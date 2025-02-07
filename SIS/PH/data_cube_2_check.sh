#!/bin/bash

###############################################
#                NoData & EPSG                #
###############################################

# Variables
INPUT_DIR="/home/carva014/Downloads/FAO/SIS/PH/TMP"                    # << EDIT THIS LINE!
cd $INPUT_DIR

# Chcek NoData values before processing
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

rm *.tif.aux.xml

########################
#        Before        #
########################
# Minimum  Maximum  Mean         StdDev       NoData   File
# 0.008    1.215    0.228        0.051        -1       PH-GSAS-EC-2024-0-30.tif
# 0.011    2.007    0.132        0.058                 PH-GSAS-EC-2024-30-100.tif
# 0.250    24.347   3.183        0.747                 PH-GSAS-ESP-2024-0-30.tif
# 0.022    9.892    5.794        1.434                 PH-GSAS-ESP-2024-30-100.tif
# 4.446    7.825    6.169        0.229                 PH-GSAS-PH-2024-0-30.tif
# 4.508    8.343    6.005        0.189                 PH-GSAS-PH-2024-30-100.tif
# 1.000    3.000    1.001        0.029                 PH-GSAS-SALT-2024-0-30.tif
# 1.000    4.000    2.002        0.045                 PH-GSAS-SALT-2024-30-100.tif
# 0.000    7.834    0.794        0.638        -99999   PH-GSOCS-ADBAU-2024-0-30.tif
# 0.000    11.299   1.516        1.039        -99999   PH-GSOCS-ADSSM1-2024-0-30.tif
# 0.001    14.764   2.446        1.437        -99999   PH-GSOCS-ADSSM2-2024-0-30.tif
# 0.009    21.693   4.458        2.256        -99999   PH-GSOCS-ADSSM3-2024-0-30.tif
# -0.370   0.392    0.018        0.047        -99999   PH-GSOCS-ASRBAU-2024-0-30.tif
# -0.349   0.565    0.069        0.058        -99999   PH-GSOCS-ASRSSM1-2024-0-30.tif
# -0.327   0.738    0.120        0.074        -99999   PH-GSOCS-ASRSSM2-2024-0-30.tif
# -0.284   1.085    0.222        0.114        -99999   PH-GSOCS-ASRSSM3-2024-0-30.tif
# 0.000    4.078    1.015        0.460        -3.4e+38 PH-GSOCS-RDSSM1-2024-0-30.tif
# 0.000    8.155    2.031        0.919        -3.4e+38 PH-GSOCS-RDSSM2-2024-0-30.tif
# 0.000    16.310   4.062        1.839        -3.4e+38 PH-GSOCS-RDSSM3-2024-0-30.tif
# 0.000    0.204    0.051        0.023        -3.4e+38 PH-GSOCS-RSRSSM1-2024-0-30.tif
# 4.509    706.400  21.186       44.224       -3.4e+38 PH-GSOCS-RSRSSM1U-2024-0-30.tif
# 0.000    0.408    0.102        0.046        -3.4e+38 PH-GSOCS-RSRSSM2-2024-0-30.tif
# 4.534    706.400  21.263       44.219       -3.4e+38 PH-GSOCS-RSRSSM2U-2024-0-30.tif
# 0.000    0.816    0.203        0.092        -3.4e+38 PH-GSOCS-RSRSSM3-2024-0-30.tif
# 4.584    706.400  21.419       44.209       -3.4e+38 PH-GSOCS-RSRSSM3U-2024-0-30.tif
# 13.254   132.551  37.194       16.595       -99999   PH-GSOCS-SOCBAU-2024-0-30.tif
# 13.649   136.305  38.214       17.040       -99999   PH-GSOCS-SOCSSM1-2024-0-30.tif
# 14.044   140.059  39.233       17.486       -99999   PH-GSOCS-SOCSSM2-2024-0-30.tif
# 14.833   147.567  41.272       18.380       -99999   PH-GSOCS-SOCSSM3-2024-0-30.tif
# 8.341    33.012   29.466       1.309        -99999   PH-GSOCS-SSMU-2024-0-30.tif
# 0.000    124.599  36.675       16.582       -3.4e+38 PH-GSOCS-T0-2024-0-30.tif
# 1.243    1.700    -9999.000    -9999.000    nan      PH-SOILP-BD-2024-0-30.tif
# 1.289    1.767    -9999.000    -9999.000    nan      PH-SOILP-BD-2024-30-60.tif
# 16.535   88.064   -9999.000    -9999.000    nan      PH-SOILP-CEC-2024-0-30.tif
# 17.005   79.165   -9999.000    -9999.000    nan      PH-SOILP-CEC-2024-30-60.tif
# 18.901   68.663   -9999.000    -9999.000    nan      PH-SOILP-CLAY-2024-0-30.tif
# 19.567   75.191   -9999.000    -9999.000    nan      PH-SOILP-CLAY-2024-30-60.tif
# 0.139    97.131   -9999.000    -9999.000    nan      PH-SOILP-K-2024-0-30.tif
# 0.095    69.215   -9999.000    -9999.000    nan      PH-SOILP-K-2024-30-60.tif
# 21.445   91.337   -9999.000    -9999.000    nan      PH-SOILP-OC-2024-0-30.tif
# 12.520   86.226   -9999.000    -9999.000    nan      PH-SOILP-OC-2024-30-60.tif
# 3.690    64.457   -9999.000    -9999.000    nan      PH-SOILP-P-2024-0-30.tif
# 1.971    60.216   -9999.000    -9999.000    nan      PH-SOILP-P-2024-30-60.tif
# 3.911    7.698    -9999.000    -9999.000    nan      PH-SOILP-PH-2024-0-30.tif
# 4.623    7.787    -9999.000    -9999.000    nan      PH-SOILP-PH-2024-30-60.tif
# 9.546    68.160   -9999.000    -9999.000    nan      PH-SOILP-SAND-2024-0-30.tif
# 8.462    71.004   -9999.000    -9999.000    nan      PH-SOILP-SAND-2024-30-60.tif
# 14.730   94.027   -9999.000    -9999.000    nan      PH-SOILP-SILT-2024-0-30.tif
# 11.511   48.613   -9999.000    -9999.000    nan      PH-SOILP-SILT-2024-30-60.tif


