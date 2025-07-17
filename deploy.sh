#!/bin/bash

# Set working directory
PROJECT_DIR="/home/carva014/Work/Code/FAO/GloSIS"      # << EDIT THIS LINE!

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
#      Docker      #
####################

# Build and start Docker shiny containers
docker compose up --build glosis-shiny -d
# Update Global.R script to glosis-shiny container
docker cp $PROJECT_DIR/glosis-shiny/global/global.R glosis-shiny:/srv/shiny-server/iso28258/global.R

# Build and start other Docker containers
docker compose up --build glosis-wm -d
docker compose up --build glosis-ws -d
docker compose up --build glosis-md -d


####################
#     glosis-md    #
####################

# Load records
docker compose exec glosis-md ls -l /records
docker compose exec glosis-md pycsw-admin.py load-records -c /etc/pycsw/pycsw.yml -p /records -r -y

# Verify if records were loaded
docker compose exec glosis-db psql -U glosis -d glosis -c "SELECT identifier, title FROM pycsw.records ORDER BY title LIMIT 5;"

# Customize pyCSW UI - https://docs.pycsw.org/en/latest/configuration.html
docker compose exec glosis-md sed -i 's/pycsw website/Philippines SIS metadata/g' pycsw/pycsw/ogc/api/templates/_base.html
docker compose exec glosis-md sed -i 's/https:\/\/pycsw.org\/img\/pycsw-logo-vertical.png/https:\/\/www.bswm.da.gov.ph\/wp-content\/uploads\/BAGONG-PILIPINAS.png/g' pycsw/pycsw/ogc/api/templates/_base.html
docker compose exec glosis-md sed -i 's/https:\/\/pycsw.org/http:\/\/localhost:8001\/collections\/metadata:main\/items/g' pycsw/pycsw/ogc/api/templates/_base.html
