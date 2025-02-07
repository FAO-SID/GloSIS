#!/bin/bash

###############################################
#       Cloud Optimized GeoTIFF - COG         #
###############################################

# Input and output directories
INPUT_DIR="/home/carva014/Downloads/FAO/SIS/PH/TMP"                    # << EDIT THIS LINE!
OUTPUT_DIR="/home/carva014/Downloads/FAO/SIS/PH/Processed"             # << EDIT THIS LINE!
cd $INPUT_DIR

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Initialize variables for overall extent
XMIN=-inf
YMIN=-inf
XMAX=inf
YMAX=inf

# Loop through all GeoTIFFs to compute overall extent
echo "########################"
echo "#        Before        #"
echo "########################"
printf "%-15s %-15s %-15s %-15s %-20s %-15s %s\n" "XMIN" "YMIN" "XMAX" "YMAX" "PIXEL_SIZE" "NODATA" "File"

for FILE in *.tif; do
    BASENAME=$(basename "$FILE")

    # Extract current extent values
    CURRENT_XMIN=$(gdalinfo "$FILE" | grep "Upper Left"  | awk -F'[(),]' '{print $2}')
    CURRENT_YMIN=$(gdalinfo "$FILE" | grep "Lower Right" | awk -F'[(),]' '{print $3}')
    CURRENT_XMAX=$(gdalinfo "$FILE" | grep "Lower Right" | awk -F'[(),]' '{print $2}')
    CURRENT_YMAX=$(gdalinfo "$FILE" | grep "Upper Left"  | awk -F'[(),]' '{print $3}')
    CURRENT_PIXEL_SIZE=$(gdalinfo "$FILE" | grep "Pixel Size" | awk -F'[(),]' '{print $2}')
    CURRENT_NODATA=$(gdalinfo "$FILE" | grep "NoData Value=" | awk -F'NoData Value=' '{print $2}')
    printf "%-15s %-15s %-15s %-15s %-15s %-15s %s\n" "$CURRENT_XMIN" "$CURRENT_YMIN" "$CURRENT_XMAX" "$CURRENT_YMAX" "$CURRENT_PIXEL_SIZE" "$CURRENT_NODATA" "$BASENAME"

    # Update overall extent
    XMIN=$(echo "$CURRENT_XMIN $XMIN" | awk '{print ($1 < $2) ? $1 : $2}')
    YMIN=$(echo "$CURRENT_YMIN $YMIN" | awk '{print ($1 > $2) ? $1 : $2}')
    XMAX=$(echo "$CURRENT_XMAX $XMAX" | awk '{print ($1 < $2) ? $1 : $2}')
    YMAX=$(echo "$CURRENT_YMAX $YMAX" | awk '{print ($1 < $2) ? $1 : $2}')
done

echo
echo "Computed extent: $XMIN $YMIN $XMAX $YMAX"
echo

# Loop through all GeoTIFFs to align them and convert them into COG's
for FILE in *.tif; do
    BASENAME=$(basename "$FILE")
    OUTPUT_TMP_FILE="$OUTPUT_DIR/tmp_${BASENAME}"
    OUTPUT_FILE="$OUTPUT_DIR/$BASENAME"

    # Set resolution based on filename
    if [[ "$BASENAME" == *"SOILP"* ]]; then
        XRES=250
        YRES=250
    else
        XRES=1000
        YRES=1000
    fi

    # Align GeoTIFFs
    gdalwarp -q -r near -tr $XRES $YRES -te $XMIN $YMIN $XMAX $YMAX "$FILE" "$OUTPUT_TMP_FILE"

    # Overviews
    gdaladdo -q -r nearest "$OUTPUT_TMP_FILE"

    # Tilling and indexing
    gdal_translate -q -of COG -co COMPRESS=DEFLATE -co PREDICTOR=2 "$OUTPUT_TMP_FILE" "$OUTPUT_FILE"

    # Remove tmp files
    rm "$OUTPUT_TMP_FILE"
done

echo "########################"
echo "#        After         #"
echo "########################"
printf "%-15s %-15s %-15s %-15s %-20s %-15s %s\n" "XMIN" "YMIN" "XMAX" "YMAX" "PIXEL_SIZE" "NODATA" "File"

# Loop through final COGs
for FILE in "$OUTPUT_DIR"/*.tif; do
    BASENAME=$(basename "$FILE")
    CURRENT_XMIN=$(gdalinfo "$FILE" | grep "Upper Left"  | awk -F'[(),]' '{print $2}')
    CURRENT_YMIN=$(gdalinfo "$FILE" | grep "Lower Right" | awk -F'[(),]' '{print $3}')
    CURRENT_XMAX=$(gdalinfo "$FILE" | grep "Lower Right" | awk -F'[(),]' '{print $2}')
    CURRENT_YMAX=$(gdalinfo "$FILE" | grep "Upper Left"  | awk -F'[(),]' '{print $3}')
    CURRENT_PIXEL_SIZE=$(gdalinfo "$FILE" | grep "Pixel Size" | awk -F'[(),]' '{print $2}')
    CURRENT_NODATA=$(gdalinfo "$FILE" | grep "NoData Value=" | awk -F'NoData Value=' '{print $2}')
    printf "%-15s %-15s %-15s %-15s %-15s %-15s %s\n" "$CURRENT_XMIN" "$CURRENT_YMIN" "$CURRENT_XMAX" "$CURRENT_YMAX" "$CURRENT_PIXEL_SIZE" "$CURRENT_NODATA" "$BASENAME"
done
