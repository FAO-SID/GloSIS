# -------------------------------
# 0. Load libraries and clean workspace
# -------------------------------
library(terra)       # Spatial raster processing
library(tidyverse)   # Data manipulation
library(sf)          # GDAL integration

rm(list = ls())  # Clear environment

# -------------------------------
# 1. Define constants and working directory
# -------------------------------
Country_ISO_code <- "BTN"  # Country code
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))  # Set working dir to script path

# Define directories
input_dir <- "BT/input"
tmp_dir <- "BT/tmp"
output_dir <- "BT/output"

# -------------------------------
# 2. List input files
# -------------------------------
ensure_dir <- function(dir) {
  if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)
}

files <- list.files(
  path = input_dir,
  pattern = "\\.(tif|tiff)$",
  recursive = TRUE,
  full.names = FALSE
)

# Write basic file listing for inspection
str_split(files, "/", simplify = TRUE) %>%
  as_tibble() %>%
  write.csv("list_raster_files.csv", row.names = FALSE)

files <- list.files(input_dir, pattern = "\\.(tif|tiff)$", recursive = TRUE, full.names = TRUE)

# -------------------------------
# 3. Read lookup tables and join
# -------------------------------
raster_dc <- read_csv("raster_datacube - BTN.csv")
glosis_datacube <- read_csv("raster_datacube - glosis_datacube_names.csv")
dat <- left_join(raster_dc, glosis_datacube)

# -------------------------------
# 4. Generate standardized filenames
# -------------------------------
dat <- dat %>%
  mutate(standard_name = paste0(Country_ISO_code, "-", initiative, "-", soil_property_code, "-", year, "-", top, "-", bottom, ".tif"))

# -------------------------------
# 5. Read rasters and save with new names
# -------------------------------
for (i in seq_len(nrow(dat))) {
  r <- rast(files[i])
  file_out <- file.path(tmp_dir, dat$standard_name[i])
  writeRaster(r, file_out, overwrite = TRUE)
}

# -------------------------------
# 6. Check raster stats & NoData
# -------------------------------
tif_files <- list.files(tmp_dir, pattern = "\\.(tif|tiff)$", full.names = TRUE)

extract_nodata_value <- function(info_lines) {
  nodata_line <- grep("NoData Value=", info_lines, value = TRUE)
  if (length(nodata_line) == 0) return(NA_real_)
  value <- sub(".*NoData Value=([-0-9.eE+]+).*", "\\1", nodata_line[1])
  as.numeric(value)
}

stats_list <- list()
for (file in tif_files) {
  r <- rast(file)
  stats <- global(r, fun = c("min", "max", "mean", "sd"), na.rm = TRUE)
  info_lines <- terra::describe(file)
  nodata_str <- extract_nodata_value(info_lines)
  
  stats_list[[file]] <- data.frame(
    File = file,
    Minimum = stats["min", 1],
    Maximum = stats["max", 1],
    Mean = stats["mean", 1],
    StdDev = stats["sd", 1],
    NoData = nodata_str
  )
}

stats_df <- bind_rows(stats_list)
stats_df$UpdatedNA <- NA_real_

# -------------------------------
# 7. Reclassify NoData values
# -------------------------------
stats_df <- stats_df %>%
  mutate(
    UpdatedNA = case_when(
      (Minimum %in% c(-99, -999, -9999)) & is.na(NoData) ~ -9999,
      Minimum == -3.4e+38 & NoData == -3.4e+38 ~ -9999,
      Minimum < -9999 ~ -3.4e+38,
      Minimum > -9999 & NoData == -3.4e+38 ~ -9999,
      Minimum < -9999 & NoData == -3.4e+38 ~ -3.4e+38,
      Minimum > -9999 & is.na(NoData) ~ -9999,
      TRUE ~ UpdatedNA
    )
  )

