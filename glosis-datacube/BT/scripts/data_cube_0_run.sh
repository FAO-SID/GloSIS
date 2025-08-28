#!/bin/bash

###############################################
#                NoData & EPSG                #
###############################################


clear
/home/carva014/Work/Code/FAO/GloSIS/glosis-datacube/BT/scripts/data_cube_1_rename.sh
/home/carva014/Work/Code/FAO/GloSIS/glosis-datacube/BT/scripts/data_cube_2_check.sh
/home/carva014/Work/Code/FAO/GloSIS/glosis-datacube/BT/scripts/data_cube_3_nodata.sh
/home/carva014/Work/Code/FAO/GloSIS/glosis-datacube/BT/scripts/data_cube_4_epsg.sh
/home/carva014/Work/Code/FAO/GloSIS/glosis-datacube/BT/scripts/data_cube_5_cog.sh
rm -Rf /home/carva014/Work/Code/FAO/GloSIS/glosis-datacube/BT/tmp
