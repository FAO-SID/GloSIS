#!/bin/bash

###############################################
#                NoData & EPSG                #
###############################################

# Variables
INPUT_DIR="/home/carva014/Downloads/FAO/SIS/PH/TMP"                    # << EDIT THIS LINE!
NODATA=-1
cd $INPUT_DIR

# Dealing with other Nodata values
echo
echo "Assigning NoData to $NODATA ..."

# NoData NULL
gdal_calc.py --quiet -A PH-GSAS-EC-2020-0-30.tif --outfile=temp.tif --calc="A*(A!=0.23120065033435822) + ($NODATA)*(A==0.23120065033435822)" --NoDataValue=$NODATA && mv temp.tif PH-GSAS-EC-2020-0-30.tif
gdal_calc.py --quiet -A PH-GSAS-EC-2020-30-100.tif --outfile=temp.tif --calc="A*(A!=0.1270795613527298) + ($NODATA)*(A==0.1270795613527298)" --NoDataValue=$NODATA && mv temp.tif PH-GSAS-EC-2020-30-100.tif
gdal_calc.py --quiet -A PH-GSAS-ESP-2020-0-30.tif --outfile=temp.tif --calc="A*(A!=3.2343051433563232) + ($NODATA)*(A==3.2343051433563232)" --NoDataValue=$NODATA && mv temp.tif PH-GSAS-ESP-2020-0-30.tif
gdal_calc.py --quiet -A PH-GSAS-ESP-2020-30-100.tif --outfile=temp.tif --calc="A*(A!=6.29727840423584) + ($NODATA)*(A==6.29727840423584)" --NoDataValue=$NODATA && mv temp.tif PH-GSAS-ESP-2020-30-100.tif
gdal_calc.py --quiet -A PH-GSAS-PH-2020-0-30.tif --outfile=temp.tif --calc="A*(A!=6.248271942138672) + ($NODATA)*(A==6.248271942138672)" --NoDataValue=$NODATA && mv temp.tif PH-GSAS-PH-2020-0-30.tif
gdal_calc.py --quiet -A PH-GSAS-PH-2020-30-100.tif --outfile=temp.tif --calc="A*(A!=6.0150837898254395) + ($NODATA)*(A==6.0150837898254395)" --NoDataValue=$NODATA && mv temp.tif PH-GSAS-PH-2020-30-100.tif
# gdal_calc.py --quiet -A PH-GSAS-SALT-2020-0-30.tif --outfile=temp.tif --calc="A*(A!=1) + ($NODATA)*(A==1)" --NoDataValue=$NODATA && mv temp.tif PH-GSAS-SALT-2020-0-30.tif
# gdal_calc.py --quiet -A PH-GSAS-SALT-2020-30-100.tif --outfile=temp.tif --calc="A*(A!=2) + ($NODATA)*(A==2)" --NoDataValue=$NODATA && mv temp.tif PH-GSAS-SALT-2020-30-100.tif

