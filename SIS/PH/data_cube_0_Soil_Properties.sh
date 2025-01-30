#!/bin/bash

###############################################
#                NoData & EPSG                #
###############################################

# Input, output directories and conventional NoData value
INPUT_DIR="/home/carva014/Downloads/FAO/SIS/PH/Original/Soil_Properties"                        # << EDIT THIS LINE!
OUTPUT_DIR="/home/carva014/Downloads/FAO/SIS/PH/Original/Soil_Properties_tmp"                   # << EDIT THIS LINE!
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


# Dealing with other Nodata values
echo
echo "Assigning NoData to $NODATA ..."
gdal_calc.py --quiet -A EC0_30_sd.tif --outfile=$OUTPUT_DIR/tmp_EC0_30_sd.tif --calc="A*(A!=-3.39999995214436425e+38) + -1*(A==-3.39999995214436425e+38)" --NoDataValue=-1
gdal_calc.py --quiet -A EC30_100_sd.tif --outfile=$OUTPUT_DIR/tmp_EC30_100_sd.tif --calc="A*(A!=-3.39999995214436425e+38) + -1*(A==-3.39999995214436425e+38)" --NoDataValue=-1
gdal_calc.py --quiet -A ESP0_30_sd.tif --outfile=$OUTPUT_DIR/tmp_ESP0_30_sd.tif --calc="A*(A!=-3.39999995214436425e+38) + -1*(A==-3.39999995214436425e+38)" --NoDataValue=-1
gdal_calc.py --quiet -A ESP30_100_sd.tif --outfile=$OUTPUT_DIR/tmp_ESP30_100_sd.tif --calc="A*(A!=-3.39999995214436425e+38) + -1*(A==-3.39999995214436425e+38)" --NoDataValue=-1
gdal_calc.py --quiet -A pH0_30_sd.tif --outfile=$OUTPUT_DIR/tmp_pH0_30_sd.tif --calc="A*(A!=-3.39999995214436425e+38) + -1*(A==-3.39999995214436425e+38)" --NoDataValue=-1
gdal_calc.py --quiet -A pH30_100_sd.tif --outfile=$OUTPUT_DIR/tmp_pH30_100_sd.tif --calc="A*(A!=-3.39999995214436425e+38) + -1*(A==-3.39999995214436425e+38)" --NoDataValue=-1
gdal_calc.py --quiet -A PHL_UncertaintyESPMap030.tif --outfile=$OUTPUT_DIR/tmp_PHL_UncertaintyESPMap030.tif --calc="A*(A!=-3.39999995214436425e+38) + -1*(A==-3.39999995214436425e+38)" --NoDataValue=-1
gdal_calc.py --quiet -A PHL_UncertaintyESPMap30100.tif --outfile=$OUTPUT_DIR/tmp_PHL_UncertaintyESPMap30100.tif --calc="A*(A!=-3.39999995214436425e+38) + -1*(A==-3.39999995214436425e+38)" --NoDataValue=-1
gdal_calc.py --quiet -A PHL_UncertaintyPHMap030.tif --outfile=$OUTPUT_DIR/tmp_PHL_UncertaintyPHMap030.tif --calc="A*(A!=-3.39999995214436425e+38) + -1*(A==-3.39999995214436425e+38)" --NoDataValue=-1
gdal_calc.py --quiet -A PHL_UncertaintyPHMap30100.tif --outfile=$OUTPUT_DIR/tmp_PHL_UncertaintyPHMap30100.tif --calc="A*(A!=-3.39999995214436425e+38) + -1*(A==-3.39999995214436425e+38)" --NoDataValue=-1
gdal_calc.py --quiet -A PHL_UncertaintySalinityMap030.tif --outfile=$OUTPUT_DIR/tmp_PHL_UncertaintySalinityMap030.tif --calc="A*(A!=-3.39999995214436425e+38) + -1*(A==-3.39999995214436425e+38)" --NoDataValue=-1
gdal_calc.py --quiet -A PHL_UncertaintySalinityMap30100.tif --outfile=$OUTPUT_DIR/tmp_PHL_UncertaintySalinityMap30100.tif --calc="A*(A!=-3.39999995214436425e+38) + -1*(A==-3.39999995214436425e+38)" --NoDataValue=-1
gdal_calc.py --quiet -A PHL_UncertaintySaltMap030.tif --outfile=$OUTPUT_DIR/tmp_PHL_UncertaintySaltMap030.tif --calc="A*(A!=-3.39999995214436425e+38) + -1*(A==-3.39999995214436425e+38)" --NoDataValue=-1
gdal_calc.py --quiet -A PHL_UncertaintySaltMap30100.tif --outfile=$OUTPUT_DIR/tmp_PHL_UncertaintySaltMap30100.tif --calc="A*(A!=-3.39999995214436425e+38) + -1*(A==-3.39999995214436425e+38)" --NoDataValue=-1

# PHL_ESPMap030[ESPt].tif
# PHL_ESPMap030.tif
# PHL_ESPMap30100[ESPt].tif
# PHL_ESPMap30100.tif
# PHL_pHMap030[PHt].tif
# PHL_pHMap030.tif
# PHL_pHMap30100[PHt].tif
# PHL_pHMap30100.tif
# PHL_SalinityMap030[ECte].tif
# PHL_SalinityMap030.tif
# PHL_SalinityMap30100[ECte].tif
# PHL_SalinityMap30100.tif
# PHL_SaltMap030.tif
# PHL_SaltMap30100.tif



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
