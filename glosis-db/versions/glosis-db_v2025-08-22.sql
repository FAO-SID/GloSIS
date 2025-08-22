--
-- PostgreSQL database dump
--

-- Dumped from database version 12.22 (Ubuntu 12.22-2.pgdg22.04+1)
-- Dumped by pg_dump version 16.2

-- Started on 2025-08-22 14:19:45 CEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 11 (class 2615 OID 54922780)
-- Name: core; Type: SCHEMA; Schema: -; Owner: glosis
--

CREATE SCHEMA core;


ALTER SCHEMA core OWNER TO glosis;

--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 11
-- Name: SCHEMA core; Type: COMMENT; Schema: -; Owner: glosis
--

COMMENT ON SCHEMA core IS 'Core entities and relations from the ISO-28258 domain model';


--
-- TOC entry 12 (class 2615 OID 54922781)
-- Name: metadata; Type: SCHEMA; Schema: -; Owner: glosis
--

CREATE SCHEMA metadata;


ALTER SCHEMA metadata OWNER TO glosis;

--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 12
-- Name: SCHEMA metadata; Type: COMMENT; Schema: -; Owner: glosis
--

COMMENT ON SCHEMA metadata IS 'Meta-data model based on VCard: https://www.w3.org/TR/vcard-rdf';


--
-- TOC entry 9 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 4 (class 3079 OID 54921076)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- TOC entry 3 (class 3079 OID 54922161)
-- Name: postgis_raster; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_raster WITH SCHEMA public;


--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION postgis_raster; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_raster IS 'PostGIS raster types and functions';


--
-- TOC entry 2 (class 3079 OID 54922718)
-- Name: postgis_sfcgal; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_sfcgal WITH SCHEMA public;


--
-- TOC entry 5024 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION postgis_sfcgal; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_sfcgal IS 'PostGIS SFCGAL functions';


--
-- TOC entry 1583 (class 1255 OID 54924171)
-- Name: check_result_value(); Type: FUNCTION; Schema: core; Owner: glosis
--

CREATE FUNCTION core.check_result_value() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    observation core.observation_phys_chem%ROWTYPE;
BEGIN
    SELECT * 
      INTO observation
      FROM core.observation_phys_chem
     WHERE observation_phys_chem_id = NEW.observation_phys_chem_id;
    
    IF NEW.value < observation.value_min OR NEW.value > observation.value_max THEN
        RAISE EXCEPTION 'Result value outside admissable bounds for the related observation.';
    ELSE
        RETURN NEW;
    END IF; 
END;
$$;


ALTER FUNCTION core.check_result_value() OWNER TO glosis;

--
-- TOC entry 5025 (class 0 OID 0)
-- Dependencies: 1583
-- Name: FUNCTION check_result_value(); Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON FUNCTION core.check_result_value() IS 'Checks if the value assigned to a result record is within the numerical bounds declared in the related observations (fields value_min and value_max).';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 274 (class 1259 OID 54924217)
-- Name: category_desc; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.category_desc (
    category_desc_id text NOT NULL,
    uri text
);


ALTER TABLE core.category_desc OWNER TO glosis;

--
-- TOC entry 222 (class 1259 OID 54922789)
-- Name: element; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.element (
    element_id integer NOT NULL,
    profile_id integer NOT NULL,
    order_element integer,
    upper_depth integer NOT NULL,
    lower_depth integer NOT NULL,
    type text NOT NULL,
    CONSTRAINT element_check CHECK ((lower_depth > upper_depth)),
    CONSTRAINT element_order_element_check CHECK ((order_element > 0)),
    CONSTRAINT element_type_check CHECK ((type = ANY (ARRAY['Horizon'::text, 'Layer'::text]))),
    CONSTRAINT element_upper_depth_check CHECK ((upper_depth >= 0)),
    CONSTRAINT element_upper_depth_check1 CHECK ((upper_depth <= 1000))
);


ALTER TABLE core.element OWNER TO glosis;

--
-- TOC entry 5027 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE element; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.element IS 'ProfileElement is the super-class of Horizon and Layer, which share the same basic properties. Horizons develop in a layer, which in turn have been developed throught geogenesis or anthropogenic action. Layers can be used to describe common characteristics of a set of adjoining horizons. For the time being no assocation is previewed between Horizon and Layer.';


--
-- TOC entry 5028 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN element.element_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.element.element_id IS 'Synthetic primary key.';


--
-- TOC entry 5029 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN element.profile_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.element.profile_id IS 'Reference to the Profile to which this element belongs';


--
-- TOC entry 5030 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN element.order_element; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.element.order_element IS 'Order of this element within the Profile';


--
-- TOC entry 5031 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN element.upper_depth; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.element.upper_depth IS 'Upper depth of this profile element in centimetres.';


--
-- TOC entry 5032 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN element.lower_depth; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.element.lower_depth IS 'Lower depth of this profile element in centimetres.';


--
-- TOC entry 5033 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN element.type; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.element.type IS 'Type of profile element, Horizon or Layer';


--
-- TOC entry 223 (class 1259 OID 54922795)
-- Name: element_element_id_seq; Type: SEQUENCE; Schema: core; Owner: glosis
--

ALTER TABLE core.element ALTER COLUMN element_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME core.element_element_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 275 (class 1259 OID 54924336)
-- Name: languages; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.languages (
    language_code text NOT NULL,
    language_name text NOT NULL
);


ALTER TABLE core.languages OWNER TO glosis;

--
-- TOC entry 224 (class 1259 OID 54922797)
-- Name: observation_desc_element; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.observation_desc_element (
    procedure_desc_id text NOT NULL,
    property_desc_id text NOT NULL,
    category_desc_id text NOT NULL,
    category_order smallint
);


ALTER TABLE core.observation_desc_element OWNER TO glosis;

--
-- TOC entry 5035 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE observation_desc_element; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.observation_desc_element IS 'Descriptive properties for the Surface feature of interest';


--
-- TOC entry 5036 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN observation_desc_element.procedure_desc_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.observation_desc_element.procedure_desc_id IS 'Foreign key to the corresponding procedure.';


--
-- TOC entry 5037 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN observation_desc_element.property_desc_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.observation_desc_element.property_desc_id IS 'Foreign key to the corresponding property';


--
-- TOC entry 5038 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN observation_desc_element.category_desc_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.observation_desc_element.category_desc_id IS 'Foreign key to the corresponding thesaurus entry';


--
-- TOC entry 225 (class 1259 OID 54922800)
-- Name: observation_desc_plot; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.observation_desc_plot (
    procedure_desc_id text NOT NULL,
    property_desc_id text NOT NULL,
    category_desc_id text NOT NULL,
    category_order smallint
);


ALTER TABLE core.observation_desc_plot OWNER TO glosis;

--
-- TOC entry 5039 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE observation_desc_plot; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.observation_desc_plot IS 'Descriptive properties for the Surface feature of interest';


--
-- TOC entry 5040 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN observation_desc_plot.procedure_desc_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.observation_desc_plot.procedure_desc_id IS 'Foreign key to the corresponding procedure.';


--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN observation_desc_plot.property_desc_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.observation_desc_plot.property_desc_id IS 'Foreign key to the corresponding property';


--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN observation_desc_plot.category_desc_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.observation_desc_plot.category_desc_id IS 'Foreign key to the corresponding thesaurus entry';


--
-- TOC entry 226 (class 1259 OID 54922803)
-- Name: observation_desc_profile; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.observation_desc_profile (
    procedure_desc_id text NOT NULL,
    property_desc_id text NOT NULL,
    category_desc_id text NOT NULL,
    category_order smallint
);


ALTER TABLE core.observation_desc_profile OWNER TO glosis;

--
-- TOC entry 5043 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE observation_desc_profile; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.observation_desc_profile IS 'Descriptive properties for the Surface feature of interest';


--
-- TOC entry 5044 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN observation_desc_profile.procedure_desc_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.observation_desc_profile.procedure_desc_id IS 'Foreign key to the corresponding procedure.';


--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN observation_desc_profile.property_desc_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.observation_desc_profile.property_desc_id IS 'Foreign key to the corresponding property';


--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN observation_desc_profile.category_desc_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.observation_desc_profile.category_desc_id IS 'Foreign key to the corresponding thesaurus entry';


--
-- TOC entry 227 (class 1259 OID 54922820)
-- Name: observation_phys_chem; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.observation_phys_chem (
    observation_phys_chem_id integer NOT NULL,
    property_phys_chem_id text NOT NULL,
    procedure_phys_chem_id text NOT NULL,
    unit_of_measure_id text NOT NULL,
    value_min real,
    value_max real
);


ALTER TABLE core.observation_phys_chem OWNER TO glosis;

--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE observation_phys_chem; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.observation_phys_chem IS 'Physio-chemical observations for the Element feature of interest';


--
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN observation_phys_chem.observation_phys_chem_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.observation_phys_chem.observation_phys_chem_id IS 'Synthetic primary key for the observation';


--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN observation_phys_chem.property_phys_chem_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.observation_phys_chem.property_phys_chem_id IS 'Foreign key to the corresponding property';


--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN observation_phys_chem.procedure_phys_chem_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.observation_phys_chem.procedure_phys_chem_id IS 'Foreign key to the corresponding procedure';


--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN observation_phys_chem.unit_of_measure_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.observation_phys_chem.unit_of_measure_id IS 'Foreign key to the corresponding unit of measure (if applicable)';


--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN observation_phys_chem.value_min; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.observation_phys_chem.value_min IS 'Minimum admissable value for this combination of property, procedure and unit of measure';


--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN observation_phys_chem.value_max; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.observation_phys_chem.value_max IS 'Maximum admissable value for this combination of property, procedure and unit of measure';


--
-- TOC entry 269 (class 1259 OID 54923778)
-- Name: observation_phys_chem_element_observation_phys_chem_element_seq; Type: SEQUENCE; Schema: core; Owner: glosis
--

ALTER TABLE core.observation_phys_chem ALTER COLUMN observation_phys_chem_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME core.observation_phys_chem_element_observation_phys_chem_element_seq
    START WITH 1008
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 228 (class 1259 OID 54922828)
-- Name: plot; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.plot (
    plot_id integer NOT NULL,
    site_id integer NOT NULL,
    plot_code character varying,
    altitude smallint,
    time_stamp date,
    map_sheet_code character varying,
    positional_accuracy smallint,
    "position" public.geometry(Point,4326),
    type text,
    CONSTRAINT plot_altitude_check CHECK (((altitude)::numeric > ('-100'::integer)::numeric)),
    CONSTRAINT plot_altitude_check1 CHECK (((altitude)::numeric < (8000)::numeric)),
    CONSTRAINT plot_time_stamp_check CHECK ((time_stamp > '1900-01-01'::date)),
    CONSTRAINT plot_type_check CHECK ((type = ANY (ARRAY['TrialPit'::text, 'Borehole'::text])))
);


ALTER TABLE core.plot OWNER TO glosis;

--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE plot; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.plot IS 'Elementary area or location where individual observations are made and/or samples are taken. Plot is the main spatial feature of interest in ISO-28258. Plot has three sub-classes: Borehole, Pit and Surface. Surface features its own table since it has its own properties and a different geometry.';


--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN plot.plot_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.plot.plot_id IS 'Synthetic primary key.';


--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN plot.site_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.plot.site_id IS 'Foreign key to Site table.';


--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN plot.plot_code; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.plot.plot_code IS 'Natural key, can be null.';


--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN plot.altitude; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.plot.altitude IS 'Altitude at the plot in metres, if known. Property re-used from GloSIS.';


--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN plot.time_stamp; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.plot.time_stamp IS 'Time stamp of the plot, if known. Property re-used from GloSIS.';


--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN plot.map_sheet_code; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.plot.map_sheet_code IS 'Code identifying the map sheet where the plot may be positioned. Property re-used from GloSIS.';


--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN plot.positional_accuracy; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.plot.positional_accuracy IS 'Accuracy in meters of the GPS position.';


--
-- TOC entry 5062 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN plot."position"; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.plot."position" IS 'Geodetic coordinates of the spatial position of the plot. Note the uncertainty associated with the WGS84 datum ensemble.';


--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN plot.type; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.plot.type IS 'Type of plot, TrialPit or Borehole.';


--
-- TOC entry 229 (class 1259 OID 54922837)
-- Name: plot_individual; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.plot_individual (
    plot_id integer NOT NULL,
    individual_id integer NOT NULL
);


ALTER TABLE core.plot_individual OWNER TO glosis;

--
-- TOC entry 5064 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE plot_individual; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.plot_individual IS 'Identifies the individual(s) responsible for surveying a plot';


--
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN plot_individual.plot_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.plot_individual.plot_id IS 'Foreign key to the plot table, identifies the plot surveyed';


--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN plot_individual.individual_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.plot_individual.individual_id IS 'Foreign key to the individual table, indicates the individual responsible for surveying the plot.';


--
-- TOC entry 230 (class 1259 OID 54922840)
-- Name: plot_plot_id_seq; Type: SEQUENCE; Schema: core; Owner: glosis
--

ALTER TABLE core.plot ALTER COLUMN plot_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME core.plot_plot_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 231 (class 1259 OID 54922842)
-- Name: procedure_desc; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.procedure_desc (
    procedure_desc_id text NOT NULL,
    reference character varying,
    uri character varying NOT NULL
);


ALTER TABLE core.procedure_desc OWNER TO glosis;

--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE procedure_desc; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.procedure_desc IS 'Descriptive Procedures for all features of interest. In most cases the procedure is described in a document such as the FAO Guidelines for Soil Description or the World Reference Base of Soil Resources.';


--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN procedure_desc.procedure_desc_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.procedure_desc.procedure_desc_id IS 'Synthetic primary key.';


--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN procedure_desc.reference; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.procedure_desc.reference IS 'Long and human readable reference to the publication.';


--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN procedure_desc.uri; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.procedure_desc.uri IS 'URI to the corresponding publication, optimally a DOI. Follow this URI for the full definition of the procedure.';


--
-- TOC entry 232 (class 1259 OID 54922850)
-- Name: procedure_phys_chem; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.procedure_phys_chem (
    procedure_phys_chem_id text NOT NULL,
    broader_id text,
    uri character varying NOT NULL,
    definition text,
    reference text,
    citation text
);


ALTER TABLE core.procedure_phys_chem OWNER TO glosis;

--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE procedure_phys_chem; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.procedure_phys_chem IS 'Physio-chemical Procedures for the Profile Element feature of interest';


--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN procedure_phys_chem.procedure_phys_chem_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.procedure_phys_chem.procedure_phys_chem_id IS 'Synthetic primary key.';


--
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN procedure_phys_chem.broader_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.procedure_phys_chem.broader_id IS 'Foreign key to brader procedure in the hierarchy';


--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN procedure_phys_chem.uri; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.procedure_phys_chem.uri IS 'URI to the corresponding in a controlled vocabulary (e.g. GloSIS). Follow this URI for the full definition and semantics of this procedure';


--
-- TOC entry 233 (class 1259 OID 54922858)
-- Name: profile; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.profile (
    profile_id integer NOT NULL,
    plot_id integer,
    surface_id integer,
    profile_code character varying,
    CONSTRAINT site_mandatory_foi CHECK ((((plot_id IS NOT NULL) OR (surface_id IS NOT NULL)) AND (NOT ((plot_id IS NOT NULL) AND (surface_id IS NOT NULL)))))
);


ALTER TABLE core.profile OWNER TO glosis;

--
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE profile; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.profile IS 'An abstract, ordered set of soil horizons and/or layers.';


--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN profile.profile_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.profile.profile_id IS 'Synthetic primary key.';


--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN profile.plot_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.profile.plot_id IS 'Foreign key to Plot feature of interest';


--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN profile.surface_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.profile.surface_id IS 'Foreign key to Surface feature of interest';


--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN profile.profile_code; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.profile.profile_code IS 'Natural primary key, if existing';


--
-- TOC entry 234 (class 1259 OID 54922865)
-- Name: profile_profile_id_seq; Type: SEQUENCE; Schema: core; Owner: glosis
--

ALTER TABLE core.profile ALTER COLUMN profile_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME core.profile_profile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 235 (class 1259 OID 54922867)
-- Name: project; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.project (
    project_id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE core.project OWNER TO glosis;

--
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE project; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.project IS 'Provides the context of the data collection as a prerequisite for the proper use or reuse of these data.';


--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN project.project_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.project.project_id IS 'Synthetic primary key.';


--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN project.name; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.project.name IS 'Natural key with project name.';


--
-- TOC entry 246 (class 1259 OID 54922970)
-- Name: project_site; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.project_site (
    project_id integer NOT NULL,
    site_id integer NOT NULL
);


ALTER TABLE core.project_site OWNER TO glosis;

--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 246
-- Name: TABLE project_site; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.project_site IS 'Many to many relation between Site and Project.';


--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 246
-- Name: COLUMN project_site.project_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.project_site.project_id IS 'Foreign key to Project table';


--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 246
-- Name: COLUMN project_site.site_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.project_site.site_id IS 'Foreign key to Site table';


--
-- TOC entry 244 (class 1259 OID 54922947)
-- Name: result_phys_chem; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.result_phys_chem (
    result_phys_chem_id integer NOT NULL,
    observation_phys_chem_id integer NOT NULL,
    specimen_id integer NOT NULL,
    individual_id integer,
    value real NOT NULL
);


ALTER TABLE core.result_phys_chem OWNER TO glosis;

--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 244
-- Name: TABLE result_phys_chem; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.result_phys_chem IS 'Numerical results for the Specimen feature interest.';


--
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 244
-- Name: COLUMN result_phys_chem.result_phys_chem_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.result_phys_chem.result_phys_chem_id IS 'Synthetic primary key.';


--
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 244
-- Name: COLUMN result_phys_chem.observation_phys_chem_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.result_phys_chem.observation_phys_chem_id IS 'Foreign key to the corresponding numerical observation.';


--
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 244
-- Name: COLUMN result_phys_chem.specimen_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.result_phys_chem.specimen_id IS 'Foreign key to the corresponding Specimen instance.';


--
-- TOC entry 5090 (class 0 OID 0)
-- Dependencies: 244
-- Name: COLUMN result_phys_chem.individual_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.result_phys_chem.individual_id IS 'Individual that is responsible for, or carried out, the process that produced this result.';


--
-- TOC entry 5091 (class 0 OID 0)
-- Dependencies: 244
-- Name: COLUMN result_phys_chem.value; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.result_phys_chem.value IS 'Numerical value resulting from applying the refered observation to the refered specimen.';


--
-- TOC entry 245 (class 1259 OID 54922963)
-- Name: site; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.site (
    site_id integer NOT NULL,
    site_code character varying,
    typical_profile integer,
    "position" public.geometry(Point,4326),
    extent public.geometry(Polygon,4326),
    CONSTRAINT site_mandatory_geometry CHECK (((("position" IS NOT NULL) OR (extent IS NOT NULL)) AND (NOT (("position" IS NOT NULL) AND (extent IS NOT NULL)))))
);


ALTER TABLE core.site OWNER TO glosis;

--
-- TOC entry 5092 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE site; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.site IS 'Defined area which is subject to a soil quality investigation. Site is not a spatial feature of interest, but provides the link between the spatial features of interest (Plot) to the Project. The geometry can either be a location (point) or extent (polygon) but not both at the same time.';


--
-- TOC entry 5093 (class 0 OID 0)
-- Dependencies: 245
-- Name: COLUMN site.site_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.site.site_id IS 'Synthetic primary key.';


--
-- TOC entry 5094 (class 0 OID 0)
-- Dependencies: 245
-- Name: COLUMN site.site_code; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.site.site_code IS 'Natural key, can be null.';


--
-- TOC entry 5095 (class 0 OID 0)
-- Dependencies: 245
-- Name: COLUMN site.typical_profile; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.site.typical_profile IS 'Foreign key to a profile providing a typical characterisation of this site.';


--
-- TOC entry 5096 (class 0 OID 0)
-- Dependencies: 245
-- Name: COLUMN site."position"; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.site."position" IS 'Geodetic coordinates of the spatial position of the site. Note the uncertainty associated with the WGS84 datum ensemble.';


--
-- TOC entry 5097 (class 0 OID 0)
-- Dependencies: 245
-- Name: COLUMN site.extent; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.site.extent IS 'Site extent expressed with geodetic coordinates of the site. Note the uncertainty associated with the WGS84 datum ensemble.';


--
-- TOC entry 248 (class 1259 OID 54922975)
-- Name: specimen; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.specimen (
    specimen_id integer NOT NULL,
    element_id integer NOT NULL,
    specimen_prep_process_id integer,
    organisation_id integer,
    code character varying
);


ALTER TABLE core.specimen OWNER TO glosis;

--
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 248
-- Name: TABLE specimen; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.specimen IS 'Soil Specimen is defined in ISO-28258 as: "a subtype of SF_Specimen. Soil Specimen may be taken in the Site, Plot, Profile, or ProfileElement including their subtypes." In this database Specimen is for now only associated to Plot for simplification.';


--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 248
-- Name: COLUMN specimen.specimen_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.specimen.specimen_id IS 'Synthetic primary key.';


--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 248
-- Name: COLUMN specimen.element_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.specimen.element_id IS 'Foreign key to the associated soil Plot';


--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 248
-- Name: COLUMN specimen.specimen_prep_process_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.specimen.specimen_prep_process_id IS 'Foreign key to the preparation process used on this soil Specimen.';


--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 248
-- Name: COLUMN specimen.organisation_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.specimen.organisation_id IS 'Organisation that is responsible for, or carried out, the process that produced this result.';


--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 248
-- Name: COLUMN specimen.code; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.specimen.code IS 'External code used to identify the soil Specimen (if used).';


--
-- TOC entry 277 (class 1259 OID 54924357)
-- Name: profiles; Type: VIEW; Schema: core; Owner: glosis
--

CREATE VIEW core.profiles AS
 SELECT r.result_phys_chem_id AS gid,
    p.name AS project_name,
    s.site_id,
    p3.profile_id,
    r.specimen_id,
    e.upper_depth,
    e.lower_depth,
    o.property_phys_chem_id,
    o.procedure_phys_chem_id,
    r.value,
    o.unit_of_measure_id,
    p2."position" AS geom
   FROM ((((((((core.project p
     LEFT JOIN core.project_site sp ON ((sp.project_id = p.project_id)))
     LEFT JOIN core.site s ON ((s.site_id = sp.site_id)))
     LEFT JOIN core.plot p2 ON ((p2.site_id = s.site_id)))
     LEFT JOIN core.profile p3 ON ((p3.plot_id = p2.plot_id)))
     LEFT JOIN core.element e ON ((e.profile_id = p3.profile_id)))
     LEFT JOIN core.specimen s2 ON ((s2.element_id = e.element_id)))
     LEFT JOIN core.result_phys_chem r ON ((r.specimen_id = s2.specimen_id)))
     LEFT JOIN core.observation_phys_chem o ON ((o.observation_phys_chem_id = r.observation_phys_chem_id)))
  ORDER BY p.name, s.site_id, p3.profile_id, e.upper_depth, o.property_phys_chem_id;


ALTER VIEW core.profiles OWNER TO glosis;

--
-- TOC entry 237 (class 1259 OID 54922876)
-- Name: project_project_id_seq; Type: SEQUENCE; Schema: core; Owner: glosis
--

ALTER TABLE core.project ALTER COLUMN project_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME core.project_project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 238 (class 1259 OID 54922878)
-- Name: project_related; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.project_related (
    project_source_id integer NOT NULL,
    project_target_id integer NOT NULL,
    role character varying NOT NULL
);


ALTER TABLE core.project_related OWNER TO glosis;

--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE project_related; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.project_related IS 'Relationship between two projects, e.g. project B being a sub-project of project A.';


--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN project_related.project_source_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.project_related.project_source_id IS 'Foreign key to source project.';


--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN project_related.project_target_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.project_related.project_target_id IS 'Foreign key to targe project.';


--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN project_related.role; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.project_related.role IS 'Role of source project in target project. This intended to be a code-list but no codes are given in the standard';


--
-- TOC entry 273 (class 1259 OID 54924209)
-- Name: property_desc; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.property_desc (
    property_desc_id text NOT NULL,
    property_pretty_name text,
    uri text
);


ALTER TABLE core.property_desc OWNER TO glosis;

--
-- TOC entry 239 (class 1259 OID 54922924)
-- Name: property_phys_chem; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.property_phys_chem (
    property_phys_chem_id text NOT NULL,
    uri character varying NOT NULL
);


ALTER TABLE core.property_phys_chem OWNER TO glosis;

--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE property_phys_chem; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.property_phys_chem IS 'Physio-chemical properties for the Element feature of interest';


--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 239
-- Name: COLUMN property_phys_chem.property_phys_chem_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.property_phys_chem.property_phys_chem_id IS 'Synthetic primary key.';


--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 239
-- Name: COLUMN property_phys_chem.uri; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.property_phys_chem.uri IS 'URI to the corresponding code in a controled vocabulary (e.g. GloSIS). Follow this URI for the full definition and semantics of this property';


--
-- TOC entry 240 (class 1259 OID 54922932)
-- Name: result_desc_element; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.result_desc_element (
    element_id integer NOT NULL,
    property_desc_id text NOT NULL,
    category_desc_id text NOT NULL
);


ALTER TABLE core.result_desc_element OWNER TO glosis;

--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 240
-- Name: TABLE result_desc_element; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.result_desc_element IS 'Descriptive results for the Element feature interest.';


--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN result_desc_element.element_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.result_desc_element.element_id IS 'Foreign key to the corresponding Element feature of interest.';


--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN result_desc_element.property_desc_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.result_desc_element.property_desc_id IS 'Foreign key to property_desc_element table.';


--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN result_desc_element.category_desc_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.result_desc_element.category_desc_id IS 'Foreign key to thesaurus_desc_element table.';


--
-- TOC entry 241 (class 1259 OID 54922935)
-- Name: result_desc_plot; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.result_desc_plot (
    plot_id integer NOT NULL,
    property_desc_id text NOT NULL,
    category_desc_id text NOT NULL
);


ALTER TABLE core.result_desc_plot OWNER TO glosis;

--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 241
-- Name: TABLE result_desc_plot; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.result_desc_plot IS 'Descriptive results for the Plot feature interest.';


--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 241
-- Name: COLUMN result_desc_plot.plot_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.result_desc_plot.plot_id IS 'Foreign key to the corresponding Plot feature of interest.';


--
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 241
-- Name: COLUMN result_desc_plot.property_desc_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.result_desc_plot.property_desc_id IS 'Foreign key to property_desc_plot table.';


--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 241
-- Name: COLUMN result_desc_plot.category_desc_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.result_desc_plot.category_desc_id IS 'Foreign key to thesaurus_desc_plot table.';


--
-- TOC entry 242 (class 1259 OID 54922938)
-- Name: result_desc_profile; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.result_desc_profile (
    profile_id integer NOT NULL,
    property_desc_id text NOT NULL,
    category_desc_id text NOT NULL
);


ALTER TABLE core.result_desc_profile OWNER TO glosis;

--
-- TOC entry 5121 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE result_desc_profile; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.result_desc_profile IS 'Descriptive results for the Profile feature interest.';


--
-- TOC entry 5122 (class 0 OID 0)
-- Dependencies: 242
-- Name: COLUMN result_desc_profile.profile_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.result_desc_profile.profile_id IS 'Foreign key to the corresponding Profile feature of interest.';


--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 242
-- Name: COLUMN result_desc_profile.property_desc_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.result_desc_profile.property_desc_id IS 'Foreign key to property_desc_profile table.';


--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 242
-- Name: COLUMN result_desc_profile.category_desc_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.result_desc_profile.category_desc_id IS 'Foreign key to thesaurus_desc_profile table.';


--
-- TOC entry 243 (class 1259 OID 54922944)
-- Name: result_desc_surface; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.result_desc_surface (
    surface_id integer NOT NULL,
    property_desc_id text NOT NULL,
    category_desc_id text NOT NULL
);


ALTER TABLE core.result_desc_surface OWNER TO glosis;

--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 243
-- Name: TABLE result_desc_surface; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.result_desc_surface IS 'Descriptive results for the Surface feature interest.';


--
-- TOC entry 5126 (class 0 OID 0)
-- Dependencies: 243
-- Name: COLUMN result_desc_surface.surface_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.result_desc_surface.surface_id IS 'Foreign key to the corresponding Surface feature of interest.';


--
-- TOC entry 5127 (class 0 OID 0)
-- Dependencies: 243
-- Name: COLUMN result_desc_surface.property_desc_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.result_desc_surface.property_desc_id IS 'Foreign key to property_desc_surface table.';


--
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 243
-- Name: COLUMN result_desc_surface.category_desc_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.result_desc_surface.category_desc_id IS 'Foreign key to thesaurus_desc_surface table.';


--
-- TOC entry 270 (class 1259 OID 54923784)
-- Name: result_phys_chem_specimen_result_phys_chem_specimen_id_seq; Type: SEQUENCE; Schema: core; Owner: glosis
--

ALTER TABLE core.result_phys_chem ALTER COLUMN result_phys_chem_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME core.result_phys_chem_specimen_result_phys_chem_specimen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 272 (class 1259 OID 54924151)
-- Name: result_spectrum; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.result_spectrum (
    result_spectrum_id integer NOT NULL,
    specimen_id integer NOT NULL,
    individual_id integer,
    spectrum jsonb
);


ALTER TABLE core.result_spectrum OWNER TO glosis;

--
-- TOC entry 271 (class 1259 OID 54924149)
-- Name: result_spectrum_result_spectrum_id_seq; Type: SEQUENCE; Schema: core; Owner: glosis
--

ALTER TABLE core.result_spectrum ALTER COLUMN result_spectrum_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME core.result_spectrum_result_spectrum_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 247 (class 1259 OID 54922973)
-- Name: site_site_id_seq; Type: SEQUENCE; Schema: core; Owner: glosis
--

ALTER TABLE core.site ALTER COLUMN site_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME core.site_site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 249 (class 1259 OID 54922981)
-- Name: specimen_prep_process; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.specimen_prep_process (
    specimen_prep_process_id integer NOT NULL,
    specimen_transport_id integer,
    specimen_storage_id integer,
    definition character varying NOT NULL
);


ALTER TABLE core.specimen_prep_process OWNER TO glosis;

--
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 249
-- Name: TABLE specimen_prep_process; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.specimen_prep_process IS 'Describes the preparation process of a soil Specimen. Contains information that does not result from observation(s).';


--
-- TOC entry 5131 (class 0 OID 0)
-- Dependencies: 249
-- Name: COLUMN specimen_prep_process.specimen_prep_process_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.specimen_prep_process.specimen_prep_process_id IS 'Synthetic primary key.';


--
-- TOC entry 5132 (class 0 OID 0)
-- Dependencies: 249
-- Name: COLUMN specimen_prep_process.specimen_transport_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.specimen_prep_process.specimen_transport_id IS 'Foreign key for the corresponding mode of transport';


--
-- TOC entry 5133 (class 0 OID 0)
-- Dependencies: 249
-- Name: COLUMN specimen_prep_process.specimen_storage_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.specimen_prep_process.specimen_storage_id IS 'Foreign key for the corresponding mode of storage';


--
-- TOC entry 5134 (class 0 OID 0)
-- Dependencies: 249
-- Name: COLUMN specimen_prep_process.definition; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.specimen_prep_process.definition IS 'Further details necessary to define the preparation process.';


--
-- TOC entry 250 (class 1259 OID 54922987)
-- Name: specimen_prep_process_specimen_prep_process_id_seq; Type: SEQUENCE; Schema: core; Owner: glosis
--

ALTER TABLE core.specimen_prep_process ALTER COLUMN specimen_prep_process_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME core.specimen_prep_process_specimen_prep_process_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 251 (class 1259 OID 54922989)
-- Name: specimen_specimen_id_seq; Type: SEQUENCE; Schema: core; Owner: glosis
--

ALTER TABLE core.specimen ALTER COLUMN specimen_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME core.specimen_specimen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 252 (class 1259 OID 54922991)
-- Name: specimen_storage; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.specimen_storage (
    specimen_storage_id integer NOT NULL,
    label character varying NOT NULL,
    definition character varying
);


ALTER TABLE core.specimen_storage OWNER TO glosis;

--
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 252
-- Name: TABLE specimen_storage; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.specimen_storage IS 'Modes of storage of a soil Specimen, part of the Specimen preparation process.';


--
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 252
-- Name: COLUMN specimen_storage.specimen_storage_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.specimen_storage.specimen_storage_id IS 'Synthetic primary key.';


--
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 252
-- Name: COLUMN specimen_storage.label; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.specimen_storage.label IS 'Short label for the storage mode.';


--
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 252
-- Name: COLUMN specimen_storage.definition; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.specimen_storage.definition IS 'Long definition providing all the necessary details for the storage mode.';


--
-- TOC entry 253 (class 1259 OID 54922997)
-- Name: specimen_storage_specimen_storage_id_seq; Type: SEQUENCE; Schema: core; Owner: glosis
--

ALTER TABLE core.specimen_storage ALTER COLUMN specimen_storage_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME core.specimen_storage_specimen_storage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 254 (class 1259 OID 54922999)
-- Name: specimen_transport; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.specimen_transport (
    specimen_transport_id integer NOT NULL,
    label character varying NOT NULL,
    definition character varying
);


ALTER TABLE core.specimen_transport OWNER TO glosis;

--
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 254
-- Name: TABLE specimen_transport; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.specimen_transport IS 'Modes of transport of a soil Specimen, part of the Specimen preparation process.';


--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 254
-- Name: COLUMN specimen_transport.specimen_transport_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.specimen_transport.specimen_transport_id IS 'Synthetic primary key.';


--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 254
-- Name: COLUMN specimen_transport.label; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.specimen_transport.label IS 'Short label for the transport mode.';


--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 254
-- Name: COLUMN specimen_transport.definition; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.specimen_transport.definition IS 'Long definition providing all the necessary details for the transport mode.';


--
-- TOC entry 255 (class 1259 OID 54923005)
-- Name: specimen_transport_specimen_transport_id_seq; Type: SEQUENCE; Schema: core; Owner: glosis
--

ALTER TABLE core.specimen_transport ALTER COLUMN specimen_transport_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME core.specimen_transport_specimen_transport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 256 (class 1259 OID 54923007)
-- Name: surface; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.surface (
    surface_id integer NOT NULL,
    super_surface_id integer,
    site_id integer NOT NULL,
    shape public.geometry(Polygon,4326),
    time_stamp date
);


ALTER TABLE core.surface OWNER TO glosis;

--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 256
-- Name: TABLE surface; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.surface IS 'Surface is a subtype of Plot with a shape geometry. Surfaces may be located within other
surfaces.';


--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 256
-- Name: COLUMN surface.surface_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.surface.surface_id IS 'Synthetic primary key.';


--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 256
-- Name: COLUMN surface.super_surface_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.surface.super_surface_id IS 'Hierarchical relation between surfaces.';


--
-- TOC entry 5146 (class 0 OID 0)
-- Dependencies: 256
-- Name: COLUMN surface.site_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.surface.site_id IS 'Foreign key to Site table';


--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 256
-- Name: COLUMN surface.shape; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.surface.shape IS 'Site extent expressed with geodetic coordinates of the site. Note the uncertainty associated with the WGS84 datum ensemble.';


--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 256
-- Name: COLUMN surface.time_stamp; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.surface.time_stamp IS 'Time stamp of the plot, if known. Property re-used from GloSIS.';


--
-- TOC entry 257 (class 1259 OID 54923013)
-- Name: surface_individual; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.surface_individual (
    surface_id integer NOT NULL,
    individual_id integer NOT NULL
);


ALTER TABLE core.surface_individual OWNER TO glosis;

--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 257
-- Name: TABLE surface_individual; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.surface_individual IS 'Identifies the individual(s) responsible for surveying a surface';


--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 257
-- Name: COLUMN surface_individual.surface_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.surface_individual.surface_id IS 'Foreign key to the surface table, identifies the surface surveyed';


--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 257
-- Name: COLUMN surface_individual.individual_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.surface_individual.individual_id IS 'Foreign key to the individual table, indicates the individual responsible for surveying the surface.';


--
-- TOC entry 258 (class 1259 OID 54923016)
-- Name: surface_surface_id_seq; Type: SEQUENCE; Schema: core; Owner: glosis
--

ALTER TABLE core.surface ALTER COLUMN surface_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME core.surface_surface_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 276 (class 1259 OID 54924344)
-- Name: translate; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.translate (
    table_name text NOT NULL,
    column_name text NOT NULL,
    language_code text NOT NULL,
    string text NOT NULL,
    translation text
);


ALTER TABLE core.translate OWNER TO glosis;

--
-- TOC entry 259 (class 1259 OID 54923058)
-- Name: unit_of_measure; Type: TABLE; Schema: core; Owner: glosis
--

CREATE TABLE core.unit_of_measure (
    unit_of_measure_id text NOT NULL,
    label character varying NOT NULL,
    uri character varying NOT NULL
);


ALTER TABLE core.unit_of_measure OWNER TO glosis;

--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 259
-- Name: TABLE unit_of_measure; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TABLE core.unit_of_measure IS 'Unit of measure';


--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 259
-- Name: COLUMN unit_of_measure.unit_of_measure_id; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.unit_of_measure.unit_of_measure_id IS 'Synthetic primary key.';


--
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 259
-- Name: COLUMN unit_of_measure.label; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.unit_of_measure.label IS 'Short label for this unit of measure';


--
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 259
-- Name: COLUMN unit_of_measure.uri; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON COLUMN core.unit_of_measure.uri IS 'URI to the corresponding unit of measuree in a controled vocabulary (e.g. GloSIS). Follow this URI for the full definition and semantics of this unit of measure';


--
-- TOC entry 260 (class 1259 OID 54923066)
-- Name: address; Type: TABLE; Schema: metadata; Owner: glosis
--

CREATE TABLE metadata.address (
    address_id integer NOT NULL,
    street_address character varying NOT NULL,
    postal_code character varying,
    locality character varying NOT NULL,
    country character varying NOT NULL
);


ALTER TABLE metadata.address OWNER TO glosis;

--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 260
-- Name: TABLE address; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON TABLE metadata.address IS 'Equivalent to the Address class in VCard, defined as delivery address for the associated object.';


--
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 260
-- Name: COLUMN address.address_id; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.address.address_id IS 'Synthetic primary key.';


--
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 260
-- Name: COLUMN address.street_address; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.address.street_address IS 'Street address data property in VCard, including house number, e.g. "Generaal Foulkesweg 108".';


--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 260
-- Name: COLUMN address.postal_code; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.address.postal_code IS 'Equivalent to the postal-code data property in VCard, e.g. "6701 PB".';


--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 260
-- Name: COLUMN address.locality; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.address.locality IS 'Locality data property in VCard, referring to a village, town, city, etc, e.g. "Wageningen".';


--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 260
-- Name: COLUMN address.country; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.address.country IS 'Equivalent to the country data property in VCard, e.g. "The Netherlands".';


--
-- TOC entry 261 (class 1259 OID 54923072)
-- Name: address_address_id_seq; Type: SEQUENCE; Schema: metadata; Owner: glosis
--

ALTER TABLE metadata.address ALTER COLUMN address_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME metadata.address_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 262 (class 1259 OID 54923074)
-- Name: individual; Type: TABLE; Schema: metadata; Owner: glosis
--

CREATE TABLE metadata.individual (
    individual_id integer NOT NULL,
    address_id integer,
    name character varying NOT NULL,
    honorific_title character varying,
    email character varying,
    telephone character varying,
    url character varying
);


ALTER TABLE metadata.individual OWNER TO glosis;

--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 262
-- Name: TABLE individual; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON TABLE metadata.individual IS 'Equivalent to the Individual class in VCard, defined as a single person or entity.';


--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 262
-- Name: COLUMN individual.individual_id; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.individual.individual_id IS 'Synthetic primary key.';


--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 262
-- Name: COLUMN individual.address_id; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.individual.address_id IS 'Foreign key to address associated with the individual.';


--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 262
-- Name: COLUMN individual.name; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.individual.name IS 'Name of the individual, encompasses the data properties additional-name, given-name and family-name in VCard.';


--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 262
-- Name: COLUMN individual.honorific_title; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.individual.honorific_title IS 'Academic title or honorific rank associated to the individual. Encompasses the data properties honorific-prefix, honorific-suffix and title in VCard.';


--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 262
-- Name: COLUMN individual.email; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.individual.email IS 'Electronic mail address of the individual.';


--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 262
-- Name: COLUMN individual.telephone; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.individual.telephone IS 'Equivalent to the telephone data property in VCard, e.g. "0031 961000789".';


--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 262
-- Name: COLUMN individual.url; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.individual.url IS 'Locator to a web page associated with the individual.';


--
-- TOC entry 263 (class 1259 OID 54923080)
-- Name: individual_individual_id_seq; Type: SEQUENCE; Schema: metadata; Owner: glosis
--

ALTER TABLE metadata.individual ALTER COLUMN individual_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME metadata.individual_individual_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 264 (class 1259 OID 54923082)
-- Name: organisation; Type: TABLE; Schema: metadata; Owner: glosis
--

CREATE TABLE metadata.organisation (
    organisation_id integer NOT NULL,
    parent_id integer,
    address_id integer,
    name character varying NOT NULL,
    email character varying,
    telephone character varying,
    url character varying
);


ALTER TABLE metadata.organisation OWNER TO glosis;

--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 264
-- Name: TABLE organisation; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON TABLE metadata.organisation IS 'Equivalent to the Organisation class in VCard, defined as a single entity, might also represent a business or government, a department or division within a business or government, a club, an association, or the like.';


--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN organisation.organisation_id; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.organisation.organisation_id IS 'Synthetic primary key.';


--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN organisation.parent_id; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.organisation.parent_id IS 'Foreign key to the parent organisation, in case of a department or division of a larger organisation.';


--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN organisation.address_id; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.organisation.address_id IS 'Foreign key to address associated with the organisation.';


--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN organisation.name; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.organisation.name IS 'Name of the organisation.';


--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN organisation.email; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.organisation.email IS 'Electronic mail address of the organisation.';


--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN organisation.telephone; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.organisation.telephone IS 'Equivalent to the telephone data property in VCard, e.g. "0031 961000787".';


--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN organisation.url; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.organisation.url IS 'Locator to a web page associated with the organisation.';


--
-- TOC entry 265 (class 1259 OID 54923088)
-- Name: organisation_individual; Type: TABLE; Schema: metadata; Owner: glosis
--

CREATE TABLE metadata.organisation_individual (
    organisation_id integer NOT NULL,
    organisation_unit_id integer,
    individual_id integer NOT NULL,
    role character varying
);


ALTER TABLE metadata.organisation_individual OWNER TO glosis;

--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 265
-- Name: TABLE organisation_individual; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON TABLE metadata.organisation_individual IS 'Relation between Individual and Organisation. Captures the object properties hasOrganisationName, org and organisation-name in VCard. In most cases means that the individual works at the organisation in the unit specified.';


--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN organisation_individual.organisation_id; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.organisation_individual.organisation_id IS 'Foreign key to the related organisation.';


--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN organisation_individual.organisation_unit_id; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.organisation_individual.organisation_unit_id IS 'Foreign key to the organisational unit associating the individual with the organisation.';


--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN organisation_individual.individual_id; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.organisation_individual.individual_id IS 'Foreign key to the related individual.';


--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN organisation_individual.role; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.organisation_individual.role IS 'Role of the individual within the organisation and respective organisational unit, e.g. "director", "secretary".';


--
-- TOC entry 266 (class 1259 OID 54923094)
-- Name: organisation_organisation_id_seq; Type: SEQUENCE; Schema: metadata; Owner: glosis
--

ALTER TABLE metadata.organisation ALTER COLUMN organisation_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME metadata.organisation_organisation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 236 (class 1259 OID 54922873)
-- Name: organisation_project; Type: TABLE; Schema: metadata; Owner: glosis
--

CREATE TABLE metadata.organisation_project (
    organisation_id integer NOT NULL,
    project_id integer NOT NULL
);


ALTER TABLE metadata.organisation_project OWNER TO glosis;

--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN organisation_project.organisation_id; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.organisation_project.organisation_id IS 'Foreign key to Organisation table.';


--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN organisation_project.project_id; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.organisation_project.project_id IS 'Foreign key to Project table.';


--
-- TOC entry 267 (class 1259 OID 54923096)
-- Name: organisation_unit; Type: TABLE; Schema: metadata; Owner: glosis
--

CREATE TABLE metadata.organisation_unit (
    organisation_unit_id integer NOT NULL,
    organisation_id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE metadata.organisation_unit OWNER TO glosis;

--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 267
-- Name: TABLE organisation_unit; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON TABLE metadata.organisation_unit IS 'Captures the data property organisation-unit and object property hasOrganisationUnit in VCard. Defines the internal structure of the organisation, apart from the departmental hierarchy.';


--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 267
-- Name: COLUMN organisation_unit.organisation_unit_id; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.organisation_unit.organisation_unit_id IS 'Synthetic primary key.';


--
-- TOC entry 5188 (class 0 OID 0)
-- Dependencies: 267
-- Name: COLUMN organisation_unit.organisation_id; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.organisation_unit.organisation_id IS 'Foreign key to the enclosing organisation, in case of a department or division of a larger organisation.';


--
-- TOC entry 5189 (class 0 OID 0)
-- Dependencies: 267
-- Name: COLUMN organisation_unit.name; Type: COMMENT; Schema: metadata; Owner: glosis
--

COMMENT ON COLUMN metadata.organisation_unit.name IS 'Name of the organisation unit.';


--
-- TOC entry 268 (class 1259 OID 54923102)
-- Name: organisation_unit_organisation_unit_id_seq; Type: SEQUENCE; Schema: metadata; Owner: glosis
--

ALTER TABLE metadata.organisation_unit ALTER COLUMN organisation_unit_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME metadata.organisation_unit_organisation_unit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 5011 (class 0 OID 54924217)
-- Dependencies: 274
-- Data for Name: category_desc; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.category_desc (category_desc_id, uri) FROM stdin;
Naramic	\N
Mollic Solonetz	\N
FM - Fine and medium (0.5-5 mm)	\N
Calcaric	\N
Brunic Regosol	\N
P - Pedfaces	\N
Aqualfs	\N
Haplic Cryosol	\N
Dfa - Snow climates - moist all seasons, hot summer	\N
2.5Y 7/2 - light grey	\N
Immissic	\N
7.5GY 6/2	\N
Leptic Andosol	\N
W - Woodland	\N
Drainic	\N
oPi - Older Pleistocene, ice-covered: commonly recent soil formation on younger over older, preweathered materials.	\N
Terric Planosol	\N
volcanic scoria/breccia	\N
Brunic Arenosol	\N
Luv	\N
V - Very fine artefacts (< 2 mm)	\N
Calcic Gypsisol	\N
oPp - Older Pleistocene, with periglacial influence: commonly recent soil formation on younger over older, preweathered materials.	\N
20-50 m	\N
SPL - Slightly plastic - Wire formable but breaks immediately if bent into a ring; soil mass deformed by very slight force.	\N
Kato	\N
Takyric Regosol	\N
Fractic	\N
Glossic Retisol	\N
anhydrite, gypsum	\N
PL - Ploughing	\N
EX - Extremely calcareous (> 25%) - Extremely strong reaction. Thick foam forms quickly.	\N
Udalfs	\N
lPf - Late Pleistocene, without periglacial influence.	\N
Anthrosol (AT)	\N
UG3 glacio-fluvial gravel	\N
UO1 - Unconsolidated: organic rainwater-fed moor peat	\N
7.5Y 7/4	\N
Histic Cambisol	\N
Neocambic Retisol	\N
Calcic Solonetz	\N
Rhodic Ferralsol	\N
HC - Hard concretions	\N
Albic Stagnosol	\N
Thyric Technosol	\N
Nitic Ferralsol	\N
5YR 4/1 - dark grey	\N
10YR 3/6 - dark yellowish brown	\N
7.5R 5/4 - weak red	\N
pyroclastic	\N
Dry - Other: 3–4%	\N
Daf - Cool-humid continental climate with warm high-sun season - moist	\N
Plaggic Podzol	\N
C - Clay (argillaceous)	\N
Protoargic	\N
Cryerts	\N
Spodic Gleysol	\N
AD - Wind deposition	\N
SC - soft concretions	\N
7.5GY 6/0	\N
Protovertic	\N
Turbic Cryosol	\N
F - Closed Forest	\N
VS - convex-straight	\N
5YR 7/1 - light grey	\N
Hydrophobic	\N
Luvic Stagnosol	\N
Dolomitic Gleysol	\N
P - Planes: Most planes are extra-pedal voids, related to accommodating ped surfaces or cracking patterns. They are often not persistent and vary in size, shape and quantity depending on the moisture condition of the soil. Planar voids may be recorded, describing width and frequency.	\N
C - Charcoal	\N
Terric Retisol	\N
AZ - Salt deposition	\N
7.5YR 8/4 - pink	\N
Tidalic Gleysol	\N
Salic	\N
SA - Scalped area	\N
NK - Not known	\N
Ferritic Nitisol	\N
Dystric Andosol	\N
EHA - Extremely hard: Extremely resistant to pressure; cannot be broken in the hand.	\N
60 - 70 %	\N
Neobrunic	\N
4 - High (15-40%)	\N
VFR - Very friable: Soil material crushes under very gentle pressure, but coheres when pressed together.	\N
Leptic	\N
Mollic Solonchak	\N
Chromic	\N
DX - Xeromorphic dwarf shrub	\N
volcanic ash	\N
Psamments	\N
NS - No specific location	\N
N 3/ - very dark grey	\N
Calcic Durisol	\N
Andic Cryosol	\N
I - Ice	\N
Ortsteinic Podzol	\N
Gypsiric Arenosol	\N
2.5Y 5/4 - light olive brown	\N
Xeralfs	\N
5B 7/1 - light bluish grey	\N
5Y 4/1 - dark grey	\N
Dry - S: 5–8%	\N
NF - Positive NaF test	\N
Oxisols	\N
Petrocalcic Vertisol	\N
V - Very widely spaced (> 5 m)	\N
WH - White	\N
Dsd - Snow climates  -dry summer,  very cold winter	\N
Gleyic Calcisol	\N
Chromic Cambisol	\N
S - Stones (60 - 200 mm)	\N
5 - Very deep (> 150 cm)	\N
SiC - Silty clay	\N
FoGr - Grasses	\N
7.5R 3/8 - dark red	\N
R - Rare (less than once in every 10 years)	\N
FE - Evergreen broad-leaved forest	\N
gravelly sand	\N
2.5YR 4/4 - reddish brown	\N
M - Mixed farming	\N
Chromic Lixisol	\N
Cryepts	\N
XE - Xeric	\N
Duric	\N
Dorsic	\N
Gypsic Luvisol	\N
OiOl - Olives	\N
Takyric Calcisol	\N
5Y 5/3 - olive	\N
RF - Submerged by local rainwater at least once a year	\N
CeMi - Millet	\N
Nudilithic Leptosol	\N
WS - Semi-deciduous woodland	\N
Pretic Phaeozem	\N
Humods	\N
4 - Deep (100-150 cm)	\N
SV3: 5 - 8 %	\N
ignimbrite	\N
Sloping	\N
grano-diorite	\N
Dystric Cambisol	\N
7.5Y 7/10	\N
Aluandic Andosol	\N
FO - Submerged by remote flowing inland water less than once a year	\N
5YR 4/4 - reddish brown	\N
> 9.0: Very Strongly alkaline	\N
Ferralsol (FR)	\N
HS - Short grassland	\N
5R 4/4 - weak red	\N
N 8/ - white	\N
Vertic Phaeozem	\N
lacustrine	\N
Rhodic Cambisol	\N
Endodolomitic Retisol	\N
Hyperspodic	\N
SiCL - Silty clay loam	\N
Cbw - Warm temperate (mesothermal) climates - dry winter	\N
OiLi - Linseed	\N
Skeletic Umbrisol	\N
White, after oxidation blue: vivianite	\N
DU - Dump (not specified)	\N
MO - Moderate: Aggregates are observable in place and there is a distinct arrangement of natural surfaces of weakness. When disturbed, the soil material breaks into a mixture of many entire aggregates, some broken aggregates, and little material without aggregates faces. Aggregates surfaces generally show distinct differences with the aggregates interiors.	\N
Skeletic Luvisol	\N
Usterts	\N
A - Annually	\N
B - Broken - Discontinuous	\N
Thionic Cambisol	\N
Leptic Podzol	\N
Yermic Calcisol	\N
UP - Upper slope (shoulder)	\N
7.5YR 2/2 - very dark brown	\N
Petrogypsic Kastanozem	\N
Umbr, Umbric	\N
Carbonic	\N
FoCl - Clover	\N
anthropogenic/technogenic	\N
Hydragric Gleysol	\N
Eutric Regosol	\N
10 - 25 %	\N
PN1 - Reserves	\N
5.1 - 5.5: Strongly acidic	\N
Thixotropic	\N
Yermic Solonchak	\N
Vesicular	\N
7.5GY 6/10	\N
Mollic Planosol	\N
Umbric Plinthosol	\N
Silandic Andosol	\N
Skeletic Durisol	\N
MO - Occasional storm surges (above mean high water springs)	\N
Coarsic Calcisol	\N
Dcf - Subarctic climate - moist	\N
Dry - Other: 9–15%	\N
AT1 - Non-irrigated tree crop cultivation	\N
08 - Moderately steep (15 - 30 %)	\N
VST - Very strongly salty (8 - 15 dS m-1)	\N
Duric Planosol	\N
WE - Evergreen woodland	\N
FrGr - Grapes, Wine, Raisins	\N
Caf - Temperate rainy (humid mesothermal) climate - moist	\N
10Y 7/8	\N
Dystric Retisol	\N
CL - Clay loam	\N
Petrocalcic Lixisol	\N
Caw - Temperate rainy (humid mesothermal) climate - dry winter	\N
F - Fine artefacts (2 - 6 mm)	\N
IH - Isohyperthermic	\N
MI - Primary mineral fragments: mica	\N
C - Cemented: Cemented mass cannot be broken in the hands and is continuous (more than 90 percent of soil mass).	\N
Skeletic Leptosol	\N
D2 - Fibric, degree of decomposition/humification is low	\N
Cordic	\N
IT - Isothermic	\N
Anthraquic Cambisol	\N
Arg	\N
R - Active in recent past (previous 50-100 years)	\N
IB3 - basic igneous: dolerite	\N
Lapiadic	\N
Leptosol (LP)	\N
Albic Podzol	\N
5R 6/3 - pale red	\N
Udox	\N
vYn - Very young (1-10 years) natural: with loss by erosion or deposition of materials such as on tidal flats, coastal dunes, river valleys, landslides, or desert areas.	\N
CO - Columnar	\N
EX - Extremely salty (>15 dS m-1)	\N
SV5: ? 12 %	\N
MA3 - Acid metamorphic: slate, phyllite, (pellitic rocks)	\N
Cf - Mild temperate rainy climate - no distinct dry season	\N
W - Water erosion or deposition	\N
VST - Very sticky - After pressure, soil material adheres strongly to both thumb and finger and is decidedly stretched when they are separated.	\N
Protic	\N
Moderately drained	\N
Dystric Nitisol	\N
Arenic	\N
IU1 - Ultrabasic igneous: peridotite	\N
Umbric Gleysol	\N
OiCc - Coconuts	\N
7.5YR 5/8 - strong brown	\N
10R 3/4 - dusky red	\N
Leptic Chernozem	\N
FO - Iron-organic matter	\N
ESE - east-south-east	\N
Dry - LS, SL, L: 9–15%	\N
UL2 - Unconsolidated: lacustrine silt and clay	\N
Dystric Fluvisol	\N
Leptic Nitisol	\N
5Y 7/6 - yellow	\N
Tidalic Histosol	\N
Isolatic Technosol	\N
Acr	\N
5R 5/8 - red	\N
V - Very thick (> 20 mm)	\N
Acric Ferralsol	\N
7.5R 4/0 - dark grey	\N
Dc - Subarctic climate	\N
Activic	\N
ST - Strongly calcareous (10-25%) - Strong visible effervescence. Bubbles form a low foam.	\N
metamorphic limestone (marble)	\N
Planosol (PL)	\N
Cambic Phaeozem	\N
Ca - Temperate rainy (humid mesothermal) climate	\N
2.5Y 8/0 - white	\N
I - Interstitial: Controlled by the fabric, or arrangement, of the soil particles, also known as textural voids. Subdivision possible into simple packing voids, which relate to the packing of sand particles, and compound packing voids, which result from the packing of non-accommodating peds. Predominantly irregular in shape and interconnected, and hard to quantify in the field.	\N
Anthraquic Vertisol	\N
Cambic Umbrisol	\N
Gypsiric Fluvisol	\N
Bathyspodic	\N
2.5Y 6/2 - light brownish grey	\N
KQ - Carbonates-silica	\N
PS - Subangular prismatic	\N
7.5YR 4/2 - (dark) brown	\N
Moderately deep (50-100 cm)	\N
PL - Plastic - Wire formable but breaks if bent into a ring; slight to moderate force required for deformation of the soil mass.	\N
Chromic Alisol	\N
Gypsic Durisol	\N
A - Abundant (> 40 %)	\N
AC - Archaeological (burial mound, midden)	\N
10YR 6/1 - (light) grey	\N
Dfd - Snow climates - moist all seasons, very cold winter	\N
N 7/ - light grey	\N
Dsc - Snow climates - dry summer,  cool short summer	\N
Plaggic Cambisol	\N
SV - Medium-gradient valley (10 - 30 %)	\N
OiGr - Groundnuts	\N
Histic Gleysol	\N
MM - Mixed material	\N
CC - concave-concave	\N
AA2 - Fallow system cultivation	\N
Dolomitic Leptosol	\N
Eutric Fluvisol	\N
S - Stones (6 - 20 cm)	\N
Ce - Cereals	\N
Moist - Other: 0.3–0.6%	\N
Thyric Histosol	\N
LS - Lower slope (foot slope)	\N
Leptic Durisol	\N
Aqu	\N
FM - Fine and medium (0.5-5 mm).	\N
PL - Placic	\N
Endodystric	\N
Petrocalcic Solonetz	\N
Vitr	\N
loess	\N
IS - Sprinkler irrigation	\N
Haplic Vertisol	\N
HI2 - Dairying	\N
Mollic Umbrisol	\N
Rhodic Nitisol	\N
Vertic Chernozem	\N
5YR 6/1 - (light) grey	\N
L - Level land (< 10 %)	\N
intermediate igneous	\N
C - Common (5-15 %)	\N
Plagg	\N
Dry - LS, SL, L: 0.5–0.8%	\N
Dystric Regosol	\N
silt and clay	\N
Rhodic	\N
D - Dominant (> 80%)	\N
US - Ustic	\N
Hydragric Planosol	\N
AM - Wind erosion and deposition	\N
5YR 4/2 - dark reddish grey	\N
MO - Moderately gypsiric (5-15%) - EC = > 1.8 dS m-1 in 10 g soil/250 ml H2O	\N
D - Daily	\N
Channels	\N
BL - Blocky	\N
Ud	\N
Takyric Solonchak	\N
Hapl	\N
V - Vughs: Mostly irregular, equidimensional voids of faunal origin or resulting from tillage or disturbance of other voids. Discontinuous or interconnected. May be quantified in specific cases.	\N
5YR 7/6 - reddish yellow	\N
Ano	\N
Chernic Phaeozem	\N
Pachic	\N
Stagnic Acrisol	\N
Someric Umbrisol	\N
Daw - Cool-humid continental climate with warm high-sun season - dry winter	\N
Hypercalcic	\N
FS - Fine sand	\N
Sideralic Anthrosol	\N
VM - Very fine to medium	\N
10YR 6/6 - brownish yellow	\N
2.5Y 5/6 - light olive brown	\N
10Y 6/1 - grey	\N
Dcs - Subarctic climate - dry season in summer	\N
1 - Very shallow (0-25 cm)	\N
0.04 - 0.07 g cm-3	\N
5R 6/1 - reddish grey	\N
Raptic	\N
CePa - Rice, paddy	\N
C - Coarse (5-20 mm).	\N
CR - Impact crater	\N
Wind erosion and deposition	\N
SG  - Stagnating	\N
Cryic Histosol	\N
10Y 4/1 - grey	\N
Supra	\N
Camb	\N
Gibbsic Plinthosol	\N
N - None - No odour detected	\N
Gleyic Andosol	\N
industrial/artisanal deposits	\N
Petrocalcic Gypsisol	\N
5YR 5/6 - yellowish red	\N
10YR 4/4 - dark yellowish brown	\N
Leptic Luvisol	\N
Dry - Other: < 0.6%	\N
Hortic Kastanozem	\N
Protic Fluvisol	\N
N - No evidence of erosion	\N
Calcisol (CL)	\N
UO - Submerged by inland water of unknown origin less than once a year	\N
GE - Greenish	\N
Cumulic	\N
UU5 - Unconsolidated: unspecified gravel, broken rock	\N
Umbrisol (UM)	\N
Dbw - Cool-humid continental  with cool high-sun season - dry winter	\N
SN - Snow	\N
Moist - S: 0.9–1.5%	\N
MS - Medium sand	\N
N 4/ - dark grey	\N
Ferritic	\N
Petrocalcic Luvisol	\N
Ferric Lixisol	\N
WC4 - Rainy without heavy rain in the last 24 hours	\N
Stagnic Plinthosol	\N
Rendzic Leptosol	\N
Sideralic Cambisol	\N
Limnic	\N
Cry	\N
5YR 2.5/2 - dark reddish brown	\N
Coarsic Leptosol	\N
Interstitial	\N
5R 6/2 - pale red	\N
CV - Coarse and very coarse	\N
Petroplinthic	\N
5B 6/1 - bluish grey	\N
Alic Durisol	\N
E - Ice climates	\N
M - Monthly	\N
SU - Sunny/clear	\N
Albic Retisol	\N
50 - 60 %	\N
VF - Very fine / thin: Granular/platy: < 1 mm,  Prismatic/columnar/wedgeshaped: < 10 mm, Blocky/crumbly/lumpy/cloddy: < 5 mm	\N
2.5Y 4/0 - dark grey	\N
Vertic Solonetz	\N
Gleyic Fluvisol	\N
7.5YR 3/4 - dark brown	\N
7.5YR 6/8 - reddish yellow	\N
RU - Rudic	\N
Columnic	\N
Gelisols	\N
Irragric Luvisol	\N
Ombroaquic	\N
T - Terraced	\N
Deposition by water	\N
gneiss rich in Fe–Mg minerals	\N
7.5GY 6/4	\N
7.5YR 4/4 - (dark) brown	\N
IA2 - Acid igneous: grano-diorite	\N
lahar	\N
10Y 8/6	\N
Bluish black (with 10% HCl; H?S smell): Fe sulphides	\N
Xerands	\N
IF - Isofrigid	\N
10YR 4/3 - (dark) brown	\N
DI - Discontinuous irregular: Surface of coatings contrasts strongly in smoothness or colour with the adjacent surfaces. Outlines of fine sand grains are not visible. Lamellae are more than 5 mm thick.	\N
CeWh - Wheat	\N
II2 - Intermediate igneous: diorite-syenite	\N
Humic	\N
Calcic Planosol	\N
C - Clay	\N
M - Many (15-40 %)	\N
Nitisol (NT)	\N
Brunic Kastanozem	\N
Q - Silica (siliceous)	\N
Reductic Gleysol	\N
D - Nodular: The layer is largely constructed from cemented nodules or concretions of irregular shape.	\N
Vertisol (VR)	\N
D - Dominant (> 80 %)	\N
Anhy	\N
(green)schist	\N
Irragric Phaeozem	\N
VFS - Very fine sand	\N
Pretic Retisol	\N
S - Soft	\N
andesite, trachyte, phonolite	\N
Fluvic Solonchak	\N
7.5R 4/6 - red	\N
2.5Y 8/8 - yellow	\N
Podzol (PZ)	\N
Vertic Alisol	\N
Salids	\N
MB3 - Basic metamorphic: gneiss rich in Fe-Mg minerals	\N
Hydragric Lixisol	\N
Sulf, Sulfic	\N
OtRu - Rubber	\N
MB6 - Basic metamorphic: eclogite	\N
5R 3/4 - dusky red	\N
E - east	\N
Csc - Warm Temperate - dry summer, cool short summer	\N
P - Prominent: The mottles are conspicuous and mottling is one of the outstanding features of the horizon. Hue, chroma and value alone or in combination are at least several units apart.	\N
2.5YR 6/8 - light red	\N
PS - Pavements and paving stones	\N
Alcalic	\N
N - Neither receiving nor shedding water	\N
quartz-diorite	\N
Alic Nitisol	\N
Gleyic Umbrisol	\N
Andic Cambisol	\N
2.5Y 8/4 - pale yellow	\N
N 5/ - grey	\N
7.5Y 7/2 - light grey	\N
GF - Submerged by rising local groundwater at least once a year	\N
weathered residuum	\N
Andic Anthrosol	\N
Luvic Nitisol	\N
SN - Slickensides, non intersecting	\N
clay	\N
Greyish green, light blue: Fe-mix Compounds (Blue-Green Rust)	\N
LF - Landfill (also sanitary)	\N
VO - Voids	\N
Cryands	\N
Archaic	\N
E - Extreme - Substantial removal of deeper subsurface horizons (badlands). Original biotic functions fully destroyed	\N
UA2 -  Unconsolidated: Anthropogenic/ technogenic industrial/artisanal deposits	\N
Solonetz (SN)	\N
Transportic Arenosol	\N
Skeletic Regosol	\N
Mollic Gleysol	\N
Tsitelic Cambisol	\N
Endo	\N
7.5GY 7/0	\N
Thionic Planosol	\N
Stagnic Gypsisol	\N
2 - Very shallow (0-25 cm) Shallow (25-50 cm) Moderately deep (50-100 cm) Deep (100-150 cm) Very deep (> 150 cm) -15 days	\N
Common	\N
10YR 3/4 - dark yellowish brown	\N
Hyperorganic	\N
Takyric Fluvisol	\N
Eutric Andosol	\N
7.5GY 7/2	\N
Panto	\N
UM2 - Unconsolidated: marine clay and silt	\N
Dry - Other: 0.6–1.2%	\N
Subaquatic Histosol	\N
3.1 - Incomplete description - without sampling: Certain relevant elements are missing from the description, an insufficient number of samples was collected, or the reliability of the analytical data does not permit a complete characterization of the soil. However, the description is useful for specific purposes and provides a satisfactory indication of the nature of the soil at high levels of soil taxonomic classification. Soil description is done without sampling.	\N
BO - Bottom (drainage line)	\N
MF - Agroforestry	\N
SO - Soft: Soil mass is very weakly coherent and fragile; breaks to powder or individual grains under very slight pressure.	\N
2.5YR 3/4 - dark reddish brown	\N
Lixisol (LX)	\N
Black colour due to metal sulphides, flammable methane present	\N
Garbic Technosol	\N
Fractic Durisol	\N
Calcaric Fluvisol	\N
Petroduric Chernozem	\N
Sideralic Retisol	\N
5Y 5/1 - grey	\N
Retisol (RT)	\N
Saprists	\N
Tonguic Phaeozem	\N
2.5Y 8/6 - yellow	\N
Rhod, Rhodic	\N
Da - Cool-humid continental climate with warm high-sun season	\N
5Y 5/6 - olive	\N
5Y 2.5/2 - black	\N
6 - 180-360 days	\N
Ferric Acrisol	\N
< 2 m	\N
Sapr	\N
PR - Prismatic	\N
Torr	\N
7.5Y 7/0	\N
5 - 90-180 days	\N
Albic Solonetz	\N
Evapocrustic	\N
Calcic Chernozem	\N
Dry - S: 0.3–0.6%	\N
Pretic Stagnosol	\N
7.5Y 8/6	\N
Loamic	\N
HI - Intensive grazing	\N
Mulmic Umbrisol	\N
I - Indurated: Cemented mass cannot be broken by body weight (75-kg standard soil scientist) (more than 90 percent of soil mass).	\N
Rend	\N
Deep (100-150 cm)	\N
V - Very wet: Crushing: free water. Forming (to a ball): drops of water without crushing. Moistening: no change of colour. pF: 0.	\N
BS -  Steppe climate	\N
Ustox	\N
UG1 - Unconsolidated: glacial moraine	\N
CeRi - Rice, dry	\N
WE - With wetlands (occupying > 15%)	\N
N - Non-cemented and non-compacted: Neither cementation nor compaction observed (slakes in water).	\N
Terric Anthrosol	\N
Ddf - Subarctic with very cold low-sun season - moist	\N
D - Diffuse (> 2 mm)	\N
evaporites	\N
Terric Stagnosol	\N
Petr	\N
5Y 7/1 - light grey	\N
Mazic	\N
PF - Petroferric	\N
7.5Y 8/10	\N
FRF - Friable to firm:	\N
2.5Y 4/4 - olive brown	\N
Skeletic Chernozem	\N
N - Non-calcareous (0%) - No detectable visible or audible effervescence.	\N
Coarse	\N
Dsb - Snow climates - dry summer, warm	\N
10Y 5/2 - olive grey	\N
Oxygleyic Gleysol	\N
Gypsiric Phaeozem	\N
M - Moist	\N
5Y 7/3 - pale yellow	\N
Relocatic Regosol	\N
BR - Bridges between sand grains	\N
DO = Dome-shaped	\N
BD5 - Very large pressure necessary to force knife into the soil, no further disintegration of sample - prismatic - > 1.8	\N
M - Many	\N
WM - Weak to moderate	\N
N - No influence	\N
5YR 3/1 - very dark grey	\N
Stagnic Technosol	\N
Eutric	\N
5Y 8/4 - pale yellow	\N
T - Crystal	\N
5YR 7/3 - pink	\N
5BG 4/1 - dark greenish grey	\N
Skeletic Cambisol	\N
F - Fine gravel (2 - 6 mm)	\N
Carbonatic	\N
Ustults	\N
Takyric	\N
Irragric	\N
NPL - Non-plastic - No wire is formable.	\N
Spodosols	\N
Pretic Cambisol	\N
Petrocalcic Solonchak	\N
Hn - Holocene (100-10,000 years) natural: with loss by erosion or deposition of materials such as on tidal flats, coastal dunes, river valleys, landslides, or desert areas.	\N
D - Closely spaced (0.2 - 0.5 m)	\N
10YR 8/2 - white	\N
PO  - Polluted	\N
BSk - Steppe climate Dry-cold	\N
Hypernatric	\N
5YR 3/2 - dark reddish brown	\N
Orthents	\N
C - Very closely spaced (< 0.2 m)	\N
Retic Phaeozem	\N
AD - Artificial drainage	\N
Laxic	\N
Leptic Cambisol	\N
4 - 30-90 days	\N
Endic	\N
Lixic Phaeozem	\N
OtSc - Sugar cane	\N
02 - Level (0.2 - 0.5 %)	\N
2.5YR 6/4 - light reddish brown	\N
VV - convex-convex	\N
7.5GY 8/4	\N
Yermic Cryosol	\N
Reductaquic Cryosol	\N
Thionic Stagnosol	\N
Protocalcic	\N
7.5R 4/8 - red	\N
UU4 - Unconsolidated: unspecified gravelly sand	\N
BD1 - Sample disintegrates at the instant of sampling, many pores visible on the pit wall - single grain, granular - 0.9-1.2	\N
B - Boulders (200 - 600 mm)	\N
FP - Plantation forestry	\N
Hyperdystric	\N
Albic Alisol	\N
CS - Clay-sesquioxides	\N
SM - Medium-gradient mountain (10 - 30 %)	\N
silt-, mud-, claystone	\N
Aric	\N
PG - Pergelic	\N
Glossic Stagnosol	\N
FR  - Fresh	\N
80 - 90 %	\N
7.5Y 5/4	\N
Verm	\N
V - Vesicular: The layer has large, equidimensional voids that may be filled with uncemented material.	\N
Tidalic Technosol	\N
Brunic Phaeozem	\N
Aquands	\N
Saprolithic	\N
SE - south-east	\N
Cryic Technosol	\N
Terric Phaeozem	\N
10 - 20 %	\N
Plaggic Umbrisol	\N
quartzite	\N
C - Common - Roots with diameters < 2 mm: 50-200, Roots with diameters > 2 mm: 5-20.	\N
Moist - Other: 1.5–3%	\N
shale	\N
Dry - LS, SL, L: 0.8–1.2%	\N
SSW - south-south-west	\N
M - Moist: Crushing: is sticky. Forming (to a ball): finger moist and cool, weakly shiny. Moistening: no change of colour. Rubbing (in the hand): obviously lighter. pF: 2.	\N
MS - Middle slope (back slope)	\N
2.5YR 2.5/4 - dark reddish brown	\N
Transportic	\N
Albic Luvisol	\N
ET - Tundra climate	\N
Hortic Gleysol	\N
Leptic Regosol	\N
OiSo - Soybeans	\N
F - Faint: The mottles are evident only on close examination. Soil colours in both the matrix and mottles have closely related hues, chromas and values.	\N
Posic	\N
NST - Non-sticky - After release of pressure, practically no soil material adheres to thumb and finger.	\N
Nearly level	\N
0 %	\N
Gleyic Solonetz	\N
CR - Crest (summit)	\N
Sulfatic	\N
Andic	\N
Andisols	\N
H - Animal husbandry	\N
Spodic Cryosol	\N
Gypsic Solonetz	\N
HVH - hard to very hard:	\N
Csb - Temperate rainy (humid mesothermal) climate with dry summer With warm summer	\N
Fractic Gypsisol	\N
Ombric Histosol	\N
TK - Takyric	\N
Fragi, Fragic	\N
OV - Overcast	\N
5R 4/1 - dark reddish grey	\N
10R 6/3 - pale red	\N
Aquerts	\N
Calcic	\N
Gypsiric	\N
Gleyic Kastanozem	\N
5Y 8/6 - yellow	\N
PH - Phreatic	\N
5YR 6/6 - reddish yellow	\N
7.9 - 8.4: Moderately alkaline	\N
A - Abundant (40-80%)	\N
Acric	\N
Hydragric Nitisol	\N
Cb - Warm temperate (mesothermal) climates	\N
Sulfidic	\N
Aeolic	\N
Moist - LS, SL, L: 0.4–0.6%	\N
Stagnic	\N
KA = Strong karst	\N
Fragic Retisol	\N
Calcaric Cambisol	\N
M - Moderately well drained - Water is removed from the soil somewhat slowly during some periods of the year. The soils are wet for short periods within rooting depth	\N
Duric Kastanozem	\N
ME - Raised beds (engineering purposes)	\N
Abruptic Retisol	\N
5YR 7/8 - reddish yellow	\N
Retic Podzol	\N
Gleyic Lixisol	\N
Fluvic Gleysol	\N
CS - Coarse sand	\N
OX  - Oxygenated	\N
BI - Infilled large burrows	\N
Ekranic Technosol	\N
Plaggic Planosol	\N
Aeric	\N
10R 4/2 - weak red	\N
FD - Deciduous forest	\N
5YR 8/2 - pinkish white	\N
lPi - Late Pleistocene, ice-covered: commonly recent soil formation on fresh materials.	\N
10R 4/4 - weak red	\N
CV - concave-convexstraight	\N
amphibolite	\N
Eutric Stagnosol	\N
Luvic Gypsisol	\N
Takyric Cambisol	\N
Moist - Other: < 0.3%	\N
V - Very poorly drained - Water is removed so slowly that the soils are wet at shallow depth for long periods. The soils have a very shallow water table	\N
FM - Fine and medium gravel/artefacts	\N
7.5YR 2/4 - very dark brown	\N
Reductic	\N
Glossic Podzol	\N
7.5Y 4/2 - greyish olive	\N
Acric Planosol	\N
Orthods	\N
Anthraquic Luvisol	\N
IP - Flood irrigation	\N
10Y 6/2 - olive grey	\N
fine and very fine	\N
Gypsiric Gleysol	\N
SSS - slightly sticky to sticky -	\N
Mollic Nitisol	\N
7.5YR 6/0 - (light) grey	\N
Pelocrustic	\N
Haplic Plinthosol	\N
Ultisols	\N
WE - Wedge-shaped	\N
Albic Plinthosol	\N
Very fine	\N
Fractic Calcisol	\N
UG2 glacio-fluvial sand	\N
Fluvents	\N
Aeolic Regosol	\N
WE - Weak: Aggregates are barely observable in place and there is only a weak arrangement of natural surfaces of weakness. When gently disturbed, the soil material breaks into a mixture of few entire aggregates, many broken aggregates, and much material without aggregate faces. Aggregate surfaces differ in some way from the aggregate interior.	\N
Medium	\N
Leptic Histosol	\N
Dwc - Snow climates - dry winter, cool short summer	\N
Ccw - Warm temperate (mesothermal) climates - dry winter	\N
OiRa - Rape	\N
Calcaric Leptosol	\N
GB - Gibbsite	\N
Salic Solonetz	\N
Takyric Gypsisol	\N
Petrocalcic	\N
EC - Extremely coarse: Prismatic/columnar/wedgeshaped: > 500 mm	\N
5R 5/4 - weak red	\N
OtPa - Palm (fibres, kernels)	\N
5Y 6/6 - olive yellow	\N
VF - Very fine (< 0.5 mm)	\N
Coarsic Cryosol	\N
10YR 2/1 - black	\N
Dystric Planosol	\N
Nudiargic Acrisol	\N
10R 6/1 - reddish grey	\N
Relocatic Arenosol	\N
VHA - Very hard: Very resistant to pressure; can be broken in the hands only with difficulty.	\N
Leptic Acrisol	\N
Rustic Podzol	\N
HE - Extensive grazing	\N
I - Irregular - Pockets more deep than wide	\N
Calci, Calc	\N
7.5YR 2/0 - black	\N
Endocalcaric Retisol	\N
AP - Angular blocky (parallelepiped)	\N
LU - Lumpy	\N
BR - Burning	\N
M - Moderately widely spaced (0.5 - 2 m)	\N
EF - Climates of perpetual frost (ice-caps)	\N
7.5Y 8/8	\N
Lamellic Acrisol	\N
10YR 7/1 - light grey	\N
Uterquic	\N
HL - hard cemented layer or layers of gypsum (less than 10 cm thick)	\N
Retic Stagnosol	\N
Vertic Cambisol	\N
1 - Less than 1 day	\N
7.5GY 3/2	\N
M - Moderate - Clear evidence of removal of surface horizons. Original biotic functions partly destroyed	\N
WD - Deposition by water	\N
Gibbsic Ferralsol	\N
Luvisol (LV)	\N
Fragloss	\N
Dolomitic Fluvisol	\N
Natric Cryosol	\N
Stagnic Alisol	\N
Geoabruptic	\N
NK - Unknown	\N
Aquents	\N
Thapto	\N
Oxyaquic Gleysol	\N
Sal	\N
Glac, Glacic	\N
vYa - Very young (1-10 years) anthropogeomorphic: with complete disturbance of natural surfaces (and soils), such as in urban, industrial, or mining areas, with very early soil development from fresh natural, technogenic, or mixed materials.	\N
Lixic Durisol	\N
Leptic Alisol	\N
R - Rapid run-off	\N
Alic Stagnosol	\N
A - Wind (aeolian) erosion or deposition	\N
Terric Umbrisol	\N
Lixic Ferralsol	\N
Fragic Alisol	\N
Fluvic	\N
Sodic	\N
acid igneous	\N
Yn - Young (10-100 years) natural: with loss by erosion or deposition of materials such as on tidal flats, coastal dunes, river valleys, landslides, or desert areas.	\N
Skeletic	\N
Skeletic Retisol	\N
Gleyic Arenosol	\N
Bathy	\N
S - south	\N
10YR 4/2 - dark greyish brown	\N
25 - 50 %	\N
Moist - S: > 6%	\N
WG - Gully erosion	\N
Chernic Planosol	\N
7.5YR 6/6 - reddish yellow	\N
ST - Transport	\N
K - Carbonates (calcareous)	\N
Dolomitic Phaeozem	\N
D5.1 - Hemic, degree of decomposition/humification is moderately strong	\N
5Y 3/1 - very dark grey	\N
5G 5/1 - greenish grey	\N
K - Carbonates	\N
Chernic	\N
Vitric Andosol	\N
2.5Y 7/8 - yellow	\N
07 - Strongly sloping (10 - 15 %)	\N
rainwater-fed moor peat	\N
P - Pisolithic: The layer is largely constructed from cemented spherical nodules.	\N
Petrogypsic	\N
10YR 7/2 - light grey	\N
2.5Y 3/2 - very dark greyish brown	\N
Clayic	\N
Alfisols	\N
5Y 4/4 - olive	\N
Mollic Plinthosol	\N
HT - Hyperthermic	\N
10R 6/4 - pale red	\N
Moist - LS, SL, L: < 0.4%	\N
N - north	\N
FoPu - Pumpkins	\N
A - Active at present	\N
Gleyic Solonchak	\N
VS - Vegetation slightly disturbed	\N
W - Wavy - Pockets less deep than wide	\N
Umbric Podzol	\N
Luvic Cryosol	\N
CH - Clay and humus (organic matter)	\N
Sapric Histosol	\N
Db - Cool-humid continental  with cool high-sun season	\N
7.5R 4/4 - weak red	\N
Leptic Retisol	\N
Rendzic Phaeozem	\N
Petroduric Kastanozem	\N
Fe mottles and/or brown Fe concretions, in wet conditions	\N
Calcic Lixisol	\N
GO - Submerged by rising local groundwater less than once a year	\N
Gleyic Gypsisol	\N
10R 5/3 - weak red	\N
M - Medium (2-5 mm) - characterized by the periodic absence of organic matter accumulation on the surface owing to the rapid decomposition process and mixing of organic matter and the mineral soil material by bioturbation. It is usually slightly acid to neutral with a C/N ratio of 10-18.	\N
CS - Clay and sesquioxides	\N
Dolomitic Luvisol	\N
Petronodic	\N
IP - Pore infillings: Including pseudomycelium of carbonates or opal	\N
Calcic Andosol	\N
Abruptic	\N
Relocatic	\N
AT - Tree and shrub cropping	\N
Magnesic	\N
AP2 - Irrigated cultivation	\N
Solimovic	\N
S - Surface (< 2 cm)	\N
Stagnic Phaeozem	\N
sand	\N
Gleyic Podzol	\N
FiJu - Jute	\N
Terric	\N
Terric Alisol	\N
Chernic Gleysol	\N
Pantofluvic Fluvisol	\N
Umbric Nitisol	\N
None	\N
6.1 - 6.5: Slightly acidic	\N
10YR 8/3 - very pale brown	\N
Gypsiric Leptosol	\N
Gypsiric Regosol	\N
10R 3/1 - dark reddish grey	\N
Kan, Kandic	\N
1.1 - Reference profile description - without sampling: No essential elements or details are missing from the description, sampling or analysis. The accuracy and reliability of the description and analytical results permit the full characterization of all soil horizons to a depth of 125 cm, or more if required for classification, or down to a C or R horizon or layer, which may be shallower. Soil description is done without sampling.	\N
SPP - slightly plastic to plastic -	\N
5R 4/3 - weak red	\N
schist	\N
10R 5/2 - weak red	\N
Si - Silt	\N
Folists	\N
Acric Durisol	\N
Stagnic Calcisol	\N
Histic Planosol	\N
Calcaric Gleysol	\N
slate, phyllite (pelitic rocks)	\N
ST - Strong: Aggregates are clearly observable in place and there is a prominent arrangement of natural surfaces of weakness. When disturbed, the soil material separates mainly into entire aggregates. Aggregates surfaces generally differ markedly from aggregate interiors.	\N
F - Fine gravel (0.2 - 0.6 cm)	\N
loam and silt	\N
10R 3/3 - dusky red	\N
Acric Stagnosol	\N
As - Tropical savanna	\N
CL - Clearing	\N
MC - Medium and coarse MV Medium to very coarse	\N
Dry - Other: 6–9%	\N
2.5YR 6/6 - light red	\N
ME - Medium: Granular/platy: 2-5 mm,  Prismatic/columnar/wedgeshaped: 20-50 mm, Blocky/crumbly/lumpy/cloddy: 10-20 mm	\N
Planes	\N
Luvic Kastanozem	\N
YE - Yellow	\N
1 - Reference profile description: No essential elements or details are missing from the description, sampling or analysis. The accuracy and reliability of the description and analytical results permit the full characterization of all soil horizons to a depth of 125 cm, or more if required for classification, or down to a C or R horizon or layer, which may be shallower.	\N
Dry - S: 2–3%	\N
TS - Toe slope	\N
Reductic Planosol	\N
Nudiargic Retisol	\N
Cambic Chernozem	\N
Geric Ferralsol	\N
7.5Y 6/6	\N
LCS - Loamy coarse sand	\N
Mass movement	\N
10YR 7/4 - very pale brown	\N
SL - Synthetic liquid	\N
5R 5/3 - weak red	\N
BD4 - Knife penetrates only 1-2 cm into the moist soil, some effort required, sample disintegrates into few fragments, which cannot be subdivided further - prismatic, platy, (angular blocky) - 1.6-1.8	\N
Petrocalcic Phaeozem	\N
CI - Continuous irregular (non-uniform, heterogeneous): Surface of coating is distinctly smoother or different in colour from the adjacent surface. Fine sand grains are enveloped in the coating but their outlines are still visible. Lamellae are 2-5 mm thick.	\N
Ferralic Lixisol	\N
Pisoplinthic Plinthosol	\N
Anthraquic Acrisol	\N
IN - Intermediate part (talf)	\N
MC - Medium and coarse (> 2 mm)	\N
Dry - S: 8–12%	\N
2.5Y 6/6 - olive yellow	\N
B - Groundwater-fed bog peat	\N
Aridisols	\N
Udults	\N
F - Few	\N
SG - Single grain	\N
F - Medium artefacts (6 - 20 mm)	\N
Duric Phaeozem	\N
BWh - Desert climate Dry-hot	\N
VE - Vegetation strongly disturbed	\N
Arenicolic	\N
Quartz	\N
Reductic Technosol	\N
D1 - Fibric, degree of decomposition/humification is very low	\N
Lu - Semi-luxury Foods and Tobacco	\N
Vermic Chernozem	\N
AA4 - Rainfed arable cultivation	\N
Steep	\N
ilmenite, magnetite, ironstone, serpentine	\N
M - Mass movement	\N
Technic	\N
5YR 2.5/1 - black	\N
Calcic Stagnosol	\N
Alic Cryosol	\N
Pretic Nitisol	\N
10Y 4/2 - olive grey	\N
Alic Umbrisol	\N
M - Medium (2-5 mm)	\N
VPL - Very plastic - Wire formable and can be bent into a ring; moderately strong to very strong force required for deformation of the soil mass.	\N
Entic Podzol	\N
FC - Fine to coarse	\N
IU3 - Ultrabasic igneous: ilmenite, magnetite, ironstone, serpentine	\N
7.5YR 4/6 - strong brown	\N
Alic Podzol	\N
DD - Deciduous dwarf shrub	\N
Duric Vertisol	\N
MO - Organic additions (not specified)	\N
WC3 - No rain in the last 24 hours	\N
LO - Loose: Non-coherent.	\N
Andosol (AN)	\N
UK2 - Unconsolidated: kryogenic periglacial solifluction layer	\N
7.5R 2.5/2 - very dusky red	\N
5BG 5/1 - greenish grey	\N
Carbic Podzol	\N
O - Older, pre-Tertiary land surfaces: commonly high plains, terraces, or peneplains, except incised valleys; frequent occurrence of palaeosoils.	\N
LuTo - Tobacco	\N
Gilgaic	\N
FoHa - Hay	\N
carbonatic, organic	\N
F - Few (2-5%)	\N
Tonguic Chernozem	\N
V - Convex	\N
Nudiargic Alisol	\N
7.5YR 5/6 - strong brown	\N
Ccf - Warm temperate (mesothermal) climates - moist	\N
V - Very wide (5 - 10 cm)	\N
Histosol (HS)	\N
M - Medium (2 - 5 mm)	\N
Vertic	\N
SC - Sandy clay	\N
Endocalcic Phaeozem	\N
Eutric Cambisol	\N
5GY 5/1 - greenish grey	\N
GR - Granular	\N
SSH - soft to slightly hard:	\N
5Y 2.5/1 - black	\N
5R 6/6 - light red	\N
Anthraquic Alisol	\N
T - Tertiary land surfaces: commonly high plains, terraces, or peneplains, except incised valleys; frequent occurrence of palaeosoils.	\N
MB4 - Basic metamorphic: metamorphic limestone (marble)	\N
BD2 - Sample disintegrates into numerous fragments after application of weak single grain, subangular, pressure - single grain, subangular, angular blocky - 1.2-1.4	\N
SSE - south-south-east	\N
Fragic Umbrisol	\N
Someric Kastanozem	\N
Csa - Temperate rainy (humid mesothermal) climate with dry summer With hot summer	\N
White, after oxidation brown: siderite	\N
Chloridic	\N
Stagnic Podzol	\N
Protic Cryosol	\N
HE3 - Ranching	\N
tuff, tuffite	\N
sandstone, greywacke, arkose	\N
Acric Nitisol	\N
Eutric Retisol	\N
PM - Porous massive	\N
2.5YR 3/0 - very dark grey	\N
Haplic Alisol	\N
IP4 - Igneous  pyroclastic ignimbrite	\N
Eutrosilic	\N
HHC - Hard hollow concretions	\N
IB2 - basic  igneous: basalt	\N
Lithic Leptosol	\N
Escalic	\N
Umbric Planosol	\N
SF - Shiny faces (as in nitic horizon)	\N
Nudinatric Solonetz	\N
Anthraquic Lixisol	\N
Chernic Andosol	\N
A - Abundant (40-80 %)	\N
Cambic Leptosol	\N
Pretic Acrisol	\N
YR - Yermic	\N
Acric Podzol	\N
Cambic Calcisol	\N
conglomerate, breccia	\N
UF1 - Unconsolidated: fluvial sand and gravel	\N
I - Imperfectly drained - Water is removed slowly so that the soils are wet at shallow depth for a considerable period	\N
AT4 - Irrigated shrub crop cultivation	\N
90 - 100 %	\N
SO1 - Sedimentary organic: limestone, other carbonate rocks	\N
Hydragric Luvisol	\N
MQ - Duripan	\N
Rhodic Alisol	\N
5Y 7/2 - light grey	\N
2.5YR 2.5/0 - black	\N
MC - Multicoloured	\N
Very gently sloping 	\N
7.5YR 5/0 - grey	\N
5YR 8/3 - pink	\N
Cryods	\N
7.5R 4/2 - weak red	\N
10YR 6/8 - brownish yellow	\N
10Y 6/4	\N
7.5R 3/4 - dusky red	\N
W - Well drained - Water is removed from the soil somewhat slowly during some periods of the year. The soils are wet for short periods within rooting depth	\N
Dry - Other: 4–6%	\N
Hemists	\N
GR - Grey	\N
Placic	\N
SX - Excavations	\N
U - Mull: characterized by the periodic absence of organic matter accumulation on the surface owing to the rapid decomposition process and mixing of organic matter and the mineral soil material by bioturbation. It is usually slightly acid to neutral with a C/N ratio of 10-18.	\N
Ustands	\N
Folic Leptosol	\N
Dsa - Snow climates - dry summer, hot	\N
5Y 8/1 - white	\N
2.5Y 7/4 - pale yellow	\N
C - Common (5-15%)	\N
7.5Y 7/8	\N
Gleyic Ferralsol	\N
Vitric Podzol	\N
WC6 - Extremely rainy time or snow melting	\N
Cc - Warm temperate (mesothermal) climates	\N
A - Tropical (rainy) climates	\N
5Y 4/2 - olive grey	\N
2.5Y 6/4 - light yellowish brown	\N
gneiss, migmatite	\N
Endoleptic	\N
Orthels	\N
Someric Phaeozem	\N
Gyps, Gypsic	\N
Dolomitic Stagnosol	\N
PN - Nature and game preservation	\N
Epi	\N
GY - Gypsum (gypsiferous)	\N
VFF - Very friable to friable:	\N
7.5Y 6/4	\N
Plac, Placic	\N
5YR 7/4 - pink	\N
P - Platy: The compacted or cemented parts are platelike and have a horizontal or subhorizontal orientation.	\N
09 - Steep (30 - 60 %)	\N
SC - Surface compaction	\N
Mollic Stagnosol	\N
RoSu - Sugar beets	\N
Moist - S: 3–6%	\N
DC - Discontinuous circular: Elongated voids of faunal or floral origin, mostly tubular in shape and continuous, varying strongly in diameter. When wider than a few centimetres (burrow holes), they are more adequately described under biological activity.	\N
2 - Moderate (15 - 40 %)	\N
7.4 - 7.8: Slightly alkaline	\N
S - Sharp (< 0.5 mm)	\N
Yermic Durisol	\N
LuTe - Tea	\N
Vitric	\N
Irragric Planosol	\N
ST - Strongly salty (4 - 8 dS m-1)	\N
Fulv	\N
W - west	\N
OiOp - Oil-palm	\N
HC - Heavy clay	\N
FVF - Firm to very firm:	\N
LuCo - Coffee	\N
W - Wet	\N
EH - Hunting and fishing	\N
1 - Low (2 - 15 %)	\N
5G 4/1 - dark greenish grey	\N
basic igneous	\N
Durinodic	\N
Aquods	\N
Fragic Lixisol	\N
VM - Vegetation moderately disturbed	\N
YB - Yellowish brown	\N
WR - Rill erosion	\N
03 - Nearly level (0.5 - 1.0 %)	\N
Moist - S: 0.6–0.9%	\N
Thionic Gleysol	\N
BO - Bottom (flat)	\N
B - Dry	\N
7.5R 3/0 - very dark grey	\N
Cohesic	\N
LP - Plain (< 10 %)	\N
V - Very hard	\N
SV1: < 3 %	\N
Subaquatic Cryosol	\N
Moist - S: 0.3–0.6%	\N
HI - Higher part (rise)	\N
SE2 - Evaporites: halite	\N
BD3 - Knife can be pushed into the moist soil with weak pressure, sample disintegrates into few fragments, which may be further divided - subangular and angular blocky, prismatic, platy - 1.4-1.6	\N
Pu - Pulses	\N
7.5Y 4/0	\N
Anthromollic Podzol	\N
SS - Semi-deciduous shrub	\N
UO2 - Unconsolidated: organic groundwater-fed bog peat	\N
10R 3/2 - dusky red	\N
Hydragric Acrisol	\N
E - Extremely wide (> 10 cm)	\N
Calcaric Arenosol	\N
SH - Medium-gradient hill (10 - 30 %)	\N
7.5YR 6/4 - light brown	\N
10Y 8/10	\N
2-5 m	\N
4 - Dominant (> 80 %)	\N
M - marl layer	\N
Albolls	\N
Siltic	\N
SL - Sleet	\N
eolian	\N
Gleyic Regosol	\N
Coarsic Podzol	\N
glacial	\N
F - Forestry	\N
Lixic	\N
TV - High-gradient valley (> 30 %)	\N
10YR 5/2 - greyish brown	\N
SC - Soft concretion	\N
10Y 3/1 - olive	\N
10R 3/6 - dark red	\N
M - Rainwater-fed moor peat	\N
LVFS - Loamy very fine sand	\N
UL1 - Unconsolidated: lacustrine sand	\N
Fluvic Planosol	\N
IB - Border irrigation	\N
7.5R 3/2 - dusky red	\N
Dry - LS, SL, L: 4–6%	\N
2.5YR 3/2 - dusky red	\N
Anthraquic	\N
IP2 - Igneous  pyroclastic volcanic scoria/breccia	\N
AA4M - Mechanized traditional rainfed arable cultivation	\N
G - Gradual (5-15 cm)	\N
OG - Organic garbage	\N
Phaeozem (PH)	\N
S - Sulphur (sulphurous)	\N
Tonguic Kastanozem	\N
Toxic	\N
Argids	\N
Pellic Vertisol	\N
IU - Irrigation (not specified)	\N
Fibr	\N
10YR 4/6 - dark yellowish brown	\N
4.5 - 5.0: Very strongly acidic	\N
5R 4/2 - weak red	\N
PD - Degradation control	\N
Ferritic Ferralsol	\N
M - Medium gravel (6 - 20 mm)	\N
SI - Industrial use	\N
AA - Annual field cropping	\N
Cryosol (CR)	\N
IF - Furrow irrigation	\N
SCL - Sandy clay loam	\N
Stagnic Retisol	\N
Skeletic Cryosol	\N
Histic Andosol	\N
VC - Very coarse (20-50 mm).	\N
SX - Xeromorphic shrub	\N
lPp - Late Pleistocene, periglacial: commonly recent soil formation on preweathered materials.	\N
Yermic Solonetz	\N
Shallow (30-50 cm)	\N
Gypsic Leptosol	\N
F - Fine (<  1 cm)	\N
AP - Perennial field cropping	\N
SD - Deciduous shrub	\N
2.5Y 7/6 - yellow	\N
Chernozem (CH)	\N
Gleyic Retisol	\N
R - Raw humus (aeromorphic mor: usually thick (5-30 cm) organic matter accumulation that is largely unaltered owing to lack of decomposers. This kind of organic matter layer develops in extremely nutrient-poor and coarsetextured soils under vegetation that produces a litter layer that is difficult to decompose. It is usually a sequence of Oi-Oe-Oa layers over a thin A horizon, easy to separate one layer from another and being very acid with a C/N ratio of > 29.	\N
Hydric Andosol	\N
Haplic Acrisol	\N
DS - Semi-deciduous dwarf shrub	\N
AN - Anthraquic	\N
Neobrunic Retisol	\N
5YR 4/6 - yellowish red	\N
UG3 - Unconsolidated: glacio-fluvial gravel	\N
5G 7/2 - pale green	\N
Fluvic Stagnosol	\N
Coarsic Technosol	\N
WX - Xeromorphic woodland	\N
Profundihumic Ferralsol	\N
Af - Tropical rainforest - moist	\N
7.5GY 7/6	\N
CH - Primary mineral fragments: quartz	\N
Haplic Calcisol	\N
ST - Sticky - After pressure, soil material adheres to both thumb and finger and tends to stretch somewhat and pull apart rather than pulling free from either digit.	\N
Mahic	\N
Xerults	\N
Calcic Kastanozem	\N
E - Extraction and collection	\N
UU2 - Unconsolidated  unspecifiedloam and silt	\N
C - Continuous: Surface of coating shows only little contrast in colour, smoothness or any other property to the adjacent surface. Fine sand grains are readily apparent in the cutan. Lamellae are less than 2 mm thick.	\N
S - Slightly hard	\N
5Y 6/2 - light olive grey	\N
DE - Dendroidal: Mostly irregular, equidimensional voids of faunal origin or resulting from tillage or disturbance of other voids. Discontinuous or interconnected. May be quantified in specific cases.	\N
AT3 - Non-irrigated shrub crop cultivation	\N
Ro - Roots and Tubers	\N
Petroduric Vertisol	\N
BR - Brown	\N
DU = Dune-shaped	\N
P - Poorly drained - Water is removed so slowly that the soils are commonly wet for considerable periods. The soils commonly have a shallow water table	\N
SB - Subangular blocky	\N
LFS - Loamy fine sand	\N
MN - Manganese	\N
CU - Cuesta-shaped	\N
Pretic Anthrosol	\N
Poly	\N
UM1 - Unconsolidated: marine sand	\N
Udepts	\N
Coarsic Durisol	\N
F - Flat	\N
Level	\N
Pretic Ferralsol	\N
7.5Y 5/2 - greyish olive	\N
Fragic Acrisol	\N
No redoximorphic characteristics at permanently high potentials	\N
5YR 4/3 - reddish brown	\N
7.5R 5/6 - red	\N
V - Very fine (< 0.5 mm) - Usually thick (5-30 cm) organic matter accumulation that is largely unaltered owing to lack of decomposers. This kind of organic matter layer develops in extremely nutrient-poor and coarsetextured soils under vegetation that produces a litter layer that is difficult to decompose. It is usually a sequence of Oi-Oe-Oa layers over a thin A horizon, easy to separate one layer from another and being very acid with a C/N ratio of > 29.	\N
Orth	\N
01 - Flat (0 - 0.2 %)	\N
Skeletic Kastanozem	\N
Histic Stagnosol	\N
5Y 8/8 - yellow	\N
Limonic	\N
MT - Tidal area (between mean low and mean high water springs)	\N
5Y 6/1 - (light) grey	\N
F - Iron	\N
Hemic Histosol	\N
7.5Y 6/2 - greyish olive	\N
U - Not used and not managed	\N
Irragric Vertisol	\N
Well drained	\N
Aquolls	\N
VC - convex-concave	\N
10R 6/2 - pale red	\N
Spolic Technosol	\N
FP - Permanently submerged by inland water	\N
VFI - Very firm: Soil material crushes under strong pressures; barely crushable between thumb and forefinger.	\N
UK1 -  Unconsolidated  kryogenic periglacial rock debris	\N
7.5YR 5/2 - brown	\N
SV - straight-convex	\N
7.5GY 4/2	\N
Hydr, Hydric	\N
Leptic Gypsisol	\N
L - Large boulders (60 - 200 cm)	\N
10Y 7/2 - light grey	\N
Andic Leptosol	\N
FR - Frigid	\N
Bryic	\N
Calcaric Gypsisol	\N
Am - Tropical rainforest short dry season	\N
Andic Podzol	\N
Stagnic Gleysol	\N
5R 3/3 - dusky red	\N
Gelistagnic	\N
Regosol (RG)	\N
PQ - Peraquic	\N
S - Somewhat excessively well drained - Water is removed from the soil rapidly	\N
Skeletic Calcisol	\N
Natr, Natric	\N
sedimentary rock (consolidated)	\N
Nechic	\N
Gypsic Andosol	\N
gravel, broken rock	\N
SC - Soft concretions	\N
Pretic Gleysol	\N
Plaggic Retisol	\N
Somb, Sombric	\N
sedimentary rock (unconsolidated)	\N
Rill erosion	\N
Differentic	\N
2.5Y 3/0 - very dark grey	\N
Yermic Lixisol	\N
Eutric Gleysol	\N
SV2: 3 - 5 %	\N
Plinthosol (PT)	\N
2.5YR 5/4 - reddish brown	\N
Leptic Plinthosol	\N
IP3 - Igneous: pyroclastic volcanic ash	\N
Profondic	\N
serpentinite, greenstone	\N
GY - Gypsum	\N
Chromic Luvisol	\N
Retic Cryosol	\N
6.6 - 7.3: Neutral	\N
C - Coarse artefacts (> 20 mm)	\N
Terric Acrisol	\N
> 50	\N
E - Elongated	\N
Protospodic	\N
GI - Gilgai	\N
AS - Shifting sands	\N
7.5YR 4/0 - dark grey	\N
Histic Cryosol	\N
Alic	\N
Umbric Stagnosol	\N
Cambic Kastanozem	\N
AT2 - Irrigated tree crop cultivation	\N
Solonchak (SC)	\N
SK - Skeletic	\N
Geric	\N
coals, bitumen and related rocks	\N
5Y 8/2 - white	\N
5R 6/4 - pale red	\N
2.5YR 4/8 - red	\N
5B 5/1 - bluish grey	\N
Pretic	\N
SP - Slickensides, partly intersecting	\N
7.5YR 7/0 - light grey	\N
HE2 - Semi-nomadism	\N
CeRy - Rye	\N
Sheet erosion	\N
PuBe - Beans	\N
Andic Technosol	\N
Retic Planosol	\N
Gleyic Anthrosol	\N
10Y 8/1 - light grey	\N
IM - With intermontane plains (occupying > 15%)	\N
Acrisol (AC)	\N
Dbf - Cool-humid continental  with cool high-sun season - moist	\N
7.5GY 5/6	\N
CL - Cloddy	\N
7.5R 6/0 - grey	\N
M - Mechanical	\N
Skeletic Lixisol	\N
Dry - S: 1–1.5%	\N
MA2 - Acid metamorphic: gneiss, migmatite	\N
T - Termite or ant channels and nests	\N
FoMa - Maize	\N
M - Medium (2 - 10 cm)	\N
Anthraquic Nitisol	\N
Anofluvic Fluvisol	\N
MB2 - Basic metamorphic:  (green)schist	\N
Alisol (AL)	\N
Vermic Regosol	\N
Drainic Histosol	\N
Dry - LS, SL, L: 6–9%	\N
7.5YR 7/6 - reddish yellow	\N
B - Biennually	\N
7.5YR 5/4 - brown	\N
Calcaric Stagnosol	\N
L - Large boulders (> 600 mm)	\N
N - None - Roots with diameters < 2 mm: 0, Roots with diameters > 2 mm: 0.	\N
FE - Primary mineral fragments: feldespar	\N
SC2 - Clastic sediments: sandstone, greywacke, arkose	\N
0	\N
I - igneous rock	\N
Dry - S: 0.6–1%	\N
D - Dwarf Shrub	\N
clastic sediments	\N
BU - Blue	\N
2.5YR 6/2 - pale red	\N
Leptic Solonchak	\N
BL - Black	\N
Takyric Lixisol	\N
C - Warm temperate (mesothermal) climates	\N
Dur	\N
WSW - west-south-west	\N
A - Coarse (> 20 mm)	\N
Dry - LS, SL, L: < 0.5%	\N
7.5Y 6/0	\N
7.5R 5/2 - weak red	\N
2.5Y 2/0 - black	\N
D3 - Fibric, degree of decomposition/humification is moderate	\N
Sideralic Arenosol	\N
7.5Y 2.5/0	\N
S - Straight	\N
MO - Moderately salty (2 - 4 dS m-1)	\N
Gypsiric Durisol	\N
Terric Luvisol	\N
SR - Residential use	\N
SC3 - Clastic sediments: silt-, mud-, claystone	\N
Dcw - Subarctic climate - dry winter	\N
MI - Mine (surface, including openpit, gravel and quarries)	\N
20 - 30 %	\N
Solimovic Arenosol	\N
U - sedimentary rock (unconsolidated)	\N
W - Weekly	\N
10YR 5/6 - yellowish brown	\N
Chromic Acrisol	\N
Skeletic Fluvisol	\N
Vertic Luvisol	\N
Mollic Cryosol	\N
FrMa - Mangoes	\N
Mollic	\N
Glossic	\N
SV4: 8 - 12 %	\N
VU - Vegetation disturbed (not specified)	\N
7.5R 5/8 - red	\N
7.5YR 3/0 - very dark grey	\N
Biocrustic	\N
7.5R 6/4 - pale red	\N
C - Clear (2-5 cm)	\N
Acroxic	\N
Tidalic Cryosol	\N
UE1 - Unconsolidated: eolian loess	\N
Blue-green to grey colour; Fe2+ ions always present	\N
Calcic Leptosol	\N
FSL - Fine sandy loam	\N
MB5 - Basic metamorphic  amphibolite	\N
Dbs - Cool-humid continental  with cool high-sun season - dry season in summer	\N
10YR 3/3 - dark brown	\N
7.5R 6/2 - pale red	\N
Glossic Planosol	\N
Very shallow (< 30 cm)	\N
5R 2.5/4 - very dusky red	\N
Flat	\N
groundwater-fed bog peat	\N
7.5GY 5/2	\N
2.5Y 7/0 - light grey	\N
Calcic Retisol	\N
04 - Very gently sloping (1.0 - 2.0 %)	\N
V - Very deep (> 20 cm)	\N
periglacial solifluction layer	\N
N 6/ - (light) grey	\N
B - Both hard and soft	\N
Oi - Oilcrops	\N
5R 5/2 - weak red	\N
SA - Salt (saline)	\N
LA - Lamellae (clay bands)	\N
Tsitelic Arenosol	\N
7.5Y 7/6	\N
D - Distinct: Surface of coating is distinctly smoother or different in colour from the adjacent surface. Fine sand grains are enveloped in the coating but their outlines are still visible. Lamellae are 2-5 mm thick.	\N
colluvial	\N
10YR 5/8 - yellowish brown	\N
Chromic Vertisol	\N
Hypersalic	\N
FrBa - Bananas	\N
fluvial	\N
PH - Horizontal pedfaces	\N
Gypsids	\N
T - Steep land (> 30 %)	\N
D - Distinct: Although not striking, the mottles are readily seen. The hue, chroma and value of the matrix are easily distinguished from those of the mottles. They may vary by as much as 2.5 units of hue or several units in chroma or value.	\N
7.5Y 5/0	\N
WC1 - No rain in the last month	\N
Fluvic Umbrisol	\N
5YR 6/3 - light reddish brown	\N
Hyperartefactic	\N
LD - Depression (< 10 %)	\N
P - Ploughing	\N
5R 4/6 - red	\N
S - Slightly moist	\N
IP1 - Igneous  pyroclastic tuff, tuffite	\N
E - Excessively well drained - Water is removed from the soil very rapidly	\N
Haplic Ferralsol	\N
Eutric Leptosol	\N
Xerolls	\N
F - Faint: Surface of coating shows only little contrast in colour, smoothness or any other property to the adjacent surface. Fine sand grains are readily apparent in the cutan. Lamellae are less than 2 mm thick.	\N
Hum, Humic	\N
Vitric Gleysol	\N
Leptic Fluvisol	\N
Vermic Phaeozem	\N
RS - Reddish	\N
Sideralic Nitisol	\N
Mawic Histosol	\N
V - Very fine (< 2 mm)	\N
7.5R 3/6 - dark red	\N
Greyzemic Phaeozem	\N
metamorphic rock	\N
Petrogypsic Durisol	\N
Aeolic Arenosol	\N
Stagnic Solonchak	\N
redeposited natural material	\N
WC - Worm casts	\N
Lixic Nitisol	\N
7.5GY 7/10	\N
Gleyic Acrisol	\N
10Y 7/4	\N
CeMa - Maize	\N
7.5Y 3/2 - olive black	\N
30 - 40 %	\N
Entisols	\N
FM - Fine and medium	\N
SO - Sodic	\N
Petroduric Planosol	\N
5GY 7/1 - light greenish grey	\N
Reductic Stagnosol	\N
Duric Chernozem	\N
UU1 - Unconsolidated: unspecified deposits clay	\N
Takyric Durisol	\N
W - Weathered: Partial weathering is indicated by discoloration and loss of crystal form in the outer parts of the fragments while the centres remain relatively fresh and the fragments have lost little of their original strength.	\N
Dystr, Dys	\N
CeSo - Sorghum	\N
Moist - S: < 0.3%	\N
Abruptic Alisol	\N
UC1 - Unconsolidated: colluvial slope deposits	\N
Epidystric	\N
Anthraquic Andosol	\N
FrMe - Melons	\N
AB - Angular blocky	\N
F - Thin (< 2 mm)	\N
Litholinic	\N
P - Ponded (run-on site)	\N
7.5YR 6/2 - pinkish grey	\N
Haplic Phaeozem	\N
No evidence of erosion	\N
Dolomitic Regosol	\N
Gibbsic	\N
10YR 4/1 - dark grey	\N
Fragic Luvisol	\N
NE - north-east	\N
Pretic Umbrisol	\N
diorite	\N
5G 6/2 - pale green	\N
Dfb - Snow climates - moist all seasons, warm summer	\N
UU3 - Unconsolidated: unspecified sand	\N
10YR 5/4 - yellowish brown	\N
5R 2.5/2 - very dusky red	\N
Das - Cool-humid continental climate with warm high-sun season - dry season in summer	\N
Thionic	\N
Dystric Arenosol	\N
Ds - Cold snow-forest climate - summer dry	\N
NNW - north-north-west	\N
5R 3/1 - dark reddish grey	\N
S - Sesquioxides	\N
Skeletic Acrisol	\N
Xanthic Acrisol	\N
EX - Extremely gypsiric (> 60%)	\N
3 - Medium (5-15%)	\N
CS - concave-straight	\N
Fragic	\N
Fluv	\N
UF - Submerged by inland water of unknown origin at least once a year	\N
Moist - S: 1.5–3%	\N
Hortic Planosol	\N
Lamellic	\N
5G 4/2 - greyish green	\N
Anthraquic Gleysol	\N
MP - Plaggen	\N
CeOa - Oats	\N
Aquults	\N
5Y 5/2 - olive grey	\N
7.5GY 3/0	\N
Ornithic	\N
Inclinic	\N
Dominant	\N
Irragric Gleysol	\N
C - Coarse gravel (20 - 60 mm)	\N
Histic Podzol	\N
BSh - Steppe climate Dry-hot	\N
F - Fine (2-6 mm)	\N
5R 5/6 - red	\N
Moist - Other: 0.9–1.5%	\N
5YR 6/8 - reddish yellow	\N
M - metamorphic rock	\N
Calcic Luvisol	\N
Fluvic Kastanozem	\N
Tidalic Fluvisol	\N
C - Channels: Elongated voids of faunal or floral origin, mostly tubular in shape and continuous, varying strongly in diameter. When wider than a few centimetres (burrow holes), they are more adequately described under biological activity.	\N
7.5GY 2.5/0	\N
Water erosion or deposition	\N
Petric Durisol	\N
SE - Evergreen shrub	\N
PD1 - Without interference	\N
AA3 - Ley system cultivation	\N
Gully erosion	\N
Cryids	\N
Moist - Other: 0.6–0.9%	\N
10YR 8/1 - white	\N
B - Broken: The layer is less than 50 percent cemented or compacted, and shows a rather irregular appearance.	\N
2.5YR 5/8 - red	\N
10YR 8/8 - yellow	\N
Xanthic	\N
ME - Mesic	\N
Lamellic Lixisol	\N
C - Concave	\N
5G 6/1 - greenish grey	\N
Tephric Arenosol	\N
SI - Slickensides, predominantly intersecting: Slickensides are polished and grooved ped surfaces that are produced by aggregates sliding one past another.	\N
Plaggic Alisol	\N
Xer	\N
W - Widely spaced (2 - 5 m)	\N
Takyric Leptosol	\N
Anthraquic Planosol	\N
SE - Medium-gradient escarpment zone (10 - 30 %)	\N
5B 4/1 - dark bluish grey	\N
7.5Y 8/2 - light grey	\N
10R 5/6 - red	\N
basic metamorphic	\N
Skeletic Gypsisol	\N
Histic Fluvisol	\N
Abruptic Luvisol	\N
R - Rounded	\N
5Y 6/3 - pale olive	\N
Petrosalic Solonchak	\N
7.5GY 7/8	\N
Wapnic	\N
Dwb - Snow climates - dry winter, warm summer	\N
7.5R 6/6 - light red	\N
Histic Retisol	\N
Pretic Podzol	\N
UF2 - Unconsolidated: fluvial clay, silt and loam	\N
PC - Partly cloudy	\N
Greyzemic Chernozem	\N
SN - Nutty subangular blocky	\N
WT - Tunnel erosion	\N
Gypsiric Cambisol	\N
TE - Terracing	\N
Irragric Anthrosol	\N
marine, estuarine	\N
Leptic Kastanozem	\N
Lamellic Alisol	\N
OiSe - Sesame	\N
Hortic Podzol	\N
O - Other	\N
IN - Inselberg covered (occupying > 1% of level land)	\N
Ustolls	\N
Protic Arenosol	\N
organic	\N
PU - Perudic	\N
Anthric	\N
kryogenic	\N
Ferric Luvisol	\N
Lithic	\N
Torrands	\N
fine and medium	\N
Densic	\N
Aw - Tropical savanna	\N
NNE - north-north-east	\N
diorite-syenite	\N
5 - 10 %	\N
10Y 8/8	\N
D - Dry: Crushing: makes no dust. Forming (to a ball): not possible, seems to be warm. Moistening: going dark. Rubbing (in the hand): hardly lighter. pF: 4.	\N
M - Many (15-40%)	\N
S - Slightly moist: Crushing: makes no dust. Forming (to a ball):  possible (not sand). Moistening: going slightly dark. Rubbing (in the hand): obviously lighter. pF: 3.	\N
Q - Silica	\N
IA3 - Acid igneous: quartz-diorite	\N
AA1 - Shifting cultivation	\N
MC - Medium and coarse gravel/artefacts	\N
MP - Agropastoralism	\N
Gleyic Planosol	\N
UG2 - Unconsolidated: glacio-fluvial sand	\N
> 50 m	\N
CO - Coarse / thick: Granular/platy: 5-10 mm,  Prismatic/columnar/wedgeshaped: 50-100 mm, Blocky/crumbly/lumpy/cloddy: 20-50 mm	\N
FoAl - Alfalfa	\N
Cwc - Warm Temperate - dry winter, cool short summer	\N
SC1 - Clastic sediments: conglomerate, breccia	\N
Gypsisol (GY)	\N
Vertic Stagnosol	\N
Fine	\N
Gypsic Kastanozem	\N
C - Common (5 - 15 %)	\N
R - Residual rock fragment: Discrete impregnated body still showing rock structure	\N
Petroduric Andosol	\N
7.5R 6/8 - light red	\N
CS - Very coarse and coarse sand	\N
Umbric Ferralsol	\N
7.5GY 8/8	\N
2.5YR 4/6 - red	\N
3.5 - 4.4: Extremely acidic	\N
7.5YR 8/0 - white	\N
Salt deposition	\N
Subaquatic Leptosol	\N
X - Complex (irregular)	\N
Isopteric	\N
Mollic Andosol	\N
Tephric	\N
HM - Medium grassland	\N
BU - Bunding	\N
Dystric Durisol	\N
basalt	\N
10Y 7/1 - light grey	\N
H - Mountain/Highland climates	\N
SE1 - Evaporites: anhydrite, gypsum	\N
L - Loam	\N
S - Severe - Surface horizons completely removed and subsurface horizons exposed. Original biotic functions largely destroyed	\N
Dystric	\N
ironstone	\N
5GY 4/1 - dark greenish grey	\N
Cambids	\N
5Y 6/4 - pale olive	\N
V - Very few - The number of very fine pores (< 2 mm) per square decimetre is 1-20, the number of medium and coarse pores (> 2 mm) per square decimetre is 1-2.	\N
SA  - Saline	\N
Ruptic	\N
Hortic Phaeozem	\N
AA4I - Improved traditional rainfed arable cultivation	\N
Skeletic Plinthosol	\N
Psamm	\N
IC - Crack infillings	\N
BS - Brownish	\N
C - Clear (0.5-2 mm)	\N
2.5YR 5/6 - red	\N
7.5GY 8/6	\N
Moist - LS, SL, L: 1–2%	\N
5–10	\N
Luvic Planosol	\N
Panpaic	\N
SA - Salic	\N
10R 6/6 - light red	\N
5R 6/8 - light red	\N
FI - Fine/thin: Granular/platy: 1-2 mm,  Prismatic/columnar/wedgeshaped: 10-20 mm, Blocky/crumbly/lumpy/cloddy: 5-10 mm	\N
B - Vesicular: Discontinuous spherical or elliptical voids (chambers) of sedimentary origin or formed by compressed air, e.g. gas bubbles in slaking crusts after heavy rainfall. Relatively unimportant in connection with plant growth.	\N
Acric Umbrisol	\N
Tidalic Regosol	\N
Luvic Phaeozem	\N
Dystric Leptosol	\N
RoPo - Potatoes	\N
ST - Strongly gypsiric (15-60%) - Higher amounts may be differentiated by abundance of H2O-soluble pseudomycelia/crystals and soil colour.	\N
10YR 7/8 - yellow	\N
AA4U - Unspecified rainfed arable cultivation	\N
LO - Lower part (and dip)	\N
S - Sulphurous - Presence of H2S (hydrogen sulphide; "rotten eggs"); commonly associated with strongly reduced soil containing sulphur compounds.	\N
Kastanozem (KS)	\N
N 2/ - black	\N
7.5Y 8/0	\N
Gelic	\N
Torrox	\N
VC - Very coarse / thick: Granular/platy: > 10 mm,  Prismatic/columnar/wedgeshaped: 100-500 mm, Blocky/crumbly/lumpy/cloddy: > 50 mm	\N
0.11 - 0.17 g cm-3	\N
A - Crop agriculture (cropping)	\N
Vitric Histosol	\N
Nudiargic Luvisol	\N
Floatic Histosol	\N
Ferralic Acrisol	\N
CR - Crumbly	\N
7.5GY 5/4	\N
Cryalfs	\N
D - Deep (10 - 20 cm)	\N
10Y 8/4	\N
eclogite	\N
P - Nature protection	\N
E - Extremely hard	\N
Cutanic	\N
GE - Gelundic	\N
ENE - east-north-east	\N
SW - south-west	\N
Albic Lixisol	\N
Anionic	\N
TM - High-gradient mountain (> 30 %)	\N
5YR 5/2 - reddish grey	\N
5Y 7/8 - yellow	\N
TO - Torric	\N
Few	\N
70 - 80 %	\N
BWn - Desert climate -frequent fog	\N
5R 3/6 - dark red	\N
CR - Cryic	\N
5GY 6/1 - greenish grey	\N
5Y 5/4 - olive	\N
Technosol (TC)	\N
Yermic Luvisol	\N
MS - Mine spoil or crude oil	\N
2.5Y 5/2 - greyish brown	\N
Pretic Alisol	\N
Claric	\N
Ustepts	\N
SS - straight-straight	\N
3 - Moderately deep (50-100 cm)	\N
Hyperalic	\N
Dds - Subarctic with very cold low-sun season - dry season in summer	\N
sand and gravel	\N
Plaggic Stagnosol	\N
Muusic Histosol	\N
7.5Y 8/4	\N
5YR 7/2 - pinkish grey	\N
C - Concretion: A discrete body with a concentric internal structure, generally cemented	\N
N - Period of activity not known	\N
Very coarse	\N
RA - Rain	\N
5YR 5/4 - reddish brown	\N
halite	\N
05 - Gently sloping (2 - 5 %)	\N
gabbro	\N
Lamellic Luvisol	\N
Gelands	\N
Cw - Mild temperate rainy climate - winter dry	\N
Gloss, Glossic	\N
7.5YR 7/4 - pink	\N
Ustalfs	\N
Vitric Cambisol	\N
MA4 - Acid metamorphic: schist	\N
Haplic Chernozem	\N
10R 5/4 - weak red	\N
Anthraquic Stagnosol	\N
Novic	\N
Vertic Kastanozem	\N
Calcic Gleysol	\N
10R 2.5/2 - very dusky red	\N
FX - Xeromorphic forest	\N
7.5GY 6/8	\N
Subaquatic Technosol	\N
Rhodic Lixisol	\N
FR - Friable: Soil material crushes easily under gentle to moderate pressure between thumb and forefinger, and coheres when pressed together.	\N
Eutric Arenosol	\N
5R 2.5/1 - reddish black	\N
Gleyic Luvisol	\N
Hydragric Cambisol	\N
Luvic Calcisol	\N
V - Very few (0-2%)	\N
Vughs	\N
Gleyic Stagnosol	\N
2.5Y 6/0 - (light) grey	\N
M - Medium gravel (0.6 - 2 cm)	\N
igneous rock	\N
W - Wide (2 - 5 cm)	\N
Coarsic Histosol	\N
Histic	\N
Histosols	\N
Coarsic Gypsisol	\N
Skeletic Alisol	\N
Tidalic Arenosol	\N
Brunic Leptosol	\N
Coarsic Plinthosol	\N
C - Coarse gravel (2 - 6 cm)	\N
7.5GY 8/0	\N
slope deposits	\N
MA1 - Acid metamorphic: quartzite	\N
MC - Medium and coarse (2-20 mm).	\N
Luvic Umbrisol	\N
FC - Coniferous forest	\N
Calcids	\N
Ve - Vegetables	\N
Dry - Other: 1.2–2%	\N
clay and silt	\N
7.5YR 3/2 - dark brown	\N
Leptic Stagnosol	\N
Plaggic Anthrosol	\N
10Y 6/6	\N
Moll	\N
Isolatic	\N
Leptic Lixisol	\N
Wapnic Cryosol	\N
PN2 - Parks	\N
F - Once every 2-4 years	\N
SB - Stones and boulders	\N
Glossic Phaeozem	\N
ID - Drip irrigation	\N
Xanthic Lixisol	\N
Plinthic Gleysol	\N
Dry - S: 3–5%	\N
10R 4/6 - red	\N
Gypsic	\N
Petric Calcisol	\N
TH - High-gradient hill (> 30 %)	\N
SL - Slightly gypsiric (0-5%) - EC = < 1.8 dS m-1 in 10 g soil/250 ml H2O	\N
Leptic Phaeozem	\N
Folic	\N
Gleyic Cambisol	\N
MS - Sand additions	\N
5BG 7/1 - light greenish grey	\N
Hydragric Vertisol	\N
Protogypsic	\N
MA - Massive	\N
Hal, Halic	\N
10YR 3/1 - very dark grey	\N
N 2.5/ - black	\N
BP - Borrow pit	\N
10YR 5/3 - brown	\N
Anthr	\N
7.5GY 7/4	\N
10YR 5/1 - grey	\N
Tidalic Leptosol	\N
CeBa - Barley	\N
Pale	\N
Solimovic Regosol	\N
Ot - Other Crops	\N
Mochipic	\N
Histic Plinthosol	\N
Glossic Umbrisol	\N
YR - Yellowish red	\N
LL - Plateau (< 10 %)	\N
Umbric Cryosol	\N
Cwb - Warm Temperate - dry winter, warm summer	\N
HL - hard cemented layer or layers of carbonates (less than 10 cm thick)	\N
Ust	\N
FM - Iron-manganese (sesquioxides)	\N
Leptic Umbrisol	\N
2.5Y 6/8 - olive yellow	\N
Stagnic Fluvisol	\N
Mollisols	\N
Moderately steep	\N
W - Weakly cemented: Cemented mass is brittle and hard, but can be broken in the hands.	\N
Tunnel erosion	\N
Oxyaquic Cryosol	\N
Wind (aeolian) erosion or deposition	\N
SL - Slightly calcareous (0-2%) - Audible effervescence but not visible.	\N
Terric Cambisol	\N
Nitric	\N
SHH - slightly hard to hard:	\N
FN - Natural forest and woodland	\N
oPf - Older Pleistocene, without periglacial influence.	\N
Cambic Durisol	\N
TE - High-gradient escarpment zone (> 30 %)	\N
BR  - Brackish	\N
CF - Coarse fragments	\N
Hortic Stagnosol	\N
Thionic Histosol	\N
Hortic Umbrisol	\N
G - "gazha" (clayey water-saturated layer with high gypsum content)	\N
N - None (0%)	\N
Lixic Umbrisol	\N
Df - Cold snow-forest climate - humid winters	\N
< 0.04 g cm-3	\N
Turb	\N
F - Fresh or slightly weathered: Fragments show little or no signs of weathering.	\N
Leptic Planosol	\N
F - Iron (ferruginous)	\N
Pretic Luvisol	\N
SP - Dissected plain (10 - 30 %)	\N
Vertic Planosol	\N
peridotite	\N
10–25	\N
N - None	\N
Mulmic	\N
S - Soft segregation (or soft accumulation): Differs from the surrounding soil mass in colour and composition but is not easily separated as a discrete body	\N
7.5GY 5/0	\N
Andic Durisol	\N
SVS - sticky to very sticky -	\N
5G 5/2 - greyish green	\N
Takyric Luvisol	\N
SC - Recreational use	\N
Y - Compacted but non-cemented: Compacted mass is appreciably harder or more brittle than other comparable soil mass (slakes in water).	\N
Dolomitic Arenosol	\N
Umbric Andosol	\N
Fi - Fibre Crops	\N
Hem	\N
2.5YR 3/6 - dark red	\N
4 - Soil augering description: Soil augerings do no permit a comprehensive soil profile description. Augerings are made for routine soil observation and identification in soil mapping, and for that purpose normally provide a satisfactory indication of the soil characteristics. Soil samples may be collected from augerings.	\N
Cwa - Warm temperate - dry winter, hot summer	\N
S - Stone line: any content, but concentrated at a distinct depth of a horizon	\N
Rhodic Luvisol	\N
Histels	\N
Terric Podzol	\N
Endocalcaric Umbrisol	\N
Pretic Lixisol	\N
CS - Warm temperate rainy climate - summer dry	\N
FF - Very fine and fine (< 2 mm)	\N
Plinth, Plinthic	\N
IB1 - basic igneous: gabbro	\N
> 0.17 g cm-3	\N
Stagnic Ferralsol	\N
10Y 8/2 - light grey	\N
dolerite	\N
F - Few (2-5 %)	\N
MR - Raised beds (agricultural purposes)	\N
O - Other: Soil material crushes only under very strong pressure; cannot be crushed between thumb and forefinger.	\N
M - Medium (1 - 2 cm)	\N
CSL - Coarse sandy loam	\N
WC5 - Heavier rain for some days or rainstorm in the last 24 hours	\N
TH - Thixotropy	\N
Hydragric Andosol	\N
FN2 - Clear felling	\N
IA1 - Acid igneous: granite	\N
V - Very few (0-2 %)	\N
pyroxenite	\N
Endogleyic	\N
Alb	\N
Grumic	\N
Subaquatic Gleysol	\N
7.5YR 8/2 - pinkish white	\N
Moist - LS, SL, L: 0.6–1%	\N
P - Pedotubules	\N
Aquepts	\N
Udands	\N
FS - Semi-deciduous forest	\N
AA4T - Traditional rainfed arable cultivation	\N
Inceptisols	\N
Cfb - Warm temperate - moist all seasons, warm summer	\N
Humults	\N
Haplic Lixisol	\N
WL - Waste liquid	\N
Thapto(ic)	\N
RO - Submerged by local rainwater less than once a year	\N
S - Sloping land (10 - 30 %)	\N
Dry - LS, SL, L: > 15%	\N
E - Earthworm channels	\N
Dolomitic Planosol	\N
Dystric Gleysol	\N
10R 4/1 - dark reddish grey	\N
IM - Isomesic	\N
PO - Pollution	\N
Dwa - Snow climates - dry winter, hot summer	\N
Ar	\N
Yermic Leptosol	\N
PV - Vertical pedfaces	\N
Yermic Cambisol	\N
Duric Andosol	\N
Uderts	\N
Gleyic Phaeozem	\N
WNW - west-north-west	\N
Shifting sands	\N
IU2 - Ultrabasic igneous: pyroxenite	\N
5G 7/1 - light greenish grey	\N
C - Thick (5 - 20 mm)	\N
10YR 3/2 - very dark greyish brown	\N
Xerepts	\N
10YR 6/4 - light yellowish brown	\N
MB1 - Basic metamorphic: slate, phyllite (pelitic rocks)	\N
RB - Reddish brown	\N
Retic	\N
Dry - Other: > 15%	\N
5 - Very high (> 40%)	\N
Cambic	\N
2.5YR 4/2 - weak red	\N
Ferralic	\N
Hydragric Stagnosol	\N
clay, silt and loam	\N
Stagnic Luvisol	\N
AQ - Aquic	\N
Glacic Cryosol	\N
N - Non-gypsiric (0%) - EC = < 1.8 dS m-1 in 10 g soil/25 ml H2O, EC = < 0.18 dS m-1 in 10 g soil/250 ml H2O	\N
Protoandic	\N
H - Humus	\N
S - Slow run-off	\N
SO2 - Sedimentary organic: marl and other mixtures	\N
Udolls	\N
7.5R 2.5/4 - very dusky red	\N
Cambic Cryosol	\N
Gleyic	\N
M - Manganese (manganiferous)	\N
5Y 3/2 - dark olive grey	\N
AW - Angular blocky (wedge-shaped)	\N
7.5Y 3/0	\N
7.5GY 4/0	\N
BD4,5 - Sample remains intact when dropped, no further disintegration after application of very large pressure - coherent (prismatic, columnar, wedgeshaped) - >1.6	\N
Petroduric Phaeozem	\N
2.5YR 6/0 - gray	\N
Gypsiric Calcisol	\N
2.5YR 2.5/2 - very dusky red	\N
Turbels	\N
Andic Gleysol	\N
Endostagnic	\N
Dry - Other: 2–3%	\N
7 - Continuously	\N
Calcic Cryosol	\N
Gently sloping	\N
Fibrists	\N
Per	\N
5BG 6/1 - greenish grey	\N
Ferralic Nitisol	\N
Stagnic Umbrisol	\N
5R 2.5/6 - dark red	\N
BD1 - Many pores, moist materials drop easily out of the auger; materials with vesicular pores, mineral soils with andic properties - granular - < 0.9	\N
Eutric Durisol	\N
Gelepts	\N
UA1 - Unconsolidated: Anthropogenic/ technogenic redeposited natural material	\N
Black Mn concretions	\N
X - Accelerated and natural erosion not distinguished	\N
LI - Lithic	\N
Luvic Chernozem	\N
SC5 - Clastic sediments: ironstone	\N
C - Coarse (> 5 mm)	\N
Cfa - Warm temperate - moist all seasons, hot summer	\N
TE = Terraced	\N
Skeletic Phaeozem	\N
Albic Planosol	\N
NW - north-west	\N
PuPe - Peas	\N
A - Abrupt (0-2 cm)	\N
C -  Coarse (> 20 mm)	\N
F - Fine (0.5-2 mm)	\N
FR - Fragipan	\N
SC - straight-concave	\N
Umbric	\N
Stagnosol (ST)	\N
D4 - Hemic, degree of decomposition/humification is strong	\N
Gleyic Chernozem	\N
I - Irregular	\N
WC2 - No rain in the last week	\N
Cambisol (CM)	\N
OiSu - Sunflower	\N
LinicUrbic Technosol	\N
HF - Forb	\N
Geric Nitisol	\N
Stagnic Solonetz	\N
SS - Synthetic solid	\N
Rubic	\N
AP1 - Non-irrigated cultivation	\N
2.5YR 4/0 - dark grey	\N
RE - Red	\N
Epic	\N
5R 3/8 - dark red	\N
Greyzemic Umbrisol	\N
> 50 %	\N
2.5Y 4/2 - dark greyish brown	\N
Dry - LS, SL, L: 1.2–2%	\N
5R 4/8 - red	\N
BWk - Desert climate Dry-cold	\N
SA - Sand coatings	\N
IN - Inundic	\N
Fluvic Cambisol	\N
0.07 - 0.11 g cm-3	\N
AA4C - Commercial rainfed arable cultivation	\N
Dry - S: < 0.3%	\N
SHA - Slightly hard: Weakly resistant to pressure; easily broken between thumb and forefinger.	\N
7.5YR 7/8 - reddish yellow	\N
Gypsic Gleysol	\N
5Y 6/8 - olive yellow	\N
Moist - Other: > 5%	\N
2 - Low (2-5%)	\N
Aceric	\N
DU - Udic	\N
PN3 - Wildlife management	\N
5R 5/1 - reddish grey	\N
10YR 6/3 - pale brown	\N
0–5	\N
II1 - Intermediate igneous: andesite, trachyte, phonolite	\N
5YR 5/1 - grey	\N
2.5YR 5/2 - weak red	\N
10Y 6/8	\N
Yermic Fluvisol	\N
PM - Pseudomycelia (carbonate infillings in pores, resembling mycelia)	\N
UR1 - Unconsolidated:  weathered residuum bauxite, laterite	\N
Y - Very dry: Crushing: dusty or hard. Forming (to a ball): not possible, seems to be warm. Moistening: going very dark. Rubbing (in the hand): not lighter. pF: 5.	\N
Fr - Fruits and Melons	\N
US - Unsorted sand	\N
10YR 6/2 - light brownish grey	\N
HC - Hypodermic coatings: Hypodermic coatings, as used here, are field-scale features, commonly only expressed as hydromorphic features. Micromorphological hypodermic coatings include non-redox features [Bullock et al., 1985].	\N
Haplic Solonchak	\N
5R 3/2 - dusky red	\N
Dystric Stagnosol	\N
HA - Hard: Moderately resistant to pressure; can be broken in the hands; not breakable between thumb and forefinger.	\N
Hist	\N
FE - Application of fertilizers	\N
S - Strongly weathered: All but the most resistant minerals are weathered, strongly discoloured and altered throughout the fragments, which tend to disintegrate under only moderate pressure.	\N
Abruptic Solonetz	\N
Sodic Solonchak	\N
Wind deposition	\N
Very steep	\N
Tephric Regosol	\N
Luvic	\N
Brunic Umbrisol	\N
Petrocalcic Durisol	\N
10R 4/8 - red	\N
Abruptic Acrisol	\N
HI1 - Animal production	\N
PVP - plastic to very plastic -	\N
Chernic Umbrisol	\N
A - Abundant (40 - 80 %)	\N
Histic Leptosol	\N
Lixic Gypsisol	\N
25–50	\N
Gypsic Lixisol	\N
FF - Submerged by remote flowing inland water at least once a year	\N
Dolomitic	\N
MU - Mineral additions (not specified)	\N
N - None - The number of very fine pores (< 2 mm) per square decimetre is 0, the number of medium and coarse pores (> 2 mm) per square decimetre is 0.	\N
D - disperse powdery gypsum	\N
Hortic Chernozem	\N
Fragic Cambisol	\N
M - Moderately rapid run-off	\N
Fol	\N
5Y 8/3 - pale yellow	\N
Plaggic	\N
Solimovic Cambisol	\N
BB - Bluish-black	\N
Oxyaquic	\N
FN1 - Selective felling	\N
S - Smooth - Nearly plane surface	\N
10YR 8/4 - very pale brown	\N
Mineralic	\N
unspecified deposits	\N
7.5GY 6/6	\N
I - Other insect activity	\N
MS - Moderate to strong	\N
Gleyic Alisol	\N
WD - Deciduous woodland	\N
Xanthic Ferralsol	\N
SST - Slightly sticky - After pressure, soil material adheres to both thumb and finger but comes off one or the other rather cleanly. It is not appreciably stretched when the digits are separated.	\N
5YR 3/3 - dark reddish brown	\N
HT - Tall grassland	\N
Haplic Kastanozem	\N
MP - Permanently submerged by seawater (below mean low water springs)	\N
5.6 - 6.0: Moderately acidic	\N
10Y 5/1 - grey	\N
Mollic Leptosol	\N
Petrogypsic Solonchak	\N
Mollic Ferralsol	\N
Leptic Technosol	\N
Hydragric Anthrosol	\N
SL - Slightly salty (0.75 - 2 dS m-1)	\N
V - Very few - Roots with diameters < 2 mm: 1-20, Roots with diameters > 2 mm: 1-2.	\N
rhyolite	\N
Cambic Gypsisol	\N
SL - Sandy loam	\N
2.5YR 5/0 - grey	\N
FoLe - Leguminous	\N
Capillaric	\N
Xanthic Nitisol	\N
Skeletic Podzol	\N
5R 2.5/3 - very dusky red	\N
Cbf - Warm temperate (mesothermal) climates - moist	\N
Stagnic Anthrosol	\N
AR - Aridic	\N
Terric Gleysol	\N
Ya - Young (10-100 years) anthropogeomorphic: with complete disturbance of any natural surfaces (and soils), such as in urban, industrial, or mining areas, with early soil development from fresh natural, technogenic, or mixed materials, or restriction of flooding by dykes.	\N
10R 4/3 - weak red	\N
Salic Vertisol	\N
Nudiargic Lixisol	\N
N - Nodule: Discrete body without an internal organization	\N
5YR 3/4 - dark reddish brown	\N
5Y 4/3 - olive	\N
Yermic Regosol	\N
Skeletic Ferralsol	\N
D - Dry	\N
Salic Cryosol	\N
Endodolomitic Umbrisol	\N
Calcaric Durisol	\N
Albic	\N
Hydragric Alisol	\N
IA4 - Acid igneous: rhyiolite	\N
Transportic Regosol	\N
Yermic Gypsisol	\N
ID - Industrial dust	\N
Profundihumic Nitisol	\N
D - Disperse powdery lime	\N
AA5 - Wet rice cultivation	\N
10YR 2/2 - very dark brown	\N
RoYa - Yams	\N
Endoabruptic	\N
Takyric Solonetz	\N
WA - Water and wind erosion	\N
CS - Coarse gravel and stones	\N
Very deep (> 150 cm)	\N
T - Once every 5-10 years	\N
Cs - Temperate rainy (humid mesothermal) climate with dry summer	\N
0 - None (0 - 2 %)	\N
Water and wind erosion	\N
A - Artefacts	\N
NT - Positive NAF test and thixotropy	\N
Many	\N
Kalaic	\N
Hortic	\N
Amphi	\N
WS - Sheet erosion	\N
UC2 - Unconsolidated: colluvial lahar	\N
Melan	\N
medium and coarse	\N
Ferric	\N
Xererts	\N
A - Angular	\N
Dry - S: > 12%	\N
MU1 - Ultrabasic metamorphic: serpentinite, greenstone	\N
Ferralic Anthrosol	\N
F - Few - The number of very fine pores (< 2 mm) per square decimetre is 20-50, the number of medium and coarse pores (> 2 mm) per square decimetre is 2-5.	\N
< 3.5: Ultra acidic	\N
Rheic Histosol	\N
BO - Open large burrows	\N
M - Medium (6-20 mm)	\N
8.5 - 9.0: Moderately alkaline	\N
Endothionic	\N
0 - 10 %	\N
40 - 50 %	\N
Moist - Other: 3–5%	\N
Chernic Stagnosol	\N
D - Discontinuous: The layer is 50-90 percent cemented or compacted, and in general shows a regular appearance.	\N
Abruptic Lixisol	\N
moraine	\N
Petroferric	\N
R - Rounded (spherical)	\N
7.5R 5/0 - grey	\N
D - Snow (microthermal) climates	\N
Sodic Vertisol	\N
SL - Silica (opal)	\N
Fibric Histosol	\N
Haplic Umbrisol	\N
Weakly drained	\N
B - Burrows (unspecified)	\N
Hortic Anthrosol	\N
3 - 15-30 days	\N
Aeolic Andosol	\N
D - Diffuse (> 15 cm)	\N
Alic Planosol	\N
Calcaric Regosol	\N
Gypsic Vertisol	\N
Terric Lixisol	\N
Gelods	\N
Ha - Holocene (100-10,000 years) anthropogeomorphic: human-made relief modifications, such as terracing or formation of hills or walls by early civilizations or during the Middle Ages, restriction of flooding by dykes, or surface raising.	\N
F - Fine (0.5-2 mm) - More decomposed than raw humus but characterized by an organic matter layer on top of the mineral soil with a diffuse boundary between the organic matter layer and A horizon. In the sequence of Oi-Oe-Oa layers, it is difficult to separate one layer from another. This develops in moderately nutrient-poor conditions, usually under a cool moist climate. It is usually acidic with a C/N ratio of 18-29.	\N
Arenosol (AR)	\N
marl and other mixtures	\N
P - Prominent: Surface of coatings contrasts strongly in smoothness or colour with the adjacent surfaces. Outlines of fine sand grains are not visible. Lamellae are more than 5 mm thick.	\N
Leptic Cryosol	\N
Petrocalcic Chernozem	\N
Fo - Fodder Plants	\N
Lixic Stagnosol	\N
Wapnic Gleysol	\N
10R 2.5/1 - reddish black	\N
Yermic Arenosol	\N
Strongly sloping	\N
HE1 - Nomadism	\N
Gleyic Technosol	\N
Luvic Durisol	\N
FrAp - Apples	\N
Dolomitic Cambisol	\N
SO3 - Sedimentary organic: coals, bitumen and related rocks	\N
Lixic Planosol	\N
Pretic Planosol	\N
acid metamorphic	\N
bauxite, laterite	\N
Rendolls	\N
Skeletic Histosol	\N
10Y 5/4	\N
Lixic Calcisol	\N
Dfc - Snow climates - moist all seasons, cool short summer	\N
D5.2 - Sapric, degree of decomposition/humification is very strong	\N
BD3 - Sample remains mostly intact when dropped, further disintegration possible after application of large pressure - coherent, prismatic, platy, (columnar, angular blocky, platy, wedgeshaped) - 1.4-1.6	\N
LV - Valley floor (< 10 %)	\N
Cfc - Warm temperate - moist all seasons,  with cool short summer	\N
Vertisols	\N
Petric Plinthosol	\N
N - (nearly)Not salty (< 0.75 dS m-1)	\N
V - Very thick (>20 mm)	\N
Puffic	\N
10YR 7/3 - very pale brown	\N
Pyric	\N
S - Sand (unspecified)	\N
BL - Boulders and large boulders	\N
EFI - Extremely firm: Soil material crushes only under very strong pressure; cannot be crushed between thumb and forefinger.	\N
Tephric Andosol	\N
H - Active in historical times	\N
PF - Pressure faces	\N
Epieutric	\N
MO - Moderately calcareous (2-10%) - Visible effervescence.	\N
Stagnic Lixisol	\N
M - Many - Roots with diameters < 2 mm: > 200, Roots with diameters > 2 mm: > 20.	\N
Stagnic Regosol	\N
H - Hard	\N
Neocambic	\N
Terric Kastanozem	\N
2 - Shallow (25-50 cm)	\N
Calcic Solonchak	\N
3 - High (40 - 80 %)	\N
limestone, other carbonate rock	\N
Hypereutric	\N
5YR 8/1 - white	\N
PL - Platy	\N
RoCa - Cassava	\N
Haplic Solonetz	\N
1 - Very low (< 2%)	\N
10Y 7/6	\N
LuCc - Cocoa	\N
10YR 8/6 - yellow	\N
10YR 7/6 - yellow	\N
2.5Y 8/2 - white	\N
ultrabasic igneous	\N
Undrained	\N
AS - Angular and subangular blocky	\N
3 - Incomplete description: Certain relevant elements are missing from the description, an insufficient number of samples was collected, or the reliability of the analytical data does not permit a complete characterization of the soil. However, the description is useful for specific purposes and provides a satisfactory indication of the nature of the soil at high levels of soil taxonomic classification.	\N
Moist - LS, SL, L: > 4%	\N
FrCi - Citrus	\N
Calcic Vertisol	\N
Calcaric Planosol	\N
Dwd - Snow climates - dry winter, very cold winter	\N
FI - Firm: Soil material crushes under moderate pressure between thumb and forefinger, but resistance is distinctly noticeable.	\N
TH - Thermic	\N
7.5R 2.5/0 - black	\N
Vitrands	\N
5 - Other descriptions: Essential elements are missing from the description, preventing a satisfactory soil characterization and classification.	\N
ultrabasic metamorphic	\N
EV - Exploitation of natural vegetation	\N
Dry - LS, SL, L: 2–4%	\N
7.5YR 8/6 - reddish yellow	\N
F - Few (2 - 5 %)	\N
Eutr, Eutric	\N
5YR 5/8 - yellowish red	\N
Ochric	\N
Not known	\N
S - Shrub	\N
PuLe - Lentils	\N
0 - 5 %	\N
C - Common - The number of very fine pores (< 2 mm) per square decimetre is 50-200, the number of medium and coarse pores (> 2 mm) per square decimetre is 5-20.	\N
Retic Umbrisol	\N
10R 6/8 - light red	\N
Very few	\N
Abundant	\N
AN - Artesanal natural material	\N
RI - Ridged	\N
GS - Greyish	\N
Andic Histosol	\N
5YR 5/3 - reddish brown	\N
Leptic Calcisol	\N
Hypergypsic	\N
M - Many (15 - 40 %)	\N
Nitic	\N
M - Moder (duff mull): more decomposed than raw humus but characterized by an organic matter layer on top of the mineral soil with a diffuse boundary between the organic matter layer and A horizon. In the sequence of Oi-Oe-Oa layers, it is difficult to separate one layer from another. This develops in moderately nutrient-poor conditions, usually under a cool moist climate. It is usually acidic with a C/N ratio of 18-29.	\N
10R 5/1 - reddish grey	\N
FF  - Very fine and fine	\N
LS - Loamy sand	\N
Petric Gypsisol	\N
periglacial rock debris	\N
S - Slight - Some evidence of damage to surface horizons. Original biotic functions largely intact	\N
Sombric	\N
ST - Silt coatings	\N
Aquox	\N
Fluvisol (FL)	\N
Dd - Subarctic with very cold low-sun season	\N
Albic Acrisol	\N
Folic Histosol	\N
7.5GY 8/2	\N
Calcaric Phaeozem	\N
7.5YR 7/2 - pinkish grey	\N
Rhodic Acrisol	\N
NO - None of the above	\N
Durids	\N
Skeletic Andosol	\N
P - Petrochemical - Presence of gaseous or liquid gasoline, oil, creosote, etc.	\N
C - Common	\N
F - Few - Roots with diameters < 2 mm: 20-50, Roots with diameters > 2 mm: 2-5.	\N
Al, Alic	\N
Spodic	\N
Petrocalcic Kastanozem	\N
Orthofluvic Fluvisol	\N
Mulmic Phaeozem	\N
2 - Routine profile description: No essential elements are missing from the description, sampling or analysis. The number of samples collected is sufficient to characterize all major soil horizons, but may not allow precise definition of all subhorizons, especially in the deeper soil. The profile depth is 80 cm or more, or down to a C or R horizon or layer, which may be shallower. Additional augering and sampling may be required for lower level classification.	\N
Haplic Luvisol	\N
CC - Calcium carbonate	\N
Tephric Fluvisol	\N
Reductigleyic Gleysol	\N
Moist - LS, SL, L: 2–4%	\N
V - Very few (0 - 2 %)	\N
Eutric Nitisol	\N
White, after oxidation white: Complete loss of Fe compounds	\N
SC4 - Clastic sediments: shale	\N
Sideralic	\N
RY - Reddish yellow	\N
Ferr	\N
Stagnic Cambisol	\N
Protic Regosol	\N
Murshic Histosol	\N
Irragric Stagnosol	\N
S - Subrounded	\N
5YR 6/4 - light reddish brown	\N
M - Many - The number of very fine pores (< 2 mm) per square decimetre is > 200, the number of medium and coarse pores (> 2 mm) per square decimetre is > 20.	\N
AA6 - Irrigated cultivation	\N
S - Settlement, industry	\N
5YR 8/4 - pink	\N
FiCo - Cotton	\N
BD3 - When dropped, sample disintegrates into few fragments, further disintegration of subfragments after application of mild pressure - angular blocky, prismatic, platy, columnar - 1.2-1.4	\N
C - Continuous: The layer is more than 90 percent cemented or compacted, and is only interrupted in places by cracks or fissures.	\N
SA - Subangular and angular blocky	\N
N - None (0 %)	\N
4.1 - Soil augering description - without sampling: Soil augerings do no permit a comprehensive soil profile description. Augerings are made for routine soil observation and identification in soil mapping, and for that purpose normally provide a satisfactory indication of the soil characteristics. Soil samples may be collected from augerings. Soil description is done without sampling.	\N
S - sedimentary rock (consolidated)	\N
W - Wet: Crushing: free water. Forming (to a ball): drops of water. Moistening: no change of colour. pF: 1.	\N
Durisol (DU)	\N
PD2 - With interference	\N
Dry - S: 1.5–2%	\N
Ferric Alisol	\N
Geric Plinthosol	\N
5-20 m	\N
Endothyric	\N
M - Moderately cemented: Cemented mass cannot be broken in the hands but is discontinuous (less than 90 percent of soil mass).	\N
BD1 - When dropped, sample disintegrates into numerous fragments, further disintegration of subfragments after application of weak pressure - angular blocky - 1.0-1.2	\N
5Y 7/4 - pale yellow	\N
2.5Y 5/0 - grey	\N
Gypsic Solonchak	\N
Umbric Leptosol	\N
10R 5/8 - red	\N
Plaggic Gleysol	\N
Arents	\N
Pisoplinthic Gleysol	\N
5YR 6/2 - pinkish grey	\N
Tonguic Umbrisol	\N
UE2 - Unconsolidated: eolian sand	\N
JA - Jarosite	\N
Fluvic Phaeozem	\N
RS - Rock structure	\N
Grossarenic	\N
Cryolls	\N
Haplic Gypsisol	\N
Irragric Cambisol	\N
Sphagn	\N
Turbic	\N
Rockic Histosol	\N
Nitic Plinthosol	\N
H - Herbaceous	\N
SiL - Silt loam	\N
7.5GY 4/4	\N
06 - Sloping (5 - 10 %)	\N
DE - Evergreen dwarf shrub	\N
2.1 - Routine profile description - without sampling: No essential elements are missing from the description, sampling or analysis. The number of samples collected is sufficient to characterize all major soil horizons, but may not allow precise definition of all subhorizons, especially in the deeper soil. The profile depth is 80 cm or more, or down to a C or R horizon or layer, which may be shallower. Additional augering and sampling may be required for lower level classification. Soil description is done without sampling.	\N
Lignic	\N
Eutric Planosol	\N
B - Boulders (20 - 60 cm)	\N
FF - Fine and very fine (< 2 mm).	\N
Gleysol (GL)	\N
Leptic Vertisol	\N
Calcaric Luvisol	\N
DT - Tundra	\N
10 - Very steep (> 60 %)	\N
Ddw - Subarctic with very cold low-sun season - dry winter	\N
LV - Levelling	\N
\.


--
-- TOC entry 4959 (class 0 OID 54922789)
-- Dependencies: 222
-- Data for Name: element; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.element (element_id, profile_id, order_element, upper_depth, lower_depth, type) FROM stdin;
\.


--
-- TOC entry 5012 (class 0 OID 54924336)
-- Dependencies: 275
-- Data for Name: languages; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.languages (language_code, language_name) FROM stdin;
en	English
es	Spanish
fr	French
de	German
it	Italian
pt	Portuguese
ru	Russian
zh	Chinese
ja	Japanese
ko	Korean
ar	Arabic
hi	Hindi
bn	Bengali
pa	Punjabi
nl	Dutch
sv	Swedish
fi	Finnish
da	Danish
no	Norwegian
pl	Polish
uk	Ukrainian
cs	Czech
hu	Hungarian
ro	Romanian
el	Greek
tr	Turkish
fa	Persian
ur	Urdu
th	Thai
vi	Vietnamese
id	Indonesian
ms	Malay
he	Hebrew
tl	Filipino
sw	Swahili
ca	Catalan
eu	Basque
ga	Irish
cy	Welsh
gd	Scottish Gaelic
hr	Croatian
sr	Serbian
sk	Slovak
sl	Slovenian
lv	Latvian
lt	Lithuanian
et	Estonian
bg	Bulgarian
ta	Tamil
te	Telugu
kn	Kannada
ml	Malayalam
mr	Marathi
gu	Gujarati
or	Odia
as	Assamese
ne	Nepali
si	Sinhala
my	Burmese
km	Khmer
lo	Lao
mn	Mongolian
am	Amharic
ha	Hausa
ig	Igbo
yo	Yoruba
zu	Zulu
xh	Xhosa
st	Southern Sotho
sn	Shona
rw	Kinyarwanda
so	Somali
\.


--
-- TOC entry 4961 (class 0 OID 54922797)
-- Dependencies: 224
-- Data for Name: observation_desc_element; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.observation_desc_element (procedure_desc_id, property_desc_id, category_desc_id, category_order) FROM stdin;
FAO GfSD 2006	AeromorphicForest	M - Moder (duff mull): more decomposed than raw humus but characterized by an organic matter layer on top of the mineral soil with a diffuse boundary between the organic matter layer and A horizon. In the sequence of Oi-Oe-Oa layers, it is difficult to separate one layer from another. This develops in moderately nutrient-poor conditions, usually under a cool moist climate. It is usually acidic with a C/N ratio of 18-29.	2
FAO GfSD 2006	AeromorphicForest	R - Raw humus (aeromorphic mor: usually thick (5-30 cm) organic matter accumulation that is largely unaltered owing to lack of decomposers. This kind of organic matter layer develops in extremely nutrient-poor and coarsetextured soils under vegetation that produces a litter layer that is difficult to decompose. It is usually a sequence of Oi-Oe-Oa layers over a thin A horizon, easy to separate one layer from another and being very acid with a C/N ratio of > 29.	1
FAO GfSD 2006	AeromorphicForest	U - Mull: characterized by the periodic absence of organic matter accumulation on the surface owing to the rapid decomposition process and mixing of organic matter and the mineral soil material by bioturbation. It is usually slightly acid to neutral with a C/N ratio of 10-18.	3
FAO GfSD 2006	ArtefactAbundance	A - Abundant (40-80%)	6
FAO GfSD 2006	ArtefactAbundance	C - Common (5-15%)	4
FAO GfSD 2006	ArtefactAbundance	D - Dominant (> 80%)	7
FAO GfSD 2006	ArtefactAbundance	F - Few (2-5%)	3
FAO GfSD 2006	ArtefactAbundance	M - Many (15-40%)	5
FAO GfSD 2006	ArtefactAbundance	N - None (0%)	1
FAO GfSD 2006	ArtefactAbundance	S - Stone line: any content, but concentrated at a distinct depth of a horizon	8
FAO GfSD 2006	ArtefactAbundance	V - Very few (0-2%)	2
FAO GfSD 2006	ArtefactColour	BB - Bluish-black	15
FAO GfSD 2006	ArtefactColour	BL - Black	16
FAO GfSD 2006	ArtefactColour	BR - Brown	5
FAO GfSD 2006	ArtefactColour	BS - Brownish	6
FAO GfSD 2006	ArtefactColour	BU - Blue	14
FAO GfSD 2006	ArtefactColour	GE - Greenish	11
FAO GfSD 2006	ArtefactColour	GR - Grey	12
FAO GfSD 2006	ArtefactColour	GS - Greyish	13
FAO GfSD 2006	ArtefactColour	MC - Multicoloured	17
FAO GfSD 2006	ArtefactColour	RB - Reddish brown	7
FAO GfSD 2006	ArtefactColour	RE - Red	2
FAO GfSD 2006	ArtefactColour	RS - Reddish	3
FAO GfSD 2006	ArtefactColour	RY - Reddish yellow	10
FAO GfSD 2006	ArtefactColour	WH - White	1
FAO GfSD 2006	ArtefactColour	YB - Yellowish brown	8
FAO GfSD 2006	ArtefactColour	YE - Yellow	9
FAO GfSD 2006	ArtefactColour	YR - Yellowish red	4
FAO GfSD 2006	ArtefactHardness	B - Both hard and soft	3
FAO GfSD 2006	ArtefactHardness	H - Hard	1
FAO GfSD 2006	ArtefactHardness	S - Soft	2
FAO GfSD 2006	ArtefactKind	AN - Artesanal natural material	1
FAO GfSD 2006	ArtefactKind	ID - Industrial dust	2
FAO GfSD 2006	ArtefactKind	MM - Mixed material	3
FAO GfSD 2006	ArtefactKind	MS - Mine spoil or crude oil	9
FAO GfSD 2006	ArtefactKind	OG - Organic garbage	4
FAO GfSD 2006	ArtefactKind	PS - Pavements and paving stones	5
FAO GfSD 2006	ArtefactKind	SL - Synthetic liquid	6
FAO GfSD 2006	ArtefactKind	SS - Synthetic solid	7
FAO GfSD 2006	ArtefactKind	WL - Waste liquid	8
FAO GfSD 2006	ArtefactSize	C - Coarse artefacts (> 20 mm)	4
FAO GfSD 2006	ArtefactSize	F - Fine artefacts (2 - 6 mm)	2
FAO GfSD 2006	ArtefactSize	F - Medium artefacts (6 - 20 mm)	3
FAO GfSD 2006	ArtefactSize	V - Very fine artefacts (< 2 mm)	1
FAO GfSD 2006	ArtefactWeathering	F - Fresh or slightly weathered: Fragments show little or no signs of weathering.	1
FAO GfSD 2006	ArtefactWeathering	S - Strongly weathered: All but the most resistant minerals are weathered, strongly discoloured and altered throughout the fragments, which tend to disintegrate under only moderate pressure.	3
FAO GfSD 2006	ArtefactWeathering	W - Weathered: Partial weathering is indicated by discoloration and loss of crystal form in the outer parts of the fragments while the centres remain relatively fresh and the fragments have lost little of their original strength.	2
FAO GfSD 2006	BiologicalAbundance	C - Common	3
FAO GfSD 2006	BiologicalAbundance	F - Few	2
FAO GfSD 2006	BiologicalAbundance	M - Many	4
FAO GfSD 2006	BiologicalAbundance	N - None	1
FAO GfSD 2006	BiologicalKind	A - Artefacts	1
FAO GfSD 2006	BiologicalKind	B - Burrows (unspecified)	2
FAO GfSD 2006	BiologicalKind	BI - Infilled large burrows	4
FAO GfSD 2006	BiologicalKind	BO - Open large burrows	3
FAO GfSD 2006	BiologicalKind	C - Charcoal	5
FAO GfSD 2006	BiologicalKind	E - Earthworm channels	6
FAO GfSD 2006	BiologicalKind	I - Other insect activity	9
FAO GfSD 2006	BiologicalKind	P - Pedotubules	7
FAO GfSD 2006	BiologicalKind	T - Termite or ant channels and nests	8
FAO GfSD 2006	BoundaryDistinctness	A - Abrupt (0-2 cm)	1
FAO GfSD 2006	BoundaryDistinctness	C - Clear (2-5 cm)	2
FAO GfSD 2006	BoundaryDistinctness	D - Diffuse (> 15 cm)	4
FAO GfSD 2006	BoundaryDistinctness	G - Gradual (5-15 cm)	3
FAO GfSD 2006	BoundaryTopography	B - Broken - Discontinuous	4
FAO GfSD 2006	BoundaryTopography	I - Irregular - Pockets more deep than wide	3
FAO GfSD 2006	BoundaryTopography	S - Smooth - Nearly plane surface	1
FAO GfSD 2006	BoundaryTopography	W - Wavy - Pockets less deep than wide	2
FAO GfSD 2006	BulkDensity	BD1 - Many pores, moist materials drop easily out of the auger; materials with vesicular pores, mineral soils with andic properties - granular - < 0.9	1
FAO GfSD 2006	BulkDensity	BD1 - Sample disintegrates at the instant of sampling, many pores visible on the pit wall - single grain, granular - 0.9-1.2	2
FAO GfSD 2006	BulkDensity	BD1 - When dropped, sample disintegrates into numerous fragments, further disintegration of subfragments after application of weak pressure - angular blocky - 1.0-1.2	7
FAO GfSD 2006	ColourDry	10YR 3/1 - very dark grey	54
FAO GfSD 2006	ColourDry	10YR 3/2 - very dark greyish brown	55
FAO GfSD 2006	BulkDensity	BD2 - Sample disintegrates into numerous fragments after application of weak single grain, subangular, pressure - single grain, subangular, angular blocky - 1.2-1.4	3
FAO GfSD 2006	BulkDensity	BD3 - Knife can be pushed into the moist soil with weak pressure, sample disintegrates into few fragments, which may be further divided - subangular and angular blocky, prismatic, platy - 1.4-1.6	4
FAO GfSD 2006	BulkDensity	BD3 - Sample remains mostly intact when dropped, further disintegration possible after application of large pressure - coherent, prismatic, platy, (columnar, angular blocky, platy, wedgeshaped) - 1.4-1.6	9
FAO GfSD 2006	BulkDensity	BD3 - When dropped, sample disintegrates into few fragments, further disintegration of subfragments after application of mild pressure - angular blocky, prismatic, platy, columnar - 1.2-1.4	8
FAO GfSD 2006	BulkDensity	BD4,5 - Sample remains intact when dropped, no further disintegration after application of very large pressure - coherent (prismatic, columnar, wedgeshaped) - >1.6	10
FAO GfSD 2006	BulkDensity	BD4 - Knife penetrates only 1-2 cm into the moist soil, some effort required, sample disintegrates into few fragments, which cannot be subdivided further - prismatic, platy, (angular blocky) - 1.6-1.8	5
FAO GfSD 2006	BulkDensity	BD5 - Very large pressure necessary to force knife into the soil, no further disintegration of sample - prismatic - > 1.8	6
FAO GfSD 2006	CarbonateContent	EX - Extremely calcareous (> 25%) - Extremely strong reaction. Thick foam forms quickly.	5
FAO GfSD 2006	CarbonateContent	MO - Moderately calcareous (2-10%) - Visible effervescence.	3
FAO GfSD 2006	CarbonateContent	N - Non-calcareous (0%) - No detectable visible or audible effervescence.	1
FAO GfSD 2006	CarbonateContent	SL - Slightly calcareous (0-2%) - Audible effervescence but not visible.	2
FAO GfSD 2006	CarbonateContent	ST - Strongly calcareous (10-25%) - Strong visible effervescence. Bubbles form a low foam.	4
FAO GfSD 2006	CarbonateForms	D - Disperse powdery lime	4
FAO GfSD 2006	CarbonateForms	HC - Hard concretions	2
FAO GfSD 2006	CarbonateForms	HHC - Hard hollow concretions	3
FAO GfSD 2006	CarbonateForms	HL - hard cemented layer or layers of carbonates (less than 10 cm thick)	7
FAO GfSD 2006	CarbonateForms	M - marl layer	6
FAO GfSD 2006	CarbonateForms	PM - Pseudomycelia (carbonate infillings in pores, resembling mycelia)	5
FAO GfSD 2006	CarbonateForms	SC - Soft concretions	1
FAO GfSD 2006	Cementation/compactionContinuity	B - Broken: The layer is less than 50 percent cemented or compacted, and shows a rather irregular appearance.	1
FAO GfSD 2006	Cementation/compactionContinuity	C - Continuous: The layer is more than 90 percent cemented or compacted, and is only interrupted in places by cracks or fissures.	3
FAO GfSD 2006	Cementation/compactionContinuity	D - Discontinuous: The layer is 50-90 percent cemented or compacted, and in general shows a regular appearance.	2
FAO GfSD 2006	Cementation/compactionDegree	C - Cemented: Cemented mass cannot be broken in the hands and is continuous (more than 90 percent of soil mass).	5
FAO GfSD 2006	Cementation/compactionDegree	I - Indurated: Cemented mass cannot be broken by body weight (75-kg standard soil scientist) (more than 90 percent of soil mass).	6
FAO GfSD 2006	Cementation/compactionDegree	M - Moderately cemented: Cemented mass cannot be broken in the hands but is discontinuous (less than 90 percent of soil mass).	4
FAO GfSD 2006	Cementation/compactionDegree	N - Non-cemented and non-compacted: Neither cementation nor compaction observed (slakes in water).	1
FAO GfSD 2006	Cementation/compactionDegree	W - Weakly cemented: Cemented mass is brittle and hard, but can be broken in the hands.	3
FAO GfSD 2006	Cementation/compactionDegree	Y - Compacted but non-cemented: Compacted mass is appreciably harder or more brittle than other comparable soil mass (slakes in water).	2
FAO GfSD 2006	Cementation/compactionNature	C - Clay	11
FAO GfSD 2006	Cementation/compactionNature	CS - Clay-sesquioxides	12
FAO GfSD 2006	Cementation/compactionNature	F - Iron	6
FAO GfSD 2006	Cementation/compactionNature	FM - Iron-manganese (sesquioxides)	7
FAO GfSD 2006	Cementation/compactionNature	FO - Iron-organic matter	8
FAO GfSD 2006	Cementation/compactionNature	GY - Gypsum	10
FAO GfSD 2006	Cementation/compactionNature	I - Ice	9
FAO GfSD 2006	Cementation/compactionNature	K - Carbonates	3
FAO GfSD 2006	Cementation/compactionNature	KQ - Carbonates-silica	5
FAO GfSD 2006	Cementation/compactionNature	M - Mechanical	13
FAO GfSD 2006	Cementation/compactionNature	NK - Not known	2
FAO GfSD 2006	Cementation/compactionNature	P - Ploughing	1
FAO GfSD 2006	Cementation/compactionNature	Q - Silica	4
FAO GfSD 2006	Cementation/compactionStructure	D - Nodular: The layer is largely constructed from cemented nodules or concretions of irregular shape.	4
FAO GfSD 2006	Cementation/compactionStructure	P - Pisolithic: The layer is largely constructed from cemented spherical nodules.	3
FAO GfSD 2006	Cementation/compactionStructure	P - Platy: The compacted or cemented parts are platelike and have a horizontal or subhorizontal orientation.	1
FAO GfSD 2006	Cementation/compactionStructure	V - Vesicular: The layer has large, equidimensional voids that may be filled with uncemented material.	2
FAO GfSD 2006	CoatingsAbundance	A - Abundant (40-80 %)	6
FAO GfSD 2006	CoatingsAbundance	C - Common (5-15 %)	4
FAO GfSD 2006	CoatingsAbundance	D - Dominant (> 80 %)	7
FAO GfSD 2006	CoatingsAbundance	F - Few (2-5 %)	3
FAO GfSD 2006	CoatingsAbundance	M - Many (15-40 %)	5
FAO GfSD 2006	CoatingsAbundance	N - None (0 %)	1
FAO GfSD 2006	CoatingsAbundance	V - Very few (0-2 %)	2
FAO GfSD 2006	CoatingsContrast	D - Distinct: Surface of coating is distinctly smoother or different in colour from the adjacent surface. Fine sand grains are enveloped in the coating but their outlines are still visible. Lamellae are 2-5 mm thick.	2
FAO GfSD 2006	CoatingsContrast	F - Faint: Surface of coating shows only little contrast in colour, smoothness or any other property to the adjacent surface. Fine sand grains are readily apparent in the cutan. Lamellae are less than 2 mm thick.	1
FAO GfSD 2006	ColourDry	10YR 3/3 - dark brown	56
FAO GfSD 2006	ColourDry	10YR 3/4 - dark yellowish brown	57
FAO GfSD 2006	ColourDry	7.5GY 7/0	260
FAO GfSD 2006	CoatingsContrast	P - Prominent: Surface of coatings contrasts strongly in smoothness or colour with the adjacent surfaces. Outlines of fine sand grains are not visible. Lamellae are more than 5 mm thick.	3
FAO GfSD 2006	CoatingsForm	C - Continuous: Surface of coating shows only little contrast in colour, smoothness or any other property to the adjacent surface. Fine sand grains are readily apparent in the cutan. Lamellae are less than 2 mm thick.	1
FAO GfSD 2006	CoatingsForm	CI - Continuous irregular (non-uniform, heterogeneous): Surface of coating is distinctly smoother or different in colour from the adjacent surface. Fine sand grains are enveloped in the coating but their outlines are still visible. Lamellae are 2-5 mm thick.	2
FAO GfSD 2006	CoatingsForm	DC - Discontinuous circular: Elongated voids of faunal or floral origin, mostly tubular in shape and continuous, varying strongly in diameter. When wider than a few centimetres (burrow holes), they are more adequately described under biological activity.	5
FAO GfSD 2006	CoatingsForm	DE - Dendroidal: Mostly irregular, equidimensional voids of faunal origin or resulting from tillage or disturbance of other voids. Discontinuous or interconnected. May be quantified in specific cases.	4
FAO GfSD 2006	CoatingsForm	DI - Discontinuous irregular: Surface of coatings contrasts strongly in smoothness or colour with the adjacent surfaces. Outlines of fine sand grains are not visible. Lamellae are more than 5 mm thick.	3
FAO GfSD 2006	CoatingsForm	O - Other: Soil material crushes only under very strong pressure; cannot be crushed between thumb and forefinger.	6
FAO GfSD 2006	CoatingsLocation	BR - Bridges between sand grains	7
FAO GfSD 2006	CoatingsLocation	CF - Coarse fragments	4
FAO GfSD 2006	CoatingsLocation	LA - Lamellae (clay bands)	5
FAO GfSD 2006	CoatingsLocation	NS - No specific location	8
FAO GfSD 2006	CoatingsLocation	PH - Horizontal pedfaces	3
FAO GfSD 2006	CoatingsLocation	P - Pedfaces	1
FAO GfSD 2006	CoatingsLocation	PV - Vertical pedfaces	2
FAO GfSD 2006	CoatingsLocation	VO - Voids	6
FAO GfSD 2006	CoatingsNature	CC - Calcium carbonate	6
FAO GfSD 2006	CoatingsNature	C - Clay	1
FAO GfSD 2006	CoatingsNature	CH - Clay and humus (organic matter)	5
FAO GfSD 2006	CoatingsNature	CS - Clay and sesquioxides	4
FAO GfSD 2006	CoatingsNature	GB - Gibbsite	7
FAO GfSD 2006	CoatingsNature	HC - Hypodermic coatings: Hypodermic coatings, as used here, are field-scale features, commonly only expressed as hydromorphic features. Micromorphological hypodermic coatings include non-redox features [Bullock et al., 1985].	8
FAO GfSD 2006	CoatingsNature	H - Humus	3
FAO GfSD 2006	CoatingsNature	JA - Jarosite	9
FAO GfSD 2006	CoatingsNature	MN - Manganese	10
FAO GfSD 2006	CoatingsNature	PF - Pressure faces	15
FAO GfSD 2006	CoatingsNature	SA - Sand coatings	12
FAO GfSD 2006	CoatingsNature	SF - Shiny faces (as in nitic horizon)	14
FAO GfSD 2006	CoatingsNature	SI - Slickensides, predominantly intersecting: Slickensides are polished and grooved ped surfaces that are produced by aggregates sliding one past another.	16
FAO GfSD 2006	CoatingsNature	SL - Silica (opal)	11
FAO GfSD 2006	CoatingsNature	SN - Slickensides, non intersecting	18
FAO GfSD 2006	CoatingsNature	SP - Slickensides, partly intersecting	17
FAO GfSD 2006	CoatingsNature	S - Sesquioxides	2
FAO GfSD 2006	CoatingsNature	ST - Silt coatings	13
FAO GfSD 2006	ColourDry	10R 2.5/1 - reddish black	217
FAO GfSD 2006	ColourDry	10R 2.5/2 - very dusky red	218
FAO GfSD 2006	ColourDry	10R 3/1 - dark reddish grey	219
FAO GfSD 2006	ColourDry	10R 3/2 - dusky red	220
FAO GfSD 2006	ColourDry	10R 3/3 - dusky red	221
FAO GfSD 2006	ColourDry	10R 3/4 - dusky red	222
FAO GfSD 2006	ColourDry	10R 3/6 - dark red	223
FAO GfSD 2006	ColourDry	10R 4/1 - dark reddish grey	18
FAO GfSD 2006	ColourDry	10R 4/2 - weak red	19
FAO GfSD 2006	ColourDry	10R 4/3 - weak red	2
FAO GfSD 2006	ColourDry	10R 4/4 - weak red	5
FAO GfSD 2006	ColourDry	10R 4/6 - red	10
FAO GfSD 2006	ColourDry	10R 4/8 - red	11
FAO GfSD 2006	ColourDry	10R 5/1 - reddish grey	6
FAO GfSD 2006	ColourDry	10R 5/2 - weak red	7
FAO GfSD 2006	ColourDry	10R 5/3 - weak red	20
FAO GfSD 2006	ColourDry	10R 5/4 - weak red	21
FAO GfSD 2006	ColourDry	10R 5/6 - red	22
FAO GfSD 2006	ColourDry	10R 5/8 - red	23
FAO GfSD 2006	ColourDry	10R 6/1 - reddish grey	24
FAO GfSD 2006	ColourDry	10R 6/2 - pale red	25
FAO GfSD 2006	ColourDry	10R 6/3 - pale red	26
FAO GfSD 2006	ColourDry	10R 6/4 - pale red	27
FAO GfSD 2006	ColourDry	10R 6/6 - light red	28
FAO GfSD 2006	ColourDry	10R 6/8 - light red	29
FAO GfSD 2006	ColourDry	10Y 3/1 - olive	30
FAO GfSD 2006	ColourDry	10Y 4/1 - grey	31
FAO GfSD 2006	ColourDry	10Y 4/2 - olive grey	32
FAO GfSD 2006	ColourDry	10Y 5/1 - grey	33
FAO GfSD 2006	ColourDry	10Y 5/2 - olive grey	34
FAO GfSD 2006	ColourDry	10Y 5/4	35
FAO GfSD 2006	ColourDry	10Y 6/1 - grey	36
FAO GfSD 2006	ColourDry	10Y 6/2 - olive grey	37
FAO GfSD 2006	ColourDry	10Y 6/4	38
FAO GfSD 2006	ColourDry	10Y 6/6	39
FAO GfSD 2006	ColourDry	10Y 6/8	40
FAO GfSD 2006	ColourDry	10Y 7/1 - light grey	41
FAO GfSD 2006	ColourDry	10Y 7/2 - light grey	42
FAO GfSD 2006	ColourDry	10Y 7/4	43
FAO GfSD 2006	ColourDry	10Y 7/6	44
FAO GfSD 2006	ColourDry	10Y 7/8	45
FAO GfSD 2006	ColourDry	10Y 8/10	47
FAO GfSD 2006	ColourDry	10Y 8/1 - light grey	46
FAO GfSD 2006	ColourDry	10Y 8/2 - light grey	48
FAO GfSD 2006	ColourDry	10Y 8/4	49
FAO GfSD 2006	ColourDry	10Y 8/6	50
FAO GfSD 2006	ColourDry	10Y 8/8	51
FAO GfSD 2006	ColourDry	10YR 2/1 - black	52
FAO GfSD 2006	ColourDry	10YR 2/2 - very dark brown	53
FAO GfSD 2006	ColourDry	10YR 3/6 - dark yellowish brown	58
FAO GfSD 2006	ColourDry	10YR 4/1 - dark grey	59
FAO GfSD 2006	ColourDry	10YR 4/2 - dark greyish brown	60
FAO GfSD 2006	ColourDry	10YR 4/3 - (dark) brown	61
FAO GfSD 2006	ColourDry	10YR 4/4 - dark yellowish brown	62
FAO GfSD 2006	ColourDry	10YR 4/6 - dark yellowish brown	63
FAO GfSD 2006	ColourDry	10YR 5/1 - grey	64
FAO GfSD 2006	ColourDry	10YR 5/2 - greyish brown	65
FAO GfSD 2006	ColourDry	10YR 5/3 - brown	66
FAO GfSD 2006	ColourDry	10YR 5/4 - yellowish brown	67
FAO GfSD 2006	ColourDry	10YR 5/6 - yellowish brown	68
FAO GfSD 2006	ColourDry	10YR 5/8 - yellowish brown	69
FAO GfSD 2006	ColourDry	10YR 6/1 - (light) grey	17
FAO GfSD 2006	ColourDry	10YR 6/2 - light brownish grey	3
FAO GfSD 2006	ColourDry	10YR 6/3 - pale brown	8
FAO GfSD 2006	ColourDry	10YR 6/4 - light yellowish brown	9
FAO GfSD 2006	ColourDry	10YR 6/6 - brownish yellow	13
FAO GfSD 2006	ColourDry	10YR 6/8 - brownish yellow	14
FAO GfSD 2006	ColourDry	10YR 7/1 - light grey	70
FAO GfSD 2006	ColourDry	10YR 7/2 - light grey	71
FAO GfSD 2006	ColourDry	10YR 7/3 - very pale brown	72
FAO GfSD 2006	ColourDry	10YR 7/4 - very pale brown	73
FAO GfSD 2006	ColourDry	10YR 7/6 - yellow	74
FAO GfSD 2006	ColourDry	10YR 7/8 - yellow	75
FAO GfSD 2006	ColourDry	10YR 8/1 - white	76
FAO GfSD 2006	ColourDry	10YR 8/2 - white	77
FAO GfSD 2006	ColourDry	10YR 8/3 - very pale brown	78
FAO GfSD 2006	ColourDry	10YR 8/4 - very pale brown	79
FAO GfSD 2006	ColourDry	10YR 8/6 - yellow	80
FAO GfSD 2006	ColourDry	10YR 8/8 - yellow	81
FAO GfSD 2006	ColourDry	2.5Y 2/0 - black	82
FAO GfSD 2006	ColourDry	2.5Y 3/0 - very dark grey	83
FAO GfSD 2006	ColourDry	2.5Y 3/2 - very dark greyish brown	84
FAO GfSD 2006	ColourDry	2.5Y 4/0 - dark grey	85
FAO GfSD 2006	ColourDry	2.5Y 4/2 - dark greyish brown	86
FAO GfSD 2006	ColourDry	2.5Y 4/4 - olive brown	87
FAO GfSD 2006	ColourDry	2.5Y 5/0 - grey	88
FAO GfSD 2006	ColourDry	2.5Y 5/2 - greyish brown	89
FAO GfSD 2006	ColourDry	2.5Y 5/4 - light olive brown	90
FAO GfSD 2006	ColourDry	2.5Y 5/6 - light olive brown	91
FAO GfSD 2006	ColourDry	2.5Y 6/0 - (light) grey	92
FAO GfSD 2006	ColourDry	2.5Y 6/2 - light brownish grey	93
FAO GfSD 2006	ColourDry	2.5Y 6/4 - light yellowish brown	94
FAO GfSD 2006	ColourDry	2.5Y 6/6 - olive yellow	95
FAO GfSD 2006	ColourDry	2.5Y 6/8 - olive yellow	96
FAO GfSD 2006	ColourDry	2.5Y 7/0 - light grey	97
FAO GfSD 2006	ColourDry	2.5Y 7/2 - light grey	98
FAO GfSD 2006	ColourDry	2.5Y 7/4 - pale yellow	99
FAO GfSD 2006	ColourDry	2.5Y 7/6 - yellow	100
FAO GfSD 2006	ColourDry	2.5Y 7/8 - yellow	101
FAO GfSD 2006	ColourDry	2.5Y 8/0 - white	102
FAO GfSD 2006	ColourDry	2.5Y 8/2 - white	103
FAO GfSD 2006	ColourDry	2.5Y 8/4 - pale yellow	104
FAO GfSD 2006	ColourDry	2.5Y 8/6 - yellow	105
FAO GfSD 2006	ColourDry	2.5Y 8/8 - yellow	106
FAO GfSD 2006	ColourDry	2.5YR 2.5/0 - black	107
FAO GfSD 2006	ColourDry	2.5YR 2.5/2 - very dusky red	108
FAO GfSD 2006	ColourDry	2.5YR 2.5/4 - dark reddish brown	109
FAO GfSD 2006	ColourDry	2.5YR 3/0 - very dark grey	110
FAO GfSD 2006	ColourDry	2.5YR 3/2 - dusky red	111
FAO GfSD 2006	ColourDry	2.5YR 3/4 - dark reddish brown	112
FAO GfSD 2006	ColourDry	2.5YR 3/6 - dark red	113
FAO GfSD 2006	ColourDry	2.5YR 4/0 - dark grey	114
FAO GfSD 2006	ColourDry	2.5YR 4/2 - weak red	115
FAO GfSD 2006	ColourDry	2.5YR 4/4 - reddish brown	116
FAO GfSD 2006	ColourDry	2.5YR 4/6 - red	117
FAO GfSD 2006	ColourDry	2.5YR 4/8 - red	1
FAO GfSD 2006	ColourDry	2.5YR 5/0 - grey	4
FAO GfSD 2006	ColourDry	2.5YR 5/2 - weak red	12
FAO GfSD 2006	ColourDry	2.5YR 5/4 - reddish brown	15
FAO GfSD 2006	ColourDry	2.5YR 5/6 - red	16
FAO GfSD 2006	ColourDry	2.5YR 5/8 - red	118
FAO GfSD 2006	ColourDry	2.5YR 6/0 - gray	119
FAO GfSD 2006	ColourDry	2.5YR 6/2 - pale red	120
FAO GfSD 2006	ColourDry	2.5YR 6/4 - light reddish brown	121
FAO GfSD 2006	ColourDry	2.5YR 6/6 - light red	122
FAO GfSD 2006	ColourDry	2.5YR 6/8 - light red	123
FAO GfSD 2006	ColourDry	5B 4/1 - dark bluish grey	124
FAO GfSD 2006	ColourDry	5B 5/1 - bluish grey	125
FAO GfSD 2006	ColourDry	5B 6/1 - bluish grey	126
FAO GfSD 2006	ColourDry	5B 7/1 - light bluish grey	127
FAO GfSD 2006	ColourDry	5BG 4/1 - dark greenish grey	128
FAO GfSD 2006	ColourDry	5BG 5/1 - greenish grey	129
FAO GfSD 2006	ColourDry	5BG 6/1 - greenish grey	130
FAO GfSD 2006	ColourDry	5BG 7/1 - light greenish grey	131
FAO GfSD 2006	ColourDry	5G 4/1 - dark greenish grey	132
FAO GfSD 2006	ColourDry	5G 4/2 - greyish green	133
FAO GfSD 2006	ColourDry	5G 5/1 - greenish grey	134
FAO GfSD 2006	ColourDry	5G 5/2 - greyish green	135
FAO GfSD 2006	ColourDry	5G 6/1 - greenish grey	136
FAO GfSD 2006	ColourDry	5G 6/2 - pale green	137
FAO GfSD 2006	ColourDry	5G 7/1 - light greenish grey	138
FAO GfSD 2006	ColourDry	5G 7/2 - pale green	139
FAO GfSD 2006	ColourDry	5GY 4/1 - dark greenish grey	140
FAO GfSD 2006	ColourDry	5GY 5/1 - greenish grey	141
FAO GfSD 2006	ColourDry	5GY 6/1 - greenish grey	142
FAO GfSD 2006	ColourDry	5GY 7/1 - light greenish grey	143
FAO GfSD 2006	ColourDry	5R 2.5/1 - reddish black	144
FAO GfSD 2006	ColourDry	5R 2.5/2 - very dusky red	145
FAO GfSD 2006	ColourDry	5R 2.5/3 - very dusky red	146
FAO GfSD 2006	ColourDry	5R 2.5/4 - very dusky red	147
FAO GfSD 2006	ColourDry	5R 2.5/6 - dark red	148
FAO GfSD 2006	ColourDry	5R 3/1 - dark reddish grey	149
FAO GfSD 2006	ColourDry	5R 3/2 - dusky red	150
FAO GfSD 2006	ColourDry	5R 3/3 - dusky red	151
FAO GfSD 2006	ColourDry	5R 3/4 - dusky red	152
FAO GfSD 2006	ColourDry	5R 3/6 - dark red	153
FAO GfSD 2006	ColourDry	5R 3/8 - dark red	154
FAO GfSD 2006	ColourDry	5R 4/1 - dark reddish grey	155
FAO GfSD 2006	ColourDry	5R 4/2 - weak red	156
FAO GfSD 2006	ColourDry	5R 4/3 - weak red	157
FAO GfSD 2006	ColourDry	5R 4/4 - weak red	158
FAO GfSD 2006	ColourDry	5R 4/6 - red	159
FAO GfSD 2006	ColourDry	5R 4/8 - red	160
FAO GfSD 2006	ColourDry	5R 5/1 - reddish grey	161
FAO GfSD 2006	ColourDry	5R 5/2 - weak red	162
FAO GfSD 2006	ColourDry	5R 5/3 - weak red	163
FAO GfSD 2006	ColourDry	5R 5/4 - weak red	164
FAO GfSD 2006	ColourDry	5R 5/6 - red	165
FAO GfSD 2006	ColourDry	5R 5/8 - red	166
FAO GfSD 2006	ColourDry	5R 6/1 - reddish grey	167
FAO GfSD 2006	ColourDry	5R 6/2 - pale red	168
FAO GfSD 2006	ColourDry	5R 6/3 - pale red	169
FAO GfSD 2006	ColourDry	5R 6/4 - pale red	170
FAO GfSD 2006	ColourDry	5R 6/6 - light red	171
FAO GfSD 2006	ColourDry	5R 6/8 - light red	172
FAO GfSD 2006	ColourDry	5Y 2.5/1 - black	173
FAO GfSD 2006	ColourDry	5Y 2.5/2 - black	174
FAO GfSD 2006	ColourDry	5Y 3/1 - very dark grey	175
FAO GfSD 2006	ColourDry	5Y 3/2 - dark olive grey	176
FAO GfSD 2006	ColourDry	5Y 4/1 - dark grey	177
FAO GfSD 2006	ColourDry	5Y 4/2 - olive grey	178
FAO GfSD 2006	ColourDry	5Y 4/3 - olive	179
FAO GfSD 2006	ColourDry	5Y 4/4 - olive	180
FAO GfSD 2006	ColourDry	5Y 5/1 - grey	181
FAO GfSD 2006	ColourDry	5Y 5/2 - olive grey	182
FAO GfSD 2006	ColourDry	5Y 5/3 - olive	183
FAO GfSD 2006	ColourDry	5Y 5/4 - olive	184
FAO GfSD 2006	ColourDry	5Y 5/6 - olive	185
FAO GfSD 2006	ColourDry	5Y 6/1 - (light) grey	186
FAO GfSD 2006	ColourDry	5Y 6/2 - light olive grey	187
FAO GfSD 2006	ColourDry	5Y 6/3 - pale olive	188
FAO GfSD 2006	ColourDry	5Y 6/4 - pale olive	189
FAO GfSD 2006	ColourDry	5Y 6/6 - olive yellow	190
FAO GfSD 2006	ColourDry	5Y 6/8 - olive yellow	191
FAO GfSD 2006	ColourDry	5Y 7/1 - light grey	192
FAO GfSD 2006	ColourDry	5Y 7/2 - light grey	193
FAO GfSD 2006	ColourDry	5Y 7/3 - pale yellow	194
FAO GfSD 2006	ColourDry	5Y 7/4 - pale yellow	195
FAO GfSD 2006	ColourDry	5Y 7/6 - yellow	196
FAO GfSD 2006	ColourDry	5Y 7/8 - yellow	197
FAO GfSD 2006	ColourDry	5Y 8/1 - white	198
FAO GfSD 2006	ColourDry	5Y 8/2 - white	199
FAO GfSD 2006	ColourDry	5Y 8/3 - pale yellow	200
FAO GfSD 2006	ColourDry	5Y 8/4 - pale yellow	201
FAO GfSD 2006	ColourDry	5Y 8/6 - yellow	202
FAO GfSD 2006	ColourDry	5Y 8/8 - yellow	203
FAO GfSD 2006	ColourDry	5YR 2.5/1 - black	204
FAO GfSD 2006	ColourDry	5YR 2.5/2 - dark reddish brown	205
FAO GfSD 2006	ColourDry	5YR 3/1 - very dark grey	206
FAO GfSD 2006	ColourDry	5YR 3/2 - dark reddish brown	207
FAO GfSD 2006	ColourDry	5YR 3/3 - dark reddish brown	208
FAO GfSD 2006	ColourDry	5YR 3/4 - dark reddish brown	209
FAO GfSD 2006	ColourDry	5YR 4/1 - dark grey	210
FAO GfSD 2006	ColourDry	5YR 4/2 - dark reddish grey	211
FAO GfSD 2006	ColourDry	5YR 4/3 - reddish brown	212
FAO GfSD 2006	ColourDry	5YR 4/4 - reddish brown	213
FAO GfSD 2006	ColourDry	5YR 4/6 - yellowish red	214
FAO GfSD 2006	ColourDry	5YR 5/1 - grey	215
FAO GfSD 2006	ColourDry	5YR 5/2 - reddish grey	216
FAO GfSD 2006	ColourDry	5YR 5/3 - reddish brown	224
FAO GfSD 2006	ColourDry	5YR 5/4 - reddish brown	225
FAO GfSD 2006	ColourDry	5YR 5/6 - yellowish red	226
FAO GfSD 2006	ColourDry	5YR 5/8 - yellowish red	227
FAO GfSD 2006	ColourDry	5YR 6/1 - (light) grey	228
FAO GfSD 2006	ColourDry	5YR 6/2 - pinkish grey	229
FAO GfSD 2006	ColourDry	5YR 6/3 - light reddish brown	230
FAO GfSD 2006	ColourDry	5YR 6/4 - light reddish brown	231
FAO GfSD 2006	ColourDry	5YR 6/6 - reddish yellow	232
FAO GfSD 2006	ColourDry	5YR 6/8 - reddish yellow	233
FAO GfSD 2006	ColourDry	5YR 7/1 - light grey	234
FAO GfSD 2006	ColourDry	5YR 7/2 - pinkish grey	235
FAO GfSD 2006	ColourDry	5YR 7/3 - pink	236
FAO GfSD 2006	ColourDry	5YR 7/4 - pink	237
FAO GfSD 2006	ColourDry	5YR 7/6 - reddish yellow	238
FAO GfSD 2006	ColourDry	5YR 7/8 - reddish yellow	239
FAO GfSD 2006	ColourDry	5YR 8/1 - white	240
FAO GfSD 2006	ColourDry	5YR 8/2 - pinkish white	241
FAO GfSD 2006	ColourDry	5YR 8/3 - pink	242
FAO GfSD 2006	ColourDry	5YR 8/4 - pink	243
FAO GfSD 2006	ColourDry	7.5GY 2.5/0	244
FAO GfSD 2006	ColourDry	7.5GY 3/0	245
FAO GfSD 2006	ColourDry	7.5GY 3/2	246
FAO GfSD 2006	ColourDry	7.5GY 4/0	247
FAO GfSD 2006	ColourDry	7.5GY 4/2	248
FAO GfSD 2006	ColourDry	7.5GY 4/4	249
FAO GfSD 2006	ColourDry	7.5GY 5/0	250
FAO GfSD 2006	ColourDry	7.5GY 5/2	251
FAO GfSD 2006	ColourDry	7.5GY 5/4	252
FAO GfSD 2006	ColourDry	7.5GY 5/6	253
FAO GfSD 2006	ColourDry	7.5GY 6/0	254
FAO GfSD 2006	ColourDry	7.5GY 6/10	255
FAO GfSD 2006	ColourDry	7.5GY 6/2	256
FAO GfSD 2006	ColourDry	7.5GY 6/4	257
FAO GfSD 2006	ColourDry	7.5GY 6/6	258
FAO GfSD 2006	ColourDry	7.5GY 6/8	259
FAO GfSD 2006	ColourDry	7.5GY 7/10	261
FAO GfSD 2006	ColourDry	7.5GY 7/2	262
FAO GfSD 2006	ColourDry	7.5GY 7/4	263
FAO GfSD 2006	ColourDry	7.5GY 7/6	264
FAO GfSD 2006	ColourDry	7.5GY 7/8	265
FAO GfSD 2006	ColourDry	7.5GY 8/0	266
FAO GfSD 2006	ColourDry	7.5GY 8/2	267
FAO GfSD 2006	ColourDry	7.5GY 8/4	268
FAO GfSD 2006	ColourDry	7.5GY 8/6	269
FAO GfSD 2006	ColourDry	7.5GY 8/8	270
FAO GfSD 2006	ColourDry	7.5R 2.5/0 - black	271
FAO GfSD 2006	ColourDry	7.5R 2.5/2 - very dusky red	272
FAO GfSD 2006	ColourDry	7.5R 2.5/4 - very dusky red	273
FAO GfSD 2006	ColourDry	7.5R 3/0 - very dark grey	274
FAO GfSD 2006	ColourDry	7.5R 3/2 - dusky red	275
FAO GfSD 2006	ColourDry	7.5R 3/4 - dusky red	276
FAO GfSD 2006	ColourDry	7.5R 3/6 - dark red	277
FAO GfSD 2006	ColourDry	7.5R 3/8 - dark red	278
FAO GfSD 2006	ColourDry	7.5R 4/0 - dark grey	279
FAO GfSD 2006	ColourDry	7.5R 4/2 - weak red	280
FAO GfSD 2006	ColourDry	7.5R 4/4 - weak red	281
FAO GfSD 2006	ColourDry	7.5R 4/6 - red	282
FAO GfSD 2006	ColourDry	7.5R 4/8 - red	283
FAO GfSD 2006	ColourDry	7.5R 5/0 - grey	284
FAO GfSD 2006	ColourDry	7.5R 5/2 - weak red	285
FAO GfSD 2006	ColourDry	7.5R 5/4 - weak red	286
FAO GfSD 2006	ColourDry	7.5R 5/6 - red	287
FAO GfSD 2006	ColourDry	7.5R 5/8 - red	288
FAO GfSD 2006	ColourDry	7.5R 6/0 - grey	289
FAO GfSD 2006	ColourDry	7.5R 6/2 - pale red	290
FAO GfSD 2006	ColourDry	7.5R 6/4 - pale red	291
FAO GfSD 2006	ColourDry	7.5R 6/6 - light red	292
FAO GfSD 2006	ColourDry	7.5R 6/8 - light red	293
FAO GfSD 2006	ColourDry	7.5Y 2.5/0	294
FAO GfSD 2006	ColourDry	7.5Y 3/0	295
FAO GfSD 2006	ColourDry	7.5Y 3/2 - olive black	296
FAO GfSD 2006	ColourDry	7.5Y 4/0	297
FAO GfSD 2006	ColourDry	7.5Y 4/2 - greyish olive	298
FAO GfSD 2006	ColourDry	7.5Y 5/0	299
FAO GfSD 2006	ColourDry	7.5Y 5/2 - greyish olive	300
FAO GfSD 2006	ColourDry	7.5Y 5/4	301
FAO GfSD 2006	ColourDry	7.5Y 6/0	302
FAO GfSD 2006	ColourDry	7.5Y 6/2 - greyish olive	303
FAO GfSD 2006	ColourDry	7.5Y 6/4	304
FAO GfSD 2006	ColourDry	7.5Y 6/6	305
FAO GfSD 2006	ColourDry	7.5Y 7/0	306
FAO GfSD 2006	ColourDry	7.5Y 7/10	307
FAO GfSD 2006	ColourDry	7.5Y 7/2 - light grey	308
FAO GfSD 2006	ColourDry	7.5Y 7/4	309
FAO GfSD 2006	ColourDry	7.5Y 7/6	310
FAO GfSD 2006	ColourDry	7.5Y 7/8	311
FAO GfSD 2006	ColourDry	7.5Y 8/0	312
FAO GfSD 2006	ColourDry	7.5Y 8/10	313
FAO GfSD 2006	ColourDry	7.5Y 8/2 - light grey	314
FAO GfSD 2006	ColourDry	7.5Y 8/4	315
FAO GfSD 2006	ColourDry	7.5Y 8/6	316
FAO GfSD 2006	ColourDry	7.5Y 8/8	317
FAO GfSD 2006	ColourDry	7.5YR 2/0 - black	318
FAO GfSD 2006	ColourDry	7.5YR 2/2 - very dark brown	319
FAO GfSD 2006	ColourDry	7.5YR 2/4 - very dark brown	320
FAO GfSD 2006	ColourDry	7.5YR 3/0 - very dark grey	321
FAO GfSD 2006	ColourDry	7.5YR 3/2 - dark brown	322
FAO GfSD 2006	ColourDry	7.5YR 3/4 - dark brown	323
FAO GfSD 2006	ColourDry	7.5YR 4/0 - dark grey	324
FAO GfSD 2006	ColourDry	7.5YR 4/2 - (dark) brown	325
FAO GfSD 2006	ColourDry	7.5YR 4/4 - (dark) brown	326
FAO GfSD 2006	ColourDry	7.5YR 4/6 - strong brown	327
FAO GfSD 2006	ColourDry	7.5YR 5/0 - grey	328
FAO GfSD 2006	ColourDry	7.5YR 5/2 - brown	329
FAO GfSD 2006	ColourDry	7.5YR 5/4 - brown	330
FAO GfSD 2006	ColourDry	7.5YR 5/6 - strong brown	331
FAO GfSD 2006	ColourDry	7.5YR 5/8 - strong brown	332
FAO GfSD 2006	ColourDry	7.5YR 6/0 - (light) grey	333
FAO GfSD 2006	ColourDry	7.5YR 6/2 - pinkish grey	334
FAO GfSD 2006	ColourDry	7.5YR 6/4 - light brown	335
FAO GfSD 2006	ColourDry	7.5YR 6/6 - reddish yellow	336
FAO GfSD 2006	ColourDry	7.5YR 6/8 - reddish yellow	337
FAO GfSD 2006	ColourDry	7.5YR 7/0 - light grey	338
FAO GfSD 2006	ColourDry	7.5YR 7/2 - pinkish grey	339
FAO GfSD 2006	ColourDry	7.5YR 7/4 - pink	340
FAO GfSD 2006	ColourDry	7.5YR 7/6 - reddish yellow	341
FAO GfSD 2006	ColourDry	7.5YR 7/8 - reddish yellow	342
FAO GfSD 2006	ColourDry	7.5YR 8/0 - white	343
FAO GfSD 2006	ColourDry	7.5YR 8/2 - pinkish white	344
FAO GfSD 2006	ColourDry	7.5YR 8/4 - pink	345
FAO GfSD 2006	ColourDry	7.5YR 8/6 - reddish yellow	346
FAO GfSD 2006	ColourDry	N 2.5/ - black	347
FAO GfSD 2006	ColourDry	N 2/ - black	348
FAO GfSD 2006	ColourDry	N 3/ - very dark grey	349
FAO GfSD 2006	ColourDry	N 4/ - dark grey	350
FAO GfSD 2006	ColourDry	N 5/ - grey	351
FAO GfSD 2006	ColourDry	N 6/ - (light) grey	352
FAO GfSD 2006	ColourDry	N 7/ - light grey	353
FAO GfSD 2006	ColourDry	N 8/ - white	354
FAO GfSD 2006	ColourMoist	10R 2.5/1 - reddish black	217
FAO GfSD 2006	ColourMoist	10R 2.5/2 - very dusky red	218
FAO GfSD 2006	ColourMoist	10R 3/1 - dark reddish grey	219
FAO GfSD 2006	ColourMoist	10R 3/2 - dusky red	220
FAO GfSD 2006	ColourMoist	10R 3/3 - dusky red	221
FAO GfSD 2006	ColourMoist	10R 3/4 - dusky red	222
FAO GfSD 2006	ColourMoist	10R 3/6 - dark red	223
FAO GfSD 2006	ColourMoist	10R 4/1 - dark reddish grey	18
FAO GfSD 2006	ColourMoist	10R 4/2 - weak red	19
FAO GfSD 2006	ColourMoist	10R 4/3 - weak red	2
FAO GfSD 2006	ColourMoist	10R 4/4 - weak red	5
FAO GfSD 2006	ColourMoist	10R 4/6 - red	10
FAO GfSD 2006	ColourMoist	10R 4/8 - red	11
FAO GfSD 2006	ColourMoist	10R 5/1 - reddish grey	6
FAO GfSD 2006	ColourMoist	10R 5/2 - weak red	7
FAO GfSD 2006	ColourMoist	10R 5/3 - weak red	20
FAO GfSD 2006	ColourMoist	10R 5/4 - weak red	21
FAO GfSD 2006	ColourMoist	10R 5/6 - red	22
FAO GfSD 2006	ColourMoist	10R 5/8 - red	23
FAO GfSD 2006	ColourMoist	10R 6/1 - reddish grey	24
FAO GfSD 2006	ColourMoist	10R 6/2 - pale red	25
FAO GfSD 2006	ColourMoist	10R 6/3 - pale red	26
FAO GfSD 2006	ColourMoist	10R 6/4 - pale red	27
FAO GfSD 2006	ColourMoist	10R 6/6 - light red	28
FAO GfSD 2006	ColourMoist	10R 6/8 - light red	29
FAO GfSD 2006	ColourMoist	10Y 3/1 - olive	30
FAO GfSD 2006	ColourMoist	10Y 4/1 - grey	31
FAO GfSD 2006	ColourMoist	10Y 4/2 - olive grey	32
FAO GfSD 2006	ColourMoist	10Y 5/1 - grey	33
FAO GfSD 2006	ColourMoist	10Y 5/2 - olive grey	34
FAO GfSD 2006	ColourMoist	10Y 5/4	35
FAO GfSD 2006	ColourMoist	10Y 6/1 - grey	36
FAO GfSD 2006	ColourMoist	10Y 6/2 - olive grey	37
FAO GfSD 2006	ColourMoist	10Y 6/4	38
FAO GfSD 2006	ColourMoist	10Y 6/6	39
FAO GfSD 2006	ColourMoist	10Y 6/8	40
FAO GfSD 2006	ColourMoist	10Y 7/1 - light grey	41
FAO GfSD 2006	ColourMoist	10Y 7/2 - light grey	42
FAO GfSD 2006	ColourMoist	10Y 7/4	43
FAO GfSD 2006	ColourMoist	10Y 7/6	44
FAO GfSD 2006	ColourMoist	10Y 7/8	45
FAO GfSD 2006	ColourMoist	10Y 8/10	47
FAO GfSD 2006	ColourMoist	10Y 8/1 - light grey	46
FAO GfSD 2006	ColourMoist	10Y 8/2 - light grey	48
FAO GfSD 2006	ColourMoist	10Y 8/4	49
FAO GfSD 2006	ColourMoist	10Y 8/6	50
FAO GfSD 2006	ColourMoist	10Y 8/8	51
FAO GfSD 2006	ColourMoist	10YR 2/1 - black	52
FAO GfSD 2006	ColourMoist	10YR 2/2 - very dark brown	53
FAO GfSD 2006	ColourMoist	10YR 3/1 - very dark grey	54
FAO GfSD 2006	ColourMoist	10YR 3/2 - very dark greyish brown	55
FAO GfSD 2006	ColourMoist	10YR 3/3 - dark brown	56
FAO GfSD 2006	ColourMoist	10YR 3/4 - dark yellowish brown	57
FAO GfSD 2006	ColourMoist	10YR 3/6 - dark yellowish brown	58
FAO GfSD 2006	ColourMoist	10YR 4/1 - dark grey	59
FAO GfSD 2006	ColourMoist	10YR 4/2 - dark greyish brown	60
FAO GfSD 2006	ColourMoist	10YR 4/3 - (dark) brown	61
FAO GfSD 2006	ColourMoist	10YR 4/4 - dark yellowish brown	62
FAO GfSD 2006	ColourMoist	10YR 4/6 - dark yellowish brown	63
FAO GfSD 2006	ColourMoist	10YR 5/1 - grey	64
FAO GfSD 2006	ColourMoist	10YR 5/2 - greyish brown	65
FAO GfSD 2006	ColourMoist	10YR 5/3 - brown	66
FAO GfSD 2006	ColourMoist	10YR 5/4 - yellowish brown	67
FAO GfSD 2006	ColourMoist	10YR 5/6 - yellowish brown	68
FAO GfSD 2006	ColourMoist	10YR 5/8 - yellowish brown	69
FAO GfSD 2006	ColourMoist	10YR 6/1 - (light) grey	17
FAO GfSD 2006	ColourMoist	10YR 6/2 - light brownish grey	3
FAO GfSD 2006	ColourMoist	10YR 6/3 - pale brown	8
FAO GfSD 2006	ColourMoist	10YR 6/4 - light yellowish brown	9
FAO GfSD 2006	ColourMoist	10YR 6/6 - brownish yellow	13
FAO GfSD 2006	ColourMoist	10YR 6/8 - brownish yellow	14
FAO GfSD 2006	ColourMoist	10YR 7/1 - light grey	70
FAO GfSD 2006	ColourMoist	10YR 7/2 - light grey	71
FAO GfSD 2006	ColourMoist	10YR 7/3 - very pale brown	72
FAO GfSD 2006	ColourMoist	10YR 7/4 - very pale brown	73
FAO GfSD 2006	ColourMoist	10YR 7/6 - yellow	74
FAO GfSD 2006	ColourMoist	10YR 7/8 - yellow	75
FAO GfSD 2006	ColourMoist	10YR 8/1 - white	76
FAO GfSD 2006	ColourMoist	10YR 8/2 - white	77
FAO GfSD 2006	ColourMoist	10YR 8/3 - very pale brown	78
FAO GfSD 2006	ColourMoist	10YR 8/4 - very pale brown	79
FAO GfSD 2006	ColourMoist	10YR 8/6 - yellow	80
FAO GfSD 2006	ColourMoist	10YR 8/8 - yellow	81
FAO GfSD 2006	ColourMoist	2.5Y 2/0 - black	82
FAO GfSD 2006	ColourMoist	2.5Y 3/0 - very dark grey	83
FAO GfSD 2006	ColourMoist	2.5Y 3/2 - very dark greyish brown	84
FAO GfSD 2006	ColourMoist	2.5Y 4/0 - dark grey	85
FAO GfSD 2006	ColourMoist	2.5Y 4/2 - dark greyish brown	86
FAO GfSD 2006	ColourMoist	2.5Y 4/4 - olive brown	87
FAO GfSD 2006	ColourMoist	2.5Y 5/0 - grey	88
FAO GfSD 2006	ColourMoist	2.5Y 5/2 - greyish brown	89
FAO GfSD 2006	ColourMoist	2.5Y 5/4 - light olive brown	90
FAO GfSD 2006	ColourMoist	2.5Y 5/6 - light olive brown	91
FAO GfSD 2006	ColourMoist	2.5Y 6/0 - (light) grey	92
FAO GfSD 2006	ColourMoist	2.5Y 6/2 - light brownish grey	93
FAO GfSD 2006	ColourMoist	2.5Y 6/4 - light yellowish brown	94
FAO GfSD 2006	ColourMoist	2.5Y 6/6 - olive yellow	95
FAO GfSD 2006	ColourMoist	2.5Y 6/8 - olive yellow	96
FAO GfSD 2006	ColourMoist	2.5Y 7/0 - light grey	97
FAO GfSD 2006	ColourMoist	2.5Y 7/2 - light grey	98
FAO GfSD 2006	ColourMoist	2.5Y 7/4 - pale yellow	99
FAO GfSD 2006	ColourMoist	2.5Y 7/6 - yellow	100
FAO GfSD 2006	ColourMoist	2.5Y 7/8 - yellow	101
FAO GfSD 2006	ColourMoist	2.5Y 8/0 - white	102
FAO GfSD 2006	ColourMoist	2.5Y 8/2 - white	103
FAO GfSD 2006	ColourMoist	2.5Y 8/4 - pale yellow	104
FAO GfSD 2006	ColourMoist	2.5Y 8/6 - yellow	105
FAO GfSD 2006	ColourMoist	2.5Y 8/8 - yellow	106
FAO GfSD 2006	ColourMoist	2.5YR 2.5/0 - black	107
FAO GfSD 2006	ColourMoist	2.5YR 2.5/2 - very dusky red	108
FAO GfSD 2006	ColourMoist	2.5YR 2.5/4 - dark reddish brown	109
FAO GfSD 2006	ColourMoist	2.5YR 3/0 - very dark grey	110
FAO GfSD 2006	ColourMoist	2.5YR 3/2 - dusky red	111
FAO GfSD 2006	ColourMoist	2.5YR 3/4 - dark reddish brown	112
FAO GfSD 2006	ColourMoist	2.5YR 3/6 - dark red	113
FAO GfSD 2006	ColourMoist	2.5YR 4/0 - dark grey	114
FAO GfSD 2006	ColourMoist	2.5YR 4/2 - weak red	115
FAO GfSD 2006	ColourMoist	2.5YR 4/4 - reddish brown	116
FAO GfSD 2006	ColourMoist	2.5YR 4/6 - red	117
FAO GfSD 2006	ColourMoist	2.5YR 4/8 - red	1
FAO GfSD 2006	ColourMoist	2.5YR 5/0 - grey	4
FAO GfSD 2006	ColourMoist	2.5YR 5/2 - weak red	12
FAO GfSD 2006	ColourMoist	2.5YR 5/4 - reddish brown	15
FAO GfSD 2006	ColourMoist	2.5YR 5/6 - red	16
FAO GfSD 2006	ColourMoist	2.5YR 5/8 - red	118
FAO GfSD 2006	ColourMoist	2.5YR 6/0 - gray	119
FAO GfSD 2006	ColourMoist	2.5YR 6/2 - pale red	120
FAO GfSD 2006	ColourMoist	2.5YR 6/4 - light reddish brown	121
FAO GfSD 2006	ColourMoist	2.5YR 6/6 - light red	122
FAO GfSD 2006	ColourMoist	2.5YR 6/8 - light red	123
FAO GfSD 2006	ColourMoist	5B 4/1 - dark bluish grey	124
FAO GfSD 2006	ColourMoist	5B 5/1 - bluish grey	125
FAO GfSD 2006	ColourMoist	5B 6/1 - bluish grey	126
FAO GfSD 2006	ColourMoist	5B 7/1 - light bluish grey	127
FAO GfSD 2006	ColourMoist	5BG 4/1 - dark greenish grey	128
FAO GfSD 2006	ColourMoist	5BG 5/1 - greenish grey	129
FAO GfSD 2006	ColourMoist	5BG 6/1 - greenish grey	130
FAO GfSD 2006	ColourMoist	5BG 7/1 - light greenish grey	131
FAO GfSD 2006	ColourMoist	5G 4/1 - dark greenish grey	132
FAO GfSD 2006	ColourMoist	5G 4/2 - greyish green	133
FAO GfSD 2006	ColourMoist	5G 5/1 - greenish grey	134
FAO GfSD 2006	ColourMoist	5G 5/2 - greyish green	135
FAO GfSD 2006	ColourMoist	5G 6/1 - greenish grey	136
FAO GfSD 2006	ColourMoist	5G 6/2 - pale green	137
FAO GfSD 2006	ColourMoist	5G 7/1 - light greenish grey	138
FAO GfSD 2006	ColourMoist	5G 7/2 - pale green	139
FAO GfSD 2006	ColourMoist	5GY 4/1 - dark greenish grey	140
FAO GfSD 2006	ColourMoist	5GY 5/1 - greenish grey	141
FAO GfSD 2006	ColourMoist	5GY 6/1 - greenish grey	142
FAO GfSD 2006	ColourMoist	5GY 7/1 - light greenish grey	143
FAO GfSD 2006	ColourMoist	5R 2.5/1 - reddish black	144
FAO GfSD 2006	ColourMoist	5R 2.5/2 - very dusky red	145
FAO GfSD 2006	ColourMoist	5R 2.5/3 - very dusky red	146
FAO GfSD 2006	ColourMoist	5R 2.5/4 - very dusky red	147
FAO GfSD 2006	ColourMoist	5R 2.5/6 - dark red	148
FAO GfSD 2006	ColourMoist	5R 3/1 - dark reddish grey	149
FAO GfSD 2006	ColourMoist	5R 3/2 - dusky red	150
FAO GfSD 2006	ColourMoist	5R 3/3 - dusky red	151
FAO GfSD 2006	ColourMoist	5R 3/4 - dusky red	152
FAO GfSD 2006	ColourMoist	5R 3/6 - dark red	153
FAO GfSD 2006	ColourMoist	5R 3/8 - dark red	154
FAO GfSD 2006	ColourMoist	5R 4/1 - dark reddish grey	155
FAO GfSD 2006	ColourMoist	5R 4/2 - weak red	156
FAO GfSD 2006	ColourMoist	5R 4/3 - weak red	157
FAO GfSD 2006	ColourMoist	5R 4/4 - weak red	158
FAO GfSD 2006	ColourMoist	5R 4/6 - red	159
FAO GfSD 2006	ColourMoist	5R 4/8 - red	160
FAO GfSD 2006	ColourMoist	5R 5/1 - reddish grey	161
FAO GfSD 2006	ColourMoist	5R 5/2 - weak red	162
FAO GfSD 2006	ColourMoist	5R 5/3 - weak red	163
FAO GfSD 2006	ColourMoist	5R 5/4 - weak red	164
FAO GfSD 2006	ColourMoist	5R 5/6 - red	165
FAO GfSD 2006	ColourMoist	5R 5/8 - red	166
FAO GfSD 2006	ColourMoist	5R 6/1 - reddish grey	167
FAO GfSD 2006	ColourMoist	5R 6/2 - pale red	168
FAO GfSD 2006	ColourMoist	5R 6/3 - pale red	169
FAO GfSD 2006	ColourMoist	5R 6/4 - pale red	170
FAO GfSD 2006	ColourMoist	5R 6/6 - light red	171
FAO GfSD 2006	ColourMoist	5R 6/8 - light red	172
FAO GfSD 2006	ColourMoist	5Y 2.5/1 - black	173
FAO GfSD 2006	ColourMoist	5Y 2.5/2 - black	174
FAO GfSD 2006	ColourMoist	5Y 3/1 - very dark grey	175
FAO GfSD 2006	ColourMoist	5Y 3/2 - dark olive grey	176
FAO GfSD 2006	ColourMoist	5Y 4/1 - dark grey	177
FAO GfSD 2006	ColourMoist	5Y 4/2 - olive grey	178
FAO GfSD 2006	ColourMoist	5Y 4/3 - olive	179
FAO GfSD 2006	ColourMoist	5Y 4/4 - olive	180
FAO GfSD 2006	ColourMoist	5Y 5/1 - grey	181
FAO GfSD 2006	ColourMoist	5Y 5/2 - olive grey	182
FAO GfSD 2006	ColourMoist	5Y 5/3 - olive	183
FAO GfSD 2006	ColourMoist	5Y 5/4 - olive	184
FAO GfSD 2006	ColourMoist	5Y 5/6 - olive	185
FAO GfSD 2006	ColourMoist	5Y 6/1 - (light) grey	186
FAO GfSD 2006	ColourMoist	5Y 6/2 - light olive grey	187
FAO GfSD 2006	ColourMoist	5Y 6/3 - pale olive	188
FAO GfSD 2006	ColourMoist	5Y 6/4 - pale olive	189
FAO GfSD 2006	ColourMoist	5Y 6/6 - olive yellow	190
FAO GfSD 2006	ColourMoist	5Y 6/8 - olive yellow	191
FAO GfSD 2006	ColourMoist	5Y 7/1 - light grey	192
FAO GfSD 2006	ColourMoist	5Y 7/2 - light grey	193
FAO GfSD 2006	ColourMoist	5Y 7/3 - pale yellow	194
FAO GfSD 2006	ColourMoist	5Y 7/4 - pale yellow	195
FAO GfSD 2006	ColourMoist	5Y 7/6 - yellow	196
FAO GfSD 2006	ColourMoist	5Y 7/8 - yellow	197
FAO GfSD 2006	ColourMoist	5Y 8/1 - white	198
FAO GfSD 2006	ColourMoist	5Y 8/2 - white	199
FAO GfSD 2006	ColourMoist	5Y 8/3 - pale yellow	200
FAO GfSD 2006	ColourMoist	5Y 8/4 - pale yellow	201
FAO GfSD 2006	ColourMoist	5Y 8/6 - yellow	202
FAO GfSD 2006	ColourMoist	5Y 8/8 - yellow	203
FAO GfSD 2006	ColourMoist	5YR 2.5/1 - black	204
FAO GfSD 2006	ColourMoist	5YR 2.5/2 - dark reddish brown	205
FAO GfSD 2006	ColourMoist	5YR 3/1 - very dark grey	206
FAO GfSD 2006	ColourMoist	5YR 3/2 - dark reddish brown	207
FAO GfSD 2006	ColourMoist	5YR 3/3 - dark reddish brown	208
FAO GfSD 2006	ColourMoist	5YR 3/4 - dark reddish brown	209
FAO GfSD 2006	ColourMoist	5YR 4/1 - dark grey	210
FAO GfSD 2006	ColourMoist	5YR 4/2 - dark reddish grey	211
FAO GfSD 2006	ColourMoist	5YR 4/3 - reddish brown	212
FAO GfSD 2006	ColourMoist	5YR 4/4 - reddish brown	213
FAO GfSD 2006	ColourMoist	5YR 4/6 - yellowish red	214
FAO GfSD 2006	ColourMoist	5YR 5/1 - grey	215
FAO GfSD 2006	ColourMoist	5YR 5/2 - reddish grey	216
FAO GfSD 2006	ColourMoist	5YR 5/3 - reddish brown	224
FAO GfSD 2006	ColourMoist	5YR 5/4 - reddish brown	225
FAO GfSD 2006	ColourMoist	5YR 5/6 - yellowish red	226
FAO GfSD 2006	ColourMoist	5YR 5/8 - yellowish red	227
FAO GfSD 2006	ColourMoist	5YR 6/1 - (light) grey	228
FAO GfSD 2006	ColourMoist	5YR 6/2 - pinkish grey	229
FAO GfSD 2006	ColourMoist	5YR 6/3 - light reddish brown	230
FAO GfSD 2006	ColourMoist	5YR 6/4 - light reddish brown	231
FAO GfSD 2006	ColourMoist	5YR 6/6 - reddish yellow	232
FAO GfSD 2006	ColourMoist	5YR 6/8 - reddish yellow	233
FAO GfSD 2006	ColourMoist	5YR 7/1 - light grey	234
FAO GfSD 2006	ColourMoist	5YR 7/2 - pinkish grey	235
FAO GfSD 2006	ColourMoist	5YR 7/3 - pink	236
FAO GfSD 2006	ColourMoist	5YR 7/4 - pink	237
FAO GfSD 2006	ColourMoist	5YR 7/6 - reddish yellow	238
FAO GfSD 2006	ColourMoist	5YR 7/8 - reddish yellow	239
FAO GfSD 2006	ColourMoist	5YR 8/1 - white	240
FAO GfSD 2006	ColourMoist	5YR 8/2 - pinkish white	241
FAO GfSD 2006	ColourMoist	5YR 8/3 - pink	242
FAO GfSD 2006	ColourMoist	5YR 8/4 - pink	243
FAO GfSD 2006	ColourMoist	7.5GY 2.5/0	244
FAO GfSD 2006	ColourMoist	7.5GY 3/0	245
FAO GfSD 2006	ColourMoist	7.5GY 3/2	246
FAO GfSD 2006	ColourMoist	7.5GY 4/0	247
FAO GfSD 2006	ColourMoist	7.5GY 4/2	248
FAO GfSD 2006	ColourMoist	7.5GY 4/4	249
FAO GfSD 2006	ColourMoist	7.5GY 5/0	250
FAO GfSD 2006	ColourMoist	7.5GY 5/2	251
FAO GfSD 2006	ColourMoist	7.5GY 5/4	252
FAO GfSD 2006	ColourMoist	7.5GY 5/6	253
FAO GfSD 2006	ColourMoist	7.5GY 6/0	254
FAO GfSD 2006	ColourMoist	7.5GY 6/10	255
FAO GfSD 2006	ColourMoist	7.5GY 6/2	256
FAO GfSD 2006	ColourMoist	7.5GY 6/4	257
FAO GfSD 2006	ColourMoist	7.5GY 6/6	258
FAO GfSD 2006	ColourMoist	7.5GY 6/8	259
FAO GfSD 2006	ColourMoist	7.5GY 7/0	260
FAO GfSD 2006	ColourMoist	7.5GY 7/10	261
FAO GfSD 2006	ColourMoist	7.5GY 7/2	262
FAO GfSD 2006	ColourMoist	7.5GY 7/4	263
FAO GfSD 2006	ColourMoist	7.5GY 7/6	264
FAO GfSD 2006	ColourMoist	7.5GY 7/8	265
FAO GfSD 2006	ColourMoist	7.5GY 8/0	266
FAO GfSD 2006	ColourMoist	7.5GY 8/2	267
FAO GfSD 2006	ColourMoist	7.5GY 8/4	268
FAO GfSD 2006	ColourMoist	7.5GY 8/6	269
FAO GfSD 2006	ColourMoist	7.5GY 8/8	270
FAO GfSD 2006	ColourMoist	7.5R 2.5/0 - black	271
FAO GfSD 2006	ColourMoist	7.5R 2.5/2 - very dusky red	272
FAO GfSD 2006	ColourMoist	7.5R 2.5/4 - very dusky red	273
FAO GfSD 2006	ColourMoist	7.5R 3/0 - very dark grey	274
FAO GfSD 2006	ColourMoist	7.5R 3/2 - dusky red	275
FAO GfSD 2006	ColourMoist	7.5R 3/4 - dusky red	276
FAO GfSD 2006	ColourMoist	7.5R 3/6 - dark red	277
FAO GfSD 2006	ColourMoist	7.5R 3/8 - dark red	278
FAO GfSD 2006	ColourMoist	7.5R 4/0 - dark grey	279
FAO GfSD 2006	ColourMoist	7.5R 4/2 - weak red	280
FAO GfSD 2006	ColourMoist	7.5R 4/4 - weak red	281
FAO GfSD 2006	ColourMoist	7.5R 4/6 - red	282
FAO GfSD 2006	ColourMoist	7.5R 4/8 - red	283
FAO GfSD 2006	ColourMoist	7.5R 5/0 - grey	284
FAO GfSD 2006	ColourMoist	7.5R 5/2 - weak red	285
FAO GfSD 2006	ColourMoist	7.5R 5/4 - weak red	286
FAO GfSD 2006	ColourMoist	7.5R 5/6 - red	287
FAO GfSD 2006	ColourMoist	7.5R 5/8 - red	288
FAO GfSD 2006	ColourMoist	7.5R 6/0 - grey	289
FAO GfSD 2006	ColourMoist	7.5R 6/2 - pale red	290
FAO GfSD 2006	ColourMoist	7.5R 6/4 - pale red	291
FAO GfSD 2006	ColourMoist	7.5R 6/6 - light red	292
FAO GfSD 2006	ColourMoist	7.5R 6/8 - light red	293
FAO GfSD 2006	ColourMoist	7.5Y 2.5/0	294
FAO GfSD 2006	ColourMoist	7.5Y 3/0	295
FAO GfSD 2006	ColourMoist	7.5Y 3/2 - olive black	296
FAO GfSD 2006	ColourMoist	7.5Y 4/0	297
FAO GfSD 2006	ColourMoist	7.5Y 4/2 - greyish olive	298
FAO GfSD 2006	ColourMoist	7.5Y 5/0	299
FAO GfSD 2006	ColourMoist	7.5Y 5/2 - greyish olive	300
FAO GfSD 2006	ColourMoist	7.5Y 5/4	301
FAO GfSD 2006	ColourMoist	7.5Y 6/0	302
FAO GfSD 2006	ColourMoist	7.5Y 6/2 - greyish olive	303
FAO GfSD 2006	ColourMoist	7.5Y 6/4	304
FAO GfSD 2006	ColourMoist	7.5Y 6/6	305
FAO GfSD 2006	ColourMoist	7.5Y 7/0	306
FAO GfSD 2006	ColourMoist	7.5Y 7/10	307
FAO GfSD 2006	ColourMoist	7.5Y 7/2 - light grey	308
FAO GfSD 2006	ColourMoist	7.5Y 7/4	309
FAO GfSD 2006	ColourMoist	7.5Y 7/6	310
FAO GfSD 2006	ColourMoist	7.5Y 7/8	311
FAO GfSD 2006	ColourMoist	7.5Y 8/0	312
FAO GfSD 2006	ColourMoist	7.5Y 8/10	313
FAO GfSD 2006	ColourMoist	7.5Y 8/2 - light grey	314
FAO GfSD 2006	ColourMoist	7.5Y 8/4	315
FAO GfSD 2006	ColourMoist	7.5Y 8/6	316
FAO GfSD 2006	ColourMoist	7.5Y 8/8	317
FAO GfSD 2006	ColourMoist	7.5YR 2/0 - black	318
FAO GfSD 2006	ColourMoist	7.5YR 2/2 - very dark brown	319
FAO GfSD 2006	ColourMoist	7.5YR 2/4 - very dark brown	320
FAO GfSD 2006	ColourMoist	7.5YR 3/0 - very dark grey	321
FAO GfSD 2006	ColourMoist	7.5YR 3/2 - dark brown	322
FAO GfSD 2006	ColourMoist	7.5YR 3/4 - dark brown	323
FAO GfSD 2006	ColourMoist	7.5YR 4/0 - dark grey	324
FAO GfSD 2006	ColourMoist	7.5YR 4/2 - (dark) brown	325
FAO GfSD 2006	ColourMoist	7.5YR 4/4 - (dark) brown	326
FAO GfSD 2006	ColourMoist	7.5YR 4/6 - strong brown	327
FAO GfSD 2006	ColourMoist	7.5YR 5/0 - grey	328
FAO GfSD 2006	ColourMoist	7.5YR 5/2 - brown	329
FAO GfSD 2006	ColourMoist	7.5YR 5/4 - brown	330
FAO GfSD 2006	ColourMoist	7.5YR 5/6 - strong brown	331
FAO GfSD 2006	ColourMoist	7.5YR 5/8 - strong brown	332
FAO GfSD 2006	ColourMoist	7.5YR 6/0 - (light) grey	333
FAO GfSD 2006	ColourMoist	7.5YR 6/2 - pinkish grey	334
FAO GfSD 2006	ColourMoist	7.5YR 6/4 - light brown	335
FAO GfSD 2006	ColourMoist	7.5YR 6/6 - reddish yellow	336
FAO GfSD 2006	ColourMoist	7.5YR 6/8 - reddish yellow	337
FAO GfSD 2006	ColourMoist	7.5YR 7/0 - light grey	338
FAO GfSD 2006	ColourMoist	7.5YR 7/2 - pinkish grey	339
FAO GfSD 2006	ColourMoist	7.5YR 7/4 - pink	340
FAO GfSD 2006	ColourMoist	7.5YR 7/6 - reddish yellow	341
FAO GfSD 2006	ColourMoist	7.5YR 7/8 - reddish yellow	342
FAO GfSD 2006	ColourMoist	7.5YR 8/0 - white	343
FAO GfSD 2006	ColourMoist	7.5YR 8/2 - pinkish white	344
FAO GfSD 2006	ColourMoist	7.5YR 8/4 - pink	345
FAO GfSD 2006	ColourMoist	7.5YR 8/6 - reddish yellow	346
FAO GfSD 2006	ColourMoist	N 2.5/ - black	347
FAO GfSD 2006	ColourMoist	N 2/ - black	348
FAO GfSD 2006	ColourMoist	N 3/ - very dark grey	349
FAO GfSD 2006	ColourMoist	N 4/ - dark grey	350
FAO GfSD 2006	ColourMoist	N 5/ - grey	351
FAO GfSD 2006	ColourMoist	N 6/ - (light) grey	352
FAO GfSD 2006	ColourMoist	N 7/ - light grey	353
FAO GfSD 2006	ColourMoist	N 8/ - white	354
FAO GfSD 2006	ConsistenceDry	EHA - Extremely hard: Extremely resistant to pressure; cannot be broken in the hand.	9
FAO GfSD 2006	ConsistenceDry	HA - Hard: Moderately resistant to pressure; can be broken in the hands; not breakable between thumb and forefinger.	6
FAO GfSD 2006	ConsistenceDry	HVH - hard to very hard:	7
FAO GfSD 2006	ConsistenceDry	LO - Loose: Non-coherent.	1
FAO GfSD 2006	ConsistenceDry	SHA - Slightly hard: Weakly resistant to pressure; easily broken between thumb and forefinger.	4
FAO GfSD 2006	ConsistenceDry	SHH - slightly hard to hard:	5
FAO GfSD 2006	ConsistenceDry	SO - Soft: Soil mass is very weakly coherent and fragile; breaks to powder or individual grains under very slight pressure.	2
FAO GfSD 2006	ConsistenceDry	SSH - soft to slightly hard:	3
FAO GfSD 2006	ConsistenceDry	VHA - Very hard: Very resistant to pressure; can be broken in the hands only with difficulty.	8
FAO GfSD 2006	ConsistenceMoist	EFI - Extremely firm: Soil material crushes only under very strong pressure; cannot be crushed between thumb and forefinger.	9
FAO GfSD 2006	ConsistenceMoist	FI - Firm: Soil material crushes under moderate pressure between thumb and forefinger, but resistance is distinctly noticeable.	6
FAO GfSD 2006	ConsistenceMoist	FRF - Friable to firm:	5
FAO GfSD 2006	ConsistenceMoist	FR - Friable: Soil material crushes easily under gentle to moderate pressure between thumb and forefinger, and coheres when pressed together.	4
FAO GfSD 2006	ConsistenceMoist	FVF - Firm to very firm:	7
FAO GfSD 2006	ConsistenceMoist	LO - Loose: Non-coherent.	1
FAO GfSD 2006	ConsistenceMoist	VFF - Very friable to friable:	3
FAO GfSD 2006	ConsistenceMoist	VFI - Very firm: Soil material crushes under strong pressures; barely crushable between thumb and forefinger.	8
FAO GfSD 2006	ConsistenceMoist	VFR - Very friable: Soil material crushes under very gentle pressure, but coheres when pressed together.	2
FAO GfSD 2006	ConsistenceWet	EFI - Extremely firm: Soil material crushes only under very strong pressure; cannot be crushed between thumb and forefinger.	9
FAO GfSD 2006	ConsistenceWet	FI - Firm: Soil material crushes under moderate pressure between thumb and forefinger, but resistance is distinctly noticeable.	6
FAO GfSD 2006	ConsistenceWet	FRF - Friable to firm:	5
FAO GfSD 2006	ConsistenceWet	FR - Friable: Soil material crushes easily under gentle to moderate pressure between thumb and forefinger, and coheres when pressed together.	4
FAO GfSD 2006	ConsistenceWet	FVF - Firm to very firm:	7
FAO GfSD 2006	ConsistenceWet	LO - Loose: Non-coherent.	1
FAO GfSD 2006	ConsistenceWet	VFF - Very friable to friable:	3
FAO GfSD 2006	ConsistenceWet	VFI - Very firm: Soil material crushes under strong pressures; barely crushable between thumb and forefinger.	8
FAO GfSD 2006	ConsistenceWet	VFR - Very friable: Soil material crushes under very gentle pressure, but coheres when pressed together.	2
FAO GfSD 2006	FieldTexture	C - Clay	12
FAO GfSD 2006	FieldTexture	CL - Clay loam	7
FAO GfSD 2006	FieldTexture	CS - Very coarse and coarse sand	15
FAO GfSD 2006	FieldTexture	FS - Fine sand	17
FAO GfSD 2006	FieldTexture	HC - Heavy clay	13
FAO GfSD 2006	FieldTexture	L - Loam	8
FAO GfSD 2006	FieldTexture	LS - Loamy sand	2
FAO GfSD 2006	FieldTexture	MS - Medium sand	16
FAO GfSD 2006	FieldTexture	SCL - Sandy clay loam	4
FAO GfSD 2006	FieldTexture	SC - Sandy clay	10
FAO GfSD 2006	FieldTexture	SiCL - Silty clay loam	6
FAO GfSD 2006	FieldTexture	SiC - Silty clay	11
FAO GfSD 2006	FieldTexture	SiL - Silt loam	5
FAO GfSD 2006	FieldTexture	Si - Silt	9
FAO GfSD 2006	FieldTexture	SL - Sandy loam	3
FAO GfSD 2006	FieldTexture	S - Sand (unspecified)	1
FAO GfSD 2006	FieldTexture	US - Unsorted sand	14
FAO GfSD 2006	FieldTexture	VFS - Very fine sand	18
FAO GfSD 2006	GypsumContent	EX - Extremely gypsiric (> 60%)	5
FAO GfSD 2006	GypsumContent	MO - Moderately gypsiric (5-15%) - EC = > 1.8 dS m-1 in 10 g soil/250 ml H2O	3
FAO GfSD 2006	MottlesColour	2.5Y 2/0 - black	82
FAO GfSD 2006	GypsumContent	N - Non-gypsiric (0%) - EC = < 1.8 dS m-1 in 10 g soil/25 ml H2O, EC = < 0.18 dS m-1 in 10 g soil/250 ml H2O	1
FAO GfSD 2006	GypsumContent	SL - Slightly gypsiric (0-5%) - EC = < 1.8 dS m-1 in 10 g soil/250 ml H2O	2
FAO GfSD 2006	GypsumContent	ST - Strongly gypsiric (15-60%) - Higher amounts may be differentiated by abundance of H2O-soluble pseudomycelia/crystals and soil colour.	4
FAO GfSD 2006	GypsumForms	D - disperse powdery gypsum	2
FAO GfSD 2006	GypsumForms	G - "gazha" (clayey water-saturated layer with high gypsum content)	3
FAO GfSD 2006	GypsumForms	HL - hard cemented layer or layers of gypsum (less than 10 cm thick)	4
FAO GfSD 2006	GypsumForms	SC - soft concretions	1
FAO GfSD 2006	MineralConcentrationsAbundance	A - Abundant (40-80 %)	6
FAO GfSD 2006	MineralConcentrationsAbundance	C - Common (5-15 %)	4
FAO GfSD 2006	MineralConcentrationsAbundance	D - Dominant (> 80 %)	7
FAO GfSD 2006	MineralConcentrationsAbundance	F - Few (2-5 %)	3
FAO GfSD 2006	MineralConcentrationsAbundance	M - Many (15-40 %)	5
FAO GfSD 2006	MineralConcentrationsAbundance	N - None (0 %)	1
FAO GfSD 2006	MineralConcentrationsAbundance	V - Very few (0-2 %)	2
FAO GfSD 2006	MineralConcentrationsColour	BB - Bluish-black	15
FAO GfSD 2006	MineralConcentrationsColour	BL - Black	16
FAO GfSD 2006	MineralConcentrationsColour	BR - Brown	5
FAO GfSD 2006	MineralConcentrationsColour	BS - Brownish	6
FAO GfSD 2006	MineralConcentrationsColour	BU - Blue	14
FAO GfSD 2006	MineralConcentrationsColour	GE - Greenish	11
FAO GfSD 2006	MineralConcentrationsColour	GR - Grey	12
FAO GfSD 2006	MineralConcentrationsColour	GS - Greyish	13
FAO GfSD 2006	MineralConcentrationsColour	MC - Multicoloured	17
FAO GfSD 2006	MineralConcentrationsColour	RB - Reddish brown	7
FAO GfSD 2006	MineralConcentrationsColour	RE - Red	2
FAO GfSD 2006	MineralConcentrationsColour	RS - Reddish	3
FAO GfSD 2006	MineralConcentrationsColour	RY - Reddish yellow	10
FAO GfSD 2006	MineralConcentrationsColour	WH - White	1
FAO GfSD 2006	MineralConcentrationsColour	YB - Yellowish brown	8
FAO GfSD 2006	MineralConcentrationsColour	YE - Yellow	9
FAO GfSD 2006	MineralConcentrationsColour	YR - Yellowish red	4
FAO GfSD 2006	MineralConcentrationsHardness	B - Both hard and soft	3
FAO GfSD 2006	MineralConcentrationsHardness	H - Hard	1
FAO GfSD 2006	MineralConcentrationsHardness	S - Soft	2
FAO GfSD 2006	MineralConcentrationsKind	C - Concretion: A discrete body with a concentric internal structure, generally cemented	2
FAO GfSD 2006	MineralConcentrationsKind	IC - Crack infillings	7
FAO GfSD 2006	MineralConcentrationsKind	IP - Pore infillings: Including pseudomycelium of carbonates or opal	6
FAO GfSD 2006	MineralConcentrationsKind	N - Nodule: Discrete body without an internal organization	5
FAO GfSD 2006	MineralConcentrationsKind	O - Other	9
FAO GfSD 2006	MineralConcentrationsKind	R - Residual rock fragment: Discrete impregnated body still showing rock structure	8
FAO GfSD 2006	MineralConcentrationsKind	SC - Soft concretion	3
FAO GfSD 2006	MineralConcentrationsKind	S - Soft segregation (or soft accumulation): Differs from the surrounding soil mass in colour and composition but is not easily separated as a discrete body	4
FAO GfSD 2006	MineralConcentrationsKind	T - Crystal	1
FAO GfSD 2006	MineralConcentrationsNature	C - Clay (argillaceous)	3
FAO GfSD 2006	MineralConcentrationsNature	CS - Clay-sesquioxides	4
FAO GfSD 2006	MineralConcentrationsNature	F - Iron (ferruginous)	11
FAO GfSD 2006	MineralConcentrationsNature	FM - Iron-manganese (sesquioxides)	12
FAO GfSD 2006	MineralConcentrationsNature	GB - Gibbsite	7
FAO GfSD 2006	MineralConcentrationsNature	GY - Gypsum (gypsiferous)	5
FAO GfSD 2006	MineralConcentrationsNature	JA - Jarosite	8
FAO GfSD 2006	MineralConcentrationsNature	K - Carbonates (calcareous)	1
FAO GfSD 2006	MineralConcentrationsNature	KQ - Carbonates-silica	2
FAO GfSD 2006	MineralConcentrationsNature	M - Manganese (manganiferous)	13
FAO GfSD 2006	MineralConcentrationsNature	NK - Not known	14
FAO GfSD 2006	MineralConcentrationsNature	Q - Silica (siliceous)	10
FAO GfSD 2006	MineralConcentrationsNature	SA - Salt (saline)	6
FAO GfSD 2006	MineralConcentrationsNature	S - Sulphur (sulphurous)	9
FAO GfSD 2006	MineralConcentrationsShape	A - Angular	5
FAO GfSD 2006	MineralConcentrationsShape	E - Elongated	2
FAO GfSD 2006	MineralConcentrationsShape	F - Flat	3
FAO GfSD 2006	MineralConcentrationsShape	I - Irregular	4
FAO GfSD 2006	MineralConcentrationsShape	R - Rounded (spherical)	1
FAO GfSD 2006	MineralConcentrationsSize	C -  Coarse (> 20 mm)	4
FAO GfSD 2006	MineralConcentrationsSize	F - Fine (2-6 mm)	2
FAO GfSD 2006	MineralConcentrationsSize	M - Medium (6-20 mm)	3
FAO GfSD 2006	MineralConcentrationsSize	V - Very fine (< 2 mm)	1
FAO GfSD 2006	mineralConcVolumeProperty	Abundant	\N
FAO GfSD 2006	mineralConcVolumeProperty	Common	\N
FAO GfSD 2006	mineralConcVolumeProperty	Dominant	\N
FAO GfSD 2006	mineralConcVolumeProperty	Few	\N
FAO GfSD 2006	mineralConcVolumeProperty	Many	\N
FAO GfSD 2006	mineralConcVolumeProperty	None	\N
FAO GfSD 2006	mineralConcVolumeProperty	Very few	\N
FAO GfSD 2006	Moisture	D - Dry: Crushing: makes no dust. Forming (to a ball): not possible, seems to be warm. Moistening: going dark. Rubbing (in the hand): hardly lighter. pF: 4.	2
FAO GfSD 2006	Moisture	M - Moist: Crushing: is sticky. Forming (to a ball): finger moist and cool, weakly shiny. Moistening: no change of colour. Rubbing (in the hand): obviously lighter. pF: 2.	4
FAO GfSD 2006	Moisture	S - Slightly moist: Crushing: makes no dust. Forming (to a ball):  possible (not sand). Moistening: going slightly dark. Rubbing (in the hand): obviously lighter. pF: 3.	3
FAO GfSD 2006	MottlesColour	2.5Y 3/0 - very dark grey	83
FAO GfSD 2006	Moisture	V - Very wet: Crushing: free water. Forming (to a ball): drops of water without crushing. Moistening: no change of colour. pF: 0.	6
FAO GfSD 2006	Moisture	W - Wet: Crushing: free water. Forming (to a ball): drops of water. Moistening: no change of colour. pF: 1.	5
FAO GfSD 2006	Moisture	Y - Very dry: Crushing: dusty or hard. Forming (to a ball): not possible, seems to be warm. Moistening: going very dark. Rubbing (in the hand): not lighter. pF: 5.	1
FAO GfSD 2006	MottlesAbundance	A - Abundant (> 40 %)	6
FAO GfSD 2006	MottlesAbundance	C - Common (5-15 %)	4
FAO GfSD 2006	MottlesAbundance	F - Few (2-5 %)	3
FAO GfSD 2006	MottlesAbundance	M - Many (15-40 %)	5
FAO GfSD 2006	MottlesAbundance	N - None (0 %)	1
FAO GfSD 2006	MottlesAbundance	V - Very few (0-2 %)	2
FAO GfSD 2006	MottlesBoundary	C - Clear (0.5-2 mm)	2
FAO GfSD 2006	MottlesBoundary	D - Diffuse (> 2 mm)	3
FAO GfSD 2006	MottlesBoundary	S - Sharp (< 0.5 mm)	1
FAO GfSD 2006	MottlesColour	10R 2.5/1 - reddish black	217
FAO GfSD 2006	MottlesColour	10R 2.5/2 - very dusky red	218
FAO GfSD 2006	MottlesColour	10R 3/1 - dark reddish grey	219
FAO GfSD 2006	MottlesColour	10R 3/2 - dusky red	220
FAO GfSD 2006	MottlesColour	10R 3/3 - dusky red	221
FAO GfSD 2006	MottlesColour	10R 3/4 - dusky red	222
FAO GfSD 2006	MottlesColour	10R 3/6 - dark red	223
FAO GfSD 2006	MottlesColour	10R 4/1 - dark reddish grey	18
FAO GfSD 2006	MottlesColour	10R 4/2 - weak red	19
FAO GfSD 2006	MottlesColour	10R 4/3 - weak red	2
FAO GfSD 2006	MottlesColour	10R 4/4 - weak red	5
FAO GfSD 2006	MottlesColour	10R 4/6 - red	10
FAO GfSD 2006	MottlesColour	10R 4/8 - red	11
FAO GfSD 2006	MottlesColour	10R 5/1 - reddish grey	6
FAO GfSD 2006	MottlesColour	10R 5/2 - weak red	7
FAO GfSD 2006	MottlesColour	10R 5/3 - weak red	20
FAO GfSD 2006	MottlesColour	10R 5/4 - weak red	21
FAO GfSD 2006	MottlesColour	10R 5/6 - red	22
FAO GfSD 2006	MottlesColour	10R 5/8 - red	23
FAO GfSD 2006	MottlesColour	10R 6/1 - reddish grey	24
FAO GfSD 2006	MottlesColour	10R 6/2 - pale red	25
FAO GfSD 2006	MottlesColour	10R 6/3 - pale red	26
FAO GfSD 2006	MottlesColour	10R 6/4 - pale red	27
FAO GfSD 2006	MottlesColour	10R 6/6 - light red	28
FAO GfSD 2006	MottlesColour	10R 6/8 - light red	29
FAO GfSD 2006	MottlesColour	10Y 3/1 - olive	30
FAO GfSD 2006	MottlesColour	10Y 4/1 - grey	31
FAO GfSD 2006	MottlesColour	10Y 4/2 - olive grey	32
FAO GfSD 2006	MottlesColour	10Y 5/1 - grey	33
FAO GfSD 2006	MottlesColour	10Y 5/2 - olive grey	34
FAO GfSD 2006	MottlesColour	10Y 5/4	35
FAO GfSD 2006	MottlesColour	10Y 6/1 - grey	36
FAO GfSD 2006	MottlesColour	10Y 6/2 - olive grey	37
FAO GfSD 2006	MottlesColour	10Y 6/4	38
FAO GfSD 2006	MottlesColour	10Y 6/6	39
FAO GfSD 2006	MottlesColour	10Y 6/8	40
FAO GfSD 2006	MottlesColour	10Y 7/1 - light grey	41
FAO GfSD 2006	MottlesColour	10Y 7/2 - light grey	42
FAO GfSD 2006	MottlesColour	10Y 7/4	43
FAO GfSD 2006	MottlesColour	10Y 7/6	44
FAO GfSD 2006	MottlesColour	10Y 7/8	45
FAO GfSD 2006	MottlesColour	10Y 8/10	47
FAO GfSD 2006	MottlesColour	10Y 8/1 - light grey	46
FAO GfSD 2006	MottlesColour	10Y 8/2 - light grey	48
FAO GfSD 2006	MottlesColour	10Y 8/4	49
FAO GfSD 2006	MottlesColour	10Y 8/6	50
FAO GfSD 2006	MottlesColour	10Y 8/8	51
FAO GfSD 2006	MottlesColour	10YR 2/1 - black	52
FAO GfSD 2006	MottlesColour	10YR 2/2 - very dark brown	53
FAO GfSD 2006	MottlesColour	10YR 3/1 - very dark grey	54
FAO GfSD 2006	MottlesColour	10YR 3/2 - very dark greyish brown	55
FAO GfSD 2006	MottlesColour	10YR 3/3 - dark brown	56
FAO GfSD 2006	MottlesColour	10YR 3/4 - dark yellowish brown	57
FAO GfSD 2006	MottlesColour	10YR 3/6 - dark yellowish brown	58
FAO GfSD 2006	MottlesColour	10YR 4/1 - dark grey	59
FAO GfSD 2006	MottlesColour	10YR 4/2 - dark greyish brown	60
FAO GfSD 2006	MottlesColour	10YR 4/3 - (dark) brown	61
FAO GfSD 2006	MottlesColour	10YR 4/4 - dark yellowish brown	62
FAO GfSD 2006	MottlesColour	10YR 4/6 - dark yellowish brown	63
FAO GfSD 2006	MottlesColour	10YR 5/1 - grey	64
FAO GfSD 2006	MottlesColour	10YR 5/2 - greyish brown	65
FAO GfSD 2006	MottlesColour	10YR 5/3 - brown	66
FAO GfSD 2006	MottlesColour	10YR 5/4 - yellowish brown	67
FAO GfSD 2006	MottlesColour	10YR 5/6 - yellowish brown	68
FAO GfSD 2006	MottlesColour	10YR 5/8 - yellowish brown	69
FAO GfSD 2006	MottlesColour	10YR 6/1 - (light) grey	17
FAO GfSD 2006	MottlesColour	10YR 6/2 - light brownish grey	3
FAO GfSD 2006	MottlesColour	10YR 6/3 - pale brown	8
FAO GfSD 2006	MottlesColour	10YR 6/4 - light yellowish brown	9
FAO GfSD 2006	MottlesColour	10YR 6/6 - brownish yellow	13
FAO GfSD 2006	MottlesColour	10YR 6/8 - brownish yellow	14
FAO GfSD 2006	MottlesColour	10YR 7/1 - light grey	70
FAO GfSD 2006	MottlesColour	10YR 7/2 - light grey	71
FAO GfSD 2006	MottlesColour	10YR 7/3 - very pale brown	72
FAO GfSD 2006	MottlesColour	10YR 7/4 - very pale brown	73
FAO GfSD 2006	MottlesColour	10YR 7/6 - yellow	74
FAO GfSD 2006	MottlesColour	10YR 7/8 - yellow	75
FAO GfSD 2006	MottlesColour	10YR 8/1 - white	76
FAO GfSD 2006	MottlesColour	10YR 8/2 - white	77
FAO GfSD 2006	MottlesColour	10YR 8/3 - very pale brown	78
FAO GfSD 2006	MottlesColour	10YR 8/4 - very pale brown	79
FAO GfSD 2006	MottlesColour	10YR 8/6 - yellow	80
FAO GfSD 2006	MottlesColour	10YR 8/8 - yellow	81
FAO GfSD 2006	MottlesColour	2.5Y 3/2 - very dark greyish brown	84
FAO GfSD 2006	MottlesColour	2.5Y 4/0 - dark grey	85
FAO GfSD 2006	MottlesColour	2.5Y 4/2 - dark greyish brown	86
FAO GfSD 2006	MottlesColour	2.5Y 4/4 - olive brown	87
FAO GfSD 2006	MottlesColour	2.5Y 5/0 - grey	88
FAO GfSD 2006	MottlesColour	2.5Y 5/2 - greyish brown	89
FAO GfSD 2006	MottlesColour	2.5Y 5/4 - light olive brown	90
FAO GfSD 2006	MottlesColour	2.5Y 5/6 - light olive brown	91
FAO GfSD 2006	MottlesColour	2.5Y 6/0 - (light) grey	92
FAO GfSD 2006	MottlesColour	2.5Y 6/2 - light brownish grey	93
FAO GfSD 2006	MottlesColour	2.5Y 6/4 - light yellowish brown	94
FAO GfSD 2006	MottlesColour	2.5Y 6/6 - olive yellow	95
FAO GfSD 2006	MottlesColour	2.5Y 6/8 - olive yellow	96
FAO GfSD 2006	MottlesColour	2.5Y 7/0 - light grey	97
FAO GfSD 2006	MottlesColour	2.5Y 7/2 - light grey	98
FAO GfSD 2006	MottlesColour	2.5Y 7/4 - pale yellow	99
FAO GfSD 2006	MottlesColour	2.5Y 7/6 - yellow	100
FAO GfSD 2006	MottlesColour	2.5Y 7/8 - yellow	101
FAO GfSD 2006	MottlesColour	2.5Y 8/0 - white	102
FAO GfSD 2006	MottlesColour	2.5Y 8/2 - white	103
FAO GfSD 2006	MottlesColour	2.5Y 8/4 - pale yellow	104
FAO GfSD 2006	MottlesColour	2.5Y 8/6 - yellow	105
FAO GfSD 2006	MottlesColour	2.5Y 8/8 - yellow	106
FAO GfSD 2006	MottlesColour	2.5YR 2.5/0 - black	107
FAO GfSD 2006	MottlesColour	2.5YR 2.5/2 - very dusky red	108
FAO GfSD 2006	MottlesColour	2.5YR 2.5/4 - dark reddish brown	109
FAO GfSD 2006	MottlesColour	2.5YR 3/0 - very dark grey	110
FAO GfSD 2006	MottlesColour	2.5YR 3/2 - dusky red	111
FAO GfSD 2006	MottlesColour	2.5YR 3/4 - dark reddish brown	112
FAO GfSD 2006	MottlesColour	2.5YR 3/6 - dark red	113
FAO GfSD 2006	MottlesColour	2.5YR 4/0 - dark grey	114
FAO GfSD 2006	MottlesColour	2.5YR 4/2 - weak red	115
FAO GfSD 2006	MottlesColour	2.5YR 4/4 - reddish brown	116
FAO GfSD 2006	MottlesColour	2.5YR 4/6 - red	117
FAO GfSD 2006	MottlesColour	2.5YR 4/8 - red	1
FAO GfSD 2006	MottlesColour	2.5YR 5/0 - grey	4
FAO GfSD 2006	MottlesColour	2.5YR 5/2 - weak red	12
FAO GfSD 2006	MottlesColour	2.5YR 5/4 - reddish brown	15
FAO GfSD 2006	MottlesColour	2.5YR 5/6 - red	16
FAO GfSD 2006	MottlesColour	2.5YR 5/8 - red	118
FAO GfSD 2006	MottlesColour	2.5YR 6/0 - gray	119
FAO GfSD 2006	MottlesColour	2.5YR 6/2 - pale red	120
FAO GfSD 2006	MottlesColour	2.5YR 6/4 - light reddish brown	121
FAO GfSD 2006	MottlesColour	2.5YR 6/6 - light red	122
FAO GfSD 2006	MottlesColour	2.5YR 6/8 - light red	123
FAO GfSD 2006	MottlesColour	5B 4/1 - dark bluish grey	124
FAO GfSD 2006	MottlesColour	5B 5/1 - bluish grey	125
FAO GfSD 2006	MottlesColour	5B 6/1 - bluish grey	126
FAO GfSD 2006	MottlesColour	5B 7/1 - light bluish grey	127
FAO GfSD 2006	MottlesColour	5BG 4/1 - dark greenish grey	128
FAO GfSD 2006	MottlesColour	5BG 5/1 - greenish grey	129
FAO GfSD 2006	MottlesColour	5BG 6/1 - greenish grey	130
FAO GfSD 2006	MottlesColour	5BG 7/1 - light greenish grey	131
FAO GfSD 2006	MottlesColour	5G 4/1 - dark greenish grey	132
FAO GfSD 2006	MottlesColour	5G 4/2 - greyish green	133
FAO GfSD 2006	MottlesColour	5G 5/1 - greenish grey	134
FAO GfSD 2006	MottlesColour	5G 5/2 - greyish green	135
FAO GfSD 2006	MottlesColour	5G 6/1 - greenish grey	136
FAO GfSD 2006	MottlesColour	5G 6/2 - pale green	137
FAO GfSD 2006	MottlesColour	5G 7/1 - light greenish grey	138
FAO GfSD 2006	MottlesColour	5G 7/2 - pale green	139
FAO GfSD 2006	MottlesColour	5GY 4/1 - dark greenish grey	140
FAO GfSD 2006	MottlesColour	5GY 5/1 - greenish grey	141
FAO GfSD 2006	MottlesColour	5GY 6/1 - greenish grey	142
FAO GfSD 2006	MottlesColour	5GY 7/1 - light greenish grey	143
FAO GfSD 2006	MottlesColour	5R 2.5/1 - reddish black	144
FAO GfSD 2006	MottlesColour	5R 2.5/2 - very dusky red	145
FAO GfSD 2006	MottlesColour	5R 2.5/3 - very dusky red	146
FAO GfSD 2006	MottlesColour	5R 2.5/4 - very dusky red	147
FAO GfSD 2006	MottlesColour	5R 2.5/6 - dark red	148
FAO GfSD 2006	MottlesColour	5R 3/1 - dark reddish grey	149
FAO GfSD 2006	MottlesColour	5R 3/2 - dusky red	150
FAO GfSD 2006	MottlesColour	5R 3/3 - dusky red	151
FAO GfSD 2006	MottlesColour	5R 3/4 - dusky red	152
FAO GfSD 2006	MottlesColour	5R 3/6 - dark red	153
FAO GfSD 2006	MottlesColour	5R 3/8 - dark red	154
FAO GfSD 2006	MottlesColour	5R 4/1 - dark reddish grey	155
FAO GfSD 2006	MottlesColour	5R 4/2 - weak red	156
FAO GfSD 2006	MottlesColour	5R 4/3 - weak red	157
FAO GfSD 2006	MottlesColour	5R 4/4 - weak red	158
FAO GfSD 2006	MottlesColour	5R 4/6 - red	159
FAO GfSD 2006	MottlesColour	5R 4/8 - red	160
FAO GfSD 2006	MottlesColour	5R 5/1 - reddish grey	161
FAO GfSD 2006	MottlesColour	5R 5/2 - weak red	162
FAO GfSD 2006	MottlesColour	5R 5/3 - weak red	163
FAO GfSD 2006	MottlesColour	5R 5/4 - weak red	164
FAO GfSD 2006	MottlesColour	5R 5/6 - red	165
FAO GfSD 2006	MottlesColour	5R 5/8 - red	166
FAO GfSD 2006	MottlesColour	5R 6/1 - reddish grey	167
FAO GfSD 2006	MottlesColour	5R 6/2 - pale red	168
FAO GfSD 2006	MottlesColour	5R 6/3 - pale red	169
FAO GfSD 2006	MottlesColour	5R 6/4 - pale red	170
FAO GfSD 2006	MottlesColour	5R 6/6 - light red	171
FAO GfSD 2006	MottlesColour	5R 6/8 - light red	172
FAO GfSD 2006	MottlesColour	5Y 2.5/1 - black	173
FAO GfSD 2006	MottlesColour	5Y 2.5/2 - black	174
FAO GfSD 2006	MottlesColour	5Y 3/1 - very dark grey	175
FAO GfSD 2006	MottlesColour	5Y 3/2 - dark olive grey	176
FAO GfSD 2006	MottlesColour	5Y 4/1 - dark grey	177
FAO GfSD 2006	MottlesColour	5Y 4/2 - olive grey	178
FAO GfSD 2006	MottlesColour	5Y 4/3 - olive	179
FAO GfSD 2006	MottlesColour	5Y 4/4 - olive	180
FAO GfSD 2006	MottlesColour	5Y 5/1 - grey	181
FAO GfSD 2006	MottlesColour	5Y 5/2 - olive grey	182
FAO GfSD 2006	MottlesColour	5Y 5/3 - olive	183
FAO GfSD 2006	MottlesColour	5Y 5/4 - olive	184
FAO GfSD 2006	MottlesColour	5Y 5/6 - olive	185
FAO GfSD 2006	MottlesColour	5Y 6/1 - (light) grey	186
FAO GfSD 2006	MottlesColour	5Y 6/2 - light olive grey	187
FAO GfSD 2006	MottlesColour	5Y 6/3 - pale olive	188
FAO GfSD 2006	MottlesColour	5Y 6/4 - pale olive	189
FAO GfSD 2006	MottlesColour	5Y 6/6 - olive yellow	190
FAO GfSD 2006	MottlesColour	5Y 6/8 - olive yellow	191
FAO GfSD 2006	MottlesColour	5Y 7/1 - light grey	192
FAO GfSD 2006	MottlesColour	5Y 7/2 - light grey	193
FAO GfSD 2006	MottlesColour	5Y 7/3 - pale yellow	194
FAO GfSD 2006	MottlesColour	5Y 7/4 - pale yellow	195
FAO GfSD 2006	MottlesColour	5Y 7/6 - yellow	196
FAO GfSD 2006	MottlesColour	5Y 7/8 - yellow	197
FAO GfSD 2006	MottlesColour	5Y 8/1 - white	198
FAO GfSD 2006	MottlesColour	5Y 8/2 - white	199
FAO GfSD 2006	MottlesColour	5Y 8/3 - pale yellow	200
FAO GfSD 2006	MottlesColour	5Y 8/4 - pale yellow	201
FAO GfSD 2006	MottlesColour	5Y 8/6 - yellow	202
FAO GfSD 2006	MottlesColour	5Y 8/8 - yellow	203
FAO GfSD 2006	MottlesColour	5YR 2.5/1 - black	204
FAO GfSD 2006	MottlesColour	5YR 2.5/2 - dark reddish brown	205
FAO GfSD 2006	MottlesColour	5YR 3/1 - very dark grey	206
FAO GfSD 2006	MottlesColour	5YR 3/2 - dark reddish brown	207
FAO GfSD 2006	MottlesColour	5YR 3/3 - dark reddish brown	208
FAO GfSD 2006	MottlesColour	5YR 3/4 - dark reddish brown	209
FAO GfSD 2006	MottlesColour	5YR 4/1 - dark grey	210
FAO GfSD 2006	MottlesColour	5YR 4/2 - dark reddish grey	211
FAO GfSD 2006	MottlesColour	5YR 4/3 - reddish brown	212
FAO GfSD 2006	MottlesColour	5YR 4/4 - reddish brown	213
FAO GfSD 2006	MottlesColour	5YR 4/6 - yellowish red	214
FAO GfSD 2006	MottlesColour	5YR 5/1 - grey	215
FAO GfSD 2006	MottlesColour	5YR 5/2 - reddish grey	216
FAO GfSD 2006	MottlesColour	5YR 5/3 - reddish brown	224
FAO GfSD 2006	MottlesColour	5YR 5/4 - reddish brown	225
FAO GfSD 2006	MottlesColour	5YR 5/6 - yellowish red	226
FAO GfSD 2006	MottlesColour	5YR 5/8 - yellowish red	227
FAO GfSD 2006	MottlesColour	5YR 6/1 - (light) grey	228
FAO GfSD 2006	MottlesColour	5YR 6/2 - pinkish grey	229
FAO GfSD 2006	MottlesColour	5YR 6/3 - light reddish brown	230
FAO GfSD 2006	MottlesColour	5YR 6/4 - light reddish brown	231
FAO GfSD 2006	MottlesColour	5YR 6/6 - reddish yellow	232
FAO GfSD 2006	MottlesColour	5YR 6/8 - reddish yellow	233
FAO GfSD 2006	MottlesColour	5YR 7/1 - light grey	234
FAO GfSD 2006	MottlesColour	5YR 7/2 - pinkish grey	235
FAO GfSD 2006	MottlesColour	5YR 7/3 - pink	236
FAO GfSD 2006	MottlesColour	5YR 7/4 - pink	237
FAO GfSD 2006	MottlesColour	5YR 7/6 - reddish yellow	238
FAO GfSD 2006	MottlesColour	5YR 7/8 - reddish yellow	239
FAO GfSD 2006	MottlesColour	5YR 8/1 - white	240
FAO GfSD 2006	MottlesColour	5YR 8/2 - pinkish white	241
FAO GfSD 2006	MottlesColour	5YR 8/3 - pink	242
FAO GfSD 2006	MottlesColour	5YR 8/4 - pink	243
FAO GfSD 2006	MottlesColour	7.5GY 2.5/0	244
FAO GfSD 2006	MottlesColour	7.5GY 3/0	245
FAO GfSD 2006	MottlesColour	7.5GY 3/2	246
FAO GfSD 2006	MottlesColour	7.5GY 4/0	247
FAO GfSD 2006	MottlesColour	7.5GY 4/2	248
FAO GfSD 2006	MottlesColour	7.5GY 4/4	249
FAO GfSD 2006	MottlesColour	7.5GY 5/0	250
FAO GfSD 2006	MottlesColour	7.5GY 5/2	251
FAO GfSD 2006	MottlesColour	7.5GY 5/4	252
FAO GfSD 2006	MottlesColour	7.5GY 5/6	253
FAO GfSD 2006	MottlesColour	7.5GY 6/0	254
FAO GfSD 2006	MottlesColour	7.5GY 6/10	255
FAO GfSD 2006	MottlesColour	7.5GY 6/2	256
FAO GfSD 2006	MottlesColour	7.5GY 6/4	257
FAO GfSD 2006	MottlesColour	7.5GY 6/6	258
FAO GfSD 2006	MottlesColour	7.5GY 6/8	259
FAO GfSD 2006	MottlesColour	7.5GY 7/0	260
FAO GfSD 2006	MottlesColour	7.5GY 7/10	261
FAO GfSD 2006	MottlesColour	7.5GY 7/2	262
FAO GfSD 2006	MottlesColour	7.5GY 7/4	263
FAO GfSD 2006	MottlesColour	7.5GY 7/6	264
FAO GfSD 2006	MottlesColour	7.5GY 7/8	265
FAO GfSD 2006	MottlesColour	7.5GY 8/0	266
FAO GfSD 2006	MottlesColour	7.5GY 8/2	267
FAO GfSD 2006	MottlesColour	7.5GY 8/4	268
FAO GfSD 2006	MottlesColour	7.5GY 8/6	269
FAO GfSD 2006	MottlesColour	7.5GY 8/8	270
FAO GfSD 2006	MottlesColour	7.5R 2.5/0 - black	271
FAO GfSD 2006	MottlesColour	7.5R 2.5/2 - very dusky red	272
FAO GfSD 2006	MottlesColour	7.5R 2.5/4 - very dusky red	273
FAO GfSD 2006	MottlesColour	7.5R 3/0 - very dark grey	274
FAO GfSD 2006	MottlesColour	7.5R 3/2 - dusky red	275
FAO GfSD 2006	MottlesColour	7.5R 3/4 - dusky red	276
FAO GfSD 2006	MottlesColour	7.5R 3/6 - dark red	277
FAO GfSD 2006	MottlesColour	7.5R 3/8 - dark red	278
FAO GfSD 2006	MottlesColour	7.5R 4/0 - dark grey	279
FAO GfSD 2006	MottlesColour	7.5R 4/2 - weak red	280
FAO GfSD 2006	MottlesColour	7.5R 4/4 - weak red	281
FAO GfSD 2006	MottlesColour	7.5R 4/6 - red	282
FAO GfSD 2006	MottlesColour	7.5R 4/8 - red	283
FAO GfSD 2006	MottlesColour	7.5R 5/0 - grey	284
FAO GfSD 2006	MottlesColour	7.5R 5/2 - weak red	285
FAO GfSD 2006	MottlesColour	7.5R 5/4 - weak red	286
FAO GfSD 2006	MottlesColour	7.5R 5/6 - red	287
FAO GfSD 2006	MottlesColour	7.5R 5/8 - red	288
FAO GfSD 2006	MottlesColour	7.5R 6/0 - grey	289
FAO GfSD 2006	MottlesColour	7.5R 6/2 - pale red	290
FAO GfSD 2006	MottlesColour	7.5R 6/4 - pale red	291
FAO GfSD 2006	MottlesColour	7.5R 6/6 - light red	292
FAO GfSD 2006	MottlesColour	7.5R 6/8 - light red	293
FAO GfSD 2006	MottlesColour	7.5Y 2.5/0	294
FAO GfSD 2006	MottlesColour	7.5Y 3/0	295
FAO GfSD 2006	MottlesColour	7.5Y 3/2 - olive black	296
FAO GfSD 2006	MottlesColour	7.5Y 4/0	297
FAO GfSD 2006	MottlesColour	7.5Y 4/2 - greyish olive	298
FAO GfSD 2006	MottlesColour	7.5Y 5/0	299
FAO GfSD 2006	MottlesColour	7.5Y 5/2 - greyish olive	300
FAO GfSD 2006	MottlesColour	7.5Y 5/4	301
FAO GfSD 2006	MottlesColour	7.5Y 6/0	302
FAO GfSD 2006	MottlesColour	7.5Y 6/2 - greyish olive	303
FAO GfSD 2006	MottlesColour	7.5Y 6/4	304
FAO GfSD 2006	MottlesColour	7.5Y 6/6	305
FAO GfSD 2006	MottlesColour	7.5Y 7/0	306
FAO GfSD 2006	MottlesColour	7.5Y 7/10	307
FAO GfSD 2006	MottlesColour	7.5Y 7/2 - light grey	308
FAO GfSD 2006	MottlesColour	7.5Y 7/4	309
FAO GfSD 2006	MottlesColour	7.5Y 7/6	310
FAO GfSD 2006	MottlesColour	7.5Y 7/8	311
FAO GfSD 2006	MottlesColour	7.5Y 8/0	312
FAO GfSD 2006	MottlesColour	7.5Y 8/10	313
FAO GfSD 2006	MottlesColour	7.5Y 8/2 - light grey	314
FAO GfSD 2006	MottlesColour	7.5Y 8/4	315
FAO GfSD 2006	MottlesColour	7.5Y 8/6	316
FAO GfSD 2006	MottlesColour	7.5Y 8/8	317
FAO GfSD 2006	MottlesColour	7.5YR 2/0 - black	318
FAO GfSD 2006	MottlesColour	7.5YR 2/2 - very dark brown	319
FAO GfSD 2006	MottlesColour	7.5YR 2/4 - very dark brown	320
FAO GfSD 2006	MottlesColour	7.5YR 3/0 - very dark grey	321
FAO GfSD 2006	MottlesColour	7.5YR 3/2 - dark brown	322
FAO GfSD 2006	MottlesColour	7.5YR 3/4 - dark brown	323
FAO GfSD 2006	MottlesColour	7.5YR 4/0 - dark grey	324
FAO GfSD 2006	MottlesColour	7.5YR 4/2 - (dark) brown	325
FAO GfSD 2006	MottlesColour	7.5YR 4/4 - (dark) brown	326
FAO GfSD 2006	MottlesColour	7.5YR 4/6 - strong brown	327
FAO GfSD 2006	MottlesColour	7.5YR 5/0 - grey	328
FAO GfSD 2006	MottlesColour	7.5YR 5/2 - brown	329
FAO GfSD 2006	MottlesColour	7.5YR 5/4 - brown	330
FAO GfSD 2006	MottlesColour	7.5YR 5/6 - strong brown	331
FAO GfSD 2006	MottlesColour	7.5YR 5/8 - strong brown	332
FAO GfSD 2006	MottlesColour	7.5YR 6/0 - (light) grey	333
FAO GfSD 2006	MottlesColour	7.5YR 6/2 - pinkish grey	334
FAO GfSD 2006	MottlesColour	7.5YR 6/4 - light brown	335
FAO GfSD 2006	MottlesColour	7.5YR 6/6 - reddish yellow	336
FAO GfSD 2006	MottlesColour	7.5YR 6/8 - reddish yellow	337
FAO GfSD 2006	MottlesColour	7.5YR 7/0 - light grey	338
FAO GfSD 2006	MottlesColour	7.5YR 7/2 - pinkish grey	339
FAO GfSD 2006	MottlesColour	7.5YR 7/4 - pink	340
FAO GfSD 2006	MottlesColour	7.5YR 7/6 - reddish yellow	341
FAO GfSD 2006	MottlesColour	7.5YR 7/8 - reddish yellow	342
FAO GfSD 2006	MottlesColour	7.5YR 8/0 - white	343
FAO GfSD 2006	MottlesColour	7.5YR 8/2 - pinkish white	344
FAO GfSD 2006	MottlesColour	7.5YR 8/4 - pink	345
FAO GfSD 2006	MottlesColour	7.5YR 8/6 - reddish yellow	346
FAO GfSD 2006	MottlesColour	N 2.5/ - black	347
FAO GfSD 2006	MottlesColour	N 2/ - black	348
FAO GfSD 2006	MottlesColour	N 3/ - very dark grey	349
FAO GfSD 2006	MottlesColour	N 4/ - dark grey	350
FAO GfSD 2006	MottlesColour	N 5/ - grey	351
FAO GfSD 2006	MottlesColour	N 6/ - (light) grey	352
FAO GfSD 2006	MottlesColour	N 7/ - light grey	353
FAO GfSD 2006	MottlesColour	N 8/ - white	354
FAO GfSD 2006	MottlesContrast	D - Distinct: Although not striking, the mottles are readily seen. The hue, chroma and value of the matrix are easily distinguished from those of the mottles. They may vary by as much as 2.5 units of hue or several units in chroma or value.	2
FAO GfSD 2006	MottlesContrast	F - Faint: The mottles are evident only on close examination. Soil colours in both the matrix and mottles have closely related hues, chromas and values.	1
FAO GfSD 2006	MottlesContrast	P - Prominent: The mottles are conspicuous and mottling is one of the outstanding features of the horizon. Hue, chroma and value alone or in combination are at least several units apart.	3
FAO GfSD 2006	MottlesSize	A - Coarse (> 20 mm)	4
FAO GfSD 2006	MottlesSize	F - Fine (2-6 mm)	2
FAO GfSD 2006	MottlesSize	M - Medium (6-20 mm)	3
FAO GfSD 2006	MottlesSize	V - Very fine (< 2 mm)	1
FAO GfSD 2006	OrganicMatter	Dry - LS, SL, L: < 0.5%	31
FAO GfSD 2006	OrganicMatter	Dry - LS, SL, L: 0.5–0.8%	32
FAO GfSD 2006	OrganicMatter	Dry - LS, SL, L: 0.8–1.2%	33
FAO GfSD 2006	OrganicMatter	Dry - LS, SL, L: 1.2–2%	34
FAO GfSD 2006	OrganicMatter	Dry - LS, SL, L: > 15%	39
FAO GfSD 2006	OrganicMatter	Dry - LS, SL, L: 2–4%	35
FAO GfSD 2006	OrganicMatter	Dry - LS, SL, L: 4–6%	36
FAO GfSD 2006	OrganicMatter	Dry - LS, SL, L: 6–9%	37
FAO GfSD 2006	OrganicMatter	Dry - LS, SL, L: 9–15%	38
FAO GfSD 2006	OrganicMatter	Dry - Other: < 0.6%	40
FAO GfSD 2006	OrganicMatter	Dry - Other: 0.6–1.2%	41
FAO GfSD 2006	OrganicMatter	Dry - Other: 1.2–2%	42
FAO GfSD 2006	OrganicMatter	Dry - Other: > 15%	48
FAO GfSD 2006	OrganicMatter	Dry - Other: 2–3%	43
FAO GfSD 2006	OrganicMatter	Dry - Other: 3–4%	44
FAO GfSD 2006	OrganicMatter	Dry - Other: 4–6%	45
FAO GfSD 2006	OrganicMatter	Dry - Other: 6–9%	46
FAO GfSD 2006	OrganicMatter	Dry - Other: 9–15%	47
FAO GfSD 2006	OrganicMatter	Dry - S: < 0.3%	21
FAO GfSD 2006	OrganicMatter	Dry - S: 0.3–0.6%	22
FAO GfSD 2006	OrganicMatter	Dry - S: 0.6–1%	23
FAO GfSD 2006	OrganicMatter	Dry - S: 1–1.5%	24
FAO GfSD 2006	OrganicMatter	Dry - S: > 12%	30
FAO GfSD 2006	OrganicMatter	Dry - S: 1.5–2%	25
FAO GfSD 2006	OrganicMatter	Dry - S: 2–3%	26
FAO GfSD 2006	OrganicMatter	Dry - S: 3–5%	27
FAO GfSD 2006	OrganicMatter	Dry - S: 5–8%	28
FAO GfSD 2006	OrganicMatter	Dry - S: 8–12%	29
FAO GfSD 2006	OrganicMatter	Moist - LS, SL, L: < 0.4%	8
FAO GfSD 2006	OrganicMatter	Moist - LS, SL, L: 0.4–0.6%	9
FAO GfSD 2006	OrganicMatter	Moist - LS, SL, L: 0.6–1%	10
FAO GfSD 2006	OrganicMatter	Moist - LS, SL, L: 1–2%	11
FAO GfSD 2006	OrganicMatter	Moist - LS, SL, L: 2–4%	12
FAO GfSD 2006	OrganicMatter	Moist - LS, SL, L: > 4%	13
FAO GfSD 2006	OrganicMatter	Moist - Other: < 0.3%	14
FAO GfSD 2006	OrganicMatter	Moist - Other: 0.3–0.6%	15
FAO GfSD 2006	OrganicMatter	Moist - Other: 0.6–0.9%	16
FAO GfSD 2006	OrganicMatter	Moist - Other: 0.9–1.5%	17
FAO GfSD 2006	OrganicMatter	Moist - Other: 1.5–3%	18
FAO GfSD 2006	OrganicMatter	Moist - Other: 3–5%	19
FAO GfSD 2006	OrganicMatter	Moist - Other: > 5%	20
FAO GfSD 2006	OrganicMatter	Moist - S: < 0.3%	1
FAO GfSD 2006	OrganicMatter	Moist - S: 0.3–0.6%	2
FAO GfSD 2006	OrganicMatter	Moist - S: 0.6–0.9%	3
FAO GfSD 2006	OrganicMatter	Moist - S: 0.9–1.5%	4
FAO GfSD 2006	OrganicMatter	Moist - S: 1.5–3%	5
FAO GfSD 2006	OrganicMatter	Moist - S: 3–6%	6
FAO GfSD 2006	OrganicMatter	Moist - S: > 6%	7
FAO GfSD 2006	PeaDescomposition	D1 - Fibric, degree of decomposition/humification is very low	1
FAO GfSD 2006	PeaDescomposition	D2 - Fibric, degree of decomposition/humification is low	2
FAO GfSD 2006	PeaDescomposition	D3 - Fibric, degree of decomposition/humification is moderate	3
FAO GfSD 2006	PeaDescomposition	D4 - Hemic, degree of decomposition/humification is strong	4
FAO GfSD 2006	PeaDescomposition	D5.1 - Hemic, degree of decomposition/humification is moderately strong	5
FAO GfSD 2006	PeaDescomposition	D5.2 - Sapric, degree of decomposition/humification is very strong	6
FAO GfSD 2006	PeatBulkDensity	0.04 - 0.07 g cm-3	2
FAO GfSD 2006	PeatBulkDensity	< 0.04 g cm-3	1
FAO GfSD 2006	PeatBulkDensity	0.07 - 0.11 g cm-3	3
FAO GfSD 2006	PeatBulkDensity	0.11 - 0.17 g cm-3	4
FAO GfSD 2006	PeatBulkDensity	> 0.17 g cm-3	5
FAO GfSD 2006	PeatDrainage	Moderately drained	3
FAO GfSD 2006	PeatDrainage	Undrained	1
FAO GfSD 2006	PeatDrainage	Weakly drained	2
FAO GfSD 2006	PeatDrainage	Well drained	4
FAO GfSD 2006	PeatVolume	SV1: < 3 %	1
FAO GfSD 2006	PeatVolume	SV2: 3 - 5 %	2
FAO GfSD 2006	PeatVolume	SV3: 5 - 8 %	3
FAO GfSD 2006	PeatVolume	SV4: 8 - 12 %	4
FAO GfSD 2006	PeatVolume	SV5: ? 12 %	5
FAO GfSD 2006	Plasticity	NPL - Non-plastic - No wire is formable.	1
FAO GfSD 2006	Plasticity	PL - Plastic - Wire formable but breaks if bent into a ring; slight to moderate force required for deformation of the soil mass.	4
FAO GfSD 2006	Plasticity	PVP - plastic to very plastic -	6
FAO GfSD 2006	Plasticity	SPL - Slightly plastic - Wire formable but breaks immediately if bent into a ring; soil mass deformed by very slight force.	2
FAO GfSD 2006	Plasticity	SPP - slightly plastic to plastic -	3
FAO GfSD 2006	Plasticity	VPL - Very plastic - Wire formable and can be bent into a ring; moderately strong to very strong force required for deformation of the soil mass.	5
FAO GfSD 2006	PoreAbundance	C - Common - The number of very fine pores (< 2 mm) per square decimetre is 50-200, the number of medium and coarse pores (> 2 mm) per square decimetre is 5-20.	4
FAO GfSD 2006	PoreAbundance	F - Few - The number of very fine pores (< 2 mm) per square decimetre is 20-50, the number of medium and coarse pores (> 2 mm) per square decimetre is 2-5.	3
FAO GfSD 2006	PoreAbundance	M - Many - The number of very fine pores (< 2 mm) per square decimetre is > 200, the number of medium and coarse pores (> 2 mm) per square decimetre is > 20.	5
FAO GfSD 2006	PoreAbundance	N - None - The number of very fine pores (< 2 mm) per square decimetre is 0, the number of medium and coarse pores (> 2 mm) per square decimetre is 0.	1
FAO GfSD 2006	PoreAbundance	V - Very few - The number of very fine pores (< 2 mm) per square decimetre is 1-20, the number of medium and coarse pores (> 2 mm) per square decimetre is 1-2.	2
FAO GfSD 2006	poresAbundanceProperty	Common	\N
FAO GfSD 2006	poresAbundanceProperty	Few	\N
FAO GfSD 2006	poresAbundanceProperty	Many	\N
FAO GfSD 2006	poresAbundanceProperty	None	\N
FAO GfSD 2006	poresAbundanceProperty	Very few	\N
FAO GfSD 2006	poresSizeProperty	Coarse	\N
FAO GfSD 2006	poresSizeProperty	Fine	\N
FAO GfSD 2006	poresSizeProperty	fine and medium	\N
FAO GfSD 2006	poresSizeProperty	fine and very fine	\N
FAO GfSD 2006	poresSizeProperty	Medium	\N
FAO GfSD 2006	poresSizeProperty	medium and coarse	\N
FAO GfSD 2006	poresSizeProperty	Very coarse	\N
FAO GfSD 2006	poresSizeProperty	Very fine	\N
FAO GfSD 2006	PorosityAbundance	1 - Very low (< 2%)	1
FAO GfSD 2006	PorosityAbundance	2 - Low (2-5%)	2
FAO GfSD 2006	PorosityAbundance	3 - Medium (5-15%)	3
FAO GfSD 2006	PorosityAbundance	4 - High (15-40%)	4
FAO GfSD 2006	PorosityAbundance	5 - Very high (> 40%)	5
FAO GfSD 2006	PorositySize	C - Coarse (5-20 mm).	7
FAO GfSD 2006	PorositySize	FF - Fine and very fine (< 2 mm).	3
FAO GfSD 2006	PorositySize	F - Fine (0.5-2 mm) - More decomposed than raw humus but characterized by an organic matter layer on top of the mineral soil with a diffuse boundary between the organic matter layer and A horizon. In the sequence of Oi-Oe-Oa layers, it is difficult to separate one layer from another. This develops in moderately nutrient-poor conditions, usually under a cool moist climate. It is usually acidic with a C/N ratio of 18-29.	2
FAO GfSD 2006	PorositySize	FM - Fine and medium (0.5-5 mm).	4
FAO GfSD 2006	PorositySize	MC - Medium and coarse (2-20 mm).	6
FAO GfSD 2006	PorositySize	M - Medium (2-5 mm) - characterized by the periodic absence of organic matter accumulation on the surface owing to the rapid decomposition process and mixing of organic matter and the mineral soil material by bioturbation. It is usually slightly acid to neutral with a C/N ratio of 10-18.	5
FAO GfSD 2006	PorositySize	VC - Very coarse (20-50 mm).	8
FAO GfSD 2006	PorositySize	V - Very fine (< 0.5 mm) - Usually thick (5-30 cm) organic matter accumulation that is largely unaltered owing to lack of decomposers. This kind of organic matter layer develops in extremely nutrient-poor and coarsetextured soils under vegetation that produces a litter layer that is difficult to decompose. It is usually a sequence of Oi-Oe-Oa layers over a thin A horizon, easy to separate one layer from another and being very acid with a C/N ratio of > 29.	1
FAO GfSD 2006	PorosityType	B - Vesicular: Discontinuous spherical or elliptical voids (chambers) of sedimentary origin or formed by compressed air, e.g. gas bubbles in slaking crusts after heavy rainfall. Relatively unimportant in connection with plant growth.	2
FAO GfSD 2006	PorosityType	C - Channels: Elongated voids of faunal or floral origin, mostly tubular in shape and continuous, varying strongly in diameter. When wider than a few centimetres (burrow holes), they are more adequately described under biological activity.	4
FAO GfSD 2006	PorosityType	I - Interstitial: Controlled by the fabric, or arrangement, of the soil particles, also known as textural voids. Subdivision possible into simple packing voids, which relate to the packing of sand particles, and compound packing voids, which result from the packing of non-accommodating peds. Predominantly irregular in shape and interconnected, and hard to quantify in the field.	1
FAO GfSD 2006	PorosityType	P - Planes: Most planes are extra-pedal voids, related to accommodating ped surfaces or cracking patterns. They are often not persistent and vary in size, shape and quantity depending on the moisture condition of the soil. Planar voids may be recorded, describing width and frequency.	5
FAO GfSD 2006	PorosityType	V - Vughs: Mostly irregular, equidimensional voids of faunal origin or resulting from tillage or disturbance of other voids. Discontinuous or interconnected. May be quantified in specific cases.	3
FAO GfSD 2006	RedoxPotential	Black colour due to metal sulphides, flammable methane present	5
FAO GfSD 2006	RedoxPotential	Black Mn concretions	2
FAO GfSD 2006	RedoxPotential	Blue-green to grey colour; Fe2+ ions always present	4
FAO GfSD 2006	RedoxPotential	Fe mottles and/or brown Fe concretions, in wet conditions	3
FAO GfSD 2006	RedoxPotential	No redoximorphic characteristics at permanently high potentials	1
FAO GfSD 2006	ReducingConditions	Bluish black (with 10% HCl; H?S smell): Fe sulphides	4
FAO GfSD 2006	ReducingConditions	Greyish green, light blue: Fe-mix Compounds (Blue-Green Rust)	1
FAO GfSD 2006	ReducingConditions	White, after oxidation blue: vivianite	3
FAO GfSD 2006	ReducingConditions	White, after oxidation brown: siderite	2
FAO GfSD 2006	ReducingConditions	White, after oxidation white: Complete loss of Fe compounds	5
FAO GfSD 2006	Rockabundance	A - Abundant (40-80%)	6
FAO GfSD 2006	Rockabundance	C - Common (5-15%)	4
FAO GfSD 2006	Rockabundance	D - Dominant (> 80%)	7
FAO GfSD 2006	Rockabundance	F - Few (2-5%)	3
FAO GfSD 2006	Rockabundance	M - Many (15-40%)	5
FAO GfSD 2006	Rockabundance	N - None (0%)	1
FAO GfSD 2006	Rockabundance	S - Stone line: any content, but concentrated at a distinct depth of a horizon	8
FAO GfSD 2006	Rockabundance	V - Very few (0-2%)	2
FAO GfSD 2006	RockNature	CH - Primary mineral fragments: quartz	63
FAO GfSD 2006	RockNature	FE - Primary mineral fragments: feldespar	65
FAO GfSD 2006	RockNature	IA1 - Acid igneous: granite	1
FAO GfSD 2006	RockNature	IA2 - Acid igneous: grano-diorite	2
FAO GfSD 2006	RockNature	IA3 - Acid igneous: quartz-diorite	3
FAO GfSD 2006	RockNature	IA4 - Acid igneous: rhyiolite	4
FAO GfSD 2006	RockNature	IB1 - basic igneous: gabbro	7
FAO GfSD 2006	RockNature	IB2 - basic  igneous: basalt	8
FAO GfSD 2006	RockNature	IB3 - basic igneous: dolerite	9
FAO GfSD 2006	RockNature	II1 - Intermediate igneous: andesite, trachyte, phonolite	5
FAO GfSD 2006	RockNature	II2 - Intermediate igneous: diorite-syenite	6
FAO GfSD 2006	RockNature	IP1 - Igneous  pyroclastic tuff, tuffite	13
FAO GfSD 2006	RockNature	IP2 - Igneous  pyroclastic volcanic scoria/breccia	14
FAO GfSD 2006	RockNature	IP3 - Igneous: pyroclastic volcanic ash	15
FAO GfSD 2006	RockNature	IP4 - Igneous  pyroclastic ignimbrite	16
FAO GfSD 2006	RockNature	IU1 - Ultrabasic igneous: peridotite	10
FAO GfSD 2006	RockNature	IU2 - Ultrabasic igneous: pyroxenite	11
FAO GfSD 2006	RockNature	IU3 - Ultrabasic igneous: ilmenite, magnetite, ironstone, serpentine	12
FAO GfSD 2006	RockNature	MA1 - Acid metamorphic: quartzite	17
FAO GfSD 2006	RockNature	MA2 - Acid metamorphic: gneiss, migmatite	18
FAO GfSD 2006	RockNature	MA3 - Acid metamorphic: slate, phyllite, (pellitic rocks)	19
FAO GfSD 2006	RockNature	MA4 - Acid metamorphic: schist	20
FAO GfSD 2006	RockNature	MB1 - Basic metamorphic: slate, phyllite (pelitic rocks)	21
FAO GfSD 2006	RockNature	MB2 - Basic metamorphic:  (green)schist	22
FAO GfSD 2006	RockNature	MB3 - Basic metamorphic: gneiss rich in Fe-Mg minerals	23
FAO GfSD 2006	RockNature	MB4 - Basic metamorphic: metamorphic limestone (marble)	24
FAO GfSD 2006	RockNature	MB5 - Basic metamorphic  amphibolite	25
FAO GfSD 2006	RockNature	MB6 - Basic metamorphic: eclogite	26
FAO GfSD 2006	RockNature	MI - Primary mineral fragments: mica	64
FAO GfSD 2006	RockNature	MU1 - Ultrabasic metamorphic: serpentinite, greenstone	27
FAO GfSD 2006	RockNature	SC1 - Clastic sediments: conglomerate, breccia	28
FAO GfSD 2006	RockNature	SC2 - Clastic sediments: sandstone, greywacke, arkose	29
FAO GfSD 2006	RockNature	SC3 - Clastic sediments: silt-, mud-, claystone	30
FAO GfSD 2006	RockNature	SC4 - Clastic sediments: shale	31
FAO GfSD 2006	RockNature	SC5 - Clastic sediments: ironstone	32
FAO GfSD 2006	RockNature	SE1 - Evaporites: anhydrite, gypsum	36
FAO GfSD 2006	RockNature	SE2 - Evaporites: halite	37
FAO GfSD 2006	RockNature	SO1 - Sedimentary organic: limestone, other carbonate rocks	33
FAO GfSD 2006	RockNature	SO2 - Sedimentary organic: marl and other mixtures	34
FAO GfSD 2006	RockNature	SO3 - Sedimentary organic: coals, bitumen and related rocks	35
FAO GfSD 2006	RockNature	UA1 - Unconsolidated: Anthropogenic/ technogenic redeposited natural material	56
FAO GfSD 2006	RockNature	UA2 -  Unconsolidated: Anthropogenic/ technogenic industrial/artisanal deposits	57
FAO GfSD 2006	RockNature	UC1 - Unconsolidated: colluvial slope deposits	45
FAO GfSD 2006	RockNature	UC2 - Unconsolidated: colluvial lahar	46
FAO GfSD 2006	RockNature	UE1 - Unconsolidated: eolian loess	47
FAO GfSD 2006	RockNature	UE2 - Unconsolidated: eolian sand	48
FAO GfSD 2006	RockNature	UF1 - Unconsolidated: fluvial sand and gravel	39
FAO GfSD 2006	RockNature	UF2 - Unconsolidated: fluvial clay, silt and loam	40
FAO GfSD 2006	RockNature	UG1 - Unconsolidated: glacial moraine	49
FAO GfSD 2006	RockNature	UG2 - Unconsolidated: glacio-fluvial sand	50
FAO GfSD 2006	RockNature	UG3 - Unconsolidated: glacio-fluvial gravel	51
FAO GfSD 2006	RockNature	UK1 -  Unconsolidated  kryogenic periglacial rock debris	52
FAO GfSD 2006	RockNature	UK2 - Unconsolidated: kryogenic periglacial solifluction layer	53
FAO GfSD 2006	RockNature	UL1 - Unconsolidated: lacustrine sand	41
FAO GfSD 2006	RockNature	UL2 - Unconsolidated: lacustrine silt and clay	42
FAO GfSD 2006	RockNature	UM1 - Unconsolidated: marine sand	43
FAO GfSD 2006	RockNature	UM2 - Unconsolidated: marine clay and silt	44
FAO GfSD 2006	RockNature	UO1 - Unconsolidated: organic rainwater-fed moor peat	54
FAO GfSD 2006	RockNature	UO2 - Unconsolidated: organic groundwater-fed bog peat	55
FAO GfSD 2006	RockNature	UR1 - Unconsolidated:  weathered residuum bauxite, laterite	38
FAO GfSD 2006	RockNature	UU1 - Unconsolidated: unspecified deposits clay	58
FAO GfSD 2006	RockNature	UU2 - Unconsolidated  unspecifiedloam and silt	59
FAO GfSD 2006	RockNature	UU3 - Unconsolidated: unspecified sand	60
FAO GfSD 2006	RockNature	UU4 - Unconsolidated: unspecified gravelly sand	61
FAO GfSD 2006	RockNature	UU5 - Unconsolidated: unspecified gravel, broken rock	62
FAO GfSD 2006	RockPrimary	CH - Primary mineral fragments: quartz	1
FAO GfSD 2006	RockPrimary	FE - Primary mineral fragments: feldespar	3
FAO GfSD 2006	RockPrimary	MI - Primary mineral fragments: mica	2
FAO GfSD 2006	RockShape	A - Angular	2
FAO GfSD 2006	RockShape	F - Flat	1
FAO GfSD 2006	RockShape	R - Rounded	4
FAO GfSD 2006	RockShape	S - Subrounded	3
FAO GfSD 2006	Rocksize	B - Boulders (200 - 600 mm)	5
FAO GfSD 2006	Rocksize	BL - Boulders and large boulders	11
FAO GfSD 2006	Rocksize	C - Coarse gravel (20 - 60 mm)	3
FAO GfSD 2006	Rocksize	CS - Coarse gravel and stones	9
FAO GfSD 2006	Rocksize	F - Fine gravel (2 - 6 mm)	1
FAO GfSD 2006	Rocksize	FM - Fine and medium gravel/artefacts	7
FAO GfSD 2006	Rocksize	L - Large boulders (> 600 mm)	6
FAO GfSD 2006	Rocksize	MC - Medium and coarse gravel/artefacts	8
FAO GfSD 2006	Rocksize	M - Medium gravel (6 - 20 mm)	2
FAO GfSD 2006	Rocksize	SB - Stones and boulders	10
FAO GfSD 2006	Rocksize	S - Stones (60 - 200 mm)	4
FAO GfSD 2006	Rockweathering	F - Fresh or slightly weathered: Fragments show little or no signs of weathering.	1
FAO GfSD 2006	Rockweathering	S - Strongly weathered: All but the most resistant minerals are weathered, strongly discoloured and altered throughout the fragments, which tend to disintegrate under only moderate pressure.	3
FAO GfSD 2006	Rockweathering	W - Weathered: Partial weathering is indicated by discoloration and loss of crystal form in the outer parts of the fragments while the centres remain relatively fresh and the fragments have lost little of their original strength.	2
FAO GfSD 2006	RootsAbundance	C - Common - Roots with diameters < 2 mm: 50-200, Roots with diameters > 2 mm: 5-20.	4
FAO GfSD 2006	RootsAbundance	F - Few - Roots with diameters < 2 mm: 20-50, Roots with diameters > 2 mm: 2-5.	3
FAO GfSD 2006	RootsAbundance	M - Many - Roots with diameters < 2 mm: > 200, Roots with diameters > 2 mm: > 20.	5
FAO GfSD 2006	RootsAbundance	N - None - Roots with diameters < 2 mm: 0, Roots with diameters > 2 mm: 0.	1
FAO GfSD 2006	RootsAbundance	V - Very few - Roots with diameters < 2 mm: 1-20, Roots with diameters > 2 mm: 1-2.	2
FAO GfSD 2006	RootsSize	C - Coarse (> 5 mm)	7
FAO GfSD 2006	RootsSize	F - Fine (0.5-2 mm)	2
FAO GfSD 2006	RootsSize	FF - Very fine and fine (< 2 mm)	3
FAO GfSD 2006	RootsSize	FM - Fine and medium (0.5-5 mm)	4
FAO GfSD 2006	RootsSize	MC - Medium and coarse (> 2 mm)	6
FAO GfSD 2006	RootsSize	M - Medium (2-5 mm)	5
FAO GfSD 2006	RootsSize	VF - Very fine (< 0.5 mm)	1
FAO GfSD 2006	SaltContent	EX - Extremely salty (>15 dS m-1)	6
FAO GfSD 2006	SaltContent	MO - Moderately salty (2 - 4 dS m-1)	3
FAO GfSD 2006	SaltContent	N - (nearly)Not salty (< 0.75 dS m-1)	1
FAO GfSD 2006	SaltContent	SL - Slightly salty (0.75 - 2 dS m-1)	2
FAO GfSD 2006	SaltContent	ST - Strongly salty (4 - 8 dS m-1)	4
FAO GfSD 2006	SaltContent	VST - Very strongly salty (8 - 15 dS m-1)	5
FAO GfSD 2006	SandfractionTexture	CS - Coarse sand	4
FAO GfSD 2006	SandfractionTexture	CSL - Coarse sandy loam	9
FAO GfSD 2006	SandfractionTexture	FS - Fine sand	2
FAO GfSD 2006	SandfractionTexture	FSL - Fine sandy loam	8
FAO GfSD 2006	SandfractionTexture	LCS - Loamy coarse sand	7
FAO GfSD 2006	SandfractionTexture	LFS - Loamy fine sand	6
FAO GfSD 2006	SandfractionTexture	LVFS - Loamy very fine sand	5
FAO GfSD 2006	SandfractionTexture	MS - Medium sand	3
FAO GfSD 2006	SandfractionTexture	VFS - Very fine sand	1
FAO GfSD 2006	SoilOdour	N - None - No odour detected	1
FAO GfSD 2006	SoilOdour	P - Petrochemical - Presence of gaseous or liquid gasoline, oil, creosote, etc.	2
FAO GfSD 2006	SoilOdour	S - Sulphurous - Presence of H2S (hydrogen sulphide; "rotten eggs"); commonly associated with strongly reduced soil containing sulphur compounds.	3
FAO GfSD 2006	SoilTexture	C - Clay	12
FAO GfSD 2006	SoilTexture	CL - Clay loam	7
FAO GfSD 2006	SoilTexture	CS - Very coarse and coarse sand	15
FAO GfSD 2006	SoilTexture	FS - Fine sand	17
FAO GfSD 2006	SoilTexture	HC - Heavy clay	13
FAO GfSD 2006	SoilTexture	L - Loam	8
FAO GfSD 2006	SoilTexture	LS - Loamy sand	2
FAO GfSD 2006	SoilTexture	MS - Medium sand	16
FAO GfSD 2006	SoilTexture	SCL - Sandy clay loam	4
FAO GfSD 2006	SoilTexture	SC - Sandy clay	10
FAO GfSD 2006	SoilTexture	SiCL - Silty clay loam	6
FAO GfSD 2006	SoilTexture	SiC - Silty clay	11
FAO GfSD 2006	SoilTexture	SiL - Silt loam	5
FAO GfSD 2006	SoilTexture	Si - Silt	9
FAO GfSD 2006	SoilTexture	SL - Sandy loam	3
FAO GfSD 2006	SoilTexture	S - Sand (unspecified)	1
FAO GfSD 2006	SoilTexture	US - Unsorted sand	14
FAO GfSD 2006	SoilTexture	VFS - Very fine sand	18
FAO GfSD 2006	Stickiness	NST - Non-sticky - After release of pressure, practically no soil material adheres to thumb and finger.	1
FAO GfSD 2006	Stickiness	SSS - slightly sticky to sticky -	3
FAO GfSD 2006	Stickiness	SST - Slightly sticky - After pressure, soil material adheres to both thumb and finger but comes off one or the other rather cleanly. It is not appreciably stretched when the digits are separated.	2
FAO GfSD 2006	Stickiness	ST - Sticky - After pressure, soil material adheres to both thumb and finger and tends to stretch somewhat and pull apart rather than pulling free from either digit.	4
FAO GfSD 2006	Stickiness	SVS - sticky to very sticky -	5
FAO GfSD 2006	Stickiness	VST - Very sticky - After pressure, soil material adheres strongly to both thumb and finger and is decidedly stretched when they are separated.	6
FAO GfSD 2006	StructureGrade	MO - Moderate: Aggregates are observable in place and there is a distinct arrangement of natural surfaces of weakness. When disturbed, the soil material breaks into a mixture of many entire aggregates, some broken aggregates, and little material without aggregates faces. Aggregates surfaces generally show distinct differences with the aggregates interiors.	3
FAO GfSD 2006	StructureGrade	MS - Moderate to strong	4
FAO GfSD 2006	StructureGrade	ST - Strong: Aggregates are clearly observable in place and there is a prominent arrangement of natural surfaces of weakness. When disturbed, the soil material separates mainly into entire aggregates. Aggregates surfaces generally differ markedly from aggregate interiors.	5
FAO GfSD 2006	StructureGrade	WE - Weak: Aggregates are barely observable in place and there is only a weak arrangement of natural surfaces of weakness. When gently disturbed, the soil material breaks into a mixture of few entire aggregates, many broken aggregates, and much material without aggregate faces. Aggregate surfaces differ in some way from the aggregate interior.	1
FAO GfSD 2006	StructureGrade	WM - Weak to moderate	2
FAO GfSD 2006	StructureSize	CO - Coarse / thick: Granular/platy: 5-10 mm,  Prismatic/columnar/wedgeshaped: 50-100 mm, Blocky/crumbly/lumpy/cloddy: 20-50 mm	4
FAO GfSD 2006	StructureSize	CV - Coarse and very coarse	12
FAO GfSD 2006	StructureSize	EC - Extremely coarse: Prismatic/columnar/wedgeshaped: > 500 mm	6
FAO GfSD 2006	StructureSize	FC - Fine to coarse	10
FAO GfSD 2006	StructureSize	FF  - Very fine and fine	7
FAO GfSD 2006	StructureSize	FI - Fine/thin: Granular/platy: 1-2 mm,  Prismatic/columnar/wedgeshaped: 10-20 mm, Blocky/crumbly/lumpy/cloddy: 5-10 mm	2
FAO GfSD 2006	StructureSize	FM - Fine and medium	9
FAO GfSD 2006	StructureSize	MC - Medium and coarse MV Medium to very coarse	11
FAO GfSD 2006	StructureSize	ME - Medium: Granular/platy: 2-5 mm,  Prismatic/columnar/wedgeshaped: 20-50 mm, Blocky/crumbly/lumpy/cloddy: 10-20 mm	3
FAO GfSD 2006	StructureSize	VC - Very coarse / thick: Granular/platy: > 10 mm,  Prismatic/columnar/wedgeshaped: 100-500 mm, Blocky/crumbly/lumpy/cloddy: > 50 mm	5
FAO GfSD 2006	StructureSize	VF - Very fine / thin: Granular/platy: < 1 mm,  Prismatic/columnar/wedgeshaped: < 10 mm, Blocky/crumbly/lumpy/cloddy: < 5 mm	1
FAO GfSD 2006	StructureSize	VM - Very fine to medium	8
FAO GfSD 2006	StructureType	AB - Angular blocky	6
FAO GfSD 2006	StructureType	AP - Angular blocky (parallelepiped)	7
FAO GfSD 2006	StructureType	AS - Angular and subangular blocky	8
FAO GfSD 2006	StructureType	AW - Angular blocky (wedge-shaped)	9
FAO GfSD 2006	StructureType	BL - Blocky	5
FAO GfSD 2006	StructureType	CL - Cloddy	20
FAO GfSD 2006	StructureType	CO - Columnar	16
FAO GfSD 2006	StructureType	CR - Crumbly	21
FAO GfSD 2006	StructureType	GR - Granular	17
FAO GfSD 2006	StructureType	LU - Lumpy	22
FAO GfSD 2006	StructureType	MA - Massive	3
FAO GfSD 2006	StructureType	PL - Platy	19
FAO GfSD 2006	StructureType	PM - Porous massive	4
FAO GfSD 2006	StructureType	PR - Prismatic	13
FAO GfSD 2006	StructureType	PS - Subangular prismatic	14
FAO GfSD 2006	StructureType	RS - Rock structure	1
FAO GfSD 2006	StructureType	SA - Subangular and angular blocky	10
FAO GfSD 2006	StructureType	SB - Subangular blocky	11
FAO GfSD 2006	StructureType	SG - Single grain	2
FAO GfSD 2006	StructureType	SN - Nutty subangular blocky	12
FAO GfSD 2006	StructureType	WC - Worm casts	18
FAO GfSD 2006	StructureType	WE - Wedge-shaped	15
FAO GfSD 2006	VoidsClassificationProperty	Channels	\N
FAO GfSD 2006	VoidsClassificationProperty	Interstitial	\N
FAO GfSD 2006	VoidsClassificationProperty	Planes	\N
FAO GfSD 2006	VoidsClassificationProperty	Vesicular	\N
FAO GfSD 2006	VoidsClassificationProperty	Vughs	\N
FAO GfSD 2006	voidsDiameterProperty	Coarse	\N
FAO GfSD 2006	voidsDiameterProperty	Fine	\N
FAO GfSD 2006	voidsDiameterProperty	fine and medium	\N
FAO GfSD 2006	voidsDiameterProperty	fine and very fine	\N
FAO GfSD 2006	voidsDiameterProperty	Medium	\N
FAO GfSD 2006	voidsDiameterProperty	medium and coarse	\N
FAO GfSD 2006	voidsDiameterProperty	Very coarse	\N
FAO GfSD 2006	voidsDiameterProperty	Very fine	\N
Soil Survey Manual 2017	FieldPH	3.5 - 4.4: Extremely acidic	2
Soil Survey Manual 2017	FieldPH	< 3.5: Ultra acidic	1
Soil Survey Manual 2017	FieldPH	4.5 - 5.0: Very strongly acidic	3
Soil Survey Manual 2017	FieldPH	5.1 - 5.5: Strongly acidic	4
Soil Survey Manual 2017	FieldPH	5.6 - 6.0: Moderately acidic	5
Soil Survey Manual 2017	FieldPH	6.1 - 6.5: Slightly acidic	6
Soil Survey Manual 2017	FieldPH	6.6 - 7.3: Neutral	7
Soil Survey Manual 2017	FieldPH	7.4 - 7.8: Slightly alkaline	8
Soil Survey Manual 2017	FieldPH	7.9 - 8.4: Moderately alkaline	9
Soil Survey Manual 2017	FieldPH	8.5 - 9.0: Moderately alkaline	10
Soil Survey Manual 2017	FieldPH	> 9.0: Very Strongly alkaline	11
WRB fourth edition 2022	AndicCharacteristics	NF - Positive NaF test	1
WRB fourth edition 2022	AndicCharacteristics	NO - None of the above	4
WRB fourth edition 2022	AndicCharacteristics	NT - Positive NAF test and thixotropy	3
WRB fourth edition 2022	AndicCharacteristics	TH - Thixotropy	2
\.


--
-- TOC entry 4962 (class 0 OID 54922800)
-- Dependencies: 225
-- Data for Name: observation_desc_plot; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.observation_desc_plot (procedure_desc_id, property_desc_id, category_desc_id, category_order) FROM stdin;
FAO GfSD 1990	DrainageClass	E - Excessively well drained - Water is removed from the soil very rapidly	1
FAO GfSD 1990	DrainageClass	I - Imperfectly drained - Water is removed slowly so that the soils are wet at shallow depth for a considerable period	5
FAO GfSD 1990	DrainageClass	M - Moderately well drained - Water is removed from the soil somewhat slowly during some periods of the year. The soils are wet for short periods within rooting depth	4
FAO GfSD 1990	DrainageClass	P - Poorly drained - Water is removed so slowly that the soils are commonly wet for considerable periods. The soils commonly have a shallow water table	6
FAO GfSD 1990	DrainageClass	S - Somewhat excessively well drained - Water is removed from the soil rapidly	2
FAO GfSD 1990	DrainageClass	V - Very poorly drained - Water is removed so slowly that the soils are wet at shallow depth for long periods. The soils have a very shallow water table	7
FAO GfSD 1990	DrainageClass	W - Well drained - Water is removed from the soil somewhat slowly during some periods of the year. The soils are wet for short periods within rooting depth	3
FAO GfSD 1990	ExternalDrainageClass	M - Moderately rapid run-off	4
FAO GfSD 1990	ExternalDrainageClass	N - Neither receiving nor shedding water	2
FAO GfSD 1990	ExternalDrainageClass	P - Ponded (run-on site)	1
FAO GfSD 1990	ExternalDrainageClass	R - Rapid run-off	5
FAO GfSD 1990	ExternalDrainageClass	S - Slow run-off	3
FAO GfSD 1990	FloodDuration	1 - Less than 1 day	1
FAO GfSD 1990	FloodDuration	2 - Very shallow (0-25 cm) Shallow (25-50 cm) Moderately deep (50-100 cm) Deep (100-150 cm) Very deep (> 150 cm) -15 days	2
FAO GfSD 1990	FloodDuration	3 - 15-30 days	3
FAO GfSD 1990	FloodDuration	4 - 30-90 days	4
FAO GfSD 1990	FloodDuration	5 - 90-180 days	5
FAO GfSD 1990	FloodDuration	6 - 180-360 days	6
FAO GfSD 1990	FloodDuration	7 - Continuously	7
FAO GfSD 1990	FloodFrequency	A - Annually	5
FAO GfSD 1990	FloodFrequency	B - Biennually	6
FAO GfSD 1990	FloodFrequency	D - Daily	2
FAO GfSD 1990	FloodFrequency	F - Once every 2-4 years	7
FAO GfSD 1990	FloodFrequency	M - Monthly	4
FAO GfSD 1990	FloodFrequency	NK - Unknown	10
FAO GfSD 1990	FloodFrequency	N - None	1
FAO GfSD 1990	FloodFrequency	R - Rare (less than once in every 10 years)	9
FAO GfSD 1990	FloodFrequency	T - Once every 5-10 years	8
FAO GfSD 1990	FloodFrequency	W - Weekly	3
FAO GfSD 1990	GroundwaterDepth	1 - Very shallow (0-25 cm)	1
FAO GfSD 1990	GroundwaterDepth	2 - Shallow (25-50 cm)	2
FAO GfSD 1990	GroundwaterDepth	3 - Moderately deep (50-100 cm)	3
FAO GfSD 1990	GroundwaterDepth	4 - Deep (100-150 cm)	4
FAO GfSD 1990	GroundwaterDepth	5 - Very deep (> 150 cm)	5
FAO GfSD 1990	GroundwaterQuality	BR  - Brackish	2
FAO GfSD 1990	GroundwaterQuality	FR  - Fresh	3
FAO GfSD 1990	GroundwaterQuality	OX  - Oxygenated	5
FAO GfSD 1990	GroundwaterQuality	PO  - Polluted	4
FAO GfSD 1990	GroundwaterQuality	SA  - Saline	1
FAO GfSD 1990	GroundwaterQuality	SG  - Stagnating	6
FAO GfSD 1990	MoistureConditions	D - Dry	1
FAO GfSD 1990	MoistureConditions	M - Moist	3
FAO GfSD 1990	MoistureConditions	S - Slightly moist	2
FAO GfSD 1990	MoistureConditions	W - Wet	4
FAO GfSD 2006	BleachedSandCover	0 - None (0 - 2 %)	1
FAO GfSD 2006	BleachedSandCover	1 - Low (2 - 15 %)	2
FAO GfSD 2006	BleachedSandCover	2 - Moderate (15 - 40 %)	3
FAO GfSD 2006	BleachedSandCover	3 - High (40 - 80 %)	4
FAO GfSD 2006	BleachedSandCover	4 - Dominant (> 80 %)	5
FAO GfSD 2006	ComplexLandform	CU - Cuesta-shaped	1
FAO GfSD 2006	ComplexLandform	DO = Dome-shaped	6
FAO GfSD 2006	ComplexLandform	DU = Dune-shaped	8
FAO GfSD 2006	ComplexLandform	IM - With intermontane plains (occupying > 15%)	4
FAO GfSD 2006	ComplexLandform	IN - Inselberg covered (occupying > 1% of level land)	3
FAO GfSD 2006	ComplexLandform	KA = Strong karst	9
FAO GfSD 2006	ComplexLandform	RI - Ridged	2
FAO GfSD 2006	ComplexLandform	TE = Terraced	7
FAO GfSD 2006	ComplexLandform	WE - With wetlands (occupying > 15%)	5
FAO GfSD 2006	CracksDepth	D - Deep (10 - 20 cm)	3
FAO GfSD 2006	CracksDepth	M - Medium (2 - 10 cm)	2
FAO GfSD 2006	CracksDepth	S - Surface (< 2 cm)	1
FAO GfSD 2006	CracksDepth	V - Very deep (> 20 cm)	4
FAO GfSD 2006	CracksDistance	C - Very closely spaced (< 0.2 m)	1
FAO GfSD 2006	CracksDistance	D - Closely spaced (0.2 - 0.5 m)	2
FAO GfSD 2006	CracksDistance	M - Moderately widely spaced (0.5 - 2 m)	3
FAO GfSD 2006	CracksDistance	V - Very widely spaced (> 5 m)	5
FAO GfSD 2006	CracksDistance	W - Widely spaced (2 - 5 m)	4
FAO GfSD 2006	CracksWidth	E - Extremely wide (> 10 cm)	5
FAO GfSD 2006	CracksWidth	F - Fine (<  1 cm)	1
FAO GfSD 2006	CracksWidth	M - Medium (1 - 2 cm)	2
FAO GfSD 2006	CracksWidth	V - Very wide (5 - 10 cm)	4
FAO GfSD 2006	CracksWidth	W - Wide (2 - 5 cm)	3
FAO GfSD 2006	Croptype	CeBa - Barley	2
FAO GfSD 2006	Croptype	Ce - Cereals	1
FAO GfSD 2006	Croptype	CeMa - Maize	3
FAO GfSD 2006	Croptype	CeMi - Millet	4
FAO GfSD 2006	Croptype	CeOa - Oats	5
FAO GfSD 2006	Croptype	CePa - Rice, paddy	6
FAO GfSD 2006	Croptype	CeRi - Rice, dry	7
FAO GfSD 2006	Croptype	CeRy - Rye	8
FAO GfSD 2006	Croptype	CeSo - Sorghum	9
FAO GfSD 2006	Croptype	CeWh - Wheat	10
FAO GfSD 2006	Croptype	FiCo - Cotton	42
FAO GfSD 2006	Croptype	Fi - Fibre Crops	41
FAO GfSD 2006	Croptype	FiJu - Jute	43
FAO GfSD 2006	Croptype	FoAl - Alfalfa	22
FAO GfSD 2006	Croptype	FoCl - Clover	23
FAO GfSD 2006	Croptype	Fo - Fodder Plants	21
FAO GfSD 2006	Croptype	FoGr - Grasses	24
FAO GfSD 2006	Croptype	FoHa - Hay	25
FAO GfSD 2006	Croptype	FoLe - Leguminous	26
FAO GfSD 2006	Croptype	FoMa - Maize	27
FAO GfSD 2006	Croptype	FoPu - Pumpkins	28
FAO GfSD 2006	Croptype	FrAp - Apples	35
FAO GfSD 2006	Croptype	FrBa - Bananas	36
FAO GfSD 2006	Croptype	FrCi - Citrus	37
FAO GfSD 2006	Croptype	Fr - Fruits and Melons	34
FAO GfSD 2006	Croptype	FrGr - Grapes, Wine, Raisins	38
FAO GfSD 2006	Croptype	FrMa - Mangoes	39
FAO GfSD 2006	Croptype	FrMe - Melons	40
FAO GfSD 2006	Croptype	LuCc - Cocoa	50
FAO GfSD 2006	Croptype	LuCo - Coffee	51
FAO GfSD 2006	Croptype	Lu - Semi-luxury Foods and Tobacco	49
FAO GfSD 2006	Croptype	LuTe - Tea	52
FAO GfSD 2006	Croptype	LuTo - Tobacco	53
FAO GfSD 2006	Croptype	OiCc - Coconuts	12
FAO GfSD 2006	Croptype	OiGr - Groundnuts	13
FAO GfSD 2006	Croptype	OiLi - Linseed	14
FAO GfSD 2006	Croptype	Oi - Oilcrops	11
FAO GfSD 2006	Croptype	OiOl - Olives	15
FAO GfSD 2006	Croptype	OiOp - Oil-palm	16
FAO GfSD 2006	Croptype	OiRa - Rape	17
FAO GfSD 2006	Croptype	OiSe - Sesame	18
FAO GfSD 2006	Croptype	OiSo - Soybeans	19
FAO GfSD 2006	Croptype	OiSu - Sunflower	20
FAO GfSD 2006	Croptype	Ot - Other Crops	54
FAO GfSD 2006	Croptype	OtPa - Palm (fibres, kernels)	57
FAO GfSD 2006	Croptype	OtRu - Rubber	56
FAO GfSD 2006	Croptype	OtSc - Sugar cane	55
FAO GfSD 2006	Croptype	PuBe - Beans	46
FAO GfSD 2006	Croptype	PuLe - Lentils	47
FAO GfSD 2006	Croptype	PuPe - Peas	48
FAO GfSD 2006	Croptype	Pu - Pulses	45
FAO GfSD 2006	Croptype	RoCa - Cassava	30
FAO GfSD 2006	Croptype	RoPo - Potatoes	31
FAO GfSD 2006	Croptype	Ro - Roots and Tubers	29
FAO GfSD 2006	Croptype	RoSu - Sugar beets	32
FAO GfSD 2006	Croptype	RoYa - Yams	33
FAO GfSD 2006	Croptype	Ve - Vegetables	44
FAO GfSD 2006	CurrentWeatherConditions	OV - Overcast	3
FAO GfSD 2006	CurrentWeatherConditions	PC - Partly cloudy	2
FAO GfSD 2006	CurrentWeatherConditions	RA - Rain	4
FAO GfSD 2006	CurrentWeatherConditions	SL - Sleet	5
FAO GfSD 2006	CurrentWeatherConditions	SN - Snow	6
FAO GfSD 2006	CurrentWeatherConditions	SU - Sunny/clear	1
FAO GfSD 2006	ErosionActivityPeriod	A - Active at present	1
FAO GfSD 2006	ErosionActivityPeriod	H - Active in historical times	3
FAO GfSD 2006	ErosionActivityPeriod	N - Period of activity not known	4
FAO GfSD 2006	ErosionActivityPeriod	R - Active in recent past (previous 50-100 years)	2
FAO GfSD 2006	ErosionActivityPeriod	X - Accelerated and natural erosion not distinguished	5
FAO GfSD 2006	ErosionAreaAffected	0 %	1
FAO GfSD 2006	ErosionAreaAffected	0 - 5 %	2
FAO GfSD 2006	ErosionAreaAffected	10 - 25 %	4
FAO GfSD 2006	ErosionAreaAffected	25 - 50 %	5
FAO GfSD 2006	ErosionAreaAffected	> 50 %	6
FAO GfSD 2006	ErosionAreaAffected	5 - 10 %	3
FAO GfSD 2006	ErosionClass	AD - Wind deposition	11
FAO GfSD 2006	ErosionClass	AM - Wind erosion and deposition	12
FAO GfSD 2006	ErosionClass	AS - Shifting sands	13
FAO GfSD 2006	ErosionClass	A - Wind (aeolian) erosion or deposition	10
FAO GfSD 2006	ErosionClass	AZ - Salt deposition	14
FAO GfSD 2006	ErosionClass	M - Mass movement	9
FAO GfSD 2006	ErosionClass	NK - Not known	15
FAO GfSD 2006	ErosionClass	N - No evidence of erosion	1
FAO GfSD 2006	ErosionClass	WA - Water and wind erosion	8
FAO GfSD 2006	ErosionClass	WD - Deposition by water	7
FAO GfSD 2006	ErosionClass	WG - Gully erosion	5
FAO GfSD 2006	ErosionClass	WR - Rill erosion	4
FAO GfSD 2006	ErosionClass	WS - Sheet erosion	3
FAO GfSD 2006	ErosionClass	WT - Tunnel erosion	6
FAO GfSD 2006	ErosionClass	W - Water erosion or deposition	2
FAO GfSD 2006	ErosionDegree	E - Extreme - Substantial removal of deeper subsurface horizons (badlands). Original biotic functions fully destroyed	4
FAO GfSD 2006	ErosionDegree	M - Moderate - Clear evidence of removal of surface horizons. Original biotic functions partly destroyed	2
FAO GfSD 2006	ErosionDegree	S - Severe - Surface horizons completely removed and subsurface horizons exposed. Original biotic functions largely destroyed	3
FAO GfSD 2006	ErosionDegree	S - Slight - Some evidence of damage to surface horizons. Original biotic functions largely intact	1
FAO GfSD 2006	erosionTotalAreaAffectedProperty	0	\N
FAO GfSD 2006	erosionTotalAreaAffectedProperty	0–5	\N
FAO GfSD 2006	erosionTotalAreaAffectedProperty	10–25	\N
FAO GfSD 2006	erosionTotalAreaAffectedProperty	25–50	\N
FAO GfSD 2006	erosionTotalAreaAffectedProperty	> 50	\N
FAO GfSD 2006	erosionTotalAreaAffectedProperty	5–10	\N
FAO GfSD 2006	FragmentsCover	A - Abundant (40 - 80 %)	6
FAO GfSD 2006	FragmentsCover	C - Common (5 - 15 %)	4
FAO GfSD 2006	FragmentsCover	D - Dominant (> 80 %)	7
FAO GfSD 2006	FragmentsCover	F - Few (2 - 5 %)	3
FAO GfSD 2006	FragmentsCover	M - Many (15 - 40 %)	5
FAO GfSD 2006	FragmentsCover	N - None (0 %)	1
FAO GfSD 2006	FragmentsCover	V - Very few (0 - 2 %)	2
FAO GfSD 2006	FragmentsSize	B - Boulders (20 - 60 cm)	5
FAO GfSD 2006	FragmentsSize	C - Coarse gravel (2 - 6 cm)	3
FAO GfSD 2006	FragmentsSize	F - Fine gravel (0.2 - 0.6 cm)	1
FAO GfSD 2006	FragmentsSize	L - Large boulders (60 - 200 cm)	6
FAO GfSD 2006	FragmentsSize	M - Medium gravel (0.6 - 2 cm)	2
FAO GfSD 2006	FragmentsSize	S - Stones (6 - 20 cm)	4
FAO GfSD 2006	HumanInfluence	AC - Archaeological (burial mound, midden)	17
FAO GfSD 2006	HumanInfluence	AD - Artificial drainage	13
FAO GfSD 2006	HumanInfluence	BP - Borrow pit	33
FAO GfSD 2006	HumanInfluence	BR - Burning	20
FAO GfSD 2006	HumanInfluence	BU - Bunding	19
FAO GfSD 2006	HumanInfluence	CL - Clearing	30
FAO GfSD 2006	HumanInfluence	CR - Impact crater	18
FAO GfSD 2006	HumanInfluence	DU - Dump (not specified)	34
FAO GfSD 2006	HumanInfluence	FE - Application of fertilizers	14
FAO GfSD 2006	HumanInfluence	IB - Border irrigation	11
FAO GfSD 2006	HumanInfluence	ID - Drip irrigation	9
FAO GfSD 2006	HumanInfluence	IF - Furrow irrigation	8
FAO GfSD 2006	HumanInfluence	IP - Flood irrigation	10
FAO GfSD 2006	HumanInfluence	IS - Sprinkler irrigation	7
FAO GfSD 2006	HumanInfluence	IU - Irrigation (not specified)	12
FAO GfSD 2006	HumanInfluence	LF - Landfill (also sanitary)	15
FAO GfSD 2006	HumanInfluence	LV - Levelling	16
FAO GfSD 2006	HumanInfluence	ME - Raised beds (engineering purposes)	25
FAO GfSD 2006	HumanInfluence	MI - Mine (surface, including openpit, gravel and quarries)	35
FAO GfSD 2006	HumanInfluence	MO - Organic additions (not specified)	28
FAO GfSD 2006	HumanInfluence	MP - Plaggen	23
FAO GfSD 2006	HumanInfluence	MR - Raised beds (agricultural purposes)	24
FAO GfSD 2006	HumanInfluence	MS - Sand additions	26
FAO GfSD 2006	HumanInfluence	MU - Mineral additions (not specified)	27
FAO GfSD 2006	HumanInfluence	NK - Not known	2
FAO GfSD 2006	HumanInfluence	N - No influence	1
FAO GfSD 2006	HumanInfluence	PL - Ploughing	22
FAO GfSD 2006	HumanInfluence	PO - Pollution	29
FAO GfSD 2006	HumanInfluence	SA - Scalped area	32
FAO GfSD 2006	HumanInfluence	SC - Surface compaction	31
FAO GfSD 2006	HumanInfluence	TE - Terracing	21
FAO GfSD 2006	HumanInfluence	VE - Vegetation strongly disturbed	5
FAO GfSD 2006	HumanInfluence	VM - Vegetation moderately disturbed	4
FAO GfSD 2006	HumanInfluence	VS - Vegetation slightly disturbed	3
FAO GfSD 2006	HumanInfluence	VU - Vegetation disturbed (not specified)	6
FAO GfSD 2006	Landuse	AA1 - Shifting cultivation	3
FAO GfSD 2006	Landuse	AA2 - Fallow system cultivation	4
FAO GfSD 2006	Landuse	AA3 - Ley system cultivation	5
FAO GfSD 2006	Landuse	AA4C - Commercial rainfed arable cultivation	7
FAO GfSD 2006	Landuse	AA4I - Improved traditional rainfed arable cultivation	8
FAO GfSD 2006	Landuse	AA4M - Mechanized traditional rainfed arable cultivation	9
FAO GfSD 2006	Landuse	AA4 - Rainfed arable cultivation	6
FAO GfSD 2006	Landuse	AA4T - Traditional rainfed arable cultivation	10
FAO GfSD 2006	Landuse	AA4U - Unspecified rainfed arable cultivation	11
FAO GfSD 2006	Landuse	AA5 - Wet rice cultivation	12
FAO GfSD 2006	Landuse	AA6 - Irrigated cultivation	13
FAO GfSD 2006	Landuse	AA - Annual field cropping	2
FAO GfSD 2006	Landuse	A - Crop agriculture (cropping)	1
FAO GfSD 2006	Landuse	AP1 - Non-irrigated cultivation	15
FAO GfSD 2006	Landuse	AP2 - Irrigated cultivation	16
FAO GfSD 2006	Landuse	AP - Perennial field cropping	14
FAO GfSD 2006	Landuse	AT1 - Non-irrigated tree crop cultivation	18
FAO GfSD 2006	Landuse	AT2 - Irrigated tree crop cultivation	19
FAO GfSD 2006	Landuse	AT3 - Non-irrigated shrub crop cultivation	20
FAO GfSD 2006	Landuse	AT4 - Irrigated shrub crop cultivation	21
FAO GfSD 2006	Landuse	AT - Tree and shrub cropping	17
FAO GfSD 2006	Landuse	E - Extraction and collection	22
FAO GfSD 2006	Landuse	EH - Hunting and fishing	23
FAO GfSD 2006	Landuse	EV - Exploitation of natural vegetation	24
FAO GfSD 2006	Landuse	F - Forestry	25
FAO GfSD 2006	Landuse	FN1 - Selective felling	27
FAO GfSD 2006	Landuse	FN2 - Clear felling	28
FAO GfSD 2006	Landuse	FN - Natural forest and woodland	26
FAO GfSD 2006	Landuse	FP - Plantation forestry	29
FAO GfSD 2006	Landuse	H - Animal husbandry	30
FAO GfSD 2006	Landuse	HE1 - Nomadism	32
FAO GfSD 2006	Landuse	HE2 - Semi-nomadism	33
FAO GfSD 2006	Landuse	HE3 - Ranching	34
FAO GfSD 2006	Landuse	HE - Extensive grazing	31
FAO GfSD 2006	Landuse	HI1 - Animal production	36
FAO GfSD 2006	Landuse	HI2 - Dairying	37
FAO GfSD 2006	Landuse	HI - Intensive grazing	35
FAO GfSD 2006	Landuse	MF - Agroforestry	39
FAO GfSD 2006	Landuse	M - Mixed farming	38
FAO GfSD 2006	Landuse	MP - Agropastoralism	40
FAO GfSD 2006	Landuse	PD1 - Without interference	43
FAO GfSD 2006	Landuse	PD2 - With interference	44
FAO GfSD 2006	Landuse	PD - Degradation control	42
FAO GfSD 2006	Landuse	PN1 - Reserves	46
FAO GfSD 2006	Landuse	PN2 - Parks	47
FAO GfSD 2006	Landuse	PN3 - Wildlife management	48
FAO GfSD 2006	Landuse	P - Nature protection	41
FAO GfSD 2006	Landuse	PN - Nature and game preservation	45
FAO GfSD 2006	Landuse	SC - Recreational use	50
FAO GfSD 2006	Landuse	SI - Industrial use	51
FAO GfSD 2006	Landuse	SR - Residential use	52
FAO GfSD 2006	Landuse	S - Settlement, industry	49
FAO GfSD 2006	Landuse	ST - Transport	53
FAO GfSD 2006	Landuse	SX - Excavations	54
FAO GfSD 2006	Landuse	U - Not used and not managed	55
FAO GfSD 2006	Lithology	IA1 - Acid igneous: granite	1
FAO GfSD 2006	Lithology	IA2 - Acid igneous: grano-diorite	2
FAO GfSD 2006	Lithology	IA3 - Acid igneous: quartz-diorite	3
FAO GfSD 2006	Lithology	IA4 - Acid igneous: rhyiolite	4
FAO GfSD 2006	Lithology	IB1 - basic igneous: gabbro	7
FAO GfSD 2006	Lithology	IB2 - basic  igneous: basalt	8
FAO GfSD 2006	Lithology	IB3 - basic igneous: dolerite	9
FAO GfSD 2006	Lithology	II1 - Intermediate igneous: andesite, trachyte, phonolite	5
FAO GfSD 2006	Lithology	II2 - Intermediate igneous: diorite-syenite	6
FAO GfSD 2006	Lithology	IP1 - Igneous  pyroclastic tuff, tuffite	13
FAO GfSD 2006	Lithology	IP2 - Igneous  pyroclastic volcanic scoria/breccia	14
FAO GfSD 2006	Lithology	IP3 - Igneous: pyroclastic volcanic ash	15
FAO GfSD 2006	Lithology	IP4 - Igneous  pyroclastic ignimbrite	16
FAO GfSD 2006	Lithology	IU1 - Ultrabasic igneous: peridotite	10
FAO GfSD 2006	Lithology	IU2 - Ultrabasic igneous: pyroxenite	11
FAO GfSD 2006	Lithology	IU3 - Ultrabasic igneous: ilmenite, magnetite, ironstone, serpentine	12
FAO GfSD 2006	Lithology	MA1 - Acid metamorphic: quartzite	17
FAO GfSD 2006	Lithology	MA2 - Acid metamorphic: gneiss, migmatite	18
FAO GfSD 2006	Lithology	MA3 - Acid metamorphic: slate, phyllite, (pellitic rocks)	19
FAO GfSD 2006	Lithology	MA4 - Acid metamorphic: schist	20
FAO GfSD 2006	Lithology	MB1 - Basic metamorphic: slate, phyllite (pelitic rocks)	21
FAO GfSD 2006	Lithology	MB2 - Basic metamorphic:  (green)schist	22
FAO GfSD 2006	Lithology	MB3 - Basic metamorphic: gneiss rich in Fe-Mg minerals	23
FAO GfSD 2006	Lithology	MB4 - Basic metamorphic: metamorphic limestone (marble)	24
FAO GfSD 2006	Lithology	MB5 - Basic metamorphic  amphibolite	25
FAO GfSD 2006	Lithology	MB6 - Basic metamorphic: eclogite	26
FAO GfSD 2006	Lithology	MU1 - Ultrabasic metamorphic: serpentinite, greenstone	27
FAO GfSD 2006	Lithology	SC1 - Clastic sediments: conglomerate, breccia	28
FAO GfSD 2006	Lithology	SC2 - Clastic sediments: sandstone, greywacke, arkose	29
FAO GfSD 2006	Lithology	SC3 - Clastic sediments: silt-, mud-, claystone	30
FAO GfSD 2006	Lithology	SC4 - Clastic sediments: shale	31
FAO GfSD 2006	Lithology	SC5 - Clastic sediments: ironstone	32
FAO GfSD 2006	Lithology	SE1 - Evaporites: anhydrite, gypsum	36
FAO GfSD 2006	Lithology	SE2 - Evaporites: halite	37
FAO GfSD 2006	Lithology	SO1 - Sedimentary organic: limestone, other carbonate rocks	33
FAO GfSD 2006	Lithology	SO2 - Sedimentary organic: marl and other mixtures	34
FAO GfSD 2006	Lithology	SO3 - Sedimentary organic: coals, bitumen and related rocks	35
FAO GfSD 2006	Lithology	UA1 - Unconsolidated: Anthropogenic/ technogenic redeposited natural material	56
FAO GfSD 2006	Lithology	UA2 -  Unconsolidated: Anthropogenic/ technogenic industrial/artisanal deposits	57
FAO GfSD 2006	Lithology	UC1 - Unconsolidated: colluvial slope deposits	45
FAO GfSD 2006	Lithology	UC2 - Unconsolidated: colluvial lahar	46
FAO GfSD 2006	Lithology	UE1 - Unconsolidated: eolian loess	47
FAO GfSD 2006	Lithology	UE2 - Unconsolidated: eolian sand	48
FAO GfSD 2006	Lithology	UF1 - Unconsolidated: fluvial sand and gravel	39
FAO GfSD 2006	Lithology	UF2 - Unconsolidated: fluvial clay, silt and loam	40
FAO GfSD 2006	Lithology	UG1 - Unconsolidated: glacial moraine	49
FAO GfSD 2006	Lithology	UG2 - Unconsolidated: glacio-fluvial sand	50
FAO GfSD 2006	Lithology	UG3 - Unconsolidated: glacio-fluvial gravel	51
FAO GfSD 2006	Lithology	UK1 -  Unconsolidated  kryogenic periglacial rock debris	52
FAO GfSD 2006	Lithology	UK2 - Unconsolidated: kryogenic periglacial solifluction layer	53
FAO GfSD 2006	Lithology	UL1 - Unconsolidated: lacustrine sand	41
FAO GfSD 2006	Lithology	UL2 - Unconsolidated: lacustrine silt and clay	42
FAO GfSD 2006	Lithology	UM1 - Unconsolidated: marine sand	43
FAO GfSD 2006	Lithology	UM2 - Unconsolidated: marine clay and silt	44
FAO GfSD 2006	Lithology	UO1 - Unconsolidated: organic rainwater-fed moor peat	54
FAO GfSD 2006	Lithology	UO2 - Unconsolidated: organic groundwater-fed bog peat	55
FAO GfSD 2006	Lithology	UR1 - Unconsolidated:  weathered residuum bauxite, laterite	38
FAO GfSD 2006	Lithology	UU1 - Unconsolidated: unspecified deposits clay	58
FAO GfSD 2006	Lithology	UU2 - Unconsolidated  unspecifiedloam and silt	59
FAO GfSD 2006	Lithology	UU3 - Unconsolidated: unspecified sand	60
FAO GfSD 2006	Lithology	UU4 - Unconsolidated: unspecified gravelly sand	61
FAO GfSD 2006	Lithology	UU5 - Unconsolidated: unspecified gravel, broken rock	62
FAO GfSD 2006	MajorLandForm	LD - Depression (< 10 %)	4
FAO GfSD 2006	MajorLandForm	L - Level land (< 10 %)	1
FAO GfSD 2006	MajorLandForm	LL - Plateau (< 10 %)	3
FAO GfSD 2006	MajorLandForm	LP - Plain (< 10 %)	2
FAO GfSD 2006	MajorLandForm	LV - Valley floor (< 10 %)	5
FAO GfSD 2006	MajorLandForm	SE - Medium-gradient escarpment zone (10 - 30 %)	7
FAO GfSD 2006	MajorLandForm	SH - Medium-gradient hill (10 - 30 %)	8
FAO GfSD 2006	MajorLandForm	SM - Medium-gradient mountain (10 - 30 %)	9
FAO GfSD 2006	MajorLandForm	SP - Dissected plain (10 - 30 %)	10
FAO GfSD 2006	MajorLandForm	S - Sloping land (10 - 30 %)	6
FAO GfSD 2006	MajorLandForm	SV - Medium-gradient valley (10 - 30 %)	11
FAO GfSD 2006	MajorLandForm	TE - High-gradient escarpment zone (> 30 %)	13
FAO GfSD 2006	MajorLandForm	TH - High-gradient hill (> 30 %)	14
FAO GfSD 2006	MajorLandForm	TM - High-gradient mountain (> 30 %)	15
FAO GfSD 2006	MajorLandForm	T - Steep land (> 30 %)	12
FAO GfSD 2006	MajorLandForm	TV - High-gradient valley (> 30 %)	16
FAO GfSD 2006	MoistureRegime	AQ - Aquic	1
FAO GfSD 2006	MoistureRegime	AR - Aridic	7
FAO GfSD 2006	MoistureRegime	DU - Udic	3
FAO GfSD 2006	MoistureRegime	PQ - Peraquic	2
FAO GfSD 2006	MoistureRegime	PU - Perudic	4
FAO GfSD 2006	MoistureRegime	TO - Torric	8
FAO GfSD 2006	MoistureRegime	US - Ustic	5
FAO GfSD 2006	MoistureRegime	XE - Xeric	6
FAO GfSD 2006	ParentDepositionProperty	Deposition by water	\N
FAO GfSD 2006	ParentDepositionProperty	Gully erosion	\N
FAO GfSD 2006	ParentDepositionProperty	Mass movement	\N
FAO GfSD 2006	ParentDepositionProperty	No evidence of erosion	\N
FAO GfSD 2006	ParentDepositionProperty	Not known	\N
FAO GfSD 2006	ParentDepositionProperty	Rill erosion	\N
FAO GfSD 2006	ParentDepositionProperty	Salt deposition	\N
FAO GfSD 2006	ParentDepositionProperty	Sheet erosion	\N
FAO GfSD 2006	ParentDepositionProperty	Shifting sands	\N
FAO GfSD 2006	ParentDepositionProperty	Tunnel erosion	\N
FAO GfSD 2006	ParentDepositionProperty	Water and wind erosion	\N
FAO GfSD 2006	ParentDepositionProperty	Water erosion or deposition	\N
FAO GfSD 2006	ParentDepositionProperty	Wind (aeolian) erosion or deposition	\N
FAO GfSD 2006	ParentDepositionProperty	Wind deposition	\N
FAO GfSD 2006	ParentDepositionProperty	Wind erosion and deposition	\N
FAO GfSD 2006	parentLithologyProperty	acid igneous	\N
FAO GfSD 2006	parentLithologyProperty	acid metamorphic	\N
FAO GfSD 2006	parentLithologyProperty	amphibolite	\N
FAO GfSD 2006	parentLithologyProperty	andesite, trachyte, phonolite	\N
FAO GfSD 2006	parentLithologyProperty	anhydrite, gypsum	\N
FAO GfSD 2006	parentLithologyProperty	anthropogenic/technogenic	\N
FAO GfSD 2006	parentLithologyProperty	basalt	\N
FAO GfSD 2006	parentLithologyProperty	basic igneous	\N
FAO GfSD 2006	parentLithologyProperty	basic metamorphic	\N
FAO GfSD 2006	parentLithologyProperty	bauxite, laterite	\N
FAO GfSD 2006	parentLithologyProperty	carbonatic, organic	\N
FAO GfSD 2006	parentLithologyProperty	clastic sediments	\N
FAO GfSD 2006	parentLithologyProperty	clay	\N
FAO GfSD 2006	parentLithologyProperty	clay and silt	\N
FAO GfSD 2006	parentLithologyProperty	clay, silt and loam	\N
FAO GfSD 2006	parentLithologyProperty	coals, bitumen and related rocks	\N
FAO GfSD 2006	parentLithologyProperty	colluvial	\N
FAO GfSD 2006	parentLithologyProperty	conglomerate, breccia	\N
FAO GfSD 2006	parentLithologyProperty	diorite	\N
FAO GfSD 2006	parentLithologyProperty	diorite-syenite	\N
FAO GfSD 2006	parentLithologyProperty	dolerite	\N
FAO GfSD 2006	parentLithologyProperty	eclogite	\N
FAO GfSD 2006	parentLithologyProperty	eolian	\N
FAO GfSD 2006	parentLithologyProperty	evaporites	\N
FAO GfSD 2006	parentLithologyProperty	fluvial	\N
FAO GfSD 2006	parentLithologyProperty	gabbro	\N
FAO GfSD 2006	parentLithologyProperty	glacial	\N
FAO GfSD 2006	parentLithologyProperty	gneiss, migmatite	\N
FAO GfSD 2006	parentLithologyProperty	gneiss rich in Fe–Mg minerals	\N
FAO GfSD 2006	parentLithologyProperty	grano-diorite	\N
FAO GfSD 2006	parentLithologyProperty	gravel, broken rock	\N
FAO GfSD 2006	parentLithologyProperty	gravelly sand	\N
FAO GfSD 2006	parentLithologyProperty	(green)schist	\N
FAO GfSD 2006	parentLithologyProperty	groundwater-fed bog peat	\N
FAO GfSD 2006	parentLithologyProperty	halite	\N
FAO GfSD 2006	parentLithologyProperty	igneous rock	\N
FAO GfSD 2006	parentLithologyProperty	ignimbrite	\N
FAO GfSD 2006	parentLithologyProperty	ilmenite, magnetite, ironstone, serpentine	\N
FAO GfSD 2006	parentLithologyProperty	industrial/artisanal deposits	\N
FAO GfSD 2006	parentLithologyProperty	intermediate igneous	\N
FAO GfSD 2006	parentLithologyProperty	ironstone	\N
FAO GfSD 2006	parentLithologyProperty	kryogenic	\N
FAO GfSD 2006	parentLithologyProperty	lacustrine	\N
FAO GfSD 2006	parentLithologyProperty	lahar	\N
FAO GfSD 2006	parentLithologyProperty	limestone, other carbonate rock	\N
FAO GfSD 2006	parentLithologyProperty	loam and silt	\N
FAO GfSD 2006	parentLithologyProperty	loess	\N
FAO GfSD 2006	parentLithologyProperty	marine, estuarine	\N
FAO GfSD 2006	parentLithologyProperty	marl and other mixtures	\N
FAO GfSD 2006	parentLithologyProperty	metamorphic limestone (marble)	\N
FAO GfSD 2006	parentLithologyProperty	metamorphic rock	\N
FAO GfSD 2006	parentLithologyProperty	moraine	\N
FAO GfSD 2006	parentLithologyProperty	organic	\N
FAO GfSD 2006	parentLithologyProperty	peridotite	\N
FAO GfSD 2006	parentLithologyProperty	periglacial rock debris	\N
FAO GfSD 2006	parentLithologyProperty	periglacial solifluction layer	\N
FAO GfSD 2006	parentLithologyProperty	pyroclastic	\N
FAO GfSD 2006	parentLithologyProperty	pyroxenite	\N
FAO GfSD 2006	parentLithologyProperty	quartz-diorite	\N
FAO GfSD 2006	parentLithologyProperty	quartzite	\N
FAO GfSD 2006	parentLithologyProperty	rainwater-fed moor peat	\N
FAO GfSD 2006	parentLithologyProperty	redeposited natural material	\N
FAO GfSD 2006	parentLithologyProperty	rhyolite	\N
FAO GfSD 2006	parentLithologyProperty	sand	\N
FAO GfSD 2006	parentLithologyProperty	sand and gravel	\N
FAO GfSD 2006	parentLithologyProperty	sandstone, greywacke, arkose	\N
FAO GfSD 2006	parentLithologyProperty	schist	\N
FAO GfSD 2006	parentLithologyProperty	sedimentary rock (consolidated)	\N
FAO GfSD 2006	parentLithologyProperty	sedimentary rock (unconsolidated)	\N
FAO GfSD 2006	parentLithologyProperty	serpentinite, greenstone	\N
FAO GfSD 2006	parentLithologyProperty	shale	\N
FAO GfSD 2006	parentLithologyProperty	silt and clay	\N
FAO GfSD 2006	parentLithologyProperty	silt-, mud-, claystone	\N
FAO GfSD 2006	parentLithologyProperty	slate, phyllite (pelitic rocks)	\N
FAO GfSD 2006	parentLithologyProperty	slope deposits	\N
FAO GfSD 2006	parentLithologyProperty	tuff, tuffite	\N
FAO GfSD 2006	parentLithologyProperty	UG2 glacio-fluvial sand	\N
FAO GfSD 2006	parentLithologyProperty	UG3 glacio-fluvial gravel	\N
FAO GfSD 2006	parentLithologyProperty	ultrabasic igneous	\N
FAO GfSD 2006	parentLithologyProperty	ultrabasic metamorphic	\N
FAO GfSD 2006	parentLithologyProperty	unspecified deposits	\N
FAO GfSD 2006	parentLithologyProperty	volcanic ash	\N
FAO GfSD 2006	parentLithologyProperty	volcanic scoria/breccia	\N
FAO GfSD 2006	parentLithologyProperty	weathered residuum	\N
FAO GfSD 2006	ParentMaterialClass	I - igneous rock	1
FAO GfSD 2006	ParentMaterialClass	M - metamorphic rock	2
FAO GfSD 2006	ParentMaterialClass	S - sedimentary rock (consolidated)	3
FAO GfSD 2006	ParentMaterialClass	U - sedimentary rock (unconsolidated)	4
FAO GfSD 2006	PastWeatherConditions	WC1 - No rain in the last month	1
FAO GfSD 2006	PastWeatherConditions	WC2 - No rain in the last week	2
FAO GfSD 2006	PastWeatherConditions	WC3 - No rain in the last 24 hours	3
FAO GfSD 2006	PastWeatherConditions	WC4 - Rainy without heavy rain in the last 24 hours	4
FAO GfSD 2006	PastWeatherConditions	WC5 - Heavier rain for some days or rainstorm in the last 24 hours	5
FAO GfSD 2006	PastWeatherConditions	WC6 - Extremely rainy time or snow melting	6
FAO GfSD 2006	Position	BO - Bottom (drainage line)	10
FAO GfSD 2006	Position	BO - Bottom (flat)	6
FAO GfSD 2006	Position	CR - Crest (summit)	1
FAO GfSD 2006	Position	HI - Higher part (rise)	7
FAO GfSD 2006	Position	IN - Intermediate part (talf)	8
FAO GfSD 2006	Position	LO - Lower part (and dip)	9
FAO GfSD 2006	Position	LS - Lower slope (foot slope)	4
FAO GfSD 2006	Position	MS - Middle slope (back slope)	3
FAO GfSD 2006	Position	TS - Toe slope	5
FAO GfSD 2006	Position	UP - Upper slope (shoulder)	2
FAO GfSD 2006	RockOutcropsCover	A - Abundant (40 - 80 %)	6
FAO GfSD 2006	RockOutcropsCover	C - Common (5 - 15 %)	4
FAO GfSD 2006	RockOutcropsCover	D - Dominant (> 80 %)	7
FAO GfSD 2006	RockOutcropsCover	F - Few (2 - 5 %)	3
FAO GfSD 2006	RockOutcropsCover	M - Many (15 - 40 %)	5
FAO GfSD 2006	RockOutcropsCover	N - None (0 %)	1
FAO GfSD 2006	RockOutcropsCover	V - Very few (0 - 2 %)	2
FAO GfSD 2006	RockOutcropsDistance	20-50 m	4
FAO GfSD 2006	RockOutcropsDistance	2-5 m	2
FAO GfSD 2006	RockOutcropsDistance	< 2 m	1
FAO GfSD 2006	RockOutcropsDistance	> 50 m	5
FAO GfSD 2006	RockOutcropsDistance	5-20 m	3
FAO GfSD 2006	SaltCover	0 - None (0 - 2 %)	1
FAO GfSD 2006	SaltCover	1 - Low (2 - 15 %)	2
FAO GfSD 2006	SaltCover	2 - Moderate (15 - 40 %)	3
FAO GfSD 2006	SaltCover	3 - High (40 - 80 %)	4
FAO GfSD 2006	SaltCover	4 - Dominant (> 80 %)	5
FAO GfSD 2006	SaltThickness	C - Thick (5 - 20 mm)	4
FAO GfSD 2006	SaltThickness	F - Thin (< 2 mm)	2
FAO GfSD 2006	SaltThickness	M - Medium (2 - 5 mm)	3
FAO GfSD 2006	SaltThickness	N - None	1
FAO GfSD 2006	SaltThickness	V - Very thick (> 20 mm)	5
FAO GfSD 2006	SealingConsistence	E - Extremely hard	4
FAO GfSD 2006	SealingConsistence	H - Hard	2
FAO GfSD 2006	SealingConsistence	S - Slightly hard	1
FAO GfSD 2006	SealingConsistence	V - Very hard	3
FAO GfSD 2006	SealingThickness	C - Thick (5 - 20 mm)	4
FAO GfSD 2006	SealingThickness	F - Thin (< 2 mm)	2
FAO GfSD 2006	SealingThickness	M - Medium (2 - 5 mm)	3
FAO GfSD 2006	SealingThickness	N - None	1
FAO GfSD 2006	SealingThickness	V - Very thick (>20 mm)	5
FAO GfSD 2006	SlopeForm	C - Concave	2
FAO GfSD 2006	SlopeForm	S - Straight	1
FAO GfSD 2006	SlopeForm	T - Terraced	4
FAO GfSD 2006	SlopeForm	V - Convex	3
FAO GfSD 2006	SlopeForm	X - Complex (irregular)	5
FAO GfSD 2006	SlopeGradient	01 - Flat (0 - 0.2 %)	1
FAO GfSD 2006	SlopeGradient	02 - Level (0.2 - 0.5 %)	2
FAO GfSD 2006	SlopeGradient	03 - Nearly level (0.5 - 1.0 %)	3
FAO GfSD 2006	SlopeGradient	04 - Very gently sloping (1.0 - 2.0 %)	4
FAO GfSD 2006	SlopeGradient	05 - Gently sloping (2 - 5 %)	5
FAO GfSD 2006	SlopeGradient	06 - Sloping (5 - 10 %)	6
FAO GfSD 2006	SlopeGradient	07 - Strongly sloping (10 - 15 %)	7
FAO GfSD 2006	SlopeGradient	08 - Moderately steep (15 - 30 %)	8
FAO GfSD 2006	SlopeGradient	09 - Steep (30 - 60 %)	9
FAO GfSD 2006	SlopeGradient	10 - Very steep (> 60 %)	10
FAO GfSD 2006	slopeGradientClassProperty	Flat	\N
FAO GfSD 2006	slopeGradientClassProperty	Gently sloping	\N
FAO GfSD 2006	slopeGradientClassProperty	Level	\N
FAO GfSD 2006	slopeGradientClassProperty	Moderately steep	\N
FAO GfSD 2006	slopeGradientClassProperty	Nearly level	\N
FAO GfSD 2006	slopeGradientClassProperty	Sloping	\N
FAO GfSD 2006	slopeGradientClassProperty	Steep	\N
FAO GfSD 2006	slopeGradientClassProperty	Strongly sloping	\N
FAO GfSD 2006	slopeGradientClassProperty	Very gently sloping 	\N
FAO GfSD 2006	slopeGradientClassProperty	Very steep	\N
FAO GfSD 2006	SlopeOrientation	E - east	5
FAO GfSD 2006	SlopeOrientation	ENE - east-north-east	6
FAO GfSD 2006	SlopeOrientation	ESE - east-south-east	4
FAO GfSD 2006	SlopeOrientation	NE - north-east	7
FAO GfSD 2006	SlopeOrientation	NNE - north-north-east	8
FAO GfSD 2006	SlopeOrientation	N - north	9
FAO GfSD 2006	SlopeOrientation	NNW - north-north-west	10
FAO GfSD 2006	SlopeOrientation	NW - north-west	11
FAO GfSD 2006	SlopeOrientation	SE - south-east	3
FAO GfSD 2006	SlopeOrientation	SSE - south-south-east	2
FAO GfSD 2006	SlopeOrientation	S - south	1
FAO GfSD 2006	SlopeOrientation	SSW - south-south-west	16
FAO GfSD 2006	SlopeOrientation	SW - south-west	15
FAO GfSD 2006	SlopeOrientation	WNW - west-north-west	12
FAO GfSD 2006	SlopeOrientation	WSW - west-south-west	14
FAO GfSD 2006	SlopeOrientation	W - west	13
FAO GfSD 2006	SlopePathway	CC - concave-concave	1
FAO GfSD 2006	SlopePathway	CS - concave-straight	2
FAO GfSD 2006	SlopePathway	CV - concave-convexstraight	3
FAO GfSD 2006	SlopePathway	SC - straight-concave	4
FAO GfSD 2006	SlopePathway	SS - straight-straight	5
FAO GfSD 2006	SlopePathway	SV - straight-convex	6
FAO GfSD 2006	SlopePathway	VC - convex-concave	7
FAO GfSD 2006	SlopePathway	VS - convex-straight	8
FAO GfSD 2006	SlopePathway	VV - convex-convex	9
FAO GfSD 2006	SurfaceAge	Ha - Holocene (100-10,000 years) anthropogeomorphic: human-made relief modifications, such as terracing or formation of hills or walls by early civilizations or during the Middle Ages, restriction of flooding by dykes, or surface raising.	6
FAO GfSD 2006	SurfaceAge	Hn - Holocene (100-10,000 years) natural: with loss by erosion or deposition of materials such as on tidal flats, coastal dunes, river valleys, landslides, or desert areas.	5
FAO GfSD 2006	SurfaceAge	lPf - Late Pleistocene, without periglacial influence.	9
FAO GfSD 2006	SurfaceAge	lPi - Late Pleistocene, ice-covered: commonly recent soil formation on fresh materials.	7
FAO GfSD 2006	SurfaceAge	lPp - Late Pleistocene, periglacial: commonly recent soil formation on preweathered materials.	8
FAO GfSD 2006	SurfaceAge	O - Older, pre-Tertiary land surfaces: commonly high plains, terraces, or peneplains, except incised valleys; frequent occurrence of palaeosoils.	14
FAO GfSD 2006	SurfaceAge	oPf - Older Pleistocene, without periglacial influence.	12
FAO GfSD 2006	SurfaceAge	oPi - Older Pleistocene, ice-covered: commonly recent soil formation on younger over older, preweathered materials.	10
FAO GfSD 2006	SurfaceAge	oPp - Older Pleistocene, with periglacial influence: commonly recent soil formation on younger over older, preweathered materials.	11
FAO GfSD 2006	SurfaceAge	T - Tertiary land surfaces: commonly high plains, terraces, or peneplains, except incised valleys; frequent occurrence of palaeosoils.	13
FAO GfSD 2006	SurfaceAge	vYa - Very young (1-10 years) anthropogeomorphic: with complete disturbance of natural surfaces (and soils), such as in urban, industrial, or mining areas, with very early soil development from fresh natural, technogenic, or mixed materials.	2
FAO GfSD 2006	SurfaceAge	vYn - Very young (1-10 years) natural: with loss by erosion or deposition of materials such as on tidal flats, coastal dunes, river valleys, landslides, or desert areas.	1
FAO GfSD 2006	SurfaceAge	Ya - Young (10-100 years) anthropogeomorphic: with complete disturbance of any natural surfaces (and soils), such as in urban, industrial, or mining areas, with early soil development from fresh natural, technogenic, or mixed materials, or restriction of flooding by dykes.	4
FAO GfSD 2006	SurfaceAge	Yn - Young (10-100 years) natural: with loss by erosion or deposition of materials such as on tidal flats, coastal dunes, river valleys, landslides, or desert areas.	3
FAO GfSD 2006	TemperatureRegime	CR - Cryic	2
FAO GfSD 2006	TemperatureRegime	FR - Frigid	3
FAO GfSD 2006	TemperatureRegime	HT - Hyperthermic	6
FAO GfSD 2006	TemperatureRegime	IF - Isofrigid	7
FAO GfSD 2006	TemperatureRegime	IH - Isohyperthermic	10
FAO GfSD 2006	TemperatureRegime	IM - Isomesic	8
FAO GfSD 2006	TemperatureRegime	IT - Isothermic	9
FAO GfSD 2006	TemperatureRegime	ME - Mesic	4
FAO GfSD 2006	TemperatureRegime	PG - Pergelic	1
FAO GfSD 2006	TemperatureRegime	TH - Thermic	5
FAO GfSD 2006	Vegetation	B - Groundwater-fed bog peat	29
FAO GfSD 2006	Vegetation	DD - Deciduous dwarf shrub	20
FAO GfSD 2006	Vegetation	D - Dwarf Shrub	17
FAO GfSD 2006	Vegetation	DE - Evergreen dwarf shrub	18
FAO GfSD 2006	Vegetation	DS - Semi-deciduous dwarf shrub	19
FAO GfSD 2006	Vegetation	DT - Tundra	22
FAO GfSD 2006	Vegetation	DX - Xeromorphic dwarf shrub	21
FAO GfSD 2006	Vegetation	FC - Coniferous forest	3
FAO GfSD 2006	Vegetation	F - Closed Forest	1
FAO GfSD 2006	Vegetation	FD - Deciduous forest	5
FAO GfSD 2006	Vegetation	FE - Evergreen broad-leaved forest	2
FAO GfSD 2006	Vegetation	FS - Semi-deciduous forest	4
FAO GfSD 2006	Vegetation	FX - Xeromorphic forest	6
FAO GfSD 2006	Vegetation	HF - Forb	27
FAO GfSD 2006	Vegetation	H - Herbaceous	23
FAO GfSD 2006	Vegetation	HM - Medium grassland	25
FAO GfSD 2006	Vegetation	HS - Short grassland	26
FAO GfSD 2006	Vegetation	HT - Tall grassland	24
FAO GfSD 2006	Vegetation	M - Rainwater-fed moor peat	28
FAO GfSD 2006	Vegetation	SD - Deciduous shrub	15
FAO GfSD 2006	Vegetation	SE - Evergreen shrub	13
FAO GfSD 2006	Vegetation	S - Shrub	12
FAO GfSD 2006	Vegetation	SS - Semi-deciduous shrub	14
FAO GfSD 2006	Vegetation	SX - Xeromorphic shrub	16
FAO GfSD 2006	Vegetation	WD - Deciduous woodland	10
FAO GfSD 2006	Vegetation	WE - Evergreen woodland	8
FAO GfSD 2006	Vegetation	WS - Semi-deciduous woodland	9
FAO GfSD 2006	Vegetation	W - Woodland	7
FAO GfSD 2006	Vegetation	WX - Xeromorphic woodland	11
ISRIC Report 2019/01	BareSoilAbundance	0 - 10 %	1
ISRIC Report 2019/01	BareSoilAbundance	10 - 20 %	2
ISRIC Report 2019/01	BareSoilAbundance	20 - 30 %	3
ISRIC Report 2019/01	BareSoilAbundance	30 - 40 %	4
ISRIC Report 2019/01	BareSoilAbundance	40 - 50 %	5
ISRIC Report 2019/01	BareSoilAbundance	50 - 60 %	6
ISRIC Report 2019/01	BareSoilAbundance	60 - 70 %	7
ISRIC Report 2019/01	BareSoilAbundance	70 - 80 %	8
ISRIC Report 2019/01	BareSoilAbundance	80 - 90 %	9
ISRIC Report 2019/01	BareSoilAbundance	90 - 100 %	10
ISRIC Report 2019/01	ForestAbundance	0 - 10 %	1
ISRIC Report 2019/01	ForestAbundance	10 - 20 %	2
ISRIC Report 2019/01	ForestAbundance	20 - 30 %	3
ISRIC Report 2019/01	ForestAbundance	30 - 40 %	4
ISRIC Report 2019/01	ForestAbundance	40 - 50 %	5
ISRIC Report 2019/01	ForestAbundance	50 - 60 %	6
ISRIC Report 2019/01	ForestAbundance	60 - 70 %	7
ISRIC Report 2019/01	ForestAbundance	70 - 80 %	8
ISRIC Report 2019/01	ForestAbundance	80 - 90 %	9
ISRIC Report 2019/01	ForestAbundance	90 - 100 %	10
ISRIC Report 2019/01	GrassAbundance	0 - 10 %	1
ISRIC Report 2019/01	GrassAbundance	10 - 20 %	2
ISRIC Report 2019/01	GrassAbundance	20 - 30 %	3
ISRIC Report 2019/01	GrassAbundance	30 - 40 %	4
ISRIC Report 2019/01	GrassAbundance	40 - 50 %	5
ISRIC Report 2019/01	GrassAbundance	50 - 60 %	6
ISRIC Report 2019/01	GrassAbundance	60 - 70 %	7
ISRIC Report 2019/01	GrassAbundance	70 - 80 %	8
ISRIC Report 2019/01	GrassAbundance	80 - 90 %	9
ISRIC Report 2019/01	GrassAbundance	90 - 100 %	10
ISRIC Report 2019/01	PavedAbundance	0 - 10 %	1
ISRIC Report 2019/01	PavedAbundance	10 - 20 %	2
ISRIC Report 2019/01	PavedAbundance	20 - 30 %	3
ISRIC Report 2019/01	PavedAbundance	30 - 40 %	4
ISRIC Report 2019/01	PavedAbundance	40 - 50 %	5
ISRIC Report 2019/01	PavedAbundance	50 - 60 %	6
ISRIC Report 2019/01	PavedAbundance	60 - 70 %	7
ISRIC Report 2019/01	PavedAbundance	70 - 80 %	8
ISRIC Report 2019/01	PavedAbundance	80 - 90 %	9
ISRIC Report 2019/01	PavedAbundance	90 - 100 %	10
ISRIC Report 2019/01	ShrubAbundace	0 - 10 %	1
ISRIC Report 2019/01	ShrubAbundace	10 - 20 %	2
ISRIC Report 2019/01	ShrubAbundace	20 - 30 %	3
ISRIC Report 2019/01	ShrubAbundace	30 - 40 %	4
ISRIC Report 2019/01	ShrubAbundace	40 - 50 %	5
ISRIC Report 2019/01	ShrubAbundace	50 - 60 %	6
ISRIC Report 2019/01	ShrubAbundace	60 - 70 %	7
ISRIC Report 2019/01	ShrubAbundace	70 - 80 %	8
ISRIC Report 2019/01	ShrubAbundace	80 - 90 %	9
ISRIC Report 2019/01	ShrubAbundace	90 - 100 %	10
ISRIC Report 2019/01	TreeDensity	0 - 10 %	1
ISRIC Report 2019/01	TreeDensity	10 - 20 %	2
ISRIC Report 2019/01	TreeDensity	20 - 30 %	3
ISRIC Report 2019/01	TreeDensity	30 - 40 %	4
ISRIC Report 2019/01	TreeDensity	40 - 50 %	5
ISRIC Report 2019/01	TreeDensity	50 - 60 %	6
ISRIC Report 2019/01	TreeDensity	60 - 70 %	7
ISRIC Report 2019/01	TreeDensity	70 - 80 %	8
ISRIC Report 2019/01	TreeDensity	80 - 90 %	9
ISRIC Report 2019/01	TreeDensity	90 - 100 %	10
Köppen-Geiger Climate Classification	KoeppenClass	Af - Tropical rainforest - moist	2
Köppen-Geiger Climate Classification	KoeppenClass	Am - Tropical rainforest short dry season	3
Köppen-Geiger Climate Classification	KoeppenClass	As - Tropical savanna	4
Köppen-Geiger Climate Classification	KoeppenClass	A - Tropical (rainy) climates	1
Köppen-Geiger Climate Classification	KoeppenClass	Aw - Tropical savanna	5
Köppen-Geiger Climate Classification	KoeppenClass	B - Dry	6
Köppen-Geiger Climate Classification	KoeppenClass	BSh - Steppe climate Dry-hot	8
Köppen-Geiger Climate Classification	KoeppenClass	BSk - Steppe climate Dry-cold	9
Köppen-Geiger Climate Classification	KoeppenClass	BS -  Steppe climate	7
Köppen-Geiger Climate Classification	KoeppenClass	BWh - Desert climate Dry-hot	10
Köppen-Geiger Climate Classification	KoeppenClass	BWk - Desert climate Dry-cold	11
Köppen-Geiger Climate Classification	KoeppenClass	BWn - Desert climate -frequent fog	12
Köppen-Geiger Climate Classification	KoeppenClass	Caf - Temperate rainy (humid mesothermal) climate - moist	15
Köppen-Geiger Climate Classification	KoeppenClass	Ca - Temperate rainy (humid mesothermal) climate	14
Köppen-Geiger Climate Classification	KoeppenClass	Caw - Temperate rainy (humid mesothermal) climate - dry winter	16
Köppen-Geiger Climate Classification	KoeppenClass	Cbf - Warm temperate (mesothermal) climates - moist	18
Köppen-Geiger Climate Classification	KoeppenClass	Cb - Warm temperate (mesothermal) climates	17
Köppen-Geiger Climate Classification	KoeppenClass	Cbw - Warm temperate (mesothermal) climates - dry winter	19
Köppen-Geiger Climate Classification	KoeppenClass	Ccf - Warm temperate (mesothermal) climates - moist	21
Köppen-Geiger Climate Classification	KoeppenClass	Cc - Warm temperate (mesothermal) climates	20
Köppen-Geiger Climate Classification	KoeppenClass	Ccw - Warm temperate (mesothermal) climates - dry winter	22
Köppen-Geiger Climate Classification	KoeppenClass	Cfa - Warm temperate - moist all seasons, hot summer	24
Köppen-Geiger Climate Classification	KoeppenClass	Cfb - Warm temperate - moist all seasons, warm summer	25
Köppen-Geiger Climate Classification	KoeppenClass	Cfc - Warm temperate - moist all seasons,  with cool short summer	26
Köppen-Geiger Climate Classification	KoeppenClass	Cf - Mild temperate rainy climate - no distinct dry season	23
Köppen-Geiger Climate Classification	KoeppenClass	Csa - Temperate rainy (humid mesothermal) climate with dry summer With hot summer	29
Köppen-Geiger Climate Classification	KoeppenClass	Csb - Temperate rainy (humid mesothermal) climate with dry summer With warm summer	30
Köppen-Geiger Climate Classification	KoeppenClass	Csc - Warm Temperate - dry summer, cool short summer	31
Köppen-Geiger Climate Classification	KoeppenClass	Cs - Temperate rainy (humid mesothermal) climate with dry summer	27
Köppen-Geiger Climate Classification	KoeppenClass	CS - Warm temperate rainy climate - summer dry	28
Köppen-Geiger Climate Classification	KoeppenClass	C - Warm temperate (mesothermal) climates	13
Köppen-Geiger Climate Classification	KoeppenClass	Cwa - Warm temperate - dry winter, hot summer	33
Köppen-Geiger Climate Classification	KoeppenClass	Cwb - Warm Temperate - dry winter, warm summer	34
Köppen-Geiger Climate Classification	KoeppenClass	Cwc - Warm Temperate - dry winter, cool short summer	35
Köppen-Geiger Climate Classification	KoeppenClass	Cw - Mild temperate rainy climate - winter dry	32
Köppen-Geiger Climate Classification	KoeppenClass	Da - Cool-humid continental climate with warm high-sun season	37
Köppen-Geiger Climate Classification	KoeppenClass	Daf - Cool-humid continental climate with warm high-sun season - moist	38
Köppen-Geiger Climate Classification	KoeppenClass	Das - Cool-humid continental climate with warm high-sun season - dry season in summer	39
Köppen-Geiger Climate Classification	KoeppenClass	Daw - Cool-humid continental climate with warm high-sun season - dry winter	40
Köppen-Geiger Climate Classification	KoeppenClass	Db - Cool-humid continental  with cool high-sun season	41
Köppen-Geiger Climate Classification	KoeppenClass	Dbf - Cool-humid continental  with cool high-sun season - moist	42
Köppen-Geiger Climate Classification	KoeppenClass	Dbs - Cool-humid continental  with cool high-sun season - dry season in summer	43
Köppen-Geiger Climate Classification	KoeppenClass	Dbw - Cool-humid continental  with cool high-sun season - dry winter	44
Köppen-Geiger Climate Classification	KoeppenClass	Dcf - Subarctic climate - moist	46
Köppen-Geiger Climate Classification	KoeppenClass	Dcs - Subarctic climate - dry season in summer	47
Köppen-Geiger Climate Classification	KoeppenClass	Dc - Subarctic climate	45
Köppen-Geiger Climate Classification	KoeppenClass	Dcw - Subarctic climate - dry winter	48
Köppen-Geiger Climate Classification	KoeppenClass	Ddf - Subarctic with very cold low-sun season - moist	50
Köppen-Geiger Climate Classification	KoeppenClass	Dds - Subarctic with very cold low-sun season - dry season in summer	51
Köppen-Geiger Climate Classification	KoeppenClass	Dd - Subarctic with very cold low-sun season	49
Köppen-Geiger Climate Classification	KoeppenClass	Ddw - Subarctic with very cold low-sun season - dry winter	52
Köppen-Geiger Climate Classification	KoeppenClass	Dfa - Snow climates - moist all seasons, hot summer	54
Köppen-Geiger Climate Classification	KoeppenClass	Dfb - Snow climates - moist all seasons, warm summer	55
Köppen-Geiger Climate Classification	KoeppenClass	Df - Cold snow-forest climate - humid winters	53
Köppen-Geiger Climate Classification	KoeppenClass	Dfc - Snow climates - moist all seasons, cool short summer	56
Köppen-Geiger Climate Classification	KoeppenClass	Dfd - Snow climates - moist all seasons, very cold winter	57
Köppen-Geiger Climate Classification	KoeppenClass	Dsa - Snow climates - dry summer, hot	59
Köppen-Geiger Climate Classification	KoeppenClass	Dsb - Snow climates - dry summer, warm	60
Köppen-Geiger Climate Classification	KoeppenClass	Ds - Cold snow-forest climate - summer dry	58
Köppen-Geiger Climate Classification	KoeppenClass	Dsc - Snow climates - dry summer,  cool short summer	61
Köppen-Geiger Climate Classification	KoeppenClass	Dsd - Snow climates  -dry summer,  very cold winter	62
Köppen-Geiger Climate Classification	KoeppenClass	D - Snow (microthermal) climates	36
Köppen-Geiger Climate Classification	KoeppenClass	Dwa - Snow climates - dry winter, hot summer	63
Köppen-Geiger Climate Classification	KoeppenClass	Dwb - Snow climates - dry winter, warm summer	64
Köppen-Geiger Climate Classification	KoeppenClass	Dwc - Snow climates - dry winter, cool short summer	65
Köppen-Geiger Climate Classification	KoeppenClass	Dwd - Snow climates - dry winter, very cold winter	66
Köppen-Geiger Climate Classification	KoeppenClass	EF - Climates of perpetual frost (ice-caps)	68
Köppen-Geiger Climate Classification	KoeppenClass	E - Ice climates	67
Köppen-Geiger Climate Classification	KoeppenClass	ET - Tundra climate	69
Köppen-Geiger Climate Classification	KoeppenClass	H - Mountain/Highland climates	70
WRB fourth edition 2022	PresenceOfWater	FF - Submerged by remote flowing inland water at least once a year	5
WRB fourth edition 2022	PresenceOfWater	FO - Submerged by remote flowing inland water less than once a year	6
WRB fourth edition 2022	PresenceOfWater	FP - Permanently submerged by inland water	4
WRB fourth edition 2022	PresenceOfWater	GF - Submerged by rising local groundwater at least once a year	7
WRB fourth edition 2022	PresenceOfWater	GO - Submerged by rising local groundwater less than once a year	8
WRB fourth edition 2022	PresenceOfWater	MO - Occasional storm surges (above mean high water springs)	3
WRB fourth edition 2022	PresenceOfWater	MP - Permanently submerged by seawater (below mean low water springs)	1
WRB fourth edition 2022	PresenceOfWater	MT - Tidal area (between mean low and mean high water springs)	2
WRB fourth edition 2022	PresenceOfWater	NO - None of the above	13
WRB fourth edition 2022	PresenceOfWater	RF - Submerged by local rainwater at least once a year	9
WRB fourth edition 2022	PresenceOfWater	RO - Submerged by local rainwater less than once a year	10
WRB fourth edition 2022	PresenceOfWater	UF - Submerged by inland water of unknown origin at least once a year	11
WRB fourth edition 2022	PresenceOfWater	UO - Submerged by inland water of unknown origin less than once a year	12
\.


--
-- TOC entry 4963 (class 0 OID 54922803)
-- Dependencies: 226
-- Data for Name: observation_desc_profile; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.observation_desc_profile (procedure_desc_id, property_desc_id, category_desc_id, category_order) FROM stdin;
FAO GfSD 1990	soilPhase	AN - Anthraquic	1
FAO GfSD 1990	soilPhase	FR - Fragipan	3
FAO GfSD 1990	soilPhase	GE - Gelundic	4
FAO GfSD 1990	soilPhase	GI - Gilgai	5
FAO GfSD 1990	soilPhase	IN - Inundic	6
FAO GfSD 1990	soilPhase	LI - Lithic	7
FAO GfSD 1990	soilPhase	MQ - Duripan	2
FAO GfSD 1990	soilPhase	PF - Petroferric	8
FAO GfSD 1990	soilPhase	PH - Phreatic	9
FAO GfSD 1990	soilPhase	PL - Placic	10
FAO GfSD 1990	soilPhase	RU - Rudic	11
FAO GfSD 1990	soilPhase	SA - Salic	12
FAO GfSD 1990	soilPhase	SK - Skeletic	13
FAO GfSD 1990	soilPhase	SO - Sodic	14
FAO GfSD 1990	soilPhase	TK - Takyric	15
FAO GfSD 1990	soilPhase	YR - Yermic	16
FAO GfSD 2006	EffectiveSoilDepth	Deep (100-150 cm)	4
FAO GfSD 2006	EffectiveSoilDepth	Moderately deep (50-100 cm)	3
FAO GfSD 2006	EffectiveSoilDepth	Shallow (30-50 cm)	2
FAO GfSD 2006	EffectiveSoilDepth	Very deep (> 150 cm)	5
FAO GfSD 2006	EffectiveSoilDepth	Very shallow (< 30 cm)	1
FAO GfSD 2006	SoilDepthtoBedrock	Deep (100-150 cm)	4
FAO GfSD 2006	SoilDepthtoBedrock	Moderately deep (50-100 cm)	3
FAO GfSD 2006	SoilDepthtoBedrock	Shallow (30-50 cm)	2
FAO GfSD 2006	SoilDepthtoBedrock	Very deep (> 150 cm)	5
FAO GfSD 2006	SoilDepthtoBedrock	Very shallow (< 30 cm)	1
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Abruptic	1
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Acr	2
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Aeric	3
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Al, Alic	4
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Alb	5
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Anhy	6
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Anionic	7
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Anthr	8
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Anthraquic	10
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Aqu	9
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Ar	11
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Arenic	12
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Arg	13
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Calci, Calc	14
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Camb	15
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Chromic	16
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Cry	18
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Cumulic	17
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Dur	19
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Durinodic	20
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Dystr, Dys	21
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Endo	22
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Epi	23
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Eutr, Eutric	24
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Ferr	25
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Fibr	26
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Fluv	27
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Fol	28
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Fragi, Fragic	29
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Fragloss	30
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Fulv	31
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Glac, Glacic	32
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Gloss, Glossic	33
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Grossarenic	34
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Gyps, Gypsic	35
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Hal, Halic	36
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Hapl	37
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Hem	38
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Hist	39
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Hum, Humic	40
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Hydr, Hydric	41
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Kan, Kandic	42
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Lamellic	43
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Leptic	44
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Limnic	45
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Lithic	46
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Luv	47
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Melan	48
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Moll	49
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Natr, Natric	50
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Nitric	51
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Ombroaquic	52
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Orth	53
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Oxyaquic	54
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Pachic	55
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Pale	56
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Per	57
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Petr	58
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Petrocalcic	59
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Petroferric	60
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Petrogypsic	61
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Petronodic	62
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Plac, Placic	63
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Plagg	64
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Plinth, Plinthic	65
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Psamm	66
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Quartz	67
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Rend	68
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Rhod, Rhodic	69
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Ruptic	70
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Sal	71
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Sapr	72
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Sodic	73
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Somb, Sombric	74
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Sphagn	75
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Sulf, Sulfic	76
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Terric	77
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Thapto(ic)	78
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Torr	79
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Turb	80
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Ud	81
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Umbr, Umbric	82
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Ust	83
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Verm	84
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Vitr	85
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Xanthic	86
Keys to Soil Taxonomy 13th edition 2022	formativeElementUSDA	Xer	87
Keys to Soil Taxonomy 13th edition 2022	soilOrderUSDA	Alfisols	1
Keys to Soil Taxonomy 13th edition 2022	soilOrderUSDA	Andisols	2
Keys to Soil Taxonomy 13th edition 2022	soilOrderUSDA	Aridisols	3
Keys to Soil Taxonomy 13th edition 2022	soilOrderUSDA	Entisols	4
Keys to Soil Taxonomy 13th edition 2022	soilOrderUSDA	Gelisols	5
Keys to Soil Taxonomy 13th edition 2022	soilOrderUSDA	Histosols	6
Keys to Soil Taxonomy 13th edition 2022	soilOrderUSDA	Inceptisols	7
Keys to Soil Taxonomy 13th edition 2022	soilOrderUSDA	Mollisols	8
Keys to Soil Taxonomy 13th edition 2022	soilOrderUSDA	Oxisols	9
Keys to Soil Taxonomy 13th edition 2022	soilOrderUSDA	Spodosols	10
Keys to Soil Taxonomy 13th edition 2022	soilOrderUSDA	Ultisols	11
Keys to Soil Taxonomy 13th edition 2022	soilOrderUSDA	Vertisols	12
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Albolls	1
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Aqualfs	2
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Aquands	3
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Aquents	4
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Aquepts	5
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Aquerts	6
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Aquods	7
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Aquolls	8
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Aquox	9
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Aquults	10
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Arents	11
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Argids	12
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Calcids	13
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Cambids	14
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Cryalfs	15
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Cryands	16
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Cryepts	17
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Cryerts	18
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Cryids	19
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Cryods	20
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Cryolls	21
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Durids	22
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Fibrists	23
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Fluvents	24
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Folists	25
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Gelands	26
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Gelepts	27
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Gelods	28
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Gypsids	29
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Hemists	30
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Histels	31
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Humods	32
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Humults	33
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Orthels	34
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Orthents	35
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Orthods	36
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Psamments	37
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Rendolls	38
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Salids	39
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Saprists	40
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Torrands	41
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Torrox	42
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Turbels	43
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Udalfs	44
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Udands	45
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Udepts	46
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Uderts	47
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Udolls	48
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Udox	49
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Udults	50
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Ustalfs	51
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Ustands	52
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Ustepts	53
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Usterts	54
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Ustolls	55
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Ustox	56
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Ustults	57
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Vitrands	58
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Xeralfs	59
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Xerands	60
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Xerepts	61
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Xererts	62
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Xerolls	63
Keys to Soil Taxonomy 13th edition 2022	soilSuborderUSDA	Xerults	64
WRB fourth edition 2022	descriptionStatus	1.1 - Reference profile description - without sampling: No essential elements or details are missing from the description, sampling or analysis. The accuracy and reliability of the description and analytical results permit the full characterization of all soil horizons to a depth of 125 cm, or more if required for classification, or down to a C or R horizon or layer, which may be shallower. Soil description is done without sampling.	8
WRB fourth edition 2022	descriptionStatus	1 - Reference profile description: No essential elements or details are missing from the description, sampling or analysis. The accuracy and reliability of the description and analytical results permit the full characterization of all soil horizons to a depth of 125 cm, or more if required for classification, or down to a C or R horizon or layer, which may be shallower.	1
WRB fourth edition 2022	descriptionStatus	2.1 - Routine profile description - without sampling: No essential elements are missing from the description, sampling or analysis. The number of samples collected is sufficient to characterize all major soil horizons, but may not allow precise definition of all subhorizons, especially in the deeper soil. The profile depth is 80 cm or more, or down to a C or R horizon or layer, which may be shallower. Additional augering and sampling may be required for lower level classification. Soil description is done without sampling.	9
WRB fourth edition 2022	descriptionStatus	2 - Routine profile description: No essential elements are missing from the description, sampling or analysis. The number of samples collected is sufficient to characterize all major soil horizons, but may not allow precise definition of all subhorizons, especially in the deeper soil. The profile depth is 80 cm or more, or down to a C or R horizon or layer, which may be shallower. Additional augering and sampling may be required for lower level classification.	2
WRB fourth edition 2022	descriptionStatus	3.1 - Incomplete description - without sampling: Certain relevant elements are missing from the description, an insufficient number of samples was collected, or the reliability of the analytical data does not permit a complete characterization of the soil. However, the description is useful for specific purposes and provides a satisfactory indication of the nature of the soil at high levels of soil taxonomic classification. Soil description is done without sampling.	7
WRB fourth edition 2022	descriptionStatus	3 - Incomplete description: Certain relevant elements are missing from the description, an insufficient number of samples was collected, or the reliability of the analytical data does not permit a complete characterization of the soil. However, the description is useful for specific purposes and provides a satisfactory indication of the nature of the soil at high levels of soil taxonomic classification.	3
WRB fourth edition 2022	descriptionStatus	4.1 - Soil augering description - without sampling: Soil augerings do no permit a comprehensive soil profile description. Augerings are made for routine soil observation and identification in soil mapping, and for that purpose normally provide a satisfactory indication of the soil characteristics. Soil samples may be collected from augerings. Soil description is done without sampling.	6
WRB fourth edition 2022	descriptionStatus	4 - Soil augering description: Soil augerings do no permit a comprehensive soil profile description. Augerings are made for routine soil observation and identification in soil mapping, and for that purpose normally provide a satisfactory indication of the soil characteristics. Soil samples may be collected from augerings.	4
WRB fourth edition 2022	descriptionStatus	5 - Other descriptions: Essential elements are missing from the description, preventing a satisfactory soil characterization and classification.	5
WRB fourth edition 2022	soilClassificationWRB	Abruptic Acrisol	1
WRB fourth edition 2022	soilClassificationWRB	Abruptic Alisol	20
WRB fourth edition 2022	soilClassificationWRB	Abruptic Lixisol	339
WRB fourth edition 2022	soilClassificationWRB	Abruptic Luvisol	363
WRB fourth edition 2022	soilClassificationWRB	Abruptic Retisol	527
WRB fourth edition 2022	soilClassificationWRB	Abruptic Solonetz	562
WRB fourth edition 2022	soilClassificationWRB	Acric Durisol	177
WRB fourth edition 2022	soilClassificationWRB	Acric Ferralsol	204
WRB fourth edition 2022	soilClassificationWRB	Acric Nitisol	402
WRB fourth edition 2022	soilClassificationWRB	Acric Planosol	459
WRB fourth edition 2022	soilClassificationWRB	Acric Podzol	503
WRB fourth edition 2022	soilClassificationWRB	Acric Stagnosol	596
WRB fourth edition 2022	soilClassificationWRB	Acric Umbrisol	636
WRB fourth edition 2022	soilClassificationWRB	Aeolic Andosol	56
WRB fourth edition 2022	soilClassificationWRB	Aeolic Arenosol	72
WRB fourth edition 2022	soilClassificationWRB	Aeolic Regosol	510
WRB fourth edition 2022	soilClassificationWRB	Albic Acrisol	16
WRB fourth edition 2022	soilClassificationWRB	Albic Alisol	35
WRB fourth edition 2022	soilClassificationWRB	Albic Lixisol	355
WRB fourth edition 2022	soilClassificationWRB	Albic Luvisol	379
WRB fourth edition 2022	soilClassificationWRB	Albic Planosol	454
WRB fourth edition 2022	soilClassificationWRB	Albic Plinthosol	479
WRB fourth edition 2022	soilClassificationWRB	Albic Podzol	487
WRB fourth edition 2022	soilClassificationWRB	Albic Retisol	541
WRB fourth edition 2022	soilClassificationWRB	Albic Solonetz	574
WRB fourth edition 2022	soilClassificationWRB	Albic Stagnosol	591
WRB fourth edition 2022	soilClassificationWRB	Alic Cryosol	161
WRB fourth edition 2022	soilClassificationWRB	Alic Durisol	179
WRB fourth edition 2022	soilClassificationWRB	Alic Nitisol	404
WRB fourth edition 2022	soilClassificationWRB	Alic Planosol	461
WRB fourth edition 2022	soilClassificationWRB	Alic Podzol	504
WRB fourth edition 2022	soilClassificationWRB	Alic Stagnosol	598
WRB fourth edition 2022	soilClassificationWRB	Alic Umbrisol	638
WRB fourth edition 2022	soilClassificationWRB	Aluandic Andosol	39
WRB fourth edition 2022	soilClassificationWRB	Andic Anthrosol	70
WRB fourth edition 2022	soilClassificationWRB	Andic Cambisol	112
WRB fourth edition 2022	soilClassificationWRB	Andic Cryosol	154
WRB fourth edition 2022	soilClassificationWRB	Andic Durisol	187
WRB fourth edition 2022	soilClassificationWRB	Andic Gleysol	238
WRB fourth edition 2022	soilClassificationWRB	Andic Histosol	295
WRB fourth edition 2022	soilClassificationWRB	Andic Leptosol	323
WRB fourth edition 2022	soilClassificationWRB	Andic Podzol	496
WRB fourth edition 2022	soilClassificationWRB	Andic Technosol	619
WRB fourth edition 2022	soilClassificationWRB	Anofluvic Fluvisol	210
WRB fourth edition 2022	soilClassificationWRB	Anthraquic Acrisol	5
WRB fourth edition 2022	soilClassificationWRB	Anthraquic Alisol	24
WRB fourth edition 2022	soilClassificationWRB	Anthraquic Andosol	44
WRB fourth edition 2022	soilClassificationWRB	Anthraquic Cambisol	105
WRB fourth edition 2022	soilClassificationWRB	Anthraquic Gleysol	231
WRB fourth edition 2022	soilClassificationWRB	Anthraquic Lixisol	344
WRB fourth edition 2022	soilClassificationWRB	Anthraquic Luvisol	368
WRB fourth edition 2022	soilClassificationWRB	Anthraquic Nitisol	397
WRB fourth edition 2022	soilClassificationWRB	Anthraquic Planosol	443
WRB fourth edition 2022	soilClassificationWRB	Anthraquic Stagnosol	580
WRB fourth edition 2022	soilClassificationWRB	Anthraquic Vertisol	656
WRB fourth edition 2022	soilClassificationWRB	Anthromollic Podzol	499
WRB fourth edition 2022	soilClassificationWRB	Brunic Arenosol	76
WRB fourth edition 2022	soilClassificationWRB	Brunic Kastanozem	312
WRB fourth edition 2022	soilClassificationWRB	Brunic Leptosol	330
WRB fourth edition 2022	soilClassificationWRB	Brunic Phaeozem	431
WRB fourth edition 2022	soilClassificationWRB	Brunic Regosol	512
WRB fourth edition 2022	soilClassificationWRB	Brunic Umbrisol	641
WRB fourth edition 2022	soilClassificationWRB	Calcaric Arenosol	85
WRB fourth edition 2022	soilClassificationWRB	Calcaric Cambisol	128
WRB fourth edition 2022	soilClassificationWRB	Calcaric Durisol	189
WRB fourth edition 2022	soilClassificationWRB	Calcaric Fluvisol	223
WRB fourth edition 2022	soilClassificationWRB	Calcaric Gleysol	256
WRB fourth edition 2022	soilClassificationWRB	Calcaric Gypsisol	273
WRB fourth edition 2022	soilClassificationWRB	Calcaric Leptosol	336
WRB fourth edition 2022	soilClassificationWRB	Calcaric Luvisol	387
WRB fourth edition 2022	soilClassificationWRB	Calcaric Phaeozem	437
WRB fourth edition 2022	soilClassificationWRB	Calcaric Planosol	467
WRB fourth edition 2022	soilClassificationWRB	Calcaric Regosol	524
WRB fourth edition 2022	soilClassificationWRB	Calcaric Stagnosol	602
WRB fourth edition 2022	soilClassificationWRB	Calcic Andosol	54
WRB fourth edition 2022	soilClassificationWRB	Calcic Chernozem	140
WRB fourth edition 2022	soilClassificationWRB	Calcic Cryosol	163
WRB fourth edition 2022	soilClassificationWRB	Calcic Durisol	175
WRB fourth edition 2022	soilClassificationWRB	Calcic Gleysol	250
WRB fourth edition 2022	soilClassificationWRB	Calcic Gypsisol	261
WRB fourth edition 2022	soilClassificationWRB	Calcic Kastanozem	310
WRB fourth edition 2022	soilClassificationWRB	Calcic Leptosol	328
WRB fourth edition 2022	soilClassificationWRB	Calcic Lixisol	358
WRB fourth edition 2022	soilClassificationWRB	Calcic Luvisol	382
WRB fourth edition 2022	soilClassificationWRB	Calcic Planosol	465
WRB fourth edition 2022	soilClassificationWRB	Calcic Retisol	542
WRB fourth edition 2022	soilClassificationWRB	Calcic Solonchak	555
WRB fourth edition 2022	soilClassificationWRB	Calcic Solonetz	569
WRB fourth edition 2022	soilClassificationWRB	Calcic Stagnosol	600
WRB fourth edition 2022	soilClassificationWRB	Calcic Vertisol	654
WRB fourth edition 2022	soilClassificationWRB	Cambic Calcisol	94
WRB fourth edition 2022	soilClassificationWRB	Cambic Chernozem	141
WRB fourth edition 2022	soilClassificationWRB	Cambic Cryosol	167
WRB fourth edition 2022	soilClassificationWRB	Cambic Durisol	181
WRB fourth edition 2022	soilClassificationWRB	Cambic Gypsisol	267
WRB fourth edition 2022	soilClassificationWRB	Cambic Kastanozem	311
WRB fourth edition 2022	soilClassificationWRB	Cambic Leptosol	329
WRB fourth edition 2022	soilClassificationWRB	Cambic Phaeozem	430
WRB fourth edition 2022	soilClassificationWRB	Cambic Umbrisol	640
WRB fourth edition 2022	soilClassificationWRB	Carbic Podzol	485
WRB fourth edition 2022	soilClassificationWRB	Chernic Andosol	48
WRB fourth edition 2022	soilClassificationWRB	Chernic Gleysol	240
WRB fourth edition 2022	soilClassificationWRB	Chernic Phaeozem	409
WRB fourth edition 2022	soilClassificationWRB	Chernic Planosol	451
WRB fourth edition 2022	soilClassificationWRB	Chernic Stagnosol	588
WRB fourth edition 2022	soilClassificationWRB	Chernic Umbrisol	624
WRB fourth edition 2022	soilClassificationWRB	Chromic Acrisol	12
WRB fourth edition 2022	soilClassificationWRB	Chromic Alisol	32
WRB fourth edition 2022	soilClassificationWRB	Chromic Cambisol	122
WRB fourth edition 2022	soilClassificationWRB	Chromic Lixisol	351
WRB fourth edition 2022	soilClassificationWRB	Chromic Luvisol	376
WRB fourth edition 2022	soilClassificationWRB	Chromic Vertisol	659
WRB fourth edition 2022	soilClassificationWRB	Coarsic Calcisol	95
WRB fourth edition 2022	soilClassificationWRB	Coarsic Cryosol	168
WRB fourth edition 2022	soilClassificationWRB	Coarsic Durisol	182
WRB fourth edition 2022	soilClassificationWRB	Coarsic Gypsisol	268
WRB fourth edition 2022	soilClassificationWRB	Coarsic Histosol	293
WRB fourth edition 2022	soilClassificationWRB	Coarsic Leptosol	318
WRB fourth edition 2022	soilClassificationWRB	Coarsic Plinthosol	481
WRB fourth edition 2022	soilClassificationWRB	Coarsic Podzol	505
WRB fourth edition 2022	soilClassificationWRB	Coarsic Technosol	616
WRB fourth edition 2022	soilClassificationWRB	Cryic Histosol	278
WRB fourth edition 2022	soilClassificationWRB	Cryic Technosol	610
WRB fourth edition 2022	soilClassificationWRB	Dolomitic Arenosol	84
WRB fourth edition 2022	soilClassificationWRB	Dolomitic Cambisol	127
WRB fourth edition 2022	soilClassificationWRB	Dolomitic Fluvisol	222
WRB fourth edition 2022	soilClassificationWRB	Dolomitic Gleysol	255
WRB fourth edition 2022	soilClassificationWRB	Dolomitic Leptosol	335
WRB fourth edition 2022	soilClassificationWRB	Dolomitic Luvisol	386
WRB fourth edition 2022	soilClassificationWRB	Dolomitic Phaeozem	436
WRB fourth edition 2022	soilClassificationWRB	Dolomitic Planosol	466
WRB fourth edition 2022	soilClassificationWRB	Dolomitic Regosol	523
WRB fourth edition 2022	soilClassificationWRB	Dolomitic Stagnosol	601
WRB fourth edition 2022	soilClassificationWRB	Drainic Histosol	290
WRB fourth edition 2022	soilClassificationWRB	Duric Andosol	52
WRB fourth edition 2022	soilClassificationWRB	Duric Chernozem	132
WRB fourth edition 2022	soilClassificationWRB	Duric Kastanozem	299
WRB fourth edition 2022	soilClassificationWRB	Duric Phaeozem	413
WRB fourth edition 2022	soilClassificationWRB	Duric Planosol	464
WRB fourth edition 2022	soilClassificationWRB	Duric Vertisol	651
WRB fourth edition 2022	soilClassificationWRB	Dystric Andosol	58
WRB fourth edition 2022	soilClassificationWRB	Dystric Arenosol	86
WRB fourth edition 2022	soilClassificationWRB	Dystric Cambisol	129
WRB fourth edition 2022	soilClassificationWRB	Dystric Durisol	190
WRB fourth edition 2022	soilClassificationWRB	Dystric Fluvisol	224
WRB fourth edition 2022	soilClassificationWRB	Dystric Gleysol	257
WRB fourth edition 2022	soilClassificationWRB	Dystric Leptosol	337
WRB fourth edition 2022	soilClassificationWRB	Dystric Nitisol	406
WRB fourth edition 2022	soilClassificationWRB	Dystric Planosol	468
WRB fourth edition 2022	soilClassificationWRB	Dystric Regosol	525
WRB fourth edition 2022	soilClassificationWRB	Dystric Retisol	546
WRB fourth edition 2022	soilClassificationWRB	Dystric Stagnosol	603
WRB fourth edition 2022	soilClassificationWRB	Ekranic Technosol	605
WRB fourth edition 2022	soilClassificationWRB	Endocalcaric Retisol	545
WRB fourth edition 2022	soilClassificationWRB	Endocalcaric Umbrisol	645
WRB fourth edition 2022	soilClassificationWRB	Endocalcic Phaeozem	415
WRB fourth edition 2022	soilClassificationWRB	Endodolomitic Retisol	544
WRB fourth edition 2022	soilClassificationWRB	Endodolomitic Umbrisol	644
WRB fourth edition 2022	soilClassificationWRB	Entic Podzol	488
WRB fourth edition 2022	soilClassificationWRB	Eutric Andosol	59
WRB fourth edition 2022	soilClassificationWRB	Eutric Arenosol	87
WRB fourth edition 2022	soilClassificationWRB	Eutric Cambisol	130
WRB fourth edition 2022	soilClassificationWRB	Eutric Durisol	191
WRB fourth edition 2022	soilClassificationWRB	Eutric Fluvisol	225
WRB fourth edition 2022	soilClassificationWRB	Eutric Gleysol	258
WRB fourth edition 2022	soilClassificationWRB	Eutric Leptosol	338
WRB fourth edition 2022	soilClassificationWRB	Eutric Nitisol	407
WRB fourth edition 2022	soilClassificationWRB	Eutric Planosol	469
WRB fourth edition 2022	soilClassificationWRB	Eutric Regosol	526
WRB fourth edition 2022	soilClassificationWRB	Eutric Retisol	547
WRB fourth edition 2022	soilClassificationWRB	Eutric Stagnosol	604
WRB fourth edition 2022	soilClassificationWRB	Ferralic Acrisol	10
WRB fourth edition 2022	soilClassificationWRB	Ferralic Anthrosol	68
WRB fourth edition 2022	soilClassificationWRB	Ferralic Lixisol	349
WRB fourth edition 2022	soilClassificationWRB	Ferralic Nitisol	389
WRB fourth edition 2022	soilClassificationWRB	Ferric Acrisol	17
WRB fourth edition 2022	soilClassificationWRB	Ferric Alisol	36
WRB fourth edition 2022	soilClassificationWRB	Ferric Lixisol	356
WRB fourth edition 2022	soilClassificationWRB	Ferric Luvisol	380
WRB fourth edition 2022	soilClassificationWRB	Ferritic Ferralsol	192
WRB fourth edition 2022	soilClassificationWRB	Ferritic Nitisol	391
WRB fourth edition 2022	soilClassificationWRB	Fibric Histosol	284
WRB fourth edition 2022	soilClassificationWRB	Floatic Histosol	281
WRB fourth edition 2022	soilClassificationWRB	Fluvic Cambisol	119
WRB fourth edition 2022	soilClassificationWRB	Fluvic Gleysol	253
WRB fourth edition 2022	soilClassificationWRB	Fluvic Kastanozem	307
WRB fourth edition 2022	soilClassificationWRB	Fluvic Phaeozem	423
WRB fourth edition 2022	soilClassificationWRB	Fluvic Planosol	455
WRB fourth edition 2022	soilClassificationWRB	Fluvic Solonchak	558
WRB fourth edition 2022	soilClassificationWRB	Fluvic Stagnosol	592
WRB fourth edition 2022	soilClassificationWRB	Fluvic Umbrisol	632
WRB fourth edition 2022	soilClassificationWRB	Folic Histosol	280
WRB fourth edition 2022	soilClassificationWRB	Folic Leptosol	333
WRB fourth edition 2022	soilClassificationWRB	Fractic Calcisol	96
WRB fourth edition 2022	soilClassificationWRB	Fractic Durisol	183
WRB fourth edition 2022	soilClassificationWRB	Fractic Gypsisol	269
WRB fourth edition 2022	soilClassificationWRB	Fragic Acrisol	2
WRB fourth edition 2022	soilClassificationWRB	Fragic Alisol	21
WRB fourth edition 2022	soilClassificationWRB	Fragic Cambisol	102
WRB fourth edition 2022	soilClassificationWRB	Fragic Lixisol	340
WRB fourth edition 2022	soilClassificationWRB	Fragic Luvisol	364
WRB fourth edition 2022	soilClassificationWRB	Fragic Retisol	528
WRB fourth edition 2022	soilClassificationWRB	Fragic Umbrisol	628
WRB fourth edition 2022	soilClassificationWRB	Garbic Technosol	609
WRB fourth edition 2022	soilClassificationWRB	Geric Ferralsol	196
WRB fourth edition 2022	soilClassificationWRB	Geric Nitisol	395
WRB fourth edition 2022	soilClassificationWRB	Geric Plinthosol	474
WRB fourth edition 2022	soilClassificationWRB	Gibbsic Ferralsol	193
WRB fourth edition 2022	soilClassificationWRB	Gibbsic Plinthosol	472
WRB fourth edition 2022	soilClassificationWRB	Glacic Cryosol	146
WRB fourth edition 2022	soilClassificationWRB	Gleyic Acrisol	8
WRB fourth edition 2022	soilClassificationWRB	Gleyic Alisol	28
WRB fourth edition 2022	soilClassificationWRB	Gleyic Andosol	45
WRB fourth edition 2022	soilClassificationWRB	Gleyic Anthrosol	66
WRB fourth edition 2022	soilClassificationWRB	Gleyic Arenosol	77
WRB fourth edition 2022	soilClassificationWRB	Gleyic Calcisol	90
WRB fourth edition 2022	soilClassificationWRB	Gleyic Cambisol	116
WRB fourth edition 2022	soilClassificationWRB	Gleyic Chernozem	136
WRB fourth edition 2022	soilClassificationWRB	Gleyic Ferralsol	199
WRB fourth edition 2022	soilClassificationWRB	Gleyic Fluvisol	214
WRB fourth edition 2022	soilClassificationWRB	Gleyic Gypsisol	263
WRB fourth edition 2022	soilClassificationWRB	Gleyic Kastanozem	306
WRB fourth edition 2022	soilClassificationWRB	Gleyic Lixisol	347
WRB fourth edition 2022	soilClassificationWRB	Gleyic Luvisol	372
WRB fourth edition 2022	soilClassificationWRB	Gleyic Phaeozem	421
WRB fourth edition 2022	soilClassificationWRB	Gleyic Planosol	450
WRB fourth edition 2022	soilClassificationWRB	Gleyic Podzol	495
WRB fourth edition 2022	soilClassificationWRB	Gleyic Regosol	513
WRB fourth edition 2022	soilClassificationWRB	Gleyic Retisol	535
WRB fourth edition 2022	soilClassificationWRB	Gleyic Solonchak	549
WRB fourth edition 2022	soilClassificationWRB	Gleyic Solonetz	563
WRB fourth edition 2022	soilClassificationWRB	Gleyic Stagnosol	587
WRB fourth edition 2022	soilClassificationWRB	Gleyic Technosol	617
WRB fourth edition 2022	soilClassificationWRB	Gleyic Umbrisol	630
WRB fourth edition 2022	soilClassificationWRB	Glossic Phaeozem	426
WRB fourth edition 2022	soilClassificationWRB	Glossic Planosol	457
WRB fourth edition 2022	soilClassificationWRB	Glossic Podzol	501
WRB fourth edition 2022	soilClassificationWRB	Glossic Retisol	529
WRB fourth edition 2022	soilClassificationWRB	Glossic Stagnosol	594
WRB fourth edition 2022	soilClassificationWRB	Glossic Umbrisol	634
WRB fourth edition 2022	soilClassificationWRB	Greyzemic Chernozem	138
WRB fourth edition 2022	soilClassificationWRB	Greyzemic Phaeozem	425
WRB fourth edition 2022	soilClassificationWRB	Greyzemic Umbrisol	633
WRB fourth edition 2022	soilClassificationWRB	Gypsic Andosol	53
WRB fourth edition 2022	soilClassificationWRB	Gypsic Durisol	173
WRB fourth edition 2022	soilClassificationWRB	Gypsic Gleysol	249
WRB fourth edition 2022	soilClassificationWRB	Gypsic Kastanozem	301
WRB fourth edition 2022	soilClassificationWRB	Gypsic Leptosol	327
WRB fourth edition 2022	soilClassificationWRB	Gypsic Lixisol	357
WRB fourth edition 2022	soilClassificationWRB	Gypsic Luvisol	381
WRB fourth edition 2022	soilClassificationWRB	Gypsic Solonchak	553
WRB fourth edition 2022	soilClassificationWRB	Gypsic Solonetz	567
WRB fourth edition 2022	soilClassificationWRB	Gypsic Vertisol	652
WRB fourth edition 2022	soilClassificationWRB	Gypsiric Arenosol	83
WRB fourth edition 2022	soilClassificationWRB	Gypsiric Calcisol	100
WRB fourth edition 2022	soilClassificationWRB	Gypsiric Cambisol	126
WRB fourth edition 2022	soilClassificationWRB	Gypsiric Durisol	188
WRB fourth edition 2022	soilClassificationWRB	Gypsiric Fluvisol	221
WRB fourth edition 2022	soilClassificationWRB	Gypsiric Gleysol	254
WRB fourth edition 2022	soilClassificationWRB	Gypsiric Leptosol	334
WRB fourth edition 2022	soilClassificationWRB	Gypsiric Phaeozem	435
WRB fourth edition 2022	soilClassificationWRB	Gypsiric Regosol	522
WRB fourth edition 2022	soilClassificationWRB	Haplic Acrisol	19
WRB fourth edition 2022	soilClassificationWRB	Haplic Alisol	38
WRB fourth edition 2022	soilClassificationWRB	Haplic Calcisol	101
WRB fourth edition 2022	soilClassificationWRB	Haplic Chernozem	145
WRB fourth edition 2022	soilClassificationWRB	Haplic Cryosol	170
WRB fourth edition 2022	soilClassificationWRB	Haplic Ferralsol	207
WRB fourth edition 2022	soilClassificationWRB	Haplic Gypsisol	274
WRB fourth edition 2022	soilClassificationWRB	Haplic Kastanozem	315
WRB fourth edition 2022	soilClassificationWRB	Haplic Lixisol	362
WRB fourth edition 2022	soilClassificationWRB	Haplic Luvisol	388
WRB fourth edition 2022	soilClassificationWRB	Haplic Phaeozem	438
WRB fourth edition 2022	soilClassificationWRB	Haplic Plinthosol	483
WRB fourth edition 2022	soilClassificationWRB	Haplic Solonchak	561
WRB fourth edition 2022	soilClassificationWRB	Haplic Solonetz	575
WRB fourth edition 2022	soilClassificationWRB	Haplic Umbrisol	646
WRB fourth edition 2022	soilClassificationWRB	Haplic Vertisol	660
WRB fourth edition 2022	soilClassificationWRB	Hemic Histosol	285
WRB fourth edition 2022	soilClassificationWRB	Histic Andosol	47
WRB fourth edition 2022	soilClassificationWRB	Histic Cambisol	115
WRB fourth edition 2022	soilClassificationWRB	Histic Cryosol	153
WRB fourth edition 2022	soilClassificationWRB	Histic Fluvisol	213
WRB fourth edition 2022	soilClassificationWRB	Histic Gleysol	237
WRB fourth edition 2022	soilClassificationWRB	Histic Leptosol	322
WRB fourth edition 2022	soilClassificationWRB	Histic Planosol	449
WRB fourth edition 2022	soilClassificationWRB	Histic Plinthosol	476
WRB fourth edition 2022	soilClassificationWRB	Histic Podzol	494
WRB fourth edition 2022	soilClassificationWRB	Histic Retisol	534
WRB fourth edition 2022	soilClassificationWRB	Histic Stagnosol	586
WRB fourth edition 2022	soilClassificationWRB	Hortic Anthrosol	62
WRB fourth edition 2022	soilClassificationWRB	Hortic Chernozem	135
WRB fourth edition 2022	soilClassificationWRB	Hortic Gleysol	233
WRB fourth edition 2022	soilClassificationWRB	Hortic Kastanozem	304
WRB fourth edition 2022	soilClassificationWRB	Hortic Phaeozem	418
WRB fourth edition 2022	soilClassificationWRB	Hortic Planosol	445
WRB fourth edition 2022	soilClassificationWRB	Hortic Podzol	490
WRB fourth edition 2022	soilClassificationWRB	Hortic Stagnosol	582
WRB fourth edition 2022	soilClassificationWRB	Hortic Umbrisol	620
WRB fourth edition 2022	soilClassificationWRB	Hydragric Acrisol	4
WRB fourth edition 2022	soilClassificationWRB	Hydragric Alisol	23
WRB fourth edition 2022	soilClassificationWRB	Hydragric Andosol	43
WRB fourth edition 2022	soilClassificationWRB	Hydragric Anthrosol	60
WRB fourth edition 2022	soilClassificationWRB	Hydragric Cambisol	104
WRB fourth edition 2022	soilClassificationWRB	Hydragric Gleysol	230
WRB fourth edition 2022	soilClassificationWRB	Hydragric Lixisol	343
WRB fourth edition 2022	soilClassificationWRB	Hydragric Luvisol	367
WRB fourth edition 2022	soilClassificationWRB	Hydragric Nitisol	396
WRB fourth edition 2022	soilClassificationWRB	Hydragric Planosol	442
WRB fourth edition 2022	soilClassificationWRB	Hydragric Stagnosol	579
WRB fourth edition 2022	soilClassificationWRB	Hydragric Vertisol	655
WRB fourth edition 2022	soilClassificationWRB	Hydric Andosol	46
WRB fourth edition 2022	soilClassificationWRB	Irragric Anthrosol	61
WRB fourth edition 2022	soilClassificationWRB	Irragric Cambisol	106
WRB fourth edition 2022	soilClassificationWRB	Irragric Gleysol	232
WRB fourth edition 2022	soilClassificationWRB	Irragric Luvisol	369
WRB fourth edition 2022	soilClassificationWRB	Irragric Phaeozem	417
WRB fourth edition 2022	soilClassificationWRB	Irragric Planosol	444
WRB fourth edition 2022	soilClassificationWRB	Irragric Stagnosol	581
WRB fourth edition 2022	soilClassificationWRB	Irragric Vertisol	657
WRB fourth edition 2022	soilClassificationWRB	Isolatic Technosol	611
WRB fourth edition 2022	soilClassificationWRB	Lamellic Acrisol	15
WRB fourth edition 2022	soilClassificationWRB	Lamellic Alisol	34
WRB fourth edition 2022	soilClassificationWRB	Lamellic Lixisol	354
WRB fourth edition 2022	soilClassificationWRB	Lamellic Luvisol	378
WRB fourth edition 2022	soilClassificationWRB	Leptic Acrisol	3
WRB fourth edition 2022	soilClassificationWRB	Leptic Alisol	22
WRB fourth edition 2022	soilClassificationWRB	Leptic Andosol	42
WRB fourth edition 2022	soilClassificationWRB	Leptic Calcisol	89
WRB fourth edition 2022	soilClassificationWRB	Leptic Cambisol	114
WRB fourth edition 2022	soilClassificationWRB	Leptic Chernozem	134
WRB fourth edition 2022	soilClassificationWRB	Leptic Cryosol	152
WRB fourth edition 2022	soilClassificationWRB	Leptic Durisol	176
WRB fourth edition 2022	soilClassificationWRB	Leptic Fluvisol	212
WRB fourth edition 2022	soilClassificationWRB	Leptic Gypsisol	262
WRB fourth edition 2022	soilClassificationWRB	Leptic Histosol	287
WRB fourth edition 2022	soilClassificationWRB	Leptic Kastanozem	303
WRB fourth edition 2022	soilClassificationWRB	Leptic Lixisol	342
WRB fourth edition 2022	soilClassificationWRB	Leptic Luvisol	366
WRB fourth edition 2022	soilClassificationWRB	Leptic Nitisol	392
WRB fourth edition 2022	soilClassificationWRB	Leptic Phaeozem	416
WRB fourth edition 2022	soilClassificationWRB	Leptic Planosol	441
WRB fourth edition 2022	soilClassificationWRB	Leptic Plinthosol	480
WRB fourth edition 2022	soilClassificationWRB	Leptic Podzol	489
WRB fourth edition 2022	soilClassificationWRB	Leptic Regosol	508
WRB fourth edition 2022	soilClassificationWRB	Leptic Retisol	530
WRB fourth edition 2022	soilClassificationWRB	Leptic Solonchak	556
WRB fourth edition 2022	soilClassificationWRB	Leptic Stagnosol	578
WRB fourth edition 2022	soilClassificationWRB	Leptic Technosol	612
WRB fourth edition 2022	soilClassificationWRB	Leptic Umbrisol	629
WRB fourth edition 2022	soilClassificationWRB	Leptic Vertisol	649
WRB fourth edition 2022	soilClassificationWRB	LinicUrbic Technosol	607
WRB fourth edition 2022	soilClassificationWRB	Lithic Leptosol	317
WRB fourth edition 2022	soilClassificationWRB	Lixic Calcisol	92
WRB fourth edition 2022	soilClassificationWRB	Lixic Durisol	178
WRB fourth edition 2022	soilClassificationWRB	Lixic Ferralsol	205
WRB fourth edition 2022	soilClassificationWRB	Lixic Gypsisol	265
WRB fourth edition 2022	soilClassificationWRB	Lixic Nitisol	403
WRB fourth edition 2022	soilClassificationWRB	Lixic Phaeozem	428
WRB fourth edition 2022	soilClassificationWRB	Lixic Planosol	460
WRB fourth edition 2022	soilClassificationWRB	Lixic Stagnosol	597
WRB fourth edition 2022	soilClassificationWRB	Lixic Umbrisol	637
WRB fourth edition 2022	soilClassificationWRB	Luvic Calcisol	93
WRB fourth edition 2022	soilClassificationWRB	Luvic Chernozem	139
WRB fourth edition 2022	soilClassificationWRB	Luvic Cryosol	162
WRB fourth edition 2022	soilClassificationWRB	Luvic Durisol	180
WRB fourth edition 2022	soilClassificationWRB	Luvic Gypsisol	266
WRB fourth edition 2022	soilClassificationWRB	Luvic Kastanozem	309
WRB fourth edition 2022	soilClassificationWRB	Luvic Nitisol	405
WRB fourth edition 2022	soilClassificationWRB	Luvic Phaeozem	429
WRB fourth edition 2022	soilClassificationWRB	Luvic Planosol	462
WRB fourth edition 2022	soilClassificationWRB	Luvic Stagnosol	599
WRB fourth edition 2022	soilClassificationWRB	Luvic Umbrisol	639
WRB fourth edition 2022	soilClassificationWRB	Mawic Histosol	277
WRB fourth edition 2022	soilClassificationWRB	Mollic Andosol	49
WRB fourth edition 2022	soilClassificationWRB	Mollic Cryosol	155
WRB fourth edition 2022	soilClassificationWRB	Mollic Ferralsol	202
WRB fourth edition 2022	soilClassificationWRB	Mollic Gleysol	241
WRB fourth edition 2022	soilClassificationWRB	Mollic Leptosol	325
WRB fourth edition 2022	soilClassificationWRB	Mollic Nitisol	400
WRB fourth edition 2022	soilClassificationWRB	Mollic Planosol	452
WRB fourth edition 2022	soilClassificationWRB	Mollic Plinthosol	477
WRB fourth edition 2022	soilClassificationWRB	Mollic Solonchak	557
WRB fourth edition 2022	soilClassificationWRB	Mollic Solonetz	565
WRB fourth edition 2022	soilClassificationWRB	Mollic Stagnosol	589
WRB fourth edition 2022	soilClassificationWRB	Mollic Umbrisol	625
WRB fourth edition 2022	soilClassificationWRB	Mulmic Phaeozem	411
WRB fourth edition 2022	soilClassificationWRB	Mulmic Umbrisol	627
WRB fourth edition 2022	soilClassificationWRB	Murshic Histosol	289
WRB fourth edition 2022	soilClassificationWRB	Muusic Histosol	275
WRB fourth edition 2022	soilClassificationWRB	Natric Cryosol	157
WRB fourth edition 2022	soilClassificationWRB	Neobrunic Retisol	540
WRB fourth edition 2022	soilClassificationWRB	Neocambic Retisol	539
WRB fourth edition 2022	soilClassificationWRB	Nitic Ferralsol	197
WRB fourth edition 2022	soilClassificationWRB	Nitic Plinthosol	475
WRB fourth edition 2022	soilClassificationWRB	Nudiargic Acrisol	14
WRB fourth edition 2022	soilClassificationWRB	Nudiargic Alisol	33
WRB fourth edition 2022	soilClassificationWRB	Nudiargic Lixisol	353
WRB fourth edition 2022	soilClassificationWRB	Nudiargic Luvisol	377
WRB fourth edition 2022	soilClassificationWRB	Nudiargic Retisol	538
WRB fourth edition 2022	soilClassificationWRB	Nudilithic Leptosol	316
WRB fourth edition 2022	soilClassificationWRB	Nudinatric Solonetz	573
WRB fourth edition 2022	soilClassificationWRB	Ombric Histosol	291
WRB fourth edition 2022	soilClassificationWRB	Orthofluvic Fluvisol	211
WRB fourth edition 2022	soilClassificationWRB	Ortsteinic Podzol	484
WRB fourth edition 2022	soilClassificationWRB	Oxyaquic Cryosol	151
WRB fourth edition 2022	soilClassificationWRB	Oxyaquic Gleysol	246
WRB fourth edition 2022	soilClassificationWRB	Oxygleyic Gleysol	247
WRB fourth edition 2022	soilClassificationWRB	Pantofluvic Fluvisol	209
WRB fourth edition 2022	soilClassificationWRB	Pellic Vertisol	658
WRB fourth edition 2022	soilClassificationWRB	Petric Calcisol	88
WRB fourth edition 2022	soilClassificationWRB	Petric Durisol	171
WRB fourth edition 2022	soilClassificationWRB	Petric Gypsisol	259
WRB fourth edition 2022	soilClassificationWRB	Petric Plinthosol	470
WRB fourth edition 2022	soilClassificationWRB	Petrocalcic Chernozem	133
WRB fourth edition 2022	soilClassificationWRB	Petrocalcic Durisol	174
WRB fourth edition 2022	soilClassificationWRB	Petrocalcic Gypsisol	260
WRB fourth edition 2022	soilClassificationWRB	Petrocalcic Kastanozem	302
WRB fourth edition 2022	soilClassificationWRB	Petrocalcic Lixisol	341
WRB fourth edition 2022	soilClassificationWRB	Petrocalcic Luvisol	365
WRB fourth edition 2022	soilClassificationWRB	Petrocalcic Phaeozem	414
WRB fourth edition 2022	soilClassificationWRB	Petrocalcic Solonchak	554
WRB fourth edition 2022	soilClassificationWRB	Petrocalcic Solonetz	568
WRB fourth edition 2022	soilClassificationWRB	Petrocalcic Vertisol	653
WRB fourth edition 2022	soilClassificationWRB	Petroduric Andosol	51
WRB fourth edition 2022	soilClassificationWRB	Petroduric Chernozem	131
WRB fourth edition 2022	soilClassificationWRB	Petroduric Kastanozem	298
WRB fourth edition 2022	soilClassificationWRB	Petroduric Phaeozem	412
WRB fourth edition 2022	soilClassificationWRB	Petroduric Planosol	463
WRB fourth edition 2022	soilClassificationWRB	Petroduric Vertisol	650
WRB fourth edition 2022	soilClassificationWRB	Petrogypsic Durisol	172
WRB fourth edition 2022	soilClassificationWRB	Petrogypsic Kastanozem	300
WRB fourth edition 2022	soilClassificationWRB	Petrogypsic Solonchak	552
WRB fourth edition 2022	soilClassificationWRB	Petrosalic Solonchak	548
WRB fourth edition 2022	soilClassificationWRB	Pisoplinthic Gleysol	243
WRB fourth edition 2022	soilClassificationWRB	Pisoplinthic Plinthosol	471
WRB fourth edition 2022	soilClassificationWRB	Plaggic Alisol	25
WRB fourth edition 2022	soilClassificationWRB	Plaggic Anthrosol	63
WRB fourth edition 2022	soilClassificationWRB	Plaggic Cambisol	107
WRB fourth edition 2022	soilClassificationWRB	Plaggic Gleysol	234
WRB fourth edition 2022	soilClassificationWRB	Plaggic Planosol	446
WRB fourth edition 2022	soilClassificationWRB	Plaggic Podzol	491
WRB fourth edition 2022	soilClassificationWRB	Plaggic Retisol	531
WRB fourth edition 2022	soilClassificationWRB	Plaggic Stagnosol	583
WRB fourth edition 2022	soilClassificationWRB	Plaggic Umbrisol	621
WRB fourth edition 2022	soilClassificationWRB	Plinthic Gleysol	244
WRB fourth edition 2022	soilClassificationWRB	Pretic Acrisol	6
WRB fourth edition 2022	soilClassificationWRB	Pretic Alisol	26
WRB fourth edition 2022	soilClassificationWRB	Pretic Anthrosol	64
WRB fourth edition 2022	soilClassificationWRB	Pretic Cambisol	108
WRB fourth edition 2022	soilClassificationWRB	Pretic Ferralsol	198
WRB fourth edition 2022	soilClassificationWRB	Pretic Gleysol	235
WRB fourth edition 2022	soilClassificationWRB	Pretic Lixisol	345
WRB fourth edition 2022	soilClassificationWRB	Pretic Luvisol	370
WRB fourth edition 2022	soilClassificationWRB	Pretic Nitisol	398
WRB fourth edition 2022	soilClassificationWRB	Pretic Phaeozem	419
WRB fourth edition 2022	soilClassificationWRB	Pretic Planosol	447
WRB fourth edition 2022	soilClassificationWRB	Pretic Podzol	492
WRB fourth edition 2022	soilClassificationWRB	Pretic Retisol	532
WRB fourth edition 2022	soilClassificationWRB	Pretic Stagnosol	584
WRB fourth edition 2022	soilClassificationWRB	Pretic Umbrisol	622
WRB fourth edition 2022	soilClassificationWRB	Profundihumic Ferralsol	201
WRB fourth edition 2022	soilClassificationWRB	Profundihumic Nitisol	399
WRB fourth edition 2022	soilClassificationWRB	Protic Arenosol	80
WRB fourth edition 2022	soilClassificationWRB	Protic Cryosol	166
WRB fourth edition 2022	soilClassificationWRB	Protic Fluvisol	220
WRB fourth edition 2022	soilClassificationWRB	Protic Regosol	519
WRB fourth edition 2022	soilClassificationWRB	Reductaquic Cryosol	150
WRB fourth edition 2022	soilClassificationWRB	Reductic Gleysol	227
WRB fourth edition 2022	soilClassificationWRB	Reductic Planosol	439
WRB fourth edition 2022	soilClassificationWRB	Reductic Stagnosol	576
WRB fourth edition 2022	soilClassificationWRB	Reductic Technosol	615
WRB fourth edition 2022	soilClassificationWRB	Reductigleyic Gleysol	248
WRB fourth edition 2022	soilClassificationWRB	Relocatic Arenosol	82
WRB fourth edition 2022	soilClassificationWRB	Relocatic Regosol	521
WRB fourth edition 2022	soilClassificationWRB	Rendzic Leptosol	324
WRB fourth edition 2022	soilClassificationWRB	Rendzic Phaeozem	408
WRB fourth edition 2022	soilClassificationWRB	Retic Cryosol	160
WRB fourth edition 2022	soilClassificationWRB	Retic Phaeozem	427
WRB fourth edition 2022	soilClassificationWRB	Retic Planosol	458
WRB fourth edition 2022	soilClassificationWRB	Retic Podzol	502
WRB fourth edition 2022	soilClassificationWRB	Retic Stagnosol	595
WRB fourth edition 2022	soilClassificationWRB	Retic Umbrisol	635
WRB fourth edition 2022	soilClassificationWRB	Rheic Histosol	292
WRB fourth edition 2022	soilClassificationWRB	Rhodic Acrisol	11
WRB fourth edition 2022	soilClassificationWRB	Rhodic Alisol	31
WRB fourth edition 2022	soilClassificationWRB	Rhodic Cambisol	121
WRB fourth edition 2022	soilClassificationWRB	Rhodic Ferralsol	194
WRB fourth edition 2022	soilClassificationWRB	Rhodic Lixisol	350
WRB fourth edition 2022	soilClassificationWRB	Rhodic Luvisol	375
WRB fourth edition 2022	soilClassificationWRB	Rhodic Nitisol	393
WRB fourth edition 2022	soilClassificationWRB	Rockic Histosol	276
WRB fourth edition 2022	soilClassificationWRB	Rustic Podzol	486
WRB fourth edition 2022	soilClassificationWRB	Salic Cryosol	158
WRB fourth edition 2022	soilClassificationWRB	Salic Solonetz	566
WRB fourth edition 2022	soilClassificationWRB	Salic Vertisol	647
WRB fourth edition 2022	soilClassificationWRB	Sapric Histosol	286
WRB fourth edition 2022	soilClassificationWRB	Sideralic Anthrosol	69
WRB fourth edition 2022	soilClassificationWRB	Sideralic Arenosol	78
WRB fourth edition 2022	soilClassificationWRB	Sideralic Cambisol	120
WRB fourth edition 2022	soilClassificationWRB	Sideralic Nitisol	390
WRB fourth edition 2022	soilClassificationWRB	Sideralic Retisol	537
WRB fourth edition 2022	soilClassificationWRB	Silandic Andosol	40
WRB fourth edition 2022	soilClassificationWRB	Skeletic Acrisol	18
WRB fourth edition 2022	soilClassificationWRB	Skeletic Alisol	37
WRB fourth edition 2022	soilClassificationWRB	Skeletic Andosol	57
WRB fourth edition 2022	soilClassificationWRB	Skeletic Calcisol	97
WRB fourth edition 2022	soilClassificationWRB	Skeletic Cambisol	123
WRB fourth edition 2022	soilClassificationWRB	Skeletic Chernozem	142
WRB fourth edition 2022	soilClassificationWRB	Skeletic Cryosol	169
WRB fourth edition 2022	soilClassificationWRB	Skeletic Durisol	184
WRB fourth edition 2022	soilClassificationWRB	Skeletic Ferralsol	206
WRB fourth edition 2022	soilClassificationWRB	Skeletic Fluvisol	216
WRB fourth edition 2022	soilClassificationWRB	Skeletic Gypsisol	270
WRB fourth edition 2022	soilClassificationWRB	Skeletic Histosol	294
WRB fourth edition 2022	soilClassificationWRB	Skeletic Kastanozem	313
WRB fourth edition 2022	soilClassificationWRB	Skeletic Leptosol	319
WRB fourth edition 2022	soilClassificationWRB	Skeletic Lixisol	361
WRB fourth edition 2022	soilClassificationWRB	Skeletic Luvisol	385
WRB fourth edition 2022	soilClassificationWRB	Skeletic Phaeozem	432
WRB fourth edition 2022	soilClassificationWRB	Skeletic Plinthosol	482
WRB fourth edition 2022	soilClassificationWRB	Skeletic Podzol	506
WRB fourth edition 2022	soilClassificationWRB	Skeletic Regosol	515
WRB fourth edition 2022	soilClassificationWRB	Skeletic Retisol	543
WRB fourth edition 2022	soilClassificationWRB	Skeletic Umbrisol	642
WRB fourth edition 2022	soilClassificationWRB	Sodic Solonchak	551
WRB fourth edition 2022	soilClassificationWRB	Sodic Vertisol	648
WRB fourth edition 2022	soilClassificationWRB	Solimovic Arenosol	73
WRB fourth edition 2022	soilClassificationWRB	Solimovic Cambisol	118
WRB fourth edition 2022	soilClassificationWRB	Solimovic Regosol	509
WRB fourth edition 2022	soilClassificationWRB	Someric Kastanozem	297
WRB fourth edition 2022	soilClassificationWRB	Someric Phaeozem	410
WRB fourth edition 2022	soilClassificationWRB	Someric Umbrisol	626
WRB fourth edition 2022	soilClassificationWRB	Spodic Cryosol	159
WRB fourth edition 2022	soilClassificationWRB	Spodic Gleysol	252
WRB fourth edition 2022	soilClassificationWRB	Spolic Technosol	608
WRB fourth edition 2022	soilClassificationWRB	Stagnic Acrisol	9
WRB fourth edition 2022	soilClassificationWRB	Stagnic Alisol	29
WRB fourth edition 2022	soilClassificationWRB	Stagnic Anthrosol	67
WRB fourth edition 2022	soilClassificationWRB	Stagnic Calcisol	91
WRB fourth edition 2022	soilClassificationWRB	Stagnic Cambisol	117
WRB fourth edition 2022	soilClassificationWRB	Stagnic Ferralsol	200
WRB fourth edition 2022	soilClassificationWRB	Stagnic Fluvisol	215
WRB fourth edition 2022	soilClassificationWRB	Stagnic Gleysol	245
WRB fourth edition 2022	soilClassificationWRB	Stagnic Gypsisol	264
WRB fourth edition 2022	soilClassificationWRB	Stagnic Lixisol	348
WRB fourth edition 2022	soilClassificationWRB	Stagnic Luvisol	373
WRB fourth edition 2022	soilClassificationWRB	Stagnic Phaeozem	422
WRB fourth edition 2022	soilClassificationWRB	Stagnic Plinthosol	473
WRB fourth edition 2022	soilClassificationWRB	Stagnic Podzol	498
WRB fourth edition 2022	soilClassificationWRB	Stagnic Regosol	514
WRB fourth edition 2022	soilClassificationWRB	Stagnic Retisol	536
WRB fourth edition 2022	soilClassificationWRB	Stagnic Solonchak	550
WRB fourth edition 2022	soilClassificationWRB	Stagnic Solonetz	564
WRB fourth edition 2022	soilClassificationWRB	Stagnic Technosol	618
WRB fourth edition 2022	soilClassificationWRB	Stagnic Umbrisol	631
WRB fourth edition 2022	soilClassificationWRB	Subaquatic Cryosol	148
WRB fourth edition 2022	soilClassificationWRB	Subaquatic Gleysol	228
WRB fourth edition 2022	soilClassificationWRB	Subaquatic Histosol	282
WRB fourth edition 2022	soilClassificationWRB	Subaquatic Leptosol	320
WRB fourth edition 2022	soilClassificationWRB	Subaquatic Technosol	613
WRB fourth edition 2022	soilClassificationWRB	Takyric Calcisol	99
WRB fourth edition 2022	soilClassificationWRB	Takyric Cambisol	125
WRB fourth edition 2022	soilClassificationWRB	Takyric Durisol	186
WRB fourth edition 2022	soilClassificationWRB	Takyric Fluvisol	219
WRB fourth edition 2022	soilClassificationWRB	Takyric Gypsisol	272
WRB fourth edition 2022	soilClassificationWRB	Takyric Leptosol	332
WRB fourth edition 2022	soilClassificationWRB	Takyric Lixisol	360
WRB fourth edition 2022	soilClassificationWRB	Takyric Luvisol	384
WRB fourth edition 2022	soilClassificationWRB	Takyric Regosol	518
WRB fourth edition 2022	soilClassificationWRB	Takyric Solonchak	560
WRB fourth edition 2022	soilClassificationWRB	Takyric Solonetz	572
WRB fourth edition 2022	soilClassificationWRB	Tephric Andosol	55
WRB fourth edition 2022	soilClassificationWRB	Tephric Arenosol	74
WRB fourth edition 2022	soilClassificationWRB	Tephric Fluvisol	217
WRB fourth edition 2022	soilClassificationWRB	Tephric Regosol	511
WRB fourth edition 2022	soilClassificationWRB	Terric Acrisol	7
WRB fourth edition 2022	soilClassificationWRB	Terric Alisol	27
WRB fourth edition 2022	soilClassificationWRB	Terric Anthrosol	65
WRB fourth edition 2022	soilClassificationWRB	Terric Cambisol	109
WRB fourth edition 2022	soilClassificationWRB	Terric Gleysol	236
WRB fourth edition 2022	soilClassificationWRB	Terric Kastanozem	305
WRB fourth edition 2022	soilClassificationWRB	Terric Lixisol	346
WRB fourth edition 2022	soilClassificationWRB	Terric Luvisol	371
WRB fourth edition 2022	soilClassificationWRB	Terric Phaeozem	420
WRB fourth edition 2022	soilClassificationWRB	Terric Planosol	448
WRB fourth edition 2022	soilClassificationWRB	Terric Podzol	493
WRB fourth edition 2022	soilClassificationWRB	Terric Retisol	533
WRB fourth edition 2022	soilClassificationWRB	Terric Stagnosol	585
WRB fourth edition 2022	soilClassificationWRB	Terric Umbrisol	623
WRB fourth edition 2022	soilClassificationWRB	Thionic Cambisol	103
WRB fourth edition 2022	soilClassificationWRB	Thionic Gleysol	226
WRB fourth edition 2022	soilClassificationWRB	Thionic Histosol	279
WRB fourth edition 2022	soilClassificationWRB	Thionic Planosol	440
WRB fourth edition 2022	soilClassificationWRB	Thionic Stagnosol	577
WRB fourth edition 2022	soilClassificationWRB	Thyric Histosol	288
WRB fourth edition 2022	soilClassificationWRB	Thyric Technosol	606
WRB fourth edition 2022	soilClassificationWRB	Tidalic Arenosol	71
WRB fourth edition 2022	soilClassificationWRB	Tidalic Cryosol	149
WRB fourth edition 2022	soilClassificationWRB	Tidalic Fluvisol	208
WRB fourth edition 2022	soilClassificationWRB	Tidalic Gleysol	229
WRB fourth edition 2022	soilClassificationWRB	Tidalic Histosol	283
WRB fourth edition 2022	soilClassificationWRB	Tidalic Leptosol	321
WRB fourth edition 2022	soilClassificationWRB	Tidalic Regosol	507
WRB fourth edition 2022	soilClassificationWRB	Tidalic Technosol	614
WRB fourth edition 2022	soilClassificationWRB	Tonguic Chernozem	144
WRB fourth edition 2022	soilClassificationWRB	Tonguic Kastanozem	314
WRB fourth edition 2022	soilClassificationWRB	Tonguic Phaeozem	434
WRB fourth edition 2022	soilClassificationWRB	Tonguic Umbrisol	643
WRB fourth edition 2022	soilClassificationWRB	Transportic Arenosol	81
WRB fourth edition 2022	soilClassificationWRB	Transportic Regosol	520
WRB fourth edition 2022	soilClassificationWRB	Tsitelic Arenosol	75
WRB fourth edition 2022	soilClassificationWRB	Tsitelic Cambisol	110
WRB fourth edition 2022	soilClassificationWRB	Turbic Cryosol	147
WRB fourth edition 2022	soilClassificationWRB	Umbric Andosol	50
WRB fourth edition 2022	soilClassificationWRB	Umbric Cryosol	156
WRB fourth edition 2022	soilClassificationWRB	Umbric Ferralsol	203
WRB fourth edition 2022	soilClassificationWRB	Umbric Gleysol	242
WRB fourth edition 2022	soilClassificationWRB	Umbric Leptosol	326
WRB fourth edition 2022	soilClassificationWRB	Umbric Nitisol	401
WRB fourth edition 2022	soilClassificationWRB	Umbric Planosol	453
WRB fourth edition 2022	soilClassificationWRB	Umbric Plinthosol	478
WRB fourth edition 2022	soilClassificationWRB	Umbric Podzol	500
WRB fourth edition 2022	soilClassificationWRB	Umbric Stagnosol	590
WRB fourth edition 2022	soilClassificationWRB	Vermic Chernozem	143
WRB fourth edition 2022	soilClassificationWRB	Vermic Phaeozem	433
WRB fourth edition 2022	soilClassificationWRB	Vermic Regosol	516
WRB fourth edition 2022	soilClassificationWRB	Vertic Alisol	30
WRB fourth edition 2022	soilClassificationWRB	Vertic Cambisol	111
WRB fourth edition 2022	soilClassificationWRB	Vertic Chernozem	137
WRB fourth edition 2022	soilClassificationWRB	Vertic Kastanozem	308
WRB fourth edition 2022	soilClassificationWRB	Vertic Luvisol	374
WRB fourth edition 2022	soilClassificationWRB	Vertic Phaeozem	424
WRB fourth edition 2022	soilClassificationWRB	Vertic Planosol	456
WRB fourth edition 2022	soilClassificationWRB	Vertic Solonetz	570
WRB fourth edition 2022	soilClassificationWRB	Vertic Stagnosol	593
WRB fourth edition 2022	soilClassificationWRB	Vitric Andosol	41
WRB fourth edition 2022	soilClassificationWRB	Vitric Cambisol	113
WRB fourth edition 2022	soilClassificationWRB	Vitric Gleysol	239
WRB fourth edition 2022	soilClassificationWRB	Vitric Histosol	296
WRB fourth edition 2022	soilClassificationWRB	Vitric Podzol	497
WRB fourth edition 2022	soilClassificationWRB	Wapnic Cryosol	164
WRB fourth edition 2022	soilClassificationWRB	Wapnic Gleysol	251
WRB fourth edition 2022	soilClassificationWRB	Xanthic Acrisol	13
WRB fourth edition 2022	soilClassificationWRB	Xanthic Ferralsol	195
WRB fourth edition 2022	soilClassificationWRB	Xanthic Lixisol	352
WRB fourth edition 2022	soilClassificationWRB	Xanthic Nitisol	394
WRB fourth edition 2022	soilClassificationWRB	Yermic Arenosol	79
WRB fourth edition 2022	soilClassificationWRB	Yermic Calcisol	98
WRB fourth edition 2022	soilClassificationWRB	Yermic Cambisol	124
WRB fourth edition 2022	soilClassificationWRB	Yermic Cryosol	165
WRB fourth edition 2022	soilClassificationWRB	Yermic Durisol	185
WRB fourth edition 2022	soilClassificationWRB	Yermic Fluvisol	218
WRB fourth edition 2022	soilClassificationWRB	Yermic Gypsisol	271
WRB fourth edition 2022	soilClassificationWRB	Yermic Leptosol	331
WRB fourth edition 2022	soilClassificationWRB	Yermic Lixisol	359
WRB fourth edition 2022	soilClassificationWRB	Yermic Luvisol	383
WRB fourth edition 2022	soilClassificationWRB	Yermic Regosol	517
WRB fourth edition 2022	soilClassificationWRB	Yermic Solonchak	559
WRB fourth edition 2022	soilClassificationWRB	Yermic Solonetz	571
WRB fourth edition 2022	soilGroupWRB	Acrisol (AC)	1
WRB fourth edition 2022	soilGroupWRB	Alisol (AL)	2
WRB fourth edition 2022	soilGroupWRB	Andosol (AN)	3
WRB fourth edition 2022	soilGroupWRB	Anthrosol (AT)	4
WRB fourth edition 2022	soilGroupWRB	Arenosol (AR)	5
WRB fourth edition 2022	soilGroupWRB	Calcisol (CL)	6
WRB fourth edition 2022	soilGroupWRB	Cambisol (CM)	7
WRB fourth edition 2022	soilGroupWRB	Chernozem (CH)	8
WRB fourth edition 2022	soilGroupWRB	Cryosol (CR)	9
WRB fourth edition 2022	soilGroupWRB	Durisol (DU)	10
WRB fourth edition 2022	soilGroupWRB	Ferralsol (FR)	11
WRB fourth edition 2022	soilGroupWRB	Fluvisol (FL)	12
WRB fourth edition 2022	soilGroupWRB	Gleysol (GL)	13
WRB fourth edition 2022	soilGroupWRB	Gypsisol (GY)	14
WRB fourth edition 2022	soilGroupWRB	Histosol (HS)	15
WRB fourth edition 2022	soilGroupWRB	Kastanozem (KS)	16
WRB fourth edition 2022	soilGroupWRB	Leptosol (LP)	17
WRB fourth edition 2022	soilGroupWRB	Lixisol (LX)	18
WRB fourth edition 2022	soilGroupWRB	Luvisol (LV)	19
WRB fourth edition 2022	soilGroupWRB	Nitisol (NT)	20
WRB fourth edition 2022	soilGroupWRB	Phaeozem (PH)	21
WRB fourth edition 2022	soilGroupWRB	Planosol (PL)	22
WRB fourth edition 2022	soilGroupWRB	Plinthosol (PT)	23
WRB fourth edition 2022	soilGroupWRB	Podzol (PZ)	24
WRB fourth edition 2022	soilGroupWRB	Regosol (RG)	25
WRB fourth edition 2022	soilGroupWRB	Retisol (RT)	26
WRB fourth edition 2022	soilGroupWRB	Solonchak (SC)	27
WRB fourth edition 2022	soilGroupWRB	Solonetz (SN)	28
WRB fourth edition 2022	soilGroupWRB	Stagnosol (ST)	29
WRB fourth edition 2022	soilGroupWRB	Technosol (TC)	30
WRB fourth edition 2022	soilGroupWRB	Umbrisol (UM)	31
WRB fourth edition 2022	soilGroupWRB	Vertisol (VR)	32
WRB fourth edition 2022	SoilSpecifierWRB	Amphi	1
WRB fourth edition 2022	SoilSpecifierWRB	Ano	2
WRB fourth edition 2022	SoilSpecifierWRB	Bathy	3
WRB fourth edition 2022	SoilSpecifierWRB	Endo	4
WRB fourth edition 2022	SoilSpecifierWRB	Epi	5
WRB fourth edition 2022	SoilSpecifierWRB	Kato	6
WRB fourth edition 2022	SoilSpecifierWRB	Panto	7
WRB fourth edition 2022	SoilSpecifierWRB	Poly	8
WRB fourth edition 2022	SoilSpecifierWRB	Supra	9
WRB fourth edition 2022	SoilSpecifierWRB	Thapto	10
WRB fourth edition 2022	SupplementaryQualifierWRB	Abruptic	1
WRB fourth edition 2022	SupplementaryQualifierWRB	Aceric	2
WRB fourth edition 2022	SupplementaryQualifierWRB	Acric	3
WRB fourth edition 2022	SupplementaryQualifierWRB	Acroxic	4
WRB fourth edition 2022	SupplementaryQualifierWRB	Activic	5
WRB fourth edition 2022	SupplementaryQualifierWRB	Aeolic	6
WRB fourth edition 2022	SupplementaryQualifierWRB	Albic	7
WRB fourth edition 2022	SupplementaryQualifierWRB	Alcalic	8
WRB fourth edition 2022	SupplementaryQualifierWRB	Alic	9
WRB fourth edition 2022	SupplementaryQualifierWRB	Andic	10
WRB fourth edition 2022	SupplementaryQualifierWRB	Anthraquic	11
WRB fourth edition 2022	SupplementaryQualifierWRB	Anthric	12
WRB fourth edition 2022	SupplementaryQualifierWRB	Archaic	13
WRB fourth edition 2022	SupplementaryQualifierWRB	Arenic	14
WRB fourth edition 2022	SupplementaryQualifierWRB	Arenicolic	15
WRB fourth edition 2022	SupplementaryQualifierWRB	Aric	16
WRB fourth edition 2022	SupplementaryQualifierWRB	Bathyspodic	17
WRB fourth edition 2022	SupplementaryQualifierWRB	Biocrustic	18
WRB fourth edition 2022	SupplementaryQualifierWRB	Bryic	19
WRB fourth edition 2022	SupplementaryQualifierWRB	Calcaric	20
WRB fourth edition 2022	SupplementaryQualifierWRB	Calcic	21
WRB fourth edition 2022	SupplementaryQualifierWRB	Cambic	22
WRB fourth edition 2022	SupplementaryQualifierWRB	Capillaric	23
WRB fourth edition 2022	SupplementaryQualifierWRB	Carbonatic	24
WRB fourth edition 2022	SupplementaryQualifierWRB	Carbonic	25
WRB fourth edition 2022	SupplementaryQualifierWRB	Chernic	26
WRB fourth edition 2022	SupplementaryQualifierWRB	Chloridic	27
WRB fourth edition 2022	SupplementaryQualifierWRB	Chromic	28
WRB fourth edition 2022	SupplementaryQualifierWRB	Claric	29
WRB fourth edition 2022	SupplementaryQualifierWRB	Clayic	30
WRB fourth edition 2022	SupplementaryQualifierWRB	Cohesic	31
WRB fourth edition 2022	SupplementaryQualifierWRB	Columnic	32
WRB fourth edition 2022	SupplementaryQualifierWRB	Cordic	33
WRB fourth edition 2022	SupplementaryQualifierWRB	Cutanic	34
WRB fourth edition 2022	SupplementaryQualifierWRB	Densic	35
WRB fourth edition 2022	SupplementaryQualifierWRB	Differentic	36
WRB fourth edition 2022	SupplementaryQualifierWRB	Dolomitic	37
WRB fourth edition 2022	SupplementaryQualifierWRB	Dorsic	38
WRB fourth edition 2022	SupplementaryQualifierWRB	Drainic	39
WRB fourth edition 2022	SupplementaryQualifierWRB	Duric	40
WRB fourth edition 2022	SupplementaryQualifierWRB	Dystric	41
WRB fourth edition 2022	SupplementaryQualifierWRB	Endic	42
WRB fourth edition 2022	SupplementaryQualifierWRB	Endoabruptic	43
WRB fourth edition 2022	SupplementaryQualifierWRB	Endodystric	44
WRB fourth edition 2022	SupplementaryQualifierWRB	Endogleyic	45
WRB fourth edition 2022	SupplementaryQualifierWRB	Endoleptic	46
WRB fourth edition 2022	SupplementaryQualifierWRB	Endostagnic	47
WRB fourth edition 2022	SupplementaryQualifierWRB	Endothionic	48
WRB fourth edition 2022	SupplementaryQualifierWRB	Endothyric	49
WRB fourth edition 2022	SupplementaryQualifierWRB	Epic	50
WRB fourth edition 2022	SupplementaryQualifierWRB	Epidystric	51
WRB fourth edition 2022	SupplementaryQualifierWRB	Epieutric	52
WRB fourth edition 2022	SupplementaryQualifierWRB	Escalic	53
WRB fourth edition 2022	SupplementaryQualifierWRB	Eutric	54
WRB fourth edition 2022	SupplementaryQualifierWRB	Eutrosilic	55
WRB fourth edition 2022	SupplementaryQualifierWRB	Evapocrustic	56
WRB fourth edition 2022	SupplementaryQualifierWRB	Ferralic	57
WRB fourth edition 2022	SupplementaryQualifierWRB	Ferric	58
WRB fourth edition 2022	SupplementaryQualifierWRB	Ferritic	59
WRB fourth edition 2022	SupplementaryQualifierWRB	Fluvic	60
WRB fourth edition 2022	SupplementaryQualifierWRB	Folic	61
WRB fourth edition 2022	SupplementaryQualifierWRB	Fractic	62
WRB fourth edition 2022	SupplementaryQualifierWRB	Fragic	63
WRB fourth edition 2022	SupplementaryQualifierWRB	Gelic	64
WRB fourth edition 2022	SupplementaryQualifierWRB	Gelistagnic	65
WRB fourth edition 2022	SupplementaryQualifierWRB	Geoabruptic	66
WRB fourth edition 2022	SupplementaryQualifierWRB	Geric	67
WRB fourth edition 2022	SupplementaryQualifierWRB	Gibbsic	68
WRB fourth edition 2022	SupplementaryQualifierWRB	Gilgaic	69
WRB fourth edition 2022	SupplementaryQualifierWRB	Gleyic	70
WRB fourth edition 2022	SupplementaryQualifierWRB	Glossic	71
WRB fourth edition 2022	SupplementaryQualifierWRB	Grumic	72
WRB fourth edition 2022	SupplementaryQualifierWRB	Gypsic	73
WRB fourth edition 2022	SupplementaryQualifierWRB	Gypsiric	74
WRB fourth edition 2022	SupplementaryQualifierWRB	Histic	75
WRB fourth edition 2022	SupplementaryQualifierWRB	Hortic	76
WRB fourth edition 2022	SupplementaryQualifierWRB	Humic	77
WRB fourth edition 2022	SupplementaryQualifierWRB	Hydrophobic	78
WRB fourth edition 2022	SupplementaryQualifierWRB	Hyperalic	79
WRB fourth edition 2022	SupplementaryQualifierWRB	Hyperartefactic	80
WRB fourth edition 2022	SupplementaryQualifierWRB	Hypercalcic	81
WRB fourth edition 2022	SupplementaryQualifierWRB	Hyperdystric	82
WRB fourth edition 2022	SupplementaryQualifierWRB	Hypereutric	83
WRB fourth edition 2022	SupplementaryQualifierWRB	Hypergypsic	84
WRB fourth edition 2022	SupplementaryQualifierWRB	Hypernatric	85
WRB fourth edition 2022	SupplementaryQualifierWRB	Hyperorganic	86
WRB fourth edition 2022	SupplementaryQualifierWRB	Hypersalic	87
WRB fourth edition 2022	SupplementaryQualifierWRB	Hyperspodic	88
WRB fourth edition 2022	SupplementaryQualifierWRB	Immissic	89
WRB fourth edition 2022	SupplementaryQualifierWRB	Inclinic	90
WRB fourth edition 2022	SupplementaryQualifierWRB	Irragric	91
WRB fourth edition 2022	SupplementaryQualifierWRB	Isolatic	92
WRB fourth edition 2022	SupplementaryQualifierWRB	Isopteric	93
WRB fourth edition 2022	SupplementaryQualifierWRB	Kalaic	94
WRB fourth edition 2022	SupplementaryQualifierWRB	Lamellic	95
WRB fourth edition 2022	SupplementaryQualifierWRB	Lapiadic	96
WRB fourth edition 2022	SupplementaryQualifierWRB	Laxic	97
WRB fourth edition 2022	SupplementaryQualifierWRB	Lignic	98
WRB fourth edition 2022	SupplementaryQualifierWRB	Limnic	99
WRB fourth edition 2022	SupplementaryQualifierWRB	Limonic	100
WRB fourth edition 2022	SupplementaryQualifierWRB	Litholinic	101
WRB fourth edition 2022	SupplementaryQualifierWRB	Lixic	102
WRB fourth edition 2022	SupplementaryQualifierWRB	Loamic	103
WRB fourth edition 2022	SupplementaryQualifierWRB	Luvic	104
WRB fourth edition 2022	SupplementaryQualifierWRB	Magnesic	105
WRB fourth edition 2022	SupplementaryQualifierWRB	Mahic	106
WRB fourth edition 2022	SupplementaryQualifierWRB	Mazic	107
WRB fourth edition 2022	SupplementaryQualifierWRB	Mineralic	108
WRB fourth edition 2022	SupplementaryQualifierWRB	Mochipic	109
WRB fourth edition 2022	SupplementaryQualifierWRB	Mollic	110
WRB fourth edition 2022	SupplementaryQualifierWRB	Mulmic	111
WRB fourth edition 2022	SupplementaryQualifierWRB	Naramic	112
WRB fourth edition 2022	SupplementaryQualifierWRB	Nechic	113
WRB fourth edition 2022	SupplementaryQualifierWRB	Neobrunic	114
WRB fourth edition 2022	SupplementaryQualifierWRB	Neocambic	115
WRB fourth edition 2022	SupplementaryQualifierWRB	Nitic	116
WRB fourth edition 2022	SupplementaryQualifierWRB	Novic	117
WRB fourth edition 2022	SupplementaryQualifierWRB	Ochric	118
WRB fourth edition 2022	SupplementaryQualifierWRB	Ornithic	119
WRB fourth edition 2022	SupplementaryQualifierWRB	Oxyaquic	120
WRB fourth edition 2022	SupplementaryQualifierWRB	Pachic	121
WRB fourth edition 2022	SupplementaryQualifierWRB	Panpaic	122
WRB fourth edition 2022	SupplementaryQualifierWRB	Pelocrustic	123
WRB fourth edition 2022	SupplementaryQualifierWRB	Petroplinthic	124
WRB fourth edition 2022	SupplementaryQualifierWRB	Placic	125
WRB fourth edition 2022	SupplementaryQualifierWRB	Plaggic	126
WRB fourth edition 2022	SupplementaryQualifierWRB	Posic	127
WRB fourth edition 2022	SupplementaryQualifierWRB	Pretic	128
WRB fourth edition 2022	SupplementaryQualifierWRB	Profondic	129
WRB fourth edition 2022	SupplementaryQualifierWRB	Protic	130
WRB fourth edition 2022	SupplementaryQualifierWRB	Protoandic	131
WRB fourth edition 2022	SupplementaryQualifierWRB	Protoargic	132
WRB fourth edition 2022	SupplementaryQualifierWRB	Protocalcic	133
WRB fourth edition 2022	SupplementaryQualifierWRB	Protogypsic	134
WRB fourth edition 2022	SupplementaryQualifierWRB	Protospodic	135
WRB fourth edition 2022	SupplementaryQualifierWRB	Protovertic	136
WRB fourth edition 2022	SupplementaryQualifierWRB	Puffic	137
WRB fourth edition 2022	SupplementaryQualifierWRB	Pyric	138
WRB fourth edition 2022	SupplementaryQualifierWRB	Raptic	139
WRB fourth edition 2022	SupplementaryQualifierWRB	Reductic	140
WRB fourth edition 2022	SupplementaryQualifierWRB	Relocatic	141
WRB fourth edition 2022	SupplementaryQualifierWRB	Retic	142
WRB fourth edition 2022	SupplementaryQualifierWRB	Rhodic	143
WRB fourth edition 2022	SupplementaryQualifierWRB	Rubic	144
WRB fourth edition 2022	SupplementaryQualifierWRB	Salic	145
WRB fourth edition 2022	SupplementaryQualifierWRB	Saprolithic	146
WRB fourth edition 2022	SupplementaryQualifierWRB	Sideralic	147
WRB fourth edition 2022	SupplementaryQualifierWRB	Siltic	148
WRB fourth edition 2022	SupplementaryQualifierWRB	Skeletic	149
WRB fourth edition 2022	SupplementaryQualifierWRB	Sodic	150
WRB fourth edition 2022	SupplementaryQualifierWRB	Solimovic	151
WRB fourth edition 2022	SupplementaryQualifierWRB	Sombric	152
WRB fourth edition 2022	SupplementaryQualifierWRB	Spodic	153
WRB fourth edition 2022	SupplementaryQualifierWRB	Stagnic	154
WRB fourth edition 2022	SupplementaryQualifierWRB	Sulfatic	155
WRB fourth edition 2022	SupplementaryQualifierWRB	Sulfidic	156
WRB fourth edition 2022	SupplementaryQualifierWRB	Takyric	157
WRB fourth edition 2022	SupplementaryQualifierWRB	Technic	158
WRB fourth edition 2022	SupplementaryQualifierWRB	Tephric	159
WRB fourth edition 2022	SupplementaryQualifierWRB	Terric	160
WRB fourth edition 2022	SupplementaryQualifierWRB	Thionic	161
WRB fourth edition 2022	SupplementaryQualifierWRB	Thixotropic	162
WRB fourth edition 2022	SupplementaryQualifierWRB	Toxic	163
WRB fourth edition 2022	SupplementaryQualifierWRB	Transportic	164
WRB fourth edition 2022	SupplementaryQualifierWRB	Turbic	165
WRB fourth edition 2022	SupplementaryQualifierWRB	Umbric	166
WRB fourth edition 2022	SupplementaryQualifierWRB	Uterquic	167
WRB fourth edition 2022	SupplementaryQualifierWRB	Vertic	168
WRB fourth edition 2022	SupplementaryQualifierWRB	Vitric	169
WRB fourth edition 2022	SupplementaryQualifierWRB	Wapnic	170
\.


--
-- TOC entry 4964 (class 0 OID 54922820)
-- Dependencies: 227
-- Data for Name: observation_phys_chem; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.observation_phys_chem (observation_phys_chem_id, property_phys_chem_id, procedure_phys_chem_id, unit_of_measure_id, value_min, value_max) FROM stdin;
543	pHProperty	pHH2O	pH	1.5	13
175	Boron (B) - extractable	Extr_ap14	%	0	100
514	pH - Hydrogen potential	pHH2O	pH	1.5	13
508	pH - Hydrogen potential	pHCaCl2_ratio1-1	pH	1.5	13
537	pHProperty	pHCaCl2_ratio1-1	pH	1.5	13
509	pH - Hydrogen potential	pHCaCl2_ratio1-10	pH	1.5	13
538	pHProperty	pHCaCl2_ratio1-10	pH	1.5	13
510	pH - Hydrogen potential	pHCaCl2_ratio1-2	pH	1.5	13
539	pHProperty	pHCaCl2_ratio1-2	pH	1.5	13
511	pH - Hydrogen potential	pHCaCl2_ratio1-2.5	pH	1.5	13
540	pHProperty	pHCaCl2_ratio1-2.5	pH	1.5	13
512	pH - Hydrogen potential	pHCaCl2_ratio1-5	pH	1.5	13
541	pHProperty	pHCaCl2_ratio1-5	pH	1.5	13
513	pH - Hydrogen potential	pHCaCl2_sat	pH	1.5	13
542	pHProperty	pHCaCl2_sat	pH	1.5	13
515	pH - Hydrogen potential	pHH2O_ratio1-1	pH	1.5	13
544	pHProperty	pHH2O_ratio1-1	pH	1.5	13
516	pH - Hydrogen potential	pHH2O_ratio1-10	pH	1.5	13
545	pHProperty	pHH2O_ratio1-10	pH	1.5	13
517	pH - Hydrogen potential	pHH2O_ratio1-2	pH	1.5	13
546	pHProperty	pHH2O_ratio1-2	pH	1.5	13
518	pH - Hydrogen potential	pHH2O_ratio1-2.5	pH	1.5	13
547	pHProperty	pHH2O_ratio1-2.5	pH	1.5	13
519	pH - Hydrogen potential	pHH2O_ratio1-5	pH	1.5	13
548	pHProperty	pHH2O_ratio1-5	pH	1.5	13
520	pH - Hydrogen potential	pHH2O_sat	pH	1.5	13
635	Clay texture fraction	SaSiCl_2-50-2000u-adj100	%	0	100
587	Sand texture fraction	SaSiCl_2-50-2000u-adj100	%	0	100
683	Silt texture fraction	SaSiCl_2-50-2000u-adj100	%	0	100
619	Clay texture fraction	SaSiCl_2-20-2000u-adj100	%	0	100
571	Sand texture fraction	SaSiCl_2-20-2000u-adj100	%	0	100
667	Silt texture fraction	SaSiCl_2-20-2000u-adj100	%	0	100
620	Clay texture fraction	SaSiCl_2-20-2000u-disp	%	0	100
572	Sand texture fraction	SaSiCl_2-20-2000u-disp	%	0	100
668	Silt texture fraction	SaSiCl_2-20-2000u-disp	%	0	100
621	Clay texture fraction	SaSiCl_2-20-2000u-disp-beaker	%	0	100
573	Sand texture fraction	SaSiCl_2-20-2000u-disp-beaker	%	0	100
669	Silt texture fraction	SaSiCl_2-20-2000u-disp-beaker	%	0	100
622	Clay texture fraction	SaSiCl_2-20-2000u-disp-hydrometer	%	0	100
574	Sand texture fraction	SaSiCl_2-20-2000u-disp-hydrometer	%	0	100
670	Silt texture fraction	SaSiCl_2-20-2000u-disp-hydrometer	%	0	100
623	Clay texture fraction	SaSiCl_2-20-2000u-disp-hydrometer-bouy	%	0	100
575	Sand texture fraction	SaSiCl_2-20-2000u-disp-hydrometer-bouy	%	0	100
671	Silt texture fraction	SaSiCl_2-20-2000u-disp-hydrometer-bouy	%	0	100
624	Clay texture fraction	SaSiCl_2-20-2000u-disp-laser	%	0	100
576	Sand texture fraction	SaSiCl_2-20-2000u-disp-laser	%	0	100
672	Silt texture fraction	SaSiCl_2-20-2000u-disp-laser	%	0	100
625	Clay texture fraction	SaSiCl_2-20-2000u-disp-pipette	%	0	100
577	Sand texture fraction	SaSiCl_2-20-2000u-disp-pipette	%	0	100
673	Silt texture fraction	SaSiCl_2-20-2000u-disp-pipette	%	0	100
626	Clay texture fraction	SaSiCl_2-20-2000u-disp-spec	%	0	100
578	Sand texture fraction	SaSiCl_2-20-2000u-disp-spec	%	0	100
493	Nitrogen (N) - total	TotalN_dc-ht-dumas	g/kg	0	1000
494	Nitrogen (N) - total	TotalN_dc-ht-leco	g/kg	0	1000
495	Nitrogen (N) - total	TotalN_dc-spec	g/kg	0	1000
69	electricalConductivityProperty	EC_ratio1-2	dS/m	0	60
674	Silt texture fraction	SaSiCl_2-20-2000u-disp-spec	%	0	100
706	Silt texture fraction	SaSiCl_2-64-2000u-disp-spec	%	0	100
659	Clay texture fraction	SaSiCl_2-64-2000u-fld	%	0	100
611	Sand texture fraction	SaSiCl_2-64-2000u-fld	%	0	100
707	Silt texture fraction	SaSiCl_2-64-2000u-fld	%	0	100
8	Available water capacity - volumetric (FC to WP)	PAWHC_calcul-fc100wp	m³/100 m³	0	100
9	Available water capacity - volumetric (FC to WP)	PAWHC_calcul-fc200wp	m³/100 m³	0	100
10	Available water capacity - volumetric (FC to WP)	PAWHC_calcul-fc300wp	m³/100 m³	0	100
31	carbonInorganicProperty	InOrgC_calcul-caco3	g/kg	0	1000
32	carbonInorganicProperty	InOrgC_calcul-tc-oc	g/kg	0	1000
33	Carbon (C) - organic	OrgC_acid-dc	g/kg	0	1000
34	Carbon (C) - organic	OrgC_acid-dc-ht	g/kg	0	1000
35	Carbon (C) - organic	OrgC_acid-dc-ht-analyser	g/kg	0	1000
36	Carbon (C) - organic	OrgC_acid-dc-lt	g/kg	0	1000
37	Carbon (C) - organic	OrgC_acid-dc-lt-loi	g/kg	0	1000
38	Carbon (C) - organic	OrgC_acid-dc-mt	g/kg	0	1000
39	Carbon (C) - organic	OrgC_acid-dc-spec	g/kg	0	1000
40	Carbon (C) - organic	OrgC_calcul-tc-ic	g/kg	0	1000
41	Carbon (C) - organic	OrgC_dc	g/kg	0	1000
42	Carbon (C) - organic	OrgC_dc-ht	g/kg	0	1000
43	Carbon (C) - organic	OrgC_dc-ht-analyser	g/kg	0	1000
44	Carbon (C) - organic	OrgC_dc-lt	g/kg	0	1000
45	Carbon (C) - organic	OrgC_dc-lt-loi	g/kg	0	1000
46	Carbon (C) - organic	OrgC_dc-mt	g/kg	0	1000
47	Carbon (C) - organic	OrgC_dc-spec	g/kg	0	1000
48	Carbon (C) - organic	OrgC_wc	g/kg	0	1000
49	Carbon (C) - organic	OrgC_wc-cro3-jackson	g/kg	0	1000
50	Carbon (C) - organic	OrgC_wc-cro3-kalembra	g/kg	0	1000
51	Carbon (C) - organic	OrgC_wc-cro3-knopp	g/kg	0	1000
52	Carbon (C) - organic	OrgC_wc-cro3-kurmies	g/kg	0	1000
53	Carbon (C) - organic	OrgC_wc-cro3-nelson	g/kg	0	1000
13	bulkDensityFineEarthProperty	BlkDensF_fe-cl-fc	kg/dm³	0.01	2.65
14	bulkDensityFineEarthProperty	BlkDensF_fe-cl-od	kg/dm³	0.01	2.65
15	bulkDensityFineEarthProperty	BlkDensF_fe-cl-unkn	kg/dm³	0.01	2.65
16	bulkDensityFineEarthProperty	BlkDensF_fe-co-fc	kg/dm³	0.01	2.65
17	bulkDensityFineEarthProperty	BlkDensF_fe-co-od	kg/dm³	0.01	2.65
18	bulkDensityFineEarthProperty	BlkDensF_fe-co-unkn	kg/dm³	0.01	2.65
19	bulkDensityFineEarthProperty	BlkDensF_fe-rpl-unkn	kg/dm³	0.01	2.65
20	bulkDensityFineEarthProperty	BlkDensF_fe-unkn	kg/dm³	0.01	2.65
21	bulkDensityFineEarthProperty	BlkDensF_fe-unkn-fc	kg/dm³	0.01	2.65
22	bulkDensityFineEarthProperty	BlkDensF_fe-unkn-od	kg/dm³	0.01	2.65
1	Acidity - exchangeable	ExchAcid_ph0-kcl1m	cmol/kg	0	100
2	Acidity - exchangeable	ExchAcid_ph0-nh4cl	cmol/kg	0	100
3	Acidity - exchangeable	ExchAcid_ph0-unkn	cmol/kg	0	100
4	Acidity - exchangeable	ExchAcid_ph7-caoac	cmol/kg	0	100
5	Acidity - exchangeable	ExchAcid_ph7-unkn	cmol/kg	0	100
6	Acidity - exchangeable	ExchAcid_ph8-bacl2tea	cmol/kg	0	100
7	Acidity - exchangeable	ExchAcid_ph8-unkn	cmol/kg	0	100
95	Hydrogen (H+) - exchangeable	ExchBases_ph-unkn-edta	cmol/kg	0	100
65	effectiveCecProperty	EffCEC_calcul-b	cmol/kg	0	100
66	effectiveCecProperty	EffCEC_calcul-ba	cmol/kg	0	100
23	bulkDensityWholeSoilProperty	BlkDensW_we-cl-fc	kg/dm³	0.01	3.6
24	bulkDensityWholeSoilProperty	BlkDensW_we-cl-od	kg/dm³	0.01	3.6
25	bulkDensityWholeSoilProperty	BlkDensW_we-cl-unkn	kg/dm³	0.01	3.6
26	bulkDensityWholeSoilProperty	BlkDensW_we-co-fc	kg/dm³	0.01	3.6
27	bulkDensityWholeSoilProperty	BlkDensW_we-co-od	kg/dm³	0.01	3.6
28	bulkDensityWholeSoilProperty	BlkDensW_we-co-unkn	kg/dm³	0.01	3.6
29	bulkDensityWholeSoilProperty	BlkDensW_we-rpl-unkn	kg/dm³	0.01	3.6
30	bulkDensityWholeSoilProperty	BlkDensW_we-unkn	kg/dm³	0.01	3.6
73	manganeseProperty	ExchBases_ph-unkn-edta	cmol/kg	0	1000
139	Magnesium (Mg++) - exchangeable	ExchBases_ph-unkn-edta	cmol/kg	0	100
106	Potassium (K+) - exchangeable	ExchBases_ph-unkn-edta	cmol/kg	0	100
117	Aluminium (Al+++) - exchangeable	ExchBases_ph-unkn-edta	cmol/kg	0	100
84	Sodium (Na+) - exchangeable	ExchBases_ph-unkn-edta	cmol/kg	0	100
251	Magnesium (Mg) - extractable	Extr_ap15	cmol/kg	0	1000
151	Manganese (Mn) - extractable	Extr_ap15	cmol/kg	0	1000
226	Potassium (K) - extractable	Extr_ap15	cmol/kg	0	1000
376	Sodium (Na) - extractable	Extr_ap15	cmol/kg	0	1000
326	Calcium (Ca++) - extractable	Extr_ap15	cmol/kg	0	1000
252	Magnesium (Mg) - extractable	Extr_ap20	cmol/kg	0	1000
152	Manganese (Mn) - extractable	Extr_ap20	cmol/kg	0	1000
227	Potassium (K) - extractable	Extr_ap20	cmol/kg	0	1000
377	Sodium (Na) - extractable	Extr_ap20	cmol/kg	0	1000
327	Calcium (Ca++) - extractable	Extr_ap20	cmol/kg	0	1000
253	Magnesium (Mg) - extractable	Extr_ap21	cmol/kg	0	1000
153	Manganese (Mn) - extractable	Extr_ap21	cmol/kg	0	1000
228	Potassium (K) - extractable	Extr_ap21	cmol/kg	0	1000
378	Sodium (Na) - extractable	Extr_ap21	cmol/kg	0	1000
328	Calcium (Ca++) - extractable	Extr_ap21	cmol/kg	0	1000
254	Magnesium (Mg) - extractable	Extr_c6h8o7-reeuwijk	cmol/kg	0	1000
154	Manganese (Mn) - extractable	Extr_c6h8o7-reeuwijk	cmol/kg	0	1000
229	Potassium (K) - extractable	Extr_c6h8o7-reeuwijk	cmol/kg	0	1000
379	Sodium (Na) - extractable	Extr_c6h8o7-reeuwijk	cmol/kg	0	1000
329	Calcium (Ca++) - extractable	Extr_c6h8o7-reeuwijk	cmol/kg	0	1000
255	Magnesium (Mg) - extractable	Extr_cacl2	cmol/kg	0	1000
155	Manganese (Mn) - extractable	Extr_cacl2	cmol/kg	0	1000
230	Potassium (K) - extractable	Extr_cacl2	cmol/kg	0	1000
380	Sodium (Na) - extractable	Extr_cacl2	cmol/kg	0	1000
330	Calcium (Ca++) - extractable	Extr_cacl2	cmol/kg	0	1000
256	Magnesium (Mg) - extractable	Extr_capo4	cmol/kg	0	1000
156	Manganese (Mn) - extractable	Extr_capo4	cmol/kg	0	1000
231	Potassium (K) - extractable	Extr_capo4	cmol/kg	0	1000
381	Sodium (Na) - extractable	Extr_capo4	cmol/kg	0	1000
331	Calcium (Ca++) - extractable	Extr_capo4	cmol/kg	0	1000
257	Magnesium (Mg) - extractable	Extr_dtpa	cmol/kg	0	1000
157	Manganese (Mn) - extractable	Extr_dtpa	cmol/kg	0	1000
232	Potassium (K) - extractable	Extr_dtpa	cmol/kg	0	1000
382	Sodium (Na) - extractable	Extr_dtpa	cmol/kg	0	1000
332	Calcium (Ca++) - extractable	Extr_dtpa	cmol/kg	0	1000
258	Magnesium (Mg) - extractable	Extr_edta	cmol/kg	0	1000
158	Manganese (Mn) - extractable	Extr_edta	cmol/kg	0	1000
233	Potassium (K) - extractable	Extr_edta	cmol/kg	0	1000
383	Sodium (Na) - extractable	Extr_edta	cmol/kg	0	1000
333	Calcium (Ca++) - extractable	Extr_edta	cmol/kg	0	1000
259	Magnesium (Mg) - extractable	Extr_h2so4-truog	cmol/kg	0	1000
159	Manganese (Mn) - extractable	Extr_h2so4-truog	cmol/kg	0	1000
234	Potassium (K) - extractable	Extr_h2so4-truog	cmol/kg	0	1000
384	Sodium (Na) - extractable	Extr_h2so4-truog	cmol/kg	0	1000
334	Calcium (Ca++) - extractable	Extr_h2so4-truog	cmol/kg	0	1000
260	Magnesium (Mg) - extractable	Extr_hcl-h2so4-nelson	cmol/kg	0	1000
160	Manganese (Mn) - extractable	Extr_hcl-h2so4-nelson	cmol/kg	0	1000
235	Potassium (K) - extractable	Extr_hcl-h2so4-nelson	cmol/kg	0	1000
385	Sodium (Na) - extractable	Extr_hcl-h2so4-nelson	cmol/kg	0	1000
335	Calcium (Ca++) - extractable	Extr_hcl-h2so4-nelson	cmol/kg	0	1000
261	Magnesium (Mg) - extractable	Extr_hcl-nh4f-bray1	cmol/kg	0	1000
161	Manganese (Mn) - extractable	Extr_hcl-nh4f-bray1	cmol/kg	0	1000
236	Potassium (K) - extractable	Extr_hcl-nh4f-bray1	cmol/kg	0	1000
386	Sodium (Na) - extractable	Extr_hcl-nh4f-bray1	cmol/kg	0	1000
336	Calcium (Ca++) - extractable	Extr_hcl-nh4f-bray1	cmol/kg	0	1000
262	Magnesium (Mg) - extractable	Extr_hcl-nh4f-bray2	cmol/kg	0	1000
162	Manganese (Mn) - extractable	Extr_hcl-nh4f-bray2	cmol/kg	0	1000
237	Potassium (K) - extractable	Extr_hcl-nh4f-bray2	cmol/kg	0	1000
387	Sodium (Na) - extractable	Extr_hcl-nh4f-bray2	cmol/kg	0	1000
337	Calcium (Ca++) - extractable	Extr_hcl-nh4f-bray2	cmol/kg	0	1000
263	Magnesium (Mg) - extractable	Extr_hcl-nh4f-kurtz-bray	cmol/kg	0	1000
163	Manganese (Mn) - extractable	Extr_hcl-nh4f-kurtz-bray	cmol/kg	0	1000
238	Potassium (K) - extractable	Extr_hcl-nh4f-kurtz-bray	cmol/kg	0	1000
388	Sodium (Na) - extractable	Extr_hcl-nh4f-kurtz-bray	cmol/kg	0	1000
338	Calcium (Ca++) - extractable	Extr_hcl-nh4f-kurtz-bray	cmol/kg	0	1000
264	Magnesium (Mg) - extractable	Extr_hno3	cmol/kg	0	1000
164	Manganese (Mn) - extractable	Extr_hno3	cmol/kg	0	1000
239	Potassium (K) - extractable	Extr_hno3	cmol/kg	0	1000
389	Sodium (Na) - extractable	Extr_hno3	cmol/kg	0	1000
339	Calcium (Ca++) - extractable	Extr_hno3	cmol/kg	0	1000
265	Magnesium (Mg) - extractable	Extr_hotwater	cmol/kg	0	1000
165	Manganese (Mn) - extractable	Extr_hotwater	cmol/kg	0	1000
240	Potassium (K) - extractable	Extr_hotwater	cmol/kg	0	1000
390	Sodium (Na) - extractable	Extr_hotwater	cmol/kg	0	1000
340	Calcium (Ca++) - extractable	Extr_hotwater	cmol/kg	0	1000
266	Magnesium (Mg) - extractable	Extr_m1	cmol/kg	0	1000
166	Manganese (Mn) - extractable	Extr_m1	cmol/kg	0	1000
241	Potassium (K) - extractable	Extr_m1	cmol/kg	0	1000
391	Sodium (Na) - extractable	Extr_m1	cmol/kg	0	1000
341	Calcium (Ca++) - extractable	Extr_m1	cmol/kg	0	1000
267	Magnesium (Mg) - extractable	Extr_m2	cmol/kg	0	1000
167	Manganese (Mn) - extractable	Extr_m2	cmol/kg	0	1000
242	Potassium (K) - extractable	Extr_m2	cmol/kg	0	1000
392	Sodium (Na) - extractable	Extr_m2	cmol/kg	0	1000
342	Calcium (Ca++) - extractable	Extr_m2	cmol/kg	0	1000
268	Magnesium (Mg) - extractable	Extr_m3	cmol/kg	0	1000
168	Manganese (Mn) - extractable	Extr_m3	cmol/kg	0	1000
243	Potassium (K) - extractable	Extr_m3	cmol/kg	0	1000
393	Sodium (Na) - extractable	Extr_m3	cmol/kg	0	1000
343	Calcium (Ca++) - extractable	Extr_m3	cmol/kg	0	1000
269	Magnesium (Mg) - extractable	Extr_m3-spec	cmol/kg	0	1000
169	Manganese (Mn) - extractable	Extr_m3-spec	cmol/kg	0	1000
244	Potassium (K) - extractable	Extr_m3-spec	cmol/kg	0	1000
394	Sodium (Na) - extractable	Extr_m3-spec	cmol/kg	0	1000
344	Calcium (Ca++) - extractable	Extr_m3-spec	cmol/kg	0	1000
270	Magnesium (Mg) - extractable	Extr_nahco3-olsen	cmol/kg	0	1000
170	Manganese (Mn) - extractable	Extr_nahco3-olsen	cmol/kg	0	1000
245	Potassium (K) - extractable	Extr_nahco3-olsen	cmol/kg	0	1000
395	Sodium (Na) - extractable	Extr_nahco3-olsen	cmol/kg	0	1000
345	Calcium (Ca++) - extractable	Extr_nahco3-olsen	cmol/kg	0	1000
271	Magnesium (Mg) - extractable	Extr_nahco3-olsen-dabin	cmol/kg	0	1000
171	Manganese (Mn) - extractable	Extr_nahco3-olsen-dabin	cmol/kg	0	1000
246	Potassium (K) - extractable	Extr_nahco3-olsen-dabin	cmol/kg	0	1000
396	Sodium (Na) - extractable	Extr_nahco3-olsen-dabin	cmol/kg	0	1000
346	Calcium (Ca++) - extractable	Extr_nahco3-olsen-dabin	cmol/kg	0	1000
272	Magnesium (Mg) - extractable	Extr_naoac-morgan	cmol/kg	0	1000
172	Manganese (Mn) - extractable	Extr_naoac-morgan	cmol/kg	0	1000
247	Potassium (K) - extractable	Extr_naoac-morgan	cmol/kg	0	1000
397	Sodium (Na) - extractable	Extr_naoac-morgan	cmol/kg	0	1000
347	Calcium (Ca++) - extractable	Extr_naoac-morgan	cmol/kg	0	1000
273	Magnesium (Mg) - extractable	Extr_nh4-co3-2-ambic1	cmol/kg	0	1000
173	Manganese (Mn) - extractable	Extr_nh4-co3-2-ambic1	cmol/kg	0	1000
248	Potassium (K) - extractable	Extr_nh4-co3-2-ambic1	cmol/kg	0	1000
398	Sodium (Na) - extractable	Extr_nh4-co3-2-ambic1	cmol/kg	0	1000
348	Calcium (Ca++) - extractable	Extr_nh4-co3-2-ambic1	cmol/kg	0	1000
274	Magnesium (Mg) - extractable	Extr_nh4ch3ch-oh-cooh-leuven	cmol/kg	0	1000
174	Manganese (Mn) - extractable	Extr_nh4ch3ch-oh-cooh-leuven	cmol/kg	0	1000
249	Potassium (K) - extractable	Extr_nh4ch3ch-oh-cooh-leuven	cmol/kg	0	1000
399	Sodium (Na) - extractable	Extr_nh4ch3ch-oh-cooh-leuven	cmol/kg	0	1000
299	Sulfur (S) - extractable	Extr_nh4ch3ch-oh-cooh-leuven	%	0	100
424	Zinc (Zn) - extractable	Extr_nh4ch3ch-oh-cooh-leuven	%	0	100
449	cadmiumProperty	Extr_nh4ch3ch-oh-cooh-leuven	%	0	100
224	molybdenumProperty	Extr_nh4ch3ch-oh-cooh-leuven	%	0	100
482	hydraulicConductivityProperty	KSat_calcul-ptf	cm/h	0	100
483	hydraulicConductivityProperty	KSat_calcul-ptf-genuchten	cm/h	0	100
484	hydraulicConductivityProperty	KSat_calcul-ptf-saxton	cm/h	0	100
485	hydraulicConductivityProperty	Ksat_bhole	cm/h	0	100
486	hydraulicConductivityProperty	Ksat_column	cm/h	0	100
487	hydraulicConductivityProperty	Ksat_dblring	cm/h	0	100
488	hydraulicConductivityProperty	Ksat_invbhole	cm/h	0	100
565	Phosphorus (P) - retention	RetentP_blakemore	g/hg	0	100
566	Phosphorus (P) - retention	RetentP_unkn-spec	g/hg	0	100
567	porosityProperty	Poros_calcul-pf0	m³/100 m³	0	100
489	Nitrogen (N) - total	TotalN_bremner	g/kg	0	1000
490	Nitrogen (N) - total	TotalN_calcul	g/kg	0	1000
491	Nitrogen (N) - total	TotalN_calcul-oc10	g/kg	0	1000
492	Nitrogen (N) - total	TotalN_dc	g/kg	0	1000
496	Nitrogen (N) - total	TotalN_h2so4	g/kg	0	1000
497	Nitrogen (N) - total	TotalN_kjeldahl	g/kg	0	1000
498	Nitrogen (N) - total	TotalN_kjeldahl-nh4	g/kg	0	1000
499	Nitrogen (N) - total	TotalN_nelson	g/kg	0	1000
500	Nitrogen (N) - total	TotalN_tn04	g/kg	0	1000
501	Nitrogen (N) - total	TotalN_tn06	g/kg	0	1000
502	Nitrogen (N) - total	TotalN_tn08	g/kg	0	1000
503	organicMatterProperty	FulAcidC_unkn	g/kg	0	1000
504	organicMatterProperty	HumAcidC_unkn	g/kg	0	1000
505	organicMatterProperty	OrgM_calcul-oc1.73	g/kg	0	1000
506	organicMatterProperty	TotHumC_unkn	g/kg	0	1000
568	solubleSaltsProperty	SlbAn_calcul-unkn	cmol/L	0	1000
569	solubleSaltsProperty	SlbCat_calcul-unkn	cmol/L	0	1000
349	Calcium (Ca++) - extractable	Extr_nh4ch3ch-oh-cooh-leuven	cmol/kg	0	1000
951	Calcium (Ca++) - total	Total_h2so4	cmol/kg	0	1000
761	Magnesium (Mg) - total	Total_h2so4	cmol/kg	0	1000
989	Manganese (Mn) - total	Total_h2so4	cmol/kg	0	1000
742	Potassium (K) - total	Total_h2so4	cmol/kg	0	1000
970	Sodium (Na) - total	Total_h2so4	cmol/kg	0	1000
952	Calcium (Ca++) - total	Total_hcl	cmol/kg	0	1000
762	Magnesium (Mg) - total	Total_hcl	cmol/kg	0	1000
990	Manganese (Mn) - total	Total_hcl	cmol/kg	0	1000
743	Potassium (K) - total	Total_hcl	cmol/kg	0	1000
971	Sodium (Na) - total	Total_hcl	cmol/kg	0	1000
953	Calcium (Ca++) - total	Total_hcl-aquaregia	cmol/kg	0	1000
763	Magnesium (Mg) - total	Total_hcl-aquaregia	cmol/kg	0	1000
991	Manganese (Mn) - total	Total_hcl-aquaregia	cmol/kg	0	1000
744	Potassium (K) - total	Total_hcl-aquaregia	cmol/kg	0	1000
972	Sodium (Na) - total	Total_hcl-aquaregia	cmol/kg	0	1000
954	Calcium (Ca++) - total	Total_hclo4	cmol/kg	0	1000
764	Magnesium (Mg) - total	Total_hclo4	cmol/kg	0	1000
992	Manganese (Mn) - total	Total_hclo4	cmol/kg	0	1000
745	Potassium (K) - total	Total_hclo4	cmol/kg	0	1000
973	Sodium (Na) - total	Total_hclo4	cmol/kg	0	1000
955	Calcium (Ca++) - total	Total_hno3-aquafortis	cmol/kg	0	1000
765	Magnesium (Mg) - total	Total_hno3-aquafortis	cmol/kg	0	1000
993	Manganese (Mn) - total	Total_hno3-aquafortis	cmol/kg	0	1000
746	Potassium (K) - total	Total_hno3-aquafortis	cmol/kg	0	1000
974	Sodium (Na) - total	Total_hno3-aquafortis	cmol/kg	0	1000
956	Calcium (Ca++) - total	Total_nh4-6mo7o24	cmol/kg	0	1000
766	Magnesium (Mg) - total	Total_nh4-6mo7o24	cmol/kg	0	1000
994	Manganese (Mn) - total	Total_nh4-6mo7o24	cmol/kg	0	1000
747	Potassium (K) - total	Total_nh4-6mo7o24	cmol/kg	0	1000
975	Sodium (Na) - total	Total_nh4-6mo7o24	cmol/kg	0	1000
957	Calcium (Ca++) - total	Total_tp03	cmol/kg	0	1000
767	Magnesium (Mg) - total	Total_tp03	cmol/kg	0	1000
995	Manganese (Mn) - total	Total_tp03	cmol/kg	0	1000
748	Potassium (K) - total	Total_tp03	cmol/kg	0	1000
976	Sodium (Na) - total	Total_tp03	cmol/kg	0	1000
958	Calcium (Ca++) - total	Total_tp04	cmol/kg	0	1000
768	Magnesium (Mg) - total	Total_tp04	cmol/kg	0	1000
996	Manganese (Mn) - total	Total_tp04	cmol/kg	0	1000
749	Potassium (K) - total	Total_tp04	cmol/kg	0	1000
977	Sodium (Na) - total	Total_tp04	cmol/kg	0	1000
959	Calcium (Ca++) - total	Total_tp05	cmol/kg	0	1000
769	Magnesium (Mg) - total	Total_tp05	cmol/kg	0	1000
997	Manganese (Mn) - total	Total_tp05	cmol/kg	0	1000
750	Potassium (K) - total	Total_tp05	cmol/kg	0	1000
978	Sodium (Na) - total	Total_tp05	cmol/kg	0	1000
960	Calcium (Ca++) - total	Total_tp06	cmol/kg	0	1000
770	Magnesium (Mg) - total	Total_tp06	cmol/kg	0	1000
998	Manganese (Mn) - total	Total_tp06	cmol/kg	0	1000
751	Potassium (K) - total	Total_tp06	cmol/kg	0	1000
979	Sodium (Na) - total	Total_tp06	cmol/kg	0	1000
961	Calcium (Ca++) - total	Total_tp07	cmol/kg	0	1000
771	Magnesium (Mg) - total	Total_tp07	cmol/kg	0	1000
999	Manganese (Mn) - total	Total_tp07	cmol/kg	0	1000
752	Potassium (K) - total	Total_tp07	cmol/kg	0	1000
980	Sodium (Na) - total	Total_tp07	cmol/kg	0	1000
962	Calcium (Ca++) - total	Total_tp08	cmol/kg	0	1000
772	Magnesium (Mg) - total	Total_tp08	cmol/kg	0	1000
1000	Manganese (Mn) - total	Total_tp08	cmol/kg	0	1000
753	Potassium (K) - total	Total_tp08	cmol/kg	0	1000
981	Sodium (Na) - total	Total_tp08	cmol/kg	0	1000
963	Calcium (Ca++) - total	Total_tp09	cmol/kg	0	1000
773	Magnesium (Mg) - total	Total_tp09	cmol/kg	0	1000
1001	Manganese (Mn) - total	Total_tp09	cmol/kg	0	1000
754	Potassium (K) - total	Total_tp09	cmol/kg	0	1000
982	Sodium (Na) - total	Total_tp09	cmol/kg	0	1000
964	Calcium (Ca++) - total	Total_tp10	cmol/kg	0	1000
774	Magnesium (Mg) - total	Total_tp10	cmol/kg	0	1000
1002	Manganese (Mn) - total	Total_tp10	cmol/kg	0	1000
755	Potassium (K) - total	Total_tp10	cmol/kg	0	1000
983	Sodium (Na) - total	Total_tp10	cmol/kg	0	1000
965	Calcium (Ca++) - total	Total_unkn	cmol/kg	0	1000
775	Magnesium (Mg) - total	Total_unkn	cmol/kg	0	1000
1003	Manganese (Mn) - total	Total_unkn	cmol/kg	0	1000
756	Potassium (K) - total	Total_unkn	cmol/kg	0	1000
984	Sodium (Na) - total	Total_unkn	cmol/kg	0	1000
966	Calcium (Ca++) - total	Total_xrd	cmol/kg	0	1000
776	Magnesium (Mg) - total	Total_xrd	cmol/kg	0	1000
1004	Manganese (Mn) - total	Total_xrd	cmol/kg	0	1000
757	Potassium (K) - total	Total_xrd	cmol/kg	0	1000
985	Sodium (Na) - total	Total_xrd	cmol/kg	0	1000
967	Calcium (Ca++) - total	Total_xrf	cmol/kg	0	1000
777	Magnesium (Mg) - total	Total_xrf	cmol/kg	0	1000
1005	Manganese (Mn) - total	Total_xrf	cmol/kg	0	1000
758	Potassium (K) - total	Total_xrf	cmol/kg	0	1000
986	Sodium (Na) - total	Total_xrf	cmol/kg	0	1000
968	Calcium (Ca++) - total	Total_xrf-p	cmol/kg	0	1000
778	Magnesium (Mg) - total	Total_xrf-p	cmol/kg	0	1000
1006	Manganese (Mn) - total	Total_xrf-p	cmol/kg	0	1000
759	Potassium (K) - total	Total_xrf-p	cmol/kg	0	1000
987	Sodium (Na) - total	Total_xrf-p	cmol/kg	0	1000
549	pHProperty	pHH2O_sat	pH	1.5	13
521	pH - Hydrogen potential	pHH2O_unkn-spec	pH	1.5	13
550	pHProperty	pHH2O_unkn-spec	pH	1.5	13
523	pH - Hydrogen potential	pHKCl_ratio1-1	pH	1.5	13
552	pHProperty	pHKCl_ratio1-1	pH	1.5	13
524	pH - Hydrogen potential	pHKCl_ratio1-10	pH	1.5	13
553	pHProperty	pHKCl_ratio1-10	pH	1.5	13
525	pH - Hydrogen potential	pHKCl_ratio1-2	pH	1.5	13
554	pHProperty	pHKCl_ratio1-2	pH	1.5	13
526	pH - Hydrogen potential	pHKCl_ratio1-2.5	pH	1.5	13
555	pHProperty	pHKCl_ratio1-2.5	pH	1.5	13
527	pH - Hydrogen potential	pHKCl_ratio1-5	pH	1.5	13
556	pHProperty	pHKCl_ratio1-5	pH	1.5	13
530	pH - Hydrogen potential	pHNaF_ratio1-1	pH	1.5	13
559	pHProperty	pHNaF_ratio1-1	pH	1.5	13
531	pH - Hydrogen potential	pHNaF_ratio1-10	pH	1.5	13
560	pHProperty	pHNaF_ratio1-10	pH	1.5	13
532	pH - Hydrogen potential	pHNaF_ratio1-2	pH	1.5	13
561	pHProperty	pHNaF_ratio1-2	pH	1.5	13
533	pH - Hydrogen potential	pHNaF_ratio1-2.5	pH	1.5	13
562	pHProperty	pHNaF_ratio1-2.5	pH	1.5	13
534	pH - Hydrogen potential	pHNaF_ratio1-5	pH	1.5	13
563	pHProperty	pHNaF_ratio1-5	pH	1.5	13
535	pH - Hydrogen potential	pHNaF_sat	pH	1.5	13
564	pHProperty	pHNaF_sat	pH	1.5	13
507	pH - Hydrogen potential	pHCaCl2	pH	1.5	13
536	pHProperty	pHCaCl2	pH	1.5	13
522	pH - Hydrogen potential	pHKCl	pH	1.5	13
551	pHProperty	pHKCl	pH	1.5	13
528	pH - Hydrogen potential	pHKCl_sat	pH	1.5	13
557	pHProperty	pHKCl_sat	pH	1.5	13
529	pH - Hydrogen potential	pHNaF	pH	1.5	13
558	pHProperty	pHNaF	pH	1.5	13
67	electricalConductivityProperty	EC_ratio1-1	dS/m	0	60
68	electricalConductivityProperty	EC_ratio1-10	dS/m	0	60
70	electricalConductivityProperty	EC_ratio1-2.5	dS/m	0	60
71	electricalConductivityProperty	EC_ratio1-5	dS/m	0	60
72	electricalConductivityProperty	ECe_sat	dS/m	0	60
627	Clay texture fraction	SaSiCl_2-20-2000u-fld	%	0	100
579	Sand texture fraction	SaSiCl_2-20-2000u-fld	%	0	100
675	Silt texture fraction	SaSiCl_2-20-2000u-fld	%	0	100
628	Clay texture fraction	SaSiCl_2-20-2000u-nodisp	%	0	100
580	Sand texture fraction	SaSiCl_2-20-2000u-nodisp	%	0	100
676	Silt texture fraction	SaSiCl_2-20-2000u-nodisp	%	0	100
629	Clay texture fraction	SaSiCl_2-20-2000u-nodisp-hydrometer	%	0	100
581	Sand texture fraction	SaSiCl_2-20-2000u-nodisp-hydrometer	%	0	100
677	Silt texture fraction	SaSiCl_2-20-2000u-nodisp-hydrometer	%	0	100
630	Clay texture fraction	SaSiCl_2-20-2000u-nodisp-hydrometer-bouy	%	0	100
582	Sand texture fraction	SaSiCl_2-20-2000u-nodisp-hydrometer-bouy	%	0	100
678	Silt texture fraction	SaSiCl_2-20-2000u-nodisp-hydrometer-bouy	%	0	100
631	Clay texture fraction	SaSiCl_2-20-2000u-nodisp-laser	%	0	100
583	Sand texture fraction	SaSiCl_2-20-2000u-nodisp-laser	%	0	100
679	Silt texture fraction	SaSiCl_2-20-2000u-nodisp-laser	%	0	100
632	Clay texture fraction	SaSiCl_2-20-2000u-nodisp-pipette	%	0	100
584	Sand texture fraction	SaSiCl_2-20-2000u-nodisp-pipette	%	0	100
680	Silt texture fraction	SaSiCl_2-20-2000u-nodisp-pipette	%	0	100
633	Clay texture fraction	SaSiCl_2-20-2000u-nodisp-spec	%	0	100
585	Sand texture fraction	SaSiCl_2-20-2000u-nodisp-spec	%	0	100
681	Silt texture fraction	SaSiCl_2-20-2000u-nodisp-spec	%	0	100
636	Clay texture fraction	SaSiCl_2-50-2000u-disp	%	0	100
588	Sand texture fraction	SaSiCl_2-50-2000u-disp	%	0	100
684	Silt texture fraction	SaSiCl_2-50-2000u-disp	%	0	100
637	Clay texture fraction	SaSiCl_2-50-2000u-disp-beaker	%	0	100
589	Sand texture fraction	SaSiCl_2-50-2000u-disp-beaker	%	0	100
685	Silt texture fraction	SaSiCl_2-50-2000u-disp-beaker	%	0	100
638	Clay texture fraction	SaSiCl_2-50-2000u-disp-hydrometer	%	0	100
590	Sand texture fraction	SaSiCl_2-50-2000u-disp-hydrometer	%	0	100
686	Silt texture fraction	SaSiCl_2-50-2000u-disp-hydrometer	%	0	100
639	Clay texture fraction	SaSiCl_2-50-2000u-disp-hydrometer-bouy	%	0	100
591	Sand texture fraction	SaSiCl_2-50-2000u-disp-hydrometer-bouy	%	0	100
687	Silt texture fraction	SaSiCl_2-50-2000u-disp-hydrometer-bouy	%	0	100
640	Clay texture fraction	SaSiCl_2-50-2000u-disp-laser	%	0	100
592	Sand texture fraction	SaSiCl_2-50-2000u-disp-laser	%	0	100
688	Silt texture fraction	SaSiCl_2-50-2000u-disp-laser	%	0	100
641	Clay texture fraction	SaSiCl_2-50-2000u-disp-pipette	%	0	100
593	Sand texture fraction	SaSiCl_2-50-2000u-disp-pipette	%	0	100
873	zincProperty	Total_xrf-p	%	0	100
969	Calcium (Ca++) - total	Total_xtf-t	cmol/kg	0	1000
779	Magnesium (Mg) - total	Total_xtf-t	cmol/kg	0	1000
1007	Manganese (Mn) - total	Total_xtf-t	cmol/kg	0	1000
760	Potassium (K) - total	Total_xtf-t	cmol/kg	0	1000
988	Sodium (Na) - total	Total_xtf-t	cmol/kg	0	1000
689	Silt texture fraction	SaSiCl_2-50-2000u-disp-pipette	%	0	100
642	Clay texture fraction	SaSiCl_2-50-2000u-disp-spec	%	0	100
594	Sand texture fraction	SaSiCl_2-50-2000u-disp-spec	%	0	100
690	Silt texture fraction	SaSiCl_2-50-2000u-disp-spec	%	0	100
643	Clay texture fraction	SaSiCl_2-50-2000u-fld	%	0	100
595	Sand texture fraction	SaSiCl_2-50-2000u-fld	%	0	100
691	Silt texture fraction	SaSiCl_2-50-2000u-fld	%	0	100
644	Clay texture fraction	SaSiCl_2-50-2000u-nodisp	%	0	100
596	Sand texture fraction	SaSiCl_2-50-2000u-nodisp	%	0	100
692	Silt texture fraction	SaSiCl_2-50-2000u-nodisp	%	0	100
645	Clay texture fraction	SaSiCl_2-50-2000u-nodisp-hydrometer	%	0	100
597	Sand texture fraction	SaSiCl_2-50-2000u-nodisp-hydrometer	%	0	100
693	Silt texture fraction	SaSiCl_2-50-2000u-nodisp-hydrometer	%	0	100
646	Clay texture fraction	SaSiCl_2-50-2000u-nodisp-hydrometer-bouy	%	0	100
598	Sand texture fraction	SaSiCl_2-50-2000u-nodisp-hydrometer-bouy	%	0	100
694	Silt texture fraction	SaSiCl_2-50-2000u-nodisp-hydrometer-bouy	%	0	100
647	Clay texture fraction	SaSiCl_2-50-2000u-nodisp-laser	%	0	100
599	Sand texture fraction	SaSiCl_2-50-2000u-nodisp-laser	%	0	100
695	Silt texture fraction	SaSiCl_2-50-2000u-nodisp-laser	%	0	100
648	Clay texture fraction	SaSiCl_2-50-2000u-nodisp-pipette	%	0	100
600	Sand texture fraction	SaSiCl_2-50-2000u-nodisp-pipette	%	0	100
696	Silt texture fraction	SaSiCl_2-50-2000u-nodisp-pipette	%	0	100
649	Clay texture fraction	SaSiCl_2-50-2000u-nodisp-spec	%	0	100
601	Sand texture fraction	SaSiCl_2-50-2000u-nodisp-spec	%	0	100
697	Silt texture fraction	SaSiCl_2-50-2000u-nodisp-spec	%	0	100
651	Clay texture fraction	SaSiCl_2-64-2000u-adj100	%	0	100
603	Sand texture fraction	SaSiCl_2-64-2000u-adj100	%	0	100
699	Silt texture fraction	SaSiCl_2-64-2000u-adj100	%	0	100
652	Clay texture fraction	SaSiCl_2-64-2000u-disp	%	0	100
604	Sand texture fraction	SaSiCl_2-64-2000u-disp	%	0	100
700	Silt texture fraction	SaSiCl_2-64-2000u-disp	%	0	100
653	Clay texture fraction	SaSiCl_2-64-2000u-disp-beaker	%	0	100
605	Sand texture fraction	SaSiCl_2-64-2000u-disp-beaker	%	0	100
701	Silt texture fraction	SaSiCl_2-64-2000u-disp-beaker	%	0	100
654	Clay texture fraction	SaSiCl_2-64-2000u-disp-hydrometer	%	0	100
606	Sand texture fraction	SaSiCl_2-64-2000u-disp-hydrometer	%	0	100
702	Silt texture fraction	SaSiCl_2-64-2000u-disp-hydrometer	%	0	100
655	Clay texture fraction	SaSiCl_2-64-2000u-disp-hydrometer-bouy	%	0	100
607	Sand texture fraction	SaSiCl_2-64-2000u-disp-hydrometer-bouy	%	0	100
703	Silt texture fraction	SaSiCl_2-64-2000u-disp-hydrometer-bouy	%	0	100
656	Clay texture fraction	SaSiCl_2-64-2000u-disp-laser	%	0	100
608	Sand texture fraction	SaSiCl_2-64-2000u-disp-laser	%	0	100
704	Silt texture fraction	SaSiCl_2-64-2000u-disp-laser	%	0	100
657	Clay texture fraction	SaSiCl_2-64-2000u-disp-pipette	%	0	100
609	Sand texture fraction	SaSiCl_2-64-2000u-disp-pipette	%	0	100
705	Silt texture fraction	SaSiCl_2-64-2000u-disp-pipette	%	0	100
658	Clay texture fraction	SaSiCl_2-64-2000u-disp-spec	%	0	100
610	Sand texture fraction	SaSiCl_2-64-2000u-disp-spec	%	0	100
351	Iron (Fe) - extractable	Extr_ap15	%	0	100
660	Clay texture fraction	SaSiCl_2-64-2000u-nodisp	%	0	100
612	Sand texture fraction	SaSiCl_2-64-2000u-nodisp	%	0	100
708	Silt texture fraction	SaSiCl_2-64-2000u-nodisp	%	0	100
661	Clay texture fraction	SaSiCl_2-64-2000u-nodisp-hydrometer	%	0	100
613	Sand texture fraction	SaSiCl_2-64-2000u-nodisp-hydrometer	%	0	100
709	Silt texture fraction	SaSiCl_2-64-2000u-nodisp-hydrometer	%	0	100
662	Clay texture fraction	SaSiCl_2-64-2000u-nodisp-hydrometer-bouy	%	0	100
614	Sand texture fraction	SaSiCl_2-64-2000u-nodisp-hydrometer-bouy	%	0	100
710	Silt texture fraction	SaSiCl_2-64-2000u-nodisp-hydrometer-bouy	%	0	100
663	Clay texture fraction	SaSiCl_2-64-2000u-nodisp-laser	%	0	100
615	Sand texture fraction	SaSiCl_2-64-2000u-nodisp-laser	%	0	100
711	Silt texture fraction	SaSiCl_2-64-2000u-nodisp-laser	%	0	100
664	Clay texture fraction	SaSiCl_2-64-2000u-nodisp-pipette	%	0	100
616	Sand texture fraction	SaSiCl_2-64-2000u-nodisp-pipette	%	0	100
712	Silt texture fraction	SaSiCl_2-64-2000u-nodisp-pipette	%	0	100
665	Clay texture fraction	SaSiCl_2-64-2000u-nodisp-spec	%	0	100
617	Sand texture fraction	SaSiCl_2-64-2000u-nodisp-spec	%	0	100
713	Silt texture fraction	SaSiCl_2-64-2000u-nodisp-spec	%	0	100
11	Base saturation - calculated	BSat_calcul-cec	%	0	100
12	Base saturation - calculated	BSat_calcul-ecec	%	0	100
62	coarseFragmentsProperty	CrsFrg_fld	%	0	100
63	coarseFragmentsProperty	CrsFrg_fldcls	%	0	100
64	coarseFragmentsProperty	CrsFrg_lab	%	0	100
191	Boron (B) - extractable	Extr_m1	%	0	100
300	Copper (Cu) - extractable	Extr_ap14	%	0	100
350	Iron (Fe) - extractable	Extr_ap14	%	0	100
450	Phosphorus (P) - extractable	Extr_ap14	%	0	100
275	Sulfur (S) - extractable	Extr_ap14	%	0	100
400	Zinc (Zn) - extractable	Extr_ap14	%	0	100
425	cadmiumProperty	Extr_ap14	%	0	100
200	molybdenumProperty	Extr_ap14	%	0	100
301	Copper (Cu) - extractable	Extr_ap15	%	0	100
451	Phosphorus (P) - extractable	Extr_ap15	%	0	100
276	Sulfur (S) - extractable	Extr_ap15	%	0	100
401	Zinc (Zn) - extractable	Extr_ap15	%	0	100
426	cadmiumProperty	Extr_ap15	%	0	100
201	molybdenumProperty	Extr_ap15	%	0	100
176	Boron (B) - extractable	Extr_ap15	%	0	100
302	Copper (Cu) - extractable	Extr_ap20	%	0	100
352	Iron (Fe) - extractable	Extr_ap20	%	0	100
452	Phosphorus (P) - extractable	Extr_ap20	%	0	100
277	Sulfur (S) - extractable	Extr_ap20	%	0	100
402	Zinc (Zn) - extractable	Extr_ap20	%	0	100
427	cadmiumProperty	Extr_ap20	%	0	100
202	molybdenumProperty	Extr_ap20	%	0	100
177	Boron (B) - extractable	Extr_ap20	%	0	100
303	Copper (Cu) - extractable	Extr_ap21	%	0	100
353	Iron (Fe) - extractable	Extr_ap21	%	0	100
453	Phosphorus (P) - extractable	Extr_ap21	%	0	100
278	Sulfur (S) - extractable	Extr_ap21	%	0	100
403	Zinc (Zn) - extractable	Extr_ap21	%	0	100
428	cadmiumProperty	Extr_ap21	%	0	100
203	molybdenumProperty	Extr_ap21	%	0	100
178	Boron (B) - extractable	Extr_ap21	%	0	100
304	Copper (Cu) - extractable	Extr_c6h8o7-reeuwijk	%	0	100
354	Iron (Fe) - extractable	Extr_c6h8o7-reeuwijk	%	0	100
454	Phosphorus (P) - extractable	Extr_c6h8o7-reeuwijk	%	0	100
279	Sulfur (S) - extractable	Extr_c6h8o7-reeuwijk	%	0	100
404	Zinc (Zn) - extractable	Extr_c6h8o7-reeuwijk	%	0	100
429	cadmiumProperty	Extr_c6h8o7-reeuwijk	%	0	100
204	molybdenumProperty	Extr_c6h8o7-reeuwijk	%	0	100
179	Boron (B) - extractable	Extr_c6h8o7-reeuwijk	%	0	100
305	Copper (Cu) - extractable	Extr_cacl2	%	0	100
355	Iron (Fe) - extractable	Extr_cacl2	%	0	100
455	Phosphorus (P) - extractable	Extr_cacl2	%	0	100
280	Sulfur (S) - extractable	Extr_cacl2	%	0	100
405	Zinc (Zn) - extractable	Extr_cacl2	%	0	100
430	cadmiumProperty	Extr_cacl2	%	0	100
205	molybdenumProperty	Extr_cacl2	%	0	100
180	Boron (B) - extractable	Extr_cacl2	%	0	100
306	Copper (Cu) - extractable	Extr_capo4	%	0	100
356	Iron (Fe) - extractable	Extr_capo4	%	0	100
456	Phosphorus (P) - extractable	Extr_capo4	%	0	100
281	Sulfur (S) - extractable	Extr_capo4	%	0	100
406	Zinc (Zn) - extractable	Extr_capo4	%	0	100
431	cadmiumProperty	Extr_capo4	%	0	100
206	molybdenumProperty	Extr_capo4	%	0	100
181	Boron (B) - extractable	Extr_capo4	%	0	100
307	Copper (Cu) - extractable	Extr_dtpa	%	0	100
357	Iron (Fe) - extractable	Extr_dtpa	%	0	100
457	Phosphorus (P) - extractable	Extr_dtpa	%	0	100
282	Sulfur (S) - extractable	Extr_dtpa	%	0	100
407	Zinc (Zn) - extractable	Extr_dtpa	%	0	100
432	cadmiumProperty	Extr_dtpa	%	0	100
207	molybdenumProperty	Extr_dtpa	%	0	100
182	Boron (B) - extractable	Extr_dtpa	%	0	100
308	Copper (Cu) - extractable	Extr_edta	%	0	100
358	Iron (Fe) - extractable	Extr_edta	%	0	100
458	Phosphorus (P) - extractable	Extr_edta	%	0	100
283	Sulfur (S) - extractable	Extr_edta	%	0	100
408	Zinc (Zn) - extractable	Extr_edta	%	0	100
433	cadmiumProperty	Extr_edta	%	0	100
208	molybdenumProperty	Extr_edta	%	0	100
183	Boron (B) - extractable	Extr_edta	%	0	100
309	Copper (Cu) - extractable	Extr_h2so4-truog	%	0	100
359	Iron (Fe) - extractable	Extr_h2so4-truog	%	0	100
459	Phosphorus (P) - extractable	Extr_h2so4-truog	%	0	100
284	Sulfur (S) - extractable	Extr_h2so4-truog	%	0	100
409	Zinc (Zn) - extractable	Extr_h2so4-truog	%	0	100
434	cadmiumProperty	Extr_h2so4-truog	%	0	100
209	molybdenumProperty	Extr_h2so4-truog	%	0	100
184	Boron (B) - extractable	Extr_h2so4-truog	%	0	100
310	Copper (Cu) - extractable	Extr_hcl-h2so4-nelson	%	0	100
360	Iron (Fe) - extractable	Extr_hcl-h2so4-nelson	%	0	100
460	Phosphorus (P) - extractable	Extr_hcl-h2so4-nelson	%	0	100
285	Sulfur (S) - extractable	Extr_hcl-h2so4-nelson	%	0	100
410	Zinc (Zn) - extractable	Extr_hcl-h2so4-nelson	%	0	100
435	cadmiumProperty	Extr_hcl-h2so4-nelson	%	0	100
210	molybdenumProperty	Extr_hcl-h2so4-nelson	%	0	100
185	Boron (B) - extractable	Extr_hcl-h2so4-nelson	%	0	100
311	Copper (Cu) - extractable	Extr_hcl-nh4f-bray1	%	0	100
361	Iron (Fe) - extractable	Extr_hcl-nh4f-bray1	%	0	100
461	Phosphorus (P) - extractable	Extr_hcl-nh4f-bray1	%	0	100
286	Sulfur (S) - extractable	Extr_hcl-nh4f-bray1	%	0	100
411	Zinc (Zn) - extractable	Extr_hcl-nh4f-bray1	%	0	100
436	cadmiumProperty	Extr_hcl-nh4f-bray1	%	0	100
211	molybdenumProperty	Extr_hcl-nh4f-bray1	%	0	100
186	Boron (B) - extractable	Extr_hcl-nh4f-bray1	%	0	100
312	Copper (Cu) - extractable	Extr_hcl-nh4f-bray2	%	0	100
362	Iron (Fe) - extractable	Extr_hcl-nh4f-bray2	%	0	100
462	Phosphorus (P) - extractable	Extr_hcl-nh4f-bray2	%	0	100
287	Sulfur (S) - extractable	Extr_hcl-nh4f-bray2	%	0	100
412	Zinc (Zn) - extractable	Extr_hcl-nh4f-bray2	%	0	100
437	cadmiumProperty	Extr_hcl-nh4f-bray2	%	0	100
212	molybdenumProperty	Extr_hcl-nh4f-bray2	%	0	100
187	Boron (B) - extractable	Extr_hcl-nh4f-bray2	%	0	100
313	Copper (Cu) - extractable	Extr_hcl-nh4f-kurtz-bray	%	0	100
363	Iron (Fe) - extractable	Extr_hcl-nh4f-kurtz-bray	%	0	100
463	Phosphorus (P) - extractable	Extr_hcl-nh4f-kurtz-bray	%	0	100
288	Sulfur (S) - extractable	Extr_hcl-nh4f-kurtz-bray	%	0	100
413	Zinc (Zn) - extractable	Extr_hcl-nh4f-kurtz-bray	%	0	100
438	cadmiumProperty	Extr_hcl-nh4f-kurtz-bray	%	0	100
213	molybdenumProperty	Extr_hcl-nh4f-kurtz-bray	%	0	100
188	Boron (B) - extractable	Extr_hcl-nh4f-kurtz-bray	%	0	100
314	Copper (Cu) - extractable	Extr_hno3	%	0	100
364	Iron (Fe) - extractable	Extr_hno3	%	0	100
464	Phosphorus (P) - extractable	Extr_hno3	%	0	100
289	Sulfur (S) - extractable	Extr_hno3	%	0	100
414	Zinc (Zn) - extractable	Extr_hno3	%	0	100
439	cadmiumProperty	Extr_hno3	%	0	100
214	molybdenumProperty	Extr_hno3	%	0	100
189	Boron (B) - extractable	Extr_hno3	%	0	100
315	Copper (Cu) - extractable	Extr_hotwater	%	0	100
365	Iron (Fe) - extractable	Extr_hotwater	%	0	100
465	Phosphorus (P) - extractable	Extr_hotwater	%	0	100
290	Sulfur (S) - extractable	Extr_hotwater	%	0	100
415	Zinc (Zn) - extractable	Extr_hotwater	%	0	100
440	cadmiumProperty	Extr_hotwater	%	0	100
215	molybdenumProperty	Extr_hotwater	%	0	100
190	Boron (B) - extractable	Extr_hotwater	%	0	100
316	Copper (Cu) - extractable	Extr_m1	%	0	100
366	Iron (Fe) - extractable	Extr_m1	%	0	100
466	Phosphorus (P) - extractable	Extr_m1	%	0	100
291	Sulfur (S) - extractable	Extr_m1	%	0	100
416	Zinc (Zn) - extractable	Extr_m1	%	0	100
441	cadmiumProperty	Extr_m1	%	0	100
216	molybdenumProperty	Extr_m1	%	0	100
317	Copper (Cu) - extractable	Extr_m2	%	0	100
367	Iron (Fe) - extractable	Extr_m2	%	0	100
467	Phosphorus (P) - extractable	Extr_m2	%	0	100
292	Sulfur (S) - extractable	Extr_m2	%	0	100
417	Zinc (Zn) - extractable	Extr_m2	%	0	100
442	cadmiumProperty	Extr_m2	%	0	100
217	molybdenumProperty	Extr_m2	%	0	100
192	Boron (B) - extractable	Extr_m2	%	0	100
318	Copper (Cu) - extractable	Extr_m3	%	0	100
368	Iron (Fe) - extractable	Extr_m3	%	0	100
468	Phosphorus (P) - extractable	Extr_m3	%	0	100
293	Sulfur (S) - extractable	Extr_m3	%	0	100
418	Zinc (Zn) - extractable	Extr_m3	%	0	100
443	cadmiumProperty	Extr_m3	%	0	100
218	molybdenumProperty	Extr_m3	%	0	100
193	Boron (B) - extractable	Extr_m3	%	0	100
319	Copper (Cu) - extractable	Extr_m3-spec	%	0	100
369	Iron (Fe) - extractable	Extr_m3-spec	%	0	100
469	Phosphorus (P) - extractable	Extr_m3-spec	%	0	100
294	Sulfur (S) - extractable	Extr_m3-spec	%	0	100
419	Zinc (Zn) - extractable	Extr_m3-spec	%	0	100
444	cadmiumProperty	Extr_m3-spec	%	0	100
219	molybdenumProperty	Extr_m3-spec	%	0	100
194	Boron (B) - extractable	Extr_m3-spec	%	0	100
320	Copper (Cu) - extractable	Extr_nahco3-olsen	%	0	100
370	Iron (Fe) - extractable	Extr_nahco3-olsen	%	0	100
470	Phosphorus (P) - extractable	Extr_nahco3-olsen	%	0	100
295	Sulfur (S) - extractable	Extr_nahco3-olsen	%	0	100
420	Zinc (Zn) - extractable	Extr_nahco3-olsen	%	0	100
445	cadmiumProperty	Extr_nahco3-olsen	%	0	100
220	molybdenumProperty	Extr_nahco3-olsen	%	0	100
195	Boron (B) - extractable	Extr_nahco3-olsen	%	0	100
321	Copper (Cu) - extractable	Extr_nahco3-olsen-dabin	%	0	100
371	Iron (Fe) - extractable	Extr_nahco3-olsen-dabin	%	0	100
471	Phosphorus (P) - extractable	Extr_nahco3-olsen-dabin	%	0	100
296	Sulfur (S) - extractable	Extr_nahco3-olsen-dabin	%	0	100
421	Zinc (Zn) - extractable	Extr_nahco3-olsen-dabin	%	0	100
446	cadmiumProperty	Extr_nahco3-olsen-dabin	%	0	100
221	molybdenumProperty	Extr_nahco3-olsen-dabin	%	0	100
196	Boron (B) - extractable	Extr_nahco3-olsen-dabin	%	0	100
322	Copper (Cu) - extractable	Extr_naoac-morgan	%	0	100
372	Iron (Fe) - extractable	Extr_naoac-morgan	%	0	100
472	Phosphorus (P) - extractable	Extr_naoac-morgan	%	0	100
297	Sulfur (S) - extractable	Extr_naoac-morgan	%	0	100
422	Zinc (Zn) - extractable	Extr_naoac-morgan	%	0	100
447	cadmiumProperty	Extr_naoac-morgan	%	0	100
222	molybdenumProperty	Extr_naoac-morgan	%	0	100
197	Boron (B) - extractable	Extr_naoac-morgan	%	0	100
323	Copper (Cu) - extractable	Extr_nh4-co3-2-ambic1	%	0	100
373	Iron (Fe) - extractable	Extr_nh4-co3-2-ambic1	%	0	100
473	Phosphorus (P) - extractable	Extr_nh4-co3-2-ambic1	%	0	100
298	Sulfur (S) - extractable	Extr_nh4-co3-2-ambic1	%	0	100
423	Zinc (Zn) - extractable	Extr_nh4-co3-2-ambic1	%	0	100
448	cadmiumProperty	Extr_nh4-co3-2-ambic1	%	0	100
223	molybdenumProperty	Extr_nh4-co3-2-ambic1	%	0	100
198	Boron (B) - extractable	Extr_nh4-co3-2-ambic1	%	0	100
324	Copper (Cu) - extractable	Extr_nh4ch3ch-oh-cooh-leuven	%	0	100
374	Iron (Fe) - extractable	Extr_nh4ch3ch-oh-cooh-leuven	%	0	100
474	Phosphorus (P) - extractable	Extr_nh4ch3ch-oh-cooh-leuven	%	0	100
895	Phosphorus (P) - total	Total_hcl	%	0	100
199	Boron (B) - extractable	Extr_nh4ch3ch-oh-cooh-leuven	%	0	100
475	gypsumProperty	CaSO4_gy01	%	0	100
476	gypsumProperty	CaSO4_gy02	%	0	100
477	gypsumProperty	CaSO4_gy03	%	0	100
478	gypsumProperty	CaSO4_gy04	%	0	100
479	gypsumProperty	CaSO4_gy05	%	0	100
480	gypsumProperty	CaSO4_gy06	%	0	100
481	gypsumProperty	CaSO4_gy07	%	0	100
618	Clay texture fraction	SaSiCl_2-20-2000u	%	0	100
570	Sand texture fraction	SaSiCl_2-20-2000u	%	0	100
666	Silt texture fraction	SaSiCl_2-20-2000u	%	0	100
634	Clay texture fraction	SaSiCl_2-50-2000u	%	0	100
586	Sand texture fraction	SaSiCl_2-50-2000u	%	0	100
682	Silt texture fraction	SaSiCl_2-50-2000u	%	0	100
650	Clay texture fraction	SaSiCl_2-64-2000u	%	0	100
602	Sand texture fraction	SaSiCl_2-64-2000u	%	0	100
698	Silt texture fraction	SaSiCl_2-64-2000u	%	0	100
913	aluminiumProperty	Total_h2so4	%	0	100
837	Copper (Cu) - total	Total_h2so4	%	0	100
932	Iron (Fe) - total	Total_h2so4	%	0	100
894	Phosphorus (P) - total	Total_h2so4	%	0	100
818	Sulfur (S) - total	Total_h2so4	%	0	100
875	cadmiumProperty	Total_h2so4	%	0	100
780	molybdenumProperty	Total_h2so4	%	0	100
856	zincProperty	Total_h2so4	%	0	100
799	Boron (B) - total	Total_h2so4	%	0	100
914	aluminiumProperty	Total_hcl	%	0	100
838	Copper (Cu) - total	Total_hcl	%	0	100
933	Iron (Fe) - total	Total_hcl	%	0	100
819	Sulfur (S) - total	Total_hcl	%	0	100
876	cadmiumProperty	Total_hcl	%	0	100
781	molybdenumProperty	Total_hcl	%	0	100
857	zincProperty	Total_hcl	%	0	100
800	Boron (B) - total	Total_hcl	%	0	100
915	aluminiumProperty	Total_hcl-aquaregia	%	0	100
839	Copper (Cu) - total	Total_hcl-aquaregia	%	0	100
934	Iron (Fe) - total	Total_hcl-aquaregia	%	0	100
896	Phosphorus (P) - total	Total_hcl-aquaregia	%	0	100
820	Sulfur (S) - total	Total_hcl-aquaregia	%	0	100
877	cadmiumProperty	Total_hcl-aquaregia	%	0	100
782	molybdenumProperty	Total_hcl-aquaregia	%	0	100
858	zincProperty	Total_hcl-aquaregia	%	0	100
801	Boron (B) - total	Total_hcl-aquaregia	%	0	100
916	aluminiumProperty	Total_hclo4	%	0	100
840	Copper (Cu) - total	Total_hclo4	%	0	100
935	Iron (Fe) - total	Total_hclo4	%	0	100
897	Phosphorus (P) - total	Total_hclo4	%	0	100
821	Sulfur (S) - total	Total_hclo4	%	0	100
878	cadmiumProperty	Total_hclo4	%	0	100
783	molybdenumProperty	Total_hclo4	%	0	100
859	zincProperty	Total_hclo4	%	0	100
802	Boron (B) - total	Total_hclo4	%	0	100
917	aluminiumProperty	Total_hno3-aquafortis	%	0	100
841	Copper (Cu) - total	Total_hno3-aquafortis	%	0	100
936	Iron (Fe) - total	Total_hno3-aquafortis	%	0	100
898	Phosphorus (P) - total	Total_hno3-aquafortis	%	0	100
822	Sulfur (S) - total	Total_hno3-aquafortis	%	0	100
879	cadmiumProperty	Total_hno3-aquafortis	%	0	100
784	molybdenumProperty	Total_hno3-aquafortis	%	0	100
860	zincProperty	Total_hno3-aquafortis	%	0	100
803	Boron (B) - total	Total_hno3-aquafortis	%	0	100
918	aluminiumProperty	Total_nh4-6mo7o24	%	0	100
842	Copper (Cu) - total	Total_nh4-6mo7o24	%	0	100
937	Iron (Fe) - total	Total_nh4-6mo7o24	%	0	100
899	Phosphorus (P) - total	Total_nh4-6mo7o24	%	0	100
823	Sulfur (S) - total	Total_nh4-6mo7o24	%	0	100
880	cadmiumProperty	Total_nh4-6mo7o24	%	0	100
785	molybdenumProperty	Total_nh4-6mo7o24	%	0	100
861	zincProperty	Total_nh4-6mo7o24	%	0	100
804	Boron (B) - total	Total_nh4-6mo7o24	%	0	100
919	aluminiumProperty	Total_tp03	%	0	100
843	Copper (Cu) - total	Total_tp03	%	0	100
938	Iron (Fe) - total	Total_tp03	%	0	100
900	Phosphorus (P) - total	Total_tp03	%	0	100
824	Sulfur (S) - total	Total_tp03	%	0	100
881	cadmiumProperty	Total_tp03	%	0	100
786	molybdenumProperty	Total_tp03	%	0	100
862	zincProperty	Total_tp03	%	0	100
805	Boron (B) - total	Total_tp03	%	0	100
920	aluminiumProperty	Total_tp04	%	0	100
844	Copper (Cu) - total	Total_tp04	%	0	100
939	Iron (Fe) - total	Total_tp04	%	0	100
901	Phosphorus (P) - total	Total_tp04	%	0	100
825	Sulfur (S) - total	Total_tp04	%	0	100
882	cadmiumProperty	Total_tp04	%	0	100
787	molybdenumProperty	Total_tp04	%	0	100
863	zincProperty	Total_tp04	%	0	100
806	Boron (B) - total	Total_tp04	%	0	100
921	aluminiumProperty	Total_tp05	%	0	100
845	Copper (Cu) - total	Total_tp05	%	0	100
940	Iron (Fe) - total	Total_tp05	%	0	100
902	Phosphorus (P) - total	Total_tp05	%	0	100
826	Sulfur (S) - total	Total_tp05	%	0	100
883	cadmiumProperty	Total_tp05	%	0	100
788	molybdenumProperty	Total_tp05	%	0	100
864	zincProperty	Total_tp05	%	0	100
807	Boron (B) - total	Total_tp05	%	0	100
922	aluminiumProperty	Total_tp06	%	0	100
846	Copper (Cu) - total	Total_tp06	%	0	100
941	Iron (Fe) - total	Total_tp06	%	0	100
903	Phosphorus (P) - total	Total_tp06	%	0	100
827	Sulfur (S) - total	Total_tp06	%	0	100
884	cadmiumProperty	Total_tp06	%	0	100
789	molybdenumProperty	Total_tp06	%	0	100
865	zincProperty	Total_tp06	%	0	100
808	Boron (B) - total	Total_tp06	%	0	100
923	aluminiumProperty	Total_tp07	%	0	100
847	Copper (Cu) - total	Total_tp07	%	0	100
942	Iron (Fe) - total	Total_tp07	%	0	100
904	Phosphorus (P) - total	Total_tp07	%	0	100
828	Sulfur (S) - total	Total_tp07	%	0	100
885	cadmiumProperty	Total_tp07	%	0	100
790	molybdenumProperty	Total_tp07	%	0	100
866	zincProperty	Total_tp07	%	0	100
809	Boron (B) - total	Total_tp07	%	0	100
924	aluminiumProperty	Total_tp08	%	0	100
848	Copper (Cu) - total	Total_tp08	%	0	100
943	Iron (Fe) - total	Total_tp08	%	0	100
905	Phosphorus (P) - total	Total_tp08	%	0	100
829	Sulfur (S) - total	Total_tp08	%	0	100
886	cadmiumProperty	Total_tp08	%	0	100
791	molybdenumProperty	Total_tp08	%	0	100
867	zincProperty	Total_tp08	%	0	100
810	Boron (B) - total	Total_tp08	%	0	100
925	aluminiumProperty	Total_tp09	%	0	100
849	Copper (Cu) - total	Total_tp09	%	0	100
944	Iron (Fe) - total	Total_tp09	%	0	100
906	Phosphorus (P) - total	Total_tp09	%	0	100
830	Sulfur (S) - total	Total_tp09	%	0	100
887	cadmiumProperty	Total_tp09	%	0	100
792	molybdenumProperty	Total_tp09	%	0	100
868	zincProperty	Total_tp09	%	0	100
811	Boron (B) - total	Total_tp09	%	0	100
926	aluminiumProperty	Total_tp10	%	0	100
850	Copper (Cu) - total	Total_tp10	%	0	100
945	Iron (Fe) - total	Total_tp10	%	0	100
907	Phosphorus (P) - total	Total_tp10	%	0	100
831	Sulfur (S) - total	Total_tp10	%	0	100
888	cadmiumProperty	Total_tp10	%	0	100
793	molybdenumProperty	Total_tp10	%	0	100
869	zincProperty	Total_tp10	%	0	100
812	Boron (B) - total	Total_tp10	%	0	100
927	aluminiumProperty	Total_unkn	%	0	100
851	Copper (Cu) - total	Total_unkn	%	0	100
946	Iron (Fe) - total	Total_unkn	%	0	100
908	Phosphorus (P) - total	Total_unkn	%	0	100
832	Sulfur (S) - total	Total_unkn	%	0	100
889	cadmiumProperty	Total_unkn	%	0	100
794	molybdenumProperty	Total_unkn	%	0	100
870	zincProperty	Total_unkn	%	0	100
813	Boron (B) - total	Total_unkn	%	0	100
928	aluminiumProperty	Total_xrd	%	0	100
852	Copper (Cu) - total	Total_xrd	%	0	100
947	Iron (Fe) - total	Total_xrd	%	0	100
909	Phosphorus (P) - total	Total_xrd	%	0	100
833	Sulfur (S) - total	Total_xrd	%	0	100
890	cadmiumProperty	Total_xrd	%	0	100
795	molybdenumProperty	Total_xrd	%	0	100
871	zincProperty	Total_xrd	%	0	100
814	Boron (B) - total	Total_xrd	%	0	100
929	aluminiumProperty	Total_xrf	%	0	100
853	Copper (Cu) - total	Total_xrf	%	0	100
948	Iron (Fe) - total	Total_xrf	%	0	100
910	Phosphorus (P) - total	Total_xrf	%	0	100
834	Sulfur (S) - total	Total_xrf	%	0	100
891	cadmiumProperty	Total_xrf	%	0	100
796	molybdenumProperty	Total_xrf	%	0	100
872	zincProperty	Total_xrf	%	0	100
815	Boron (B) - total	Total_xrf	%	0	100
930	aluminiumProperty	Total_xrf-p	%	0	100
854	Copper (Cu) - total	Total_xrf-p	%	0	100
949	Iron (Fe) - total	Total_xrf-p	%	0	100
911	Phosphorus (P) - total	Total_xrf-p	%	0	100
835	Sulfur (S) - total	Total_xrf-p	%	0	100
892	cadmiumProperty	Total_xrf-p	%	0	100
797	molybdenumProperty	Total_xrf-p	%	0	100
816	Boron (B) - total	Total_xrf-p	%	0	100
931	aluminiumProperty	Total_xtf-t	%	0	100
855	Copper (Cu) - total	Total_xtf-t	%	0	100
950	Iron (Fe) - total	Total_xtf-t	%	0	100
912	Phosphorus (P) - total	Total_xtf-t	%	0	100
836	Sulfur (S) - total	Total_xtf-t	%	0	100
893	cadmiumProperty	Total_xtf-t	%	0	100
798	molybdenumProperty	Total_xtf-t	%	0	100
874	zincProperty	Total_xtf-t	%	0	100
817	Boron (B) - total	Total_xtf-t	%	0	100
54	Carbon (C) - organic	OrgC_wc-cro3-nrcs6a1c	g/kg	0	1000
55	Carbon (C) - organic	OrgC_wc-cro3-tiurin	g/kg	0	1000
56	Carbon (C) - organic	OrgC_wc-cro3-walkleyblack	g/kg	0	1000
57	Carbon (C) - total	TotC_calcul-ic-oc	g/kg	0	1000
58	Carbon (C) - total	TotC_dc-ht	g/kg	0	1000
59	Carbon (C) - total	TotC_dc-ht-analyser	g/kg	0	1000
60	Carbon (C) - total	TotC_dc-ht-spec	g/kg	0	1000
61	Carbon (C) - total	TotC_dc-mt	g/kg	0	1000
714	totalCarbonateEquivalentProperty	CaCO3_acid-ch3cooh-dc	g/kg	0	1000
715	totalCarbonateEquivalentProperty	CaCO3_acid-ch3cooh-nodc	g/kg	0	1000
716	totalCarbonateEquivalentProperty	CaCO3_acid-ch3cooh-unkn	g/kg	0	1000
717	totalCarbonateEquivalentProperty	CaCO3_acid-dc	g/kg	0	1000
718	totalCarbonateEquivalentProperty	CaCO3_acid-h2so4-dc	g/kg	0	1000
719	totalCarbonateEquivalentProperty	CaCO3_acid-h2so4-nodc	g/kg	0	1000
720	totalCarbonateEquivalentProperty	CaCO3_acid-h2so4-unkn	g/kg	0	1000
721	totalCarbonateEquivalentProperty	CaCO3_acid-h3po4-dc	g/kg	0	1000
722	totalCarbonateEquivalentProperty	CaCO3_acid-h3po4-nodc	g/kg	0	1000
723	totalCarbonateEquivalentProperty	CaCO3_acid-h3po4-unkn	g/kg	0	1000
724	totalCarbonateEquivalentProperty	CaCO3_acid-hcl-dc	g/kg	0	1000
725	totalCarbonateEquivalentProperty	CaCO3_acid-hcl-nodc	g/kg	0	1000
726	totalCarbonateEquivalentProperty	CaCO3_acid-hcl-unkn	g/kg	0	1000
727	totalCarbonateEquivalentProperty	CaCO3_acid-nodc	g/kg	0	1000
728	totalCarbonateEquivalentProperty	CaCO3_acid-unkn	g/kg	0	1000
729	totalCarbonateEquivalentProperty	CaCO3_ca01	g/kg	0	1000
730	totalCarbonateEquivalentProperty	CaCO3_ca02	g/kg	0	1000
731	totalCarbonateEquivalentProperty	CaCO3_ca03	g/kg	0	1000
732	totalCarbonateEquivalentProperty	CaCO3_ca04	g/kg	0	1000
733	totalCarbonateEquivalentProperty	CaCO3_ca05	g/kg	0	1000
734	totalCarbonateEquivalentProperty	CaCO3_ca06	g/kg	0	1000
735	totalCarbonateEquivalentProperty	CaCO3_ca07	g/kg	0	1000
736	totalCarbonateEquivalentProperty	CaCO3_ca08	g/kg	0	1000
737	totalCarbonateEquivalentProperty	CaCO3_ca09	g/kg	0	1000
738	totalCarbonateEquivalentProperty	CaCO3_ca10	g/kg	0	1000
739	totalCarbonateEquivalentProperty	CaCO3_ca11	g/kg	0	1000
740	totalCarbonateEquivalentProperty	CaCO3_ca12	g/kg	0	1000
741	totalCarbonateEquivalentProperty	CaCO3_calcul-tc-oc	g/kg	0	1000
74	manganeseProperty	ExchBases_ph-unkn-m3	cmol/kg	0	1000
75	manganeseProperty	ExchBases_ph-unkn-m3-spec	cmol/kg	0	1000
76	manganeseProperty	ExchBases_ph0-cohex	cmol/kg	0	1000
77	manganeseProperty	ExchBases_ph0-nh4cl	cmol/kg	0	1000
78	manganeseProperty	ExchBases_ph7-nh4oac	cmol/kg	0	1000
79	manganeseProperty	ExchBases_ph7-nh4oac-aas	cmol/kg	0	1000
80	manganeseProperty	ExchBases_ph7-nh4oac-fp	cmol/kg	0	1000
81	manganeseProperty	ExchBases_ph7-unkn	cmol/kg	0	1000
82	manganeseProperty	ExchBases_ph8-bacl2tea	cmol/kg	0	1000
83	manganeseProperty	ExchBases_ph8-unkn	cmol/kg	0	1000
250	Magnesium (Mg) - extractable	Extr_ap14	cmol/kg	0	1000
150	Manganese (Mn) - extractable	Extr_ap14	cmol/kg	0	1000
225	Potassium (K) - extractable	Extr_ap14	cmol/kg	0	1000
375	Sodium (Na) - extractable	Extr_ap14	cmol/kg	0	1000
325	Calcium (Ca++) - extractable	Extr_ap14	cmol/kg	0	1000
128	Calcium (Ca++) - exchangeable	ExchBases_ph-unkn-edta	cmol/kg	0	100
96	Hydrogen (H+) - exchangeable	ExchBases_ph-unkn-m3	cmol/kg	0	100
140	Magnesium (Mg++) - exchangeable	ExchBases_ph-unkn-m3	cmol/kg	0	100
107	Potassium (K+) - exchangeable	ExchBases_ph-unkn-m3	cmol/kg	0	100
118	Aluminium (Al+++) - exchangeable	ExchBases_ph-unkn-m3	cmol/kg	0	100
129	Calcium (Ca++) - exchangeable	ExchBases_ph-unkn-m3	cmol/kg	0	100
97	Hydrogen (H+) - exchangeable	ExchBases_ph-unkn-m3-spec	cmol/kg	0	100
141	Magnesium (Mg++) - exchangeable	ExchBases_ph-unkn-m3-spec	cmol/kg	0	100
108	Potassium (K+) - exchangeable	ExchBases_ph-unkn-m3-spec	cmol/kg	0	100
119	Aluminium (Al+++) - exchangeable	ExchBases_ph-unkn-m3-spec	cmol/kg	0	100
130	Calcium (Ca++) - exchangeable	ExchBases_ph-unkn-m3-spec	cmol/kg	0	100
98	Hydrogen (H+) - exchangeable	ExchBases_ph0-cohex	cmol/kg	0	100
142	Magnesium (Mg++) - exchangeable	ExchBases_ph0-cohex	cmol/kg	0	100
109	Potassium (K+) - exchangeable	ExchBases_ph0-cohex	cmol/kg	0	100
120	Aluminium (Al+++) - exchangeable	ExchBases_ph0-cohex	cmol/kg	0	100
131	Calcium (Ca++) - exchangeable	ExchBases_ph0-cohex	cmol/kg	0	100
99	Hydrogen (H+) - exchangeable	ExchBases_ph0-nh4cl	cmol/kg	0	100
143	Magnesium (Mg++) - exchangeable	ExchBases_ph0-nh4cl	cmol/kg	0	100
110	Potassium (K+) - exchangeable	ExchBases_ph0-nh4cl	cmol/kg	0	100
121	Aluminium (Al+++) - exchangeable	ExchBases_ph0-nh4cl	cmol/kg	0	100
132	Calcium (Ca++) - exchangeable	ExchBases_ph0-nh4cl	cmol/kg	0	100
100	Hydrogen (H+) - exchangeable	ExchBases_ph7-nh4oac	cmol/kg	0	100
144	Magnesium (Mg++) - exchangeable	ExchBases_ph7-nh4oac	cmol/kg	0	100
111	Potassium (K+) - exchangeable	ExchBases_ph7-nh4oac	cmol/kg	0	100
122	Aluminium (Al+++) - exchangeable	ExchBases_ph7-nh4oac	cmol/kg	0	100
133	Calcium (Ca++) - exchangeable	ExchBases_ph7-nh4oac	cmol/kg	0	100
101	Hydrogen (H+) - exchangeable	ExchBases_ph7-nh4oac-aas	cmol/kg	0	100
145	Magnesium (Mg++) - exchangeable	ExchBases_ph7-nh4oac-aas	cmol/kg	0	100
112	Potassium (K+) - exchangeable	ExchBases_ph7-nh4oac-aas	cmol/kg	0	100
123	Aluminium (Al+++) - exchangeable	ExchBases_ph7-nh4oac-aas	cmol/kg	0	100
134	Calcium (Ca++) - exchangeable	ExchBases_ph7-nh4oac-aas	cmol/kg	0	100
102	Hydrogen (H+) - exchangeable	ExchBases_ph7-nh4oac-fp	cmol/kg	0	100
146	Magnesium (Mg++) - exchangeable	ExchBases_ph7-nh4oac-fp	cmol/kg	0	100
113	Potassium (K+) - exchangeable	ExchBases_ph7-nh4oac-fp	cmol/kg	0	100
124	Aluminium (Al+++) - exchangeable	ExchBases_ph7-nh4oac-fp	cmol/kg	0	100
135	Calcium (Ca++) - exchangeable	ExchBases_ph7-nh4oac-fp	cmol/kg	0	100
103	Hydrogen (H+) - exchangeable	ExchBases_ph7-unkn	cmol/kg	0	100
147	Magnesium (Mg++) - exchangeable	ExchBases_ph7-unkn	cmol/kg	0	100
114	Potassium (K+) - exchangeable	ExchBases_ph7-unkn	cmol/kg	0	100
125	Aluminium (Al+++) - exchangeable	ExchBases_ph7-unkn	cmol/kg	0	100
136	Calcium (Ca++) - exchangeable	ExchBases_ph7-unkn	cmol/kg	0	100
104	Hydrogen (H+) - exchangeable	ExchBases_ph8-bacl2tea	cmol/kg	0	100
148	Magnesium (Mg++) - exchangeable	ExchBases_ph8-bacl2tea	cmol/kg	0	100
115	Potassium (K+) - exchangeable	ExchBases_ph8-bacl2tea	cmol/kg	0	100
126	Aluminium (Al+++) - exchangeable	ExchBases_ph8-bacl2tea	cmol/kg	0	100
137	Calcium (Ca++) - exchangeable	ExchBases_ph8-bacl2tea	cmol/kg	0	100
105	Hydrogen (H+) - exchangeable	ExchBases_ph8-unkn	cmol/kg	0	100
149	Magnesium (Mg++) - exchangeable	ExchBases_ph8-unkn	cmol/kg	0	100
116	Potassium (K+) - exchangeable	ExchBases_ph8-unkn	cmol/kg	0	100
127	Aluminium (Al+++) - exchangeable	ExchBases_ph8-unkn	cmol/kg	0	100
138	Calcium (Ca++) - exchangeable	ExchBases_ph8-unkn	cmol/kg	0	100
85	Sodium (Na+) - exchangeable	ExchBases_ph-unkn-m3	cmol/kg	0	100
86	Sodium (Na+) - exchangeable	ExchBases_ph-unkn-m3-spec	cmol/kg	0	100
87	Sodium (Na+) - exchangeable	ExchBases_ph0-cohex	cmol/kg	0	100
88	Sodium (Na+) - exchangeable	ExchBases_ph0-nh4cl	cmol/kg	0	100
89	Sodium (Na+) - exchangeable	ExchBases_ph7-nh4oac	cmol/kg	0	100
90	Sodium (Na+) - exchangeable	ExchBases_ph7-nh4oac-aas	cmol/kg	0	100
91	Sodium (Na+) - exchangeable	ExchBases_ph7-nh4oac-fp	cmol/kg	0	100
92	Sodium (Na+) - exchangeable	ExchBases_ph7-unkn	cmol/kg	0	100
93	Sodium (Na+) - exchangeable	ExchBases_ph8-bacl2tea	cmol/kg	0	100
94	Sodium (Na+) - exchangeable	ExchBases_ph8-unkn	cmol/kg	0	100
\.


--
-- TOC entry 4965 (class 0 OID 54922828)
-- Dependencies: 228
-- Data for Name: plot; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.plot (plot_id, site_id, plot_code, altitude, time_stamp, map_sheet_code, positional_accuracy, "position", type) FROM stdin;
\.


--
-- TOC entry 4966 (class 0 OID 54922837)
-- Dependencies: 229
-- Data for Name: plot_individual; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.plot_individual (plot_id, individual_id) FROM stdin;
\.


--
-- TOC entry 4968 (class 0 OID 54922842)
-- Dependencies: 231
-- Data for Name: procedure_desc; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.procedure_desc (procedure_desc_id, reference, uri) FROM stdin;
FAO GfSD 2006	Food and Agriculture Organisation of the United Nations, Guidelines for Soil Description, Fourth Edition, 2006.	https://www.fao.org/publications/card/en/c/903943c7-f56a-521a-8d32-459e7e0cdae9/
FAO GfSD 1990	Food and Agriculture Organisation of the United Nations, Guidelines for Soil Description, Fourth Edition, 1990	FAO GfSD 1990
ISRIC Report 2019/01	ISRIC Report 2019/01: Tier 1 and Tier 2 data in the context of the federated Global Soil Information System. Appendix 1	https://www.isric.org/documents/document-type/isric-report-201901-tier-1-and-tier-2-data-context-federated-global-soil
Keys to Soil Taxonomy 13th edition 2022	Keys to Soil Taxonomy, 13th ed.2022	https://nrcspad.sc.egov.usda.gov/DistributionCenter/product.aspx?ProductID=1709
Köppen-Geiger Climate Classification	DOI: 10.1127/0941-2948/2006/0130	https://www.schweizerbart.de/papers/metz/detail/15/55034/World_Map_of_the_Koppen_Geiger_climate_classificat?af=crossref
Soil Survey Manual 2017	Soil Survey Manual 2017	https://www.nrcs.usda.gov/resources/guides-and-instructions/soil-survey-manual
WRB fourth edition 2022	WRB fourth edition 2022	https://www.fao.org/soils-portal/data-hub/soil-classification/world-reference-base/en/
\.


--
-- TOC entry 4969 (class 0 OID 54922850)
-- Dependencies: 232
-- Data for Name: procedure_phys_chem; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.procedure_phys_chem (procedure_phys_chem_id, broader_id, uri, definition, reference, citation) FROM stdin;
pHH2O	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHH2O	pHH2O (soil reaction) in a soil/water solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
TotalN_dc-ht-dumas	\N	http://w3id.org/glosis/model/procedure/nitrogenTotalProcedure-TotalN_dc-ht-dumas	Dry combustion at 800-1000 C celcius (Dumas method)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
TotalN_dc-ht-leco	\N	http://w3id.org/glosis/model/procedure/nitrogenTotalProcedure-TotalN_dc-ht-leco	Element analyzer (LECO analyzer), Dry Combustion	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHKCl	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHKCl	pHKCl (soil reaction) in a soil/KCl solution (0.01-1 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
SaSiCl_2-50-2000u-adj100	\N	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-50-2000u-adj100	\N	\N	\N
SaSiCl_2-20-2000u-adj100	\N	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-20-2000u-adj100	\N	\N	\N
SaSiCl_2-20-2000u-disp	\N	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-20-2000u-disp	\N	\N	\N
SaSiCl_2-20-2000u-fld	\N	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-20-2000u-fld	\N	\N	\N
SaSiCl_2-20-2000u-nodisp	\N	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-20-2000u-nodisp	\N	\N	\N
SaSiCl_2-50-2000u-disp	\N	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-50-2000u-disp	\N	\N	\N
SaSiCl_2-50-2000u-fld	\N	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-50-2000u-fld	\N	\N	\N
SaSiCl_2-50-2000u-nodisp	\N	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-50-2000u-nodisp	\N	\N	\N
SaSiCl_2-64-2000u-adj100	\N	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-64-2000u-adj100	\N	\N	\N
SaSiCl_2-64-2000u-disp	\N	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-64-2000u-disp	\N	\N	\N
SaSiCl_2-64-2000u-fld	\N	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-64-2000u-fld	\N	\N	\N
SaSiCl_2-64-2000u-nodisp	\N	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-64-2000u-nodisp	\N	\N	\N
SaSiCl_2-20-2000u	\N	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-20-2000u	\N	\N	\N
SaSiCl_2-50-2000u	\N	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-50-2000u	\N	\N	\N
SaSiCl_2-64-2000u	\N	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-64-2000u	\N	\N	\N
SaSiCl_2-20-2000u-disp-beaker	SaSiCl_2-20-2000u-disp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-20-2000u-disp-beaker	\N	\N	\N
SaSiCl_2-20-2000u-disp-hydrometer	SaSiCl_2-20-2000u-disp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-20-2000u-disp-hydrometer	\N	\N	\N
SaSiCl_2-20-2000u-disp-hydrometer-bouy	SaSiCl_2-20-2000u-disp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-20-2000u-disp-hydrometer-bouy	\N	\N	\N
SaSiCl_2-20-2000u-disp-laser	SaSiCl_2-20-2000u-disp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-20-2000u-disp-laser	\N	\N	\N
SaSiCl_2-20-2000u-disp-pipette	SaSiCl_2-20-2000u-disp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-20-2000u-disp-pipette	\N	\N	\N
SaSiCl_2-20-2000u-disp-spec	SaSiCl_2-20-2000u-disp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-20-2000u-disp-spec	\N	\N	\N
SaSiCl_2-20-2000u-nodisp-hydrometer	SaSiCl_2-20-2000u-nodisp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-20-2000u-nodisp-hydrometer	\N	\N	\N
SaSiCl_2-20-2000u-nodisp-hydrometer-bouy	SaSiCl_2-20-2000u-nodisp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-20-2000u-nodisp-hydrometer-bouy	\N	\N	\N
SaSiCl_2-20-2000u-nodisp-laser	SaSiCl_2-20-2000u-nodisp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-20-2000u-nodisp-laser	\N	\N	\N
SaSiCl_2-20-2000u-nodisp-pipette	SaSiCl_2-20-2000u-nodisp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-20-2000u-nodisp-pipette	\N	\N	\N
SaSiCl_2-20-2000u-nodisp-spec	SaSiCl_2-20-2000u-nodisp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-20-2000u-nodisp-spec	\N	\N	\N
SaSiCl_2-50-2000u-disp-beaker	SaSiCl_2-50-2000u-disp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-50-2000u-disp-beaker	\N	\N	\N
SaSiCl_2-50-2000u-disp-hydrometer	SaSiCl_2-50-2000u-disp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-50-2000u-disp-hydrometer	\N	\N	\N
SaSiCl_2-50-2000u-disp-hydrometer-bouy	SaSiCl_2-50-2000u-disp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-50-2000u-disp-hydrometer-bouy	\N	\N	\N
SaSiCl_2-50-2000u-disp-laser	SaSiCl_2-50-2000u-disp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-50-2000u-disp-laser	\N	\N	\N
SaSiCl_2-50-2000u-disp-pipette	SaSiCl_2-50-2000u-disp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-50-2000u-disp-pipette	\N	\N	\N
SaSiCl_2-50-2000u-disp-spec	SaSiCl_2-50-2000u-disp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-50-2000u-disp-spec	\N	\N	\N
SaSiCl_2-50-2000u-nodisp-hydrometer	SaSiCl_2-50-2000u-nodisp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-50-2000u-nodisp-hydrometer	\N	\N	\N
SaSiCl_2-50-2000u-nodisp-hydrometer-bouy	SaSiCl_2-50-2000u-nodisp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-50-2000u-nodisp-hydrometer-bouy	\N	\N	\N
SaSiCl_2-50-2000u-nodisp-laser	SaSiCl_2-50-2000u-nodisp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-50-2000u-nodisp-laser	\N	\N	\N
SaSiCl_2-50-2000u-nodisp-pipette	SaSiCl_2-50-2000u-nodisp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-50-2000u-nodisp-pipette	\N	\N	\N
SaSiCl_2-50-2000u-nodisp-spec	SaSiCl_2-50-2000u-nodisp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-50-2000u-nodisp-spec	\N	\N	\N
SaSiCl_2-64-2000u-disp-beaker	SaSiCl_2-64-2000u-disp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-64-2000u-disp-beaker	\N	\N	\N
SaSiCl_2-64-2000u-disp-hydrometer	SaSiCl_2-64-2000u-disp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-64-2000u-disp-hydrometer	\N	\N	\N
SaSiCl_2-64-2000u-disp-hydrometer-bouy	SaSiCl_2-64-2000u-disp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-64-2000u-disp-hydrometer-bouy	\N	\N	\N
SaSiCl_2-64-2000u-disp-laser	SaSiCl_2-64-2000u-disp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-64-2000u-disp-laser	\N	\N	\N
SaSiCl_2-64-2000u-disp-pipette	SaSiCl_2-64-2000u-disp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-64-2000u-disp-pipette	\N	\N	\N
SaSiCl_2-64-2000u-disp-spec	SaSiCl_2-64-2000u-disp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-64-2000u-disp-spec	\N	\N	\N
SaSiCl_2-64-2000u-nodisp-hydrometer	SaSiCl_2-64-2000u-nodisp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-64-2000u-nodisp-hydrometer	\N	\N	\N
SaSiCl_2-64-2000u-nodisp-hydrometer-bouy	SaSiCl_2-64-2000u-nodisp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-64-2000u-nodisp-hydrometer-bouy	\N	\N	\N
SaSiCl_2-64-2000u-nodisp-laser	SaSiCl_2-64-2000u-nodisp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-64-2000u-nodisp-laser	\N	\N	\N
SaSiCl_2-64-2000u-nodisp-pipette	SaSiCl_2-64-2000u-nodisp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-64-2000u-nodisp-pipette	\N	\N	\N
SaSiCl_2-64-2000u-nodisp-spec	SaSiCl_2-64-2000u-nodisp	http://w3id.org/glosis/model/procedure/textureProcedure-SaSiCl_2-64-2000u-nodisp-spec	\N	\N	\N
OrgC_wc	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_wc	Wet oxidation or wet combustion methods	\N	\N
Extr_m1	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_m1	Mehlich1 method	https://www.ncagr.gov/AGRONOMI/pdffiles/mehlich53.pdf	\N
TotalN_h2so4	\N	http://w3id.org/glosis/model/procedure/nitrogenTotalProcedure-TotalN_h2so4	H2SO4	\N	\N
TotalN_calcul	\N	http://w3id.org/glosis/model/procedure/nitrogenTotalProcedure-TotalN_calcul	OC * 1.72 / 20 (gives C/N=11.6009)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
TotalN_kjeldahl	\N	http://w3id.org/glosis/model/procedure/nitrogenTotalProcedure-TotalN_kjeldahl	Method of Kjeldahl (digestion)	https://en.wikipedia.org/wiki/Kjeldahl_method	Kjeldahl, J. (1883) ‘Neue Methode zur Bestimmung des Stickstoffs in organischen Körpern’ (New method for the determination of nitrogen in organic substances), Zeitschrift für analytische Chemie, 22 (1) : 366-383.
TotalN_dc-spec	\N	http://w3id.org/glosis/model/procedure/nitrogenTotalProcedure-TotalN_dc-spec	Spectrally measured and converted to N by dry combustion	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
TotalN_kjeldahl-nh4	\N	http://w3id.org/glosis/model/procedure/nitrogenTotalProcedure-TotalN_kjeldahl-nh4	Kjeldahl, and ammonia distillation	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
TotalN_tn08	\N	http://w3id.org/glosis/model/procedure/nitrogenTotalProcedure-TotalN_tn08	Sample digested by sulphuric acid, distillation of released ammonia, back titration against sulpuric acid	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Extr_dtpa	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_dtpa	DiethyneleTriaminePentaAcetic acid (DTPA) method	https://doi.org/10.2136/sssaj1978.03615995004200030009x	\N
TotalN_tn04	\N	http://w3id.org/glosis/model/procedure/nitrogenTotalProcedure-TotalN_tn04	Dry combustion using a CN-corder and cobalt oxide or copper oxide as an oxidation accelerator (Tanabe and Araragi, 1970)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
TotalN_calcul-oc10	\N	http://w3id.org/glosis/model/procedure/nitrogenTotalProcedure-TotalN_calcul-oc10	Calculated from OrgC and C/N ratio of 10	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
TotalN_nelson	\N	http://w3id.org/glosis/model/procedure/nitrogenTotalProcedure-TotalN_nelson	Nelson and Sommers, 1980	https://doi.org/10.1093/jaoac/63.4.770	Darrell W Nelson, Lee E Sommers, Total Nitrogen Analysis of Soil and Plant Tissues, Journal of Association of Official Analytical Chemists, Volume 63, Issue 4, 1 July 1980, Pages 770–778,
TotalN_dc	\N	http://w3id.org/glosis/model/procedure/nitrogenTotalProcedure-TotalN_dc	Dry combustion	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
TotalN_tn06	\N	http://w3id.org/glosis/model/procedure/nitrogenTotalProcedure-TotalN_tn06	Continuous flow analyser after digestion with H2SO4/salicyclic acid/H2O2/Se	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
TotalN_bremner	\N	http://w3id.org/glosis/model/procedure/nitrogenTotalProcedure-TotalN_bremner	Total N (Bremner, 1965, p. 1162-1164)	https://doi.org/10.2134/agronmonogr9.2.c32	Bremner, J. M. 1965. Total Nitrogen. In: C. A. Black (ed.) Methods of soil analysis. Part 2: Chemical and microbial properties. Number 9 in series Agronomy. American Society of Agronomy, Inc. Publisher, Madison, USA. Pp. 1049-1178
PAWHC_calcul-fc200wp	\N	http://w3id.org/glosis/model/procedure/availableWaterHoldingCapacityProcedure-PAWHC_calcul-fc200wp	Plant available water holding capacity of the soil fine earth fraction, calculated with field capacity defined at 200 cm (pF 2.3)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
PAWHC_calcul-fc300wp	\N	http://w3id.org/glosis/model/procedure/availableWaterHoldingCapacityProcedure-PAWHC_calcul-fc300wp	Plant available water holding capacity of the soil fine earth fraction, calculated with field capacity defined at 300 cm (pF 2.5)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
PAWHC_calcul-fc100wp	\N	http://w3id.org/glosis/model/procedure/availableWaterHoldingCapacityProcedure-PAWHC_calcul-fc100wp	Plant available water holding capacity of the soil fine earth fraction, calculated with field capacity defined at 100 cm (pF 2.0)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
InOrgC_calcul-caco3	\N	http://w3id.org/glosis/model/procedure/carbonInorganicProcedure-InOrgC_calcul-caco3	Indirect estimate from total carbonate equivalent, with a factor of 0.12 (molar weights: CaCO3 100g/mol, C 12g/mol)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
InOrgC_calcul-tc-oc	\N	http://w3id.org/glosis/model/procedure/carbonInorganicProcedure-InOrgC_calcul-tc-oc	Indirect estimate (total carbon minus organic carbon = inorganic carbon)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
EffCEC_calcul-b	\N	http://w3id.org/glosis/model/procedure/effectiveCecProcedure-EffCEC_calcul-b	Sum of exchangeable bases (Ca, Mg, K, Na) without exchangeable acidity (H+Al), see ExchBases and ExchAcids for methods	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Total_unkn	\N	http://w3id.org/glosis/model/procedure/totalElementsProcedure-Total_unkn	Unspecified method	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
EffCEC_calcul-ba	\N	http://w3id.org/glosis/model/procedure/effectiveCecProcedure-EffCEC_calcul-ba	Sum of exchangeable bases (Ca, Mg, K, Na) plus exchangeable acidity (H+Al), see ExchBases and ExchAcids for methods	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Total_nh4-6mo7o24	\N	http://w3id.org/glosis/model/procedure/totalElementsProcedure-Total_nh4-6mo7o24	COLORIMETRIC VANADATE MOLYBDATE. Particularly used for Total P.	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Total_tp05	\N	http://w3id.org/glosis/model/procedure/totalElementsProcedure-Total_tp05	8 M HCl extraction. Particularly used for Total P.	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Total_hcl-aquaregia	\N	http://w3id.org/glosis/model/procedure/totalElementsProcedure-Total_hcl-aquaregia	Hydrocloric (HCl) extraction in nitric/perchloric acid mixture (totals) aqua regia	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Total_xrf	\N	http://w3id.org/glosis/model/procedure/totalElementsProcedure-Total_xrf	XRF	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Total_xrd	\N	http://w3id.org/glosis/model/procedure/totalElementsProcedure-Total_xrd	XRD	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Total_xrf-p	\N	http://w3id.org/glosis/model/procedure/totalElementsProcedure-Total_xrf-p	PXRF	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHCaCl2_sat	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHCaCl2_sat	pHCaCl2 (soil reaction) in saturated paste	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Total_tp03	\N	http://w3id.org/glosis/model/procedure/totalElementsProcedure-Total_tp03	reagent of Baeyens. Precipitation in form of Phosphomolybdate. Particularly used for Total P.	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Total_hcl	\N	http://w3id.org/glosis/model/procedure/totalElementsProcedure-Total_hcl	HCl extraction. Particularly used for Total P.	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Total_hclo4	\N	http://w3id.org/glosis/model/procedure/totalElementsProcedure-Total_hclo4	Perchloric acid percolation. Particularly used for Total P.	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Total_tp10	\N	http://w3id.org/glosis/model/procedure/totalElementsProcedure-Total_tp10	Colorimetric, unspecified extract	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Total_tp07	\N	http://w3id.org/glosis/model/procedure/totalElementsProcedure-Total_tp07	1:1 H2SO4 : HNO3. Particularly used for Total P.	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Total_tp04	\N	http://w3id.org/glosis/model/procedure/totalElementsProcedure-Total_tp04	acid fleischman. Particularly used for Total P.	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Total_tp09	\N	http://w3id.org/glosis/model/procedure/totalElementsProcedure-Total_tp09	Walker and Adams, 1958. Particularly used for Total P.	\N	WALKER, T. W., AND A. F. R. ADAMS. 1958. Studies on soil organic matter. I. Soil Sci. 85: 307-318. 
Total_tp08	\N	http://w3id.org/glosis/model/procedure/totalElementsProcedure-Total_tp08	After Nitric acid attack (boiling with HNO3), colometric determination (method of Duval).. Particularly used for Total P.	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Total_h2so4	\N	http://w3id.org/glosis/model/procedure/totalElementsProcedure-Total_h2so4	Total P-/- colorimetric in H2SO4-Se-Salicylic acid digest( sulfuric acid) Particularly used for Total P.	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Total_tp06	\N	http://w3id.org/glosis/model/procedure/totalElementsProcedure-Total_tp06	Molybdenum blue method, using ascorbic acid as reductant after heating of soil to 550 C and extraction with 6M sulphuric acid. Particularly used for Total P.	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Total_xtf-t	\N	http://w3id.org/glosis/model/procedure/totalElementsProcedure-Total_xtf-t	TXRF	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Total_hno3-aquafortis	\N	http://w3id.org/glosis/model/procedure/totalElementsProcedure-Total_hno3-aquafortis	Nitric acid attack. Particularly used for Total P.	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_ca10	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_ca10	CaCO3 Equivalent, CO2 evolution after HCl treatment. Gravimetric	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
BSat_calcul-ecec	\N	http://w3id.org/glosis/model/procedure/baseSaturationProcedure-BSat_calcul-ecec	Sum of exchangeable bases (Ca++, Mg++, K+, Na+) as percentage of EffCEC (method specified with EffCEC and ExchBases)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
BSat_calcul-cec	\N	http://w3id.org/glosis/model/procedure/baseSaturationProcedure-BSat_calcul-cec	Sum of exchangeable bases (Ca++, Mg++, K+, Na+) as percentage of CEC (method specified with CEC and ExchBases)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
SlbAn_calcul-unkn	\N	http://w3id.org/glosis/model/procedure/solubleSaltsProcedure-SlbAn_calcul-unkn	Sum of soluble anions (Cl, SO4, HCO2, CO3, NO3, F)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
SlbCat_calcul-unkn	\N	http://w3id.org/glosis/model/procedure/solubleSaltsProcedure-SlbCat_calcul-unkn	Sum of soluble cations (Ca, Mg, K, Na)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_acid-h3po4-dc	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_acid-h3po4-dc	Dissolution of carbonates by Phosphoric acid [H3PO4], external heat (dry combustion)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_acid-h2so4-nodc	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_acid-h2so4-nodc	Dissolution of carbonates by Sulfuric acid [H2SO4], no external (no dry combustion)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_acid-ch3cooh-unkn	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_acid-ch3cooh-unkn	Dissolution of carbonates by Acetic acid [CH3COOH], external heat unknown	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_acid-dc	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_acid-dc	Dissolution of carbonates by acid, external heat (dry combustion)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_acid-h2so4-dc	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_acid-h2so4-dc	Dissolution of carbonates by Sulfuric acid [H2SO4], external heat (dry combustion)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_ca11	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_ca11	Black, 1965-HCl	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_acid-hcl-dc	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_acid-hcl-dc	Dissolution of carbonates by Hydrochloric acid [HCl], or Perchloric acid [HClO4], external heat (dry combustion)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_calcul-tc-oc	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_calcul-tc-oc	Indirect estimate: inorganic carbon divided by 0.12 (computed as total carbon minus organic carbon)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_ca01	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_ca01	Method of Scheibler (volumetric)	\N	ON L 1084-99 (1999) Chemical analyses of soils—determination of carbonate. In: Austrian Standards Institute (ed) O‹ NORM L 1084. Austrian Standards Institute, Vienna
CaCO3_ca04	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_ca04	Calcimeter method (volumetric after adition of dilute acid)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_acid-h2so4-unkn	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_acid-h2so4-unkn	Dissolution of carbonates by Sulfuric acid [H2SO4], external heat unknown	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_acid-hcl-unkn	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_acid-hcl-unkn	Dissolution of carbonates by Hydrochloric acid [HCl], or Perchloric acid [HClO4], external heat unknown	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_ca12	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_ca12	Treatment with H2SO4 N/2 acid followed by titration with NaOH N/2 in presence of an indicator	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
OrgC_dc-ht	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_dc-ht	Unacidified. Dry combustion at high temperature (e.g. 1200 C and colometric CO2 measurement (Schlichting et al. 1995)	\N	Schlichting E, Blume HP, Stahr K (1995) Soils Practical (in German). Blackwell, Berlin
CaCO3_ca08	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_ca08	Bernard calcimeter (Total CaCO3)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_ca07	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_ca07	Pressure calcimeter (Nelson, 1982)	https://acsess.onlinelibrary.wiley.com/doi/book/10.2134/agronmonogr9.2.2ed	Nelson, D.W., and L.E. Sommers. 1982. Total carbon, organic carbon and organic matter. p. 539-579. In A.L. Page (ed.), 1983. Methods of soil analysis. Part 2. 2nd ed. Agron. Monogr. 9. ASA and SSSA, Madison, WI.
CaCO3_ca09	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_ca09	Carbonates: H3PO4 treatment at 80 deg. C and CO2 measurement like TOC (OC13), transformation into CaCO3 (Schlichting et al. 1995)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_acid-ch3cooh-nodc	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_acid-ch3cooh-nodc	Dissolution of carbonates by Acetic acid [CH3COOH], no external (no dry combustion)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_acid-ch3cooh-dc	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_acid-ch3cooh-dc	Dissolution of carbonates by Acetic acid [CH3COOH], external heat (dry combustion)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_ca06	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_ca06	H3PO4 acid at 80C, conductometric in NaOH (Schlichting & Blume, 1966)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_acid-h3po4-unkn	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_acid-h3po4-unkn	Dissolution of carbonates by Phosphoric acid [H3PO4], external heat unknown	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_ca03	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_ca03	Method of Piper (HCl)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_acid-h3po4-nodc	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_acid-h3po4-nodc	Dissolution of carbonates by Phosphoric acid [H3PO4], no external (no dry combustion)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_ca05	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_ca05	Gravimetric (USDA Agr. Hdbk 60-/- method Richards et al., 1954)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_acid-hcl-nodc	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_acid-hcl-nodc	Dissolution of carbonates by Hydrochloric acid [HCl], or Perchloric acid [HClO4], no external (no dry combustion)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_acid-unkn	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_acid-unkn	Dissolution of carbonates by acid, external heat unknown	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaCO3_ca02	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_ca02	Method of Wesemael	\N	Wesemael, J.C., 1955. De bepaling van van calciumcarbonaatgehalte van gronden. Chemisch Weekblad 51, 35-36.
CaCO3_acid-nodc	\N	http://w3id.org/glosis/model/procedure/totalCarbonateEquivalentProcedure-CaCO3_acid-nodc	Dissolution of carbonates by acid, no external (no dry combustion)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
SumTxtr_calcul	\N	http://w3id.org/glosis/model/procedure/textureSumProcedure-SumTxtr_calcul	Calculated sum of sand, silt and clay fractions	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CrsFrg_fld	\N	http://w3id.org/glosis/model/procedure/coarseFragmentsProcedure-CrsFrg_fld	Particles > 2 mm observed in the field. May include concretions and very hard aggregates	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CrsFrg_fldcls	\N	http://w3id.org/glosis/model/procedure/coarseFragmentsProcedure-CrsFrg_fldcls	Particles > 2 mm observed in the field and calculated from class values. May include concretions and very hard aggregates	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CrsFrg_lab	\N	http://w3id.org/glosis/model/procedure/coarseFragmentsProcedure-CrsFrg_lab	Particles > 2 mm measured in laboratory (sieved after light pounding). May include concretions and very hard aggregates	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Poros_calcul-pf0	\N	http://w3id.org/glosis/model/procedure/porosityProcedure-Poros_calcul-pf0	Porosity calculated from volumetric moisture content at pF 0 (1 cm)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHNaF_ratio1-5	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHNaF_ratio1-5	pHNaF (soil reaction) in 1:5 soil/NaF solution (0.01-1 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHNaF_ratio1-1	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHNaF_ratio1-1	pHNaF (soil reaction) in 1:1 soil/NaF solution (1 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHH2O_sat	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHH2O_sat	pHH2O (soil reaction) in water saturated paste	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHNaF_ratio1-2.5	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHNaF_ratio1-2.5	pHNaF (soil reaction) in 1:2.5 soil/NaF solution (0.01-1 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHCaCl2_ratio1-1	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHCaCl2_ratio1-1	pHCaCl2 (soil reaction) in 1:1 soil/1 M CaCl2 solution (1 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHKCl_sat	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHKCl_sat	pHKCl (soil reaction) in saturated paste	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHKCl_ratio1-2	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHKCl_ratio1-2	pHKCl (soil reaction) in 1:2 soil/KCl solution (0.01-1 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHH2O_unkn-spec	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHH2O_unkn-spec	Spectrally measured and converted to pHH2O (soil reaction) in unknown soil/water solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHKCl_ratio1-5	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHKCl_ratio1-5	pHKCl (soil reaction) in 1:5 soil/KCl solution (0.01-1 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHNaF_ratio1-2	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHNaF_ratio1-2	pHNaF (soil reaction) in 1:2 soil/NaF solution (0.01-1 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHH2O_ratio1-2.5	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHH2O_ratio1-2.5	pHH2O (soil reaction) in 1:2.5 soil/water solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHCaCl2_ratio1-5	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHCaCl2_ratio1-5	pHCaCl2 (soil reaction) in 1:5 soil/CaCl2 solution (0.01-1 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHH2O_ratio1-1	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHH2O_ratio1-1	pHH2O (soil reaction) in 1:1 soil/water solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHCaCl2	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHCaCl2	pHCaCl2 (soil reaction) in a soil/CaCl2 solution (0.01-1 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHH2O_ratio1-2	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHH2O_ratio1-2	pHH2O (soil reaction) in 1:2 soil/water solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHCaCl2_ratio1-10	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHCaCl2_ratio1-10	pHCaCl2 (soil reaction) in 1:10 soil/CaCl2 solution (0.01-1 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHH2O_ratio1-5	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHH2O_ratio1-5	pHH2O (soil reaction) in 1:5 soil/water solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHKCl_ratio1-1	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHKCl_ratio1-1	pHKCl (soil reaction) in 1:1 soil/KCl solution (1 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHCaCl2_ratio1-2	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHCaCl2_ratio1-2	pHCaCl2 (soil reaction) in 1:2 soil/CaCl2 solution (0.01-1 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHCaCl2_ratio1-2.5	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHCaCl2_ratio1-2.5	pHCaCl2 (soil reaction) in 1:2.5 soil/CaCl2 solution (0.01-1 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHNaF_sat	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHNaF_sat	pHNaF (soil reaction) in saturated paste	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHNaF	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHNaF	pHNaF (soil reaction) in a soil/NaF solution (0.01-1 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHKCl_ratio1-2.5	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHKCl_ratio1-2.5	pHKCl (soil reaction) in 1:2.5 soil/KCl solution (0.01-1 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHNaF_ratio1-10	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHNaF_ratio1-10	pHNaF (soil reaction) in 1:10 soil/NaF solution (0.01-1 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHH2O_ratio1-10	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHH2O_ratio1-10	pHH2O (soil reaction) in 1:10 soil/water solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
pHKCl_ratio1-10	\N	http://w3id.org/glosis/model/procedure/pHProcedure-pHKCl_ratio1-10	pHKCl (soil reaction) in 1:10 soil/KCl solution (0.01-1 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
RetentP_unkn-spec	\N	http://w3id.org/glosis/model/procedure/phosphorusRetentionProcedure-RetentP_unkn-spec	Spectrally measured and converted to P retention (P buffer index)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
RetentP_blakemore	\N	http://w3id.org/glosis/model/procedure/phosphorusRetentionProcedure-RetentP_blakemore	P retention at ~pH4.6  (acc. Blakemore 1987)	\N	Blakemore L.C. Searle P.L. and Daly, B.K. (1987) Methods for chemical analysis of soils. NZ Soil Bureau, Lower Hutt, New Zealand.
BlkDensW_we-unkn	\N	http://w3id.org/glosis/model/procedure/bulkDensityWholeSoilProcedure-BlkDensW_we-unkn	Whole earth. Type of sample unknown, at unknown humidity, not corrected for coarse fragments if any	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
BlkDensW_we-cl-fc	\N	http://w3id.org/glosis/model/procedure/bulkDensityWholeSoilProcedure-BlkDensW_we-cl-fc	Whole earth. Clod samples (natural clods), at field capacity (0.33 bar, 33 kPa, 330 cm, pF 2.5), not corrected for coarse fragments if any	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
BlkDensW_we-cl-od	\N	http://w3id.org/glosis/model/procedure/bulkDensityWholeSoilProcedure-BlkDensW_we-cl-od	Whole earth. Clod samples (natural clods), at oven dry, not corrected for coarse fragments if any	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
BlkDensW_we-co-od	\N	http://w3id.org/glosis/model/procedure/bulkDensityWholeSoilProcedure-BlkDensW_we-co-od	Whole earth. Core sampling (pF rings), at oven dry, not corrected for coarse fragments if any	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
BlkDensW_we-cl-unkn	\N	http://w3id.org/glosis/model/procedure/bulkDensityWholeSoilProcedure-BlkDensW_we-cl-unkn	Whole earth. Clod samples (natural clods), at unknown humidity, not corrected for coarse fragments if any	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
BlkDensW_we-co-fc	\N	http://w3id.org/glosis/model/procedure/bulkDensityWholeSoilProcedure-BlkDensW_we-co-fc	Whole earth. Core sampling (pF rings), at field capacity (0.33 bar, 33 kPa, 336 cm, pF 2.5), not corrected for coarse fragments if any	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
BlkDensW_we-co-unkn	\N	http://w3id.org/glosis/model/procedure/bulkDensityWholeSoilProcedure-BlkDensW_we-co-unkn	Whole earth. Core sampling (pF rings), at unknown humidity, not corrected for coarse fragments if any	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
BlkDensW_we-rpl-unkn	\N	http://w3id.org/glosis/model/procedure/bulkDensityWholeSoilProcedure-BlkDensW_we-rpl-unkn	Whole earth. Excavation and replacement (i.e. soils too fragile to remove a stable sample) e.g. by auger, at unknown humidity, not corrected for coarse fragments if any	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CEC_ph0-cohex	\N	http://w3id.org/glosis/model/procedure/cationExchangeCapacitySoilProcedure-CEC_ph0-cohex	CEC unbuffered at pH of the soil, in Cobalt(III) hexamine chloride solution 0,0166M (Cohex) [Co[NH3]6]Cl3 ), ISO 23470 (2007)  exchange solution	https://www.iso.org/standard/36879.html	\N
CEC_ph8-baoac	\N	http://w3id.org/glosis/model/procedure/cationExchangeCapacitySoilProcedure-CEC_ph8-baoac	CEC buffered at pH 8.0-8.5, in 0.5 M Ba-acetate exchange solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CEC_ph8-nh4oac	\N	http://w3id.org/glosis/model/procedure/cationExchangeCapacitySoilProcedure-CEC_ph8-nh4oac	CEC buffered at pH 8.0-8.5, in 1 M NH4-acetate exchange solution (0.25-1.0 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CEC_ph0-nh4cl	\N	http://w3id.org/glosis/model/procedure/cationExchangeCapacitySoilProcedure-CEC_ph0-nh4cl	CEC unbuffered at pH of the soil, in 1 M NH4-chloride exchange solution (0.2-1.0 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CEC_ph8-unkn	\N	http://w3id.org/glosis/model/procedure/cationExchangeCapacitySoilProcedure-CEC_ph8-unkn	CEC buffered at pH 8.0-8.5, in unknown exchange solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CEC_ph-unkn-m3	\N	http://w3id.org/glosis/model/procedure/cationExchangeCapacitySoilProcedure-CEC_ph-unkn-m3	CEC at unknown buffer, in Mehlich III exchange solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CEC_ph7-nh4oac	\N	http://w3id.org/glosis/model/procedure/cationExchangeCapacitySoilProcedure-CEC_ph7-nh4oac	CEC buffered at pH 7, in 1 M NH4-acetate (NH4OAc) exchange solution (0.25-1.0 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CEC_ph7-unkn	\N	http://w3id.org/glosis/model/procedure/cationExchangeCapacitySoilProcedure-CEC_ph7-unkn	CEC buffered at pH 7, in unknown exchange solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CEC_ph8-naoac	\N	http://w3id.org/glosis/model/procedure/cationExchangeCapacitySoilProcedure-CEC_ph8-naoac	CEC buffered at pH 8.0-8.5, in 1 M Na-acetate exchange solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CEC_ph-unkn-cacl2	\N	http://w3id.org/glosis/model/procedure/cationExchangeCapacitySoilProcedure-CEC_ph-unkn-cacl2	CEC at unknown buffer, in 0.1 M CaCl2 exchange solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CEC_ph0-kcl	\N	http://w3id.org/glosis/model/procedure/cationExchangeCapacitySoilProcedure-CEC_ph0-kcl	CEC unbuffered at pH of the soil, in 1 M KCl exchange solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CEC_ph7-edta	\N	http://w3id.org/glosis/model/procedure/cationExchangeCapacitySoilProcedure-CEC_ph7-edta	CEC buffered at pH 7, in 0.1 M Li-EDTA exchange solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CEC_ph0-unkn	\N	http://w3id.org/glosis/model/procedure/cationExchangeCapacitySoilProcedure-CEC_ph0-unkn	CEC unbuffered at pH of the soil, in unknown exchange solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CEC_ph8-licl2tea	\N	http://w3id.org/glosis/model/procedure/cationExchangeCapacitySoilProcedure-CEC_ph8-licl2tea	CEC buffered at pH 8.0-8.5, in 0.5 M Li-chloride - TEA exchange solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CEC_ph0-ag-thioura	\N	http://w3id.org/glosis/model/procedure/cationExchangeCapacitySoilProcedure-CEC_ph0-ag-thioura	CEC unbuffered at pH of the soil, in 0.01 M Ag-thioura exchange solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CEC_ph0-bacl2	\N	http://w3id.org/glosis/model/procedure/cationExchangeCapacitySoilProcedure-CEC_ph0-bacl2	CEC unbuffered at pH o the soil, in 0.5 M BaCl2 exchange solution (0.1.1.0 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CEC_ph8-bacl2tea	\N	http://w3id.org/glosis/model/procedure/cationExchangeCapacitySoilProcedure-CEC_ph8-bacl2tea	CEC buffered at pH 8.0-8.5, in 0.5 M BaCl2-TEA exchange solution (0.1.1.0 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CEC_ph0-nh4oac	\N	http://w3id.org/glosis/model/procedure/cationExchangeCapacitySoilProcedure-CEC_ph0-nh4oac	CEC unbuffered at pH of the soil, in 1 M NH4-acetate (NH4OAc) exchange solution (0.25-1.0 M)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CEC_ph-unkn-lioac	\N	http://w3id.org/glosis/model/procedure/cationExchangeCapacitySoilProcedure-CEC_ph-unkn-lioac	CEC at unknown buffer, in 0.5 M Li-acetate exchange solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
VMC_ud	\N	http://w3id.org/glosis/model/procedure/moistureContentProcedure-VMC_ud	Undisturbed samples	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
VMC_d-cl-ww	\N	http://w3id.org/glosis/model/procedure/moistureContentProcedure-VMC_d-cl-ww	Pressure-plate extraction, disturbed -clod- samples (wt%) * density on weight/weight basis; to be converted to v/v (with BD at appropriate humidity)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
VMC_calcul-ptf-brookscorey	\N	http://w3id.org/glosis/model/procedure/moistureContentProcedure-VMC_calcul-ptf-brookscorey	Calculated by PTF of brooks - corey	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
VMC_d-ww	\N	http://w3id.org/glosis/model/procedure/moistureContentProcedure-VMC_d-ww	Volumetric moisture content in disturbed samples on weight/weight basis to be converted to v/v (with BD at appropriate humidity)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
VMC_calcul-ptf	\N	http://w3id.org/glosis/model/procedure/moistureContentProcedure-VMC_calcul-ptf	Calculated by PTF	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
VMC_d-cl	\N	http://w3id.org/glosis/model/procedure/moistureContentProcedure-VMC_d-cl	Pressure-plate extraction, disturbed -clod- samples (wt%) * density	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
VMC_d	\N	http://w3id.org/glosis/model/procedure/moistureContentProcedure-VMC_d	Volumetric moisture content in disturbed samples	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
VMC_ud-co	\N	http://w3id.org/glosis/model/procedure/moistureContentProcedure-VMC_ud-co	Volumetric moisture content in undisturbed samples (pF rings cores)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
VMC_ud-cl	\N	http://w3id.org/glosis/model/procedure/moistureContentProcedure-VMC_ud-cl	Natural clod	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaSO4_gy01	\N	http://w3id.org/glosis/model/procedure/gypsumProcedure-CaSO4_gy01	Dissolved in water and precipitated by acetone	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaSO4_gy06	\N	http://w3id.org/glosis/model/procedure/gypsumProcedure-CaSO4_gy06	Total-S, using LECO furnace, minus easily soluble MgSO4 and Na2SO4	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaSO4_gy07	\N	http://w3id.org/glosis/model/procedure/gypsumProcedure-CaSO4_gy07	Schleiff method, electrometric	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaSO4_gy04	\N	http://w3id.org/glosis/model/procedure/gypsumProcedure-CaSO4_gy04	In 0.1 M Na3-EDTA-/- turbidimetric (Begheijn, 1993)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaSO4_gy03	\N	http://w3id.org/glosis/model/procedure/gypsumProcedure-CaSO4_gy03	Calculated from conductivity of successive dilutions	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaSO4_gy05	\N	http://w3id.org/glosis/model/procedure/gypsumProcedure-CaSO4_gy05	Gravimetric after dissolution in 0.2 N HCl (USSR-method)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
CaSO4_gy02	\N	http://w3id.org/glosis/model/procedure/gypsumProcedure-CaSO4_gy02	Differ. between Ca-conc. in sat. extr. and Ca-conc. in 1/50 s/w solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
EC_ratio1-10	\N	http://w3id.org/glosis/model/procedure/electricalConductivityProcedure-EC_ratio1-10	Elec. conductivity at 1:10 soil/water ratio	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
EC_ratio1-2	\N	http://w3id.org/glosis/model/procedure/electricalConductivityProcedure-EC_ratio1-2	Elec. conductivity at 1:2 soil/water ratio	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
EC_ratio1-2.5	\N	http://w3id.org/glosis/model/procedure/electricalConductivityProcedure-EC_ratio1-2.5	Elec. conductivity at 1:2.5 soil/water ratio	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
EC_ratio1-5	\N	http://w3id.org/glosis/model/procedure/electricalConductivityProcedure-EC_ratio1-5	Elec. conductivity at 1:5 soil/water ratio	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
ECe_sat	\N	http://w3id.org/glosis/model/procedure/electricalConductivityProcedure-ECe_sat	Elec. conductivity in saturated paste (ECe)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
EC_ratio1-1	\N	http://w3id.org/glosis/model/procedure/electricalConductivityProcedure-EC_ratio1-1	Elec. conductivity at 1:1 soil/water ratio	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
ExchBases_ph7-nh4oac-fp	\N	http://w3id.org/glosis/model/procedure/exchangeableBasesProcedure-ExchBases_ph7-nh4oac-fp	Exch bases (Ca, Mg, K, Na) buffered at pH 7, in 1M NH4OAc, K and Na with FP (Flame Photometry)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
ExchBases_ph8-bacl2tea	\N	http://w3id.org/glosis/model/procedure/exchangeableBasesProcedure-ExchBases_ph8-bacl2tea	Exch bases (Ca, Mg, K, Na) buffered at pH 8.0-8.5, in 0.5 M BaCl2 - TEA solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
ExchBases_ph-unkn-edta	\N	http://w3id.org/glosis/model/procedure/exchangeableBasesProcedure-ExchBases_ph-unkn-edta	Exch bases (Ca, Mg, K, Na) unknown buffer, in EDTA solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
ExchBases_ph-unkn-m3	\N	http://w3id.org/glosis/model/procedure/exchangeableBasesProcedure-ExchBases_ph-unkn-m3	Exch bases (Ca, Mg, K, Na) unknown buffer, in Mehlich3 solution with extractable ppm assumed exchangeable cmolc/kg	https://doi.org/10.1080/00103628409367568	\N
ExchBases_ph0-nh4cl	\N	http://w3id.org/glosis/model/procedure/exchangeableBasesProcedure-ExchBases_ph0-nh4cl	Exch bases (Ca, Mg, K, Na) unbuffered, in 1 M NH4Cl (0.05-1.0 m?)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
ExchBases_ph8-unkn	\N	http://w3id.org/glosis/model/procedure/exchangeableBasesProcedure-ExchBases_ph8-unkn	Exch bases (Ca, Mg, K, Na) buffered at pH 8.0-8.5, in unknown solution	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
ExchBases_ph7-nh4oac	\N	http://w3id.org/glosis/model/procedure/exchangeableBasesProcedure-ExchBases_ph7-nh4oac	Exch bases (Ca, Mg, K, Na) buffered at pH 7, in 1M NH4OAc	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
ExchBases_ph0-cohex	\N	http://w3id.org/glosis/model/procedure/exchangeableBasesProcedure-ExchBases_ph0-cohex	Exch bases (Ca, Mg, K, Na) unbuffered, in Cobalt(III) hexamine chloride solution 0,0166M (Cohex) [Co[NH3]6]Cl3 ), ISO 23470 (2007)	https://www.iso.org/standard/36879.html	\N
ExchBases_ph7-unkn	\N	http://w3id.org/glosis/model/procedure/exchangeableBasesProcedure-ExchBases_ph7-unkn	Exch bases (Ca, Mg, K, Na) buffered at pH 7, in unknown solution	https://www.isric.org/sites/default/files/WOSISprocedureManual_2020nov17web.pdf#page=70	\N
ExchBases_ph-unkn-m3-spec	\N	http://w3id.org/glosis/model/procedure/exchangeableBasesProcedure-ExchBases_ph-unkn-m3-spec	Exch bases (Ca, Mg, K, Na) spectrally measured and converted to, unknown buffer, in Mehlich3 solution with extractable ppm assumed exchangeable cmolc/kg	https://doi.org/10.1080/00103628409367568	\N
ExchBases_ph7-nh4oac-aas	\N	http://w3id.org/glosis/model/procedure/exchangeableBasesProcedure-ExchBases_ph7-nh4oac-aas	Exch bases (Ca, Mg, K, Na) buffered at pH 7, in 1M NH4OAc, Ca and Mg with AAS (Atomic Absorption Spectrometry)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
OrgC_dc-lt-loi	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_dc-lt-loi	Unacidified. Loss on ignition (NL) is total Organic Carbon	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
OrgC_calcul-tc-ic	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_calcul-tc-ic	Calculated as total carbon minus inorganic carbon	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
OrgC_wc-cro3-tiurin	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_wc-cro3-tiurin	Wet oxidation according to Tiurin with K-dichromate	\N	I. V. TIURIN, Pochvovodenie (Pedology), (1931) 36.
OrgC_dc-lt	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_dc-lt	Unacidified. Dry combustion at low temperature e.g. 500 C	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
OrgC_acid-dc	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_acid-dc	Acidified dry combustion or dry oxidation methods (after removal of carbonates)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
OrgC_acid-dc-ht-analyser	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_acid-dc-ht-analyser	Acidified. Furnace combustion (e.g., LECO combustion analyzer, Dumas method)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
OrgC_acid-dc-lt	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_acid-dc-lt	Acidified. Dry combustion at 500 C	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
OrgC_wc-cro3-nelson	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_wc-cro3-nelson	Wet oxidation according to Nelson and Sommers (1996)	\N	Nelson and Sommers (1996) in: Sparks DL (ed.). Soil Sci. Soc. Am. book series 5, part 3, pp 961-1010.
OrgC_dc	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_dc	Unacidified. Dry combustion or dry oxidation methods (without prior removal of carbonates)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
OrgC_acid-dc-lt-loi	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_acid-dc-lt-loi	Acidified. Loss on ignition (NL)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
OrgC_wc-cro3-walkleyblack	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_wc-cro3-walkleyblack	Walkley-Black method (chromic acid digestion)	\N	Walkley, A. and I. A. Black. 1934. An Examination of Degtjareff Method for Determining Soil Organic Matter and a Proposed Modification of the Chromic Acid Titration Method. Soil Sci. 37:29–37.
OrgC_acid-dc-ht	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_acid-dc-ht	Acidified. Dry combustion at 1200 C and colometric CO2 measurement (Schlichting et al. 1995)	\N	Schlichting E, Blume HP, Stahr K (1995) Soils Practical (in German). Blackwell, Berlin
OrgC_dc-spec	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_dc-spec	Spectrally measured and converted to Unacidified Dry combustion or dry oxidation methods	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
OrgC_wc-cro3-knopp	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_wc-cro3-knopp	Wet oxidation according to Knopp with chromic acid and gravimetric determination of CO2	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
OrgC_dc-ht-analyser	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_dc-ht-analyser	Unacidified. Dry combustion by furnace (e.g., LECO combustion analyzer, Dumas method). Is total Carbon?	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
OrgC_wc-cro3-nrcs6a1c	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_wc-cro3-nrcs6a1c	Wet oxidation according to USDA-NRCS method 6A1c with acid dichromate digestion, FeSO4 titration, automatic titrator	https://www.nrcs.usda.gov/Internet/FSE_DOCUMENTS/stelprdb1253872.pdf	\N
OrgC_wc-cro3-kalembra	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_wc-cro3-kalembra	Wet oxidation according to Kalembra and Jenkinson (1973) with acid dichromate	https://doi.org/10.1002/jsfa.2740240910	\N
OrgC_acid-dc-mt	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_acid-dc-mt	Acidified. Dry combustion at 840 C	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
OrgC_wc-cro3-jackson	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_wc-cro3-jackson	Wet oxidation according to Jackson (1958) with chromic acid digestion	\N	Jackson, M. L. (1958) Soil Chemical Analysis. Prentice-Hall, Englewood Cliffs, New Jersey.
OrgC_acid-dc-spec	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_acid-dc-spec	Spectrally measured and converted to Acidified dry combustion or dry oxidation methods (after removal of carbonates)	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
OrgC_wc-cro3-kurmies	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_wc-cro3-kurmies	Wet oxidation according to Kurmies with K2Cr2O7+H2SO4	\N	B. KURMIES, Z. Pflanzenernühr. Dung. u Bodenk., 44 (1949) 121
OrgC_dc-mt	\N	http://w3id.org/glosis/model/procedure/carbonOrganicProcedure-OrgC_dc-mt	Unacidified. Dry combustion at medium temperature e.g. 840 C	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
ExchAcid_ph7-unkn	\N	http://w3id.org/glosis/model/procedure/acidityExchangeableProcedure-ExchAcid_ph7-unkn	Exch acidity (H+Al) buffered at pH 7, in unknown extract	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
ExchAcid_ph0-unkn	\N	http://w3id.org/glosis/model/procedure/acidityExchangeableProcedure-ExchAcid_ph0-unkn	Exch acidity (H+Al) unbuffered, in unknown extract	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
ExchAcid_ph8-bacl2tea	\N	http://w3id.org/glosis/model/procedure/acidityExchangeableProcedure-ExchAcid_ph8-bacl2tea	Exch (extractable / potential) acidity (Al) buffered at pH 8.0-8.5, in 1 M BaCl2 - TEA	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
ExchAcid_ph0-kcl1m	\N	http://w3id.org/glosis/model/procedure/acidityExchangeableProcedure-ExchAcid_ph0-kcl1m	Exch acidity (H+Al) unbuffered, in 1 M KCl extract	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
ExchAcid_ph0-nh4cl	\N	http://w3id.org/glosis/model/procedure/acidityExchangeableProcedure-ExchAcid_ph0-nh4cl	Exch acidity (H+Al) unbuffered, in 0.05-0.1 M NH4Cl extract	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
ExchAcid_ph7-caoac	\N	http://w3id.org/glosis/model/procedure/acidityExchangeableProcedure-ExchAcid_ph7-caoac	Exch acidity (H+Al) buffered at pH 7, in 1M Ca-acetate extract	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
ExchAcid_ph8-unkn	\N	http://w3id.org/glosis/model/procedure/acidityExchangeableProcedure-ExchAcid_ph8-unkn	Exch (extractable / potential) acidity (Al) buffered at pH 8.0-8.5, in unknown extract	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
HumAcidC_unkn	\N	http://w3id.org/glosis/model/procedure/organicMatterProcedure-HumAcidC_unkn	Humic acid carbon_unknown method	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
FulAcidC_unkn	\N	http://w3id.org/glosis/model/procedure/organicMatterProcedure-FulAcidC_unkn	Fulvic acid carbon_unknown method	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
TotHumC_unkn	\N	http://w3id.org/glosis/model/procedure/organicMatterProcedure-TotHumC_unkn	Total humic carbon_unknown method	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
OrgM_calcul-oc1.73	\N	http://w3id.org/glosis/model/procedure/organicMatterProcedure-OrgM_calcul-oc1.73	Organic carbon * 1,73	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
BlkDensF_fe-co-od	\N	http://w3id.org/glosis/model/procedure/bulkDensityFineEarthProcedure-BlkDensF_fe-co-od	Fine earth. Core sampling (pF rings), at oven dry, corrected for coarse fragments if any	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
BlkDensF_fe-co-unkn	\N	http://w3id.org/glosis/model/procedure/bulkDensityFineEarthProcedure-BlkDensF_fe-co-unkn	Fine earth. Core sampling (pF rings), at unknown humidity, corrected for coarse fragments if any	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
BlkDensF_fe-unkn-od	\N	http://w3id.org/glosis/model/procedure/bulkDensityFineEarthProcedure-BlkDensF_fe-unkn-od	Fine earth. Type of sample unknown, at oven dry, corrected for coarse fragments if any	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
BlkDensF_fe-co-fc	\N	http://w3id.org/glosis/model/procedure/bulkDensityFineEarthProcedure-BlkDensF_fe-co-fc	Fine earth. Core sampling (pF rings), at field capacity (0.33 bar, 33 kPa, 336 cm, pF 2.5), corrected for coarse fragments if any	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
BlkDensF_fe-rpl-unkn	\N	http://w3id.org/glosis/model/procedure/bulkDensityFineEarthProcedure-BlkDensF_fe-rpl-unkn	Fine earth. Excavation and replacement (i.e. soils too fragile to remove a stable sample) e.g. by auger, at unknown humidity, corrected for coarse fragments if any	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
BlkDensF_fe-cl-unkn	\N	http://w3id.org/glosis/model/procedure/bulkDensityFineEarthProcedure-BlkDensF_fe-cl-unkn	Fine earth. Clod samples (natural clods or reconstituted from < 2mm sample), at unknown humidity, corrected for coarse fragments if any	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
BlkDensF_fe-unkn-fc	\N	http://w3id.org/glosis/model/procedure/bulkDensityFineEarthProcedure-BlkDensF_fe-unkn-fc	Fine earth. Type of sample unknown, at field capacity (0.33 bar, 33 kPa, 330 cm, pF 2.5), corrected for coarse fragments if any	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
BlkDensF_fe-cl-od	\N	http://w3id.org/glosis/model/procedure/bulkDensityFineEarthProcedure-BlkDensF_fe-cl-od	Fine earth. Clod samples (natural clods or reconstituted from < 2mm sample), at oven dry, corrected for coarse fragments if any	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
BlkDensF_fe-cl-fc	\N	http://w3id.org/glosis/model/procedure/bulkDensityFineEarthProcedure-BlkDensF_fe-cl-fc	Fine earth. Clod samples (natural clods or reconstituted from < 2mm sample), at field capacity (0.33 bar, 33 kPa, 330 cm, pF 2.5), corrected for coarse fragments if any	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
BlkDensF_fe-unkn	\N	http://w3id.org/glosis/model/procedure/bulkDensityFineEarthProcedure-BlkDensF_fe-unkn	Fine earth. Type of sample unknown, at unknown humidity, corrected for coarse fragments if any	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
KSat_calcul-ptf-saxton	\N	http://w3id.org/glosis/model/procedure/hydraulicConductivityProcedure-KSat_calcul-ptf-saxton	Saturated hydraulic conductivity.	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Ksat_invbhole	\N	http://w3id.org/glosis/model/procedure/hydraulicConductivityProcedure-Ksat_invbhole	Saturated hydraulic conductivity. Inverse bore hole method	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
KSat_calcul-ptf	\N	http://w3id.org/glosis/model/procedure/hydraulicConductivityProcedure-KSat_calcul-ptf	Saturated hydraulic conductivity.	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
KSat_calcul-ptf-genuchten	\N	http://w3id.org/glosis/model/procedure/hydraulicConductivityProcedure-KSat_calcul-ptf-genuchten	Saturated and not saturated hydraulic conductivity.	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Ksat_column	\N	http://w3id.org/glosis/model/procedure/hydraulicConductivityProcedure-Ksat_column	Saturated hydraulic conductivity. Permeability in cm/hr determined in column filled with fine earth fraction	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Ksat_dblring	\N	http://w3id.org/glosis/model/procedure/hydraulicConductivityProcedure-Ksat_dblring	Saturated hydraulic conductivity. Double ring method	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Ksat_bhole	\N	http://w3id.org/glosis/model/procedure/hydraulicConductivityProcedure-Ksat_bhole	Saturated hydraulic conductivity. Bore hole method	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Extr_ap15	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_ap15	Method of Hunter (1975) modified after ISFEI method. Particularly used for available P.	\N	Hunter, A. 1975. New techniques and equipment for routine soil/plant analytical procedures. In: Soil Management in Tropical America. (eds E. Borremiza & A. Alvarado). N.C. State University, Raleigh, NC.
Extr_edta	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_edta	EthyleneDiamineTetraAcetic acid (EDTA) method	https://journals.lww.com/soilsci/Citation/1954/10000/SOIL_AND_PLANT_STUDIES_WITH_CHELATES_OF.8.aspx	\N
Extr_nahco3-olsen	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_nahco3-olsen	Method of Olsen (0.5 M Sodium Bicarbonate (NaHCO3) extraction at pH8.5). Particularly used for available P.	https://acsess.onlinelibrary.wiley.com/doi/book/10.2134/agronmonogr9.2	\N
Extr_hcl-nh4f-bray1	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_hcl-nh4f-bray1	Method of Bray I  (dilute HCl/NH4F). Particularly used for available P.	https://doi.org/10.1097/00010694-194501000-00006	\N
Extr_ap20	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_ap20	Olsen (not acid soils) resp. Bray I (acid soils). Particularly used for available P.	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Extr_hotwater	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_hotwater	Hot water. Particularly used for available B	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Extr_m3	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_m3	Mehlich3 method (extractant 0.2 N CH3COOH + 0.25 N NH4NO3 + 0.015 N NH4F + 0.013 N HNO3 + 0.001 M EDTA)	https://doi.org/10.1080/00103628409367568	\N
Extr_nahco3-olsen-dabin	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_nahco3-olsen-dabin	Method of Olsen, modified by Dabin (ORSTOM). Particularly used for available P.	https://docplayer.fr/81912854-Application-des-dosages-automatiques-a-l-analyse-des-sols-2e-partie-par.html	\N
Extr_hcl-nh4f-kurtz-bray	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_hcl-nh4f-kurtz-bray	Method of Kurtz-Bray I (0.025 M HCl + 0.03 M NH4F). Particularly used for available P.	https://doi.org/10.1097/00010694-194501000-00006	\N
Extr_ap21	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_ap21	Olsen (if pH > 7) resp. Mehlich (if pH < 7). Particularly used for available P.	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Extr_capo4	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_capo4	Ca phosphate. Particularly used for available S.	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Extr_hcl-h2so4-nelson	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_hcl-h2so4-nelson	Method of Nelson (dilute HCl/H2SO4). Particularly used for available P.	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Extr_nh4ch3ch-oh-cooh-leuven	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_nh4ch3ch-oh-cooh-leuven	NH4-lactate extraction method (KU-Leuven). Particularly used for available P.	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Extr_cacl2	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_cacl2	CaCl2. Particularly used for soluble P.	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Extr_c6h8o7-reeuwijk	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_c6h8o7-reeuwijk	Complexation with citric acid (van Reeuwijk). Particularly used for available P.	https://www.isric.org/documents/document-type/technical-paper-09-procedures-soil-analysis-6th-edition	\N
Extr_hno3	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_hno3	Nitric acid (HNO3) method	https://www.iso.org/standard/60060.html	ISO. ISO/DIS 17586 Soil Quality - Extraction of Trace Elements Using Dilute Nitric Acid, 2016; p 14
Extr_m2	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_m2	Mehlich2 method	https://doi.org/10.1080/00103627609366673	\N
Extr_m3-spec	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_m3-spec	Spectrally measured and converted to Mehlich3 method (extractant 0.2 N CH3COOH + 0.25 N NH4NO3 + 0.015 N NH4F + 0.013 N HNO3 + 0.001 M EDTA)	https://doi.org/10.1080/00103628409367568	\N
Extr_naoac-morgan	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_naoac-morgan	Method of Morgan (Na-acetate/acetic acid). Particularly used for available P.	https://portal.ct.gov/-/media/CAES/DOCUMENTS/Publications/Bulletins/B450pdf.pdf?la=en	\N
Extr_h2so4-truog	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_h2so4-truog	Method of Truog (dilute H2SO4). Particularly used for available P.	https://doi.org/10.2134/agronj1930.00021962002200100008x	\N
Extr_nh4-co3-2-ambic1	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_nh4-co3-2-ambic1	Ambic1 method (ammonium bicarbonate) (South Africa). Particularly used for available P.	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
Extr_ap14	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_ap14	Method of Saunders and Metelerkamp (anion-exch. resin). Particularly used for available P.	\N	Saunders and Metelerkamp
Extr_hcl-nh4f-bray2	\N	http://w3id.org/glosis/model/procedure/extractableElementsProcedure-Extr_hcl-nh4f-bray2	Method of Bray II (dilute HCl/NH4F). Particularly used for available P.	https://doi.org/10.1097/00010694-194501000-00006	\N
TotC_dc-mt	\N	http://w3id.org/glosis/model/procedure/carbonTotalProcedure-TotC_dc-mt	Unacidified dry combustion at medium temperature (550-950 C).	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
TotC_dc-ht-analyser	\N	http://w3id.org/glosis/model/procedure/carbonTotalProcedure-TotC_dc-ht-analyser	Unacidified dry combustion at high temperature (950-1400 C). Total Carbon (USDA-NRCS method 6A), LECO analyzer at 1140 C	https://www.nrcs.usda.gov/Internet/FSE_DOCUMENTS/stelprdb1253872.pdf	\N
TotC_dc-ht-spec	\N	http://w3id.org/glosis/model/procedure/carbonTotalProcedure-TotC_dc-ht-spec	Spectrally measured and converted to Unacidified dry combustion at high temperature (950-1400 C).	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
TotC_calcul-ic-oc	\N	http://w3id.org/glosis/model/procedure/carbonTotalProcedure-TotC_calcul-ic-oc	Calculated as sum of inorganic carbon and organic carbon	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
TotC_dc-ht	\N	http://w3id.org/glosis/model/procedure/carbonTotalProcedure-TotC_dc-ht	Unacidified dry combustion at high temperature (950-1400 C). Total Carbon	https://www.isric.org/sites/default/files/isric_report_2014_01.pdf	Leenaars J.G.B., A.J.M. van Oostrum and M. Ruiperez Gonzalez, 2014. Africa Soil Profiles Database, Version 1.2. A compilation of georeferenced and standardised legacy soil profile data for Sub-Saharan Africa (with dataset). ISRIC Report 2014/01. Africa Soil Information Service (AfSIS) project and ISRIC - World Soil Information, Wageningen, the Netherlands. See Annex 4.
\.


--
-- TOC entry 4970 (class 0 OID 54922858)
-- Dependencies: 233
-- Data for Name: profile; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.profile (profile_id, plot_id, surface_id, profile_code) FROM stdin;
\.


--
-- TOC entry 4972 (class 0 OID 54922867)
-- Dependencies: 235
-- Data for Name: project; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.project (project_id, name) FROM stdin;
\.


--
-- TOC entry 4975 (class 0 OID 54922878)
-- Dependencies: 238
-- Data for Name: project_related; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.project_related (project_source_id, project_target_id, role) FROM stdin;
\.


--
-- TOC entry 4983 (class 0 OID 54922970)
-- Dependencies: 246
-- Data for Name: project_site; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.project_site (project_id, site_id) FROM stdin;
\.


--
-- TOC entry 5010 (class 0 OID 54924209)
-- Dependencies: 273
-- Data for Name: property_desc; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.property_desc (property_desc_id, property_pretty_name, uri) FROM stdin;
MineralConcentrationsNature	Mineral Concentrations Nature	http://w3id.org/glosis/model/layerhorizon/mineralConcNatureProperty
Landuse	Landuse	http://w3id.org/glosis/model/siteplot/landUseClassProperty
poresAbundanceProperty	poresAbundanceProperty	http://w3id.org/glosis/model/layerhorizon/poresAbundanceProperty
CarbonateForms	Carbonate Forms	http://w3id.org/glosis/model/layerhorizon/carbonatesFormsProperty
soilDepthRootableClassProperty	soilDepthRootableClassProperty	http://w3id.org/glosis/model/common/soilDepthRootableClassProperty
Stickiness	Stickiness	http://w3id.org/glosis/model/layerhorizon/stickinessProperty
poresSizeProperty	poresSizeProperty	http://w3id.org/glosis/model/layerhorizon/poresSizeProperty
RockOutcropsCover	Rock Outcrops Cover	http://w3id.org/glosis/model/siteplot/rockOutcropsCoverProperty
CoatingsAbundance	Coatings Abundance	http://w3id.org/glosis/model/layerhorizon/coatingAbundanceProperty
KoeppenClass	Koeppen Class	http://w3id.org/glosis/model/siteplot/koeppenClassProperty
MineralConcentrationsHardness	Mineral Concentrations Hardness	http://w3id.org/glosis/model/layerhorizon/mineralConcHardnessProperty
MottlesBoundary	Mottles Boundary	http://w3id.org/glosis/model/layerhorizon/mottlesBoundaryClassificationProperty
DrainageClass	Drainage Class	\N
GypsumForms	Gypsum Forms	http://w3id.org/glosis/model/layerhorizon/gypsumFormsProperty
Cementation/compactionNature	Cementation/compaction Nature	http://w3id.org/glosis/model/layerhorizon/cementationNatureProperty
CoatingsNature	Coatings Nature	http://w3id.org/glosis/model/layerhorizon/coatingNatureProperty
FloodFrequency	Flood Frequency	http://w3id.org/glosis/model/siteplot/floodFrequencyProperty
parentTextureUnconsolidatedProperty	parentTextureUnconsolidatedProperty	http://w3id.org/glosis/model/siteplot/parentTextureUnconsolidatedProperty
mottlesPresenceProperty	mottlesPresenceProperty	http://w3id.org/glosis/model/layerhorizon/mottlesPresenceProperty
ArtefactKind	Artefact Kind	\N
ArtefactHardness	Artefact Hardness	http://w3id.org/glosis/model/layerhorizon/MineralConcHardness
HumanInfluence	Human Influence	http://w3id.org/glosis/model/siteplot/humanInfluenceClassProperty
RockShape	Rock Shape	http://w3id.org/glosis/model/common/rockShapeProperty
mineralContentProperty	mineralContentProperty	http://w3id.org/glosis/model/layerhorizon/mineralContentProperty
soilSuborderUSDA	USDA Suborder	http://w3id.org/glosis/model/profile/SoilClassificationUSDA
cationExchangeCapacityEffectiveProperty	cationExchangeCapacityEffectiveProperty	http://w3id.org/glosis/model/layerhorizon/cationExchangeCapacityEffectiveProperty
Lithology	Lithology	http://w3id.org/glosis/model/siteplot/geologyProperty
PeaDescomposition	Pea Descomposition	http://w3id.org/glosis/model/layerhorizon/peatDecompostionProperty
CoatingsForm	Coatings Form	http://w3id.org/glosis/model/layerhorizon/coatingFormProperty
RockNature	Rock Nature	http://w3id.org/glosis/model/siteplot/lithologyProperty
MottlesContrast	Mottles Contrast	http://w3id.org/glosis/model/layerhorizon/mottlesContrastProperty
PeatVolume	Peat Volume	http://w3id.org/glosis/model/layerhorizon/peatVolumeProperty
BiologicalAbundance	Biological Abundance	http://w3id.org/glosis/model/layerhorizon/biologicalAbundanceProperty
SurfaceAge	Surface Age	http://w3id.org/glosis/model/siteplot/surfaceAgeProperty
SoilOdour	Soil Odour	\N
PoreAbundance	Pore Abundance	http://w3id.org/glosis/model/layerhorizon/PoresAbundance
saltProperty	saltProperty	http://w3id.org/glosis/model/layerhorizon/saltProperty
RedoxPotential	Redox Potential	\N
SupplementaryQualifierWRB	WRB Supplementary Qualifier	http://w3id.org/glosis/model/profile/SoilClassificationWRB
OrganicMatter	Organic Matter Content	http://w3id.org/glosis/model/layerhorizon/OrganicMatterValue
ForestAbundance	Forest Abundance	http://w3id.org/glosis/model/siteplot/ForestAbundanceProperty
PeatDrainage	Peat Drainage	http://w3id.org/glosis/model/layerhorizon/peatDrainageProperty
GrassAbundance	Grass Abundance	http://w3id.org/glosis/model/siteplot/GrassAbundanceProperty
StructureSize	Structure Size	http://w3id.org/glosis/model/layerhorizon/structureSizeProperty
SaltContent	Salt Content	http://w3id.org/glosis/model/layerhorizon/saltContentProperty
ExternalDrainageClass	External Drainage Class	\N
textureLabClassProperty	textureLabClassProperty	http://w3id.org/glosis/model/layerhorizon/textureLabClassProperty
MottlesColour	Mottles Colour	http://w3id.org/glosis/model/layerhorizon/mottlesColourProperty
SoilTexture	Soil Texture	http://w3id.org/glosis/model/common/textureProperty
soilDepthSampledProperty	soilDepthSampledProperty	http://w3id.org/glosis/model/common/soilDepthSampledProperty
Cementation/compactionStructure	Cementation/compaction Structure	http://w3id.org/glosis/model/layerhorizon/cementationFabricProperty
MineralConcentrationsColour	Mineral Concentrations Colour	http://w3id.org/glosis/model/layerhorizon/mineralConcColourProperty
RockPrimary	Rock Primary	http://w3id.org/glosis/model/layerhorizon/mineralFragmentsProperty
BulkDensity	Bulk Density	http://w3id.org/glosis/model/layerhorizon/bulkDensityMineralProperty
solubleCationsTotalProperty	solubleCationsTotalProperty	http://w3id.org/glosis/model/layerhorizon/solubleCationsTotalProperty
gypsumWeightProperty	gypsumWeightProperty	http://w3id.org/glosis/model/layerhorizon/gypsumWeightProperty
SlopeOrientation	Slope Orientation	http://w3id.org/glosis/model/siteplot/slopeOrientationClassProperty
organicMatterClassProperty	organicMatterClassProperty	http://w3id.org/glosis/model/common/organicMatterClassProperty
BiologicalKind	Biological Kind	http://w3id.org/glosis/model/layerhorizon/biologicalFeaturesProperty
ComplexLandform	Complex Landform	http://w3id.org/glosis/model/siteplot/landformComplexProperty
Cementation/compactionDegree	Cementation/compaction Degree	http://w3id.org/glosis/model/layerhorizon/cementationDegreeProperty
infiltrationRateClassProperty	infiltrationRateClassProperty	http://w3id.org/glosis/model/common/infiltrationRateClassProperty
soilDepthBedrockProperty	soilDepthBedrockProperty	http://w3id.org/glosis/model/common/soilDepthBedrockProperty
PeatBulkDensity	Peat Bulk Density	http://w3id.org/glosis/model/layerhorizon/bulkDensityPeatProperty
SandfractionTexture	Sand fraction Texture	http://w3id.org/glosis/model/layerhorizon/sandyTextureProperty
SlopePathway	Slope Pathway	http://w3id.org/glosis/model/siteplot/slopePathwaysProperty
ConsistenceDry	Consistence Dry	http://w3id.org/glosis/model/layerhorizon/consistenceDryProperty
MineralConcentrationsShape	Mineral Concentrations Shape	http://w3id.org/glosis/model/layerhorizon/mineralConcShapeProperty
slopeGradientClassProperty	slopeGradientClassProperty	http://w3id.org/glosis/model/siteplot/slopeGradientClassProperty
EffectiveSoilDepth	Effective soil depth	http://w3id.org/glosis/model/common/SoilDepthRootableClass
MoistureRegime	Moisture Regime	\N
ErosionDegree	Erosion Degree	http://w3id.org/glosis/model/siteplot/erosionDegreeProperty
FloodDuration	Flood Duration	http://w3id.org/glosis/model/siteplot/floodDurationProperty
soilClassificationUSDAProperty	soilClassificationUSDAProperty	http://w3id.org/glosis/model/profile/soilClassificationUSDAProperty
PavedAbundance	Paved Abundance	http://w3id.org/glosis/model/siteplot/PavedAbundanceProperty
SlopeGradient	Slope Gradient	http://w3id.org/glosis/model/siteplot/slopeGradientProperty
formativeElementUSDA	USDA Formative Element	http://w3id.org/glosis/model/profile/SoilClassificationUSDA
soilClassificationWRB	WRB Soil Name	http://w3id.org/glosis/model/profile/SoilClassificationWRB
soilClassificationWRBProperty	soilClassificationWRBProperty	http://w3id.org/glosis/model/profile/soilClassificationWRBProperty
ErosionAreaAffected	Erosion Area Affected	http://w3id.org/glosis/model/siteplot/erosionAreaAffectedProperty
Cementation/compactionContinuity	Cementation/compaction Continuity	http://w3id.org/glosis/model/layerhorizon/cementationContinuityProperty
ColourDry	Colour Dry	http://w3id.org/glosis/model/common/colourDryProperty
GypsumContent	Gypsum Content	http://w3id.org/glosis/model/layerhorizon/gypsumContentProperty
TemperatureRegime	Temperature Regime	\N
Rocksize	Rock size	http://w3id.org/glosis/model/common/rockSizeProperty
MineralConcentrationsKind	Mineral Concentrations Kind	http://w3id.org/glosis/model/layerhorizon/mineralConcKindProperty
VoidsClassificationProperty	VoidsClassificationProperty	http://w3id.org/glosis/model/layerhorizon/voidsClassificationProperty
ArtefactWeathering	Artefact Weathering	http://w3id.org/glosis/model/common/weatheringFragmentsProperty
ErosionClass	Erosion Class	http://w3id.org/glosis/model/siteplot/erosionCategoryProperty
BoundaryTopography	Boundary Topography	http://w3id.org/glosis/model/layerhorizon/boundaryTopographyProperty
soilClassificationFAOProperty	soilClassificationFAOProperty	http://w3id.org/glosis/model/profile/soilClassificationFAOProperty
PastWeatherConditions	Past Weather Conditions	http://w3id.org/glosis/model/siteplot/weatherConditionsPastProperty
PorosityType	Porosity Type	http://w3id.org/glosis/model/layerhorizon/VoidsClassification
SoilSpecifierWRB	WRB Specifier	http://w3id.org/glosis/model/profile/SoilClassificationWRB
GroundwaterDepth	Groundwater Depth	http://w3id.org/glosis/model/siteplot/groundwaterDepthProperty
CracksDistance	Cracks Distance	http://w3id.org/glosis/model/common/cracksDistanceProperty
cationsSumProperty	cationsSumProperty	http://w3id.org/glosis/model/layerhorizon/cationsSumProperty
ArtefactAbundance	Artefact Abundance	http://w3id.org/glosis/model/common/rockAbundanceProperty
ReducingConditions	Reducing Conditions	\N
FragmentsCover	Fragments Cover	http://w3id.org/glosis/model/common/fragmentCoverProperty
dryConsistencyProperty	dryConsistencyProperty	http://w3id.org/glosis/model/layerhorizon/dryConsistencyProperty
wetPlasticityProperty	wetPlasticityProperty	http://w3id.org/glosis/model/layerhorizon/wetPlasticityProperty
CurrentWeatherConditions	Current Weather Conditions	http://w3id.org/glosis/model/siteplot/weatherConditionsCurrentProperty
RockOutcropsDistance	Rock Outcrops Distance	http://w3id.org/glosis/model/siteplot/rockOutcropsDistanceProperty
moistConsistencyProperty	moistConsistencyProperty	http://w3id.org/glosis/model/layerhorizon/moistConsistencyProperty
Croptype	Crop type	http://w3id.org/glosis/model/siteplot/cropClassProperty
ArtefactColour	Artefact Colour	http://w3id.org/glosis/model/layerhorizon/mineralConcColourProperty
AeromorphicForest	Aeromorphic Forest	\N
slopeOrientationProperty	slopeOrientationProperty	http://w3id.org/glosis/model/siteplot/slopeOrientationProperty
StructureType	Structure Type	\N
MoistureConditions	Moisture Conditions	\N
SaltThickness	Salt Thickness	http://w3id.org/glosis/model/surface/saltThicknessProperty
RootsAbundance	Roots Abundance	http://w3id.org/glosis/model/layerhorizon/rootsAbundanceProperty
FieldPH	Field pH	\N
saltPresenceProperty	saltPresenceProperty	http://w3id.org/glosis/model/surface/saltPresenceProperty
FieldTexture	Field Texture	http://w3id.org/glosis/model/layerhorizon/textureFieldClassProperty
soilDepthRootableProperty	soilDepthRootableProperty	http://w3id.org/glosis/model/common/soilDepthRootableProperty
MottlesSize	Mottles Size	http://w3id.org/glosis/model/layerhorizon/mottlesSizeProperty
AndicCharacteristics	Andic Characteristics	\N
soilGroupWRB	WRB Soil Group	http://w3id.org/glosis/model/profile/SoilClassificationWRB
oxalateExtractableOpticalDensityProperty	oxalateExtractableOpticalDensityProperty	http://w3id.org/glosis/model/layerhorizon/oxalateExtractableOpticalDensityProperty
ConsistenceMoist	Consistence Moist	http://w3id.org/glosis/model/layerhorizon/consistenceMoistProperty
soilOrderUSDA	USDA order	http://w3id.org/glosis/model/profile/SoilClassificationUSDA
BleachedSandCover	Bleached Sand Cover	http://w3id.org/glosis/model/common/bleachedSandProperty
SealingConsistence	Sealing Consistence	http://w3id.org/glosis/model/surface/sealingConsistenceProperty
Position	Position	http://w3id.org/glosis/model/siteplot/physiographyProperty
RootsSize	Roots Size	http://w3id.org/glosis/model/layerhorizon/rootsPresenceProperty
MajorLandForm	Major LandForm	http://w3id.org/glosis/model/siteplot/majorLandFormProperty
solubleAnionsTotalProperty	solubleAnionsTotalProperty	http://w3id.org/glosis/model/layerhorizon/solubleAnionsTotalProperty
SlopeForm	Slope Form	http://w3id.org/glosis/model/siteplot/slopeFormProperty
BoundaryDistinctness	Boundary Distinctness	http://w3id.org/glosis/model/layerhorizon/boundaryDistinctnessProperty
soilDepthProperty	soilDepthProperty	http://w3id.org/glosis/model/common/soilDepthProperty
ColourMoist	Colour Moist	http://w3id.org/glosis/model/common/colourWetProperty
BareSoilAbundance	Bare Soil Abundance	http://w3id.org/glosis/model/siteplot/bareCoverAbundanceProperty
infiltrationRateNumericProperty	infiltrationRateNumericProperty	http://w3id.org/glosis/model/common/infiltrationRateNumericProperty
Vegetation	Vegetation	http://w3id.org/glosis/model/siteplot/vegetationClassProperty
StructureGrade	Structure Grade	http://w3id.org/glosis/model/layerhorizon/structureGradeProperty
MineralConcentrationsAbundance	Mineral Concentrations Abundance	http://w3id.org/glosis/model/layerhorizon/mineralConcAbundanceProperty
mineralConcVolumeProperty	mineralConcVolumeProperty	http://w3id.org/glosis/model/layerhorizon/mineralConcVolumeProperty
CoatingsContrast	Coatings Contrast	http://w3id.org/glosis/model/layerhorizon/coatingContrastProperty
ArtefactSize	Artefact Size	http://w3id.org/glosis/model/common/rockSizeProperty
ParentMaterialClass	Parent Material Class	http://w3id.org/glosis/model/siteplot/lithologyProperty
SaltCover	Salt Cover	http://w3id.org/glosis/model/surface/saltCoverProperty
MineralConcentrationsSize	Mineral Concentrations Size	http://w3id.org/glosis/model/layerhorizon/mineralConcSizeProperty
descriptionStatus	Description Status	http://w3id.org/glosis/model/profile/profileDescriptionStatusProperty
PresenceOfWater	Presence Of Water	\N
cationExchangeCapacityProperty	cationExchangeCapacityProperty	http://w3id.org/glosis/model/layerhorizon/cationExchangeCapacityProperty
Plasticity	Plasticity	http://w3id.org/glosis/model/layerhorizon/plasticityProperty
PorositySize	Porosity Size	http://w3id.org/glosis/model/layerhorizon/PoresSize
Moisture	Moisture	http://w3id.org/glosis/model/layerhorizon/moistureContentProperty
SealingThickness	Sealing Thickness	http://w3id.org/glosis/model/surface/sealingThicknessProperty
TreeDensity	Tree Density	http://w3id.org/glosis/model/siteplot/treeDensityProperty
MottlesAbundance	Mottles Abundance	http://w3id.org/glosis/model/layerhorizon/mottlesAbundanceProperty
ParticleSizeFractionsSumProperty	ParticleSizeFractionsSumProperty	http://w3id.org/glosis/model/layerhorizon/particleSizeFractionsSumProperty
voidsDiameterProperty	voidsDiameterProperty	http://w3id.org/glosis/model/layerhorizon/voidsDiameterProperty
Rockweathering	Rock weathering	http://w3id.org/glosis/model/siteplot/weatheringRockProperty
CarbonateContent	Carbonate Content	http://w3id.org/glosis/model/layerhorizon/carbonatesContentProperty
erosionTotalAreaAffectedProperty	erosionTotalAreaAffectedProperty	http://w3id.org/glosis/model/siteplot/erosionTotalAreaAffectedProperty
SoilDepthtoBedrock	Soil Depth to Bedrock	http://w3id.org/glosis/model/common/SoilDepthBedrock
PorosityAbundance	Porosity Abundance	http://w3id.org/glosis/model/layerhorizon/porosityClassProperty
FragmentsSize	Fragments Size	http://w3id.org/glosis/model/common/fragmentSizeProperty
ShrubAbundace	Shrub Abundace	http://w3id.org/glosis/model/siteplot/ShrubsAbundanceProperty
GroundwaterQuality	Groundwater Quality	\N
soilPhase	Soil Phase	\N
CracksDepth	Cracks Depth	http://w3id.org/glosis/model/common/cracksDepthProperty
parentLithologyProperty	parentLithologyProperty	http://w3id.org/glosis/model/siteplot/parentLithologyProperty
CracksWidth	Cracks Width	http://w3id.org/glosis/model/common/cracksWidthProperty
Rockabundance	Rock abundance	http://w3id.org/glosis/model/common/rockAbundanceProperty
CoatingsLocation	Coatings Location	http://w3id.org/glosis/model/layerhorizon/coatingLocationProperty
ErosionActivityPeriod	Erosion Activity Period	http://w3id.org/glosis/model/siteplot/erosionActivityPeriodProperty
ParentDepositionProperty	ParentDepositionProperty	http://w3id.org/glosis/model/siteplot/parentDepositionProperty
ConsistenceWet	Consistence Wet	http://w3id.org/glosis/model/layerhorizon/consistenceMoistProperty
\.


--
-- TOC entry 4976 (class 0 OID 54922924)
-- Dependencies: 239
-- Data for Name: property_phys_chem; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.property_phys_chem (property_phys_chem_id, uri) FROM stdin;
aluminiumProperty	http://w3id.org/glosis/model/layerhorizon/aluminiumProperty
Calcium (Ca++) - total	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Caltot
Carbon (C) - organic	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Carorg
Carbon (C) - total	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Cartot
Copper (Cu) - extractable	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Copext
Copper (Cu) - total	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Coptot
Hydrogen (H+) - exchangeable	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Hydexc
Iron (Fe) - extractable	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Iroext
Iron (Fe) - total	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Irotot
Magnesium (Mg++) - exchangeable	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Magexc
Magnesium (Mg) - extractable	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Magext
Magnesium (Mg) - total	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Magtot
Manganese (Mn) - extractable	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Manext
Manganese (Mn) - total	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Mantot
Nitrogen (N) - total	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Nittot
Phosphorus (P) - extractable	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Phoext
Phosphorus (P) - retention	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Phoret
Phosphorus (P) - total	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Photot
Potassium (K+) - exchangeable	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Potexc
Potassium (K) - extractable	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Potext
Potassium (K) - total	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Pottot
Sodium (Na) - extractable	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Sodext
Sodium (Na) - total	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Sodtot
Sulfur (S) - extractable	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Sulext
Sulfur (S) - total	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Sultot
Clay texture fraction	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Textclay
Sand texture fraction	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Textsand
Silt texture fraction	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Textsilt
Zinc (Zn) - extractable	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Zinext
pH - Hydrogen potential	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-pH
bulkDensityFineEarthProperty	http://w3id.org/glosis/model/layerhorizon/bulkDensityFineEarthProperty
bulkDensityWholeSoilProperty	http://w3id.org/glosis/model/layerhorizon/bulkDensityWholeSoilProperty
cadmiumProperty	http://w3id.org/glosis/model/layerhorizon/cadmiumProperty
carbonInorganicProperty	http://w3id.org/glosis/model/layerhorizon/carbonInorganicProperty
cationExchangeCapacitycSoilProperty	http://w3id.org/glosis/model/layerhorizon/cationExchangeCapacitycSoilProperty
coarseFragmentsProperty	http://w3id.org/glosis/model/layerhorizon/coarseFragmentsProperty
effectiveCecProperty	http://w3id.org/glosis/model/layerhorizon/effectiveCecProperty
electricalConductivityProperty	http://w3id.org/glosis/model/layerhorizon/electricalConductivityProperty
gypsumProperty	http://w3id.org/glosis/model/layerhorizon/gypsumProperty
hydraulicConductivityProperty	http://w3id.org/glosis/model/layerhorizon/hydraulicConductivityProperty
manganeseProperty	http://w3id.org/glosis/model/layerhorizon/manganeseProperty
molybdenumProperty	http://w3id.org/glosis/model/layerhorizon/molybdenumProperty
organicMatterProperty	http://w3id.org/glosis/model/layerhorizon/organicMatterProperty
pHProperty	http://w3id.org/glosis/model/layerhorizon/pHProperty
porosityProperty	http://w3id.org/glosis/model/layerhorizon/porosityProperty
solubleSaltsProperty	http://w3id.org/glosis/model/layerhorizon/solubleSaltsProperty
totalCarbonateEquivalentProperty	http://w3id.org/glosis/model/layerhorizon/totalCarbonateEquivalentProperty
zincProperty	http://w3id.org/glosis/model/layerhorizon/zincProperty
Acidity - exchangeable	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Aciexc
Boron (B) - total	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Bortot
Aluminium (Al+++) - exchangeable	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Aluexc
Available water capacity - volumetric (FC to WP)	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Avavol
Base saturation - calculated	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Bascal
Boron (B) - extractable	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Borext
Calcium (Ca++) - exchangeable	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Calexc
Calcium (Ca++) - extractable	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Calext
Sodium (Na+) - exchangeable	http://w3id.org/glosis/model/codelists/physioChemicalPropertyCode-Sodexp
\.


--
-- TOC entry 4977 (class 0 OID 54922932)
-- Dependencies: 240
-- Data for Name: result_desc_element; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.result_desc_element (element_id, property_desc_id, category_desc_id) FROM stdin;
\.


--
-- TOC entry 4978 (class 0 OID 54922935)
-- Dependencies: 241
-- Data for Name: result_desc_plot; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.result_desc_plot (plot_id, property_desc_id, category_desc_id) FROM stdin;
\.


--
-- TOC entry 4979 (class 0 OID 54922938)
-- Dependencies: 242
-- Data for Name: result_desc_profile; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.result_desc_profile (profile_id, property_desc_id, category_desc_id) FROM stdin;
\.


--
-- TOC entry 4980 (class 0 OID 54922944)
-- Dependencies: 243
-- Data for Name: result_desc_surface; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.result_desc_surface (surface_id, property_desc_id, category_desc_id) FROM stdin;
\.


--
-- TOC entry 4981 (class 0 OID 54922947)
-- Dependencies: 244
-- Data for Name: result_phys_chem; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.result_phys_chem (result_phys_chem_id, observation_phys_chem_id, specimen_id, individual_id, value) FROM stdin;
\.


--
-- TOC entry 5009 (class 0 OID 54924151)
-- Dependencies: 272
-- Data for Name: result_spectrum; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.result_spectrum (result_spectrum_id, specimen_id, individual_id, spectrum) FROM stdin;
\.


--
-- TOC entry 4982 (class 0 OID 54922963)
-- Dependencies: 245
-- Data for Name: site; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.site (site_id, site_code, typical_profile, "position", extent) FROM stdin;
\.


--
-- TOC entry 4985 (class 0 OID 54922975)
-- Dependencies: 248
-- Data for Name: specimen; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.specimen (specimen_id, element_id, specimen_prep_process_id, organisation_id, code) FROM stdin;
\.


--
-- TOC entry 4986 (class 0 OID 54922981)
-- Dependencies: 249
-- Data for Name: specimen_prep_process; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.specimen_prep_process (specimen_prep_process_id, specimen_transport_id, specimen_storage_id, definition) FROM stdin;
\.


--
-- TOC entry 4989 (class 0 OID 54922991)
-- Dependencies: 252
-- Data for Name: specimen_storage; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.specimen_storage (specimen_storage_id, label, definition) FROM stdin;
\.


--
-- TOC entry 4991 (class 0 OID 54922999)
-- Dependencies: 254
-- Data for Name: specimen_transport; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.specimen_transport (specimen_transport_id, label, definition) FROM stdin;
\.


--
-- TOC entry 4993 (class 0 OID 54923007)
-- Dependencies: 256
-- Data for Name: surface; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.surface (surface_id, super_surface_id, site_id, shape, time_stamp) FROM stdin;
\.


--
-- TOC entry 4994 (class 0 OID 54923013)
-- Dependencies: 257
-- Data for Name: surface_individual; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.surface_individual (surface_id, individual_id) FROM stdin;
\.


--
-- TOC entry 5013 (class 0 OID 54924344)
-- Dependencies: 276
-- Data for Name: translate; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.translate (table_name, column_name, language_code, string, translation) FROM stdin;
category_desc	category_desc_id	es	10Y 3/1 - olive	\N
category_desc	category_desc_id	es	Carbonatic	\N
property_desc	property_pretty_name	es	Crop type	\N
category_desc	category_desc_id	es	6.1 - 6.5: Slightly acidic	\N
category_desc	category_desc_id	es	7.5R 3/8 - dark red	\N
category_desc	category_desc_id	es	Geric Plinthosol	\N
category_desc	category_desc_id	es	CI - Continuous irregular (non-uniform, heterogeneous): Surface of coating is distinctly smoother or different in colour from the adjacent surface. Fine sand grains are enveloped in the coating but their outlines are still visible. Lamellae are 2-5 mm thick.	\N
category_desc	category_desc_id	es	Rustic Podzol	\N
category_desc	category_desc_id	es	Andic Durisol	\N
category_desc	category_desc_id	es	DU = Dune-shaped	\N
category_desc	category_desc_id	es	SC - Soft concretion	\N
property_desc	property_pretty_name	es	solubleAnionsTotalProperty	\N
category_desc	category_desc_id	es	UC1 - Unconsolidated: colluvial slope deposits	\N
property_desc	property_pretty_name	es	Human Influence	\N
category_desc	category_desc_id	es	BWk - Desert climate Dry-cold	\N
category_desc	category_desc_id	es	Udolls	\N
property_desc	property_pretty_name	es	Porosity Abundance	\N
category_desc	category_desc_id	es	UO1 - Unconsolidated: organic rainwater-fed moor peat	\N
category_desc	category_desc_id	es	Cbf - Warm temperate (mesothermal) climates - moist	\N
category_desc	category_desc_id	es	Fragic Alisol	\N
property_desc	property_pretty_name	es	Salt Cover	\N
category_desc	category_desc_id	es	7.5Y 7/2 - light grey	\N
category_desc	category_desc_id	es	coals, bitumen and related rocks	\N
category_desc	category_desc_id	es	Hortic	\N
category_desc	category_desc_id	es	Ot - Other Crops	\N
category_desc	category_desc_id	es	DE - Dendroidal: Mostly irregular, equidimensional voids of faunal origin or resulting from tillage or disturbance of other voids. Discontinuous or interconnected. May be quantified in specific cases.	\N
category_desc	category_desc_id	es	N 4/ - dark grey	\N
category_desc	category_desc_id	es	D5.1 - Hemic, degree of decomposition/humification is moderately strong	\N
category_desc	category_desc_id	es	Takyric	\N
category_desc	category_desc_id	es	10YR 3/2 - very dark greyish brown	\N
category_desc	category_desc_id	es	C - Concave	\N
category_desc	category_desc_id	es	SV3: 5 - 8 %	\N
category_desc	category_desc_id	es	FI - Firm: Soil material crushes under moderate pressure between thumb and forefinger, but resistance is distinctly noticeable.	\N
category_desc	category_desc_id	es	Transportic	\N
category_desc	category_desc_id	es	Eutric Andosol	\N
category_desc	category_desc_id	es	Pretic Luvisol	\N
category_desc	category_desc_id	es	Vitrands	\N
category_desc	category_desc_id	es	Calcic Leptosol	\N
category_desc	category_desc_id	es	VM - Vegetation moderately disturbed	\N
category_desc	category_desc_id	es	MB1 - Basic metamorphic: slate, phyllite (pelitic rocks)	\N
category_desc	category_desc_id	es	5R 6/1 - reddish grey	\N
category_desc	category_desc_id	es	B - Boulders (200 - 600 mm)	\N
category_desc	category_desc_id	es	F - Few	\N
category_desc	category_desc_id	es	W - Well drained - Water is removed from the soil somewhat slowly during some periods of the year. The soils are wet for short periods within rooting depth	\N
category_desc	category_desc_id	es	FN1 - Selective felling	\N
property_phys_chem	property_phys_chem_id	es	Potassium (K+) - exchangeable	\N
category_desc	category_desc_id	es	Cambic Calcisol	\N
category_desc	category_desc_id	es	5 - Very high (> 40%)	\N
category_desc	category_desc_id	es	Leptic Solonchak	\N
category_desc	category_desc_id	es	serpentinite, greenstone	\N
category_desc	category_desc_id	es	WS - Sheet erosion	\N
category_desc	category_desc_id	es	E - Extraction and collection	\N
category_desc	category_desc_id	es	Endocalcic Phaeozem	\N
category_desc	category_desc_id	es	5Y 5/1 - grey	\N
category_desc	category_desc_id	es	FoGr - Grasses	\N
category_desc	category_desc_id	es	Fluvic Phaeozem	\N
category_desc	category_desc_id	es	Calcaric Cambisol	\N
category_desc	category_desc_id	es	7.5GY 6/10	\N
category_desc	category_desc_id	es	Oxyaquic	\N
category_desc	category_desc_id	es	MS - Sand additions	\N
category_desc	category_desc_id	es	5R 6/6 - light red	\N
category_desc	category_desc_id	es	Luvic Nitisol	\N
category_desc	category_desc_id	es	Endodolomitic Umbrisol	\N
category_desc	category_desc_id	es	IU - Irrigation (not specified)	\N
category_desc	category_desc_id	es	10Y 7/2 - light grey	\N
category_desc	category_desc_id	es	Dry - S: 8–12%	\N
category_desc	category_desc_id	es	10YR 7/4 - very pale brown	\N
category_desc	category_desc_id	es	Tidalic Technosol	\N
category_desc	category_desc_id	es	7.5Y 7/4	\N
category_desc	category_desc_id	es	Anthraquic Gleysol	\N
category_desc	category_desc_id	es	TV - High-gradient valley (> 30 %)	\N
category_desc	category_desc_id	es	Leptic Regosol	\N
category_desc	category_desc_id	es	PN2 - Parks	\N
category_desc	category_desc_id	es	N - (nearly)Not salty (< 0.75 dS m-1)	\N
category_desc	category_desc_id	es	K - Carbonates (calcareous)	\N
category_desc	category_desc_id	es	Sideralic	\N
category_desc	category_desc_id	es	2.5Y 7/6 - yellow	\N
property_phys_chem	property_phys_chem_id	es	cadmiumProperty	\N
property_desc	property_pretty_name	es	Erosion Area Affected	\N
category_desc	category_desc_id	es	Gleyic Kastanozem	\N
category_desc	category_desc_id	es	UU1 - Unconsolidated: unspecified deposits clay	\N
category_desc	category_desc_id	es	Takyric Calcisol	\N
category_desc	category_desc_id	es	Albic Acrisol	\N
category_desc	category_desc_id	es	Luvic Kastanozem	\N
category_desc	category_desc_id	es	FR - Fragipan	\N
category_desc	category_desc_id	es	7.5R 5/4 - weak red	\N
category_desc	category_desc_id	es	PVP - plastic to very plastic -	\N
category_desc	category_desc_id	es	AA - Annual field cropping	\N
property_desc	property_pretty_name	es	Salt Content	\N
category_desc	category_desc_id	es	Rockic Histosol	\N
property_desc	property_pretty_name	es	Slope Gradient	\N
category_desc	category_desc_id	es	Orth	\N
category_desc	category_desc_id	es	5YR 6/2 - pinkish grey	\N
category_desc	category_desc_id	es	P - Prominent: Surface of coatings contrasts strongly in smoothness or colour with the adjacent surfaces. Outlines of fine sand grains are not visible. Lamellae are more than 5 mm thick.	\N
property_phys_chem	property_phys_chem_id	es	Sodium (Na) - total	\N
category_desc	category_desc_id	es	IA4 - Acid igneous: rhyiolite	\N
category_desc	category_desc_id	es	HE2 - Semi-nomadism	\N
category_desc	category_desc_id	es	Irragric Vertisol	\N
category_desc	category_desc_id	es	F - Forestry	\N
category_desc	category_desc_id	es	RY - Reddish yellow	\N
category_desc	category_desc_id	es	FrBa - Bananas	\N
category_desc	category_desc_id	es	D3 - Fibric, degree of decomposition/humification is moderate	\N
category_desc	category_desc_id	es	09 - Steep (30 - 60 %)	\N
category_desc	category_desc_id	es	BD4,5 - Sample remains intact when dropped, no further disintegration after application of very large pressure - coherent (prismatic, columnar, wedgeshaped) - >1.6	\N
category_desc	category_desc_id	es	IU1 - Ultrabasic igneous: peridotite	\N
category_desc	category_desc_id	es	F - Fine gravel (0.2 - 0.6 cm)	\N
category_desc	category_desc_id	es	Pisoplinthic Plinthosol	\N
category_desc	category_desc_id	es	3 - High (40 - 80 %)	\N
category_desc	category_desc_id	es	10Y 6/4	\N
property_phys_chem	property_phys_chem_id	es	Potassium (K) - extractable	\N
category_desc	category_desc_id	es	Profundihumic Ferralsol	\N
category_desc	category_desc_id	es	Hortic Kastanozem	\N
category_desc	category_desc_id	es	Few	\N
category_desc	category_desc_id	es	10YR 8/3 - very pale brown	\N
category_desc	category_desc_id	es	7.5YR 5/0 - grey	\N
category_desc	category_desc_id	es	Lithic Leptosol	\N
category_desc	category_desc_id	es	OiSe - Sesame	\N
category_desc	category_desc_id	es	Vertisol (VR)	\N
category_desc	category_desc_id	es	WD - Deposition by water	\N
property_desc	property_pretty_name	es	External Drainage Class	\N
property_desc	property_pretty_name	es	saltPresenceProperty	\N
category_desc	category_desc_id	es	Very coarse	\N
category_desc	category_desc_id	es	B - Groundwater-fed bog peat	\N
category_desc	category_desc_id	es	Immissic	\N
category_desc	category_desc_id	es	CeBa - Barley	\N
category_desc	category_desc_id	es	N 5/ - grey	\N
category_desc	category_desc_id	es	HE - Extensive grazing	\N
property_desc	property_pretty_name	es	Flood Frequency	\N
category_desc	category_desc_id	es	Capillaric	\N
category_desc	category_desc_id	es	GF - Submerged by rising local groundwater at least once a year	\N
category_desc	category_desc_id	es	Gypsiric Cambisol	\N
category_desc	category_desc_id	es	5R 4/2 - weak red	\N
category_desc	category_desc_id	es	Ferric Acrisol	\N
category_desc	category_desc_id	es	W - Wide (2 - 5 cm)	\N
category_desc	category_desc_id	es	Haplic Acrisol	\N
category_desc	category_desc_id	es	Pretic Planosol	\N
category_desc	category_desc_id	es	Hydragric Alisol	\N
category_desc	category_desc_id	es	Lamellic Luvisol	\N
category_desc	category_desc_id	es	Dur	\N
category_desc	category_desc_id	es	Skeletic Phaeozem	\N
category_desc	category_desc_id	es	Petrocalcic Chernozem	\N
category_desc	category_desc_id	es	VST - Very strongly salty (8 - 15 dS m-1)	\N
category_desc	category_desc_id	es	C - Common - The number of very fine pores (< 2 mm) per square decimetre is 50-200, the number of medium and coarse pores (> 2 mm) per square decimetre is 5-20.	\N
category_desc	category_desc_id	es	10Y 5/4	\N
category_desc	category_desc_id	es	Loamic	\N
category_desc	category_desc_id	es	Kalaic	\N
category_desc	category_desc_id	es	B - Vesicular: Discontinuous spherical or elliptical voids (chambers) of sedimentary origin or formed by compressed air, e.g. gas bubbles in slaking crusts after heavy rainfall. Relatively unimportant in connection with plant growth.	\N
category_desc	category_desc_id	es	S - Slightly hard	\N
category_desc	category_desc_id	es	Regosol (RG)	\N
category_desc	category_desc_id	es	Alic Umbrisol	\N
category_desc	category_desc_id	es	S - Somewhat excessively well drained - Water is removed from the soil rapidly	\N
property_desc	property_pretty_name	es	solubleCationsTotalProperty	\N
category_desc	category_desc_id	es	Petroduric Planosol	\N
category_desc	category_desc_id	es	5GY 6/1 - greenish grey	\N
category_desc	category_desc_id	es	Not known	\N
category_desc	category_desc_id	es	SG - Single grain	\N
category_desc	category_desc_id	es	CR - Crest (summit)	\N
category_desc	category_desc_id	es	5R 2.5/6 - dark red	\N
category_desc	category_desc_id	es	P - Planes: Most planes are extra-pedal voids, related to accommodating ped surfaces or cracking patterns. They are often not persistent and vary in size, shape and quantity depending on the moisture condition of the soil. Planar voids may be recorded, describing width and frequency.	\N
category_desc	category_desc_id	es	> 50 %	\N
category_desc	category_desc_id	es	Gypsic Leptosol	\N
category_desc	category_desc_id	es	BU - Blue	\N
category_desc	category_desc_id	es	LuTo - Tobacco	\N
category_desc	category_desc_id	es	M - Mass movement	\N
category_desc	category_desc_id	es	Gleyic Arenosol	\N
category_desc	category_desc_id	es	W - Widely spaced (2 - 5 m)	\N
category_desc	category_desc_id	es	5YR 7/3 - pink	\N
category_desc	category_desc_id	es	Luvic Umbrisol	\N
category_desc	category_desc_id	es	IU3 - Ultrabasic igneous: ilmenite, magnetite, ironstone, serpentine	\N
category_desc	category_desc_id	es	S - Stones (60 - 200 mm)	\N
property_phys_chem	property_phys_chem_id	es	effectiveCecProperty	\N
category_desc	category_desc_id	es	Leptic Umbrisol	\N
category_desc	category_desc_id	es	C - Coarse gravel (2 - 6 cm)	\N
category_desc	category_desc_id	es	Tsitelic Arenosol	\N
category_desc	category_desc_id	es	Dry - LS, SL, L: 6–9%	\N
category_desc	category_desc_id	es	V - Convex	\N
category_desc	category_desc_id	es	loam and silt	\N
category_desc	category_desc_id	es	5YR 2.5/2 - dark reddish brown	\N
category_desc	category_desc_id	es	3 - Moderately deep (50-100 cm)	\N
category_desc	category_desc_id	es	Ferric Lixisol	\N
category_desc	category_desc_id	es	Moist - S: 1.5–3%	\N
category_desc	category_desc_id	es	Yermic Calcisol	\N
category_desc	category_desc_id	es	SHA - Slightly hard: Weakly resistant to pressure; easily broken between thumb and forefinger.	\N
category_desc	category_desc_id	es	5R 2.5/2 - very dusky red	\N
category_desc	category_desc_id	es	SB - Subangular blocky	\N
category_desc	category_desc_id	es	US - Ustic	\N
category_desc	category_desc_id	es	RE - Red	\N
category_desc	category_desc_id	es	MB4 - Basic metamorphic: metamorphic limestone (marble)	\N
category_desc	category_desc_id	es	Cc - Warm temperate (mesothermal) climates	\N
category_desc	category_desc_id	es	5R 5/3 - weak red	\N
category_desc	category_desc_id	es	1 - Very shallow (0-25 cm)	\N
category_desc	category_desc_id	es	W - Weakly cemented: Cemented mass is brittle and hard, but can be broken in the hands.	\N
category_desc	category_desc_id	es	Gleyic Luvisol	\N
category_desc	category_desc_id	es	Plaggic Gleysol	\N
category_desc	category_desc_id	es	Hortic Umbrisol	\N
category_desc	category_desc_id	es	CL - Cloddy	\N
category_desc	category_desc_id	es	KQ - Carbonates-silica	\N
category_desc	category_desc_id	es	Brunic Regosol	\N
category_desc	category_desc_id	es	Fo - Fodder Plants	\N
category_desc	category_desc_id	es	metamorphic rock	\N
category_desc	category_desc_id	es	Retic Planosol	\N
category_desc	category_desc_id	es	Aquods	\N
category_desc	category_desc_id	es	Drainic Histosol	\N
category_desc	category_desc_id	es	sedimentary rock (consolidated)	\N
category_desc	category_desc_id	es	W - Woodland	\N
category_desc	category_desc_id	es	MO - Moderately gypsiric (5-15%) - EC = > 1.8 dS m-1 in 10 g soil/250 ml H2O	\N
category_desc	category_desc_id	es	0.07 - 0.11 g cm-3	\N
category_desc	category_desc_id	es	IF - Furrow irrigation	\N
category_desc	category_desc_id	es	Skeletic Lixisol	\N
category_desc	category_desc_id	es	Bathyspodic	\N
category_desc	category_desc_id	es	Mulmic Phaeozem	\N
category_desc	category_desc_id	es	5.1 - 5.5: Strongly acidic	\N
category_desc	category_desc_id	es	Stagnic Gleysol	\N
category_desc	category_desc_id	es	MO - Occasional storm surges (above mean high water springs)	\N
category_desc	category_desc_id	es	Siltic	\N
category_desc	category_desc_id	es	2.5YR 3/0 - very dark grey	\N
category_desc	category_desc_id	es	Skeletic Calcisol	\N
category_desc	category_desc_id	es	FO - Submerged by remote flowing inland water less than once a year	\N
category_desc	category_desc_id	es	Wind deposition	\N
category_desc	category_desc_id	es	H - Animal husbandry	\N
category_desc	category_desc_id	es	Escalic	\N
category_desc	category_desc_id	es	Dbw - Cool-humid continental  with cool high-sun season - dry winter	\N
category_desc	category_desc_id	es	Isolatic Technosol	\N
category_desc	category_desc_id	es	7.5GY 4/2	\N
category_desc	category_desc_id	es	Petroduric Phaeozem	\N
category_desc	category_desc_id	es	Aquolls	\N
category_desc	category_desc_id	es	MI - Mine (surface, including openpit, gravel and quarries)	\N
category_desc	category_desc_id	es	Salic Vertisol	\N
category_desc	category_desc_id	es	Albic Lixisol	\N
category_desc	category_desc_id	es	medium and coarse	\N
category_desc	category_desc_id	es	M - Many (15 - 40 %)	\N
category_desc	category_desc_id	es	Calcic Kastanozem	\N
category_desc	category_desc_id	es	Protic Regosol	\N
property_desc	property_pretty_name	es	Mineral Concentrations Size	\N
category_desc	category_desc_id	es	Very few	\N
category_desc	category_desc_id	es	Dolomitic Fluvisol	\N
category_desc	category_desc_id	es	5R 6/2 - pale red	\N
category_desc	category_desc_id	es	Dsc - Snow climates - dry summer,  cool short summer	\N
property_phys_chem	property_phys_chem_id	es	Iron (Fe) - total	\N
category_desc	category_desc_id	es	5YR 4/6 - yellowish red	\N
category_desc	category_desc_id	es	AA4 - Rainfed arable cultivation	\N
category_desc	category_desc_id	es	M - Mechanical	\N
category_desc	category_desc_id	es	Anionic	\N
category_desc	category_desc_id	es	IP3 - Igneous: pyroclastic volcanic ash	\N
category_desc	category_desc_id	es	Al, Alic	\N
category_desc	category_desc_id	es	5YR 5/1 - grey	\N
property_desc	property_pretty_name	es	infiltrationRateClassProperty	\N
category_desc	category_desc_id	es	Leptic Fluvisol	\N
category_desc	category_desc_id	es	7.5R 2.5/4 - very dusky red	\N
category_desc	category_desc_id	es	AM - Wind erosion and deposition	\N
category_desc	category_desc_id	es	Lixic Ferralsol	\N
category_desc	category_desc_id	es	Rhodic Ferralsol	\N
property_desc	property_pretty_name	es	Artefact Size	\N
category_desc	category_desc_id	es	IP - Pore infillings: Including pseudomycelium of carbonates or opal	\N
category_desc	category_desc_id	es	10 - 25 %	\N
category_desc	category_desc_id	es	Thapto(ic)	\N
category_desc	category_desc_id	es	Spodic Gleysol	\N
category_desc	category_desc_id	es	N - None - The number of very fine pores (< 2 mm) per square decimetre is 0, the number of medium and coarse pores (> 2 mm) per square decimetre is 0.	\N
category_desc	category_desc_id	es	LU - Lumpy	\N
category_desc	category_desc_id	es	Tidalic Gleysol	\N
category_desc	category_desc_id	es	7.5YR 6/8 - reddish yellow	\N
category_desc	category_desc_id	es	Ortsteinic Podzol	\N
property_desc	property_pretty_name	es	Sealing Thickness	\N
category_desc	category_desc_id	es	5R 2.5/1 - reddish black	\N
category_desc	category_desc_id	es	SB - Stones and boulders	\N
category_desc	category_desc_id	es	gabbro	\N
category_desc	category_desc_id	es	CH - Clay and humus (organic matter)	\N
category_desc	category_desc_id	es	Stagnic Cambisol	\N
category_desc	category_desc_id	es	Fragic Acrisol	\N
category_desc	category_desc_id	es	Pretic Umbrisol	\N
category_desc	category_desc_id	es	Pretic Acrisol	\N
category_desc	category_desc_id	es	clay and silt	\N
category_desc	category_desc_id	es	S - Sharp (< 0.5 mm)	\N
category_desc	category_desc_id	es	Lixisol (LX)	\N
category_desc	category_desc_id	es	Cambic Cryosol	\N
category_desc	category_desc_id	es	2.1 - Routine profile description - without sampling: No essential elements are missing from the description, sampling or analysis. The number of samples collected is sufficient to characterize all major soil horizons, but may not allow precise definition of all subhorizons, especially in the deeper soil. The profile depth is 80 cm or more, or down to a C or R horizon or layer, which may be shallower. Additional augering and sampling may be required for lower level classification. Soil description is done without sampling.	\N
category_desc	category_desc_id	es	Vitric Gleysol	\N
category_desc	category_desc_id	es	Retic Umbrisol	\N
category_desc	category_desc_id	es	VF - Very fine (< 0.5 mm)	\N
category_desc	category_desc_id	es	DD - Deciduous dwarf shrub	\N
category_desc	category_desc_id	es	Carbonic	\N
property_desc	property_pretty_name	es	Reducing Conditions	\N
category_desc	category_desc_id	es	PuPe - Peas	\N
category_desc	category_desc_id	es	Nudinatric Solonetz	\N
category_desc	category_desc_id	es	Petrocalcic Durisol	\N
category_desc	category_desc_id	es	AD - Artificial drainage	\N
property_desc	property_pretty_name	es	Artefact Abundance	\N
category_desc	category_desc_id	es	P - Ploughing	\N
category_desc	category_desc_id	es	Subaquatic Histosol	\N
category_desc	category_desc_id	es	< 0.04 g cm-3	\N
category_desc	category_desc_id	es	Fluvisol (FL)	\N
category_desc	category_desc_id	es	F - Fine (0.5-2 mm) - More decomposed than raw humus but characterized by an organic matter layer on top of the mineral soil with a diffuse boundary between the organic matter layer and A horizon. In the sequence of Oi-Oe-Oa layers, it is difficult to separate one layer from another. This develops in moderately nutrient-poor conditions, usually under a cool moist climate. It is usually acidic with a C/N ratio of 18-29.	\N
category_desc	category_desc_id	es	LinicUrbic Technosol	\N
property_desc	property_pretty_name	es	infiltrationRateNumericProperty	\N
category_desc	category_desc_id	es	0–5	\N
category_desc	category_desc_id	es	M - Moderately well drained - Water is removed from the soil somewhat slowly during some periods of the year. The soils are wet for short periods within rooting depth	\N
category_desc	category_desc_id	es	ET - Tundra climate	\N
category_desc	category_desc_id	es	Dry - S: > 12%	\N
category_desc	category_desc_id	es	Placic	\N
category_desc	category_desc_id	es	Petroduric Chernozem	\N
category_desc	category_desc_id	es	M - Moderately rapid run-off	\N
category_desc	category_desc_id	es	UO2 - Unconsolidated: organic groundwater-fed bog peat	\N
category_desc	category_desc_id	es	WC6 - Extremely rainy time or snow melting	\N
category_desc	category_desc_id	es	Moderately drained	\N
category_desc	category_desc_id	es	C - Coarse (> 5 mm)	\N
category_desc	category_desc_id	es	Ruptic	\N
property_desc	property_pretty_name	es	Colour Moist	\N
category_desc	category_desc_id	es	NO - None of the above	\N
property_desc	property_pretty_name	es	Slope Form	\N
category_desc	category_desc_id	es	WX - Xeromorphic woodland	\N
category_desc	category_desc_id	es	Folic Leptosol	\N
category_desc	category_desc_id	es	P - Pisolithic: The layer is largely constructed from cemented spherical nodules.	\N
category_desc	category_desc_id	es	Takyric Cambisol	\N
category_desc	category_desc_id	es	Gelic	\N
category_desc	category_desc_id	es	MB3 - Basic metamorphic: gneiss rich in Fe-Mg minerals	\N
category_desc	category_desc_id	es	Mass movement	\N
category_desc	category_desc_id	es	Dystric Planosol	\N
category_desc	category_desc_id	es	7.5Y 6/4	\N
category_desc	category_desc_id	es	FS - Fine sand	\N
category_desc	category_desc_id	es	Ddw - Subarctic with very cold low-sun season - dry winter	\N
category_desc	category_desc_id	es	Aric	\N
category_desc	category_desc_id	es	D - Discontinuous: The layer is 50-90 percent cemented or compacted, and in general shows a regular appearance.	\N
category_desc	category_desc_id	es	Transportic Arenosol	\N
category_desc	category_desc_id	es	Petrogypsic	\N
property_desc	property_pretty_name	es	mineralConcVolumeProperty	\N
category_desc	category_desc_id	es	Transportic Regosol	\N
category_desc	category_desc_id	es	A - Abrupt (0-2 cm)	\N
category_desc	category_desc_id	es	2.5YR 4/6 - red	\N
category_desc	category_desc_id	es	Cambic Phaeozem	\N
category_desc	category_desc_id	es	Hortic Anthrosol	\N
category_desc	category_desc_id	es	Dfb - Snow climates - moist all seasons, warm summer	\N
category_desc	category_desc_id	es	Gelands	\N
category_desc	category_desc_id	es	Cfb - Warm temperate - moist all seasons, warm summer	\N
category_desc	category_desc_id	es	Moist - S: > 6%	\N
category_desc	category_desc_id	es	10YR 5/4 - yellowish brown	\N
category_desc	category_desc_id	es	Petrogypsic Durisol	\N
category_desc	category_desc_id	es	anthropogenic/technogenic	\N
category_desc	category_desc_id	es	5R 4/4 - weak red	\N
category_desc	category_desc_id	es	10R 3/6 - dark red	\N
category_desc	category_desc_id	es	Plaggic Cambisol	\N
category_desc	category_desc_id	es	HC - Hypodermic coatings: Hypodermic coatings, as used here, are field-scale features, commonly only expressed as hydromorphic features. Micromorphological hypodermic coatings include non-redox features [Bullock et al., 1985].	\N
category_desc	category_desc_id	es	US - Unsorted sand	\N
category_desc	category_desc_id	es	10R 6/4 - pale red	\N
category_desc	category_desc_id	es	Leptic	\N
category_desc	category_desc_id	es	Gilgaic	\N
category_desc	category_desc_id	es	7.5YR 3/4 - dark brown	\N
category_desc	category_desc_id	es	anhydrite, gypsum	\N
category_desc	category_desc_id	es	N 3/ - very dark grey	\N
category_desc	category_desc_id	es	Gypsic Kastanozem	\N
category_desc	category_desc_id	es	Albic Solonetz	\N
category_desc	category_desc_id	es	MP - Permanently submerged by seawater (below mean low water springs)	\N
category_desc	category_desc_id	es	periglacial rock debris	\N
category_desc	category_desc_id	es	Skeletic Acrisol	\N
category_desc	category_desc_id	es	V - Very wide (5 - 10 cm)	\N
category_desc	category_desc_id	es	Endodolomitic Retisol	\N
category_desc	category_desc_id	es	20-50 m	\N
category_desc	category_desc_id	es	Dfc - Snow climates - moist all seasons, cool short summer	\N
category_desc	category_desc_id	es	YR - Yermic	\N
category_desc	category_desc_id	es	2.5YR 3/2 - dusky red	\N
category_desc	category_desc_id	es	ST - Strong: Aggregates are clearly observable in place and there is a prominent arrangement of natural surfaces of weakness. When disturbed, the soil material separates mainly into entire aggregates. Aggregates surfaces generally differ markedly from aggregate interiors.	\N
category_desc	category_desc_id	es	basic metamorphic	\N
category_desc	category_desc_id	es	N - None - No odour detected	\N
category_desc	category_desc_id	es	glacial	\N
category_desc	category_desc_id	es	F - Medium artefacts (6 - 20 mm)	\N
category_desc	category_desc_id	es	D - Nodular: The layer is largely constructed from cemented nodules or concretions of irregular shape.	\N
category_desc	category_desc_id	es	N - No evidence of erosion	\N
category_desc	category_desc_id	es	RS - Rock structure	\N
category_desc	category_desc_id	es	SE2 - Evaporites: halite	\N
category_desc	category_desc_id	es	Water and wind erosion	\N
category_desc	category_desc_id	es	Brunic Umbrisol	\N
category_desc	category_desc_id	es	Terric Cambisol	\N
category_desc	category_desc_id	es	Ust	\N
category_desc	category_desc_id	es	Hyperalic	\N
category_desc	category_desc_id	es	Lapiadic	\N
category_desc	category_desc_id	es	5YR 8/3 - pink	\N
category_desc	category_desc_id	es	7.5GY 8/0	\N
category_desc	category_desc_id	es	Pantofluvic Fluvisol	\N
category_desc	category_desc_id	es	P - Petrochemical - Presence of gaseous or liquid gasoline, oil, creosote, etc.	\N
category_desc	category_desc_id	es	Nudiargic Acrisol	\N
category_desc	category_desc_id	es	FR - Friable: Soil material crushes easily under gentle to moderate pressure between thumb and forefinger, and coheres when pressed together.	\N
property_desc	property_pretty_name	es	Structure Size	\N
property_desc	property_pretty_name	es	cationExchangeCapacityProperty	\N
category_desc	category_desc_id	es	V - Very wet: Crushing: free water. Forming (to a ball): drops of water without crushing. Moistening: no change of colour. pF: 0.	\N
category_desc	category_desc_id	es	NNE - north-north-east	\N
category_desc	category_desc_id	es	5Y 3/1 - very dark grey	\N
category_desc	category_desc_id	es	H - Humus	\N
category_desc	category_desc_id	es	OtRu - Rubber	\N
category_desc	category_desc_id	es	M - Many - Roots with diameters < 2 mm: > 200, Roots with diameters > 2 mm: > 20.	\N
category_desc	category_desc_id	es	Eutric Nitisol	\N
category_desc	category_desc_id	es	Turbels	\N
category_desc	category_desc_id	es	D - Dwarf Shrub	\N
category_desc	category_desc_id	es	Wapnic	\N
category_desc	category_desc_id	es	Xer	\N
category_desc	category_desc_id	es	B - Dry	\N
category_desc	category_desc_id	es	Common	\N
category_desc	category_desc_id	es	Udands	\N
category_desc	category_desc_id	es	5Y 2.5/1 - black	\N
category_desc	category_desc_id	es	PU - Perudic	\N
category_desc	category_desc_id	es	4.5 - 5.0: Very strongly acidic	\N
category_desc	category_desc_id	es	IN - Inundic	\N
category_desc	category_desc_id	es	N - None - Roots with diameters < 2 mm: 0, Roots with diameters > 2 mm: 0.	\N
category_desc	category_desc_id	es	A - Abundant (40-80 %)	\N
category_desc	category_desc_id	es	SO - Soft: Soil mass is very weakly coherent and fragile; breaks to powder or individual grains under very slight pressure.	\N
property_desc	property_pretty_name	es	Soil Texture	\N
category_desc	category_desc_id	es	ST - Strongly salty (4 - 8 dS m-1)	\N
category_desc	category_desc_id	es	Plaggic Planosol	\N
category_desc	category_desc_id	es	Fluvic Solonchak	\N
category_desc	category_desc_id	es	A - Abundant (40 - 80 %)	\N
category_desc	category_desc_id	es	Petroplinthic	\N
category_desc	category_desc_id	es	8.5 - 9.0: Moderately alkaline	\N
category_desc	category_desc_id	es	Stagnic Anthrosol	\N
category_desc	category_desc_id	es	10YR 4/2 - dark greyish brown	\N
category_desc	category_desc_id	es	10R 4/1 - dark reddish grey	\N
property_desc	property_pretty_name	es	Mineral Concentrations Abundance	\N
category_desc	category_desc_id	es	GE - Greenish	\N
category_desc	category_desc_id	es	10R 3/4 - dusky red	\N
property_desc	property_pretty_name	es	Porosity Size	\N
category_desc	category_desc_id	es	2 - Moderate (15 - 40 %)	\N
category_desc	category_desc_id	es	Orthofluvic Fluvisol	\N
category_desc	category_desc_id	es	Df - Cold snow-forest climate - humid winters	\N
category_desc	category_desc_id	es	N 6/ - (light) grey	\N
category_desc	category_desc_id	es	Tonguic Phaeozem	\N
category_desc	category_desc_id	es	V - Very fine artefacts (< 2 mm)	\N
category_desc	category_desc_id	es	FM - Fine and medium (0.5-5 mm)	\N
category_desc	category_desc_id	es	7.5YR 7/0 - light grey	\N
category_desc	category_desc_id	es	Yermic Lixisol	\N
category_desc	category_desc_id	es	Si - Silt	\N
category_desc	category_desc_id	es	10YR 4/4 - dark yellowish brown	\N
category_desc	category_desc_id	es	BO - Open large burrows	\N
category_desc	category_desc_id	es	PS - Subangular prismatic	\N
property_desc	property_pretty_name	es	ParticleSizeFractionsSumProperty	\N
property_desc	property_pretty_name	es	Erosion Degree	\N
category_desc	category_desc_id	es	10Y 8/2 - light grey	\N
category_desc	category_desc_id	es	3.1 - Incomplete description - without sampling: Certain relevant elements are missing from the description, an insufficient number of samples was collected, or the reliability of the analytical data does not permit a complete characterization of the soil. However, the description is useful for specific purposes and provides a satisfactory indication of the nature of the soil at high levels of soil taxonomic classification. Soil description is done without sampling.	\N
category_desc	category_desc_id	es	10Y 6/8	\N
category_desc	category_desc_id	es	FiJu - Jute	\N
category_desc	category_desc_id	es	Skeletic Kastanozem	\N
category_desc	category_desc_id	es	Humic	\N
category_desc	category_desc_id	es	Floatic Histosol	\N
category_desc	category_desc_id	es	Dry - S: 2–3%	\N
category_desc	category_desc_id	es	BI - Infilled large burrows	\N
category_desc	category_desc_id	es	Oxygleyic Gleysol	\N
category_desc	category_desc_id	es	5YR 8/1 - white	\N
category_desc	category_desc_id	es	Alic	\N
category_desc	category_desc_id	es	HA - Hard: Moderately resistant to pressure; can be broken in the hands; not breakable between thumb and forefinger.	\N
category_desc	category_desc_id	es	Leptic Technosol	\N
category_desc	category_desc_id	es	UG2 glacio-fluvial sand	\N
category_desc	category_desc_id	es	7.5YR 8/2 - pinkish white	\N
category_desc	category_desc_id	es	Tephric Regosol	\N
category_desc	category_desc_id	es	VHA - Very hard: Very resistant to pressure; can be broken in the hands only with difficulty.	\N
category_desc	category_desc_id	es	F - Fine gravel (2 - 6 mm)	\N
category_desc	category_desc_id	es	NW - north-west	\N
category_desc	category_desc_id	es	Usterts	\N
category_desc	category_desc_id	es	C - Channels: Elongated voids of faunal or floral origin, mostly tubular in shape and continuous, varying strongly in diameter. When wider than a few centimetres (burrow holes), they are more adequately described under biological activity.	\N
category_desc	category_desc_id	es	Pretic Podzol	\N
category_desc	category_desc_id	es	igneous rock	\N
category_desc	category_desc_id	es	OiCc - Coconuts	\N
category_desc	category_desc_id	es	MC - Medium and coarse gravel/artefacts	\N
category_desc	category_desc_id	es	Dystric Andosol	\N
category_desc	category_desc_id	es	FiCo - Cotton	\N
category_desc	category_desc_id	es	Endoleptic	\N
property_desc	property_pretty_name	es	Cracks Distance	\N
category_desc	category_desc_id	es	fine and very fine	\N
category_desc	category_desc_id	es	5R 6/3 - pale red	\N
category_desc	category_desc_id	es	Hal, Halic	\N
category_desc	category_desc_id	es	Fragic	\N
category_desc	category_desc_id	es	Arenosol (AR)	\N
property_desc	property_pretty_name	es	Redox Potential	\N
category_desc	category_desc_id	es	Umbric Leptosol	\N
category_desc	category_desc_id	es	Fluvic Umbrisol	\N
category_desc	category_desc_id	es	F - Once every 2-4 years	\N
category_desc	category_desc_id	es	10YR 5/2 - greyish brown	\N
category_desc	category_desc_id	es	YB - Yellowish brown	\N
category_desc	category_desc_id	es	7.5Y 7/8	\N
category_desc	category_desc_id	es	Reductic Stagnosol	\N
category_desc	category_desc_id	es	Dcf - Subarctic climate - moist	\N
category_desc	category_desc_id	es	Calcaric Phaeozem	\N
category_desc	category_desc_id	es	IP2 - Igneous  pyroclastic volcanic scoria/breccia	\N
property_phys_chem	property_phys_chem_id	es	Boron (B) - total	\N
category_desc	category_desc_id	es	CO - Coarse / thick: Granular/platy: 5-10 mm,  Prismatic/columnar/wedgeshaped: 50-100 mm, Blocky/crumbly/lumpy/cloddy: 20-50 mm	\N
category_desc	category_desc_id	es	Pellic Vertisol	\N
category_desc	category_desc_id	es	FoPu - Pumpkins	\N
category_desc	category_desc_id	es	Gleyic Gypsisol	\N
category_desc	category_desc_id	es	Eutric Planosol	\N
category_desc	category_desc_id	es	A - Angular	\N
category_desc	category_desc_id	es	Andic Histosol	\N
category_desc	category_desc_id	es	Inclinic	\N
category_desc	category_desc_id	es	Cambids	\N
category_desc	category_desc_id	es	VF - Very fine / thin: Granular/platy: < 1 mm,  Prismatic/columnar/wedgeshaped: < 10 mm, Blocky/crumbly/lumpy/cloddy: < 5 mm	\N
category_desc	category_desc_id	es	Leptic Durisol	\N
category_desc	category_desc_id	es	M - Medium (2 - 10 cm)	\N
category_desc	category_desc_id	es	MP - Plaggen	\N
property_desc	property_pretty_name	es	soilDepthRootableClassProperty	\N
category_desc	category_desc_id	es	Subaquatic Cryosol	\N
category_desc	category_desc_id	es	Deposition by water	\N
property_phys_chem	property_phys_chem_id	es	Magnesium (Mg) - total	\N
category_desc	category_desc_id	es	5G 7/1 - light greenish grey	\N
category_desc	category_desc_id	es	Leptic Cambisol	\N
category_desc	category_desc_id	es	Albic Planosol	\N
category_desc	category_desc_id	es	Haplic Phaeozem	\N
category_desc	category_desc_id	es	Ferric Alisol	\N
category_desc	category_desc_id	es	Fluvents	\N
category_desc	category_desc_id	es	Gleyic Alisol	\N
category_desc	category_desc_id	es	Moist - LS, SL, L: < 0.4%	\N
category_desc	category_desc_id	es	gneiss rich in Fe–Mg minerals	\N
category_desc	category_desc_id	es	2.5Y 4/0 - dark grey	\N
category_desc	category_desc_id	es	UC2 - Unconsolidated: colluvial lahar	\N
category_desc	category_desc_id	es	Tonguic Chernozem	\N
category_desc	category_desc_id	es	White, after oxidation brown: siderite	\N
category_desc	category_desc_id	es	Sideralic Cambisol	\N
category_desc	category_desc_id	es	3 - Medium (5-15%)	\N
category_desc	category_desc_id	es	Chromic Luvisol	\N
category_desc	category_desc_id	es	Bathy	\N
category_desc	category_desc_id	es	Somb, Sombric	\N
category_desc	category_desc_id	es	Hortic Gleysol	\N
category_desc	category_desc_id	es	Dry - S: 5–8%	\N
property_desc	property_pretty_name	es	Plasticity	\N
category_desc	category_desc_id	es	Oxyaquic Cryosol	\N
category_desc	category_desc_id	es	RoYa - Yams	\N
category_desc	category_desc_id	es	Calci, Calc	\N
category_desc	category_desc_id	es	Hydragric Cambisol	\N
category_desc	category_desc_id	es	Umbric Cryosol	\N
category_desc	category_desc_id	es	1 - Very low (< 2%)	\N
category_desc	category_desc_id	es	As - Tropical savanna	\N
category_desc	category_desc_id	es	LD - Depression (< 10 %)	\N
category_desc	category_desc_id	es	Tephric	\N
category_desc	category_desc_id	es	WC - Worm casts	\N
category_desc	category_desc_id	es	moraine	\N
property_desc	property_pretty_name	es	Cementation/compaction Structure	\N
category_desc	category_desc_id	es	S - Sand (unspecified)	\N
category_desc	category_desc_id	es	T - Steep land (> 30 %)	\N
category_desc	category_desc_id	es	Moist - S: < 0.3%	\N
property_desc	property_pretty_name	es	Complex Landform	\N
category_desc	category_desc_id	es	Terric Anthrosol	\N
property_desc	property_pretty_name	es	slopeGradientClassProperty	\N
category_desc	category_desc_id	es	04 - Very gently sloping (1.0 - 2.0 %)	\N
category_desc	category_desc_id	es	FI - Fine/thin: Granular/platy: 1-2 mm,  Prismatic/columnar/wedgeshaped: 10-20 mm, Blocky/crumbly/lumpy/cloddy: 5-10 mm	\N
category_desc	category_desc_id	es	R - Raw humus (aeromorphic mor: usually thick (5-30 cm) organic matter accumulation that is largely unaltered owing to lack of decomposers. This kind of organic matter layer develops in extremely nutrient-poor and coarsetextured soils under vegetation that produces a litter layer that is difficult to decompose. It is usually a sequence of Oi-Oe-Oa layers over a thin A horizon, easy to separate one layer from another and being very acid with a C/N ratio of > 29.	\N
category_desc	category_desc_id	es	Dry - LS, SL, L: 0.8–1.2%	\N
category_desc	category_desc_id	es	SU - Sunny/clear	\N
category_desc	category_desc_id	es	Abruptic Solonetz	\N
category_desc	category_desc_id	es	BL - Boulders and large boulders	\N
property_phys_chem	property_phys_chem_id	es	Potassium (K) - total	\N
category_desc	category_desc_id	es	5YR 5/3 - reddish brown	\N
category_desc	category_desc_id	es	Dry - S: 0.3–0.6%	\N
category_desc	category_desc_id	es	MA2 - Acid metamorphic: gneiss, migmatite	\N
category_desc	category_desc_id	es	GO - Submerged by rising local groundwater less than once a year	\N
category_desc	category_desc_id	es	Dystric Leptosol	\N
category_desc	category_desc_id	es	Vesicular	\N
category_desc	category_desc_id	es	Acric	\N
category_desc	category_desc_id	es	Gyps, Gypsic	\N
category_desc	category_desc_id	es	7.5YR 6/6 - reddish yellow	\N
category_desc	category_desc_id	es	Skeletic	\N
category_desc	category_desc_id	es	B - Broken - Discontinuous	\N
category_desc	category_desc_id	es	Cambic Gypsisol	\N
category_desc	category_desc_id	es	IA3 - Acid igneous: quartz-diorite	\N
category_desc	category_desc_id	es	P - Poorly drained - Water is removed so slowly that the soils are commonly wet for considerable periods. The soils commonly have a shallow water table	\N
category_desc	category_desc_id	es	Ekranic Technosol	\N
property_desc	property_pretty_name	es	soilClassificationWRBProperty	\N
category_desc	category_desc_id	es	WE - Wedge-shaped	\N
category_desc	category_desc_id	es	Gelods	\N
category_desc	category_desc_id	es	SC4 - Clastic sediments: shale	\N
category_desc	category_desc_id	es	Alcalic	\N
property_phys_chem	property_phys_chem_id	es	Zinc (Zn) - extractable	\N
category_desc	category_desc_id	es	NNW - north-north-west	\N
category_desc	category_desc_id	es	80 - 90 %	\N
category_desc	category_desc_id	es	Coarse	\N
category_desc	category_desc_id	es	S - Sesquioxides	\N
category_desc	category_desc_id	es	S - south	\N
property_desc	property_pretty_name	es	Soil Odour	\N
category_desc	category_desc_id	es	WC4 - Rainy without heavy rain in the last 24 hours	\N
category_desc	category_desc_id	es	Glossic Phaeozem	\N
category_desc	category_desc_id	es	5 - 10 %	\N
category_desc	category_desc_id	es	Abruptic Luvisol	\N
category_desc	category_desc_id	es	Fe mottles and/or brown Fe concretions, in wet conditions	\N
property_desc	property_pretty_name	es	wetPlasticityProperty	\N
category_desc	category_desc_id	es	10Y 8/4	\N
category_desc	category_desc_id	es	Dystric	\N
category_desc	category_desc_id	es	Aquands	\N
category_desc	category_desc_id	es	7.5Y 8/2 - light grey	\N
category_desc	category_desc_id	es	Leptic Chernozem	\N
category_desc	category_desc_id	es	Stagnic Solonetz	\N
category_desc	category_desc_id	es	Hem	\N
property_desc	property_pretty_name	es	Stickiness	\N
category_desc	category_desc_id	es	M - Medium (1 - 2 cm)	\N
category_desc	category_desc_id	es	C - Common	\N
category_desc	category_desc_id	es	Black Mn concretions	\N
category_desc	category_desc_id	es	Skeletic Retisol	\N
property_desc	property_pretty_name	es	Mineral Concentrations Shape	\N
category_desc	category_desc_id	es	BR - Burning	\N
category_desc	category_desc_id	es	PH - Phreatic	\N
category_desc	category_desc_id	es	> 0.17 g cm-3	\N
category_desc	category_desc_id	es	5G 4/2 - greyish green	\N
property_desc	property_pretty_name	es	Temperature Regime	\N
category_desc	category_desc_id	es	Aqu	\N
category_desc	category_desc_id	es	SV1: < 3 %	\N
category_desc	category_desc_id	es	5G 6/2 - pale green	\N
category_desc	category_desc_id	es	CeWh - Wheat	\N
category_desc	category_desc_id	es	FrAp - Apples	\N
category_desc	category_desc_id	es	F - Fine artefacts (2 - 6 mm)	\N
category_desc	category_desc_id	es	W - Wet	\N
category_desc	category_desc_id	es	Plac, Placic	\N
category_desc	category_desc_id	es	Am - Tropical rainforest short dry season	\N
category_desc	category_desc_id	es	Pelocrustic	\N
category_desc	category_desc_id	es	2 - Low (2-5%)	\N
property_desc	property_pretty_name	es	WRB Supplementary Qualifier	\N
category_desc	category_desc_id	es	Rheic Histosol	\N
category_desc	category_desc_id	es	Plaggic Alisol	\N
category_desc	category_desc_id	es	Coarsic Durisol	\N
category_desc	category_desc_id	es	Sodic	\N
category_desc	category_desc_id	es	FoCl - Clover	\N
category_desc	category_desc_id	es	Mollic Leptosol	\N
category_desc	category_desc_id	es	IP4 - Igneous  pyroclastic ignimbrite	\N
category_desc	category_desc_id	es	D - Closely spaced (0.2 - 0.5 m)	\N
category_desc	category_desc_id	es	F - Closed Forest	\N
category_desc	category_desc_id	es	VFI - Very firm: Soil material crushes under strong pressures; barely crushable between thumb and forefinger.	\N
property_desc	property_pretty_name	es	Erosion Activity Period	\N
category_desc	category_desc_id	es	Cambic Chernozem	\N
category_desc	category_desc_id	es	Moist - Other: < 0.3%	\N
category_desc	category_desc_id	es	Retisol (RT)	\N
category_desc	category_desc_id	es	UU4 - Unconsolidated: unspecified gravelly sand	\N
category_desc	category_desc_id	es	I - igneous rock	\N
category_desc	category_desc_id	es	EH - Hunting and fishing	\N
category_desc	category_desc_id	es	N - Non-cemented and non-compacted: Neither cementation nor compaction observed (slakes in water).	\N
category_desc	category_desc_id	es	Luvic Cryosol	\N
category_desc	category_desc_id	es	5Y 6/2 - light olive grey	\N
category_desc	category_desc_id	es	MC - Medium and coarse (2-20 mm).	\N
category_desc	category_desc_id	es	ST - Transport	\N
category_desc	category_desc_id	es	AC - Archaeological (burial mound, midden)	\N
category_desc	category_desc_id	es	C -  Coarse (> 20 mm)	\N
category_desc	category_desc_id	es	Dry - LS, SL, L: < 0.5%	\N
category_desc	category_desc_id	es	Rubic	\N
category_desc	category_desc_id	es	Cohesic	\N
category_desc	category_desc_id	es	Gleyic Regosol	\N
property_desc	property_pretty_name	es	Artefact Hardness	\N
category_desc	category_desc_id	es	Umbr, Umbric	\N
category_desc	category_desc_id	es	Eutrosilic	\N
category_desc	category_desc_id	es	Ya - Young (10-100 years) anthropogeomorphic: with complete disturbance of any natural surfaces (and soils), such as in urban, industrial, or mining areas, with early soil development from fresh natural, technogenic, or mixed materials, or restriction of flooding by dykes.	\N
category_desc	category_desc_id	es	Nudiargic Lixisol	\N
category_desc	category_desc_id	es	5YR 7/1 - light grey	\N
category_desc	category_desc_id	es	V - Very thick (> 20 mm)	\N
category_desc	category_desc_id	es	5R 3/3 - dusky red	\N
category_desc	category_desc_id	es	PN - Nature and game preservation	\N
category_desc	category_desc_id	es	10YR 8/8 - yellow	\N
category_desc	category_desc_id	es	BD1 - When dropped, sample disintegrates into numerous fragments, further disintegration of subfragments after application of weak pressure - angular blocky - 1.0-1.2	\N
category_desc	category_desc_id	es	AS - Angular and subangular blocky	\N
category_desc	category_desc_id	es	30 - 40 %	\N
category_desc	category_desc_id	es	Pretic Retisol	\N
category_desc	category_desc_id	es	Hapl	\N
category_desc	category_desc_id	es	Nitic	\N
category_desc	category_desc_id	es	10R 2.5/1 - reddish black	\N
category_desc	category_desc_id	es	S - Settlement, industry	\N
category_desc	category_desc_id	es	Spodosols	\N
category_desc	category_desc_id	es	Hum, Humic	\N
category_desc	category_desc_id	es	Chernic Umbrisol	\N
category_desc	category_desc_id	es	BD3 - Sample remains mostly intact when dropped, further disintegration possible after application of large pressure - coherent, prismatic, platy, (columnar, angular blocky, platy, wedgeshaped) - 1.4-1.6	\N
category_desc	category_desc_id	es	Chromic Cambisol	\N
category_desc	category_desc_id	es	Reductigleyic Gleysol	\N
category_desc	category_desc_id	es	Xerolls	\N
category_desc	category_desc_id	es	Leptic Alisol	\N
category_desc	category_desc_id	es	FF - Very fine and fine (< 2 mm)	\N
category_desc	category_desc_id	es	Gibbsic	\N
property_desc	property_pretty_name	es	mineralContentProperty	\N
category_desc	category_desc_id	es	08 - Moderately steep (15 - 30 %)	\N
category_desc	category_desc_id	es	10YR 7/8 - yellow	\N
category_desc	category_desc_id	es	Channels	\N
category_desc	category_desc_id	es	2.5YR 5/4 - reddish brown	\N
category_desc	category_desc_id	es	Very steep	\N
category_desc	category_desc_id	es	AD - Wind deposition	\N
category_desc	category_desc_id	es	Moderately steep	\N
category_desc	category_desc_id	es	Duric Chernozem	\N
property_desc	property_pretty_name	es	Artefact Weathering	\N
category_desc	category_desc_id	es	Umbric Nitisol	\N
category_desc	category_desc_id	es	6.6 - 7.3: Neutral	\N
category_desc	category_desc_id	es	Stagnic Acrisol	\N
category_desc	category_desc_id	es	Solimovic Cambisol	\N
category_desc	category_desc_id	es	Albic Podzol	\N
category_desc	category_desc_id	es	Water erosion or deposition	\N
category_desc	category_desc_id	es	W - west	\N
category_desc	category_desc_id	es	HVH - hard to very hard:	\N
category_desc	category_desc_id	es	LS - Lower slope (foot slope)	\N
category_desc	category_desc_id	es	Duric Planosol	\N
category_desc	category_desc_id	es	Haplic Kastanozem	\N
category_desc	category_desc_id	es	Litholinic	\N
category_desc	category_desc_id	es	7.5Y 7/0	\N
category_desc	category_desc_id	es	Dry - LS, SL, L: 0.5–0.8%	\N
category_desc	category_desc_id	es	CL - Clearing	\N
category_desc	category_desc_id	es	Xeralfs	\N
category_desc	category_desc_id	es	Camb	\N
category_desc	category_desc_id	es	MB5 - Basic metamorphic  amphibolite	\N
category_desc	category_desc_id	es	Luvic Stagnosol	\N
property_phys_chem	property_phys_chem_id	es	Clay texture fraction	\N
category_desc	category_desc_id	es	UR1 - Unconsolidated:  weathered residuum bauxite, laterite	\N
category_desc	category_desc_id	es	Skeletic Alisol	\N
category_desc	category_desc_id	es	Biocrustic	\N
category_desc	category_desc_id	es	Csa - Temperate rainy (humid mesothermal) climate with dry summer With hot summer	\N
category_desc	category_desc_id	es	Moist - LS, SL, L: > 4%	\N
category_desc	category_desc_id	es	BL - Black	\N
category_desc	category_desc_id	es	Sideralic Retisol	\N
category_desc	category_desc_id	es	5YR 4/1 - dark grey	\N
category_desc	category_desc_id	es	slope deposits	\N
category_desc	category_desc_id	es	SA - Salt (saline)	\N
category_desc	category_desc_id	es	7.5GY 7/10	\N
category_desc	category_desc_id	es	(green)schist	\N
category_desc	category_desc_id	es	2.5Y 6/8 - olive yellow	\N
category_desc	category_desc_id	es	BD4 - Knife penetrates only 1-2 cm into the moist soil, some effort required, sample disintegrates into few fragments, which cannot be subdivided further - prismatic, platy, (angular blocky) - 1.6-1.8	\N
category_desc	category_desc_id	es	Stagnic Ferralsol	\N
category_desc	category_desc_id	es	Lixic Nitisol	\N
category_desc	category_desc_id	es	VS - convex-straight	\N
property_phys_chem	property_phys_chem_id	es	totalCarbonateEquivalentProperty	\N
category_desc	category_desc_id	es	7.5YR 4/4 - (dark) brown	\N
category_desc	category_desc_id	es	limestone, other carbonate rock	\N
category_desc	category_desc_id	es	GI - Gilgai	\N
category_desc	category_desc_id	es	Vertic Luvisol	\N
category_desc	category_desc_id	es	Albic Stagnosol	\N
category_desc	category_desc_id	es	Histic Andosol	\N
category_desc	category_desc_id	es	Petrocalcic	\N
category_desc	category_desc_id	es	Sapr	\N
category_desc	category_desc_id	es	Moderately deep (50-100 cm)	\N
category_desc	category_desc_id	es	Moist - LS, SL, L: 0.6–1%	\N
category_desc	category_desc_id	es	Terric	\N
category_desc	category_desc_id	es	WC5 - Heavier rain for some days or rainstorm in the last 24 hours	\N
category_desc	category_desc_id	es	Calcaric Gypsisol	\N
category_desc	category_desc_id	es	Caf - Temperate rainy (humid mesothermal) climate - moist	\N
category_desc	category_desc_id	es	AA5 - Wet rice cultivation	\N
category_desc	category_desc_id	es	5YR 5/2 - reddish grey	\N
category_desc	category_desc_id	es	Kato	\N
category_desc	category_desc_id	es	Ombroaquic	\N
category_desc	category_desc_id	es	Vitric Histosol	\N
category_desc	category_desc_id	es	IB2 - basic  igneous: basalt	\N
category_desc	category_desc_id	es	SW - south-west	\N
category_desc	category_desc_id	es	Skeletic Umbrisol	\N
property_desc	property_pretty_name	es	Carbonate Forms	\N
category_desc	category_desc_id	es	MO - Moderately calcareous (2-10%) - Visible effervescence.	\N
category_desc	category_desc_id	es	Limnic	\N
category_desc	category_desc_id	es	Ustands	\N
category_desc	category_desc_id	es	1 - Reference profile description: No essential elements or details are missing from the description, sampling or analysis. The accuracy and reliability of the description and analytical results permit the full characterization of all soil horizons to a depth of 125 cm, or more if required for classification, or down to a C or R horizon or layer, which may be shallower.	\N
category_desc	category_desc_id	es	Hyperdystric	\N
category_desc	category_desc_id	es	Ha - Holocene (100-10,000 years) anthropogeomorphic: human-made relief modifications, such as terracing or formation of hills or walls by early civilizations or during the Middle Ages, restriction of flooding by dykes, or surface raising.	\N
category_desc	category_desc_id	es	F - Fine (<  1 cm)	\N
category_desc	category_desc_id	es	Profundihumic Nitisol	\N
category_desc	category_desc_id	es	WL - Waste liquid	\N
category_desc	category_desc_id	es	0 - 5 %	\N
category_desc	category_desc_id	es	E - Excessively well drained - Water is removed from the soil very rapidly	\N
category_desc	category_desc_id	es	Wapnic Gleysol	\N
category_desc	category_desc_id	es	RS - Reddish	\N
category_desc	category_desc_id	es	diorite-syenite	\N
category_desc	category_desc_id	es	10R 4/2 - weak red	\N
category_desc	category_desc_id	es	PN1 - Reserves	\N
category_desc	category_desc_id	es	amphibolite	\N
category_desc	category_desc_id	es	2.5Y 8/2 - white	\N
category_desc	category_desc_id	es	Sodic Solonchak	\N
category_desc	category_desc_id	es	SC - straight-concave	\N
property_desc	property_pretty_name	es	voidsDiameterProperty	\N
category_desc	category_desc_id	es	Dsa - Snow climates - dry summer, hot	\N
category_desc	category_desc_id	es	TS - Toe slope	\N
category_desc	category_desc_id	es	oPp - Older Pleistocene, with periglacial influence: commonly recent soil formation on younger over older, preweathered materials.	\N
category_desc	category_desc_id	es	Vertic Cambisol	\N
category_desc	category_desc_id	es	5YR 3/2 - dark reddish brown	\N
category_desc	category_desc_id	es	Aeolic Arenosol	\N
category_desc	category_desc_id	es	2.5Y 4/4 - olive brown	\N
category_desc	category_desc_id	es	Calcaric Durisol	\N
category_desc	category_desc_id	es	SL - Slightly gypsiric (0-5%) - EC = < 1.8 dS m-1 in 10 g soil/250 ml H2O	\N
category_desc	category_desc_id	es	T - Once every 5-10 years	\N
category_desc	category_desc_id	es	CSL - Coarse sandy loam	\N
category_desc	category_desc_id	es	C - Common (5 - 15 %)	\N
property_desc	property_pretty_name	es	Field Texture	\N
category_desc	category_desc_id	es	ME - Mesic	\N
category_desc	category_desc_id	es	Vertisols	\N
category_desc	category_desc_id	es	Dystr, Dys	\N
category_desc	category_desc_id	es	WE - With wetlands (occupying > 15%)	\N
category_desc	category_desc_id	es	VM - Very fine to medium	\N
category_desc	category_desc_id	es	VFR - Very friable: Soil material crushes under very gentle pressure, but coheres when pressed together.	\N
category_desc	category_desc_id	es	NF - Positive NaF test	\N
category_desc	category_desc_id	es	BS - Brownish	\N
category_desc	category_desc_id	es	Endoabruptic	\N
category_desc	category_desc_id	es	Aceric	\N
category_desc	category_desc_id	es	Leptosol (LP)	\N
category_desc	category_desc_id	es	5YR 8/4 - pink	\N
category_desc	category_desc_id	es	AT1 - Non-irrigated tree crop cultivation	\N
category_desc	category_desc_id	es	70 - 80 %	\N
category_desc	category_desc_id	es	2.5Y 5/2 - greyish brown	\N
category_desc	category_desc_id	es	clastic sediments	\N
category_desc	category_desc_id	es	5Y 4/2 - olive grey	\N
property_phys_chem	property_phys_chem_id	es	Sand texture fraction	\N
category_desc	category_desc_id	es	Eutric Stagnosol	\N
category_desc	category_desc_id	es	Hydragric Gleysol	\N
category_desc	category_desc_id	es	UM2 - Unconsolidated: marine clay and silt	\N
category_desc	category_desc_id	es	Gypsic	\N
category_desc	category_desc_id	es	Pretic Gleysol	\N
category_desc	category_desc_id	es	2.5YR 6/8 - light red	\N
category_desc	category_desc_id	es	D - Diffuse (> 2 mm)	\N
category_desc	category_desc_id	es	MQ - Duripan	\N
category_desc	category_desc_id	es	7.5GY 3/2	\N
category_desc	category_desc_id	es	Fluvic Kastanozem	\N
category_desc	category_desc_id	es	Gypsiric Regosol	\N
category_desc	category_desc_id	es	7.5R 3/6 - dark red	\N
category_desc	category_desc_id	es	Vitric Andosol	\N
category_desc	category_desc_id	es	ESE - east-south-east	\N
category_desc	category_desc_id	es	Dorsic	\N
category_desc	category_desc_id	es	Chromic Vertisol	\N
category_desc	category_desc_id	es	ilmenite, magnetite, ironstone, serpentine	\N
category_desc	category_desc_id	es	BD1 - Sample disintegrates at the instant of sampling, many pores visible on the pit wall - single grain, granular - 0.9-1.2	\N
property_desc	property_pretty_name	es	soilClassificationUSDAProperty	\N
category_desc	category_desc_id	es	7.5Y 7/10	\N
category_desc	category_desc_id	es	CF - Coarse fragments	\N
category_desc	category_desc_id	es	Irragric Gleysol	\N
category_desc	category_desc_id	es	Wind erosion and deposition	\N
category_desc	category_desc_id	es	Plaggic Stagnosol	\N
property_desc	property_pretty_name	es	Rock weathering	\N
category_desc	category_desc_id	es	Pachic	\N
category_desc	category_desc_id	es	NS - No specific location	\N
category_desc	category_desc_id	es	carbonatic, organic	\N
property_desc	property_pretty_name	es	Rock Shape	\N
category_desc	category_desc_id	es	Skeletic Fluvisol	\N
category_desc	category_desc_id	es	Petrogypsic Kastanozem	\N
category_desc	category_desc_id	es	Gleyic Calcisol	\N
category_desc	category_desc_id	es	Calcaric Arenosol	\N
category_desc	category_desc_id	es	Fractic Gypsisol	\N
category_desc	category_desc_id	es	IA1 - Acid igneous: granite	\N
category_desc	category_desc_id	es	Brunic Leptosol	\N
category_desc	category_desc_id	es	Xererts	\N
category_desc	category_desc_id	es	Wapnic Cryosol	\N
category_desc	category_desc_id	es	Ferralic Acrisol	\N
category_desc	category_desc_id	es	BD3 - When dropped, sample disintegrates into few fragments, further disintegration of subfragments after application of mild pressure - angular blocky, prismatic, platy, columnar - 1.2-1.4	\N
category_desc	category_desc_id	es	5R 5/1 - reddish grey	\N
category_desc	category_desc_id	es	SL - Synthetic liquid	\N
category_desc	category_desc_id	es	Retic Podzol	\N
category_desc	category_desc_id	es	eclogite	\N
category_desc	category_desc_id	es	4.1 - Soil augering description - without sampling: Soil augerings do no permit a comprehensive soil profile description. Augerings are made for routine soil observation and identification in soil mapping, and for that purpose normally provide a satisfactory indication of the soil characteristics. Soil samples may be collected from augerings. Soil description is done without sampling.	\N
category_desc	category_desc_id	es	periglacial solifluction layer	\N
category_desc	category_desc_id	es	2.5Y 6/2 - light brownish grey	\N
category_desc	category_desc_id	es	Brunic Arenosol	\N
category_desc	category_desc_id	es	5R 3/4 - dusky red	\N
property_desc	property_pretty_name	es	Structure Grade	\N
category_desc	category_desc_id	es	Petric Gypsisol	\N
category_desc	category_desc_id	es	SHH - slightly hard to hard:	\N
category_desc	category_desc_id	es	2.5YR 6/0 - gray	\N
category_desc	category_desc_id	es	Pretic Cambisol	\N
category_desc	category_desc_id	es	C - Common (5-15 %)	\N
category_desc	category_desc_id	es	SS - Semi-deciduous shrub	\N
category_desc	category_desc_id	es	B - Biennually	\N
category_desc	category_desc_id	es	02 - Level (0.2 - 0.5 %)	\N
category_desc	category_desc_id	es	Mollic	\N
category_desc	category_desc_id	es	UU3 - Unconsolidated: unspecified sand	\N
category_desc	category_desc_id	es	7.5R 5/2 - weak red	\N
category_desc	category_desc_id	es	CS - Coarse sand	\N
category_desc	category_desc_id	es	L - Large boulders (60 - 200 cm)	\N
category_desc	category_desc_id	es	Albic Alisol	\N
category_desc	category_desc_id	es	Anthraquic Stagnosol	\N
category_desc	category_desc_id	es	5YR 4/4 - reddish brown	\N
category_desc	category_desc_id	es	Sulfidic	\N
category_desc	category_desc_id	es	NK - Not known	\N
category_desc	category_desc_id	es	Pale	\N
category_desc	category_desc_id	es	5R 5/2 - weak red	\N
category_desc	category_desc_id	es	CS - Clay-sesquioxides	\N
category_desc	category_desc_id	es	BO - Bottom (drainage line)	\N
category_desc	category_desc_id	es	Ferralsol (FR)	\N
category_desc	category_desc_id	es	HL - hard cemented layer or layers of carbonates (less than 10 cm thick)	\N
category_desc	category_desc_id	es	MP - Agropastoralism	\N
category_desc	category_desc_id	es	Flat	\N
category_desc	category_desc_id	es	Murshic Histosol	\N
category_desc	category_desc_id	es	BSk - Steppe climate Dry-cold	\N
category_desc	category_desc_id	es	Pisoplinthic Gleysol	\N
category_desc	category_desc_id	es	AT2 - Irrigated tree crop cultivation	\N
property_desc	property_pretty_name	es	Roots Size	\N
category_desc	category_desc_id	es	WNW - west-north-west	\N
category_desc	category_desc_id	es	Raptic	\N
property_phys_chem	property_phys_chem_id	es	pH - Hydrogen potential	\N
category_desc	category_desc_id	es	I - Irregular - Pockets more deep than wide	\N
category_desc	category_desc_id	es	I - Interstitial: Controlled by the fabric, or arrangement, of the soil particles, also known as textural voids. Subdivision possible into simple packing voids, which relate to the packing of sand particles, and compound packing voids, which result from the packing of non-accommodating peds. Predominantly irregular in shape and interconnected, and hard to quantify in the field.	\N
category_desc	category_desc_id	es	fluvial	\N
property_desc	property_pretty_name	es	soilDepthSampledProperty	\N
category_desc	category_desc_id	es	Anofluvic Fluvisol	\N
category_desc	category_desc_id	es	Sal	\N
category_desc	category_desc_id	es	S - Sloping land (10 - 30 %)	\N
category_desc	category_desc_id	es	M - Moderately widely spaced (0.5 - 2 m)	\N
property_phys_chem	property_phys_chem_id	es	organicMatterProperty	\N
category_desc	category_desc_id	es	2.5Y 6/0 - (light) grey	\N
category_desc	category_desc_id	es	FM - Fine and medium	\N
category_desc	category_desc_id	es	Cordic	\N
category_desc	category_desc_id	es	Acric Stagnosol	\N
category_desc	category_desc_id	es	Yermic Fluvisol	\N
category_desc	category_desc_id	es	PC - Partly cloudy	\N
category_desc	category_desc_id	es	BSh - Steppe climate Dry-hot	\N
category_desc	category_desc_id	es	E - east	\N
category_desc	category_desc_id	es	LuTe - Tea	\N
category_desc	category_desc_id	es	Moist - Other: 3–5%	\N
category_desc	category_desc_id	es	Irragric Cambisol	\N
category_desc	category_desc_id	es	2.5Y 7/2 - light grey	\N
category_desc	category_desc_id	es	WC1 - No rain in the last month	\N
category_desc	category_desc_id	es	Petrocalcic Solonchak	\N
category_desc	category_desc_id	es	HE3 - Ranching	\N
category_desc	category_desc_id	es	Fr - Fruits and Melons	\N
category_desc	category_desc_id	es	10Y 5/2 - olive grey	\N
category_desc	category_desc_id	es	Protic Arenosol	\N
category_desc	category_desc_id	es	Calcic Cryosol	\N
category_desc	category_desc_id	es	Cambic Durisol	\N
category_desc	category_desc_id	es	Gleyic Andosol	\N
category_desc	category_desc_id	es	bauxite, laterite	\N
category_desc	category_desc_id	es	S - Soft segregation (or soft accumulation): Differs from the surrounding soil mass in colour and composition but is not easily separated as a discrete body	\N
property_desc	property_pretty_name	es	USDA Formative Element	\N
property_phys_chem	property_phys_chem_id	es	Sodium (Na+) - exchangeable	\N
category_desc	category_desc_id	es	lahar	\N
category_desc	category_desc_id	es	Dwd - Snow climates - dry winter, very cold winter	\N
category_desc	category_desc_id	es	A - Artefacts	\N
category_desc	category_desc_id	es	Eutric Cambisol	\N
category_desc	category_desc_id	es	Torrands	\N
category_desc	category_desc_id	es	FC - Fine to coarse	\N
category_desc	category_desc_id	es	Ornithic	\N
category_desc	category_desc_id	es	MU - Mineral additions (not specified)	\N
category_desc	category_desc_id	es	Leptic Stagnosol	\N
category_desc	category_desc_id	es	RU - Rudic	\N
category_desc	category_desc_id	es	Fragic Lixisol	\N
property_phys_chem	property_phys_chem_id	es	Aluminium (Al+++) - exchangeable	\N
category_desc	category_desc_id	es	Gypsisol (GY)	\N
category_desc	category_desc_id	es	N - No influence	\N
category_desc	category_desc_id	es	D - Dry	\N
category_desc	category_desc_id	es	Cw - Mild temperate rainy climate - winter dry	\N
property_desc	property_pretty_name	es	Fragments Cover	\N
category_desc	category_desc_id	es	Calcic Solonchak	\N
category_desc	category_desc_id	es	Cryerts	\N
category_desc	category_desc_id	es	CS - concave-straight	\N
category_desc	category_desc_id	es	Pretic Phaeozem	\N
category_desc	category_desc_id	es	Ultisols	\N
category_desc	category_desc_id	es	UE1 - Unconsolidated: eolian loess	\N
property_desc	property_pretty_name	es	Koeppen Class	\N
category_desc	category_desc_id	es	06 - Sloping (5 - 10 %)	\N
category_desc	category_desc_id	es	UA2 -  Unconsolidated: Anthropogenic/ technogenic industrial/artisanal deposits	\N
category_desc	category_desc_id	es	> 9.0: Very Strongly alkaline	\N
category_desc	category_desc_id	es	Hypergypsic	\N
category_desc	category_desc_id	es	MO - Organic additions (not specified)	\N
category_desc	category_desc_id	es	3.5 - 4.4: Extremely acidic	\N
category_desc	category_desc_id	es	7.5R 3/0 - very dark grey	\N
category_desc	category_desc_id	es	C - Warm temperate (mesothermal) climates	\N
category_desc	category_desc_id	es	LuCc - Cocoa	\N
category_desc	category_desc_id	es	SSE - south-south-east	\N
category_desc	category_desc_id	es	5YR 2.5/1 - black	\N
category_desc	category_desc_id	es	Yermic Luvisol	\N
category_desc	category_desc_id	es	FM - Fine and medium gravel/artefacts	\N
category_desc	category_desc_id	es	RA - Rain	\N
category_desc	category_desc_id	es	LS - Loamy sand	\N
category_desc	category_desc_id	es	F - Few (2-5 %)	\N
category_desc	category_desc_id	es	N - None	\N
category_desc	category_desc_id	es	Acric Ferralsol	\N
category_desc	category_desc_id	es	HT - Hyperthermic	\N
category_desc	category_desc_id	es	Dystric Cambisol	\N
category_desc	category_desc_id	es	F - Few (2-5%)	\N
category_desc	category_desc_id	es	silt-, mud-, claystone	\N
category_desc	category_desc_id	es	M - Moist: Crushing: is sticky. Forming (to a ball): finger moist and cool, weakly shiny. Moistening: no change of colour. Rubbing (in the hand): obviously lighter. pF: 2.	\N
category_desc	category_desc_id	es	V - Very fine (< 0.5 mm) - Usually thick (5-30 cm) organic matter accumulation that is largely unaltered owing to lack of decomposers. This kind of organic matter layer develops in extremely nutrient-poor and coarsetextured soils under vegetation that produces a litter layer that is difficult to decompose. It is usually a sequence of Oi-Oe-Oa layers over a thin A horizon, easy to separate one layer from another and being very acid with a C/N ratio of > 29.	\N
category_desc	category_desc_id	es	10R 5/1 - reddish grey	\N
category_desc	category_desc_id	es	Gypsids	\N
category_desc	category_desc_id	es	Albic Luvisol	\N
category_desc	category_desc_id	es	Histic Stagnosol	\N
category_desc	category_desc_id	es	PO  - Polluted	\N
category_desc	category_desc_id	es	Tephric Arenosol	\N
category_desc	category_desc_id	es	7.5GY 7/0	\N
category_desc	category_desc_id	es	7.5GY 6/2	\N
category_desc	category_desc_id	es	Petric Plinthosol	\N
category_desc	category_desc_id	es	S - Severe - Surface horizons completely removed and subsurface horizons exposed. Original biotic functions largely destroyed	\N
category_desc	category_desc_id	es	5YR 3/1 - very dark grey	\N
category_desc	category_desc_id	es	Histic	\N
category_desc	category_desc_id	es	PD - Degradation control	\N
category_desc	category_desc_id	es	10R 6/1 - reddish grey	\N
category_desc	category_desc_id	es	Lignic	\N
property_desc	property_pretty_name	es	organicMatterClassProperty	\N
category_desc	category_desc_id	es	oPi - Older Pleistocene, ice-covered: commonly recent soil formation on younger over older, preweathered materials.	\N
category_desc	category_desc_id	es	5Y 7/8 - yellow	\N
category_desc	category_desc_id	es	S - Smooth - Nearly plane surface	\N
category_desc	category_desc_id	es	Albic Retisol	\N
property_desc	property_pretty_name	es	Coatings Location	\N
category_desc	category_desc_id	es	Aluandic Andosol	\N
category_desc	category_desc_id	es	Durisol (DU)	\N
category_desc	category_desc_id	es	Terric Lixisol	\N
category_desc	category_desc_id	es	Natric Cryosol	\N
category_desc	category_desc_id	es	2 - Routine profile description: No essential elements are missing from the description, sampling or analysis. The number of samples collected is sufficient to characterize all major soil horizons, but may not allow precise definition of all subhorizons, especially in the deeper soil. The profile depth is 80 cm or more, or down to a C or R horizon or layer, which may be shallower. Additional augering and sampling may be required for lower level classification.	\N
category_desc	category_desc_id	es	D - Disperse powdery lime	\N
category_desc	category_desc_id	es	01 - Flat (0 - 0.2 %)	\N
category_desc	category_desc_id	es	Leptic Cryosol	\N
category_desc	category_desc_id	es	Fol	\N
category_desc	category_desc_id	es	5GY 7/1 - light greenish grey	\N
category_desc	category_desc_id	es	Tidalic Regosol	\N
category_desc	category_desc_id	es	7.5YR 8/4 - pink	\N
category_desc	category_desc_id	es	Abruptic Alisol	\N
category_desc	category_desc_id	es	Durinodic	\N
category_desc	category_desc_id	es	Aeric	\N
category_desc	category_desc_id	es	10YR 3/3 - dark brown	\N
category_desc	category_desc_id	es	F - Iron (ferruginous)	\N
property_desc	property_pretty_name	es	Roots Abundance	\N
category_desc	category_desc_id	es	Mollic Andosol	\N
category_desc	category_desc_id	es	R - Residual rock fragment: Discrete impregnated body still showing rock structure	\N
category_desc	category_desc_id	es	Dry - LS, SL, L: 4–6%	\N
category_desc	category_desc_id	es	EC - Extremely coarse: Prismatic/columnar/wedgeshaped: > 500 mm	\N
category_desc	category_desc_id	es	10Y 6/1 - grey	\N
category_desc	category_desc_id	es	Rhodic Acrisol	\N
category_desc	category_desc_id	es	5Y 6/3 - pale olive	\N
category_desc	category_desc_id	es	Plaggic Retisol	\N
category_desc	category_desc_id	es	MF - Agroforestry	\N
category_desc	category_desc_id	es	Oxisols	\N
property_phys_chem	property_phys_chem_id	es	Carbon (C) - organic	\N
category_desc	category_desc_id	es	Gleyic Phaeozem	\N
category_desc	category_desc_id	es	vYa - Very young (1-10 years) anthropogeomorphic: with complete disturbance of natural surfaces (and soils), such as in urban, industrial, or mining areas, with very early soil development from fresh natural, technogenic, or mixed materials.	\N
category_desc	category_desc_id	es	5R 4/3 - weak red	\N
category_desc	category_desc_id	es	Xanthic Nitisol	\N
category_desc	category_desc_id	es	DI - Discontinuous irregular: Surface of coatings contrasts strongly in smoothness or colour with the adjacent surfaces. Outlines of fine sand grains are not visible. Lamellae are more than 5 mm thick.	\N
category_desc	category_desc_id	es	HHC - Hard hollow concretions	\N
category_desc	category_desc_id	es	Gleyic Cambisol	\N
category_desc	category_desc_id	es	Differentic	\N
category_desc	category_desc_id	es	IB - Border irrigation	\N
category_desc	category_desc_id	es	5R 3/1 - dark reddish grey	\N
category_desc	category_desc_id	es	7.5Y 5/2 - greyish olive	\N
category_desc	category_desc_id	es	VPL - Very plastic - Wire formable and can be bent into a ring; moderately strong to very strong force required for deformation of the soil mass.	\N
category_desc	category_desc_id	es	XE - Xeric	\N
category_desc	category_desc_id	es	Vertic Kastanozem	\N
category_desc	category_desc_id	es	7.5Y 8/4	\N
category_desc	category_desc_id	es	AN - Anthraquic	\N
category_desc	category_desc_id	es	T - Terraced	\N
category_desc	category_desc_id	es	5YR 6/4 - light reddish brown	\N
category_desc	category_desc_id	es	Sphagn	\N
category_desc	category_desc_id	es	Gypsiric	\N
category_desc	category_desc_id	es	5R 3/2 - dusky red	\N
category_desc	category_desc_id	es	7.5GY 6/6	\N
category_desc	category_desc_id	es	BP - Borrow pit	\N
category_desc	category_desc_id	es	PF - Pressure faces	\N
category_desc	category_desc_id	es	E - Extremely hard	\N
category_desc	category_desc_id	es	Pretic Lixisol	\N
category_desc	category_desc_id	es	Thyric Technosol	\N
category_desc	category_desc_id	es	Duric Vertisol	\N
category_desc	category_desc_id	es	10R 4/4 - weak red	\N
category_desc	category_desc_id	es	Mollic Cryosol	\N
category_desc	category_desc_id	es	OiSu - Sunflower	\N
category_desc	category_desc_id	es	Takyric Durisol	\N
category_desc	category_desc_id	es	2.5YR 5/8 - red	\N
category_desc	category_desc_id	es	UO - Submerged by inland water of unknown origin less than once a year	\N
property_desc	property_pretty_name	es	WRB Soil Group	\N
category_desc	category_desc_id	es	Nitic Plinthosol	\N
property_phys_chem	property_phys_chem_id	es	aluminiumProperty	\N
category_desc	category_desc_id	es	V - Very thick (>20 mm)	\N
category_desc	category_desc_id	es	YR - Yellowish red	\N
category_desc	category_desc_id	es	HI1 - Animal production	\N
category_desc	category_desc_id	es	Aw - Tropical savanna	\N
category_desc	category_desc_id	es	Calcaric Fluvisol	\N
category_desc	category_desc_id	es	Albic Plinthosol	\N
property_desc	property_pretty_name	es	poresSizeProperty	\N
property_desc	property_pretty_name	es	Mottles Abundance	\N
category_desc	category_desc_id	es	5–10	\N
category_desc	category_desc_id	es	Protoandic	\N
category_desc	category_desc_id	es	Alic Podzol	\N
category_desc	category_desc_id	es	Thapto	\N
category_desc	category_desc_id	es	Hypernatric	\N
category_desc	category_desc_id	es	PD1 - Without interference	\N
category_desc	category_desc_id	es	Terric Luvisol	\N
category_desc	category_desc_id	es	Stagnic Gypsisol	\N
category_desc	category_desc_id	es	2.5Y 6/6 - olive yellow	\N
category_desc	category_desc_id	es	SV5: ? 12 %	\N
category_desc	category_desc_id	es	RF - Submerged by local rainwater at least once a year	\N
category_desc	category_desc_id	es	M - Medium (2 - 5 mm)	\N
category_desc	category_desc_id	es	FX - Xeromorphic forest	\N
category_desc	category_desc_id	es	90 - 100 %	\N
category_desc	category_desc_id	es	GS - Greyish	\N
property_phys_chem	property_phys_chem_id	es	Sulfur (S) - total	\N
category_desc	category_desc_id	es	TE - Terracing	\N
category_desc	category_desc_id	es	GY - Gypsum (gypsiferous)	\N
category_desc	category_desc_id	es	4 - Deep (100-150 cm)	\N
category_desc	category_desc_id	es	Alic Cryosol	\N
category_desc	category_desc_id	es	Laxic	\N
property_phys_chem	property_phys_chem_id	es	Calcium (Ca++) - extractable	\N
category_desc	category_desc_id	es	10Y 7/4	\N
category_desc	category_desc_id	es	Histosol (HS)	\N
category_desc	category_desc_id	es	marl and other mixtures	\N
property_phys_chem	property_phys_chem_id	es	Calcium (Ca++) - total	\N
category_desc	category_desc_id	es	Oi - Oilcrops	\N
category_desc	category_desc_id	es	MS - Middle slope (back slope)	\N
category_desc	category_desc_id	es	Spodic Cryosol	\N
category_desc	category_desc_id	es	Haplic Solonetz	\N
category_desc	category_desc_id	es	Salt deposition	\N
category_desc	category_desc_id	es	SK - Skeletic	\N
category_desc	category_desc_id	es	10YR 4/6 - dark yellowish brown	\N
category_desc	category_desc_id	es	lPp - Late Pleistocene, periglacial: commonly recent soil formation on preweathered materials.	\N
category_desc	category_desc_id	es	Coarsic Leptosol	\N
category_desc	category_desc_id	es	Gypsic Durisol	\N
category_desc	category_desc_id	es	SM - Medium-gradient mountain (10 - 30 %)	\N
category_desc	category_desc_id	es	C - Coarse (5-20 mm).	\N
category_desc	category_desc_id	es	Hypersalic	\N
category_desc	category_desc_id	es	F - Faint: The mottles are evident only on close examination. Soil colours in both the matrix and mottles have closely related hues, chromas and values.	\N
category_desc	category_desc_id	es	Leptic Vertisol	\N
category_desc	category_desc_id	es	OiLi - Linseed	\N
property_desc	property_pretty_name	es	USDA Suborder	\N
category_desc	category_desc_id	es	pyroxenite	\N
category_desc	category_desc_id	es	Reductaquic Cryosol	\N
category_desc	category_desc_id	es	10R 5/8 - red	\N
property_desc	property_pretty_name	es	Rock Primary	\N
category_desc	category_desc_id	es	Petrocalcic Kastanozem	\N
category_desc	category_desc_id	es	S - Sulphurous - Presence of H2S (hydrogen sulphide; "rotten eggs"); commonly associated with strongly reduced soil containing sulphur compounds.	\N
property_phys_chem	property_phys_chem_id	es	Nitrogen (N) - total	\N
category_desc	category_desc_id	es	DS - Semi-deciduous dwarf shrub	\N
category_desc	category_desc_id	es	Hortic Podzol	\N
category_desc	category_desc_id	es	Solonetz (SN)	\N
category_desc	category_desc_id	es	DC - Discontinuous circular: Elongated voids of faunal or floral origin, mostly tubular in shape and continuous, varying strongly in diameter. When wider than a few centimetres (burrow holes), they are more adequately described under biological activity.	\N
category_desc	category_desc_id	es	Coarsic Cryosol	\N
category_desc	category_desc_id	es	Vermic Phaeozem	\N
category_desc	category_desc_id	es	Anthraquic Acrisol	\N
category_desc	category_desc_id	es	7.5Y 6/6	\N
category_desc	category_desc_id	es	Moist - S: 3–6%	\N
category_desc	category_desc_id	es	M - Medium (2-5 mm) - characterized by the periodic absence of organic matter accumulation on the surface owing to the rapid decomposition process and mixing of organic matter and the mineral soil material by bioturbation. It is usually slightly acid to neutral with a C/N ratio of 10-18.	\N
category_desc	category_desc_id	es	IH - Isohyperthermic	\N
property_phys_chem	property_phys_chem_id	es	Sulfur (S) - extractable	\N
category_desc	category_desc_id	es	C - Coarse artefacts (> 20 mm)	\N
category_desc	category_desc_id	es	7.5Y 6/0	\N
category_desc	category_desc_id	es	2-5 m	\N
property_desc	property_pretty_name	es	Artefact Colour	\N
category_desc	category_desc_id	es	Terric Gleysol	\N
property_desc	property_pretty_name	es	Erosion Class	\N
property_desc	property_pretty_name	es	Landuse	\N
category_desc	category_desc_id	es	25 - 50 %	\N
category_desc	category_desc_id	es	IA2 - Acid igneous: grano-diorite	\N
category_desc	category_desc_id	es	5Y 4/1 - dark grey	\N
category_desc	category_desc_id	es	Neobrunic	\N
category_desc	category_desc_id	es	Endo	\N
category_desc	category_desc_id	es	R - Active in recent past (previous 50-100 years)	\N
category_desc	category_desc_id	es	7.5GY 8/2	\N
category_desc	category_desc_id	es	Plinthosol (PT)	\N
category_desc	category_desc_id	es	7.5Y 4/0	\N
category_desc	category_desc_id	es	Pretic Stagnosol	\N
category_desc	category_desc_id	es	V - Very few (0-2%)	\N
property_desc	property_pretty_name	es	Mottles Contrast	\N
category_desc	category_desc_id	es	Gleyic Lixisol	\N
category_desc	category_desc_id	es	loess	\N
category_desc	category_desc_id	es	N - None (0 %)	\N
category_desc	category_desc_id	es	10R 6/3 - pale red	\N
property_desc	property_pretty_name	es	WRB Specifier	\N
category_desc	category_desc_id	es	Af - Tropical rainforest - moist	\N
category_desc	category_desc_id	es	Stagnic Fluvisol	\N
category_desc	category_desc_id	es	rainwater-fed moor peat	\N
category_desc	category_desc_id	es	5Y 7/6 - yellow	\N
category_desc	category_desc_id	es	Hypercalcic	\N
category_desc	category_desc_id	es	Gleyic Planosol	\N
category_desc	category_desc_id	es	Luvic	\N
category_desc	category_desc_id	es	Dfa - Snow climates - moist all seasons, hot summer	\N
category_desc	category_desc_id	es	Posic	\N
category_desc	category_desc_id	es	Umbric Gleysol	\N
category_desc	category_desc_id	es	5G 5/1 - greenish grey	\N
category_desc	category_desc_id	es	Cryepts	\N
property_phys_chem	property_phys_chem_id	es	coarseFragmentsProperty	\N
category_desc	category_desc_id	es	I - Indurated: Cemented mass cannot be broken by body weight (75-kg standard soil scientist) (more than 90 percent of soil mass).	\N
category_desc	category_desc_id	es	Moist - S: 0.9–1.5%	\N
category_desc	category_desc_id	es	RI - Ridged	\N
category_desc	category_desc_id	es	SL - Slightly salty (0.75 - 2 dS m-1)	\N
category_desc	category_desc_id	es	Gypsiric Phaeozem	\N
category_desc	category_desc_id	es	M - Medium (6-20 mm)	\N
category_desc	category_desc_id	es	5Y 5/3 - olive	\N
category_desc	category_desc_id	es	W - Weekly	\N
category_desc	category_desc_id	es	2 - Very shallow (0-25 cm) Shallow (25-50 cm) Moderately deep (50-100 cm) Deep (100-150 cm) Very deep (> 150 cm) -15 days	\N
category_desc	category_desc_id	es	gneiss, migmatite	\N
category_desc	category_desc_id	es	7.5R 3/4 - dusky red	\N
category_desc	category_desc_id	es	Someric Kastanozem	\N
property_desc	property_pretty_name	es	slopeOrientationProperty	\N
category_desc	category_desc_id	es	Fractic	\N
category_desc	category_desc_id	es	Vitric Podzol	\N
category_desc	category_desc_id	es	Gleyic Fluvisol	\N
category_desc	category_desc_id	es	Dcw - Subarctic climate - dry winter	\N
category_desc	category_desc_id	es	AT3 - Non-irrigated shrub crop cultivation	\N
property_desc	property_pretty_name	es	Groundwater Depth	\N
property_desc	property_pretty_name	es	gypsumWeightProperty	\N
category_desc	category_desc_id	es	10YR 3/6 - dark yellowish brown	\N
category_desc	category_desc_id	es	Calcic Gypsisol	\N
category_desc	category_desc_id	es	P - Pedotubules	\N
category_desc	category_desc_id	es	Nechic	\N
property_phys_chem	property_phys_chem_id	es	Phosphorus (P) - total	\N
category_desc	category_desc_id	es	H - Herbaceous	\N
category_desc	category_desc_id	es	marine, estuarine	\N
category_desc	category_desc_id	es	AA2 - Fallow system cultivation	\N
category_desc	category_desc_id	es	UM1 - Unconsolidated: marine sand	\N
category_desc	category_desc_id	es	Hydragric Lixisol	\N
category_desc	category_desc_id	es	Ud	\N
category_desc	category_desc_id	es	Eutr, Eutric	\N
category_desc	category_desc_id	es	SCL - Sandy clay loam	\N
category_desc	category_desc_id	es	Dwb - Snow climates - dry winter, warm summer	\N
category_desc	category_desc_id	es	IP - Flood irrigation	\N
category_desc	category_desc_id	es	Fluvic Stagnosol	\N
category_desc	category_desc_id	es	Gleysol (GL)	\N
category_desc	category_desc_id	es	10R 4/3 - weak red	\N
category_desc	category_desc_id	es	Acric Durisol	\N
category_desc	category_desc_id	es	Natr, Natric	\N
category_desc	category_desc_id	es	10R 3/2 - dusky red	\N
category_desc	category_desc_id	es	Cry	\N
category_desc	category_desc_id	es	7.5YR 4/2 - (dark) brown	\N
category_desc	category_desc_id	es	Supra	\N
category_desc	category_desc_id	es	quartzite	\N
category_desc	category_desc_id	es	fine and medium	\N
category_desc	category_desc_id	es	organic	\N
category_desc	category_desc_id	es	Terric Alisol	\N
category_desc	category_desc_id	es	CePa - Rice, paddy	\N
category_desc	category_desc_id	es	FRF - Friable to firm:	\N
category_desc	category_desc_id	es	Greyish green, light blue: Fe-mix Compounds (Blue-Green Rust)	\N
category_desc	category_desc_id	es	H - Hard	\N
category_desc	category_desc_id	es	KA = Strong karst	\N
property_desc	property_pretty_name	es	Paved Abundance	\N
category_desc	category_desc_id	es	5Y 2.5/2 - black	\N
category_desc	category_desc_id	es	AA4I - Improved traditional rainfed arable cultivation	\N
category_desc	category_desc_id	es	Irragric Phaeozem	\N
category_desc	category_desc_id	es	UL2 - Unconsolidated: lacustrine silt and clay	\N
category_desc	category_desc_id	es	AA4M - Mechanized traditional rainfed arable cultivation	\N
category_desc	category_desc_id	es	Moist - Other: > 5%	\N
category_desc	category_desc_id	es	Vertic Phaeozem	\N
category_desc	category_desc_id	es	Gleyic Ferralsol	\N
property_desc	property_pretty_name	es	Soil Phase	\N
category_desc	category_desc_id	es	SV2: 3 - 5 %	\N
category_desc	category_desc_id	es	CU - Cuesta-shaped	\N
property_desc	property_pretty_name	es	Drainage Class	\N
category_desc	category_desc_id	es	Sodic Vertisol	\N
category_desc	category_desc_id	es	Andic Cambisol	\N
category_desc	category_desc_id	es	Yermic Regosol	\N
category_desc	category_desc_id	es	N 8/ - white	\N
category_desc	category_desc_id	es	Evapocrustic	\N
property_phys_chem	property_phys_chem_id	es	Silt texture fraction	\N
category_desc	category_desc_id	es	Mollic Stagnosol	\N
category_desc	category_desc_id	es	40 - 50 %	\N
category_desc	category_desc_id	es	5Y 7/4 - pale yellow	\N
category_desc	category_desc_id	es	7.5R 6/8 - light red	\N
category_desc	category_desc_id	es	5Y 8/6 - yellow	\N
category_desc	category_desc_id	es	Umbric Stagnosol	\N
category_desc	category_desc_id	es	Vermic Chernozem	\N
property_phys_chem	property_phys_chem_id	es	bulkDensityWholeSoilProperty	\N
category_desc	category_desc_id	es	UU2 - Unconsolidated  unspecifiedloam and silt	\N
category_desc	category_desc_id	es	Moist - LS, SL, L: 0.4–0.6%	\N
category_desc	category_desc_id	es	Ce - Cereals	\N
category_desc	category_desc_id	es	FP - Permanently submerged by inland water	\N
category_desc	category_desc_id	es	CeRy - Rye	\N
category_desc	category_desc_id	es	7.5YR 6/0 - (light) grey	\N
category_desc	category_desc_id	es	FM - Fine and medium (0.5-5 mm).	\N
category_desc	category_desc_id	es	PD2 - With interference	\N
category_desc	category_desc_id	es	7.5Y 8/8	\N
category_desc	category_desc_id	es	Medium	\N
category_desc	category_desc_id	es	MA1 - Acid metamorphic: quartzite	\N
category_desc	category_desc_id	es	Dd - Subarctic with very cold low-sun season	\N
category_desc	category_desc_id	es	Gypsic Solonchak	\N
category_desc	category_desc_id	es	FoHa - Hay	\N
category_desc	category_desc_id	es	WE - Evergreen woodland	\N
category_desc	category_desc_id	es	Plaggic Podzol	\N
category_desc	category_desc_id	es	Rhodic Lixisol	\N
category_desc	category_desc_id	es	Vertic	\N
category_desc	category_desc_id	es	FR - Frigid	\N
category_desc	category_desc_id	es	Gleyic Retisol	\N
category_desc	category_desc_id	es	Gypsiric Durisol	\N
category_desc	category_desc_id	es	Calcic Lixisol	\N
category_desc	category_desc_id	es	Terric Planosol	\N
category_desc	category_desc_id	es	LCS - Loamy coarse sand	\N
category_desc	category_desc_id	es	Irragric Stagnosol	\N
category_desc	category_desc_id	es	MB2 - Basic metamorphic:  (green)schist	\N
category_desc	category_desc_id	es	5BG 4/1 - dark greenish grey	\N
category_desc	category_desc_id	es	LO - Lower part (and dip)	\N
category_desc	category_desc_id	es	SC1 - Clastic sediments: conglomerate, breccia	\N
category_desc	category_desc_id	es	5YR 4/3 - reddish brown	\N
category_desc	category_desc_id	es	4 - Dominant (> 80 %)	\N
category_desc	category_desc_id	es	SA - Subangular and angular blocky	\N
category_desc	category_desc_id	es	Hydragric Luvisol	\N
category_desc	category_desc_id	es	Gelisols	\N
category_desc	category_desc_id	es	Thionic Cambisol	\N
category_desc	category_desc_id	es	NT - Positive NAF test and thixotropy	\N
category_desc	category_desc_id	es	Cwb - Warm Temperate - dry winter, warm summer	\N
category_desc	category_desc_id	es	7.5YR 4/6 - strong brown	\N
category_desc	category_desc_id	es	SC - Recreational use	\N
category_desc	category_desc_id	es	Gypsic Luvisol	\N
category_desc	category_desc_id	es	10Y 6/6	\N
category_desc	category_desc_id	es	Calcisol (CL)	\N
category_desc	category_desc_id	es	M - Moist	\N
category_desc	category_desc_id	es	Densic	\N
category_desc	category_desc_id	es	SN - Snow	\N
category_desc	category_desc_id	es	5YR 7/2 - pinkish grey	\N
category_desc	category_desc_id	es	P - Platy: The compacted or cemented parts are platelike and have a horizontal or subhorizontal orientation.	\N
category_desc	category_desc_id	es	Endostagnic	\N
category_desc	category_desc_id	es	Lamellic Acrisol	\N
category_desc	category_desc_id	es	II2 - Intermediate igneous: diorite-syenite	\N
category_desc	category_desc_id	es	Wind (aeolian) erosion or deposition	\N
category_desc	category_desc_id	es	SSS - slightly sticky to sticky -	\N
category_desc	category_desc_id	es	FR  - Fresh	\N
category_desc	category_desc_id	es	Duric Andosol	\N
category_desc	category_desc_id	es	Hydragric Nitisol	\N
category_desc	category_desc_id	es	5Y 6/6 - olive yellow	\N
category_desc	category_desc_id	es	10 - 20 %	\N
category_desc	category_desc_id	es	MR - Raised beds (agricultural purposes)	\N
category_desc	category_desc_id	es	Brunic Phaeozem	\N
category_desc	category_desc_id	es	Tonguic Umbrisol	\N
category_desc	category_desc_id	es	10YR 3/4 - dark yellowish brown	\N
category_desc	category_desc_id	es	FD - Deciduous forest	\N
category_desc	category_desc_id	es	10YR 7/1 - light grey	\N
category_desc	category_desc_id	es	Calcaric Leptosol	\N
category_desc	category_desc_id	es	Shallow (30-50 cm)	\N
category_desc	category_desc_id	es	Ustults	\N
category_desc	category_desc_id	es	IP1 - Igneous  pyroclastic tuff, tuffite	\N
category_desc	category_desc_id	es	Ferralic Nitisol	\N
category_desc	category_desc_id	es	Ferric Luvisol	\N
category_desc	category_desc_id	es	Fluv	\N
category_desc	category_desc_id	es	Clayic	\N
category_desc	category_desc_id	es	RoCa - Cassava	\N
category_desc	category_desc_id	es	intermediate igneous	\N
category_desc	category_desc_id	es	Leptic Lixisol	\N
category_desc	category_desc_id	es	sedimentary rock (unconsolidated)	\N
category_desc	category_desc_id	es	Stagnic	\N
category_desc	category_desc_id	es	5R 5/4 - weak red	\N
category_desc	category_desc_id	es	2.5Y 3/0 - very dark grey	\N
category_desc	category_desc_id	es	PuLe - Lentils	\N
category_desc	category_desc_id	es	IU2 - Ultrabasic igneous: pyroxenite	\N
category_desc	category_desc_id	es	Humults	\N
category_desc	category_desc_id	es	Dry - LS, SL, L: 2–4%	\N
property_desc	property_pretty_name	es	cationsSumProperty	\N
category_desc	category_desc_id	es	Histic Plinthosol	\N
category_desc	category_desc_id	es	Xanthic Acrisol	\N
category_desc	category_desc_id	es	S - Stone line: any content, but concentrated at a distinct depth of a horizon	\N
category_desc	category_desc_id	es	Gypsiric Calcisol	\N
category_desc	category_desc_id	es	5BG 7/1 - light greenish grey	\N
category_desc	category_desc_id	es	ultrabasic igneous	\N
category_desc	category_desc_id	es	MC - Medium and coarse MV Medium to very coarse	\N
category_desc	category_desc_id	es	OiOl - Olives	\N
category_desc	category_desc_id	es	Fragic Cambisol	\N
category_desc	category_desc_id	es	Calcic Andosol	\N
category_desc	category_desc_id	es	Lixic Umbrisol	\N
category_desc	category_desc_id	es	Rendzic Phaeozem	\N
category_desc	category_desc_id	es	Garbic Technosol	\N
category_desc	category_desc_id	es	Terric Umbrisol	\N
category_desc	category_desc_id	es	Andic Leptosol	\N
category_desc	category_desc_id	es	Anthraquic	\N
category_desc	category_desc_id	es	C - Clay	\N
category_desc	category_desc_id	es	5G 7/2 - pale green	\N
category_desc	category_desc_id	es	Acric Podzol	\N
category_desc	category_desc_id	es	Chernic Andosol	\N
category_desc	category_desc_id	es	OtSc - Sugar cane	\N
category_desc	category_desc_id	es	M - Monthly	\N
category_desc	category_desc_id	es	Skeletic Ferralsol	\N
category_desc	category_desc_id	es	Petric Calcisol	\N
category_desc	category_desc_id	es	> 50 m	\N
category_desc	category_desc_id	es	10R 6/8 - light red	\N
category_desc	category_desc_id	es	EX - Extremely gypsiric (> 60%)	\N
category_desc	category_desc_id	es	SVS - sticky to very sticky -	\N
category_desc	category_desc_id	es	5Y 4/4 - olive	\N
category_desc	category_desc_id	es	10YR 6/6 - brownish yellow	\N
category_desc	category_desc_id	es	Leptic Retisol	\N
category_desc	category_desc_id	es	Planosol (PL)	\N
category_desc	category_desc_id	es	Anthrosol (AT)	\N
category_desc	category_desc_id	es	Vertic Alisol	\N
category_desc	category_desc_id	es	Dry - S: 3–5%	\N
category_desc	category_desc_id	es	AA3 - Ley system cultivation	\N
category_desc	category_desc_id	es	Lamellic Alisol	\N
category_desc	category_desc_id	es	HL - hard cemented layer or layers of gypsum (less than 10 cm thick)	\N
category_desc	category_desc_id	es	2.5Y 8/8 - yellow	\N
category_desc	category_desc_id	es	Histic Gleysol	\N
category_desc	category_desc_id	es	5YR 5/4 - reddish brown	\N
category_desc	category_desc_id	es	5 - 90-180 days	\N
category_desc	category_desc_id	es	Duric Phaeozem	\N
category_desc	category_desc_id	es	Acric Planosol	\N
category_desc	category_desc_id	es	Cryands	\N
category_desc	category_desc_id	es	2.5YR 6/2 - pale red	\N
category_desc	category_desc_id	es	FN2 - Clear felling	\N
category_desc	category_desc_id	es	Dry - Other: > 15%	\N
category_desc	category_desc_id	es	Tidalic Arenosol	\N
category_desc	category_desc_id	es	Moist - Other: 0.6–0.9%	\N
category_desc	category_desc_id	es	slate, phyllite (pelitic rocks)	\N
category_desc	category_desc_id	es	Isopteric	\N
category_desc	category_desc_id	es	10YR 2/1 - black	\N
category_desc	category_desc_id	es	S - Stones (6 - 20 cm)	\N
category_desc	category_desc_id	es	Relocatic	\N
category_desc	category_desc_id	es	CeMa - Maize	\N
category_desc	category_desc_id	es	F - Faint: Surface of coating shows only little contrast in colour, smoothness or any other property to the adjacent surface. Fine sand grains are readily apparent in the cutan. Lamellae are less than 2 mm thick.	\N
category_desc	category_desc_id	es	Dry - Other: 0.6–1.2%	\N
category_desc	category_desc_id	es	Leptic Luvisol	\N
category_desc	category_desc_id	es	C - Charcoal	\N
category_desc	category_desc_id	es	3 - Incomplete description: Certain relevant elements are missing from the description, an insufficient number of samples was collected, or the reliability of the analytical data does not permit a complete characterization of the soil. However, the description is useful for specific purposes and provides a satisfactory indication of the nature of the soil at high levels of soil taxonomic classification.	\N
category_desc	category_desc_id	es	D - disperse powdery gypsum	\N
category_desc	category_desc_id	es	AA4C - Commercial rainfed arable cultivation	\N
category_desc	category_desc_id	es	D - Diffuse (> 15 cm)	\N
category_desc	category_desc_id	es	SF - Shiny faces (as in nitic horizon)	\N
property_desc	property_pretty_name	es	Bare Soil Abundance	\N
category_desc	category_desc_id	es	SA  - Saline	\N
category_desc	category_desc_id	es	Vermic Regosol	\N
category_desc	category_desc_id	es	Petronodic	\N
category_desc	category_desc_id	es	Takyric Gypsisol	\N
category_desc	category_desc_id	es	WG - Gully erosion	\N
category_desc	category_desc_id	es	N - Non-gypsiric (0%) - EC = < 1.8 dS m-1 in 10 g soil/25 ml H2O, EC = < 0.18 dS m-1 in 10 g soil/250 ml H2O	\N
category_desc	category_desc_id	es	Takyric Solonchak	\N
category_desc	category_desc_id	es	Fractic Durisol	\N
category_desc	category_desc_id	es	UE2 - Unconsolidated: eolian sand	\N
category_desc	category_desc_id	es	10Y 8/10	\N
category_desc	category_desc_id	es	A - Coarse (> 20 mm)	\N
category_desc	category_desc_id	es	Interstitial	\N
category_desc	category_desc_id	es	gravel, broken rock	\N
category_desc	category_desc_id	es	Luv	\N
category_desc	category_desc_id	es	Moist - Other: 1.5–3%	\N
category_desc	category_desc_id	es	2.5Y 5/4 - light olive brown	\N
category_desc	category_desc_id	es	WM - Weak to moderate	\N
category_desc	category_desc_id	es	Ferralic Anthrosol	\N
category_desc	category_desc_id	es	Ferritic Nitisol	\N
category_desc	category_desc_id	es	< 2 m	\N
category_desc	category_desc_id	es	Orthods	\N
category_desc	category_desc_id	es	Stagnic Alisol	\N
category_desc	category_desc_id	es	2.5Y 7/8 - yellow	\N
category_desc	category_desc_id	es	SL - Sleet	\N
category_desc	category_desc_id	es	F - Few (2 - 5 %)	\N
category_desc	category_desc_id	es	7.5GY 8/8	\N
category_desc	category_desc_id	es	PG - Pergelic	\N
property_phys_chem	property_phys_chem_id	es	Manganese (Mn) - extractable	\N
category_desc	category_desc_id	es	10YR 7/2 - light grey	\N
category_desc	category_desc_id	es	Yermic Cryosol	\N
category_desc	category_desc_id	es	VU - Vegetation disturbed (not specified)	\N
category_desc	category_desc_id	es	SE - Evergreen shrub	\N
category_desc	category_desc_id	es	7.5GY 2.5/0	\N
category_desc	category_desc_id	es	C - Common - Roots with diameters < 2 mm: 50-200, Roots with diameters > 2 mm: 5-20.	\N
category_desc	category_desc_id	es	Anthromollic Podzol	\N
category_desc	category_desc_id	es	Calcaric	\N
category_desc	category_desc_id	es	Albic	\N
category_desc	category_desc_id	es	VE - Vegetation strongly disturbed	\N
category_desc	category_desc_id	es	D - Distinct: Surface of coating is distinctly smoother or different in colour from the adjacent surface. Fine sand grains are enveloped in the coating but their outlines are still visible. Lamellae are 2-5 mm thick.	\N
category_desc	category_desc_id	es	MS - Mine spoil or crude oil	\N
category_desc	category_desc_id	es	VFF - Very friable to friable:	\N
category_desc	category_desc_id	es	Hyperorganic	\N
category_desc	category_desc_id	es	C - Cemented: Cemented mass cannot be broken in the hands and is continuous (more than 90 percent of soil mass).	\N
category_desc	category_desc_id	es	sand	\N
category_desc	category_desc_id	es	Protic	\N
category_desc	category_desc_id	es	Petrocalcic Solonetz	\N
category_desc	category_desc_id	es	7.5YR 2/2 - very dark brown	\N
category_desc	category_desc_id	es	Petr	\N
category_desc	category_desc_id	es	SN - Nutty subangular blocky	\N
category_desc	category_desc_id	es	LV - Levelling	\N
category_desc	category_desc_id	es	Irragric Planosol	\N
category_desc	category_desc_id	es	ST - Sticky - After pressure, soil material adheres to both thumb and finger and tends to stretch somewhat and pull apart rather than pulling free from either digit.	\N
category_desc	category_desc_id	es	Chernic Phaeozem	\N
category_desc	category_desc_id	es	7.5GY 5/6	\N
category_desc	category_desc_id	es	Petroduric Vertisol	\N
category_desc	category_desc_id	es	Chloridic	\N
category_desc	category_desc_id	es	Dry - S: 0.6–1%	\N
category_desc	category_desc_id	es	S - sedimentary rock (consolidated)	\N
category_desc	category_desc_id	es	Hydragric Andosol	\N
category_desc	category_desc_id	es	5R 2.5/3 - very dusky red	\N
category_desc	category_desc_id	es	Vughs	\N
category_desc	category_desc_id	es	Nudiargic Retisol	\N
category_desc	category_desc_id	es	10R 4/8 - red	\N
category_desc	category_desc_id	es	D - Distinct: Although not striking, the mottles are readily seen. The hue, chroma and value of the matrix are easily distinguished from those of the mottles. They may vary by as much as 2.5 units of hue or several units in chroma or value.	\N
category_desc	category_desc_id	es	White, after oxidation blue: vivianite	\N
category_desc	category_desc_id	es	I - Other insect activity	\N
category_desc	category_desc_id	es	SS - Synthetic solid	\N
category_desc	category_desc_id	es	grano-diorite	\N
category_desc	category_desc_id	es	halite	\N
category_desc	category_desc_id	es	M - marl layer	\N
category_desc	category_desc_id	es	TM - High-gradient mountain (> 30 %)	\N
category_desc	category_desc_id	es	Very gently sloping 	\N
category_desc	category_desc_id	es	Solimovic	\N
category_desc	category_desc_id	es	10YR 4/1 - dark grey	\N
category_desc	category_desc_id	es	Gleyic Solonetz	\N
category_desc	category_desc_id	es	Alic Planosol	\N
category_desc	category_desc_id	es	Andic Anthrosol	\N
category_desc	category_desc_id	es	Muusic Histosol	\N
category_desc	category_desc_id	es	AP1 - Non-irrigated cultivation	\N
category_desc	category_desc_id	es	Isolatic	\N
category_desc	category_desc_id	es	Lamellic Lixisol	\N
category_desc	category_desc_id	es	Cb - Warm temperate (mesothermal) climates	\N
category_desc	category_desc_id	es	0.04 - 0.07 g cm-3	\N
category_desc	category_desc_id	es	Bluish black (with 10% HCl; H?S smell): Fe sulphides	\N
category_desc	category_desc_id	es	7.5YR 5/4 - brown	\N
category_desc	category_desc_id	es	NK - Unknown	\N
category_desc	category_desc_id	es	Eutric Retisol	\N
category_desc	category_desc_id	es	Sapric Histosol	\N
category_desc	category_desc_id	es	DX - Xeromorphic dwarf shrub	\N
category_desc	category_desc_id	es	Skeletic Histosol	\N
category_desc	category_desc_id	es	Skeletic Gypsisol	\N
category_desc	category_desc_id	es	Pretic	\N
category_desc	category_desc_id	es	Calcic Gleysol	\N
category_desc	category_desc_id	es	MT - Tidal area (between mean low and mean high water springs)	\N
category_desc	category_desc_id	es	HE1 - Nomadism	\N
category_desc	category_desc_id	es	Dolomitic Gleysol	\N
category_desc	category_desc_id	es	Ro - Roots and Tubers	\N
category_desc	category_desc_id	es	Gleyic Anthrosol	\N
category_desc	category_desc_id	es	Petrosalic Solonchak	\N
category_desc	category_desc_id	es	M - Manganese (manganiferous)	\N
property_desc	property_pretty_name	es	Rock Nature	\N
category_desc	category_desc_id	es	Gypsiric Gleysol	\N
property_phys_chem	property_phys_chem_id	es	Copper (Cu) - total	\N
category_desc	category_desc_id	es	5 - Other descriptions: Essential elements are missing from the description, preventing a satisfactory soil characterization and classification.	\N
category_desc	category_desc_id	es	0 %	\N
category_desc	category_desc_id	es	Moist - LS, SL, L: 2–4%	\N
category_desc	category_desc_id	es	R - Rapid run-off	\N
category_desc	category_desc_id	es	OX  - Oxygenated	\N
category_desc	category_desc_id	es	OiSo - Soybeans	\N
category_desc	category_desc_id	es	BR - Brown	\N
category_desc	category_desc_id	es	G - Gradual (5-15 cm)	\N
category_desc	category_desc_id	es	F - Thin (< 2 mm)	\N
category_desc	category_desc_id	es	Turbic	\N
category_desc	category_desc_id	es	Many	\N
property_desc	property_pretty_name	es	Cementation/compaction Continuity	\N
category_desc	category_desc_id	es	Skeletic Andosol	\N
category_desc	category_desc_id	es	L - Loam	\N
category_desc	category_desc_id	es	Chromic Acrisol	\N
category_desc	category_desc_id	es	WH - White	\N
category_desc	category_desc_id	es	Glossic Planosol	\N
category_desc	category_desc_id	es	Silandic Andosol	\N
category_desc	category_desc_id	es	P - Prominent: The mottles are conspicuous and mottling is one of the outstanding features of the horizon. Hue, chroma and value alone or in combination are at least several units apart.	\N
category_desc	category_desc_id	es	RO - Submerged by local rainwater less than once a year	\N
category_desc	category_desc_id	es	CeOa - Oats	\N
category_desc	category_desc_id	es	7.5Y 6/2 - greyish olive	\N
category_desc	category_desc_id	es	AT - Tree and shrub cropping	\N
category_desc	category_desc_id	es	Y - Compacted but non-cemented: Compacted mass is appreciably harder or more brittle than other comparable soil mass (slakes in water).	\N
category_desc	category_desc_id	es	5G 6/1 - greenish grey	\N
category_desc	category_desc_id	es	Tephric Andosol	\N
category_desc	category_desc_id	es	Dystric Arenosol	\N
category_desc	category_desc_id	es	ironstone	\N
category_desc	category_desc_id	es	Level	\N
property_phys_chem	property_phys_chem_id	es	Calcium (Ca++) - exchangeable	\N
category_desc	category_desc_id	es	7.5YR 6/4 - light brown	\N
category_desc	category_desc_id	es	M - Medium (2-5 mm)	\N
category_desc	category_desc_id	es	Rendzic Leptosol	\N
category_desc	category_desc_id	es	industrial/artisanal deposits	\N
category_desc	category_desc_id	es	Anthraquic Vertisol	\N
category_desc	category_desc_id	es	IT - Isothermic	\N
category_desc	category_desc_id	es	Dry - Other: 2–3%	\N
category_desc	category_desc_id	es	gravelly sand	\N
category_desc	category_desc_id	es	Stagnic Calcisol	\N
category_desc	category_desc_id	es	Hydragric Anthrosol	\N
category_desc	category_desc_id	es	5YR 6/8 - reddish yellow	\N
category_desc	category_desc_id	es	Carbic Podzol	\N
category_desc	category_desc_id	es	Andisols	\N
category_desc	category_desc_id	es	Gleyic Umbrisol	\N
category_desc	category_desc_id	es	andesite, trachyte, phonolite	\N
property_desc	property_pretty_name	es	Peat Volume	\N
category_desc	category_desc_id	es	Nitic Ferralsol	\N
category_desc	category_desc_id	es	M - Many (15-40%)	\N
category_desc	category_desc_id	es	S - Surface (< 2 cm)	\N
category_desc	category_desc_id	es	Hortic Phaeozem	\N
category_desc	category_desc_id	es	10YR 6/1 - (light) grey	\N
property_desc	property_pretty_name	es	Sand fraction Texture	\N
category_desc	category_desc_id	es	Umbric Plinthosol	\N
category_desc	category_desc_id	es	volcanic scoria/breccia	\N
category_desc	category_desc_id	es	BR  - Brackish	\N
property_desc	property_pretty_name	es	erosionTotalAreaAffectedProperty	\N
category_desc	category_desc_id	es	B - Broken: The layer is less than 50 percent cemented or compacted, and shows a rather irregular appearance.	\N
category_desc	category_desc_id	es	Umbric Ferralsol	\N
category_desc	category_desc_id	es	PM - Porous massive	\N
category_desc	category_desc_id	es	BL - Blocky	\N
category_desc	category_desc_id	es	CO - Columnar	\N
category_desc	category_desc_id	es	Haplic Vertisol	\N
category_desc	category_desc_id	es	SL - Silica (opal)	\N
category_desc	category_desc_id	es	RoSu - Sugar beets	\N
category_desc	category_desc_id	es	Gleyic Acrisol	\N
category_desc	category_desc_id	es	UG1 - Unconsolidated: glacial moraine	\N
category_desc	category_desc_id	es	Tonguic Kastanozem	\N
property_desc	property_pretty_name	es	saltProperty	\N
category_desc	category_desc_id	es	Alic Nitisol	\N
category_desc	category_desc_id	es	10R 6/2 - pale red	\N
category_desc	category_desc_id	es	V - Vesicular: The layer has large, equidimensional voids that may be filled with uncemented material.	\N
category_desc	category_desc_id	es	IB3 - basic igneous: dolerite	\N
category_desc	category_desc_id	es	10Y 8/6	\N
category_desc	category_desc_id	es	Relocatic Regosol	\N
category_desc	category_desc_id	es	2.5YR 4/2 - weak red	\N
category_desc	category_desc_id	es	Strongly sloping	\N
category_desc	category_desc_id	es	Calcaric Luvisol	\N
category_desc	category_desc_id	es	Histic Planosol	\N
category_desc	category_desc_id	es	Glossic Stagnosol	\N
category_desc	category_desc_id	es	W - Wet: Crushing: free water. Forming (to a ball): drops of water. Moistening: no change of colour. pF: 1.	\N
category_desc	category_desc_id	es	SO2 - Sedimentary organic: marl and other mixtures	\N
category_desc	category_desc_id	es	Aquox	\N
category_desc	category_desc_id	es	H - Mountain/Highland climates	\N
category_desc	category_desc_id	es	Pu - Pulses	\N
category_desc	category_desc_id	es	Eutric Fluvisol	\N
category_desc	category_desc_id	es	7.5R 5/6 - red	\N
category_desc	category_desc_id	es	Anthraquic Cambisol	\N
category_desc	category_desc_id	es	Brunic Kastanozem	\N
category_desc	category_desc_id	es	5YR 4/2 - dark reddish grey	\N
category_desc	category_desc_id	es	Abruptic	\N
category_desc	category_desc_id	es	5YR 3/3 - dark reddish brown	\N
category_desc	category_desc_id	es	PO - Pollution	\N
category_desc	category_desc_id	es	Alfisols	\N
category_desc	category_desc_id	es	R - Rounded (spherical)	\N
category_desc	category_desc_id	es	Dcs - Subarctic climate - dry season in summer	\N
category_desc	category_desc_id	es	Lixic Gypsisol	\N
category_desc	category_desc_id	es	Saprolithic	\N
category_desc	category_desc_id	es	Chromic Lixisol	\N
category_desc	category_desc_id	es	BD5 - Very large pressure necessary to force knife into the soil, no further disintegration of sample - prismatic - > 1.8	\N
category_desc	category_desc_id	es	Saprists	\N
property_desc	property_pretty_name	es	Consistence Moist	\N
property_desc	property_pretty_name	es	Current Weather Conditions	\N
category_desc	category_desc_id	es	Thionic Stagnosol	\N
category_desc	category_desc_id	es	Gypsiric Fluvisol	\N
category_desc	category_desc_id	es	Vertic Planosol	\N
category_desc	category_desc_id	es	sandstone, greywacke, arkose	\N
category_desc	category_desc_id	es	Cryosol (CR)	\N
category_desc	category_desc_id	es	Dolomitic Planosol	\N
category_desc	category_desc_id	es	Cf - Mild temperate rainy climate - no distinct dry season	\N
category_desc	category_desc_id	es	LA - Lamellae (clay bands)	\N
category_desc	category_desc_id	es	Yermic Cambisol	\N
category_desc	category_desc_id	es	X - Complex (irregular)	\N
category_desc	category_desc_id	es	Glossic Umbrisol	\N
category_desc	category_desc_id	es	Gypsiric Arenosol	\N
category_desc	category_desc_id	es	7.5R 5/8 - red	\N
category_desc	category_desc_id	es	Histic Retisol	\N
category_desc	category_desc_id	es	7.5R 2.5/0 - black	\N
category_desc	category_desc_id	es	10Y 7/8	\N
category_desc	category_desc_id	es	Gleyic Podzol	\N
category_desc	category_desc_id	es	5BG 6/1 - greenish grey	\N
category_desc	category_desc_id	es	10YR 5/3 - brown	\N
category_desc	category_desc_id	es	Terric Kastanozem	\N
category_desc	category_desc_id	es	5Y 6/4 - pale olive	\N
category_desc	category_desc_id	es	Ferr	\N
category_desc	category_desc_id	es	Folic	\N
category_desc	category_desc_id	es	5.6 - 6.0: Moderately acidic	\N
category_desc	category_desc_id	es	10YR 6/2 - light brownish grey	\N
category_desc	category_desc_id	es	Kan, Kandic	\N
category_desc	category_desc_id	es	SC - Surface compaction	\N
category_desc	category_desc_id	es	Folists	\N
category_desc	category_desc_id	es	Tephric Fluvisol	\N
category_desc	category_desc_id	es	SC2 - Clastic sediments: sandstone, greywacke, arkose	\N
category_desc	category_desc_id	es	Dsb - Snow climates - dry summer, warm	\N
category_desc	category_desc_id	es	A - Abundant (> 40 %)	\N
category_desc	category_desc_id	es	7.5R 4/4 - weak red	\N
category_desc	category_desc_id	es	PV - Vertical pedfaces	\N
category_desc	category_desc_id	es	Cs - Temperate rainy (humid mesothermal) climate with dry summer	\N
category_desc	category_desc_id	es	W - Wavy - Pockets less deep than wide	\N
category_desc	category_desc_id	es	Blue-green to grey colour; Fe2+ ions always present	\N
category_desc	category_desc_id	es	7.5GY 4/4	\N
category_desc	category_desc_id	es	0.11 - 0.17 g cm-3	\N
category_desc	category_desc_id	es	UK2 - Unconsolidated: kryogenic periglacial solifluction layer	\N
property_desc	property_pretty_name	es	USDA order	\N
category_desc	category_desc_id	es	7.5R 4/2 - weak red	\N
category_desc	category_desc_id	es	Eutric Durisol	\N
category_desc	category_desc_id	es	Glossic	\N
category_desc	category_desc_id	es	5YR 7/8 - reddish yellow	\N
category_desc	category_desc_id	es	silt and clay	\N
category_desc	category_desc_id	es	5YR 6/1 - (light) grey	\N
property_desc	property_pretty_name	es	Andic Characteristics	\N
category_desc	category_desc_id	es	Yermic Durisol	\N
category_desc	category_desc_id	es	Udepts	\N
category_desc	category_desc_id	es	schist	\N
category_desc	category_desc_id	es	DO = Dome-shaped	\N
category_desc	category_desc_id	es	BD3 - Knife can be pushed into the moist soil with weak pressure, sample disintegrates into few fragments, which may be further divided - subangular and angular blocky, prismatic, platy - 1.4-1.6	\N
category_desc	category_desc_id	es	GE - Gelundic	\N
category_desc	category_desc_id	es	Calcic	\N
category_desc	category_desc_id	es	S - Soft	\N
category_desc	category_desc_id	es	Grumic	\N
category_desc	category_desc_id	es	Luvic Gypsisol	\N
category_desc	category_desc_id	es	vYn - Very young (1-10 years) natural: with loss by erosion or deposition of materials such as on tidal flats, coastal dunes, river valleys, landslides, or desert areas.	\N
property_desc	property_pretty_name	es	mottlesPresenceProperty	\N
category_desc	category_desc_id	es	M - metamorphic rock	\N
category_desc	category_desc_id	es	NE - north-east	\N
category_desc	category_desc_id	es	SH - Medium-gradient hill (10 - 30 %)	\N
category_desc	category_desc_id	es	P - Ponded (run-on site)	\N
category_desc	category_desc_id	es	CS - Very coarse and coarse sand	\N
category_desc	category_desc_id	es	SS - straight-straight	\N
category_desc	category_desc_id	es	Leptic Planosol	\N
category_desc	category_desc_id	es	SG  - Stagnating	\N
category_desc	category_desc_id	es	Stagnic Podzol	\N
category_desc	category_desc_id	es	7.5YR 3/0 - very dark grey	\N
category_desc	category_desc_id	es	7.5R 6/6 - light red	\N
category_desc	category_desc_id	es	Terric Acrisol	\N
category_desc	category_desc_id	es	Luvic Phaeozem	\N
category_desc	category_desc_id	es	7.5R 6/0 - grey	\N
category_desc	category_desc_id	es	PuBe - Beans	\N
category_desc	category_desc_id	es	5Y 5/2 - olive grey	\N
category_desc	category_desc_id	es	Mollic Gleysol	\N
category_desc	category_desc_id	es	SL - Slightly calcareous (0-2%) - Audible effervescence but not visible.	\N
category_desc	category_desc_id	es	Anthraquic Lixisol	\N
property_desc	property_pretty_name	es	Forest Abundance	\N
property_desc	property_pretty_name	es	Carbonate Content	\N
category_desc	category_desc_id	es	Pretic Nitisol	\N
category_desc	category_desc_id	es	BWh - Desert climate Dry-hot	\N
category_desc	category_desc_id	es	2.5Y 8/0 - white	\N
category_desc	category_desc_id	es	Hyperartefactic	\N
category_desc	category_desc_id	es	Xerults	\N
category_desc	category_desc_id	es	7.5YR 8/6 - reddish yellow	\N
category_desc	category_desc_id	es	WR - Rill erosion	\N
property_phys_chem	property_phys_chem_id	es	Base saturation - calculated	\N
category_desc	category_desc_id	es	ENE - east-north-east	\N
property_desc	property_pretty_name	es	cationExchangeCapacityEffectiveProperty	\N
category_desc	category_desc_id	es	Cbw - Warm temperate (mesothermal) climates - dry winter	\N
category_desc	category_desc_id	es	SPL - Slightly plastic - Wire formable but breaks immediately if bent into a ring; soil mass deformed by very slight force.	\N
category_desc	category_desc_id	es	5YR 5/6 - yellowish red	\N
category_desc	category_desc_id	es	FrGr - Grapes, Wine, Raisins	\N
category_desc	category_desc_id	es	V - Very hard	\N
category_desc	category_desc_id	es	O - Older, pre-Tertiary land surfaces: commonly high plains, terraces, or peneplains, except incised valleys; frequent occurrence of palaeosoils.	\N
property_desc	property_pretty_name	es	oxalateExtractableOpticalDensityProperty	\N
category_desc	category_desc_id	es	Leptic Andosol	\N
category_desc	category_desc_id	es	TH - Thermic	\N
category_desc	category_desc_id	es	Abruptic Lixisol	\N
category_desc	category_desc_id	es	FE - Application of fertilizers	\N
category_desc	category_desc_id	es	Geric Ferralsol	\N
category_desc	category_desc_id	es	Haplic Plinthosol	\N
category_desc	category_desc_id	es	D5.2 - Sapric, degree of decomposition/humification is very strong	\N
category_desc	category_desc_id	es	Takyric Solonetz	\N
category_desc	category_desc_id	es	WC3 - No rain in the last 24 hours	\N
category_desc	category_desc_id	es	2.5Y 2/0 - black	\N
category_desc	category_desc_id	es	S - Strongly weathered: All but the most resistant minerals are weathered, strongly discoloured and altered throughout the fragments, which tend to disintegrate under only moderate pressure.	\N
category_desc	category_desc_id	es	Moist - Other: 0.3–0.6%	\N
category_desc	category_desc_id	es	A - Abundant (40-80%)	\N
category_desc	category_desc_id	es	VFS - Very fine sand	\N
category_desc	category_desc_id	es	G - "gazha" (clayey water-saturated layer with high gypsum content)	\N
property_desc	property_pretty_name	es	parentTextureUnconsolidatedProperty	\N
category_desc	category_desc_id	es	EV - Exploitation of natural vegetation	\N
category_desc	category_desc_id	es	Coarsic Podzol	\N
category_desc	category_desc_id	es	10Y 6/2 - olive grey	\N
category_desc	category_desc_id	es	E - Extreme - Substantial removal of deeper subsurface horizons (badlands). Original biotic functions fully destroyed	\N
property_desc	property_pretty_name	es	moistConsistencyProperty	\N
category_desc	category_desc_id	es	Umbric Andosol	\N
category_desc	category_desc_id	es	MC - Medium and coarse (> 2 mm)	\N
category_desc	category_desc_id	es	PM - Pseudomycelia (carbonate infillings in pores, resembling mycelia)	\N
category_desc	category_desc_id	es	basic igneous	\N
property_desc	property_pretty_name	es	Mottles Boundary	\N
category_desc	category_desc_id	es	MO - Moderate: Aggregates are observable in place and there is a distinct arrangement of natural surfaces of weakness. When disturbed, the soil material breaks into a mixture of many entire aggregates, some broken aggregates, and little material without aggregates faces. Aggregates surfaces generally show distinct differences with the aggregates interiors.	\N
category_desc	category_desc_id	es	Histic Podzol	\N
category_desc	category_desc_id	es	Udox	\N
category_desc	category_desc_id	es	Tidalic Histosol	\N
category_desc	category_desc_id	es	Fractic Calcisol	\N
category_desc	category_desc_id	es	Skeletic Durisol	\N
category_desc	category_desc_id	es	Stagnic Regosol	\N
category_desc	category_desc_id	es	E - Ice climates	\N
category_desc	category_desc_id	es	7.5YR 2/0 - black	\N
category_desc	category_desc_id	es	Pyric	\N
category_desc	category_desc_id	es	Fine	\N
category_desc	category_desc_id	es	A - Active at present	\N
category_desc	category_desc_id	es	Anthraquic Luvisol	\N
category_desc	category_desc_id	es	10YR 5/6 - yellowish brown	\N
category_desc	category_desc_id	es	5Y 8/8 - yellow	\N
category_desc	category_desc_id	es	Daf - Cool-humid continental climate with warm high-sun season - moist	\N
property_desc	property_pretty_name	es	Position	\N
category_desc	category_desc_id	es	Alic Durisol	\N
property_desc	property_pretty_name	es	Shrub Abundace	\N
category_desc	category_desc_id	es	7.5GY 7/8	\N
category_desc	category_desc_id	es	WA - Water and wind erosion	\N
category_desc	category_desc_id	es	SA - Sand coatings	\N
category_desc	category_desc_id	es	Luvisol (LV)	\N
property_desc	property_pretty_name	es	Tree Density	\N
category_desc	category_desc_id	es	Udults	\N
category_desc	category_desc_id	es	10YR 8/2 - white	\N
property_desc	property_pretty_name	es	poresAbundanceProperty	\N
category_desc	category_desc_id	es	Plinthic Gleysol	\N
category_desc	category_desc_id	es	eolian	\N
category_desc	category_desc_id	es	DU - Dump (not specified)	\N
category_desc	category_desc_id	es	Spodic	\N
category_desc	category_desc_id	es	7.5YR 7/4 - pink	\N
category_desc	category_desc_id	es	No redoximorphic characteristics at permanently high potentials	\N
category_desc	category_desc_id	es	7.5YR 2/4 - very dark brown	\N
property_phys_chem	property_phys_chem_id	es	Phosphorus (P) - retention	\N
category_desc	category_desc_id	es	SA - Scalped area	\N
category_desc	category_desc_id	es	Q - Silica	\N
category_desc	category_desc_id	es	UG2 - Unconsolidated: glacio-fluvial sand	\N
category_desc	category_desc_id	es	IS - Sprinkler irrigation	\N
category_desc	category_desc_id	es	Lixic Durisol	\N
category_desc	category_desc_id	es	V - Very few - Roots with diameters < 2 mm: 1-20, Roots with diameters > 2 mm: 1-2.	\N
category_desc	category_desc_id	es	ST - Strongly calcareous (10-25%) - Strong visible effervescence. Bubbles form a low foam.	\N
category_desc	category_desc_id	es	FS - Semi-deciduous forest	\N
property_desc	property_pretty_name	es	Pea Descomposition	\N
category_desc	category_desc_id	es	Alisol (AL)	\N
category_desc	category_desc_id	es	Naramic	\N
category_desc	category_desc_id	es	Acr	\N
category_desc	category_desc_id	es	10YR 8/6 - yellow	\N
category_desc	category_desc_id	es	Umbric Planosol	\N
category_desc	category_desc_id	es	SC - Sandy clay	\N
category_desc	category_desc_id	es	SD - Deciduous shrub	\N
property_desc	property_pretty_name	es	Cracks Depth	\N
category_desc	category_desc_id	es	SE1 - Evaporites: anhydrite, gypsum	\N
category_desc	category_desc_id	es	Stagnic Technosol	\N
category_desc	category_desc_id	es	M - Mixed farming	\N
category_desc	category_desc_id	es	7.5Y 5/0	\N
category_desc	category_desc_id	es	7.5YR 4/0 - dark grey	\N
category_desc	category_desc_id	es	Dry - LS, SL, L: 1.2–2%	\N
category_desc	category_desc_id	es	Moll	\N
category_desc	category_desc_id	es	Endic	\N
category_desc	category_desc_id	es	Cambic Umbrisol	\N
category_desc	category_desc_id	es	Bryic	\N
category_desc	category_desc_id	es	Steep	\N
category_desc	category_desc_id	es	Haplic Solonchak	\N
category_desc	category_desc_id	es	10Y 8/8	\N
category_desc	category_desc_id	es	IN - Intermediate part (talf)	\N
category_desc	category_desc_id	es	Vertic Solonetz	\N
category_desc	category_desc_id	es	S - Straight	\N
category_desc	category_desc_id	es	Neocambic	\N
category_desc	category_desc_id	es	Gully erosion	\N
category_desc	category_desc_id	es	Takyric Lixisol	\N
category_desc	category_desc_id	es	Moist - S: 0.3–0.6%	\N
category_desc	category_desc_id	es	10R 5/2 - weak red	\N
category_desc	category_desc_id	es	TE - High-gradient escarpment zone (> 30 %)	\N
category_desc	category_desc_id	es	Lixic Calcisol	\N
category_desc	category_desc_id	es	O - Other: Soil material crushes only under very strong pressure; cannot be crushed between thumb and forefinger.	\N
category_desc	category_desc_id	es	10YR 3/1 - very dark grey	\N
category_desc	category_desc_id	es	TE = Terraced	\N
category_desc	category_desc_id	es	1 - Low (2 - 15 %)	\N
category_desc	category_desc_id	es	BU - Bunding	\N
category_desc	category_desc_id	es	SL - Sandy loam	\N
category_desc	category_desc_id	es	10Y 7/1 - light grey	\N
category_desc	category_desc_id	es	Geric Nitisol	\N
category_desc	category_desc_id	es	VC - Very coarse (20-50 mm).	\N
property_desc	property_pretty_name	es	Cementation/compaction Nature	\N
property_desc	property_pretty_name	es	Effective soil depth	\N
category_desc	category_desc_id	es	Aqualfs	\N
category_desc	category_desc_id	es	Luvic Calcisol	\N
category_desc	category_desc_id	es	Lixic Phaeozem	\N
category_desc	category_desc_id	es	2.5YR 5/6 - red	\N
category_desc	category_desc_id	es	ME - Medium: Granular/platy: 2-5 mm,  Prismatic/columnar/wedgeshaped: 20-50 mm, Blocky/crumbly/lumpy/cloddy: 10-20 mm	\N
category_desc	category_desc_id	es	Csb - Temperate rainy (humid mesothermal) climate with dry summer With warm summer	\N
category_desc	category_desc_id	es	Leptic Gypsisol	\N
category_desc	category_desc_id	es	6 - 180-360 days	\N
category_desc	category_desc_id	es	Melan	\N
category_desc	category_desc_id	es	Gleyic Solonchak	\N
category_desc	category_desc_id	es	PF - Petroferric	\N
category_desc	category_desc_id	es	clay	\N
category_desc	category_desc_id	es	5G 4/1 - dark greenish grey	\N
category_desc	category_desc_id	es	Relocatic Arenosol	\N
category_desc	category_desc_id	es	Rhodic Cambisol	\N
category_desc	category_desc_id	es	HI2 - Dairying	\N
category_desc	category_desc_id	es	R - Rare (less than once in every 10 years)	\N
category_desc	category_desc_id	es	Folic Histosol	\N
category_desc	category_desc_id	es	Luvic Durisol	\N
category_desc	category_desc_id	es	ID - Drip irrigation	\N
property_desc	property_pretty_name	es	Consistence Wet	\N
category_desc	category_desc_id	es	5Y 5/4 - olive	\N
category_desc	category_desc_id	es	10YR 7/6 - yellow	\N
category_desc	category_desc_id	es	CeMi - Millet	\N
category_desc	category_desc_id	es	Petrocalcic Lixisol	\N
category_desc	category_desc_id	es	WD - Deciduous woodland	\N
property_desc	property_pretty_name	es	Gypsum Content	\N
category_desc	category_desc_id	es	HF - Forb	\N
category_desc	category_desc_id	es	Torrox	\N
category_desc	category_desc_id	es	2 - Shallow (25-50 cm)	\N
category_desc	category_desc_id	es	2.5Y 5/0 - grey	\N
category_desc	category_desc_id	es	Hortic Planosol	\N
category_desc	category_desc_id	es	Petrocalcic Phaeozem	\N
category_desc	category_desc_id	es	Hypereutric	\N
category_desc	category_desc_id	es	2.5YR 2.5/2 - very dusky red	\N
category_desc	category_desc_id	es	7.5Y 8/6	\N
category_desc	category_desc_id	es	Thionic Planosol	\N
category_desc	category_desc_id	es	Skeletic Regosol	\N
category_desc	category_desc_id	es	MU1 - Ultrabasic metamorphic: serpentinite, greenstone	\N
category_desc	category_desc_id	es	Abruptic Retisol	\N
category_desc	category_desc_id	es	5R 3/6 - dark red	\N
category_desc	category_desc_id	es	Acric Umbrisol	\N
category_desc	category_desc_id	es	Duric Kastanozem	\N
property_desc	property_pretty_name	es	soilDepthBedrockProperty	\N
category_desc	category_desc_id	es	Hemists	\N
category_desc	category_desc_id	es	AP - Angular blocky (parallelepiped)	\N
category_desc	category_desc_id	es	Yermic Arenosol	\N
category_desc	category_desc_id	es	Claric	\N
category_desc	category_desc_id	es	Magnesic	\N
category_desc	category_desc_id	es	Eutric Arenosol	\N
category_desc	category_desc_id	es	DU - Udic	\N
category_desc	category_desc_id	es	Dry - S: < 0.3%	\N
category_desc	category_desc_id	es	V - Very few (0-2 %)	\N
category_desc	category_desc_id	es	Uterquic	\N
category_desc	category_desc_id	es	S - Subrounded	\N
category_desc	category_desc_id	es	Fluvic Gleysol	\N
category_desc	category_desc_id	es	Yermic Leptosol	\N
category_desc	category_desc_id	es	Hemic Histosol	\N
category_desc	category_desc_id	es	05 - Gently sloping (2 - 5 %)	\N
category_desc	category_desc_id	es	Xanthic Ferralsol	\N
category_desc	category_desc_id	es	7.5GY 5/4	\N
category_desc	category_desc_id	es	Calcic Chernozem	\N
category_desc	category_desc_id	es	7.5YR 7/6 - reddish yellow	\N
category_desc	category_desc_id	es	UU5 - Unconsolidated: unspecified gravel, broken rock	\N
category_desc	category_desc_id	es	CS - Warm temperate rainy climate - summer dry	\N
category_desc	category_desc_id	es	Anthraquic Alisol	\N
property_desc	property_pretty_name	es	Mottles Size	\N
property_desc	property_pretty_name	es	Peat Bulk Density	\N
category_desc	category_desc_id	es	Rend	\N
category_desc	category_desc_id	es	Histic Leptosol	\N
category_desc	category_desc_id	es	OiOp - Oil-palm	\N
category_desc	category_desc_id	es	7.5GY 8/4	\N
category_desc	category_desc_id	es	Mollic Solonetz	\N
category_desc	category_desc_id	es	Anthric	\N
category_desc	category_desc_id	es	Cryic Technosol	\N
category_desc	category_desc_id	es	7 - Continuously	\N
category_desc	category_desc_id	es	Ustox	\N
category_desc	category_desc_id	es	RoPo - Potatoes	\N
category_desc	category_desc_id	es	Skeletic Leptosol	\N
category_desc	category_desc_id	es	Protoargic	\N
category_desc	category_desc_id	es	Panto	\N
category_desc	category_desc_id	es	S - Slow run-off	\N
category_desc	category_desc_id	es	Orthents	\N
category_desc	category_desc_id	es	2.5YR 2.5/0 - black	\N
category_desc	category_desc_id	es	Fibric Histosol	\N
category_desc	category_desc_id	es	3 - 15-30 days	\N
category_desc	category_desc_id	es	sand and gravel	\N
category_desc	category_desc_id	es	7.5Y 2.5/0	\N
category_desc	category_desc_id	es	N - Nodule: Discrete body without an internal organization	\N
category_desc	category_desc_id	es	UL1 - Unconsolidated: lacustrine sand	\N
category_desc	category_desc_id	es	RB - Reddish brown	\N
category_desc	category_desc_id	es	Per	\N
category_desc	category_desc_id	es	Ustalfs	\N
category_desc	category_desc_id	es	Mulmic Umbrisol	\N
category_desc	category_desc_id	es	Endogleyic	\N
category_desc	category_desc_id	es	Yermic Solonchak	\N
category_desc	category_desc_id	es	10YR 6/8 - brownish yellow	\N
category_desc	category_desc_id	es	10–25	\N
category_desc	category_desc_id	es	SO - Sodic	\N
category_desc	category_desc_id	es	EHA - Extremely hard: Extremely resistant to pressure; cannot be broken in the hand.	\N
category_desc	category_desc_id	es	White, after oxidation white: Complete loss of Fe compounds	\N
category_desc	category_desc_id	es	Dolomitic	\N
property_desc	property_pretty_name	es	soilClassificationFAOProperty	\N
category_desc	category_desc_id	es	Sideralic Nitisol	\N
category_desc	category_desc_id	es	Poly	\N
category_desc	category_desc_id	es	Fragic Luvisol	\N
category_desc	category_desc_id	es	LuCo - Coffee	\N
category_desc	category_desc_id	es	Skeletic Plinthosol	\N
category_desc	category_desc_id	es	Fulv	\N
category_desc	category_desc_id	es	CR - Crumbly	\N
category_desc	category_desc_id	es	Deep (100-150 cm)	\N
category_desc	category_desc_id	es	FrMe - Melons	\N
category_desc	category_desc_id	es	SV - straight-convex	\N
category_desc	category_desc_id	es	5 - Very deep (> 150 cm)	\N
category_desc	category_desc_id	es	Inceptisols	\N
category_desc	category_desc_id	es	Limonic	\N
category_desc	category_desc_id	es	Gently sloping	\N
category_desc	category_desc_id	es	Cutanic	\N
category_desc	category_desc_id	es	Glossic Retisol	\N
property_desc	property_pretty_name	es	Moisture	\N
category_desc	category_desc_id	es	Calcic Planosol	\N
category_desc	category_desc_id	es	Gleyic Chernozem	\N
property_desc	property_pretty_name	es	Mineral Concentrations Kind	\N
category_desc	category_desc_id	es	5YR 3/4 - dark reddish brown	\N
category_desc	category_desc_id	es	M - Many - The number of very fine pores (< 2 mm) per square decimetre is > 200, the number of medium and coarse pores (> 2 mm) per square decimetre is > 20.	\N
category_desc	category_desc_id	es	Tidalic Cryosol	\N
category_desc	category_desc_id	es	Haplic Lixisol	\N
category_desc	category_desc_id	es	Calcic Solonetz	\N
category_desc	category_desc_id	es	Sheet erosion	\N
category_desc	category_desc_id	es	7.5GY 6/8	\N
category_desc	category_desc_id	es	7.5Y 3/0	\N
category_desc	category_desc_id	es	UK1 -  Unconsolidated  kryogenic periglacial rock debris	\N
category_desc	category_desc_id	es	Abruptic Acrisol	\N
category_desc	category_desc_id	es	7.5YR 5/8 - strong brown	\N
category_desc	category_desc_id	es	7.5GY 7/2	\N
category_desc	category_desc_id	es	T - Tertiary land surfaces: commonly high plains, terraces, or peneplains, except incised valleys; frequent occurrence of palaeosoils.	\N
category_desc	category_desc_id	es	Sulf, Sulfic	\N
property_desc	property_pretty_name	es	Mineral Concentrations Colour	\N
category_desc	category_desc_id	es	Calcaric Regosol	\N
category_desc	category_desc_id	es	Rhodic Alisol	\N
category_desc	category_desc_id	es	MO - Moderately salty (2 - 4 dS m-1)	\N
category_desc	category_desc_id	es	5-20 m	\N
category_desc	category_desc_id	es	Cfa - Warm temperate - moist all seasons, hot summer	\N
category_desc	category_desc_id	es	Dry - Other: 1.2–2%	\N
category_desc	category_desc_id	es	PQ - Peraquic	\N
category_desc	category_desc_id	es	Ferritic Ferralsol	\N
category_desc	category_desc_id	es	Gibbsic Ferralsol	\N
category_desc	category_desc_id	es	Torr	\N
category_desc	category_desc_id	es	PL - Placic	\N
property_phys_chem	property_phys_chem_id	es	Boron (B) - extractable	\N
category_desc	category_desc_id	es	Ferralic	\N
category_desc	category_desc_id	es	V - Very fine (< 2 mm)	\N
category_desc	category_desc_id	es	Xerands	\N
category_desc	category_desc_id	es	L - Level land (< 10 %)	\N
category_desc	category_desc_id	es	Chernic Planosol	\N
property_desc	property_pretty_name	es	Flood Duration	\N
property_desc	property_pretty_name	es	textureLabClassProperty	\N
category_desc	category_desc_id	es	CeSo - Sorghum	\N
category_desc	category_desc_id	es	OiGr - Groundnuts	\N
category_desc	category_desc_id	es	C - Clear (0.5-2 mm)	\N
category_desc	category_desc_id	es	Sulfatic	\N
category_desc	category_desc_id	es	Retic Cryosol	\N
category_desc	category_desc_id	es	Rhodic	\N
property_desc	property_pretty_name	es	Mineral Concentrations Hardness	\N
category_desc	category_desc_id	es	Ca - Temperate rainy (humid mesothermal) climate	\N
category_desc	category_desc_id	es	BB - Bluish-black	\N
category_desc	category_desc_id	es	Haplic Umbrisol	\N
category_desc	category_desc_id	es	Technosol (TC)	\N
category_desc	category_desc_id	es	Petrocalcic Gypsisol	\N
property_phys_chem	property_phys_chem_id	es	Iron (Fe) - extractable	\N
category_desc	category_desc_id	es	L - Large boulders (> 600 mm)	\N
category_desc	category_desc_id	es	Albolls	\N
category_desc	category_desc_id	es	clay, silt and loam	\N
category_desc	category_desc_id	es	5Y 8/1 - white	\N
category_desc	category_desc_id	es	FVF - Firm to very firm:	\N
category_desc	category_desc_id	es	MI - Primary mineral fragments: mica	\N
category_desc	category_desc_id	es	Caw - Temperate rainy (humid mesothermal) climate - dry winter	\N
category_desc	category_desc_id	es	5R 4/6 - red	\N
category_desc	category_desc_id	es	Cfc - Warm temperate - moist all seasons,  with cool short summer	\N
category_desc	category_desc_id	es	Dry - S: 1.5–2%	\N
category_desc	category_desc_id	es	Ustolls	\N
category_desc	category_desc_id	es	Dry - S: 1–1.5%	\N
property_desc	property_pretty_name	es	Presence Of Water	\N
category_desc	category_desc_id	es	Petrocalcic Luvisol	\N
category_desc	category_desc_id	es	MC - Multicoloured	\N
category_desc	category_desc_id	es	5R 6/8 - light red	\N
category_desc	category_desc_id	es	Protospodic	\N
category_desc	category_desc_id	es	Fluvic Planosol	\N
category_desc	category_desc_id	es	Cryids	\N
category_desc	category_desc_id	es	K - Carbonates	\N
category_desc	category_desc_id	es	Fragic Umbrisol	\N
category_desc	category_desc_id	es	SE - south-east	\N
category_desc	category_desc_id	es	Ccf - Warm temperate (mesothermal) climates - moist	\N
category_desc	category_desc_id	es	Haplic Gypsisol	\N
category_desc	category_desc_id	es	Aquerts	\N
category_desc	category_desc_id	es	metamorphic limestone (marble)	\N
category_desc	category_desc_id	es	Skeletic Cryosol	\N
category_desc	category_desc_id	es	Chromic	\N
category_desc	category_desc_id	es	Coarsic Technosol	\N
property_desc	property_pretty_name	es	Mottles Colour	\N
category_desc	category_desc_id	es	Thionic Gleysol	\N
category_desc	category_desc_id	es	Protogypsic	\N
category_desc	category_desc_id	es	Stagnic Lixisol	\N
category_desc	category_desc_id	es	5Y 4/3 - olive	\N
category_desc	category_desc_id	es	Cryalfs	\N
category_desc	category_desc_id	es	DE - Evergreen dwarf shrub	\N
category_desc	category_desc_id	es	MB6 - Basic metamorphic: eclogite	\N
category_desc	category_desc_id	es	Endocalcaric Umbrisol	\N
category_desc	category_desc_id	es	Ferralic Lixisol	\N
category_desc	category_desc_id	es	LV - Valley floor (< 10 %)	\N
category_desc	category_desc_id	es	5Y 6/1 - (light) grey	\N
category_desc	category_desc_id	es	FE - Evergreen broad-leaved forest	\N
category_desc	category_desc_id	es	Lixic Planosol	\N
category_desc	category_desc_id	es	OG - Organic garbage	\N
category_desc	category_desc_id	es	CV - Coarse and very coarse	\N
category_desc	category_desc_id	es	Gypsic Vertisol	\N
category_desc	category_desc_id	es	Very fine	\N
property_phys_chem	property_phys_chem_id	es	solubleSaltsProperty	\N
category_desc	category_desc_id	es	5R 2.5/4 - very dusky red	\N
category_desc	category_desc_id	es	Pretic Anthrosol	\N
category_desc	category_desc_id	es	JA - Jarosite	\N
category_desc	category_desc_id	es	Lithic	\N
property_desc	property_pretty_name	es	Fragments Size	\N
category_desc	category_desc_id	es	10Y 5/1 - grey	\N
category_desc	category_desc_id	es	A - Annually	\N
category_desc	category_desc_id	es	Mollic Nitisol	\N
category_desc	category_desc_id	es	lacustrine	\N
category_desc	category_desc_id	es	> 50	\N
category_desc	category_desc_id	es	Eutric Regosol	\N
property_phys_chem	property_phys_chem_id	es	Carbon (C) - total	\N
category_desc	category_desc_id	es	IN - Inselberg covered (occupying > 1% of level land)	\N
category_desc	category_desc_id	es	Arenicolic	\N
category_desc	category_desc_id	es	2.5YR 6/6 - light red	\N
property_desc	property_pretty_name	es	Salt Thickness	\N
category_desc	category_desc_id	es	Calcaric Planosol	\N
category_desc	category_desc_id	es	7.5GY 6/4	\N
category_desc	category_desc_id	es	7.9 - 8.4: Moderately alkaline	\N
category_desc	category_desc_id	es	Cumulic	\N
category_desc	category_desc_id	es	N 7/ - light grey	\N
category_desc	category_desc_id	es	5Y 6/8 - olive yellow	\N
category_desc	category_desc_id	es	Dbf - Cool-humid continental  with cool high-sun season - moist	\N
category_desc	category_desc_id	es	C - Clear (2-5 cm)	\N
category_desc	category_desc_id	es	V - Very widely spaced (> 5 m)	\N
category_desc	category_desc_id	es	SST - Slightly sticky - After pressure, soil material adheres to both thumb and finger but comes off one or the other rather cleanly. It is not appreciably stretched when the digits are separated.	\N
category_desc	category_desc_id	es	V - Very poorly drained - Water is removed so slowly that the soils are wet at shallow depth for long periods. The soils have a very shallow water table	\N
property_phys_chem	property_phys_chem_id	es	Phosphorus (P) - extractable	\N
category_desc	category_desc_id	es	10R 5/4 - weak red	\N
category_desc	category_desc_id	es	10 - Very steep (> 60 %)	\N
category_desc	category_desc_id	es	10YR 5/1 - grey	\N
category_desc	category_desc_id	es	Stagnic Phaeozem	\N
category_desc	category_desc_id	es	lPi - Late Pleistocene, ice-covered: commonly recent soil formation on fresh materials.	\N
category_desc	category_desc_id	es	Plagg	\N
category_desc	category_desc_id	es	WC2 - No rain in the last week	\N
category_desc	category_desc_id	es	SC5 - Clastic sediments: ironstone	\N
category_desc	category_desc_id	es	7.5R 6/2 - pale red	\N
category_desc	category_desc_id	es	07 - Strongly sloping (10 - 15 %)	\N
category_desc	category_desc_id	es	E - Elongated	\N
category_desc	category_desc_id	es	shale	\N
category_desc	category_desc_id	es	5Y 7/2 - light grey	\N
category_desc	category_desc_id	es	P - Pedfaces	\N
category_desc	category_desc_id	es	Ustepts	\N
category_desc	category_desc_id	es	Greyzemic Chernozem	\N
category_desc	category_desc_id	es	U - sedimentary rock (unconsolidated)	\N
category_desc	category_desc_id	es	Anthr	\N
category_desc	category_desc_id	es	Csc - Warm Temperate - dry summer, cool short summer	\N
category_desc	category_desc_id	es	Hortic Chernozem	\N
category_desc	category_desc_id	es	Reductic Planosol	\N
category_desc	category_desc_id	es	OiRa - Rape	\N
category_desc	category_desc_id	es	Spolic Technosol	\N
category_desc	category_desc_id	es	Udalfs	\N
category_desc	category_desc_id	es	SX - Xeromorphic shrub	\N
category_desc	category_desc_id	es	Das - Cool-humid continental climate with warm high-sun season - dry season in summer	\N
category_desc	category_desc_id	es	Oxyaquic Gleysol	\N
property_desc	property_pretty_name	es	Boundary Topography	\N
category_desc	category_desc_id	es	Plaggic Anthrosol	\N
category_desc	category_desc_id	es	BD1 - Many pores, moist materials drop easily out of the auger; materials with vesicular pores, mineral soils with andic properties - granular - < 0.9	\N
category_desc	category_desc_id	es	Leptic Acrisol	\N
property_desc	property_pretty_name	es	Moisture Regime	\N
category_desc	category_desc_id	es	5YR 6/6 - reddish yellow	\N
category_desc	category_desc_id	es	Abundant	\N
category_desc	category_desc_id	es	Dystric Nitisol	\N
category_desc	category_desc_id	es	2.5YR 4/4 - reddish brown	\N
category_desc	category_desc_id	es	FF - Submerged by remote flowing inland water at least once a year	\N
category_desc	category_desc_id	es	5R 6/4 - pale red	\N
category_desc	category_desc_id	es	Rhodic Nitisol	\N
category_desc	category_desc_id	es	Histosols	\N
property_desc	property_pretty_name	es	Bleached Sand Cover	\N
category_desc	category_desc_id	es	Ddf - Subarctic with very cold low-sun season - moist	\N
category_desc	category_desc_id	es	Leptic Podzol	\N
category_desc	category_desc_id	es	C - Concretion: A discrete body with a concentric internal structure, generally cemented	\N
category_desc	category_desc_id	es	10R 3/3 - dusky red	\N
category_desc	category_desc_id	es	Subaquatic Technosol	\N
category_desc	category_desc_id	es	AA6 - Irrigated cultivation	\N
category_desc	category_desc_id	es	ST - Strongly gypsiric (15-60%) - Higher amounts may be differentiated by abundance of H2O-soluble pseudomycelia/crystals and soil colour.	\N
property_desc	property_pretty_name	es	Gypsum Forms	\N
category_desc	category_desc_id	es	MA - Massive	\N
category_desc	category_desc_id	es	Amphi	\N
category_desc	category_desc_id	es	Anthraquic Planosol	\N
category_desc	category_desc_id	es	Plinth, Plinthic	\N
category_desc	category_desc_id	es	Nitric	\N
category_desc	category_desc_id	es	E - Extremely wide (> 10 cm)	\N
category_desc	category_desc_id	es	Nudiargic Alisol	\N
category_desc	category_desc_id	es	Ano	\N
category_desc	category_desc_id	es	Vitr	\N
category_desc	category_desc_id	es	Gelistagnic	\N
category_desc	category_desc_id	es	Pretic Ferralsol	\N
category_desc	category_desc_id	es	2.5YR 5/0 - grey	\N
property_desc	property_pretty_name	es	Major LandForm	\N
category_desc	category_desc_id	es	Dry - Other: 6–9%	\N
category_desc	category_desc_id	es	SiC - Silty clay	\N
category_desc	category_desc_id	es	Stagnic Umbrisol	\N
category_desc	category_desc_id	es	M - Medium gravel (6 - 20 mm)	\N
category_desc	category_desc_id	es	M - Medium gravel (0.6 - 2 cm)	\N
category_desc	category_desc_id	es	VO - Voids	\N
category_desc	category_desc_id	es	Terric Retisol	\N
category_desc	category_desc_id	es	MS - Moderate to strong	\N
category_desc	category_desc_id	es	HT - Tall grassland	\N
category_desc	category_desc_id	es	Hortic Stagnosol	\N
category_desc	category_desc_id	es	20 - 30 %	\N
category_desc	category_desc_id	es	A - Tropical (rainy) climates	\N
category_desc	category_desc_id	es	Ochric	\N
property_desc	property_pretty_name	es	Colour Dry	\N
category_desc	category_desc_id	es	ST - Silt coatings	\N
category_desc	category_desc_id	es	Dolomitic Stagnosol	\N
category_desc	category_desc_id	es	Da - Cool-humid continental climate with warm high-sun season	\N
category_desc	category_desc_id	es	S - Slight - Some evidence of damage to surface horizons. Original biotic functions largely intact	\N
category_desc	category_desc_id	es	Moist - LS, SL, L: 1–2%	\N
property_desc	property_pretty_name	es	Moisture Conditions	\N
property_desc	property_pretty_name	es	Biological Kind	\N
property_desc	property_pretty_name	es	Biological Abundance	\N
category_desc	category_desc_id	es	10Y 4/1 - grey	\N
property_phys_chem	property_phys_chem_id	es	pHProperty	\N
category_desc	category_desc_id	es	Vertic Chernozem	\N
category_desc	category_desc_id	es	Takyric Regosol	\N
category_desc	category_desc_id	es	LO - Loose: Non-coherent.	\N
category_desc	category_desc_id	es	Calcaric Stagnosol	\N
category_desc	category_desc_id	es	Ds - Cold snow-forest climate - summer dry	\N
category_desc	category_desc_id	es	Turbic Cryosol	\N
category_desc	category_desc_id	es	FrMa - Mangoes	\N
category_desc	category_desc_id	es	Dolomitic Phaeozem	\N
category_desc	category_desc_id	es	Retic	\N
category_desc	category_desc_id	es	2.5YR 5/2 - weak red	\N
category_desc	category_desc_id	es	AA4U - Unspecified rainfed arable cultivation	\N
category_desc	category_desc_id	es	5R 4/8 - red	\N
property_desc	property_pretty_name	es	Coatings Contrast	\N
category_desc	category_desc_id	es	7.5GY 3/0	\N
category_desc	category_desc_id	es	Leptic Kastanozem	\N
category_desc	category_desc_id	es	Xerepts	\N
category_desc	category_desc_id	es	Hydragric Vertisol	\N
category_desc	category_desc_id	es	Andic Cryosol	\N
property_phys_chem	property_phys_chem_id	es	Sodium (Na) - extractable	\N
category_desc	category_desc_id	es	Dolomitic Leptosol	\N
category_desc	category_desc_id	es	Very shallow (< 30 cm)	\N
category_desc	category_desc_id	es	VC - convex-concave	\N
category_desc	category_desc_id	es	None	\N
category_desc	category_desc_id	es	VC - Very coarse / thick: Granular/platy: > 10 mm,  Prismatic/columnar/wedgeshaped: 100-500 mm, Blocky/crumbly/lumpy/cloddy: > 50 mm	\N
property_desc	property_pretty_name	es	WRB Soil Name	\N
category_desc	category_desc_id	es	Reductic	\N
category_desc	category_desc_id	es	S - Shrub	\N
property_desc	property_pretty_name	es	parentLithologyProperty	\N
category_desc	category_desc_id	es	Endothyric	\N
category_desc	category_desc_id	es	Coarsic Gypsisol	\N
category_desc	category_desc_id	es	Luvic Chernozem	\N
category_desc	category_desc_id	es	Argids	\N
category_desc	category_desc_id	es	Glac, Glacic	\N
category_desc	category_desc_id	es	Black colour due to metal sulphides, flammable methane present	\N
category_desc	category_desc_id	es	CL - Clay loam	\N
category_desc	category_desc_id	es	Mollisols	\N
category_desc	category_desc_id	es	D2 - Fibric, degree of decomposition/humification is low	\N
category_desc	category_desc_id	es	M - Rainwater-fed moor peat	\N
category_desc	category_desc_id	es	Fluvic	\N
category_desc	category_desc_id	es	CC - concave-concave	\N
category_desc	category_desc_id	es	2.5YR 2.5/4 - dark reddish brown	\N
property_phys_chem	property_phys_chem_id	es	Manganese (Mn) - total	\N
category_desc	category_desc_id	es	GR - Grey	\N
category_desc	category_desc_id	es	Dry - Other: 4–6%	\N
category_desc	category_desc_id	es	Acrisol (AC)	\N
category_desc	category_desc_id	es	Alic Stagnosol	\N
category_desc	category_desc_id	es	unspecified deposits	\N
category_desc	category_desc_id	es	Thionic Histosol	\N
property_phys_chem	property_phys_chem_id	es	Hydrogen (H+) - exchangeable	\N
category_desc	category_desc_id	es	LVFS - Loamy very fine sand	\N
category_desc	category_desc_id	es	Dystric Stagnosol	\N
category_desc	category_desc_id	es	ultrabasic metamorphic	\N
category_desc	category_desc_id	es	7.5GY 6/0	\N
property_phys_chem	property_phys_chem_id	es	Magnesium (Mg) - extractable	\N
category_desc	category_desc_id	es	dolerite	\N
category_desc	category_desc_id	es	1.1 - Reference profile description - without sampling: No essential elements or details are missing from the description, sampling or analysis. The accuracy and reliability of the description and analytical results permit the full characterization of all soil horizons to a depth of 125 cm, or more if required for classification, or down to a C or R horizon or layer, which may be shallower. Soil description is done without sampling.	\N
category_desc	category_desc_id	es	5YR 6/3 - light reddish brown	\N
category_desc	category_desc_id	es	FoLe - Leguminous	\N
category_desc	category_desc_id	es	CeRi - Rice, dry	\N
category_desc	category_desc_id	es	VS - Vegetation slightly disturbed	\N
category_desc	category_desc_id	es	Subaquatic Gleysol	\N
category_desc	category_desc_id	es	Mulmic	\N
category_desc	category_desc_id	es	F - Fine (2-6 mm)	\N
category_desc	category_desc_id	es	5BG 5/1 - greenish grey	\N
category_desc	category_desc_id	es	Gypsic Solonetz	\N
category_desc	category_desc_id	es	0 - 10 %	\N
category_desc	category_desc_id	es	7.5YR 7/8 - reddish yellow	\N
category_desc	category_desc_id	es	D1 - Fibric, degree of decomposition/humification is very low	\N
category_desc	category_desc_id	es	7.5GY 5/2	\N
category_desc	category_desc_id	es	Verm	\N
category_desc	category_desc_id	es	10YR 8/1 - white	\N
category_desc	category_desc_id	es	2.5Y 8/6 - yellow	\N
category_desc	category_desc_id	es	Endocalcaric Retisol	\N
category_desc	category_desc_id	es	Cwa - Warm temperate - dry winter, hot summer	\N
category_desc	category_desc_id	es	evaporites	\N
category_desc	category_desc_id	es	Coarsic Histosol	\N
category_desc	category_desc_id	es	CH - Primary mineral fragments: quartz	\N
category_desc	category_desc_id	es	Vitric	\N
category_desc	category_desc_id	es	NPL - Non-plastic - No wire is formable.	\N
category_desc	category_desc_id	es	Alb	\N
category_desc	category_desc_id	es	2.5Y 4/2 - dark greyish brown	\N
category_desc	category_desc_id	es	2.5YR 4/0 - dark grey	\N
category_desc	category_desc_id	es	Protocalcic	\N
category_desc	category_desc_id	es	Durids	\N
category_desc	category_desc_id	es	AW - Angular blocky (wedge-shaped)	\N
category_desc	category_desc_id	es	Nearly level	\N
category_desc	category_desc_id	es	UP - Upper slope (shoulder)	\N
category_desc	category_desc_id	es	Salids	\N
property_phys_chem	property_phys_chem_id	es	zincProperty	\N
category_desc	category_desc_id	es	Gypsiric Leptosol	\N
category_desc	category_desc_id	es	Coarsic Plinthosol	\N
category_desc	category_desc_id	es	O - Other	\N
category_desc	category_desc_id	es	7.5Y 8/10	\N
category_desc	category_desc_id	es	Takyric Luvisol	\N
property_desc	property_pretty_name	es	Surface Age	\N
category_desc	category_desc_id	es	Undrained	\N
category_desc	category_desc_id	es	Stagnic Solonchak	\N
category_desc	category_desc_id	es	03 - Nearly level (0.5 - 1.0 %)	\N
category_desc	category_desc_id	es	5YR 5/8 - yellowish red	\N
category_desc	category_desc_id	es	AA1 - Shifting cultivation	\N
property_phys_chem	property_phys_chem_id	es	hydraulicConductivityProperty	\N
category_desc	category_desc_id	es	Aeolic Regosol	\N
category_desc	category_desc_id	es	Dry - Other: 9–15%	\N
category_desc	category_desc_id	es	F - Flat	\N
category_desc	category_desc_id	es	CS - Coarse gravel and stones	\N
category_desc	category_desc_id	es	Vertic Stagnosol	\N
category_desc	category_desc_id	es	Protovertic	\N
category_desc	category_desc_id	es	7.5GY 5/0	\N
category_desc	category_desc_id	es	Irragric	\N
category_desc	category_desc_id	es	7.5YR 5/6 - strong brown	\N
category_desc	category_desc_id	es	Dystric Gleysol	\N
category_desc	category_desc_id	es	Gibbsic Plinthosol	\N
category_desc	category_desc_id	es	Mazic	\N
category_desc	category_desc_id	es	Rhodic Luvisol	\N
category_desc	category_desc_id	es	SI - Industrial use	\N
category_desc	category_desc_id	es	Arents	\N
category_desc	category_desc_id	es	Mollic Plinthosol	\N
category_desc	category_desc_id	es	2.5YR 3/4 - dark reddish brown	\N
category_desc	category_desc_id	es	Histic Cambisol	\N
category_desc	category_desc_id	es	Dry - Other: 3–4%	\N
category_desc	category_desc_id	es	Skeletic Luvisol	\N
category_desc	category_desc_id	es	Drainic	\N
property_desc	property_pretty_name	es	Slope Orientation	\N
category_desc	category_desc_id	es	N - None (0%)	\N
category_desc	category_desc_id	es	OtPa - Palm (fibres, kernels)	\N
category_desc	category_desc_id	es	Protic Cryosol	\N
category_desc	category_desc_id	es	Db - Cool-humid continental  with cool high-sun season	\N
category_desc	category_desc_id	es	Dds - Subarctic with very cold low-sun season - dry season in summer	\N
category_desc	category_desc_id	es	SiCL - Silty clay loam	\N
category_desc	category_desc_id	es	FM - Iron-manganese (sesquioxides)	\N
category_desc	category_desc_id	es	Ferritic	\N
category_desc	category_desc_id	es	ignimbrite	\N
category_desc	category_desc_id	es	C - Continuous: Surface of coating shows only little contrast in colour, smoothness or any other property to the adjacent surface. Fine sand grains are readily apparent in the cutan. Lamellae are less than 2 mm thick.	\N
category_desc	category_desc_id	es	10Y 8/1 - light grey	\N
category_desc	category_desc_id	es	Gleyic Technosol	\N
category_desc	category_desc_id	es	F - Fresh or slightly weathered: Fragments show little or no signs of weathering.	\N
category_desc	category_desc_id	es	lPf - Late Pleistocene, without periglacial influence.	\N
category_desc	category_desc_id	es	10R 6/6 - light red	\N
property_desc	property_pretty_name	es	Vegetation	\N
category_desc	category_desc_id	es	Dbs - Cool-humid continental  with cool high-sun season - dry season in summer	\N
category_desc	category_desc_id	es	Leptic Plinthosol	\N
category_desc	category_desc_id	es	Skeletic Cambisol	\N
category_desc	category_desc_id	es	D - Dry: Crushing: makes no dust. Forming (to a ball): not possible, seems to be warm. Moistening: going dark. Rubbing (in the hand): hardly lighter. pF: 4.	\N
category_desc	category_desc_id	es	YE - Yellow	\N
category_desc	category_desc_id	es	Cambisol (CM)	\N
category_desc	category_desc_id	es	Eutric Gleysol	\N
category_desc	category_desc_id	es	Moist - Other: 0.9–1.5%	\N
category_desc	category_desc_id	es	Glacic Cryosol	\N
category_desc	category_desc_id	es	D - Deep (10 - 20 cm)	\N
category_desc	category_desc_id	es	AP2 - Irrigated cultivation	\N
category_desc	category_desc_id	es	AZ - Salt deposition	\N
category_desc	category_desc_id	es	MN - Manganese	\N
property_phys_chem	property_phys_chem_id	es	Copper (Cu) - extractable	\N
category_desc	category_desc_id	es	7.5GY 8/6	\N
category_desc	category_desc_id	es	Terric Stagnosol	\N
property_phys_chem	property_phys_chem_id	es	molybdenumProperty	\N
category_desc	category_desc_id	es	Dolomitic Cambisol	\N
category_desc	category_desc_id	es	10YR 8/4 - very pale brown	\N
category_desc	category_desc_id	es	5B 7/1 - light bluish grey	\N
category_desc	category_desc_id	es	SSW - south-south-west	\N
property_desc	property_pretty_name	es	soilDepthRootableProperty	\N
property_desc	property_pretty_name	es	Porosity Type	\N
category_desc	category_desc_id	es	D - Daily	\N
category_desc	category_desc_id	es	7.5YR 7/2 - pinkish grey	\N
category_desc	category_desc_id	es	Cambic Leptosol	\N
category_desc	category_desc_id	es	Geric	\N
property_desc	property_pretty_name	es	Structure Type	\N
category_desc	category_desc_id	es	Entic Podzol	\N
category_desc	category_desc_id	es	GB - Gibbsite	\N
category_desc	category_desc_id	es	pyroclastic	\N
category_desc	category_desc_id	es	UA1 - Unconsolidated: Anthropogenic/ technogenic redeposited natural material	\N
category_desc	category_desc_id	es	SO1 - Sedimentary organic: limestone, other carbonate rocks	\N
category_desc	category_desc_id	es	5Y 8/2 - white	\N
category_desc	category_desc_id	es	Yermic Gypsisol	\N
property_desc	property_pretty_name	es	soilDepthProperty	\N
category_desc	category_desc_id	es	Greyzemic Umbrisol	\N
category_desc	category_desc_id	es	Andic Podzol	\N
category_desc	category_desc_id	es	FF - Fine and very fine (< 2 mm).	\N
category_desc	category_desc_id	es	S - Sulphur (sulphurous)	\N
category_desc	category_desc_id	es	Luvic Planosol	\N
category_desc	category_desc_id	es	Mollic Solonchak	\N
category_desc	category_desc_id	es	Solimovic Regosol	\N
category_desc	category_desc_id	es	Hist	\N
category_desc	category_desc_id	es	OV - Overcast	\N
category_desc	category_desc_id	es	7.5YR 3/2 - dark brown	\N
category_desc	category_desc_id	es	tuff, tuffite	\N
category_desc	category_desc_id	es	MA3 - Acid metamorphic: slate, phyllite, (pellitic rocks)	\N
category_desc	category_desc_id	es	T - Crystal	\N
category_desc	category_desc_id	es	C - Common (5-15%)	\N
property_phys_chem	property_phys_chem_id	es	Magnesium (Mg++) - exchangeable	\N
category_desc	category_desc_id	es	0	\N
category_desc	category_desc_id	es	U - Mull: characterized by the periodic absence of organic matter accumulation on the surface owing to the rapid decomposition process and mixing of organic matter and the mineral soil material by bioturbation. It is usually slightly acid to neutral with a C/N ratio of 10-18.	\N
category_desc	category_desc_id	es	Gypsic Gleysol	\N
category_desc	category_desc_id	es	7.5Y 8/0	\N
category_desc	category_desc_id	es	UF2 - Unconsolidated: fluvial clay, silt and loam	\N
category_desc	category_desc_id	es	colluvial	\N
category_desc	category_desc_id	es	Dry - LS, SL, L: > 15%	\N
category_desc	category_desc_id	es	IM - Isomesic	\N
category_desc	category_desc_id	es	FSL - Fine sandy loam	\N
category_desc	category_desc_id	es	E - Earthworm channels	\N
category_desc	category_desc_id	es	4 - Soil augering description: Soil augerings do no permit a comprehensive soil profile description. Augerings are made for routine soil observation and identification in soil mapping, and for that purpose normally provide a satisfactory indication of the soil characteristics. Soil samples may be collected from augerings.	\N
category_desc	category_desc_id	es	Toxic	\N
category_desc	category_desc_id	es	7.5Y 3/2 - olive black	\N
category_desc	category_desc_id	es	Fragic Retisol	\N
category_desc	category_desc_id	es	Takyric Fluvisol	\N
category_desc	category_desc_id	es	I - Irregular	\N
category_desc	category_desc_id	es	10YR 7/3 - very pale brown	\N
category_desc	category_desc_id	es	Q - Silica (siliceous)	\N
category_desc	category_desc_id	es	Sideralic Arenosol	\N
category_desc	category_desc_id	es	Cryolls	\N
category_desc	category_desc_id	es	10R 3/1 - dark reddish grey	\N
category_desc	category_desc_id	es	IF - Isofrigid	\N
category_desc	category_desc_id	es	Dolomitic Arenosol	\N
category_desc	category_desc_id	es	LL - Plateau (< 10 %)	\N
category_desc	category_desc_id	es	Petrocalcic Vertisol	\N
category_desc	category_desc_id	es	HC - Heavy clay	\N
category_desc	category_desc_id	es	Lixic	\N
category_desc	category_desc_id	es	10R 2.5/2 - very dusky red	\N
category_desc	category_desc_id	es	Thionic	\N
category_desc	category_desc_id	es	Mineralic	\N
category_desc	category_desc_id	es	IM - With intermontane plains (occupying > 15%)	\N
category_desc	category_desc_id	es	B - Burrows (unspecified)	\N
category_desc	category_desc_id	es	Dc - Subarctic climate	\N
category_desc	category_desc_id	es	H - Active in historical times	\N
category_desc	category_desc_id	es	Salic Cryosol	\N
category_desc	category_desc_id	es	PH - Horizontal pedfaces	\N
category_desc	category_desc_id	es	Cwc - Warm Temperate - dry winter, cool short summer	\N
category_desc	category_desc_id	es	Petroduric Andosol	\N
category_desc	category_desc_id	es	D - Dominant (> 80%)	\N
category_desc	category_desc_id	es	Someric Umbrisol	\N
property_desc	property_pretty_name	es	Field pH	\N
category_desc	category_desc_id	es	PR - Prismatic	\N
category_desc	category_desc_id	es	N 2.5/ - black	\N
category_desc	category_desc_id	es	Epi	\N
property_desc	property_pretty_name	es	Groundwater Quality	\N
category_desc	category_desc_id	es	Mawic Histosol	\N
category_desc	category_desc_id	es	Retic Stagnosol	\N
category_desc	category_desc_id	es	Andic	\N
category_desc	category_desc_id	es	Mollic Planosol	\N
category_desc	category_desc_id	es	7.5R 3/2 - dusky red	\N
category_desc	category_desc_id	es	7.5Y 4/2 - greyish olive	\N
category_desc	category_desc_id	es	Haplic Cryosol	\N
category_desc	category_desc_id	es	SE - Medium-gradient escarpment zone (10 - 30 %)	\N
category_desc	category_desc_id	es	Dominant	\N
category_desc	category_desc_id	es	Ferric	\N
category_desc	category_desc_id	es	TH - High-gradient hill (> 30 %)	\N
property_desc	property_pretty_name	es	Coatings Form	\N
category_desc	category_desc_id	es	Planes	\N
category_desc	category_desc_id	es	Sloping	\N
category_desc	category_desc_id	es	N - north	\N
category_desc	category_desc_id	es	Stagnic Luvisol	\N
category_desc	category_desc_id	es	SiL - Silt loam	\N
category_desc	category_desc_id	es	F - Iron	\N
category_desc	category_desc_id	es	5GY 4/1 - dark greenish grey	\N
property_desc	property_pretty_name	es	dryConsistencyProperty	\N
category_desc	category_desc_id	es	PL - Platy	\N
category_desc	category_desc_id	es	10R 5/6 - red	\N
category_desc	category_desc_id	es	BWn - Desert climate -frequent fog	\N
category_desc	category_desc_id	es	Leptic Histosol	\N
category_desc	category_desc_id	es	5R 5/8 - red	\N
category_desc	category_desc_id	es	5Y 7/3 - pale yellow	\N
category_desc	category_desc_id	es	7.4 - 7.8: Slightly alkaline	\N
category_desc	category_desc_id	es	60 - 70 %	\N
category_desc	category_desc_id	es	7.5YR 5/2 - brown	\N
category_desc	category_desc_id	es	Haplic Alisol	\N
category_desc	category_desc_id	es	FO - Iron-organic matter	\N
category_desc	category_desc_id	es	M - Moder (duff mull): more decomposed than raw humus but characterized by an organic matter layer on top of the mineral soil with a diffuse boundary between the organic matter layer and A horizon. In the sequence of Oi-Oe-Oa layers, it is difficult to separate one layer from another. This develops in moderately nutrient-poor conditions, usually under a cool moist climate. It is usually acidic with a C/N ratio of 18-29.	\N
category_desc	category_desc_id	es	Calcic Luvisol	\N
category_desc	category_desc_id	es	CR - Cryic	\N
property_desc	property_pretty_name	es	Aeromorphic Forest	\N
category_desc	category_desc_id	es	Glossic Podzol	\N
category_desc	category_desc_id	es	Histic Fluvisol	\N
category_desc	category_desc_id	es	Quartz	\N
category_desc	category_desc_id	es	Profondic	\N
property_phys_chem	property_phys_chem_id	es	Available water capacity - volumetric (FC to WP)	\N
category_desc	category_desc_id	es	Dystric Retisol	\N
property_desc	property_pretty_name	es	Rock Outcrops Cover	\N
category_desc	category_desc_id	es	Dfd - Snow climates - moist all seasons, very cold winter	\N
category_desc	category_desc_id	es	SC - Soft concretions	\N
category_desc	category_desc_id	es	Y - Very dry: Crushing: dusty or hard. Forming (to a ball): not possible, seems to be warm. Moistening: going very dark. Rubbing (in the hand): not lighter. pF: 5.	\N
category_desc	category_desc_id	es	Xanthic Lixisol	\N
category_desc	category_desc_id	es	Mahic	\N
category_desc	category_desc_id	es	Eutric	\N
category_desc	category_desc_id	es	Lu - Semi-luxury Foods and Tobacco	\N
category_desc	category_desc_id	es	5YR 8/2 - pinkish white	\N
category_desc	category_desc_id	es	5B 4/1 - dark bluish grey	\N
category_desc	category_desc_id	es	7.5R 4/8 - red	\N
category_desc	category_desc_id	es	C - Coarse gravel (20 - 60 mm)	\N
category_desc	category_desc_id	es	Haplic Ferralsol	\N
category_desc	category_desc_id	es	SPP - slightly plastic to plastic -	\N
category_desc	category_desc_id	es	acid igneous	\N
category_desc	category_desc_id	es	Fragi, Fragic	\N
category_desc	category_desc_id	es	Histic Cryosol	\N
category_desc	category_desc_id	es	Rill erosion	\N
category_desc	category_desc_id	es	Calcic Stagnosol	\N
category_desc	category_desc_id	es	SA - Salic	\N
category_desc	category_desc_id	es	Calcids	\N
category_desc	category_desc_id	es	Ccw - Warm temperate (mesothermal) climates - dry winter	\N
category_desc	category_desc_id	es	R - Rounded	\N
category_desc	category_desc_id	es	Dsd - Snow climates  -dry summer,  very cold winter	\N
category_desc	category_desc_id	es	Yermic Solonetz	\N
category_desc	category_desc_id	es	GY - Gypsum	\N
category_desc	category_desc_id	es	S - Slightly moist: Crushing: makes no dust. Forming (to a ball):  possible (not sand). Moistening: going slightly dark. Rubbing (in the hand): obviously lighter. pF: 3.	\N
category_desc	category_desc_id	es	Andic Technosol	\N
category_desc	category_desc_id	es	B - Both hard and soft	\N
category_desc	category_desc_id	es	Geoabruptic	\N
property_desc	property_pretty_name	es	Organic Matter Content	\N
property_desc	property_pretty_name	es	Cracks Width	\N
category_desc	category_desc_id	es	Chernic Stagnosol	\N
category_desc	category_desc_id	es	10YR 6/3 - pale brown	\N
category_desc	category_desc_id	es	Dwc - Snow climates - dry winter, cool short summer	\N
category_desc	category_desc_id	es	50 - 60 %	\N
category_desc	category_desc_id	es	peridotite	\N
category_desc	category_desc_id	es	Uderts	\N
category_desc	category_desc_id	es	Chernic	\N
category_desc	category_desc_id	es	D4 - Hemic, degree of decomposition/humification is strong	\N
category_desc	category_desc_id	es	C - Thick (5 - 20 mm)	\N
property_phys_chem	property_phys_chem_id	es	porosityProperty	\N
category_desc	category_desc_id	es	Fi - Fibre Crops	\N
category_desc	category_desc_id	es	Anthraquic Andosol	\N
category_desc	category_desc_id	es	Technic	\N
category_desc	category_desc_id	es	Tsitelic Cambisol	\N
category_desc	category_desc_id	es	Arenic	\N
category_desc	category_desc_id	es	PL - Plastic - Wire formable but breaks if bent into a ring; slight to moderate force required for deformation of the soil mass.	\N
category_desc	category_desc_id	es	Psamm	\N
category_desc	category_desc_id	es	7.5GY 7/6	\N
category_desc	category_desc_id	es	ME - Raised beds (engineering purposes)	\N
category_desc	category_desc_id	es	Columnic	\N
category_desc	category_desc_id	es	Dystric Fluvisol	\N
category_desc	category_desc_id	es	Stagnosol (ST)	\N
category_desc	category_desc_id	es	7.5R 2.5/2 - very dusky red	\N
category_desc	category_desc_id	es	Daw - Cool-humid continental climate with warm high-sun season - dry winter	\N
category_desc	category_desc_id	es	AS - Shifting sands	\N
category_desc	category_desc_id	es	5GY 5/1 - greenish grey	\N
category_desc	category_desc_id	es	LI - Lithic	\N
category_desc	category_desc_id	es	Aeolic	\N
category_desc	category_desc_id	es	LFS - Loamy fine sand	\N
category_desc	category_desc_id	es	5G 5/2 - greyish green	\N
category_desc	category_desc_id	es	MA4 - Acid metamorphic: schist	\N
property_desc	property_pretty_name	es	Consistence Dry	\N
category_desc	category_desc_id	es	2.5Y 8/4 - pale yellow	\N
category_desc	category_desc_id	es	MS - Medium sand	\N
property_desc	property_pretty_name	es	Slope Pathway	\N
category_desc	category_desc_id	es	SP - Dissected plain (10 - 30 %)	\N
property_desc	property_pretty_name	es	Boundary Distinctness	\N
category_desc	category_desc_id	es	10R 5/3 - weak red	\N
category_desc	category_desc_id	es	10YR 2/2 - very dark brown	\N
category_desc	category_desc_id	es	Irragric Luvisol	\N
category_desc	category_desc_id	es	Ar	\N
category_desc	category_desc_id	es	Terric Phaeozem	\N
category_desc	category_desc_id	es	Fibr	\N
category_desc	category_desc_id	es	LF - Landfill (also sanitary)	\N
category_desc	category_desc_id	es	Leptic Nitisol	\N
category_desc	category_desc_id	es	Tidalic Leptosol	\N
category_desc	category_desc_id	es	< 3.5: Ultra acidic	\N
category_desc	category_desc_id	es	Hn - Holocene (100-10,000 years) natural: with loss by erosion or deposition of materials such as on tidal flats, coastal dunes, river valleys, landslides, or desert areas.	\N
category_desc	category_desc_id	es	7.5R 6/4 - pale red	\N
category_desc	category_desc_id	es	SC - soft concretions	\N
category_desc	category_desc_id	es	Solonchak (SC)	\N
category_desc	category_desc_id	es	Cambic	\N
category_desc	category_desc_id	es	M - Moderately cemented: Cemented mass cannot be broken in the hands but is discontinuous (less than 90 percent of soil mass).	\N
property_phys_chem	property_phys_chem_id	es	bulkDensityFineEarthProperty	\N
category_desc	category_desc_id	es	Psamments	\N
category_desc	category_desc_id	es	7.5R 4/6 - red	\N
category_desc	category_desc_id	es	Dolomitic Regosol	\N
category_desc	category_desc_id	es	HI - Intensive grazing	\N
category_desc	category_desc_id	es	Irragric Anthrosol	\N
category_desc	category_desc_id	es	10YR 6/4 - light yellowish brown	\N
category_desc	category_desc_id	es	25–50	\N
category_desc	category_desc_id	es	HC - Hard concretions	\N
category_desc	category_desc_id	es	Petrogypsic Solonchak	\N
category_desc	category_desc_id	es	Endothionic	\N
category_desc	category_desc_id	es	Calcic Vertisol	\N
category_desc	category_desc_id	es	10Y 7/6	\N
category_desc	category_desc_id	es	volcanic ash	\N
category_desc	category_desc_id	es	CV - concave-convexstraight	\N
category_desc	category_desc_id	es	Thixotropic	\N
category_desc	category_desc_id	es	Xanthic	\N
category_desc	category_desc_id	es	2.5YR 3/6 - dark red	\N
category_desc	category_desc_id	es	Aeolic Andosol	\N
category_desc	category_desc_id	es	Kastanozem (KS)	\N
category_desc	category_desc_id	es	Hydragric Stagnosol	\N
category_desc	category_desc_id	es	A - Crop agriculture (cropping)	\N
category_desc	category_desc_id	es	AN - Artesanal natural material	\N
category_desc	category_desc_id	es	Gypsic Andosol	\N
category_desc	category_desc_id	es	Gelepts	\N
property_desc	property_pretty_name	es	Rock Outcrops Distance	\N
category_desc	category_desc_id	es	SV - Medium-gradient valley (10 - 30 %)	\N
category_desc	category_desc_id	es	VST - Very sticky - After pressure, soil material adheres strongly to both thumb and finger and is decidedly stretched when they are separated.	\N
category_desc	category_desc_id	es	Very deep (> 150 cm)	\N
property_desc	property_pretty_name	es	Pore Abundance	\N
category_desc	category_desc_id	es	Lixic Stagnosol	\N
category_desc	category_desc_id	es	Salic Solonetz	\N
category_desc	category_desc_id	es	Gleyic	\N
category_desc	category_desc_id	es	Subaquatic Leptosol	\N
category_desc	category_desc_id	es	Grossarenic	\N
category_desc	category_desc_id	es	Stagnic Retisol	\N
category_desc	category_desc_id	es	Gypsic Lixisol	\N
property_phys_chem	property_phys_chem_id	es	Acidity - exchangeable	\N
category_desc	category_desc_id	es	Fluvic Cambisol	\N
category_desc	category_desc_id	es	2.5Y 5/6 - light olive brown	\N
category_desc	category_desc_id	es	Lamellic	\N
category_desc	category_desc_id	es	HI - Higher part (rise)	\N
property_desc	property_pretty_name	es	VoidsClassificationProperty	\N
category_desc	category_desc_id	es	Andic Gleysol	\N
category_desc	category_desc_id	es	Epidystric	\N
category_desc	category_desc_id	es	NST - Non-sticky - After release of pressure, practically no soil material adheres to thumb and finger.	\N
category_desc	category_desc_id	es	Fragloss	\N
category_desc	category_desc_id	es	WE - Weak: Aggregates are barely observable in place and there is only a weak arrangement of natural surfaces of weakness. When gently disturbed, the soil material breaks into a mixture of few entire aggregates, many broken aggregates, and much material without aggregate faces. Aggregate surfaces differ in some way from the aggregate interior.	\N
category_desc	category_desc_id	es	Umbric	\N
category_desc	category_desc_id	es	Rendolls	\N
property_desc	property_pretty_name	es	Bulk Density	\N
category_desc	category_desc_id	es	acid metamorphic	\N
category_desc	category_desc_id	es	Haplic Chernozem	\N
category_desc	category_desc_id	es	N 2/ - black	\N
category_desc	category_desc_id	es	P - Nature protection	\N
category_desc	category_desc_id	es	HM - Medium grassland	\N
category_desc	category_desc_id	es	5YR 7/6 - reddish yellow	\N
category_desc	category_desc_id	es	Rhod, Rhodic	\N
category_desc	category_desc_id	es	N - Neither receiving nor shedding water	\N
category_desc	category_desc_id	es	Stagnic Plinthosol	\N
category_desc	category_desc_id	es	Skeletic Chernozem	\N
category_desc	category_desc_id	es	Calcic Durisol	\N
category_desc	category_desc_id	es	Mochipic	\N
category_desc	category_desc_id	es	Petric Durisol	\N
category_desc	category_desc_id	es	Duric	\N
category_desc	category_desc_id	es	S - Slightly moist	\N
category_desc	category_desc_id	es	Endodystric	\N
category_desc	category_desc_id	es	10YR 5/8 - yellowish brown	\N
category_desc	category_desc_id	es	LP - Plain (< 10 %)	\N
category_desc	category_desc_id	es	DT - Tundra	\N
category_desc	category_desc_id	es	V - Very deep (> 20 cm)	\N
category_desc	category_desc_id	es	7.5Y 5/4	\N
category_desc	category_desc_id	es	UG3 glacio-fluvial gravel	\N
category_desc	category_desc_id	es	WT - Tunnel erosion	\N
category_desc	category_desc_id	es	5YR 7/4 - pink	\N
category_desc	category_desc_id	es	BR - Bridges between sand grains	\N
category_desc	category_desc_id	es	Hydrophobic	\N
property_desc	property_pretty_name	es	Cementation/compaction Degree	\N
category_desc	category_desc_id	es	FC - Coniferous forest	\N
category_desc	category_desc_id	es	CS - Clay and sesquioxides	\N
category_desc	category_desc_id	es	Umbric Podzol	\N
category_desc	category_desc_id	es	5R 4/1 - dark reddish grey	\N
property_desc	property_pretty_name	es	Rock size	\N
category_desc	category_desc_id	es	SX - Excavations	\N
category_desc	category_desc_id	es	Thyric Histosol	\N
property_desc	property_pretty_name	es	ParentDepositionProperty	\N
category_desc	category_desc_id	es	Hydr, Hydric	\N
category_desc	category_desc_id	es	A - Wind (aeolian) erosion or deposition	\N
category_desc	category_desc_id	es	BS -  Steppe climate	\N
category_desc	category_desc_id	es	F - Fine (0.5-2 mm)	\N
category_desc	category_desc_id	es	2.5Y 7/0 - light grey	\N
category_desc	category_desc_id	es	Nudiargic Luvisol	\N
category_desc	category_desc_id	es	Acroxic	\N
category_desc	category_desc_id	es	7.5R 5/0 - grey	\N
category_desc	category_desc_id	es	Leptic Phaeozem	\N
category_desc	category_desc_id	es	AB - Angular blocky	\N
category_desc	category_desc_id	es	Someric Phaeozem	\N
category_desc	category_desc_id	es	Neocambic Retisol	\N
property_phys_chem	property_phys_chem_id	es	cationExchangeCapacitycSoilProperty	\N
category_desc	category_desc_id	es	AT4 - Irrigated shrub crop cultivation	\N
category_desc	category_desc_id	es	CC - Calcium carbonate	\N
category_desc	category_desc_id	es	Solimovic Arenosol	\N
category_desc	category_desc_id	es	UG3 - Unconsolidated: glacio-fluvial gravel	\N
category_desc	category_desc_id	es	FrCi - Citrus	\N
property_desc	property_pretty_name	es	Past Weather Conditions	\N
category_desc	category_desc_id	es	II1 - Intermediate igneous: andesite, trachyte, phonolite	\N
category_desc	category_desc_id	es	UF - Submerged by inland water of unknown origin at least once a year	\N
category_desc	category_desc_id	es	Mollic Umbrisol	\N
category_desc	category_desc_id	es	2.5YR 4/8 - red	\N
category_desc	category_desc_id	es	PL - Ploughing	\N
category_desc	category_desc_id	es	Chernozem (CH)	\N
property_desc	property_pretty_name	es	Coatings Abundance	\N
category_desc	category_desc_id	es	Shifting sands	\N
category_desc	category_desc_id	es	SV4: 8 - 12 %	\N
category_desc	category_desc_id	es	Takyric Leptosol	\N
category_desc	category_desc_id	es	7.5YR 6/2 - pinkish grey	\N
category_desc	category_desc_id	es	Umbrisol (UM)	\N
category_desc	category_desc_id	es	7.5GY 7/4	\N
category_desc	category_desc_id	es	V - Vughs: Mostly irregular, equidimensional voids of faunal origin or resulting from tillage or disturbance of other voids. Discontinuous or interconnected. May be quantified in specific cases.	\N
category_desc	category_desc_id	es	basalt	\N
property_desc	property_pretty_name	es	Mineral Concentrations Nature	\N
property_phys_chem	property_phys_chem_id	es	gypsumProperty	\N
category_desc	category_desc_id	es	AQ - Aquic	\N
category_desc	category_desc_id	es	2.5Y 6/4 - light yellowish brown	\N
category_desc	category_desc_id	es	D - Dominant (> 80 %)	\N
category_desc	category_desc_id	es	X - Accelerated and natural erosion not distinguished	\N
category_desc	category_desc_id	es	TH - Thixotropy	\N
property_desc	property_pretty_name	es	Description Status	\N
category_desc	category_desc_id	es	Petroduric Kastanozem	\N
category_desc	category_desc_id	es	Eutric Leptosol	\N
category_desc	category_desc_id	es	FoMa - Maize	\N
category_desc	category_desc_id	es	Hydragric Acrisol	\N
property_desc	property_pretty_name	es	Artefact Kind	\N
property_desc	property_pretty_name	es	Rock abundance	\N
category_desc	category_desc_id	es	Haplic Luvisol	\N
category_desc	category_desc_id	es	Gleyic Stagnosol	\N
category_desc	category_desc_id	es	5R 5/6 - red	\N
category_desc	category_desc_id	es	VV - convex-convex	\N
category_desc	category_desc_id	es	PS - Pavements and paving stones	\N
property_desc	property_pretty_name	es	Soil Depth to Bedrock	\N
category_desc	category_desc_id	es	M - Many (15-40 %)	\N
category_desc	category_desc_id	es	Histels	\N
category_desc	category_desc_id	es	2.5Y 3/2 - very dark greyish brown	\N
category_desc	category_desc_id	es	W - Water erosion or deposition	\N
category_desc	category_desc_id	es	5Y 8/3 - pale yellow	\N
category_desc	category_desc_id	es	2.5Y 7/4 - pale yellow	\N
property_phys_chem	property_phys_chem_id	es	manganeseProperty	\N
category_desc	category_desc_id	es	Anhy	\N
category_desc	category_desc_id	es	5R 3/8 - dark red	\N
category_desc	category_desc_id	es	5Y 8/4 - pale yellow	\N
category_desc	category_desc_id	es	Salic	\N
category_desc	category_desc_id	es	Gloss, Glossic	\N
category_desc	category_desc_id	es	V - Very few (0 - 2 %)	\N
category_desc	category_desc_id	es	Hyperspodic	\N
category_desc	category_desc_id	es	Plaggic Umbrisol	\N
category_desc	category_desc_id	es	WSW - west-south-west	\N
category_desc	category_desc_id	es	B - Boulders (20 - 60 cm)	\N
category_desc	category_desc_id	es	7.5YR 8/0 - white	\N
category_desc	category_desc_id	es	Aquents	\N
category_desc	category_desc_id	es	Tunnel erosion	\N
property_desc	property_pretty_name	es	Parent Material Class	\N
category_desc	category_desc_id	es	SO3 - Sedimentary organic: coals, bitumen and related rocks	\N
category_desc	category_desc_id	es	V - Very few - The number of very fine pores (< 2 mm) per square decimetre is 1-20, the number of medium and coarse pores (> 2 mm) per square decimetre is 1-2.	\N
category_desc	category_desc_id	es	FE - Primary mineral fragments: feldespar	\N
category_desc	category_desc_id	es	SP - Slickensides, partly intersecting	\N
category_desc	category_desc_id	es	Dystric Regosol	\N
category_desc	category_desc_id	es	Coarsic Calcisol	\N
category_desc	category_desc_id	es	Panpaic	\N
category_desc	category_desc_id	es	Novic	\N
category_desc	category_desc_id	es	Mollic Ferralsol	\N
category_desc	category_desc_id	es	TO - Torric	\N
category_desc	category_desc_id	es	Hydric Andosol	\N
category_desc	category_desc_id	es	C - Very closely spaced (< 0.2 m)	\N
category_desc	category_desc_id	es	EX - Extremely calcareous (> 25%) - Extremely strong reaction. Thick foam forms quickly.	\N
category_desc	category_desc_id	es	Cryods	\N
category_desc	category_desc_id	es	10YR 4/3 - (dark) brown	\N
category_desc	category_desc_id	es	PN3 - Wildlife management	\N
category_desc	category_desc_id	es	Moist - S: 0.6–0.9%	\N
property_desc	property_pretty_name	es	Grass Abundance	\N
category_desc	category_desc_id	es	ID - Industrial dust	\N
category_desc	category_desc_id	es	oPf - Older Pleistocene, without periglacial influence.	\N
category_desc	category_desc_id	es	4 - High (15-40%)	\N
category_desc	category_desc_id	es	Ve - Vegetables	\N
category_desc	category_desc_id	es	M - Moderate - Clear evidence of removal of surface horizons. Original biotic functions partly destroyed	\N
category_desc	category_desc_id	es	M - Many	\N
category_desc	category_desc_id	es	HS - Short grassland	\N
category_desc	category_desc_id	es	Tidalic Fluvisol	\N
category_desc	category_desc_id	es	Yn - Young (10-100 years) natural: with loss by erosion or deposition of materials such as on tidal flats, coastal dunes, river valleys, landslides, or desert areas.	\N
category_desc	category_desc_id	es	No evidence of erosion	\N
category_desc	category_desc_id	es	Entisols	\N
category_desc	category_desc_id	es	D - Snow (microthermal) climates	\N
category_desc	category_desc_id	es	Ombric Histosol	\N
category_desc	category_desc_id	es	Sideralic Anthrosol	\N
category_desc	category_desc_id	es	2.5YR 6/4 - light reddish brown	\N
category_desc	category_desc_id	es	Aquepts	\N
category_desc	category_desc_id	es	5B 5/1 - bluish grey	\N
category_desc	category_desc_id	es	WS - Semi-deciduous woodland	\N
category_desc	category_desc_id	es	F - Few - Roots with diameters < 2 mm: 20-50, Roots with diameters > 2 mm: 2-5.	\N
category_desc	category_desc_id	es	EX - Extremely salty (>15 dS m-1)	\N
category_desc	category_desc_id	es	AP - Perennial field cropping	\N
category_desc	category_desc_id	es	Leptic Calcisol	\N
category_desc	category_desc_id	es	Sombric	\N
category_desc	category_desc_id	es	Cambic Kastanozem	\N
category_desc	category_desc_id	es	IC - Crack infillings	\N
category_desc	category_desc_id	es	Aquults	\N
category_desc	category_desc_id	es	FF  - Very fine and fine	\N
category_desc	category_desc_id	es	N - Non-calcareous (0%) - No detectable visible or audible effervescence.	\N
category_desc	category_desc_id	es	Reductic Technosol	\N
category_desc	category_desc_id	es	Pretic Alisol	\N
category_desc	category_desc_id	es	N - Period of activity not known	\N
category_desc	category_desc_id	es	Well drained	\N
category_desc	category_desc_id	es	Aridisols	\N
category_desc	category_desc_id	es	Dry - Other: < 0.6%	\N
category_desc	category_desc_id	es	Dystric Durisol	\N
category_desc	category_desc_id	es	SSH - soft to slightly hard:	\N
category_desc	category_desc_id	es	Chernic Gleysol	\N
property_desc	property_pretty_name	es	Sealing Consistence	\N
category_desc	category_desc_id	es	redeposited natural material	\N
category_desc	category_desc_id	es	Humods	\N
category_desc	category_desc_id	es	Plaggic	\N
category_desc	category_desc_id	es	diorite	\N
category_desc	category_desc_id	es	Skeletic Podzol	\N
category_desc	category_desc_id	es	FoAl - Alfalfa	\N
category_desc	category_desc_id	es	Terric Podzol	\N
category_desc	category_desc_id	es	quartz-diorite	\N
category_desc	category_desc_id	es	0 - None (0 - 2 %)	\N
category_desc	category_desc_id	es	MM - Mixed material	\N
category_desc	category_desc_id	es	7.5R 4/0 - dark grey	\N
category_desc	category_desc_id	es	Petroferric	\N
category_desc	category_desc_id	es	Epieutric	\N
category_desc	category_desc_id	es	FN - Natural forest and woodland	\N
category_desc	category_desc_id	es	Acric Nitisol	\N
category_desc	category_desc_id	es	Chromic Alisol	\N
category_desc	category_desc_id	es	Puffic	\N
category_desc	category_desc_id	es	Dry - LS, SL, L: 9–15%	\N
category_desc	category_desc_id	es	7.5GY 4/0	\N
category_desc	category_desc_id	es	Calcic Retisol	\N
category_desc	category_desc_id	es	Haplic Calcisol	\N
category_desc	category_desc_id	es	Greyzemic Phaeozem	\N
category_desc	category_desc_id	es	Orthels	\N
category_desc	category_desc_id	es	4 - 30-90 days	\N
category_desc	category_desc_id	es	F - Few - The number of very fine pores (< 2 mm) per square decimetre is 20-50, the number of medium and coarse pores (> 2 mm) per square decimetre is 2-5.	\N
category_desc	category_desc_id	es	kryogenic	\N
category_desc	category_desc_id	es	Calcaric Gleysol	\N
category_desc	category_desc_id	es	Weakly drained	\N
category_desc	category_desc_id	es	Dolomitic Luvisol	\N
category_desc	category_desc_id	es	groundwater-fed bog peat	\N
category_desc	category_desc_id	es	SI - Slickensides, predominantly intersecting: Slickensides are polished and grooved ped surfaces that are produced by aggregates sliding one past another.	\N
category_desc	category_desc_id	es	Activic	\N
category_desc	category_desc_id	es	AR - Aridic	\N
category_desc	category_desc_id	es	weathered residuum	\N
category_desc	category_desc_id	es	EFI - Extremely firm: Soil material crushes only under very strong pressure; cannot be crushed between thumb and forefinger.	\N
category_desc	category_desc_id	es	Dwa - Snow climates - dry winter, hot summer	\N
category_desc	category_desc_id	es	Vitric Cambisol	\N
category_desc	category_desc_id	es	AA4T - Traditional rainfed arable cultivation	\N
category_desc	category_desc_id	es	I - Imperfectly drained - Water is removed slowly so that the soils are wet at shallow depth for a considerable period	\N
category_desc	category_desc_id	es	5Y 3/2 - dark olive grey	\N
category_desc	category_desc_id	es	7.5Y 7/6	\N
category_desc	category_desc_id	es	rhyolite	\N
category_desc	category_desc_id	es	10Y 4/2 - olive grey	\N
category_desc	category_desc_id	es	5Y 7/1 - light grey	\N
category_desc	category_desc_id	es	Nudilithic Leptosol	\N
category_desc	category_desc_id	es	SR - Residential use	\N
category_desc	category_desc_id	es	BD2 - Sample disintegrates into numerous fragments after application of weak single grain, subangular, pressure - single grain, subangular, angular blocky - 1.2-1.4	\N
category_desc	category_desc_id	es	W - Weathered: Partial weathering is indicated by discoloration and loss of crystal form in the outer parts of the fragments while the centres remain relatively fresh and the fragments have lost little of their original strength.	\N
category_desc	category_desc_id	es	Protic Fluvisol	\N
category_desc	category_desc_id	es	Arg	\N
category_desc	category_desc_id	es	GR - Granular	\N
property_phys_chem	property_phys_chem_id	es	electricalConductivityProperty	\N
category_desc	category_desc_id	es	10R 4/6 - red	\N
category_desc	category_desc_id	es	Phaeozem (PH)	\N
category_desc	category_desc_id	es	conglomerate, breccia	\N
category_desc	category_desc_id	es	I - Ice	\N
category_desc	category_desc_id	es	C - Clay (argillaceous)	\N
category_desc	category_desc_id	es	FP - Plantation forestry	\N
category_desc	category_desc_id	es	Neobrunic Retisol	\N
category_desc	category_desc_id	es	1 - Less than 1 day	\N
category_desc	category_desc_id	es	Nitisol (NT)	\N
property_desc	property_pretty_name	es	Lithology	\N
category_desc	category_desc_id	es	Fibrists	\N
category_desc	category_desc_id	es	SN - Slickensides, non intersecting	\N
category_desc	category_desc_id	es	Andosol (AN)	\N
category_desc	category_desc_id	es	CR - Impact crater	\N
category_desc	category_desc_id	es	Retic Phaeozem	\N
category_desc	category_desc_id	es	EF - Climates of perpetual frost (ice-caps)	\N
category_desc	category_desc_id	es	Cryic Histosol	\N
category_desc	category_desc_id	es	Epic	\N
category_desc	category_desc_id	es	Archaic	\N
category_desc	category_desc_id	es	C - Continuous: The layer is more than 90 percent cemented or compacted, and is only interrupted in places by cracks or fissures.	\N
category_desc	category_desc_id	es	Hydragric Planosol	\N
property_desc	property_pretty_name	es	Coatings Nature	\N
category_desc	category_desc_id	es	5B 6/1 - bluish grey	\N
category_desc	category_desc_id	es	IB1 - basic igneous: gabbro	\N
category_desc	category_desc_id	es	T - Termite or ant channels and nests	\N
category_desc	category_desc_id	es	U - Not used and not managed	\N
category_desc	category_desc_id	es	TK - Takyric	\N
category_desc	category_desc_id	es	Reductic Gleysol	\N
category_desc	category_desc_id	es	UF1 - Unconsolidated: fluvial sand and gravel	\N
category_desc	category_desc_id	es	Podzol (PZ)	\N
category_desc	category_desc_id	es	Turb	\N
category_desc	category_desc_id	es	Anthraquic Nitisol	\N
category_desc	category_desc_id	es	BO - Bottom (flat)	\N
category_desc	category_desc_id	es	5Y 5/6 - olive	\N
property_desc	property_pretty_name	es	Peat Drainage	\N
property_phys_chem	property_phys_chem_id	es	carbonInorganicProperty	\N
category_desc	category_desc_id	es	SC3 - Clastic sediments: silt-, mud-, claystone	\N
\.


--
-- TOC entry 4996 (class 0 OID 54923058)
-- Dependencies: 259
-- Data for Name: unit_of_measure; Type: TABLE DATA; Schema: core; Owner: glosis
--

COPY core.unit_of_measure (unit_of_measure_id, label, uri) FROM stdin;
cm/h	Centimetre per hour	http://qudt.org/vocab/unit/CentiM-PER-HR
%	Percent	http://qudt.org/vocab/unit/PERCENT
cmol/kg	Centimole per kilogram	http://qudt.org/vocab/unit/CentiMOL-PER-KiloGM
dS/m	Decisiemens per metre	http://qudt.org/vocab/unit/DeciS-PER-M
g/kg	Gram per kilogram	http://qudt.org/vocab/unit/GM-PER-KiloGM
kg/dm³	Kilogram per cubic decimetre	http://qudt.org/vocab/unit/KiloGM-PER-DeciM3
pH	Acidity	http://qudt.org/vocab/unit/PH
cmol/L	Centimol per litre	http://w3id.org/glosis/model/unit/CentiMOL-PER-L
g/hg	Gram per hectogram	http://w3id.org/glosis/model/unit/GM-PER-HectoGM
m³/100 m³	Cubic metre per one hundred cubic metre	http://w3id.org/glosis/model/unit/M3-PER-HundredM3
mg/kg	Miligram per kilogram (also ppm)	http://qudt.org/vocab/unit/MilliGM-PER-KiloGM
t/(ha·a)	Tonne per hectare year	https://qudt.org/vocab/unit/TONNE-PER-HA-YR
class	categorical	https://qudt.org/vocab/unit/class
dimensionless	no dimension	https://qudt.org/vocab/unit/dimensionless
\.


--
-- TOC entry 4997 (class 0 OID 54923066)
-- Dependencies: 260
-- Data for Name: address; Type: TABLE DATA; Schema: metadata; Owner: glosis
--

COPY metadata.address (address_id, street_address, postal_code, locality, country) FROM stdin;
\.


--
-- TOC entry 4999 (class 0 OID 54923074)
-- Dependencies: 262
-- Data for Name: individual; Type: TABLE DATA; Schema: metadata; Owner: glosis
--

COPY metadata.individual (individual_id, address_id, name, honorific_title, email, telephone, url) FROM stdin;
\.


--
-- TOC entry 5001 (class 0 OID 54923082)
-- Dependencies: 264
-- Data for Name: organisation; Type: TABLE DATA; Schema: metadata; Owner: glosis
--

COPY metadata.organisation (organisation_id, parent_id, address_id, name, email, telephone, url) FROM stdin;
\.


--
-- TOC entry 5002 (class 0 OID 54923088)
-- Dependencies: 265
-- Data for Name: organisation_individual; Type: TABLE DATA; Schema: metadata; Owner: glosis
--

COPY metadata.organisation_individual (organisation_id, organisation_unit_id, individual_id, role) FROM stdin;
\.


--
-- TOC entry 4973 (class 0 OID 54922873)
-- Dependencies: 236
-- Data for Name: organisation_project; Type: TABLE DATA; Schema: metadata; Owner: glosis
--

COPY metadata.organisation_project (organisation_id, project_id) FROM stdin;
\.


--
-- TOC entry 5004 (class 0 OID 54923096)
-- Dependencies: 267
-- Data for Name: organisation_unit; Type: TABLE DATA; Schema: metadata; Owner: glosis
--

COPY metadata.organisation_unit (organisation_unit_id, organisation_id, name) FROM stdin;
\.


--
-- TOC entry 4637 (class 0 OID 54921397)
-- Dependencies: 208
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: glosis
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- TOC entry 5190 (class 0 OID 0)
-- Dependencies: 223
-- Name: element_element_id_seq; Type: SEQUENCE SET; Schema: core; Owner: glosis
--

SELECT pg_catalog.setval('core.element_element_id_seq', 1, false);


--
-- TOC entry 5191 (class 0 OID 0)
-- Dependencies: 269
-- Name: observation_phys_chem_element_observation_phys_chem_element_seq; Type: SEQUENCE SET; Schema: core; Owner: glosis
--

SELECT pg_catalog.setval('core.observation_phys_chem_element_observation_phys_chem_element_seq', 1008, false);


--
-- TOC entry 5192 (class 0 OID 0)
-- Dependencies: 230
-- Name: plot_plot_id_seq; Type: SEQUENCE SET; Schema: core; Owner: glosis
--

SELECT pg_catalog.setval('core.plot_plot_id_seq', 1, false);


--
-- TOC entry 5193 (class 0 OID 0)
-- Dependencies: 234
-- Name: profile_profile_id_seq; Type: SEQUENCE SET; Schema: core; Owner: glosis
--

SELECT pg_catalog.setval('core.profile_profile_id_seq', 1, false);


--
-- TOC entry 5194 (class 0 OID 0)
-- Dependencies: 237
-- Name: project_project_id_seq; Type: SEQUENCE SET; Schema: core; Owner: glosis
--

SELECT pg_catalog.setval('core.project_project_id_seq', 1, false);


--
-- TOC entry 5195 (class 0 OID 0)
-- Dependencies: 270
-- Name: result_phys_chem_specimen_result_phys_chem_specimen_id_seq; Type: SEQUENCE SET; Schema: core; Owner: glosis
--

SELECT pg_catalog.setval('core.result_phys_chem_specimen_result_phys_chem_specimen_id_seq', 1, false);


--
-- TOC entry 5196 (class 0 OID 0)
-- Dependencies: 271
-- Name: result_spectrum_result_spectrum_id_seq; Type: SEQUENCE SET; Schema: core; Owner: glosis
--

SELECT pg_catalog.setval('core.result_spectrum_result_spectrum_id_seq', 1, false);


--
-- TOC entry 5197 (class 0 OID 0)
-- Dependencies: 247
-- Name: site_site_id_seq; Type: SEQUENCE SET; Schema: core; Owner: glosis
--

SELECT pg_catalog.setval('core.site_site_id_seq', 1, false);


--
-- TOC entry 5198 (class 0 OID 0)
-- Dependencies: 250
-- Name: specimen_prep_process_specimen_prep_process_id_seq; Type: SEQUENCE SET; Schema: core; Owner: glosis
--

SELECT pg_catalog.setval('core.specimen_prep_process_specimen_prep_process_id_seq', 1, false);


--
-- TOC entry 5199 (class 0 OID 0)
-- Dependencies: 251
-- Name: specimen_specimen_id_seq; Type: SEQUENCE SET; Schema: core; Owner: glosis
--

SELECT pg_catalog.setval('core.specimen_specimen_id_seq', 1, false);


--
-- TOC entry 5200 (class 0 OID 0)
-- Dependencies: 253
-- Name: specimen_storage_specimen_storage_id_seq; Type: SEQUENCE SET; Schema: core; Owner: glosis
--

SELECT pg_catalog.setval('core.specimen_storage_specimen_storage_id_seq', 1, false);


--
-- TOC entry 5201 (class 0 OID 0)
-- Dependencies: 255
-- Name: specimen_transport_specimen_transport_id_seq; Type: SEQUENCE SET; Schema: core; Owner: glosis
--

SELECT pg_catalog.setval('core.specimen_transport_specimen_transport_id_seq', 1, false);


--
-- TOC entry 5202 (class 0 OID 0)
-- Dependencies: 258
-- Name: surface_surface_id_seq; Type: SEQUENCE SET; Schema: core; Owner: glosis
--

SELECT pg_catalog.setval('core.surface_surface_id_seq', 1, false);


--
-- TOC entry 5203 (class 0 OID 0)
-- Dependencies: 261
-- Name: address_address_id_seq; Type: SEQUENCE SET; Schema: metadata; Owner: glosis
--

SELECT pg_catalog.setval('metadata.address_address_id_seq', 1, false);


--
-- TOC entry 5204 (class 0 OID 0)
-- Dependencies: 263
-- Name: individual_individual_id_seq; Type: SEQUENCE SET; Schema: metadata; Owner: glosis
--

SELECT pg_catalog.setval('metadata.individual_individual_id_seq', 1, false);


--
-- TOC entry 5205 (class 0 OID 0)
-- Dependencies: 266
-- Name: organisation_organisation_id_seq; Type: SEQUENCE SET; Schema: metadata; Owner: glosis
--

SELECT pg_catalog.setval('metadata.organisation_organisation_id_seq', 1, false);


--
-- TOC entry 5206 (class 0 OID 0)
-- Dependencies: 268
-- Name: organisation_unit_organisation_unit_id_seq; Type: SEQUENCE SET; Schema: metadata; Owner: glosis
--

SELECT pg_catalog.setval('metadata.organisation_unit_organisation_unit_id_seq', 1, false);


--
-- TOC entry 4763 (class 2606 OID 54924224)
-- Name: category_desc category_desc_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.category_desc
    ADD CONSTRAINT category_desc_pkey PRIMARY KEY (category_desc_id);


--
-- TOC entry 4653 (class 2606 OID 54923143)
-- Name: element element_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.element
    ADD CONSTRAINT element_pkey PRIMARY KEY (element_id);


--
-- TOC entry 4765 (class 2606 OID 54924343)
-- Name: languages languages_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (language_code);


--
-- TOC entry 4657 (class 2606 OID 54924272)
-- Name: observation_desc_element observation_desc_element_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.observation_desc_element
    ADD CONSTRAINT observation_desc_element_pkey PRIMARY KEY (property_desc_id, category_desc_id);


--
-- TOC entry 4659 (class 2606 OID 54924254)
-- Name: observation_desc_plot observation_desc_plot_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.observation_desc_plot
    ADD CONSTRAINT observation_desc_plot_pkey PRIMARY KEY (property_desc_id, category_desc_id);


--
-- TOC entry 4661 (class 2606 OID 54924263)
-- Name: observation_desc_profile observation_desc_profile_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.observation_desc_profile
    ADD CONSTRAINT observation_desc_profile_pkey PRIMARY KEY (property_desc_id, category_desc_id);


--
-- TOC entry 4663 (class 2606 OID 54923165)
-- Name: observation_phys_chem observation_phys_chem_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.observation_phys_chem
    ADD CONSTRAINT observation_phys_chem_pkey PRIMARY KEY (observation_phys_chem_id);


--
-- TOC entry 4665 (class 2606 OID 54924102)
-- Name: observation_phys_chem observation_phys_chem_property_phys_chem_id_procedure_phys__key; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.observation_phys_chem
    ADD CONSTRAINT observation_phys_chem_property_phys_chem_id_procedure_phys__key UNIQUE (property_phys_chem_id, procedure_phys_chem_id);


--
-- TOC entry 4671 (class 2606 OID 54923750)
-- Name: plot_individual plot_individual_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.plot_individual
    ADD CONSTRAINT plot_individual_pkey PRIMARY KEY (plot_id, individual_id);


--
-- TOC entry 4667 (class 2606 OID 54923173)
-- Name: plot plot_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.plot
    ADD CONSTRAINT plot_pkey PRIMARY KEY (plot_id);


--
-- TOC entry 4673 (class 2606 OID 54923978)
-- Name: procedure_desc procedure_desc_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.procedure_desc
    ADD CONSTRAINT procedure_desc_pkey PRIMARY KEY (procedure_desc_id);


--
-- TOC entry 4675 (class 2606 OID 54923177)
-- Name: procedure_desc procedure_desc_uri_key; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.procedure_desc
    ADD CONSTRAINT procedure_desc_uri_key UNIQUE (uri);


--
-- TOC entry 4677 (class 2606 OID 54924077)
-- Name: procedure_phys_chem procedure_phys_chem_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.procedure_phys_chem
    ADD CONSTRAINT procedure_phys_chem_pkey PRIMARY KEY (procedure_phys_chem_id);


--
-- TOC entry 4681 (class 2606 OID 54923181)
-- Name: profile profile_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.profile
    ADD CONSTRAINT profile_pkey PRIMARY KEY (profile_id);


--
-- TOC entry 4685 (class 2606 OID 54923187)
-- Name: project project_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.project
    ADD CONSTRAINT project_pkey PRIMARY KEY (project_id);


--
-- TOC entry 4691 (class 2606 OID 54923752)
-- Name: project_related project_related_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.project_related
    ADD CONSTRAINT project_related_pkey PRIMARY KEY (project_source_id, project_target_id);


--
-- TOC entry 4713 (class 2606 OID 54923219)
-- Name: project_site project_site_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.project_site
    ADD CONSTRAINT project_site_pkey PRIMARY KEY (project_id, site_id);


--
-- TOC entry 4761 (class 2606 OID 54924216)
-- Name: property_desc property_desc_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.property_desc
    ADD CONSTRAINT property_desc_pkey PRIMARY KEY (property_desc_id);


--
-- TOC entry 4693 (class 2606 OID 54924051)
-- Name: property_phys_chem property_phys_chem_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.property_phys_chem
    ADD CONSTRAINT property_phys_chem_pkey PRIMARY KEY (property_phys_chem_id);


--
-- TOC entry 4697 (class 2606 OID 54923890)
-- Name: result_desc_element result_desc_element_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.result_desc_element
    ADD CONSTRAINT result_desc_element_pkey PRIMARY KEY (element_id, property_desc_id);


--
-- TOC entry 4699 (class 2606 OID 54923902)
-- Name: result_desc_plot result_desc_plot_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.result_desc_plot
    ADD CONSTRAINT result_desc_plot_pkey PRIMARY KEY (plot_id, property_desc_id);


--
-- TOC entry 4701 (class 2606 OID 54923926)
-- Name: result_desc_profile result_desc_profile_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.result_desc_profile
    ADD CONSTRAINT result_desc_profile_pkey PRIMARY KEY (profile_id, property_desc_id);


--
-- TOC entry 4703 (class 2606 OID 54923914)
-- Name: result_desc_surface result_desc_surface_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.result_desc_surface
    ADD CONSTRAINT result_desc_surface_pkey PRIMARY KEY (surface_id, property_desc_id);


--
-- TOC entry 4705 (class 2606 OID 54923205)
-- Name: result_phys_chem result_numerical_specimen_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.result_phys_chem
    ADD CONSTRAINT result_numerical_specimen_pkey PRIMARY KEY (result_phys_chem_id);


--
-- TOC entry 4707 (class 2606 OID 54923792)
-- Name: result_phys_chem result_phys_chem_specimen_observation_phys_chem_id_specimen_key; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.result_phys_chem
    ADD CONSTRAINT result_phys_chem_specimen_observation_phys_chem_id_specimen_key UNIQUE (observation_phys_chem_id, specimen_id);


--
-- TOC entry 4757 (class 2606 OID 54924158)
-- Name: result_spectrum result_spectrum_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.result_spectrum
    ADD CONSTRAINT result_spectrum_pkey PRIMARY KEY (result_spectrum_id);


--
-- TOC entry 4709 (class 2606 OID 54923217)
-- Name: site site_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.site
    ADD CONSTRAINT site_pkey PRIMARY KEY (site_id);


--
-- TOC entry 4715 (class 2606 OID 54923221)
-- Name: specimen specimen_code_key; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.specimen
    ADD CONSTRAINT specimen_code_key UNIQUE (code);


--
-- TOC entry 4717 (class 2606 OID 54923223)
-- Name: specimen specimen_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.specimen
    ADD CONSTRAINT specimen_pkey PRIMARY KEY (specimen_id);


--
-- TOC entry 4719 (class 2606 OID 54923225)
-- Name: specimen_prep_process specimen_prep_process_definition_key; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.specimen_prep_process
    ADD CONSTRAINT specimen_prep_process_definition_key UNIQUE (definition);


--
-- TOC entry 4721 (class 2606 OID 54923227)
-- Name: specimen_prep_process specimen_prep_process_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.specimen_prep_process
    ADD CONSTRAINT specimen_prep_process_pkey PRIMARY KEY (specimen_prep_process_id);


--
-- TOC entry 4723 (class 2606 OID 54923229)
-- Name: specimen_storage specimen_storage_definition_key; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.specimen_storage
    ADD CONSTRAINT specimen_storage_definition_key UNIQUE (definition);


--
-- TOC entry 4725 (class 2606 OID 54923231)
-- Name: specimen_storage specimen_storage_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.specimen_storage
    ADD CONSTRAINT specimen_storage_pkey PRIMARY KEY (specimen_storage_id);


--
-- TOC entry 4729 (class 2606 OID 54923233)
-- Name: specimen_transport specimen_transport_definition_key; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.specimen_transport
    ADD CONSTRAINT specimen_transport_definition_key UNIQUE (definition);


--
-- TOC entry 4731 (class 2606 OID 54923235)
-- Name: specimen_transport specimen_transport_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.specimen_transport
    ADD CONSTRAINT specimen_transport_pkey PRIMARY KEY (specimen_transport_id);


--
-- TOC entry 4739 (class 2606 OID 54923764)
-- Name: surface_individual surface_individual_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.surface_individual
    ADD CONSTRAINT surface_individual_pkey PRIMARY KEY (surface_id, individual_id);


--
-- TOC entry 4735 (class 2606 OID 54923239)
-- Name: surface surface_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.surface
    ADD CONSTRAINT surface_pkey PRIMARY KEY (surface_id);


--
-- TOC entry 4767 (class 2606 OID 54924351)
-- Name: translate translate_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.translate
    ADD CONSTRAINT translate_pkey PRIMARY KEY (table_name, column_name, language_code, string);


--
-- TOC entry 4741 (class 2606 OID 54924025)
-- Name: unit_of_measure unit_of_measure_pkey; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.unit_of_measure
    ADD CONSTRAINT unit_of_measure_pkey PRIMARY KEY (unit_of_measure_id);


--
-- TOC entry 4655 (class 2606 OID 54923253)
-- Name: element unq_element_profile_order_element; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.element
    ADD CONSTRAINT unq_element_profile_order_element UNIQUE (profile_id, order_element);


--
-- TOC entry 4669 (class 2606 OID 54923255)
-- Name: plot unq_plot_code; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.plot
    ADD CONSTRAINT unq_plot_code UNIQUE (plot_code);


--
-- TOC entry 4679 (class 2606 OID 54923261)
-- Name: procedure_phys_chem unq_procedure_phys_chem_uri; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.procedure_phys_chem
    ADD CONSTRAINT unq_procedure_phys_chem_uri UNIQUE (uri);


--
-- TOC entry 4683 (class 2606 OID 54923263)
-- Name: profile unq_profile_code; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.profile
    ADD CONSTRAINT unq_profile_code UNIQUE (profile_code);


--
-- TOC entry 4687 (class 2606 OID 54923265)
-- Name: project unq_project_name; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.project
    ADD CONSTRAINT unq_project_name UNIQUE (name);


--
-- TOC entry 4695 (class 2606 OID 54923287)
-- Name: property_phys_chem unq_property_phys_chem_uri; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.property_phys_chem
    ADD CONSTRAINT unq_property_phys_chem_uri UNIQUE (uri);


--
-- TOC entry 4711 (class 2606 OID 54923297)
-- Name: site unq_site_code; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.site
    ADD CONSTRAINT unq_site_code UNIQUE (site_code);


--
-- TOC entry 4727 (class 2606 OID 54923299)
-- Name: specimen_storage unq_specimen_storage_label; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.specimen_storage
    ADD CONSTRAINT unq_specimen_storage_label UNIQUE (label);


--
-- TOC entry 4733 (class 2606 OID 54923301)
-- Name: specimen_transport unq_specimen_transport_label; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.specimen_transport
    ADD CONSTRAINT unq_specimen_transport_label UNIQUE (label);


--
-- TOC entry 4737 (class 2606 OID 54923303)
-- Name: surface unq_surface_super; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.surface
    ADD CONSTRAINT unq_surface_super UNIQUE (surface_id, super_surface_id);


--
-- TOC entry 4743 (class 2606 OID 54923315)
-- Name: unit_of_measure unq_unit_of_measure_uri; Type: CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.unit_of_measure
    ADD CONSTRAINT unq_unit_of_measure_uri UNIQUE (uri);


--
-- TOC entry 4745 (class 2606 OID 54923317)
-- Name: address address_pkey; Type: CONSTRAINT; Schema: metadata; Owner: glosis
--

ALTER TABLE ONLY metadata.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (address_id);


--
-- TOC entry 4747 (class 2606 OID 54923319)
-- Name: individual individual_pkey; Type: CONSTRAINT; Schema: metadata; Owner: glosis
--

ALTER TABLE ONLY metadata.individual
    ADD CONSTRAINT individual_pkey PRIMARY KEY (individual_id);


--
-- TOC entry 4751 (class 2606 OID 54923321)
-- Name: organisation_individual organisation_individual_individual_id_organisation_id_key; Type: CONSTRAINT; Schema: metadata; Owner: glosis
--

ALTER TABLE ONLY metadata.organisation_individual
    ADD CONSTRAINT organisation_individual_individual_id_organisation_id_key UNIQUE (individual_id, organisation_id);


--
-- TOC entry 4749 (class 2606 OID 54923323)
-- Name: organisation organisation_pkey; Type: CONSTRAINT; Schema: metadata; Owner: glosis
--

ALTER TABLE ONLY metadata.organisation
    ADD CONSTRAINT organisation_pkey PRIMARY KEY (organisation_id);


--
-- TOC entry 4689 (class 2606 OID 54923185)
-- Name: organisation_project organisation_project_pkey; Type: CONSTRAINT; Schema: metadata; Owner: glosis
--

ALTER TABLE ONLY metadata.organisation_project
    ADD CONSTRAINT organisation_project_pkey PRIMARY KEY (organisation_id, project_id);


--
-- TOC entry 4753 (class 2606 OID 54923325)
-- Name: organisation_unit organisation_unit_name_organisation_id_key; Type: CONSTRAINT; Schema: metadata; Owner: glosis
--

ALTER TABLE ONLY metadata.organisation_unit
    ADD CONSTRAINT organisation_unit_name_organisation_id_key UNIQUE (name, organisation_id);


--
-- TOC entry 4755 (class 2606 OID 54923327)
-- Name: organisation_unit organisation_unit_pkey; Type: CONSTRAINT; Schema: metadata; Owner: glosis
--

ALTER TABLE ONLY metadata.organisation_unit
    ADD CONSTRAINT organisation_unit_pkey PRIMARY KEY (organisation_unit_id);


--
-- TOC entry 4758 (class 1259 OID 54924169)
-- Name: result_spectrum_specimen_id_idx; Type: INDEX; Schema: core; Owner: glosis
--

CREATE INDEX result_spectrum_specimen_id_idx ON core.result_spectrum USING btree (specimen_id);


--
-- TOC entry 4759 (class 1259 OID 54924170)
-- Name: result_spectrum_spectrum_idx; Type: INDEX; Schema: core; Owner: glosis
--

CREATE INDEX result_spectrum_spectrum_idx ON core.result_spectrum USING gin (spectrum);


--
-- TOC entry 4824 (class 2620 OID 54924172)
-- Name: result_phys_chem trg_check_result_value; Type: TRIGGER; Schema: core; Owner: glosis
--

CREATE TRIGGER trg_check_result_value BEFORE INSERT OR UPDATE ON core.result_phys_chem FOR EACH ROW EXECUTE FUNCTION core.check_result_value();


--
-- TOC entry 5207 (class 0 OID 0)
-- Dependencies: 4824
-- Name: TRIGGER trg_check_result_value ON result_phys_chem; Type: COMMENT; Schema: core; Owner: glosis
--

COMMENT ON TRIGGER trg_check_result_value ON core.result_phys_chem IS 'Verifies if the value assigned to the result is valid. See the function core.ceck_result_value function for implementation.';


--
-- TOC entry 4791 (class 2606 OID 54923340)
-- Name: result_desc_element fk_element; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.result_desc_element
    ADD CONSTRAINT fk_element FOREIGN KEY (element_id) REFERENCES core.element(element_id);


--
-- TOC entry 4812 (class 2606 OID 54923345)
-- Name: surface_individual fk_individual; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.surface_individual
    ADD CONSTRAINT fk_individual FOREIGN KEY (individual_id) REFERENCES metadata.individual(individual_id);


--
-- TOC entry 4782 (class 2606 OID 54923350)
-- Name: plot_individual fk_individual; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.plot_individual
    ADD CONSTRAINT fk_individual FOREIGN KEY (individual_id) REFERENCES metadata.individual(individual_id);


--
-- TOC entry 4805 (class 2606 OID 54923375)
-- Name: specimen fk_organisation; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.specimen
    ADD CONSTRAINT fk_organisation FOREIGN KEY (organisation_id) REFERENCES metadata.organisation(organisation_id);


--
-- TOC entry 4783 (class 2606 OID 54923390)
-- Name: plot_individual fk_plot; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.plot_individual
    ADD CONSTRAINT fk_plot FOREIGN KEY (plot_id) REFERENCES core.plot(plot_id);


--
-- TOC entry 4785 (class 2606 OID 54923395)
-- Name: profile fk_plot; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.profile
    ADD CONSTRAINT fk_plot FOREIGN KEY (plot_id) REFERENCES core.plot(plot_id);


--
-- TOC entry 4793 (class 2606 OID 54923400)
-- Name: result_desc_plot fk_plot; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.result_desc_plot
    ADD CONSTRAINT fk_plot FOREIGN KEY (plot_id) REFERENCES core.plot(plot_id);


--
-- TOC entry 4768 (class 2606 OID 54923440)
-- Name: element fk_profile; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.element
    ADD CONSTRAINT fk_profile FOREIGN KEY (profile_id) REFERENCES core.profile(profile_id);


--
-- TOC entry 4795 (class 2606 OID 54923445)
-- Name: result_desc_profile fk_profile; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.result_desc_profile
    ADD CONSTRAINT fk_profile FOREIGN KEY (profile_id) REFERENCES core.profile(profile_id);


--
-- TOC entry 4802 (class 2606 OID 54923450)
-- Name: site fk_profile; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.site
    ADD CONSTRAINT fk_profile FOREIGN KEY (typical_profile) REFERENCES core.profile(profile_id);


--
-- TOC entry 4803 (class 2606 OID 54923455)
-- Name: project_site fk_project; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.project_site
    ADD CONSTRAINT fk_project FOREIGN KEY (project_id) REFERENCES core.project(project_id);


--
-- TOC entry 4789 (class 2606 OID 54923465)
-- Name: project_related fk_project_source; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.project_related
    ADD CONSTRAINT fk_project_source FOREIGN KEY (project_source_id) REFERENCES core.project(project_id);


--
-- TOC entry 4790 (class 2606 OID 54923470)
-- Name: project_related fk_project_target; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.project_related
    ADD CONSTRAINT fk_project_target FOREIGN KEY (project_target_id) REFERENCES core.project(project_id);


--
-- TOC entry 4810 (class 2606 OID 54923510)
-- Name: surface fk_site; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.surface
    ADD CONSTRAINT fk_site FOREIGN KEY (site_id) REFERENCES core.site(site_id);


--
-- TOC entry 4781 (class 2606 OID 54923515)
-- Name: plot fk_site; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.plot
    ADD CONSTRAINT fk_site FOREIGN KEY (site_id) REFERENCES core.site(site_id);


--
-- TOC entry 4804 (class 2606 OID 54923520)
-- Name: project_site fk_site; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.project_site
    ADD CONSTRAINT fk_site FOREIGN KEY (site_id) REFERENCES core.site(site_id);


--
-- TOC entry 4799 (class 2606 OID 54923530)
-- Name: result_phys_chem fk_specimen; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.result_phys_chem
    ADD CONSTRAINT fk_specimen FOREIGN KEY (specimen_id) REFERENCES core.specimen(specimen_id);


--
-- TOC entry 4821 (class 2606 OID 54924159)
-- Name: result_spectrum fk_specimen; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.result_spectrum
    ADD CONSTRAINT fk_specimen FOREIGN KEY (specimen_id) REFERENCES core.specimen(specimen_id);


--
-- TOC entry 4806 (class 2606 OID 54923535)
-- Name: specimen fk_specimen_prep_process; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.specimen
    ADD CONSTRAINT fk_specimen_prep_process FOREIGN KEY (specimen_prep_process_id) REFERENCES core.specimen_prep_process(specimen_prep_process_id);


--
-- TOC entry 4808 (class 2606 OID 54923540)
-- Name: specimen_prep_process fk_specimen_storage; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.specimen_prep_process
    ADD CONSTRAINT fk_specimen_storage FOREIGN KEY (specimen_storage_id) REFERENCES core.specimen_storage(specimen_storage_id);


--
-- TOC entry 4809 (class 2606 OID 54923545)
-- Name: specimen_prep_process fk_specimen_transport; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.specimen_prep_process
    ADD CONSTRAINT fk_specimen_transport FOREIGN KEY (specimen_transport_id) REFERENCES core.specimen_transport(specimen_transport_id);


--
-- TOC entry 4786 (class 2606 OID 54923550)
-- Name: profile fk_surface; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.profile
    ADD CONSTRAINT fk_surface FOREIGN KEY (surface_id) REFERENCES core.surface(surface_id);


--
-- TOC entry 4797 (class 2606 OID 54923555)
-- Name: result_desc_surface fk_surface; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.result_desc_surface
    ADD CONSTRAINT fk_surface FOREIGN KEY (surface_id) REFERENCES core.surface(surface_id);


--
-- TOC entry 4813 (class 2606 OID 54923560)
-- Name: surface_individual fk_surface; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.surface_individual
    ADD CONSTRAINT fk_surface FOREIGN KEY (surface_id) REFERENCES core.surface(surface_id);


--
-- TOC entry 4811 (class 2606 OID 54923565)
-- Name: surface fk_surface; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.surface
    ADD CONSTRAINT fk_surface FOREIGN KEY (super_surface_id) REFERENCES core.surface(surface_id);


--
-- TOC entry 4769 (class 2606 OID 54924325)
-- Name: observation_desc_element observation_desc_element_category_desc_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.observation_desc_element
    ADD CONSTRAINT observation_desc_element_category_desc_id_fkey FOREIGN KEY (category_desc_id) REFERENCES core.category_desc(category_desc_id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4770 (class 2606 OID 54924009)
-- Name: observation_desc_element observation_desc_element_procedure_desc_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.observation_desc_element
    ADD CONSTRAINT observation_desc_element_procedure_desc_id_fkey FOREIGN KEY (procedure_desc_id) REFERENCES core.procedure_desc(procedure_desc_id) ON UPDATE CASCADE;


--
-- TOC entry 4771 (class 2606 OID 54924320)
-- Name: observation_desc_element observation_desc_element_property_desc_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.observation_desc_element
    ADD CONSTRAINT observation_desc_element_property_desc_id_fkey FOREIGN KEY (property_desc_id) REFERENCES core.property_desc(property_desc_id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4772 (class 2606 OID 54924305)
-- Name: observation_desc_plot observation_desc_plot_category_desc_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.observation_desc_plot
    ADD CONSTRAINT observation_desc_plot_category_desc_id_fkey FOREIGN KEY (category_desc_id) REFERENCES core.category_desc(category_desc_id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4773 (class 2606 OID 54924014)
-- Name: observation_desc_plot observation_desc_plot_procedure_desc_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.observation_desc_plot
    ADD CONSTRAINT observation_desc_plot_procedure_desc_id_fkey FOREIGN KEY (procedure_desc_id) REFERENCES core.procedure_desc(procedure_desc_id) ON UPDATE CASCADE;


--
-- TOC entry 4774 (class 2606 OID 54924300)
-- Name: observation_desc_plot observation_desc_plot_property_desc_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.observation_desc_plot
    ADD CONSTRAINT observation_desc_plot_property_desc_id_fkey FOREIGN KEY (property_desc_id) REFERENCES core.property_desc(property_desc_id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4775 (class 2606 OID 54924315)
-- Name: observation_desc_profile observation_desc_profile_category_desc_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.observation_desc_profile
    ADD CONSTRAINT observation_desc_profile_category_desc_id_fkey FOREIGN KEY (category_desc_id) REFERENCES core.category_desc(category_desc_id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4776 (class 2606 OID 54924019)
-- Name: observation_desc_profile observation_desc_profile_procedure_desc_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.observation_desc_profile
    ADD CONSTRAINT observation_desc_profile_procedure_desc_id_fkey FOREIGN KEY (procedure_desc_id) REFERENCES core.procedure_desc(procedure_desc_id) ON UPDATE CASCADE;


--
-- TOC entry 4777 (class 2606 OID 54924310)
-- Name: observation_desc_profile observation_desc_profile_property_desc_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.observation_desc_profile
    ADD CONSTRAINT observation_desc_profile_property_desc_id_fkey FOREIGN KEY (property_desc_id) REFERENCES core.property_desc(property_desc_id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4778 (class 2606 OID 54924111)
-- Name: observation_phys_chem observation_phys_chem_procedure_phys_chem_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.observation_phys_chem
    ADD CONSTRAINT observation_phys_chem_procedure_phys_chem_id_fkey FOREIGN KEY (procedure_phys_chem_id) REFERENCES core.procedure_phys_chem(procedure_phys_chem_id) ON UPDATE CASCADE;


--
-- TOC entry 4779 (class 2606 OID 54924071)
-- Name: observation_phys_chem observation_phys_chem_property_phys_chem_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.observation_phys_chem
    ADD CONSTRAINT observation_phys_chem_property_phys_chem_id_fkey FOREIGN KEY (property_phys_chem_id) REFERENCES core.property_phys_chem(property_phys_chem_id) ON UPDATE CASCADE;


--
-- TOC entry 4780 (class 2606 OID 54924045)
-- Name: observation_phys_chem observation_phys_chem_unit_of_measure_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.observation_phys_chem
    ADD CONSTRAINT observation_phys_chem_unit_of_measure_id_fkey FOREIGN KEY (unit_of_measure_id) REFERENCES core.unit_of_measure(unit_of_measure_id) ON UPDATE CASCADE;


--
-- TOC entry 4784 (class 2606 OID 54924096)
-- Name: procedure_phys_chem procedure_phys_chem_broader_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.procedure_phys_chem
    ADD CONSTRAINT procedure_phys_chem_broader_id_fkey FOREIGN KEY (broader_id) REFERENCES core.procedure_phys_chem(procedure_phys_chem_id) ON UPDATE CASCADE;


--
-- TOC entry 4792 (class 2606 OID 54924295)
-- Name: result_desc_element result_desc_element_property_desc_id_category_desc_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.result_desc_element
    ADD CONSTRAINT result_desc_element_property_desc_id_category_desc_id_fkey FOREIGN KEY (property_desc_id, category_desc_id) REFERENCES core.observation_desc_element(property_desc_id, category_desc_id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4794 (class 2606 OID 54924280)
-- Name: result_desc_plot result_desc_plot_property_desc_id_category_desc_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.result_desc_plot
    ADD CONSTRAINT result_desc_plot_property_desc_id_category_desc_id_fkey FOREIGN KEY (property_desc_id, category_desc_id) REFERENCES core.observation_desc_plot(property_desc_id, category_desc_id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4796 (class 2606 OID 54924290)
-- Name: result_desc_profile result_desc_profile_property_desc_id_category_desc_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.result_desc_profile
    ADD CONSTRAINT result_desc_profile_property_desc_id_category_desc_id_fkey FOREIGN KEY (property_desc_id, category_desc_id) REFERENCES core.observation_desc_profile(property_desc_id, category_desc_id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4798 (class 2606 OID 54924285)
-- Name: result_desc_surface result_desc_surface_property_desc_id_category_desc_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.result_desc_surface
    ADD CONSTRAINT result_desc_surface_property_desc_id_category_desc_id_fkey FOREIGN KEY (property_desc_id, category_desc_id) REFERENCES core.observation_desc_plot(property_desc_id, category_desc_id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4800 (class 2606 OID 54923726)
-- Name: result_phys_chem result_phys_chem_specimen_individual_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.result_phys_chem
    ADD CONSTRAINT result_phys_chem_specimen_individual_id_fkey FOREIGN KEY (individual_id) REFERENCES metadata.individual(individual_id);


--
-- TOC entry 4801 (class 2606 OID 54923793)
-- Name: result_phys_chem result_phys_chem_specimen_observation_phys_chem_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.result_phys_chem
    ADD CONSTRAINT result_phys_chem_specimen_observation_phys_chem_id_fkey FOREIGN KEY (observation_phys_chem_id) REFERENCES core.observation_phys_chem(observation_phys_chem_id);


--
-- TOC entry 4822 (class 2606 OID 54924164)
-- Name: result_spectrum result_spectrum_individual_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.result_spectrum
    ADD CONSTRAINT result_spectrum_individual_id_fkey FOREIGN KEY (individual_id) REFERENCES metadata.individual(individual_id);


--
-- TOC entry 4807 (class 2606 OID 54924116)
-- Name: specimen specimen_element_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.specimen
    ADD CONSTRAINT specimen_element_id_fkey FOREIGN KEY (element_id) REFERENCES core.element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4823 (class 2606 OID 54924352)
-- Name: translate translate_language_code_fkey; Type: FK CONSTRAINT; Schema: core; Owner: glosis
--

ALTER TABLE ONLY core.translate
    ADD CONSTRAINT translate_language_code_fkey FOREIGN KEY (language_code) REFERENCES core.languages(language_code);


--
-- TOC entry 4814 (class 2606 OID 54923630)
-- Name: individual fk_address; Type: FK CONSTRAINT; Schema: metadata; Owner: glosis
--

ALTER TABLE ONLY metadata.individual
    ADD CONSTRAINT fk_address FOREIGN KEY (address_id) REFERENCES metadata.address(address_id);


--
-- TOC entry 4815 (class 2606 OID 54923635)
-- Name: organisation fk_address; Type: FK CONSTRAINT; Schema: metadata; Owner: glosis
--

ALTER TABLE ONLY metadata.organisation
    ADD CONSTRAINT fk_address FOREIGN KEY (address_id) REFERENCES metadata.address(address_id);


--
-- TOC entry 4817 (class 2606 OID 54923640)
-- Name: organisation_individual fk_individual; Type: FK CONSTRAINT; Schema: metadata; Owner: glosis
--

ALTER TABLE ONLY metadata.organisation_individual
    ADD CONSTRAINT fk_individual FOREIGN KEY (individual_id) REFERENCES metadata.individual(individual_id);


--
-- TOC entry 4787 (class 2606 OID 54923380)
-- Name: organisation_project fk_organisation; Type: FK CONSTRAINT; Schema: metadata; Owner: glosis
--

ALTER TABLE ONLY metadata.organisation_project
    ADD CONSTRAINT fk_organisation FOREIGN KEY (organisation_id) REFERENCES metadata.organisation(organisation_id);


--
-- TOC entry 4818 (class 2606 OID 54923645)
-- Name: organisation_individual fk_organisation; Type: FK CONSTRAINT; Schema: metadata; Owner: glosis
--

ALTER TABLE ONLY metadata.organisation_individual
    ADD CONSTRAINT fk_organisation FOREIGN KEY (organisation_id) REFERENCES metadata.organisation(organisation_id);


--
-- TOC entry 4820 (class 2606 OID 54923650)
-- Name: organisation_unit fk_organisation; Type: FK CONSTRAINT; Schema: metadata; Owner: glosis
--

ALTER TABLE ONLY metadata.organisation_unit
    ADD CONSTRAINT fk_organisation FOREIGN KEY (organisation_id) REFERENCES metadata.organisation(organisation_id);


--
-- TOC entry 4819 (class 2606 OID 54923655)
-- Name: organisation_individual fk_organisation_unit; Type: FK CONSTRAINT; Schema: metadata; Owner: glosis
--

ALTER TABLE ONLY metadata.organisation_individual
    ADD CONSTRAINT fk_organisation_unit FOREIGN KEY (organisation_unit_id) REFERENCES metadata.organisation_unit(organisation_unit_id);


--
-- TOC entry 4788 (class 2606 OID 54923460)
-- Name: organisation_project fk_project; Type: FK CONSTRAINT; Schema: metadata; Owner: glosis
--

ALTER TABLE ONLY metadata.organisation_project
    ADD CONSTRAINT fk_project FOREIGN KEY (project_id) REFERENCES core.project(project_id);


--
-- TOC entry 4816 (class 2606 OID 54923721)
-- Name: organisation organisation_parent_id_fkey; Type: FK CONSTRAINT; Schema: metadata; Owner: glosis
--

ALTER TABLE ONLY metadata.organisation
    ADD CONSTRAINT organisation_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES metadata.organisation(organisation_id);


--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 9
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 5026 (class 0 OID 0)
-- Dependencies: 274
-- Name: TABLE category_desc; Type: ACL; Schema: core; Owner: glosis
--

GRANT SELECT ON TABLE core.category_desc TO glosis_r;


--
-- TOC entry 5034 (class 0 OID 0)
-- Dependencies: 275
-- Name: TABLE languages; Type: ACL; Schema: core; Owner: glosis
--

GRANT SELECT ON TABLE core.languages TO glosis_r;


--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 277
-- Name: TABLE profiles; Type: ACL; Schema: core; Owner: glosis
--

GRANT SELECT ON TABLE core.profiles TO glosis_r;


--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 273
-- Name: TABLE property_desc; Type: ACL; Schema: core; Owner: glosis
--

GRANT SELECT ON TABLE core.property_desc TO glosis_r;


--
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 272
-- Name: TABLE result_spectrum; Type: ACL; Schema: core; Owner: glosis
--

GRANT SELECT ON TABLE core.result_spectrum TO glosis_r;


--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 276
-- Name: TABLE translate; Type: ACL; Schema: core; Owner: glosis
--

GRANT SELECT ON TABLE core.translate TO glosis_r;


--
-- TOC entry 3428 (class 826 OID 54924147)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: core; Owner: glosis
--

ALTER DEFAULT PRIVILEGES FOR ROLE glosis IN SCHEMA core GRANT SELECT ON TABLES TO glosis_r;


--
-- TOC entry 3429 (class 826 OID 54924148)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: metadata; Owner: glosis
--

ALTER DEFAULT PRIVILEGES FOR ROLE glosis IN SCHEMA metadata GRANT SELECT ON TABLES TO glosis_r;


-- Completed on 2025-08-22 14:19:45 CEST

--
-- PostgreSQL database dump complete
--

