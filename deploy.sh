#!/bin/bash

# Variables
PROJECT_DIR="/home/carva014/Work/Code/FAO/GloSIS"
COUNTRY=BT
COUNTRY_LONG="Bhutan"
ORG_LOGO_URL="https:\/\/tse4.mm.bing.net\/th\/id/OIP.hV37F63PxOkqMwTAlCNnvQAAAA?r=0&pid=Api" # PH "https:\/\/www.bswm.da.gov.ph\/wp-content\/uploads\/BAGONG-PILIPINAS.png"
LATITUDE=27.5   # 27 BT / 12 PH
LONGITUDE=89.7  # 90 BT / 120 PH
ZOOM=9
LAYER_DEFAULT='BT-GSNM-BKD-2024-0-30'
BASE_MAP_DEFAULT='esri-imagery' # esri-imagery / OpenStreetMap / Open TopoMap

# Navigate to the project folder
cd $PROJECT_DIR


####################
#      Docker      #
####################

# Clean up Docker
docker stop $(docker ps -q)
docker rm $(docker ps -aq)
docker rmi $(docker images -q) --force
docker network prune -f
docker volume prune -f
docker system prune -a --volumes -f

# Remove old DB volume content
rm -rf $PROJECT_DIR/glosis-db/volume/*


####################
#     glosis-db    #
####################

# Build and run glosis-db container
docker compose up --build glosis-db -d

# Wait for the PostgreSQL server to be ready
echo "Waiting for glosis-db PostgreSQL to start..."
until docker exec glosis-db pg_isready -U glosis -d glosis; do
  sleep 1
done
echo "glosis-db PostgreSQL is ready."

# Copy SQL scripts to glosis-db container
docker cp $PROJECT_DIR/glosis-db/initdb/init-01.sql glosis-db:/tmp/init-01.sql
docker cp $PROJECT_DIR/glosis-db/versions/glosis-db_latest.sql glosis-db:/tmp/init-02.sql
docker cp $PROJECT_DIR/glosis-db/initdb/init-03.sql glosis-db:/tmp/init-03.sql

# Execute SQL scripts inside the container
sleep 10
docker exec -it glosis-db psql -d glosis -U glosis -f /tmp/init-01.sql
docker exec -it glosis-db psql -d glosis -U glosis -f /tmp/init-02.sql
docker exec -it glosis-db psql -d glosis -U glosis -f /tmp/init-03.sql


####################
#   glosis-shiny   #
####################

# Build and start Docker shiny containers
docker compose up --build glosis-shiny -d
# Update Global.R script to glosis-shiny container
docker cp $PROJECT_DIR/glosis-shiny/global/global.R glosis-shiny:/srv/shiny-server/iso28258/global.R


####################
#     glosis-ws    #
####################

# Load records
rm $PROJECT_DIR/glosis-ws/volume/*.map
rm $PROJECT_DIR/glosis-ws/volume/*.tif
cp $PROJECT_DIR/glosis-datacube/$COUNTRY/output/*.tif $PROJECT_DIR/glosis-ws/volume
cp $PROJECT_DIR/glosis-datacube/$COUNTRY/output/*.map $PROJECT_DIR/glosis-ws/volume

# Build and start container
docker compose up --build glosis-ws -d


####################
#     glosis-md    #
####################

# Customize pyCSW
cp $PROJECT_DIR/glosis-md/pycsw_default.yml $PROJECT_DIR/glosis-md/pycsw.yml
sed -i "s|COUNTRY_SIS|$COUNTRY_LONG|g" $PROJECT_DIR/glosis-md/pycsw.yml

# Build and start container
docker compose up --build glosis-md -d

# Customize pyCSW UI - https://docs.pycsw.org/en/latest/configuration.html
docker compose exec glosis-md sed -i "s/pycsw website/${COUNTRY_LONG} SIS metadata/g" pycsw/pycsw/ogc/api/templates/_base.html
docker compose exec glosis-md sed -i "s|https://pycsw.org/img/pycsw-logo-vertical.png|${ORG_LOGO_URL}|g" pycsw/pycsw/ogc/api/templates/_base.html
docker compose exec glosis-md sed -i "s/https:\/\/pycsw.org/http:\/\/localhost:8001\/collections\/metadata:main\/items/g" pycsw/pycsw/ogc/api/templates/_base.html

# Load records
docker compose exec glosis-db psql -U glosis -d glosis -c "DELETE FROM pycsw.records;"
rm $PROJECT_DIR/glosis-md/volume/*.xml
cp $PROJECT_DIR/glosis-datacube/$COUNTRY/output/*.xml $PROJECT_DIR/glosis-md/volume
docker compose exec glosis-md ls -l /records
rm $PROJECT_DIR/glosis-md/volume/*.tif.aux.xml
docker compose exec glosis-md pycsw-admin.py load-records -c /etc/pycsw/pycsw.yml -p /records -r -y

# Verify if records were loaded
docker compose exec glosis-db psql -U glosis -d glosis -c "SELECT identifier, title FROM pycsw.records ORDER BY title LIMIT 5;"


####################
#     glosis-wm    #
####################

# collapsed group layer names in main.js line 323
# collapsed group layer names in layers.js line 84

# Overwrite logo file
cp $PROJECT_DIR/glosis-wm/public/img/logo_${COUNTRY}.png $PROJECT_DIR/glosis-wm/public/img/logo.png # index.html line 9 and 13

# Overwrite layer info file
cp $PROJECT_DIR/glosis-wm/public/layer_info_${COUNTRY}.csv $PROJECT_DIR/glosis-wm/public/layer_info.csv # layers.js line 8

# Reset main.js
cp $PROJECT_DIR/glosis-wm/src/js/main.default $PROJECT_DIR/glosis-wm/src/js/main.js

# Set map center
sed -i "s/MAP_CENTER_LONG/$LONGITUDE/g" $PROJECT_DIR/glosis-wm/src/js/main.js         # main.js line 98
sed -i "s/MAP_CENTER_LAT/$LATITUDE/g" $PROJECT_DIR/glosis-wm/src/js/main.js           # main.js line 98

# Set zoom level
sed -i "s/MAP_ZOOM/$ZOOM/g" $PROJECT_DIR/glosis-wm/src/js/main.js                     # main.js line 99

# Set default base map
sed -i "s/BASE_MAP_DEFAULT/$BASE_MAP_DEFAULT/g" $PROJECT_DIR/glosis-wm/src/js/main.js # main.js line 465

# Set default layer
sed -i "s/LAYER_DEFAULT/$LAYER_DEFAULT/g" $PROJECT_DIR/glosis-wm/src/js/main.js       # main.js line 476

# Reset index.html
cp $PROJECT_DIR/glosis-wm/src/index.default $PROJECT_DIR/glosis-wm/src/index.html

# Set country name
sed -i "s/COUNTRY_LONG/$COUNTRY_LONG/g" $PROJECT_DIR/glosis-wm/src/index.html       # main.js line 476

# Build and start container
docker compose up --build glosis-wm -d
