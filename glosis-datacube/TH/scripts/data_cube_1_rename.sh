#!/bin/bash

###############################################
#                    Rename                   #
###############################################

echo

COUNTRY=TH
PROJ=GSAS
YEAR=2020
INPUT_DIR="/home/carva014/Downloads/FAO/AFACI/$COUNTRY/input/$PROJ"                   # << EDIT THIS LINE!
OUTPUT_DIR="/home/carva014/Downloads/FAO/AFACI/$COUNTRY/tmp"                          # << EDIT THIS LINE!

mkdir -p "$OUTPUT_DIR"

# Non existing NoData parameter, add now or fail after.
gdal_edit.py -a_nodata nan $INPUT_DIR/EC0_30_uncertain-Naruekamon_Janjirawuttikul.tif
gdal_edit.py -a_nodata nan $INPUT_DIR/EC30_100_uncertain-Naruekamon_Janjirawuttikul.tif
gdal_edit.py -a_nodata nan $INPUT_DIR/ESP0_30_uncertain-Naruekamon_Janjirawuttikul.tif
gdal_edit.py -a_nodata nan $INPUT_DIR/ESP30_100_uncertain-Naruekamon_Janjirawuttikul.tif
gdal_edit.py -a_nodata nan $INPUT_DIR/pH0_30_uncertain-Naruekamon_Janjirawuttikul.tif
gdal_edit.py -a_nodata nan $INPUT_DIR/pH30_100_uncertain-Naruekamon_Janjirawuttikul.tif
gdal_edit.py -a_nodata nan $INPUT_DIR/Salt0_30cm_uncertainA-Naruekamon_Janjirawuttikul.tif
gdal_edit.py -a_nodata nan $INPUT_DIR/Salt30_100cm_uncertainA-Naruekamon_Janjirawuttikul.tif
gdal_edit.py -a_nodata nan $INPUT_DIR/Sub30_100ECse-Naruekamon_Janjirawuttikul.tif
gdal_edit.py -a_nodata nan $INPUT_DIR/Sub30_100ESP-Naruekamon_Janjirawuttikul.tif
gdal_edit.py -a_nodata nan $INPUT_DIR/Sub30_100PH-Naruekamon_Janjirawuttikul.tif
gdal_edit.py -a_nodata nan $INPUT_DIR/Sub30_100saltaffected-Naruekamon_Janjirawuttikul.tif
gdal_edit.py -a_nodata nan $INPUT_DIR/Top0_30ECse-Naruekamon_Janjirawuttikul.tif
gdal_edit.py -a_nodata nan $INPUT_DIR/Top0_30ESP-Naruekamon_Janjirawuttikul.tif
gdal_edit.py -a_nodata nan $INPUT_DIR/Top0_30PH-Naruekamon_Janjirawuttikul.tif
gdal_edit.py -a_nodata nan $INPUT_DIR/Top0_30saltaffected-Naruekamon_Janjirawuttikul.tif

