#!/bin/bash

psql -h localhost -p 5432 -d postgres -U postgres -c "DROP DATABASE IF EXISTS glosis"
# psql -h localhost -p 5432 -d postgres -U postgres -c "DROP ROLE IF EXISTS glosis"
# psql -h localhost -p 5432 -d postgres -U postgres -c "DROP ROLE IF EXISTS glosis_r"
# psql -h localhost -p 5432 -d postgres -U postgres -c "CREATE ROLE glosis WITH LOGIN SUPERUSER INHERIT CREATEDB CREATEROLE NOREPLICATION NOBYPASSRLS PASSWORD 'glosis'"
# psql -h localhost -p 5432 -d postgres -U postgres -c "CREATE ROLE glosis_r WITH LOGIN NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS PASSWORD 'glosis'"
psql -h localhost -p 5432 -d postgres -U glosis -c "CREATE DATABASE glosis"
psql -h localhost -p 5432 -d glosis -U glosis -c "CREATE EXTENSION IF NOT EXISTS postgis"
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/glosis-db_v1.5_changed.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_001.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_002.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_003.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_004.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_005.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_006.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_007.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_008.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_009.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_010.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_011.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_012.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_013.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_014.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_015.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_016.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_017.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_018.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_019.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_020.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_021.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_022.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_023.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_024.sql
psql -h localhost -p 5432 -d glosis -U glosis -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_025.sql
/home/carva014/Work/Code/FAO/GloSIS/glosis-db/Changes/mod_026.sh

# Dump iso28258 database
date=`date +%Y-%m-%d`
pg_dump -h localhost \
        -p 5432 \
        -d glosis \
        -U glosis \
        -F plain \
        -v \
        -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/versions/glosis-db_v$date.sql

pg_dump -h localhost \
        -p 5432 \
        -d glosis \
        -U glosis \
        -F plain \
        -v \
        -f /home/carva014/Work/Code/FAO/GloSIS/glosis-db/versions/glosis-db_latest.sql
cp /home/carva014/Work/Code/FAO/GloSIS/glosis-db/versions/glosis-db_latest.sql /home/carva014/Work/Code/FAO/GloSIS/glosis-db/scripts/glosis-db_latest.sql

# Export table with codelists of properties, procedures, units and alowed value range
psql -h localhost -p 5432 -d glosis -U glosis -c "\COPY (
        SELECT o.property_phys_chem_id, o.procedure_phys_chem_id, o.unit_of_measure_id, o.value_min, o.value_max, p.definition, p.citation, p.reference 
        FROM core.observation_phys_chem o
        LEFT JOIN core.procedure_phys_chem p ON p.procedure_phys_chem_id = o.procedure_phys_chem_id
        ORDER BY 1, 2) 
        TO '/home/carva014/Work/Code/FAO/GloSIS/glosis-db/versions/glosis-db_observation_phys_chem_code_list.csv' WITH CSV HEADER"
