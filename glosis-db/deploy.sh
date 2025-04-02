# start 
cd /home/carva014/Work/Code/FAO/glosis-sis/test/
docker-compose up -d
ll

# check container
docker ps

# drop db if already exists
docker exec -it glosis_db psql -d postgres -U glosis -c "DROP DATABASE IF EXISTS iso28258"

# create db
docker exec -it glosis_db psql -d postgres -U glosis -c "CREATE DATABASE iso28258 WITH OWNER = glosis TEMPLATE = postgres"

# remove unnecessary schemas and extensions
docker exec -it glosis_db psql -d iso28258 -U glosis -c "DROP EXTENSION postgis_tiger_geocoder"
docker exec -it glosis_db psql -d iso28258 -U glosis -c "DROP EXTENSION postgis_topology"
docker exec -it glosis_db psql -d iso28258 -U glosis -c "DROP EXTENSION fuzzystrmatch"
docker exec -it glosis_db psql -d iso28258 -U glosis -c "DROP SCHEMA IF EXISTS tiger"
docker exec -it glosis_db psql -d iso28258 -U glosis -c "DROP SCHEMA IF EXISTS tiger_data"
docker exec -it glosis_db psql -d iso28258 -U glosis -c "DROP SCHEMA IF EXISTS topology"

# create objects
docker cp /home/carva014/Work/Code/FAO/glosis-db/ISO_28258_ISRIC_v1.5_changed.sql glosis_db:/tmp/init.sql
docker exec -it glosis_db psql -d iso28258 -U glosis -f /tmp/init.sql

# db is running on localhost::5442
