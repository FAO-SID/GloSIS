#!/usr/bin/env pwsh

###############################################
#                    Rename                   #
###############################################

# GSAS Section
$INPUT_DIR = "C:\home\carva014\Work\Code\FAO\GloSIS\glosis-datacube\BT\input\GSAS"           # << EDIT THIS LINE!
$OUTPUT_DIR = "C:\home\carva014\Work\Code\FAO\GloSIS\glosis-datacube\BT\tmp"                 # << EDIT THIS LINE!
$YEAR = 2021                                                                                  # << EDIT THIS LINE!

Copy-Item "$INPUT_DIR\EC0_30_sd.tif" "$OUTPUT_DIR\BT-GSAS-ECXSD-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\EC0_30_uncertain.tif" "$OUTPUT_DIR\BT-GSAS-ECXU-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\EC30_100_sd.tif" "$OUTPUT_DIR\BT-GSAS-ECXSD-$YEAR-30-100.tif"
Copy-Item "$INPUT_DIR\EC30_100_uncertain.tif" "$OUTPUT_DIR\BT-GSAS-ECXU-$YEAR-30-100.tif"
Copy-Item "$INPUT_DIR\ESP30_100_sd.tif" "$OUTPUT_DIR\BT-GSAS-NAEXCSD-$YEAR-30-100.tif"
Copy-Item "$INPUT_DIR\ESP30_100_uncertain.tif" "$OUTPUT_DIR\BT-GSAS-NAEXCU-$YEAR-30-100.tif"
Copy-Item "$INPUT_DIR\pH30_100_sd.tif" "$OUTPUT_DIR\BT-GSAS-PHXSD-$YEAR-30-100.tif"
Copy-Item "$INPUT_DIR\pH30_100_uncertain.tif" "$OUTPUT_DIR\BT-GSAS-PHXU-$YEAR-30-100.tif"
Copy-Item "$INPUT_DIR\Salt30_100cm_uncertain.tif" "$OUTPUT_DIR\BT-GSAS-SALTU-$YEAR-30-100.tif"
Copy-Item "$INPUT_DIR\Top0_30ECse.tif" "$OUTPUT_DIR\BT-GSAS-ECXSE-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Top0_30ECte.tif" "$OUTPUT_DIR\BT-GSAS-ECXTE-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Top0_30ESP.tif" "$OUTPUT_DIR\BT-GSAS-NAEXC-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Top0_30ESPt.tif" "$OUTPUT_DIR\BT-GSAS-NAEXCPT-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Top0_30PH.tif" "$OUTPUT_DIR\BT-GSAS-PHX-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Top0_30PHt.tif" "$OUTPUT_DIR\BT-GSAS-PHXT-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Top0_30saltaffected.tif" "$OUTPUT_DIR\BT-GSAS-SALT-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Top30_100ECse.tif" "$OUTPUT_DIR\BT-GSAS-ECXSE-$YEAR-30-100.tif"
Copy-Item "$INPUT_DIR\Top30_100ECte.tif" "$OUTPUT_DIR\BT-GSAS-ECXTE-$YEAR-30-100.tif"
Copy-Item "$INPUT_DIR\Top30_100ESP.tif" "$OUTPUT_DIR\BT-GSAS-NAEXC-$YEAR-30-100.tif"
Copy-Item "$INPUT_DIR\Top30_100ESPt.tif" "$OUTPUT_DIR\BT-GSAS-NAEXCPT-$YEAR-30-100.tif"
Copy-Item "$INPUT_DIR\Top30_100PH.tif" "$OUTPUT_DIR\BT-GSAS-PHX-$YEAR-30-100.tif"
Copy-Item "$INPUT_DIR\Top30_100PHt.tif" "$OUTPUT_DIR\BT-GSAS-PHXT-$YEAR-30-100.tif"
Copy-Item "$INPUT_DIR\Top30_100saltaffected.tif" "$OUTPUT_DIR\BT-GSAS-SALT-$YEAR-30-100.tif"

