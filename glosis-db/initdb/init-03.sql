-- create role
CREATE ROLE pycsw WITH LOGIN NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS PASSWORD 'pycsw';
ALTER ROLE pycsw SET search_path = pycsw;

-- remove unnecessary schemas and extensions
DROP EXTENSION postgis_tiger_geocoder;
DROP EXTENSION postgis_topology;
DROP EXTENSION fuzzystrmatch;
DROP SCHEMA IF EXISTS tiger;
DROP SCHEMA IF EXISTS tiger_data;
DROP SCHEMA IF EXISTS topology;

-- create pycsw schema
CREATE SCHEMA pycsw;
ALTER SCHEMA pycsw OWNER TO pycsw;
COMMENT ON SCHEMA pycsw IS 'GloSIS metadata catalog';
GRANT ALL ON SCHEMA pycsw TO pycsw;

-- grant privileges to glosis_r
GRANT USAGE  ON SCHEMA core TO glosis_r;
GRANT SELECT ON ALL TABLES IN SCHEMA core TO glosis_r;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA core TO glosis_r;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA core TO glosis_r;
GRANT USAGE  ON SCHEMA metadata TO glosis_r;
GRANT SELECT ON ALL TABLES IN SCHEMA metadata TO glosis_r;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA metadata TO glosis_r;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA metadata TO glosis_r;
GRANT USAGE  ON SCHEMA pycsw TO glosis_r;
GRANT SELECT ON ALL TABLES IN SCHEMA pycsw TO glosis_r;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA pycsw TO glosis_r;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA pycsw TO glosis_r;

-- grant all privileges to pycsw
GRANT ALL ON SCHEMA pycsw TO pycsw;
GRANT ALL ON ALL TABLES IN SCHEMA pycsw TO pycsw;
GRANT ALL ON ALL SEQUENCES IN SCHEMA pycsw TO pycsw;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA pycsw TO pycsw;
