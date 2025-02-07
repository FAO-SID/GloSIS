#!/bin/bash

###############################################
#                    Rename                   #
###############################################

INPUT_DIR="/home/carva014/Downloads/FAO/SIS/PH/Original/GSAS"                          # << EDIT THIS LINE!
OUTPUT_DIR="/home/carva014/Downloads/FAO/SIS/PH/TMP"                                   # << EDIT THIS LINE!
cp $INPUT_DIR/Top0_30ECse.tif $OUTPUT_DIR/PH-GSAS-EC-2024-0-30.tif
cp $INPUT_DIR/Sub30_100ECse.tif $OUTPUT_DIR/PH-GSAS-EC-2024-30-100.tif
cp $INPUT_DIR/Top0_30ESP.tif $OUTPUT_DIR/PH-GSAS-ESP-2024-0-30.tif
cp $INPUT_DIR/Sub30_100ESP.tif $OUTPUT_DIR/PH-GSAS-ESP-2024-30-100.tif
cp $INPUT_DIR/Top0_30PH.tif $OUTPUT_DIR/PH-GSAS-PH-2024-0-30.tif
cp $INPUT_DIR/Sub30_100PH.tif $OUTPUT_DIR/PH-GSAS-PH-2024-30-100.tif
cp $INPUT_DIR/Top0_30saltaffected.tif $OUTPUT_DIR/PH-GSAS-SALT-2024-0-30.tif
cp $INPUT_DIR/Sub30_100saltaffected.tif $OUTPUT_DIR/PH-GSAS-SALT-2024-30-100.tif

INPUT_DIR="/home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS"                          # << EDIT THIS LINE!
OUTPUT_DIR="/home/carva014/Downloads/FAO/SIS/PH/TMP"                                    # << EDIT THIS LINE!
cp $INPUT_DIR/PHL_GSOCseq_AbsDiff_BAU_Map030.tif $OUTPUT_DIR/PH-GSOCS-ADBAU-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_AbsDiff_SSM1_Map030.tif $OUTPUT_DIR/PH-GSOCS-ADSSM1-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_AbsDiff_SSM2_Map030.tif $OUTPUT_DIR/PH-GSOCS-ADSSM2-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_AbsDiff_SSM3_Map030.tif $OUTPUT_DIR/PH-GSOCS-ADSSM3-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_ASR_SSM1_Map030.tif $OUTPUT_DIR/PH-GSOCS-ASRSSM1-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_ASR_SSM2_Map030.tif $OUTPUT_DIR/PH-GSOCS-ASRSSM2-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_ASR_SSM3_Map030.tif $OUTPUT_DIR/PH-GSOCS-ASRSSM3-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_ASR_BAU_Map030.tif $OUTPUT_DIR/PH-GSOCS-ASRBAU-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_finalSOC_BAU_Map030.tif $OUTPUT_DIR/PH-GSOCS-SOCBAU-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_finalSOC_SSM1_Map030.tif $OUTPUT_DIR/PH-GSOCS-SOCSSM1-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_finalSOC_SSM2_Map030.tif $OUTPUT_DIR/PH-GSOCS-SOCSSM2-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_finalSOC_SSM3_Map030.tif $OUTPUT_DIR/PH-GSOCS-SOCSSM3-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_RelDiff_SSM1_Map030.tif $OUTPUT_DIR/PH-GSOCS-RDSSM1-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_RelDiff_SSM2_Map030.tif $OUTPUT_DIR/PH-GSOCS-RDSSM2-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_RelDiff_SSM3_Map030.tif $OUTPUT_DIR/PH-GSOCS-RDSSM3-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_RSR_SSM1_Map030.tif $OUTPUT_DIR/PH-GSOCS-RSRSSM1-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_RSR_SSM1_UncertaintyMap030.tif $OUTPUT_DIR/PH-GSOCS-RSRSSM1U-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_RSR_SSM2_Map030.tif $OUTPUT_DIR/PH-GSOCS-RSRSSM2-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_RSR_SSM2_UncertaintyMap030.tif $OUTPUT_DIR/PH-GSOCS-RSRSSM2U-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_RSR_SSM3_Map030.tif $OUTPUT_DIR/PH-GSOCS-RSRSSM3-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_RSR_SSM3_UncertaintyMap030.tif $OUTPUT_DIR/PH-GSOCS-RSRSSM3U-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_SSM_UncertaintyMap030.tif $OUTPUT_DIR/PH-GSOCS-SSMU-2024-0-30.tif
cp $INPUT_DIR/PHL_GSOCseq_T0_Map030.tif $OUTPUT_DIR/PH-GSOCS-T0-2024-0-30.tif

