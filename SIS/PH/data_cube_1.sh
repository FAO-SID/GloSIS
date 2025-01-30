#!/bin/bash

###############################################
#                NoData & EPSG                #
###############################################

# Input, output directories and conventional NoData value
INPUT_DIR="/home/carva014/Downloads/FAO/SIS/PH/Original/GSAS"                        # << EDIT THIS LINE!
OUTPUT_DIR="/home/carva014/Downloads/FAO/SIS/PH/Original/GSAS_tmp"                   # << EDIT THIS LINE!
PROJECTION="EPSG:32651"                                                              # << EDIT THIS LINE!
NODATA=-1

# Create output directory if it doesn't exist
cd $INPUT_DIR
mkdir -p "$OUTPUT_DIR"

# Chcek NoData values before processing
echo "########################"
echo "#        Before        #"
echo "########################"
printf "%-8s %-8s %-12s %-12s %-8s %s\n" "Minimum" "Maximum" "Mean" "StdDev" "NoData" "File"
for FILE in "$INPUT_DIR"/*.tif; do
    BASENAME=$(basename "$FILE")

    # Extract NoData and stat values
    CURRENT_NODATA=$(gdalinfo "$FILE" | grep "NoData Value=" | awk -F'NoData Value=' '{print $2}')
    MIN=$(gdalinfo -stats "$FILE" | grep "Minimum=" | awk -F'Minimum=' '{print $2}' | awk -F',' '{print $1}')
    MAX=$(gdalinfo -stats "$FILE" | grep "Minimum=" | awk -F'Maximum=' '{print $2}' | awk -F',' '{print $1}')
    MEA=$(gdalinfo -stats "$FILE" | grep "Minimum=" | awk -F'Mean=' '{print $2}' | awk -F',' '{print $1}')
    STD=$(gdalinfo -stats "$FILE" | grep "Minimum=" | awk -F'StdDev=' '{print $2}' | awk -F',' '{print $1}')
    printf "%-8s %-8s %-12s %-12s %-8s %s\n" "$MIN" "$MAX" "$MEA" "$STD" "$CURRENT_NODATA" "$BASENAME"
done

# Replace -9999 values with -1 and assign -1 as NoData
echo
echo "Assigning NoData to $NODATA ..."
for FILE in "$INPUT_DIR"/*.tif; do
    BASENAME=$(basename "$FILE")
    OUTPUT_TMP_FILE="$OUTPUT_DIR/tmp_${BASENAME}"

    # Extract Mean value
    MEA=$(gdalinfo -stats "$FILE" | grep "Minimum=" | awk -F'Mean=' '{print $2}' | awk -F',' '{print $1}')

    # If Mean value = -9999.000 then reclassify to value defined in line 11 ($NODATA)
    if [ "$MEA" = -9999.000 ]; then
        gdal_calc.py --quiet -A $FILE --outfile=$OUTPUT_TMP_FILE --calc="A*(A!=-9999) + $NODATA*(A==-9999)" --NoDataValue=$NODATA

    # If not then just copy the file as it is
    else
        cp $FILE $OUTPUT_TMP_FILE
    fi
done

# Reproject
echo "Reprojecting to $PROJECTION ..."
echo
for FILE in "$OUTPUT_DIR"/*.tif; do
    BASENAME=$(basename "$FILE" | sed 's/^tmp_//') # remove tmp_ prefix
    OUTPUT_FILE="$OUTPUT_DIR/$BASENAME"
    gdalwarp -q -r near -t_srs "$PROJECTION" "$FILE" "$OUTPUT_FILE"

    # Remove tmp files
    rm "$FILE"
done

# Chcek NoData values after processing
echo "########################"
echo "#        After         #"
echo "########################"
printf "%-8s %-8s %-12s %-12s %-8s %s\n" "Minimum" "Maximum" "Mean" "StdDev" "NoData" "File"
for FILE in "$OUTPUT_DIR"/*.tif; do
    BASENAME=$(basename "$FILE")

    # Extract NoData and stat values
    CURRENT_NODATA=$(gdalinfo "$FILE" | grep "NoData Value=" | awk -F'NoData Value=' '{print $2}')
    MIN=$(gdalinfo -stats "$FILE" | grep "Minimum=" | awk -F'Minimum=' '{print $2}' | awk -F',' '{print $1}')
    MAX=$(gdalinfo -stats "$FILE" | grep "Minimum=" | awk -F'Maximum=' '{print $2}' | awk -F',' '{print $1}')
    MEA=$(gdalinfo -stats "$FILE" | grep "Minimum=" | awk -F'Mean=' '{print $2}' | awk -F',' '{print $1}')
    STD=$(gdalinfo -stats "$FILE" | grep "Minimum=" | awk -F'StdDev=' '{print $2}' | awk -F',' '{print $1}')
    printf "%-8s %-8s %-12s %-12s %-8s %s\n" "$MIN" "$MAX" "$MEA" "$STD" "$CURRENT_NODATA" "$BASENAME"
done

# Delete files ending in .aux.xml
cd "$OUTPUT_DIR"
rm *.aux.xml
cd "$INPUT_DIR"
rm *.aux.xml
