#!/bin/bash

###############################################
#                    Rename                   #
###############################################

INPUT_DIR="FAO/GloSIS/glosis-datacube/BT/input/GSAS"                          # << EDIT THIS LINE!
OUTPUT_DIR="FAO/GloSIS/glosis-datacube/BT/input/BT/tmp"                       # << EDIT THIS LINE!
cp $INPUT_DIR/Top0_30ECse.tif $OUTPUT_DIR/BT-GSAS-ECX-2020-0-30.tif
cp $INPUT_DIR/Sub30_100ECse.tif $OUTPUT_DIR/BT-GSAS-ECX-2020-30-100.tif
cp $INPUT_DIR/Top0_30ESP.tif $OUTPUT_DIR/BT-GSAS-NAEXC-2020-0-30.tif
cp $INPUT_DIR/Sub30_100ESP.tif $OUTPUT_DIR/BT-GSAS-NAEXC-2020-30-100.tif
cp $INPUT_DIR/Top0_30BT.tif $OUTPUT_DIR/BT-GSAS-BTX-2020-0-30.tif
cp $INPUT_DIR/Sub30_100BT.tif $OUTPUT_DIR/BT-GSAS-BTX-2020-30-100.tif
cp $INPUT_DIR/Top0_30saltaffected.tif $OUTPUT_DIR/BT-GSAS-SALT-2020-0-30.tif
cp $INPUT_DIR/Sub30_100saltaffected.tif $OUTPUT_DIR/BT-GSAS-SALT-2020-30-100.tif


/home/carva014/Downloads/FAO/SIS/BT/GSAS/EC0_30_sd.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/EC0_30_uncertain.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/EC30_100_sd.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/EC30_100_uncertain.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/ESP30_100_sd.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/ESP30_100_uncertain.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/pH30_100_sd.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/pH30_100_uncertain.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/Salt30_100cm_uncertain.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/saltaffected_LUT.txt
/home/carva014/Downloads/FAO/SIS/BT/GSAS/Top0_30ECse.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/Top0_30ECte.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/Top0_30ESP.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/Top0_30ESPt.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/Top0_30PH.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/Top0_30PHt.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/Top0_30saltaffected.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/Top30_100ECse.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/Top30_100ECte.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/Top30_100ESP.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/Top30_100ESPt.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/Top30_100PH.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/Top30_100PHt.tif
/home/carva014/Downloads/FAO/SIS/BT/GSAS/Top30_100saltaffected.tif