# GSOC Section
$INPUT_DIR = "C:\home\carva014\Work\Code\FAO\GloSIS\glosis-datacube\BT\input\GSOC"           # << EDIT THIS LINE!
$OUTPUT_DIR = "C:\home\carva014\Work\Code\FAO\GloSIS\glosis-datacube\BT\tmp"                 # << EDIT THIS LINE!
$YEAR = 2022                                                                                  # << EDIT THIS LINE!

Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_AbsDiff_BAU_Map030.tif" "$OUTPUT_DIR\BT-GSOC-CORGADBAU-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_AbsDiff_SSM1_Map030.tif" "$OUTPUT_DIR\BT-GSOC-CORGADSSM1-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_AbsDiff_SSM2_Map030.tif" "$OUTPUT_DIR\BT-GSOC-CORGADSSM2-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_AbsDiff_SSM3_Map030.tif" "$OUTPUT_DIR\BT-GSOC-CORGADSSM3-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_ASR_BAU_Map030.tif" "$OUTPUT_DIR\BT-GSOC-CORGASRBAU-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_ASR_BAU_UncertaintyMap030.tif" "$OUTPUT_DIR\BT-GSOC-CORGASRBAUU-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_ASR_SSM1_Map030.tif" "$OUTPUT_DIR\BT-GSOC-CORGASRSSM1-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_ASR_SSM1_UncertaintyMap030.tif" "$OUTPUT_DIR\BT-GSOC-CORGASRSSM1U-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_ASR_SSM2_Map030.tif" "$OUTPUT_DIR\BT-GSOC-CORGASRSSM2-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_ASR_SSM2_UncertaintyMap030.tif" "$OUTPUT_DIR\BT-GSOC-CORGASRSSM2U-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_ASR_SSM3_Map030.tif" "$OUTPUT_DIR\BT-GSOC-CORGASRSSM3-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_ASR_SSM3_UncertaintyMap030.tif" "$OUTPUT_DIR\BT-GSOC-CORGASRSSM3U-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_BAU_UncertaintyMap030.tif" "$OUTPUT_DIR\BT-GSOC-CORGBAUU-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_finalSOC_BAU_Map030.tif" "$OUTPUT_DIR\BT-GSOC-CORGSOCBAU-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_finalSOC_SSM1_Map030.tif" "$OUTPUT_DIR\BT-GSOC-CORGSOCSSM1-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_finalSOC_SSM2_Map030.tif" "$OUTPUT_DIR\BT-GSOC-CORGSOCSSM2-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_finalSOC_SSM3_Map030.tif" "$OUTPUT_DIR\BT-GSOC-CORGSOCSSM3-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_RelDiff_SSM1_Map030.tif" "$OUTPUT_DIR\BT-GSOC-CORGRDSSM1-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_RelDiff_SSM2_Map030.tif" "$OUTPUT_DIR\BT-GSOC-CORGRDSSM2-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_RelDiff_SSM3_Map030.tif" "$OUTPUT_DIR\BT-GSOC-CORGRDSSM3-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_RSR_SSM1_Map030.tif" "$OUTPUT_DIR\BT-GSOC-CORGRSRSSM1-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_RSR_SSM1_UncertaintyMap030.tif" "$OUTPUT_DIR\BT-GSOC-CORGRSRSSM1U-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_RSR_SSM2_Map030.tif" "$OUTPUT_DIR\BT-GSOC-CORGRSRSSM2-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_RSR_SSM2_UncertaintyMap030.tif" "$OUTPUT_DIR\BT-GSOC-CORGRSRSSM2U-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_RSR_SSM3_Map030.tif" "$OUTPUT_DIR\BT-GSOC-CORGRSRSSM3-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_RSR_SSM3_UncertaintyMap030.tif" "$OUTPUT_DIR\BT-GSOC-CORGRSRSSM3U-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_SSM_UncertaintyMap030.tif" "$OUTPUT_DIR\BT-GSOC-CORGSSMU-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_T0_Map030.tif" "$OUTPUT_DIR\BT-GSOC-CORGT0-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Bhutan_GSOCseq_T0_UncertaintyMap030.tif" "$OUTPUT_DIR\BT-GSOC-CORGT0U-$YEAR-0-30.tif"

# GSNM Section
$INPUT_DIR = "C:\home\carva014\Work\Code\FAO\GloSIS\glosis-datacube\BT\input\GSNM"           # << EDIT THIS LINE!
$OUTPUT_DIR = "C:\home\carva014\Work\Code\FAO\GloSIS\glosis-datacube\BT\tmp"                 # << EDIT THIS LINE!
$YEAR = 2024                                                                                  # << EDIT THIS LINE!