INPUT_DIR="/home/carva014/Downloads/FAO/SIS/PH/Original/SOILP"                          # << EDIT THIS LINE!
OUTPUT_DIR="/home/carva014/Downloads/FAO/SIS/PH/TMP"                                    # << EDIT THIS LINE!
cp $INPUT_DIR/ak_0_30_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-K-2024-0-30.tif
cp $INPUT_DIR/ak_30_60_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-K-2024-30-60.tif
cp $INPUT_DIR/ak_60_100_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-K-2024-60-100.tif
cp $INPUT_DIR/ak_0_30_SD_PHL.tif $OUTPUT_DIR/PH-SOILP-K-2024-0-30SD.tif
cp $INPUT_DIR/ap_0_30_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-P-2024-0-30.tif
cp $INPUT_DIR/ap_30_60_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-P-2024-30-60.tif
cp $INPUT_DIR/ap_60_100_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-P-2024-60-100.tif
cp $INPUT_DIR/ap_0_30_SD_PHL.tif $OUTPUT_DIR/PH-SOILP-P-2024-0-30SD.tif
cp $INPUT_DIR/bd_0_30_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-BD-2024-0-30.tif
cp $INPUT_DIR/bd_30_60_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-BD-2024-30-60.tif
cp $INPUT_DIR/bd_60_100_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-BD-2024-60-100.tif
cp $INPUT_DIR/bd_0_30_SD_PHL.tif $OUTPUT_DIR/PH-SOILP-BD-2024-0-30SD.tif
cp $INPUT_DIR/cec_0_30_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-CEC-2024-0-30.tif
cp $INPUT_DIR/cec_30_60_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-CEC-2024-30-60.tif
cp $INPUT_DIR/cec_60_100_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-CEC-2024-60-100.tif
cp $INPUT_DIR/cec_0_30_SD_PHL.tif $OUTPUT_DIR/PH-SOILP-CEC-2024-0-30SD.tif
cp $INPUT_DIR/clay_0_30_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-CLAY-2024-0-30.tif
cp $INPUT_DIR/clay_30_60_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-CLAY-2024-30-60.tif
cp $INPUT_DIR/clay_60_100_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-CLAY-2024-60-100.tif
cp $INPUT_DIR/clay_0_30_SD_PHL.tif $OUTPUT_DIR/PH-SOILP-CLAY-2024-0-30SD.tif
cp $INPUT_DIR/ocs_0_30_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-OC-2024-0-30.tif
cp $INPUT_DIR/ocs_30_60_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-OC-2024-30-60.tif
cp $INPUT_DIR/ocs_60_100_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-OC-2024-60-100.tif
cp $INPUT_DIR/ocs_0_30_SD_PHL.tif $OUTPUT_DIR/PH-SOILP-OC-2024-0-30SD.tif
cp $INPUT_DIR/ph_0_30_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-PH-2024-0-30.tif
cp $INPUT_DIR/ph_30_60_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-PH-2024-30-60.tif
cp $INPUT_DIR/ph_60_100_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-PH-2024-60-100.tif
cp $INPUT_DIR/ph_0_30_SD_PHL.tif $OUTPUT_DIR/PH-SOILP-PH-2024-0-30SD.tif
cp $INPUT_DIR/sand_0_30_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-SAND-2024-0-30.tif
cp $INPUT_DIR/sand_30_60_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-SAND-2024-30-60.tif
cp $INPUT_DIR/sand_60_100_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-SAND-2024-60-100.tif
cp $INPUT_DIR/sand_0_30_SD_PHL.tif $OUTPUT_DIR/PH-SOILP-SAND-2024-0-30SD.tif
cp $INPUT_DIR/silt_0_30_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-SILT-2024-0-30.tif
cp $INPUT_DIR/silt_30_60_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-SILT-2024-30-60.tif
cp $INPUT_DIR/silt_60_100_Mean_PHL.tif $OUTPUT_DIR/PH-SOILP-SILT-2024-60-100.tif
cp $INPUT_DIR/silt_0_30_SD_PHL.tif $OUTPUT_DIR/PH-SOILP-SILT-2024-0-30SD.tif