INPUT_DIR="FAO/GloSIS/glosis-datacube/BT/input/GSOC"                          # << EDIT THIS LINE!
OUTPUT_DIR="FAO/GloSIS/glosis-datacube/BT/input/BT/tmp"                       # << EDIT THIS LINE!
cp $INPUT_DIR/Bhutan_GSOCseq_AbsDiff_BAU_Map030.tif $OUTPUT_DIR/BT-GSOC-CORGADBAU-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_AbsDiff_SSM1_Map030.tif $OUTPUT_DIR/BT-GSOC-CORGADSSM1-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_AbsDiff_SSM2_Map030.tif $OUTPUT_DIR/BT-GSOC-CORGADSSM2-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_AbsDiff_SSM3_Map030.tif $OUTPUT_DIR/BT-GSOC-CORGADSSM3-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_ASR_BAU_Map030.tif $OUTPUT_DIR/BT-GSOC-CORGASRBAU-2021-0-30.tif
# cp $INPUT_DIR/Bhutan_GSOCseq_ASR_BAU_UncertaintyMap030.tif $OUTPUT_DIR/BT-GSOC-CORGASRBAUU-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_ASR_SSM1_Map030.tif $OUTPUT_DIR/BT-GSOC-CORGASRSSM1-2021-0-30.tif
# cp $INPUT_DIR/Bhutan_GSOCseq_ASR_SSM1_UncertaintyMap030.tif $OUTPUT_DIR/BT-GSOC-CORGASRSSM1U-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_ASR_SSM2_Map030.tif $OUTPUT_DIR/BT-GSOC-CORGASRSSM2-2021-0-30.tif
# cp $INPUT_DIR/Bhutan_GSOCseq_ASR_SSM2_UncertaintyMap030.tif $OUTPUT_DIR/BT-GSOC-CORGASRSSM2U-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_ASR_SSM3_Map030.tif $OUTPUT_DIR/BT-GSOC-CORGASRSSM3-2021-0-30.tif
# cp $INPUT_DIR/Bhutan_GSOCseq_ASR_SSM3_UncertaintyMap030.tif $OUTPUT_DIR/BT-GSOC-CORGASRSSM3U-2021-0-30.tif
# cp $INPUT_DIR/Bhutan_GSOCseq_BAU_UncertaintyMap030.tif $OUTPUT_DIR/BT-GSOC-CORGBAUU-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_finalSOC_BAU_Map030.tif $OUTPUT_DIR/BT-GSOC-CORGSOCBAU-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_finalSOC_SSM1_Map030.tif $OUTPUT_DIR/BT-GSOC-CORGSOCSSM1-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_finalSOC_SSM2_Map030.tif $OUTPUT_DIR/BT-GSOC-CORGSOCSSM2-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_finalSOC_SSM3_Map030.tif $OUTPUT_DIR/BT-GSOC-CORGSOCSSM3-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_RelDiff_SSM1_Map030.tif $OUTPUT_DIR/BT-GSOC-CORGRDSSM1-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_RelDiff_SSM2_Map030.tif $OUTPUT_DIR/BT-GSOC-CORGRDSSM2-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_RelDiff_SSM3_Map030.tif $OUTPUT_DIR/BT-GSOC-CORGRDSSM3-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_RSR_SSM1_Map030.tif $OUTPUT_DIR/BT-GSOC-CORGRSRSSM1-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_RSR_SSM1_UncertaintyMap030.tif $OUTPUT_DIR/BT-GSOC-CORGRSRSSM1U-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_RSR_SSM2_Map030.tif $OUTPUT_DIR/BT-GSOC-CORGRSRSSM2-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_RSR_SSM2_UncertaintyMap030.tif $OUTPUT_DIR/BT-GSOC-CORGRSRSSM2U-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_RSR_SSM3_Map030.tif $OUTPUT_DIR/BT-GSOC-CORGRSRSSM3-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_RSR_SSM3_UncertaintyMap030.tif $OUTPUT_DIR/BT-GSOC-CORGRSRSSM3U-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_SSM_UncertaintyMap030.tif $OUTPUT_DIR/BT-GSOC-CORGSSMU-2021-0-30.tif
cp $INPUT_DIR/Bhutan_GSOCseq_T0_Map030.tif $OUTPUT_DIR/BT-GSOC-CORGT0-2021-0-30.tif
# cp $INPUT_DIR/Bhutan_GSOCseq_T0_UncertaintyMap030.tif $OUTPUT_DIR/BT-GSOC-CORGT0U-2021-0-30.tif


INSERT INTO metadata.project (country_id, project_id, project_name) SELECT 'BT', project_id, project_name;

INSERT INTO metadata.property (property_id, name, unit_id) VALUES
('CORGASRBAUU', 'Organic Carbon Sequestration Potential - ASR Business As Usual (BAU) uncertainty', 'tonnes C ha-1 yr-1'),
('CORGASRSSM1U', 'Organic Carbon Sequestration Potential - ASR SSM1 uncertainty', 'tonnes C ha-1 yr-1'),
('CORGASRSSM2U', 'Organic Carbon Sequestration Potential - ASR SSM2 uncertainty', 'tonnes C ha-1 yr-1'),
('CORGASRSSM3U', 'Organic Carbon Sequestration Potential - ASR SSM3 uncertainty', 'tonnes C ha-1 yr-1'),
('CORGBAUU', 'Organic Carbon Sequestration Potential - Business As Usual (BAU) uncertainty', 'tonnes C ha-1 yr-1'),
('CORGT0U', 'Organic Carbon Sequestration Potential - Time Zero (TO) uncertainty', 'tonnes C ha-1 yr-1'),

AvailK_0_30_sd ('KXXSD', 'Potassium (K) standard deviation', 'ppm'),
AvailP_0_30_sd ('PXXSD', 'Phosphorus (P) standard deviation', 'ppm'),
BD_0_30_sd ('BKDSD', 'Bulk density standard deviation', 'g/cm3'),
BS_0_30_mean ('BASAT', 'Base saturation', '%'),
BS_0_30_sd ('BASATSD', 'Base saturation standard deviation', '%'),
CEC_0_30_sd ('CECSD', 'Cation exchange capacity standard deviation', 'cmol(c)/kg'),
ClayTotal_0_30_sd ('CLAYSD', 'Clay texture fraction standard deviation', '%'),
CNRatio_0_30_mean ('CORGNTOTR', 'Organic Carbon (C) Nitrogen (N) ratio', '%'),
CNRatio_0_30_sd ('CORGNTOTRSD', 'Organic Carbon (C) Nitrogen (N) ratio standard deviation', '%'),
K_0_30_mean ('KXX', 'Potassium (K)', 'ppm'),
K_0_30_sd ('KXXSD', 'Potassium (K) standard deviation', 'ppm'),
OC_0_30_sd ('CORGSD', 'Carbon (C) - organic standard deviation', '%'),
pHH2O_0_30_mean ('PHAQ', 'pH - Hydrogen potential in water', 'pH'),
pHH2O_0_30_sd ('PHAQSD', 'pH - Hydrogen potential in water standard deviation', 'pH'),
SandTotal_0_30_sd ('SANDSD', 'Sand texture fraction standard deviation', '%'),
SiltTotal_0_30_sd ('SILTSD', 'Silt texture fraction standard deviation', '%'),
TotalN_0_30_mean ('NTOT', 'Nitrogen (N) - total', ''),
TotalN_0_30_sd ('NTOTSD', 'Nitrogen (N) - total standard deviation', ''),

