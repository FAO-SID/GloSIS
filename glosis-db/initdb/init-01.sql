-- create role
CREATE ROLE glosis_r WITH LOGIN NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS PASSWORD 'glosis';
CREATE ROLE pycsw WITH LOGIN NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS PASSWORD 'pycsw';
ALTER ROLE pycsw SET search_path = pycsw;
CREATE ROLE kobo WITH LOGIN NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS PASSWORD 'kobo';
ALTER ROLE kobo SET search_path = kobo;

-- add extensions
CREATE EXTENSION IF NOT EXISTS postgis_raster SCHEMA "public"; -- raster support
CREATE EXTENSION IF NOT EXISTS postgis_sfcgal SCHEMA "public"; -- 2D and 3D spatial functions https://postgis.net/docs/en/reference.html#reference_sfcgal
-- CREATE EXTENSION IF NOT EXISTS ogr_fdw SCHEMA "public"; -- OGR warapper
-- SQL Error [0A000]: ERROR: extension "ogr_fdw" is not available
--   Detail: Could not open extension control file "/usr/share/postgresql/17/extension/ogr_fdw.control": No such file or directory.
--   Hint: The extension must first be installed on the system where PostgreSQL is running.

-- upgrade extensions
SELECT postgis_extensions_upgrade();
