#!/bin/bash

# Variables
PROJECT_DIR="/home/carva014/Work/Code/FAO/GloSIS"      # << EDIT THIS LINE!
COUNTRY=BT
COUNTRY_LONG="Bhutan"
ORG_LOGO_URL="https:\/\/tse4.mm.bing.net\/th\/id/OIP.hV37F63PxOkqMwTAlCNnvQAAAA?r=0&pid=Api" # PH "https:\/\/www.bswm.da.gov.ph\/wp-content\/uploads\/BAGONG-PILIPINAS.png"
LATITUDE=27   # 27 BT / 12 PH
LONGITUDE=90  # 90 BT / 120 PH
ZOOM=6

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
# rm $PROJECT_DIR/glosis-ws/volume/*.map
# rm $PROJECT_DIR/glosis-ws/volume/*.tif
cp $PROJECT_DIR/glosis-datacube/$COUNTRY/output/*.tif $PROJECT_DIR/glosis-ws/volume
cp $PROJECT_DIR/glosis-datacube/$COUNTRY/output/*.map $PROJECT_DIR/glosis-ws/volume

# Build and startcontainer
docker compose up --build glosis-ws -d


####################
#     glosis-md    #
####################

# Build and startcontainer
docker compose up --build glosis-md -d

# Load records
rm $PROJECT_DIR/glosis-md/volume/*.xml
cp $PROJECT_DIR/glosis-datacube/$COUNTRY/output/*.xml $PROJECT_DIR/glosis-md/volume
docker compose exec glosis-md ls -l /records
# FAILED: docker compose exec glosis-md pycsw-admin.py load-records -c /etc/pycsw/pycsw.yml -p /records -r -y

# Verify if records were loaded
docker compose exec glosis-db psql -U glosis -d glosis -c "SELECT identifier, title FROM pycsw.records ORDER BY title LIMIT 5;"

# Customize pyCSW UI - https://docs.pycsw.org/en/latest/configuration.html
docker compose exec glosis-md sed -i "s/pycsw website/${COUNTRY_LONG} SIS metadata/g" pycsw/pycsw/ogc/api/templates/_base.html
docker compose exec glosis-md sed -i "s|https://pycsw.org/img/pycsw-logo-vertical.png|${ORG_LOGO_URL}|g" pycsw/pycsw/ogc/api/templates/_base.html
docker compose exec glosis-md sed -i "s/https:\/\/pycsw.org/http:\/\/localhost:8001\/collections\/metadata:main\/items/g" pycsw/pycsw/ogc/api/templates/_base.html

####################
#     glosis-wm    #
####################

# layer_info.csv in layers.js line 8
# collapsed group layer names in main.js line 323
# default base map main.js line 464
# default layer map main.js line 475

# set the center and zoom level of the map
sed -i "s/MAP_CENTER_LONG/$LONGITUDE/g" $PROJECT_DIR/glosis-wm/src/js/main.js # line 98
sed -i "s/MAP_CENTER_LAT/$LATITUDE/g" $PROJECT_DIR/glosis-wm/src/js/main.js   # line 98
sed -i "s/MAP_ZOOM/$ZOOM/g" $PROJECT_DIR/glosis-wm/src/js/main.js             # line 99

# Build and startcontainer
docker compose up --build glosis-wm -d





