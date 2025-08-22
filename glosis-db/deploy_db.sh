#!/bin/bash

# variables
PROJECT_DIR="/home/carva014/Work/Code/FAO"      # << EDIT THIS LINE!
DATE=`date +%Y-%m-%d`


psql -h localhost -p 5432 -d postgres -U postgres -c "DROP DATABASE IF EXISTS glosis"
# psql -h localhost -p 5432 -d postgres -U postgres -c "DROP ROLE IF EXISTS glosis"
# psql -h localhost -p 5432 -d postgres -U postgres -c "DROP ROLE IF EXISTS glosis_r"
# psql -h localhost -p 5432 -d postgres -U postgres -c "CREATE ROLE glosis WITH LOGIN SUPERUSER INHERIT CREATEDB CREATEROLE NOREPLICATION NOBYPASSRLS PASSWORD 'glosis'"
# psql -h localhost -p 5432 -d postgres -U postgres -c "CREATE ROLE glosis_r WITH LOGIN NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS PASSWORD 'glosis'"
psql -h localhost -p 5432 -d postgres -U glosis -c "CREATE DATABASE glosis"
psql -h localhost -p 5432 -d glosis -U glosis -c "CREATE EXTENSION IF NOT EXISTS postgis SCHEMA "public""
psql -h localhost -p 5432 -d glosis -U glosis -c "CREATE EXTENSION IF NOT EXISTS postgis_raster SCHEMA "public""
psql -h localhost -p 5432 -d glosis -U glosis -c "CREATE EXTENSION IF NOT EXISTS postgis_sfcgal SCHEMA "public""
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/versions/glosis-db_v1.5_changed.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_001.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_002.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_003.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_004.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_005.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_006.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_007.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_008.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_009.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_010.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_011.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_012.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_013.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_014.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_015.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_016.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_017.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_018.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_019.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_020.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_021.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_022.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_023.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_024.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_025.sql
$PROJECT_DIR/GloSIS/glosis-db/modifications/mod_026.sh
$PROJECT_DIR/GloSIS/glosis-db/modifications/mod_027.sh
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_028.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_029.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_030.sql
psql -h localhost -p 5432 -d glosis -U glosis -f $PROJECT_DIR/GloSIS/glosis-db/modifications/mod_031.sql

# Dump iso28258 database
pg_dump -h localhost \
        -p 5432 \
        -d glosis \
        -U glosis \
        -F plain \
        -v \
        -f $PROJECT_DIR/GloSIS/glosis-db/versions/glosis-db_v$DATE.sql

pg_dump -h localhost \
        -p 5432 \
        -d glosis \
        -U glosis \
        -F plain \
        -v \
        -f $PROJECT_DIR/GloSIS/glosis-db/versions/glosis-db_latest.sql

# Export table with codelists of properties, procedures, units and alowed value range
psql -h localhost -p 5432 -d glosis -U glosis -c "\COPY (
        SELECT o.property_phys_chem_id, o.procedure_phys_chem_id, o.unit_of_measure_id, o.value_min, o.value_max, p.definition, p.citation, p.reference 
        FROM core.observation_phys_chem o
        LEFT JOIN core.procedure_phys_chem p ON p.procedure_phys_chem_id = o.procedure_phys_chem_id
        ORDER BY 1, 2) 
        TO '$PROJECT_DIR/GloSIS/glosis-db/versions/glosis-db_observation_phys_chem_code_list.csv' WITH CSV HEADER"
