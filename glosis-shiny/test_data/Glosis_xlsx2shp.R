# Script to create shapefiles from Glosis XLSX template data
# Last modified on 25th August 2025

## 1 - Set environment and load libraries ===========================
setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) # Set working directory to source file location
getwd()

# List of packages
packages <- c("dplyr","sf","janitor", "readxl", "tools")

# Load packages
invisible(lapply(packages, library, character.only = TRUE))
rm(packages)

# Read all available xlsx templates in the directory and store in the object "files", adjust the path to your xlsx templates if necessary.
files <- list.files(pattern = "xlsx$")
files # Shows the available files
# Define your target xlsx based on the list in files
myfile <- files[1] # Selects first xlsx in the list, change it to 2, 3, etc if you want to use another target xlsx template in this list

plot <- read_excel(myfile, sheet="Plot Data", skip = 1)
profile <- read_excel(myfile, sheet="Profile Data", skip = 1)
element <- read_excel(myfile, sheet="Element Data", skip = 1)
specimen <- read_excel(myfile, sheet="Specimen Data", skip = 0)
metadata <- read_excel(myfile, sheet="Metadata", skip = 1)


# Join them by profile_code
df <- plot %>%
  full_join(profile,  by = "profile_code") %>%
  full_join(element,  by = "profile_code") %>%
  full_join(specimen, by = "profile_code")

# Add metadata
df <- df %>%
  full_join(metadata,  by = "plot_code")


# 1) Keep valid coords and ensure numeric
df_pts <- df %>%
  filter(!is.na(longitude), !is.na(latitude)) %>%
  mutate(
    longitude = as.numeric(longitude),
    latitude  = as.numeric(latitude)
  )

# Optional: one point per profile_code (comment out if you want all)
#df_pts <- df_pts %>% distinct(profile_code, .keep_all = TRUE)

# 2) Convert to sf (WGS84 / EPSG:4326). Keep lon/lat columns in the table.
pts_sf <- st_as_sf(df_pts, coords = c("longitude", "latitude"),
                   crs = 4326, remove = FALSE)

# 3) Coerce tricky types for Shapefile
pts_sf_shp <- pts_sf %>%
  mutate(
    across(where(is.logical), as.integer),
    across(where(is.factor), as.character)
  )

# 4) Make safe, short, unique field names (<=10 chars)
nm <- janitor::make_clean_names(names(pts_sf_shp))       # snake_case, ascii
nm <- gsub("[^A-Za-z0-9_]", "_", nm)                     # only safe chars
nm <- substr(nm, 1, 10)                                  # <=10 chars

# ensure uniqueness after truncation (appends 2-digit suffix)
dup <- duplicated(nm)
if (any(dup)) {
  counts <- ave(seq_along(nm), nm, FUN = seq_along)
  nm[dup] <- paste0(substr(nm[dup], 1, 8), sprintf("%02d", counts[dup]))
}
names(pts_sf_shp) <- nm

# 5) (Optional) keep a lean set of fields to avoid bloated DBF
# pts_sf_shp <- dplyr::select(pts_sf_shp, profile_code, longitude, latitude, geometry)

# 6) Remove any previous sidecar files and write
myfile <- tools::file_path_sans_ext(myfile)
# delete any shapefile sidecar files with that base name
unlink( list.files(pattern = paste0("^", myfile, "\\.(shp|shx|dbf|prj|cpg)$")), force = TRUE)

# 7) Save to shapefile in the subfolder "xlsx2shape"
output_dir <-"xlsx2shape/"
# check if output directory exists if not create it
if (!file.exists(output_dir)){
  # create a new sub directory inside the main path
  dir.create(output_dir)
}
st_write(pts_sf_shp, paste0("xlsx2shapes/",myfile, ".shp"), delete_dsn = TRUE)