Ca_0_30_mean ('XXXXXX', '', ''),
Ca_0_30_sd ('XXXXXXSD', ' standard deviation', ''),
CoarMat_0_30_mean ('XXXXXX', '', ''),
CoarMat_0_30_sd ('XXXXXXSD', ' standard deviation', ''),
Mg2_0_30_mean ('XXXXXX', '', ''),
Mg2_0_30_sd ('XXXXXXSD', ' standard deviation', ''),
Na_0_30_mean ('XXXXXX', '', ''),
Na_0_30_sd ('XXXXXXSD', ' standard deviation', ''),
TEB_0_30_mean ('XXXXXX', '', ''),
TEB_0_30_sd ('XXXXXXSD', ' standard deviation', ''),



BS_0_30_mean.tif = Base saturation? Unit of measure in %?

Ca_0_30_mean.tif? And unit of measure?
    CAEXC	Calcium (Ca++) - exchangeable
    CAEXT	Calcium (Ca++) - extractable
    CASOL	Calcium (Ca++) - soluble
    CATOT	Calcium (Ca++) - total
    CCEFRA	Calcium carbonate equivalent - fraction
    CCETOT	Calcium carbonate equivalent - total

CoarMat_0_30_mean.tif? And unit of measure?
    Coarse fragments gravimetric	g/100g
    Coarse fragments volumetric	    cm³/100cm³

Mg2_0_30_mean.tif? And unit of measure?
    MGEXC	Magnesium (Mg++) - exchangeable
    MGEXT	Magnesium (Mg) - extractable
    MGSOL	Magnesium (Mg++) - soluble
    MGTOT	Magnesium (Mg) - total

Na_0_30_mean.tif? And unit of measure?
    NAEXC	Sodium (Na+) - exchangeable
    NAEXT	Sodium (Na) - extractable
    NASOL	Sodium (Na+) - soluble
    NATOT	Sodium (Na) - total

TEB_0_30_mean.tif? And unit of measure?

TotalN_0_30_mean.tif Unit of measure?