# # old file names
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-AbsDiff_BAU.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_AbsDiff_BAU_Map030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-AbsDiff_SSM1.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_AbsDiff_SSM1_Map030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-AbsDiff_SSM2.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_AbsDiff_SSM2_Map030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-AbsDiff_SSM3.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_AbsDiff_SSM3_Map030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-ASR_SSM1.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_ASR_SSM1_Map030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-ASR_SSM2.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_ASR_SSM2_Map030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-ASR_SSM3.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_ASR_SSM3_Map030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-ASR_BAU.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_ASR_BAU_Map030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-SOC_BAU.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_finalSOC_BAU_Map030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-SOC_SSM1.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_finalSOC_SSM1_Map030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-SOC_SSM2.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_finalSOC_SSM2_Map030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-SOC_SSM3.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_finalSOC_SSM3_Map030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-RelDiff_SSM1.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_RelDiff_SSM1_Map030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-RelDiff_SSM2.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_RelDiff_SSM2_Map030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-RelDiff_SSM3.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_RelDiff_SSM3_Map030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-RSR_SSM1.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_RSR_SSM1_Map030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-RSR_SSM1_unc.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_RSR_SSM1_UncertaintyMap030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-RSR_SSM2.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_RSR_SSM2_Map030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-RSR_SSM2_unc.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_RSR_SSM2_UncertaintyMap030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-RSR_SSM3.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_RSR_SSM3_Map030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-RSR_SSM3_unc.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_RSR_SSM3_UncertaintyMap030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-SSM_unc.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_SSM_UncertaintyMap030.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/GSOCS/PHL_GSOC-2024-0-30-T0.tif /home/carva014/Downloads/FAO/SIS/PH/Original/PHL_GSOCseq_T0_Map030.tif

# cp /home/carva014/Downloads/FAO/SIS/PH/Original/SOILP/PH-Soil-2024-0-30-BD.tif /home/carva014/Downloads/FAO/SIS/PH/Original/bd_0_30_Mean_PHL.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/SOILP/PH-Soil-2024-0-30-CEC.tif /home/carva014/Downloads/FAO/SIS/PH/Original/cec_0_30_Mean_PHL.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/SOILP/PH-Soil-2024-0-30-Clay.tif /home/carva014/Downloads/FAO/SIS/PH/Original/clay_0_30_Mean_PHL.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/SOILP/PH-Soil-2024-0-30-K.tif /home/carva014/Downloads/FAO/SIS/PH/Original/ak_0_30_Mean_PHL.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/SOILP/PH-Soil-2024-0-30-OC.tif /home/carva014/Downloads/FAO/SIS/PH/Original/ocs_0_30_Mean_PHL.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/SOILP/PH-Soil-2024-0-30-P.tif /home/carva014/Downloads/FAO/SIS/PH/Original/ap_0_30_Mean_PHL.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/SOILP/PH-Soil-2024-0-30-pH.tif /home/carva014/Downloads/FAO/SIS/PH/Original/ph_0_30_Mean_PHL.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/SOILP/PH-Soil-2024-0-30-Sand.tif /home/carva014/Downloads/FAO/SIS/PH/Original/sand_0_30_Mean_PHL.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/SOILP/PH-Soil-2024-0-30-Silt.tif /home/carva014/Downloads/FAO/SIS/PH/Original/silt_0_30_Mean_PHL.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/SOILP/PH-Soil-2024-30-60-BD.tif /home/carva014/Downloads/FAO/SIS/PH/Original/bd_30_60_Mean_PHL.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/SOILP/PH-Soil-2024-30-60-CEC.tif /home/carva014/Downloads/FAO/SIS/PH/Original/cec_30_60_Mean_PHL.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/SOILP/PH-Soil-2024-30-60-Clay.tif /home/carva014/Downloads/FAO/SIS/PH/Original/clay_30_60_Mean_PHL.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/SOILP/PH-Soil-2024-30-60-K.tif /home/carva014/Downloads/FAO/SIS/PH/Original/ak_30_60_Mean_PHL.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/SOILP/PH-Soil-2024-30-60-OC.tif /home/carva014/Downloads/FAO/SIS/PH/Original/ocs_30_60_Mean_PHL.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/SOILP/PH-Soil-2024-30-60-P.tif /home/carva014/Downloads/FAO/SIS/PH/Original/ap_30_60_Mean_PHL.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/SOILP/PH-Soil-2024-30-60-pH.tif /home/carva014/Downloads/FAO/SIS/PH/Original/ph_30_60_Mean_PHL.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/SOILP/PH-Soil-2024-30-60-Sand.tif /home/carva014/Downloads/FAO/SIS/PH/Original/sand_30_60_Mean_PHL.tif
# cp /home/carva014/Downloads/FAO/SIS/PH/Original/SOILP/PH-Soil-2024-30-60-Silt.tif /home/carva014/Downloads/FAO/SIS/PH/Original/silt_30_60_Mean_PHL.tif