assign_nodata <- function(filename, nodata) {
  r <- rast(filename)
  NAflag(r) <- nodata
  tmpfile <- tempfile(fileext = ".tif")
  writeRaster(r, tmpfile, overwrite = TRUE, NAflag = nodata)
  file.rename(tmpfile, filename)
}

nodata_ops <- stats_df %>%
  filter(!is.na(UpdatedNA)) %>%
  group_by(UpdatedNA) %>%
  summarise(files = list(File), .groups = "drop") %>%
  mutate(group = purrr::map2(files, UpdatedNA, ~ list(files = .x, value = .y))) %>%
  pull(group)

for (group in nodata_ops) {
  for (file in group$files) {
    assign_nodata(file, group$value)
  }
}

# -------------------------------
# 8. Reproject rasters to EPSG:4326
# -------------------------------
epsg <- "EPSG:4326"

for (file in tif_files) {
  r <- rast(file)
  r_proj <- project(r, epsg, method = "near")
  tmpfile <- tempfile(fileext = ".tif")
  writeRaster(r_proj, tmpfile, overwrite = TRUE)
  file.rename(tmpfile, file)
}

# -------------------------------
# 9. Convert aligned rasters to COG
# -------------------------------
get_extent_info <- function(file) {
  r <- rast(file)
  band_info <- describe(r)[[1]]
  e <- ext(r)
  res_vals <- res(r)
  nodata <- if ("Nodata" %in% names(band_info)) as.numeric(band_info["Nodata"]) else NA_real_
  
  tibble(
    File = basename(file),
    XMIN = e[1], YMIN = e[3],
    XMAX = e[2], YMAX = e[4],
    PIXEL_SIZE = mean(res_vals),
    NODATA = nodata
  )
}

extent_table <- bind_rows(lapply(tif_files, get_extent_info))

global_extent <- extent_table %>%
  summarise(XMIN = max(XMIN), YMIN = max(YMIN), XMAX = min(XMAX), YMAX = min(YMAX))

xmin <- global_extent$XMIN; xmax <- global_extent$XMAX
ymin <- global_extent$YMIN; ymax <- global_extent$YMAX

target_extent <- ext(xmin, xmax, ymin, ymax)
target_crs <- "EPSG:4326"

for (file in tif_files) {
  base <- basename(file)
  output_tmp_file <- file.path(tmp_dir, paste0("tmp_", base))
  output_file <- file.path(output_dir, base)
  
  if (str_detect(base, "GSAS|GSOC")) {
    res_target <- extent_table$PIXEL_SIZE[first(grep("GSAS|GSOC", extent_table$File))]
  } else {
    res_target <- extent_table$PIXEL_SIZE[first(grep("GSNM", extent_table$File))]
  }
  
  r <- rast(file)
  template <- rast(ext = target_extent, resolution = res_target, crs = target_crs)
  aligned <- project(r, template, method = "near")
  writeRaster(aligned, output_tmp_file, overwrite = TRUE)
  
  gdal_utils("addo", source = output_tmp_file, options = c("-r", "nearest", "-q"))
  gdal_utils("translate", source = output_tmp_file, destination = output_file,
             options = c("-of", "COG", "-co", "COMPRESS=DEFLATE", "-co", "PREDICTOR=2", "-q"))
  file.remove(output_tmp_file)
}

# -------------------------------
# 10. Create VRTs
# -------------------------------
create_vrt <- function(pattern, output_name) {
  matching <- list.files(output_dir, pattern = pattern, full.names = TRUE)
  list_file <- tempfile(fileext = ".txt")
  writeLines(matching, list_file)
  gdal_utils("buildvrt", source = list_file,
             destination = file.path(output_dir, paste0(output_name, ".vrt")),
             options = c("-separate", "-q", "-input_file_list"))
  file.remove(list_file)
}

create_vrt("GSAS.*\\.tif$", "PH-GSAS")
create_vrt("GSOC.*\\.tif$", "PH-GSOC")
create_vrt("GSNM.*\\.tif$", "PH-GSNM")