INPUT_DIR="FAO/GloSIS/glosis-datacube/BT/input/GSNM"                          # << EDIT THIS LINE!
OUTPUT_DIR="FAO/GloSIS/glosis-datacube/BT/input/BT/tmp"                       # << EDIT THIS LINE!
cp $INPUT_DIR/AvailK_0_30_mean.tiff $OUTPUT_DIR/BT-GSNM-KXX-2023-0-30.tif
# cp $INPUT_DIR/AvailK_0_30_sd.tiff $OUTPUT_DIR/BT-GSNM-KXXSD-2023-0-30.tif
cp $INPUT_DIR/AvailP_0_30_mean.tiff $OUTPUT_DIR/BT-GSNM-PXX-2023-0-30.tif
# cp $INPUT_DIR/AvailP_0_30_sd.tiff $OUTPUT_DIR/BT-GSNM-PXXSD-2023-0-30.tif
cp $INPUT_DIR/BD_0_30_mean.tiff $OUTPUT_DIR/BT-GSNM-BKD-2023-0-30.tif
# cp $INPUT_DIR/BD_0_30_sd.tiff $OUTPUT_DIR/BT-GSNM-BKDSD-2023-0-30.tif
# cp $INPUT_DIR/BS_0_30_mean.tiff $OUTPUT_DIR/BT-GSNM-XXXXXX-2023-0-30.tif
# cp $INPUT_DIR/BS_0_30_sd.tiff $OUTPUT_DIR/BT-GSNM-XXXXXXSD-2023-0-30.tif
# cp $INPUT_DIR/Ca_0_30_mean.tiff $OUTPUT_DIR/BT-GSNM-XXXXXX-2023-0-30.tif
# cp $INPUT_DIR/Ca_0_30_sd.tiff $OUTPUT_DIR/BT-GSNM-XXXXXXSD-2023-0-30.tif
cp $INPUT_DIR/CEC_0_30_mean.tiff $OUTPUT_DIR/BT-GSNM-CEC-2023-0-30.tif
# cp $INPUT_DIR/CEC_0_30_sd.tiff $OUTPUT_DIR/BT-GSNM-CECSD-2023-0-30.tif
cp $INPUT_DIR/ClayTotal_0_30_mean.tiff $OUTPUT_DIR/BT-GSNM-CLAY-2023-0-30.tif
# cp $INPUT_DIR/ClayTotal_0_30_sd.tiff $OUTPUT_DIR/BT-GSNM-CLAYSD-2023-0-30.tif
# cp $INPUT_DIR/CNRatio_0_30_mean.tiff $OUTPUT_DIR/BT-GSNM-XXXXXX-2023-0-30.tif
# cp $INPUT_DIR/CNRatio_0_30_sd.tiff $OUTPUT_DIR/BT-GSNM-XXXXXXSD-2023-0-30.tif
# cp $INPUT_DIR/CoarMat_0_30_mean.tiff $OUTPUT_DIR/BT-GSNM-XXXXXX-2023-0-30.tif
# cp $INPUT_DIR/CoarMat_0_30_sd.tiff $OUTPUT_DIR/BT-GSNM-XXXXXXSD-2023-0-30.tif
# cp $INPUT_DIR/K_0_30_mean.tiff $OUTPUT_DIR/BT-GSNM-XXXXXX-2023-0-30.tif
# cp $INPUT_DIR/K_0_30_sd.tiff $OUTPUT_DIR/BT-GSNM-XXXXXXSD-2023-0-30.tif
# cp $INPUT_DIR/Mg2_0_30_mean.tiff $OUTPUT_DIR/BT-GSNM-XXXXXX-2023-0-30.tif
# cp $INPUT_DIR/Mg2_0_30_sd.tiff $OUTPUT_DIR/BT-GSNM-XXXXXXSD-2023-0-30.tif
# cp $INPUT_DIR/Na_0_30_mean.tiff $OUTPUT_DIR/BT-GSNM-XXXXXX-2023-0-30.tif
# cp $INPUT_DIR/Na_0_30_sd.tiff $OUTPUT_DIR/BT-GSNM-XXXXXXSD-2023-0-30.tif
cp $INPUT_DIR/OC_0_30_mean.tiff $OUTPUT_DIR/BT-GSNM-CORG-2023-0-30.tif
# cp $INPUT_DIR/OC_0_30_sd.tiff $OUTPUT_DIR/BT-GSNM-CORGSD-2023-0-30.tif
# cp $INPUT_DIR/pHH2O_0_30_mean.tiff $OUTPUT_DIR/BT-GSNM-XXXXXX-2023-0-30.tif
# cp $INPUT_DIR/pHH2O_0_30_sd.tiff $OUTPUT_DIR/BT-GSNM-XXXXXXSD-2023-0-30.tif
cp $INPUT_DIR/SandTotal_0_30_mean.tiff $OUTPUT_DIR/BT-GSNM-SAND-2023-0-30.tif
# cp $INPUT_DIR/SandTotal_0_30_sd.tiff $OUTPUT_DIR/BT-GSNM-SANDSD-2023-0-30.tif
cp $INPUT_DIR/SiltTotal_0_30_mean.tiff $OUTPUT_DIR/BT-GSNM-SILT-2023-0-30.tif
# cp $INPUT_DIR/SiltTotal_0_30_sd.tiff $OUTPUT_DIR/BT-GSNM-SILTSD-2023-0-30.tif
# cp $INPUT_DIR/TEB_0_30_mean.tiff $OUTPUT_DIR/BT-GSNM-XXXXXX-2023-0-30.tif
# cp $INPUT_DIR/TEB_0_30_sd.tiff $OUTPUT_DIR/BT-GSNM-XXXXXXSD-2023-0-30.tif
# cp $INPUT_DIR/TotalN_0_30_mean.tiff $OUTPUT_DIR/BT-GSNM-XXXXXX-2023-0-30.tif
# cp $INPUT_DIR/TotalN_0_30_sd.tiff $OUTPUT_DIR/BT-GSNM-XXXXXXSD-2023-0-30.tif

INPUT_DIR="FAO/GloSIS/glosis-datacube/BT/input/OTHER"                         # << EDIT THIS LINE!
OUTPUT_DIR="FAO/GloSIS/glosis-datacube/BT/input/BT/tmp"                       # << EDIT THIS LINE!
# cp $INPUT_DIR/SoilType_map_10.tif $OUTPUT_DIR/BT-OTHER-XXXXXXXXXX-2023-0-100.tif