cp $INPUT_DIR/EC0_30_uncertain-Naruekamon_Janjirawuttikul.tif $OUTPUT_DIR/$COUNTRY-$PROJ-ECX-$YEAR-0-30-UNCT.tif
cp $INPUT_DIR/EC30_100_uncertain-Naruekamon_Janjirawuttikul.tif $OUTPUT_DIR/$COUNTRY-$PROJ-ECX-$YEAR-30-100-UNCT.tif
cp $INPUT_DIR/ESP0_30_uncertain-Naruekamon_Janjirawuttikul.tif $OUTPUT_DIR/$COUNTRY-$PROJ-NAEXC-$YEAR-0-30-UNCT.tif
cp $INPUT_DIR/ESP30_100_uncertain-Naruekamon_Janjirawuttikul.tif $OUTPUT_DIR/$COUNTRY-$PROJ-NAEXC-$YEAR-30-100-UNCT.tif
cp $INPUT_DIR/pH0_30_uncertain-Naruekamon_Janjirawuttikul.tif $OUTPUT_DIR/$COUNTRY-$PROJ-PHX-$YEAR-0-30-UNCT.tif
cp $INPUT_DIR/pH30_100_uncertain-Naruekamon_Janjirawuttikul.tif $OUTPUT_DIR/$COUNTRY-$PROJ-PHX-$YEAR-30-100-UNCT.tif
cp $INPUT_DIR/Salt0_30cm_uncertainA-Naruekamon_Janjirawuttikul.tif $OUTPUT_DIR/$COUNTRY-$PROJ-SALT-$YEAR-0-30-UNCT.tif
cp $INPUT_DIR/Salt30_100cm_uncertainA-Naruekamon_Janjirawuttikul.tif $OUTPUT_DIR/$COUNTRY-$PROJ-SALT-$YEAR-30-100-UNCT.tif
cp $INPUT_DIR/Sub30_100ECse-Naruekamon_Janjirawuttikul.tif $OUTPUT_DIR/$COUNTRY-$PROJ-ECX-$YEAR-30-100-MEAN.tif
cp $INPUT_DIR/Sub30_100ESP-Naruekamon_Janjirawuttikul.tif $OUTPUT_DIR/$COUNTRY-$PROJ-NAEXC-$YEAR-30-100-MEAN.tif
cp $INPUT_DIR/Sub30_100PH-Naruekamon_Janjirawuttikul.tif $OUTPUT_DIR/$COUNTRY-$PROJ-PHX-$YEAR-30-100-MEAN.tif
cp $INPUT_DIR/Sub30_100saltaffected-Naruekamon_Janjirawuttikul.tif $OUTPUT_DIR/$COUNTRY-$PROJ-SALT-$YEAR-30-100-MEAN.tif
cp $INPUT_DIR/Top0_30ECse-Naruekamon_Janjirawuttikul.tif $OUTPUT_DIR/$COUNTRY-$PROJ-ECX-$YEAR-0-30-MEAN.tif
cp $INPUT_DIR/Top0_30ESP-Naruekamon_Janjirawuttikul.tif $OUTPUT_DIR/$COUNTRY-$PROJ-NAEXC-$YEAR-0-30-MEAN.tif
cp $INPUT_DIR/Top0_30PH-Naruekamon_Janjirawuttikul.tif $OUTPUT_DIR/$COUNTRY-$PROJ-PHX-$YEAR-0-30-MEAN.tif
cp $INPUT_DIR/Top0_30saltaffected-Naruekamon_Janjirawuttikul.tif $OUTPUT_DIR/$COUNTRY-$PROJ-SALT-$YEAR-0-30-MEAN.tif


PROJ=GSNM
YEAR=2025
UD="0"
LD=30
INPUT_DIR="/home/carva014/Downloads/FAO/AFACI/$COUNTRY/input/$PROJ"                   # << EDIT THIS LINE!

cp $INPUT_DIR/THA-GSNM-BKD-2024-0-30.tif $OUTPUT_DIR/$COUNTRY-$PROJ-BKD-$YEAR-$UD-$LD-MEAN.tif
cp $INPUT_DIR/THA-GSNM-BKDU-2024-0-30.tif $OUTPUT_DIR/$COUNTRY-$PROJ-BKD-$YEAR-$UD-$LD-UNCT.tif 
cp $INPUT_DIR/THA-GSNM-KEXT-2024-0-30.tif $OUTPUT_DIR/$COUNTRY-$PROJ-KEXT-$YEAR-$UD-$LD-MEAN.tif 
cp $INPUT_DIR/THA-GSNM-KEXTU-2024-0-30.tif $OUTPUT_DIR/$COUNTRY-$PROJ-KEXT-$YEAR-$UD-$LD-UNCT.tif
cp $INPUT_DIR/THA-GSNM-PEXT-2024-0-30.tif $OUTPUT_DIR/$COUNTRY-$PROJ-PEXT-$YEAR-$UD-$LD-MEAN.tif 
cp $INPUT_DIR/THA-GSNM-PEXTU-2024-0-30.tif $OUTPUT_DIR/$COUNTRY-$PROJ-PEXT-$YEAR-$UD-$LD-UNCT.tif
cp $INPUT_DIR/TH-GSNM-AKX-2025-0-30.tif $OUTPUT_DIR/$COUNTRY-$PROJ-AKX-$YEAR-$UD-$LD-MEAN.tif
cp $INPUT_DIR/TH-GSNM-AKXSD-2025-0-30.tif $OUTPUT_DIR/$COUNTRY-$PROJ-AKX-$YEAR-$UD-$LD-SDEV.tif 
cp $INPUT_DIR/TH-GSNM-APX-2025-0-30.tif $OUTPUT_DIR/$COUNTRY-$PROJ-APX-$YEAR-$UD-$LD-MEAN.tif
cp $INPUT_DIR/TH-GSNM-APXSD-2025-0-30.tif $OUTPUT_DIR/$COUNTRY-$PROJ-APX-$YEAR-$UD-$LD-SDEV.tif 
# cp $INPUT_DIR/TH-GSNM-BDX-2025-0-30.tif $OUTPUT_DIR/$COUNTRY-$PROJ-BDX-$YEAR-$UD-$LD-MEAN.tif
# cp $INPUT_DIR/TH-GSNM-BDXSD-2025-0-30.tif $OUTPUT_DIR/$COUNTRY-$PROJ-BDX-$YEAR-$UD-$LD-SDEV.tif