# Rewrite pixels with -99999 to -1
gdal_calc.py --quiet -A PH-GSOC-ADBAU-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-ADBAU-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSOC-ADSSM1-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-ADSSM1-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSOC-ADSSM2-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-ADSSM2-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSOC-ADSSM3-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-ADSSM3-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSOC-ASRBAU-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-ASRBAU-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSOC-ASRSSM1-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-ASRSSM1-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSOC-ASRSSM2-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-ASRSSM2-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSOC-ASRSSM3-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-ASRSSM3-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSOC-SSMU-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-SSMU-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSOC-SOCBAU-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-SOCBAU-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSOC-SOCSSM1-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-SOCSSM1-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSOC-SOCSSM2-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-SOCSSM2-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSOC-SOCSSM3-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-SOCSSM3-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSNM-BD-2023-0-30.tif --outfile=temp.tif --calc="A*(A!=-9999) + ($NODATA)*(A==-9999)" --NoDataValue=$NODATA && mv temp.tif PH-GSNM-BD-2023-0-30.tif 
gdal_calc.py --quiet -A PH-GSNM-BD-2023-30-60.tif --outfile=temp.tif --calc="A*(A!=-9999) + ($NODATA)*(A==-9999)" --NoDataValue=$NODATA && mv temp.tif PH-GSNM-BD-2023-30-60.tif 
gdal_calc.py --quiet -A PH-GSNM-CEC-2023-0-30.tif --outfile=temp.tif --calc="A*(A!=-9999) + ($NODATA)*(A==-9999)" --NoDataValue=$NODATA && mv temp.tif PH-GSNM-CEC-2023-0-30.tif 
gdal_calc.py --quiet -A PH-GSNM-CEC-2023-30-60.tif --outfile=temp.tif --calc="A*(A!=-9999) + ($NODATA)*(A==-9999)" --NoDataValue=$NODATA && mv temp.tif PH-GSNM-CEC-2023-30-60.tif 
gdal_calc.py --quiet -A PH-GSNM-CLAY-2023-0-30.tif --outfile=temp.tif --calc="A*(A!=-9999) + ($NODATA)*(A==-9999)" --NoDataValue=$NODATA && mv temp.tif PH-GSNM-CLAY-2023-0-30.tif 
gdal_calc.py --quiet -A PH-GSNM-CLAY-2023-30-60.tif --outfile=temp.tif --calc="A*(A!=-9999) + ($NODATA)*(A==-9999)" --NoDataValue=$NODATA && mv temp.tif PH-GSNM-CLAY-2023-30-60.tif 
gdal_calc.py --quiet -A PH-GSNM-K-2023-0-30.tif --outfile=temp.tif --calc="A*(A!=-9999) + ($NODATA)*(A==-9999)" --NoDataValue=$NODATA && mv temp.tif PH-GSNM-K-2023-0-30.tif 
gdal_calc.py --quiet -A PH-GSNM-K-2023-30-60.tif --outfile=temp.tif --calc="A*(A!=-9999) + ($NODATA)*(A==-9999)" --NoDataValue=$NODATA && mv temp.tif PH-GSNM-K-2023-30-60.tif 
gdal_calc.py --quiet -A PH-GSNM-OC-2023-0-30.tif --outfile=temp.tif --calc="A*(A!=-9999) + ($NODATA)*(A==-9999)" --NoDataValue=$NODATA && mv temp.tif PH-GSNM-OC-2023-0-30.tif 
gdal_calc.py --quiet -A PH-GSNM-OC-2023-30-60.tif --outfile=temp.tif --calc="A*(A!=-9999) + ($NODATA)*(A==-9999)" --NoDataValue=$NODATA && mv temp.tif PH-GSNM-OC-2023-30-60.tif 
gdal_calc.py --quiet -A PH-GSNM-P-2023-0-30.tif --outfile=temp.tif --calc="A*(A!=-9999) + ($NODATA)*(A==-9999)" --NoDataValue=$NODATA && mv temp.tif PH-GSNM-P-2023-0-30.tif 
gdal_calc.py --quiet -A PH-GSNM-P-2023-30-60.tif --outfile=temp.tif --calc="A*(A!=-9999) + ($NODATA)*(A==-9999)" --NoDataValue=$NODATA && mv temp.tif PH-GSNM-P-2023-30-60.tif 
gdal_calc.py --quiet -A PH-GSNM-PH-2023-0-30.tif --outfile=temp.tif --calc="A*(A!=-9999) + ($NODATA)*(A==-9999)" --NoDataValue=$NODATA && mv temp.tif PH-GSNM-PH-2023-0-30.tif 
gdal_calc.py --quiet -A PH-GSNM-PH-2023-30-60.tif --outfile=temp.tif --calc="A*(A!=-9999) + ($NODATA)*(A==-9999)" --NoDataValue=$NODATA && mv temp.tif PH-GSNM-PH-2023-30-60.tif 
gdal_calc.py --quiet -A PH-GSNM-SAND-2023-0-30.tif --outfile=temp.tif --calc="A*(A!=-9999) + ($NODATA)*(A==-9999)" --NoDataValue=$NODATA && mv temp.tif PH-GSNM-SAND-2023-0-30.tif 
gdal_calc.py --quiet -A PH-GSNM-SAND-2023-30-60.tif --outfile=temp.tif --calc="A*(A!=-9999) + ($NODATA)*(A==-9999)" --NoDataValue=$NODATA && mv temp.tif PH-GSNM-SAND-2023-30-60.tif 
gdal_calc.py --quiet -A PH-GSNM-SILT-2023-0-30.tif --outfile=temp.tif --calc="A*(A!=-9999) + ($NODATA)*(A==-9999)" --NoDataValue=$NODATA && mv temp.tif PH-GSNM-SILT-2023-0-30.tif 
gdal_calc.py --quiet -A PH-GSNM-SILT-2023-30-60.tif --outfile=temp.tif --calc="A*(A!=-9999) + ($NODATA)*(A==-9999)" --NoDataValue=$NODATA && mv temp.tif PH-GSNM-SILT-2023-30-60.tif 

# NoData -3.4e+38
gdal_calc.py --quiet -A PH-GSOC-RDSSM1-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-339999995214436424907732413799364296704.000) + ($NODATA)*(A==-339999995214436424907732413799364296704.000)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-RDSSM1-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSOC-RDSSM2-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-339999995214436424907732413799364296704.000) + ($NODATA)*(A==-339999995214436424907732413799364296704.000)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-RDSSM2-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSOC-RDSSM3-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-339999995214436424907732413799364296704.000) + ($NODATA)*(A==-339999995214436424907732413799364296704.000)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-RDSSM3-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSOC-RSRSSM1-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-339999995214436424907732413799364296704.000) + ($NODATA)*(A==-339999995214436424907732413799364296704.000)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-RSRSSM1-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSOC-RSRSSM1U-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-339999995214436424907732413799364296704.000) + ($NODATA)*(A==-339999995214436424907732413799364296704.000)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-RSRSSM1U-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSOC-RSRSSM2-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-339999995214436424907732413799364296704.000) + ($NODATA)*(A==-339999995214436424907732413799364296704.000)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-RSRSSM2-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSOC-RSRSSM2U-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-339999995214436424907732413799364296704.000) + ($NODATA)*(A==-339999995214436424907732413799364296704.000)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-RSRSSM2U-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSOC-RSRSSM3-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-339999995214436424907732413799364296704.000) + ($NODATA)*(A==-339999995214436424907732413799364296704.000)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-RSRSSM3-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSOC-RSRSSM3U-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-339999995214436424907732413799364296704.000) + ($NODATA)*(A==-339999995214436424907732413799364296704.000)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-RSRSSM3U-2021-0-30.tif
gdal_calc.py --quiet -A PH-GSOC-T0-2021-0-30.tif --outfile=temp.tif --calc="A*(A!=-339999995214436424907732413799364296704.000) + ($NODATA)*(A==-339999995214436424907732413799364296704.000)" --NoDataValue=$NODATA && mv temp.tif PH-GSOC-T0-2021-0-30.tif
