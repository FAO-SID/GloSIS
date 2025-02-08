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
gdal_calc.py --quiet -A PH-GSAS-EC-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=0.23120065033435822) + ($NODATA)*(A==0.23120065033435822)" --NoDataValue=$NODATA && mv temp.tif PH-GSAS-EC-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSAS-EC-2024-30-100.tif --outfile=temp.tif --calc="A*(A!=0.1270795613527298) + ($NODATA)*(A==0.1270795613527298)" --NoDataValue=$NODATA && mv temp.tif PH-GSAS-EC-2024-30-100.tif
gdal_calc.py --quiet -A PH-GSAS-ESP-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=3.2343051433563232) + ($NODATA)*(A==3.2343051433563232)" --NoDataValue=$NODATA && mv temp.tif PH-GSAS-ESP-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSAS-ESP-2024-30-100.tif --outfile=temp.tif --calc="A*(A!=6.29727840423584) + ($NODATA)*(A==6.29727840423584)" --NoDataValue=$NODATA && mv temp.tif PH-GSAS-ESP-2024-30-100.tif
gdal_calc.py --quiet -A PH-GSAS-PH-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=6.248271942138672) + ($NODATA)*(A==6.248271942138672)" --NoDataValue=$NODATA && mv temp.tif PH-GSAS-PH-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSAS-PH-2024-30-100.tif --outfile=temp.tif --calc="A*(A!=6.0150837898254395) + ($NODATA)*(A==6.0150837898254395)" --NoDataValue=$NODATA && mv temp.tif PH-GSAS-PH-2024-30-100.tif
gdal_calc.py --quiet -A PH-GSAS-SALT-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=1) + ($NODATA)*(A==1)" --NoDataValue=$NODATA && mv temp.tif PH-GSAS-SALT-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSAS-SALT-2024-30-100.tif --outfile=temp.tif --calc="A*(A!=2) + ($NODATA)*(A==2)" --NoDataValue=$NODATA && mv temp.tif PH-GSAS-SALT-2024-30-100.tif

# Rewrite pixels with -99999 to -1
gdal_calc.py --quiet -A PH-GSOCS-ADBAU-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-ADBAU-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSOCS-ADSSM1-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-ADSSM1-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSOCS-ADSSM2-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-ADSSM2-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSOCS-ADSSM3-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-ADSSM3-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSOCS-ASRBAU-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-ASRBAU-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSOCS-ASRSSM1-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-ASRSSM1-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSOCS-ASRSSM2-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-ASRSSM2-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSOCS-ASRSSM3-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-ASRSSM3-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSOCS-SSMU-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-SSMU-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSOCS-SOCBAU-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-SOCBAU-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSOCS-SOCSSM1-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-SOCSSM1-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSOCS-SOCSSM2-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-SOCSSM2-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSOCS-SOCSSM3-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-SOCSSM3-2024-0-30.tif
gdal_calc.py --quiet -A PH-SOILP-BD-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-SOILP-BD-2024-0-30.tif 
gdal_calc.py --quiet -A PH-SOILP-BD-2024-30-60.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-SOILP-BD-2024-30-60.tif 
gdal_calc.py --quiet -A PH-SOILP-CEC-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-SOILP-CEC-2024-0-30.tif 
gdal_calc.py --quiet -A PH-SOILP-CEC-2024-30-60.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-SOILP-CEC-2024-30-60.tif 
gdal_calc.py --quiet -A PH-SOILP-CLAY-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-SOILP-CLAY-2024-0-30.tif 
gdal_calc.py --quiet -A PH-SOILP-CLAY-2024-30-60.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-SOILP-CLAY-2024-30-60.tif 
gdal_calc.py --quiet -A PH-SOILP-K-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-SOILP-K-2024-0-30.tif 
gdal_calc.py --quiet -A PH-SOILP-K-2024-30-60.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-SOILP-K-2024-30-60.tif 
gdal_calc.py --quiet -A PH-SOILP-OC-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-SOILP-OC-2024-0-30.tif 
gdal_calc.py --quiet -A PH-SOILP-OC-2024-30-60.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-SOILP-OC-2024-30-60.tif 
gdal_calc.py --quiet -A PH-SOILP-P-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-SOILP-P-2024-0-30.tif 
gdal_calc.py --quiet -A PH-SOILP-P-2024-30-60.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-SOILP-P-2024-30-60.tif 
gdal_calc.py --quiet -A PH-SOILP-PH-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-SOILP-PH-2024-0-30.tif 
gdal_calc.py --quiet -A PH-SOILP-PH-2024-30-60.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-SOILP-PH-2024-30-60.tif 
gdal_calc.py --quiet -A PH-SOILP-SAND-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-SOILP-SAND-2024-0-30.tif 
gdal_calc.py --quiet -A PH-SOILP-SAND-2024-30-60.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-SOILP-SAND-2024-30-60.tif 
gdal_calc.py --quiet -A PH-SOILP-SILT-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-SOILP-SILT-2024-0-30.tif 
gdal_calc.py --quiet -A PH-SOILP-SILT-2024-30-60.tif --outfile=temp.tif --calc="A*(A!=-99999) + ($NODATA)*(A==-99999)" --NoDataValue=$NODATA && mv temp.tif PH-SOILP-SILT-2024-30-60.tif 

# NoData -3.4e+38
gdal_calc.py --quiet -A PH-GSOCS-RDSSM1-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-339999995214436424907732413799364296704.000) + ($NODATA)*(A==-339999995214436424907732413799364296704.000)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-RDSSM1-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSOCS-RDSSM2-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-339999995214436424907732413799364296704.000) + ($NODATA)*(A==-339999995214436424907732413799364296704.000)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-RDSSM2-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSOCS-RDSSM3-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-339999995214436424907732413799364296704.000) + ($NODATA)*(A==-339999995214436424907732413799364296704.000)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-RDSSM3-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSOCS-RSRSSM1-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-339999995214436424907732413799364296704.000) + ($NODATA)*(A==-339999995214436424907732413799364296704.000)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-RSRSSM1-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSOCS-RSRSSM1U-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-339999995214436424907732413799364296704.000) + ($NODATA)*(A==-339999995214436424907732413799364296704.000)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-RSRSSM1U-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSOCS-RSRSSM2-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-339999995214436424907732413799364296704.000) + ($NODATA)*(A==-339999995214436424907732413799364296704.000)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-RSRSSM2-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSOCS-RSRSSM2U-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-339999995214436424907732413799364296704.000) + ($NODATA)*(A==-339999995214436424907732413799364296704.000)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-RSRSSM2U-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSOCS-RSRSSM3-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-339999995214436424907732413799364296704.000) + ($NODATA)*(A==-339999995214436424907732413799364296704.000)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-RSRSSM3-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSOCS-RSRSSM3U-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-339999995214436424907732413799364296704.000) + ($NODATA)*(A==-339999995214436424907732413799364296704.000)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-RSRSSM3U-2024-0-30.tif
gdal_calc.py --quiet -A PH-GSOCS-T0-2024-0-30.tif --outfile=temp.tif --calc="A*(A!=-339999995214436424907732413799364296704.000) + ($NODATA)*(A==-339999995214436424907732413799364296704.000)" --NoDataValue=$NODATA && mv temp.tif PH-GSOCS-T0-2024-0-30.tif