Copy-Item "$INPUT_DIR\AvailK_0_30_mean.tiff" "$OUTPUT_DIR\BT-GSNM-KXX-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\AvailK_0_30_sd.tiff" "$OUTPUT_DIR\BT-GSNM-KXXSD-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\AvailP_0_30_mean.tiff" "$OUTPUT_DIR\BT-GSNM-PXX-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\AvailP_0_30_sd.tiff" "$OUTPUT_DIR\BT-GSNM-PXXSD-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\BD_0_30_mean.tiff" "$OUTPUT_DIR\BT-GSNM-BKD-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\BD_0_30_sd.tiff" "$OUTPUT_DIR\BT-GSNM-BKDSD-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\BS_0_30_mean.tiff" "$OUTPUT_DIR\BT-GSNM-BASAT-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\BS_0_30_sd.tiff" "$OUTPUT_DIR\BT-GSNM-BASATSD-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Ca_0_30_mean.tiff" "$OUTPUT_DIR\BT-GSNM-CAEXC-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Ca_0_30_sd.tiff" "$OUTPUT_DIR\BT-GSNM-CAEXCSD-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\CEC_0_30_mean.tiff" "$OUTPUT_DIR\BT-GSNM-CEC-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\CEC_0_30_sd.tiff" "$OUTPUT_DIR\BT-GSNM-CECSD-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\ClayTotal_0_30_mean.tiff" "$OUTPUT_DIR\BT-GSNM-CLAY-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\ClayTotal_0_30_sd.tiff" "$OUTPUT_DIR\BT-GSNM-CLAYSD-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\CNRatio_0_30_mean.tiff" "$OUTPUT_DIR\BT-GSNM-CORGNTOTR-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\CNRatio_0_30_sd.tiff" "$OUTPUT_DIR\BT-GSNM-CORGNTOTRSD-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\CoarMat_0_30_mean.tiff" "$OUTPUT_DIR\BT-GSNM-CFRAGF-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\CoarMat_0_30_sd.tiff" "$OUTPUT_DIR\BT-GSNM-CFRAGFSD-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\K_0_30_mean.tiff" "$OUTPUT_DIR\BT-GSNM-KEXC-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\K_0_30_sd.tiff" "$OUTPUT_DIR\BT-GSNM-KEXCSD-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Mg2_0_30_mean.tiff" "$OUTPUT_DIR\BT-GSNM-MGEXC-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Mg2_0_30_sd.tiff" "$OUTPUT_DIR\BT-GSNM-MGEXCSD-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Na_0_30_mean.tiff" "$OUTPUT_DIR\BT-GSNM-NAEXC-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\Na_0_30_sd.tiff" "$OUTPUT_DIR\BT-GSNM-NAEXCSD-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\OC_0_30_mean.tiff" "$OUTPUT_DIR\BT-GSNM-CORG-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\OC_0_30_sd.tiff" "$OUTPUT_DIR\BT-GSNM-CORGSD-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\pHH2O_0_30_mean.tiff" "$OUTPUT_DIR\BT-GSNM-PHAQ-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\pHH2O_0_30_sd.tiff" "$OUTPUT_DIR\BT-GSNM-PHAQSD-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\SandTotal_0_30_mean.tiff" "$OUTPUT_DIR\BT-GSNM-SAND-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\SandTotal_0_30_sd.tiff" "$OUTPUT_DIR\BT-GSNM-SANDSD-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\SiltTotal_0_30_mean.tiff" "$OUTPUT_DIR\BT-GSNM-SILT-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\SiltTotal_0_30_sd.tiff" "$OUTPUT_DIR\BT-GSNM-SILTSD-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\TEB_0_30_mean.tiff" "$OUTPUT_DIR\BT-GSNM-BSEXC-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\TEB_0_30_sd.tiff" "$OUTPUT_DIR\BT-GSNM-BSEXCSD-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\TotalN_0_30_mean.tiff" "$OUTPUT_DIR\BT-GSNM-NTOT-$YEAR-0-30.tif"
Copy-Item "$INPUT_DIR\TotalN_0_30_sd.tiff" "$OUTPUT_DIR\BT-GSNM-NTOTSD-$YEAR-0-30.tif"

# OTHER Section
$INPUT_DIR = "C:\home\carva014\Work\Code\FAO\GloSIS\glosis-datacube\BT\input\OTHER"          # << EDIT THIS LINE!
$OUTPUT_DIR = "C:\home\carva014\Work\Code\FAO\GloSIS\glosis-datacube\BT\tmp"                 # << EDIT THIS LINE!
$YEAR = 2024                                                                                  # << EDIT THIS LINE!

Copy-Item "$INPUT_DIR\SoilType_map_10.tif" "$OUTPUT_DIR\BT-OTHER-CLAWRB-$YEAR-0-100.tif"