#####################################
#         After nodata script       #
#####################################
# Minimum  Maximum  Mean         StdDev       NoData   File
# 0.008    1.215    0.228        0.051        -1       PH-GSAS-EC-2024-0-30.tif
# 0.011    2.007    0.132        0.058        -1       PH-GSAS-EC-2024-30-100.tif
# 0.250    24.347   3.183        0.747        -1       PH-GSAS-ESP-2024-0-30.tif
# 0.022    9.892    5.794        1.434        -1       PH-GSAS-ESP-2024-30-100.tif
# 4.446    7.825    6.169        0.229        -1       PH-GSAS-PH-2024-0-30.tif
# 4.508    8.343    6.005        0.189        -1       PH-GSAS-PH-2024-30-100.tif
# 1.000    3.000    1.001        0.029        -1       PH-GSAS-SALT-2024-0-30.tif
# 1.000    4.000    2.002        0.045        -1       PH-GSAS-SALT-2024-30-100.tif
# 0.000    12.408   0.796        0.642        -1       PH-GSOCS-ADBAU-2024-0-30.tif
# 0.000    16.162   1.518        1.042        -1       PH-GSOCS-ADSSM1-2024-0-30.tif
# 0.000    19.916   2.448        1.439        -1       PH-GSOCS-ADSSM2-2024-0-30.tif
# 0.002    27.424   4.463        2.259        -1       PH-GSOCS-ADSSM3-2024-0-30.tif
# -0.436   0.620    0.018        0.047        -1       PH-GSOCS-ASRBAU-2024-0-30.tif
# -0.415   0.808    0.069        0.058        -1       PH-GSOCS-ASRSSM1-2024-0-30.tif
# -0.394   0.996    0.120        0.074        -1       PH-GSOCS-ASRSSM2-2024-0-30.tif
# -0.352   1.371    0.222        0.114        -1       PH-GSOCS-ASRSSM3-2024-0-30.tif
# 0.000    4.078    1.015        0.460        -1       PH-GSOCS-RDSSM1-2024-0-30.tif
# 0.000    8.155    2.031        0.919        -1       PH-GSOCS-RDSSM2-2024-0-30.tif
# 0.000    16.310   4.062        1.839        -1       PH-GSOCS-RDSSM3-2024-0-30.tif
# 0.000    0.204    0.051        0.023        -1       PH-GSOCS-RSRSSM1-2024-0-30.tif
# 4.509    706.400  21.186       44.223       -1       PH-GSOCS-RSRSSM1U-2024-0-30.tif
# 0.000    0.408    0.102        0.046        -1       PH-GSOCS-RSRSSM2-2024-0-30.tif
# 4.534    706.400  21.263       44.219       -1       PH-GSOCS-RSRSSM2U-2024-0-30.tif
# 0.000    0.816    0.203        0.092        -1       PH-GSOCS-RSRSSM3-2024-0-30.tif
# 4.584    706.400  21.419       44.209       -1       PH-GSOCS-RSRSSM3U-2024-0-30.tif
# 13.254   132.551  37.194       16.595       -1       PH-GSOCS-SOCBAU-2024-0-30.tif
# 13.649   136.305  38.214       17.040       -1       PH-GSOCS-SOCSSM1-2024-0-30.tif
# 14.044   140.059  39.233       17.486       -1       PH-GSOCS-SOCSSM2-2024-0-30.tif
# 14.833   147.567  41.272       18.380       -1       PH-GSOCS-SOCSSM3-2024-0-30.tif
# 8.230    33.528   29.468       1.308        -1       PH-GSOCS-SSMU-2024-0-30.tif
# 0.000    124.599  36.675       16.582       -1       PH-GSOCS-T0-2024-0-30.tif
# 1.243    1.700    1.459        0.035        -1       PH-SOILP-BD-2024-0-30.tif
# 1.289    1.767    1.581        0.027        -1       PH-SOILP-BD-2024-30-60.tif
# 16.535   88.064   35.487       4.065        -1       PH-SOILP-CEC-2024-0-30.tif
# 17.005   79.165   34.817       4.428        -1       PH-SOILP-CEC-2024-30-60.tif
# 18.901   68.663   43.566       3.676        -1       PH-SOILP-CLAY-2024-0-30.tif
# 19.567   75.191   48.453       4.652        -1       PH-SOILP-CLAY-2024-30-60.tif
# 0.139    97.131   2.868        8.028        -1       PH-SOILP-K-2024-0-30.tif
# 0.095    69.215   1.963        4.724        -1       PH-SOILP-K-2024-30-60.tif
# 21.445   91.337   55.912       7.082        -1       PH-SOILP-OC-2024-0-30.tif
# 12.520   86.226   33.266       5.503        -1       PH-SOILP-OC-2024-30-60.tif
# 3.690    64.457   13.021       4.988        -1       PH-SOILP-P-2024-0-30.tif
# 1.971    60.216   9.887        5.058        -1       PH-SOILP-P-2024-30-60.tif
# 3.911    7.698    5.692        0.284        -1       PH-SOILP-PH-2024-0-30.tif
# 4.623    7.787    5.783        0.348        -1       PH-SOILP-PH-2024-30-60.tif
# 9.546    68.160   29.720       6.440        -1       PH-SOILP-SAND-2024-0-30.tif
# 8.462    71.004   28.112       7.038        -1       PH-SOILP-SAND-2024-30-60.tif
# 14.730   94.027   29.948       2.593        -1       PH-SOILP-SILT-2024-0-30.tif
# 11.511   48.613   25.454       2.053        -1       PH-SOILP-SILT-2024-30-60.tif


