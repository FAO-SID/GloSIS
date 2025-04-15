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

-- create kobo schema
CREATE SCHEMA kobo;
ALTER SCHEMA kobo OWNER TO kobo;
COMMENT ON SCHEMA kobo IS 'GloSIS data collection';
GRANT ALL ON SCHEMA kobo TO kobo;

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
GRANT USAGE  ON SCHEMA kobo TO glosis_r;
GRANT SELECT ON ALL TABLES IN SCHEMA kobo TO glosis_r;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA kobo TO glosis_r;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA kobo TO glosis_r;

-- grant all privileges to pycsw
GRANT ALL ON SCHEMA pycsw TO pycsw;
GRANT ALL ON ALL TABLES IN SCHEMA pycsw TO pycsw;
GRANT ALL ON ALL SEQUENCES IN SCHEMA pycsw TO pycsw;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA pycsw TO pycsw;

-- grant all privileges to kobo
GRANT ALL ON SCHEMA kobo TO kobo;
GRANT ALL ON ALL TABLES IN SCHEMA kobo TO kobo;
GRANT ALL ON ALL SEQUENCES IN SCHEMA kobo TO kobo;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA kobo TO kobo;