#####################################
#          After epsg script        #
#####################################
# Minimum  Maximum  Mean         StdDev       NoData   File
# 0.008    1.215    0.228        0.051        -1       PH-GSAS-EC-2024-0-30.tif
# 0.011    2.007    0.132        0.058        -1       PH-GSAS-EC-2024-30-100.tif
# 0.250    24.347   3.183        0.747        -1       PH-GSAS-ESP-2024-0-30.tif
# 0.022    9.892    5.794        1.434        -1       PH-GSAS-ESP-2024-30-100.tif
# 4.446    7.825    6.169        0.229        -1       PH-GSAS-PH-2024-0-30.tif
# 4.508    8.343    6.005        0.189        -1       PH-GSAS-PH-2024-30-100.tif
# 1.000    3.000    1.001        0.029        -1       PH-GSAS-SALT-2024-0-30.tif
# 1.000    4.000    2.002        0.045        -1       PH-GSAS-SALT-2024-30-100.tif
# 0.000    12.408   0.800        0.642        -1       PH-GSOCS-ADBAU-2024-0-30.tif
# 0.000    16.162   1.523        1.043        -1       PH-GSOCS-ADSSM1-2024-0-30.tif
# 0.000    19.916   2.454        1.441        -1       PH-GSOCS-ADSSM2-2024-0-30.tif
# 0.002    27.424   4.471        2.262        -1       PH-GSOCS-ADSSM3-2024-0-30.tif
# -0.436   0.620    0.018        0.047        -1       PH-GSOCS-ASRBAU-2024-0-30.tif
# -0.415   0.808    0.069        0.058        -1       PH-GSOCS-ASRSSM1-2024-0-30.tif
# -0.394   0.996    0.121        0.075        -1       PH-GSOCS-ASRSSM2-2024-0-30.tif
# -0.352   1.371    0.223        0.114        -1       PH-GSOCS-ASRSSM3-2024-0-30.tif
# 0.000    4.078    1.016        0.460        -1       PH-GSOCS-RDSSM1-2024-0-30.tif
# 0.000    8.155    2.033        0.920        -1       PH-GSOCS-RDSSM2-2024-0-30.tif
# 0.000    16.310   4.066        1.840        -1       PH-GSOCS-RDSSM3-2024-0-30.tif
# 0.000    0.204    0.051        0.023        -1       PH-GSOCS-RSRSSM1-2024-0-30.tif
# 4.509    706.400  21.178       44.139       -1       PH-GSOCS-RSRSSM1U-2024-0-30.tif
# 0.000    0.408    0.102        0.046        -1       PH-GSOCS-RSRSSM2-2024-0-30.tif
# 4.534    706.400  21.256       44.134       -1       PH-GSOCS-RSRSSM2U-2024-0-30.tif
# 0.000    0.816    0.203        0.092        -1       PH-GSOCS-RSRSSM3-2024-0-30.tif
# 4.584    706.400  21.412       44.125       -1       PH-GSOCS-RSRSSM3U-2024-0-30.tif
# 13.254   132.551  37.202       16.604       -1       PH-GSOCS-SOCBAU-2024-0-30.tif
# 13.649   136.305  38.223       17.049       -1       PH-GSOCS-SOCSSM1-2024-0-30.tif
# 14.044   140.059  39.243       17.496       -1       PH-GSOCS-SOCSSM2-2024-0-30.tif
# 14.833   147.567  41.284       18.389       -1       PH-GSOCS-SOCSSM3-2024-0-30.tif
# 8.230    33.528   29.476       1.310        -1       PH-GSOCS-SSMU-2024-0-30.tif
# 0.000    124.599  36.681       16.588       -1       PH-GSOCS-T0-2024-0-30.tif
# 1.243    1.700    1.459        0.035        -1       PH-SOILP-BD-2024-0-30.tif
# 1.289    1.767    1.581        0.027        -1       PH-SOILP-BD-2024-30-60.tif
# 16.535   88.064   35.499       4.066        -1       PH-SOILP-CEC-2024-0-30.tif
# 17.005   79.165   34.827       4.430        -1       PH-SOILP-CEC-2024-30-60.tif
# 20.247   68.663   43.566       3.675        -1       PH-SOILP-CLAY-2024-0-30.tif
# 21.024   75.191   48.462       4.651        -1       PH-SOILP-CLAY-2024-30-60.tif
# 0.139    97.131   2.857        7.991        -1       PH-SOILP-K-2024-0-30.tif
# 0.095    69.215   1.957        4.704        -1       PH-SOILP-K-2024-30-60.tif
# 22.403   91.337   55.919       7.065        -1       PH-SOILP-OC-2024-0-30.tif
# 12.520   86.226   33.274       5.498        -1       PH-SOILP-OC-2024-30-60.tif
# 3.690    64.457   13.009       4.986        -1       PH-SOILP-P-2024-0-30.tif
# 1.971    60.216   9.877        5.055        -1       PH-SOILP-P-2024-30-60.tif
# 3.911    7.698    5.693        0.284        -1       PH-SOILP-PH-2024-0-30.tif
# 4.623    7.787    5.784        0.348        -1       PH-SOILP-PH-2024-30-60.tif
# 9.546    66.280   29.720       6.444        -1       PH-SOILP-SAND-2024-0-30.tif
# 8.797    67.452   28.100       7.036        -1       PH-SOILP-SAND-2024-30-60.tif
# 15.365   94.027   29.947       2.592        -1       PH-SOILP-SILT-2024-0-30.tif
# 11.511   48.613   25.455       2.052        -1       PH-SOILP-SILT-2024-30-60.tif


#####################################
#           After cog script        #
#####################################


