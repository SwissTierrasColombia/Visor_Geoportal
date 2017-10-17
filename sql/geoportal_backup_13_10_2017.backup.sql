--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: geoportal; Type: SCHEMA; Schema: -; Owner: geoportal_user
--

CREATE SCHEMA geoportal;


ALTER SCHEMA geoportal OWNER TO geoportal_user;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET search_path = geoportal, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: alert_geom_line; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE alert_geom_line (
    id_geom integer NOT NULL,
    the_geom public.geometry(LineString,4326)
);


ALTER TABLE alert_geom_line OWNER TO geoportal_user;

--
-- Name: alert_geom_point; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE alert_geom_point (
    id_geom integer NOT NULL,
    the_geom public.geometry(Point,4326)
);


ALTER TABLE alert_geom_point OWNER TO geoportal_user;

--
-- Name: alert_geom_polygon; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE alert_geom_polygon (
    id_geom integer NOT NULL,
    the_geom public.geometry(Polygon,4326)
);


ALTER TABLE alert_geom_polygon OWNER TO geoportal_user;

--
-- Name: alert_geoms; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE alert_geoms
    START WITH 55
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE alert_geoms OWNER TO geoportal_user;

--
-- Name: alerts; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE alerts (
    id_alert integer NOT NULL,
    id_user integer,
    title character varying,
    description character varying NOT NULL,
    c_status_curr character varying(1) NOT NULL,
    id_alert_type integer NOT NULL,
    insert_time timestamp without time zone,
    geometry_type character varying NOT NULL,
    id_geom integer NOT NULL,
    reference_code character varying,
    submitter_name character varying,
    submitter_email character varying,
    dep_name character varying,
    dep_cod character varying,
    inserted_by_muni_name character varying,
    inserted_by_muni_cod character varying,
    from_sit_muni boolean DEFAULT false NOT NULL,
    date_event date,
    phone_num character varying,
    mobile_num character varying
);


ALTER TABLE alerts OWNER TO geoportal_user;

--
-- Name: alert_id_alert_seq; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE alert_id_alert_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE alert_id_alert_seq OWNER TO geoportal_user;

--
-- Name: alert_id_alert_seq; Type: SEQUENCE OWNED BY; Schema: geoportal; Owner: geoportal_user
--

ALTER SEQUENCE alert_id_alert_seq OWNED BY alerts.id_alert;


--
-- Name: alert_status; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE alert_status (
    c_status character varying(1) NOT NULL,
    name character varying
);


ALTER TABLE alert_status OWNER TO geoportal_user;

--
-- Name: alert_status_history; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE alert_status_history (
    id_alert integer,
    c_status character varying(1),
    date_change timestamp without time zone,
    id_history integer NOT NULL,
    note character varying
);


ALTER TABLE alert_status_history OWNER TO geoportal_user;

--
-- Name: alert_status_history_id_history_seq; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE alert_status_history_id_history_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE alert_status_history_id_history_seq OWNER TO geoportal_user;

--
-- Name: alert_status_history_id_history_seq; Type: SEQUENCE OWNED BY; Schema: geoportal; Owner: geoportal_user
--

ALTER SEQUENCE alert_status_history_id_history_seq OWNED BY alert_status_history.id_history;


--
-- Name: alert_types; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE alert_types (
    id_alert_type integer NOT NULL,
    name character varying,
    key character varying
);


ALTER TABLE alert_types OWNER TO geoportal_user;

--
-- Name: alert_types_id_alert_type_seq; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE alert_types_id_alert_type_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE alert_types_id_alert_type_seq OWNER TO geoportal_user;

--
-- Name: alert_types_id_alert_type_seq; Type: SEQUENCE OWNED BY; Schema: geoportal; Owner: geoportal_user
--

ALTER SEQUENCE alert_types_id_alert_type_seq OWNED BY alert_types.id_alert_type;


--
-- Name: alerts_intersections; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE alerts_intersections (
    id integer NOT NULL,
    name character varying NOT NULL,
    id_layer integer,
    key_column_name character varying,
    desc_column_name character varying,
    geom_column_name character varying,
    active boolean DEFAULT false NOT NULL,
    CONSTRAINT ck_alerts_intersections CHECK ((((active = true) AND (id_layer IS NOT NULL) AND (key_column_name IS NOT NULL) AND (desc_column_name IS NOT NULL) AND (geom_column_name IS NOT NULL)) OR (active = false)))
);


ALTER TABLE alerts_intersections OWNER TO geoportal_user;

--
-- Name: alerts_intersections_id_seq; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE alerts_intersections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE alerts_intersections_id_seq OWNER TO geoportal_user;

--
-- Name: alerts_intersections_id_seq; Type: SEQUENCE OWNED BY; Schema: geoportal; Owner: geoportal_user
--

ALTER SEQUENCE alerts_intersections_id_seq OWNED BY alerts_intersections.id;


--
-- Name: alerts_settings; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE alerts_settings (
    id integer NOT NULL,
    key character varying NOT NULL,
    value character varying NOT NULL
);


ALTER TABLE alerts_settings OWNER TO geoportal_user;

--
-- Name: alerts_settings_id_seq; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE alerts_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE alerts_settings_id_seq OWNER TO geoportal_user;

--
-- Name: alerts_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: geoportal; Owner: geoportal_user
--

ALTER SEQUENCE alerts_settings_id_seq OWNED BY alerts_settings.id;


--
-- Name: comments; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE comments (
    id_comment integer NOT NULL,
    id_user integer NOT NULL,
    value character varying
);


ALTER TABLE comments OWNER TO geoportal_user;

--
-- Name: comments_p_comment_seq; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE comments_p_comment_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comments_p_comment_seq OWNER TO geoportal_user;

--
-- Name: comments_p_comment_seq; Type: SEQUENCE OWNED BY; Schema: geoportal; Owner: geoportal_user
--

ALTER SEQUENCE comments_p_comment_seq OWNED BY comments.id_comment;


--
-- Name: departments_permissions_mapping; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE departments_permissions_mapping (
    id integer NOT NULL,
    c_permission character varying NOT NULL,
    identif_value character varying NOT NULL
);


ALTER TABLE departments_permissions_mapping OWNER TO geoportal_user;

--
-- Name: departments_permissions_mapping_id_seq; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE departments_permissions_mapping_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE departments_permissions_mapping_id_seq OWNER TO geoportal_user;

--
-- Name: departments_permissions_mapping_id_seq; Type: SEQUENCE OWNED BY; Schema: geoportal; Owner: geoportal_user
--

ALTER SEQUENCE departments_permissions_mapping_id_seq OWNED BY departments_permissions_mapping.id;


--
-- Name: general_settings; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE general_settings (
    id integer NOT NULL,
    key character varying NOT NULL,
    value character varying NOT NULL
);


ALTER TABLE general_settings OWNER TO geoportal_user;

--
-- Name: general_settings_id_seq; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE general_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE general_settings_id_seq OWNER TO geoportal_user;

--
-- Name: general_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: geoportal; Owner: geoportal_user
--

ALTER SEQUENCE general_settings_id_seq OWNED BY general_settings.id;


--
-- Name: layerconfigs; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE layerconfigs (
    id_layer_config integer NOT NULL,
    s_options json,
    s_ol_options json,
    s_cache_url character varying,
    cache_enabled boolean DEFAULT false NOT NULL,
    s_sld_url character varying,
    sld_override boolean DEFAULT false NOT NULL,
    s_cache_workspace character varying,
    attr_mapping text
);


ALTER TABLE layerconfigs OWNER TO geoportal_user;

--
-- Name: layer_config_id_layer_config_seq; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE layer_config_id_layer_config_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE layer_config_id_layer_config_seq OWNER TO geoportal_user;

--
-- Name: layer_config_id_layer_config_seq; Type: SEQUENCE OWNED BY; Schema: geoportal; Owner: geoportal_user
--

ALTER SEQUENCE layer_config_id_layer_config_seq OWNED BY layerconfigs.id_layer_config;


--
-- Name: layers; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE layers (
    id_layer integer NOT NULL,
    s_name character varying NOT NULL,
    s_title character varying NOT NULL,
    s_description character varying,
    id_layersource integer,
    s_mode character varying DEFAULT 'single'::character varying NOT NULL,
    id_layer_type integer NOT NULL,
    id_layer_config integer,
    base_layer boolean DEFAULT false NOT NULL,
    s_attribute_name_for_info character varying,
    reference_layer_for_alerts boolean DEFAULT false NOT NULL,
    s_responsible character varying,
    external boolean DEFAULT false NOT NULL,
    f_wfs_search_enabled boolean DEFAULT false NOT NULL,
    s_reference_date character varying,
    s_metadata_uuid character varying,
    s_wfs_url character varying,
    s_wcs_url character varying,
    downloadable boolean DEFAULT false NOT NULL,
    f_show_info_dialog boolean DEFAULT true NOT NULL
);


ALTER TABLE layers OWNER TO geoportal_user;

--
-- Name: layersources; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE layersources (
    id_layersource integer NOT NULL,
    s_url character varying,
    s_layersource_name character varying,
    s_layersource_description character varying,
    s_cache_url character varying,
    enabled_external_wms_list boolean DEFAULT false
);


ALTER TABLE layersources OWNER TO geoportal_user;

--
-- Name: layer_config_vw; Type: VIEW; Schema: geoportal; Owner: geoportal_user
--

CREATE VIEW layer_config_vw AS
 SELECT l.id_layer,
    l.s_name,
    l.s_title,
    l.s_description,
    l.id_layersource,
    sources.s_layersource_name,
    l.s_mode,
    l.base_layer,
    l.id_layer_type,
    l.s_attribute_name_for_info,
    l.s_reference_date,
    l.s_responsible,
    l.s_metadata_uuid,
    l.external,
    l.downloadable,
    l.f_wfs_search_enabled,
    l.s_wfs_url,
    l.s_wcs_url,
    l.f_show_info_dialog,
    conf.id_layer_config,
    conf.s_options,
    conf.s_ol_options,
    conf.s_cache_url,
    conf.s_cache_workspace,
    conf.cache_enabled,
    conf.s_sld_url,
    conf.sld_override
   FROM ((layers l
     LEFT JOIN layerconfigs conf ON ((l.id_layer_config = conf.id_layer_config)))
     LEFT JOIN layersources sources ON ((sources.id_layersource = l.id_layersource)))
  ORDER BY l.s_name;


ALTER TABLE layer_config_vw OWNER TO geoportal_user;

--
-- Name: layergroups; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE layergroups (
    id_layergroup integer NOT NULL,
    s_name character varying NOT NULL,
    id_map integer NOT NULL,
    "position" integer,
    background boolean DEFAULT false NOT NULL
);


ALTER TABLE layergroups OWNER TO geoportal_user;

--
-- Name: layer_group_id_layer_group_seq; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE layer_group_id_layer_group_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE layer_group_id_layer_group_seq OWNER TO geoportal_user;

--
-- Name: layer_group_id_layer_group_seq; Type: SEQUENCE OWNED BY; Schema: geoportal; Owner: geoportal_user
--

ALTER SEQUENCE layer_group_id_layer_group_seq OWNED BY layergroups.id_layergroup;


--
-- Name: layer_id_layer_seq; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE layer_id_layer_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE layer_id_layer_seq OWNER TO geoportal_user;

--
-- Name: layer_id_layer_seq; Type: SEQUENCE OWNED BY; Schema: geoportal; Owner: geoportal_user
--

ALTER SEQUENCE layer_id_layer_seq OWNED BY layersources.id_layersource;


--
-- Name: layer_id_layer_seq1; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE layer_id_layer_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE layer_id_layer_seq1 OWNER TO geoportal_user;

--
-- Name: layer_id_layer_seq1; Type: SEQUENCE OWNED BY; Schema: geoportal; Owner: geoportal_user
--

ALTER SEQUENCE layer_id_layer_seq1 OWNED BY layers.id_layer;


--
-- Name: layer_types; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE layer_types (
    id_layer_type integer NOT NULL,
    s_type_name character varying NOT NULL
);


ALTER TABLE layer_types OWNER TO geoportal_user;

--
-- Name: layer_type_id_layer_type_seq; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE layer_type_id_layer_type_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE layer_type_id_layer_type_seq OWNER TO geoportal_user;

--
-- Name: layer_type_id_layer_type_seq; Type: SEQUENCE OWNED BY; Schema: geoportal; Owner: geoportal_user
--

ALTER SEQUENCE layer_type_id_layer_type_seq OWNED BY layer_types.id_layer_type;


--
-- Name: layergroups_layers; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE layergroups_layers (
    id_layergroup integer NOT NULL,
    id_layer integer NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    "position" integer NOT NULL
);


ALTER TABLE layergroups_layers OWNER TO geoportal_user;

--
-- Name: logs; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE logs (
    id_log integer NOT NULL,
    id_user integer,
    operation character varying,
    description character varying,
    operation_time timestamp without time zone,
    context character varying
);


ALTER TABLE logs OWNER TO geoportal_user;

--
-- Name: logs_id_log_seq1; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE logs_id_log_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logs_id_log_seq1 OWNER TO geoportal_user;

--
-- Name: logs_id_log_seq1; Type: SEQUENCE OWNED BY; Schema: geoportal; Owner: geoportal_user
--

ALTER SEQUENCE logs_id_log_seq1 OWNED BY logs.id_log;


--
-- Name: map_config_vw; Type: VIEW; Schema: geoportal; Owner: geoportal_user
--

CREATE VIEW map_config_vw AS
 SELECT lg.id_layergroup,
    lg.s_name AS layergroup_name,
    lg."position" AS layergroup_position,
    lg.id_map,
    lg.background,
    lgl."position",
    lgl.enabled,
    COALESCE(l.id_layer, 0) AS id_layer,
    l.s_name,
    l.s_title,
    l.s_description,
    l.id_layersource,
    sources.s_layersource_name,
    l.s_mode,
    l.base_layer,
    l.id_layer_type,
    conf.id_layer_config,
    conf.s_options,
    conf.s_ol_options,
    conf.s_cache_url,
    conf.cache_enabled
   FROM ((((layergroups lg
     LEFT JOIN layergroups_layers lgl ON ((lg.id_layergroup = lgl.id_layergroup)))
     LEFT JOIN layers l ON ((l.id_layer = lgl.id_layer)))
     LEFT JOIN layerconfigs conf ON ((l.id_layer_config = conf.id_layer_config)))
     LEFT JOIN layersources sources ON ((sources.id_layersource = l.id_layersource)))
  ORDER BY lg.id_map, lg.id_layergroup, lgl."position";


ALTER TABLE map_config_vw OWNER TO geoportal_user;

--
-- Name: maps; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE maps (
    id_map integer NOT NULL,
    s_name character varying NOT NULL,
    s_projection character varying NOT NULL,
    s_units character varying NOT NULL,
    f_show_overview boolean DEFAULT false NOT NULL,
    j_custom_scales json,
    d_dots_per_inch_override double precision,
    j_custom_resolutions json,
    custom_scales_resolutions character varying,
    f_maxscale double precision,
    f_default_extent_minx double precision NOT NULL,
    f_default_extent_miny double precision NOT NULL,
    f_default_extent_maxx double precision NOT NULL,
    f_default_extent_maxy double precision NOT NULL,
    thumbnail text
);


ALTER TABLE maps OWNER TO geoportal_user;

--
-- Name: map_id_map_seq; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE map_id_map_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE map_id_map_seq OWNER TO geoportal_user;

--
-- Name: map_id_map_seq; Type: SEQUENCE OWNED BY; Schema: geoportal; Owner: geoportal_user
--

ALTER SEQUENCE map_id_map_seq OWNED BY maps.id_map;


--
-- Name: modules_id_module_seq; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE modules_id_module_seq
    START WITH 18
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE modules_id_module_seq OWNER TO geoportal_user;

--
-- Name: permissions; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE permissions (
    id_permission integer NOT NULL,
    c_permission character varying(50) NOT NULL,
    description character varying(50),
    description_en character varying,
    description_es character varying
);


ALTER TABLE permissions OWNER TO geoportal_user;

--
-- Name: redlining_line; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE redlining_line (
    id_redlining integer NOT NULL,
    id_user integer,
    type character varying(1),
    label character varying,
    geometry character varying,
    the_geom public.geometry(LineString,4326)
);


ALTER TABLE redlining_line OWNER TO geoportal_user;

--
-- Name: redlining_line_id_redlining_seq; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE redlining_line_id_redlining_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE redlining_line_id_redlining_seq OWNER TO geoportal_user;

--
-- Name: redlining_line_id_redlining_seq; Type: SEQUENCE OWNED BY; Schema: geoportal; Owner: geoportal_user
--

ALTER SEQUENCE redlining_line_id_redlining_seq OWNED BY redlining_line.id_redlining;


--
-- Name: redlining_point; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE redlining_point (
    id_redlining integer NOT NULL,
    id_user integer,
    type character varying(1),
    label character varying,
    geometry character varying,
    the_geom public.geometry(Point,4326)
);


ALTER TABLE redlining_point OWNER TO geoportal_user;

--
-- Name: redlining_point_id_redlining_seq; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE redlining_point_id_redlining_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE redlining_point_id_redlining_seq OWNER TO geoportal_user;

--
-- Name: redlining_point_id_redlining_seq; Type: SEQUENCE OWNED BY; Schema: geoportal; Owner: geoportal_user
--

ALTER SEQUENCE redlining_point_id_redlining_seq OWNED BY redlining_point.id_redlining;


--
-- Name: redlining_polygon; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE redlining_polygon (
    id_redlining integer NOT NULL,
    id_user integer,
    type character varying(1),
    label character varying,
    geometry character varying,
    the_geom public.geometry(Polygon,4326)
);


ALTER TABLE redlining_polygon OWNER TO geoportal_user;

--
-- Name: redlining_polygon_id_redlining_seq; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE redlining_polygon_id_redlining_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE redlining_polygon_id_redlining_seq OWNER TO geoportal_user;

--
-- Name: redlining_polygon_id_redlining_seq; Type: SEQUENCE OWNED BY; Schema: geoportal; Owner: geoportal_user
--

ALTER SEQUENCE redlining_polygon_id_redlining_seq OWNED BY redlining_polygon.id_redlining;


--
-- Name: redlining_redlining_seq; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE redlining_redlining_seq
    START WITH 273
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE redlining_redlining_seq OWNER TO geoportal_user;

--
-- Name: role_permission; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE role_permission (
    id_role integer NOT NULL,
    id_permission integer NOT NULL
);


ALTER TABLE role_permission OWNER TO geoportal_user;

--
-- Name: roles; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE roles (
    id_role integer NOT NULL,
    role_name character varying NOT NULL,
    description character varying
);


ALTER TABLE roles OWNER TO geoportal_user;

--
-- Name: roles_id_role_seq; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE roles_id_role_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE roles_id_role_seq OWNER TO geoportal_user;

--
-- Name: roles_id_role_seq; Type: SEQUENCE OWNED BY; Schema: geoportal; Owner: geoportal_user
--

ALTER SEQUENCE roles_id_role_seq OWNED BY roles.id_role;


--
-- Name: system_settings; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE system_settings (
    id integer NOT NULL,
    key character varying NOT NULL,
    value character varying NOT NULL
);


ALTER TABLE system_settings OWNER TO geoportal_user;

--
-- Name: system_settings_id_system_setting_seq; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE system_settings_id_system_setting_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE system_settings_id_system_setting_seq OWNER TO geoportal_user;

--
-- Name: system_settings_id_system_setting_seq; Type: SEQUENCE OWNED BY; Schema: geoportal; Owner: geoportal_user
--

ALTER SEQUENCE system_settings_id_system_setting_seq OWNED BY system_settings.id;


--
-- Name: users; Type: TABLE; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE TABLE users (
    id_user integer NOT NULL,
    password_old character varying(20),
    username character varying(20) NOT NULL,
    id_role integer,
    f_disabled boolean DEFAULT false NOT NULL,
    f_deleted boolean DEFAULT false NOT NULL,
    password_hash character varying,
    CONSTRAINT chk_users_id_role_f_deleted CHECK ((((f_deleted = true) AND (id_role IS NULL)) OR ((f_deleted = false) AND (id_role IS NOT NULL))))
);


ALTER TABLE users OWNER TO geoportal_user;

--
-- Name: users_id_user_seq1; Type: SEQUENCE; Schema: geoportal; Owner: geoportal_user
--

CREATE SEQUENCE users_id_user_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_user_seq1 OWNER TO geoportal_user;

--
-- Name: users_id_user_seq1; Type: SEQUENCE OWNED BY; Schema: geoportal; Owner: geoportal_user
--

ALTER SEQUENCE users_id_user_seq1 OWNED BY users.id_user;


--
-- Name: vw_alerts; Type: VIEW; Schema: geoportal; Owner: geoportal_user
--

CREATE VIEW vw_alerts AS
 SELECT a.id_alert,
    a.id_alert_type,
    at.name AS type_name,
    a.geometry_type,
    a.id_user,
    a.title,
    a.description,
    a.reference_code,
    a.submitter_name,
    a.submitter_email,
    a.insert_time,
    a.date_event,
    a.phone_num,
    a.mobile_num,
    a.c_status_curr,
    a.dep_name,
    a.dep_cod,
    a.inserted_by_muni_name,
    a.inserted_by_muni_cod,
    a.from_sit_muni,
    als.name AS status_curr_name,
        CASE a.geometry_type
            WHEN 'point'::text THEN public.st_astext(gp.the_geom)
            ELSE NULL::text
        END AS wkt_geometry,
    last_modified_status.date_change
   FROM ((((alerts a
     JOIN alert_types at ON ((a.id_alert_type = at.id_alert_type)))
     JOIN alert_status als ON (((als.c_status)::text = (a.c_status_curr)::text)))
     JOIN alert_geom_point gp ON ((gp.id_geom = a.id_geom)))
     LEFT JOIN ( SELECT ash.id_alert,
            ash.c_status,
            ash.date_change,
            ash.id_history,
            ash.note
           FROM (alert_status_history ash
             JOIN ( SELECT alert_status_history.id_alert,
                    max(alert_status_history.date_change) AS last_update
                   FROM alert_status_history
                  GROUP BY alert_status_history.id_alert) a_1 ON (((a_1.id_alert = ash.id_alert) AND (a_1.last_update = ash.date_change))))) last_modified_status ON ((last_modified_status.id_alert = a.id_alert)));


ALTER TABLE vw_alerts OWNER TO geoportal_user;

--
-- Name: vw_alerts_publish; Type: VIEW; Schema: geoportal; Owner: geoportal_user
--

CREATE VIEW vw_alerts_publish AS
 SELECT vw_alerts.id_alert,
    vw_alerts.id_alert_type,
    vw_alerts.reference_code,
    vw_alerts.type_name,
    vw_alerts.title,
    vw_alerts.description,
    vw_alerts.submitter_name,
    vw_alerts.submitter_email,
    vw_alerts.date_event,
    vw_alerts.phone_num,
    vw_alerts.mobile_num,
    vw_alerts.insert_time,
    vw_alerts.c_status_curr,
    vw_alerts.dep_name,
    vw_alerts.dep_cod,
    vw_alerts.inserted_by_muni_name,
    vw_alerts.inserted_by_muni_cod,
    vw_alerts.from_sit_muni,
    vw_alerts.status_curr_name,
    (public.st_geomfromtext(vw_alerts.wkt_geometry, 4326))::public.geometry(Geometry,4326) AS st_geomfromtext
   FROM vw_alerts;


ALTER TABLE vw_alerts_publish OWNER TO geoportal_user;

--
-- Name: vw_alerts_sit_read; Type: VIEW; Schema: geoportal; Owner: geoportal_user
--

CREATE VIEW vw_alerts_sit_read AS
 SELECT vw_alerts.id_alert,
    vw_alerts.id_alert_type,
    vw_alerts.reference_code,
    vw_alerts.type_name,
    vw_alerts.title,
    vw_alerts.description,
    vw_alerts.submitter_name,
    vw_alerts.submitter_email,
    vw_alerts.date_event,
    vw_alerts.phone_num,
    vw_alerts.mobile_num,
    vw_alerts.insert_time,
    vw_alerts.c_status_curr,
    vw_alerts.dep_name,
    vw_alerts.dep_cod,
    vw_alerts.inserted_by_muni_name,
    vw_alerts.inserted_by_muni_cod,
    vw_alerts.from_sit_muni,
    vw_alerts.status_curr_name,
    vw_alerts.wkt_geometry,
    (public.st_geomfromtext(vw_alerts.wkt_geometry, 4326))::public.geometry(Geometry,4326) AS st_geomfromtext
   FROM vw_alerts;


ALTER TABLE vw_alerts_sit_read OWNER TO geoportal_user;

--
-- Name: vw_alerts_test; Type: VIEW; Schema: geoportal; Owner: geoportal_user
--

CREATE VIEW vw_alerts_test AS
 SELECT a.id_alert,
    a.id_alert_type,
    at.name AS type_name,
    a.geometry_type,
    a.id_user,
    a.title,
    a.description,
    a.insert_time,
    a.c_status_curr,
    als.name AS status_curr_name,
        CASE a.geometry_type
            WHEN 'point'::text THEN gp.the_geom
            WHEN 'line'::text THEN gl.the_geom
            WHEN 'polygon'::text THEN gpol.the_geom
            ELSE NULL::public.geometry
        END AS geometry
   FROM (((((alerts a
     JOIN alert_types at ON ((a.id_alert_type = at.id_alert_type)))
     JOIN alert_status als ON (((als.c_status)::text = (a.c_status_curr)::text)))
     LEFT JOIN alert_geom_point gp ON ((gp.id_geom = a.id_geom)))
     LEFT JOIN alert_geom_line gl ON ((gl.id_geom = a.id_geom)))
     LEFT JOIN alert_geom_polygon gpol ON ((gpol.id_geom = a.id_geom)));


ALTER TABLE vw_alerts_test OWNER TO geoportal_user;

--
-- Name: id_history; Type: DEFAULT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY alert_status_history ALTER COLUMN id_history SET DEFAULT nextval('alert_status_history_id_history_seq'::regclass);


--
-- Name: id_alert_type; Type: DEFAULT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY alert_types ALTER COLUMN id_alert_type SET DEFAULT nextval('alert_types_id_alert_type_seq'::regclass);


--
-- Name: id_alert; Type: DEFAULT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY alerts ALTER COLUMN id_alert SET DEFAULT nextval('alert_id_alert_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY alerts_intersections ALTER COLUMN id SET DEFAULT nextval('alerts_intersections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY alerts_settings ALTER COLUMN id SET DEFAULT nextval('alerts_settings_id_seq'::regclass);


--
-- Name: id_comment; Type: DEFAULT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY comments ALTER COLUMN id_comment SET DEFAULT nextval('comments_p_comment_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY departments_permissions_mapping ALTER COLUMN id SET DEFAULT nextval('departments_permissions_mapping_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY general_settings ALTER COLUMN id SET DEFAULT nextval('general_settings_id_seq'::regclass);


--
-- Name: id_layer_type; Type: DEFAULT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY layer_types ALTER COLUMN id_layer_type SET DEFAULT nextval('layer_type_id_layer_type_seq'::regclass);


--
-- Name: id_layer_config; Type: DEFAULT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY layerconfigs ALTER COLUMN id_layer_config SET DEFAULT nextval('layer_config_id_layer_config_seq'::regclass);


--
-- Name: id_layergroup; Type: DEFAULT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY layergroups ALTER COLUMN id_layergroup SET DEFAULT nextval('layer_group_id_layer_group_seq'::regclass);


--
-- Name: id_layer; Type: DEFAULT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY layers ALTER COLUMN id_layer SET DEFAULT nextval('layer_id_layer_seq1'::regclass);


--
-- Name: id_layersource; Type: DEFAULT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY layersources ALTER COLUMN id_layersource SET DEFAULT nextval('layer_id_layer_seq'::regclass);


--
-- Name: id_log; Type: DEFAULT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY logs ALTER COLUMN id_log SET DEFAULT nextval('logs_id_log_seq1'::regclass);


--
-- Name: id_map; Type: DEFAULT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY maps ALTER COLUMN id_map SET DEFAULT nextval('map_id_map_seq'::regclass);


--
-- Name: id_redlining; Type: DEFAULT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY redlining_line ALTER COLUMN id_redlining SET DEFAULT nextval('redlining_line_id_redlining_seq'::regclass);


--
-- Name: id_redlining; Type: DEFAULT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY redlining_point ALTER COLUMN id_redlining SET DEFAULT nextval('redlining_point_id_redlining_seq'::regclass);


--
-- Name: id_redlining; Type: DEFAULT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY redlining_polygon ALTER COLUMN id_redlining SET DEFAULT nextval('redlining_polygon_id_redlining_seq'::regclass);


--
-- Name: id_role; Type: DEFAULT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY roles ALTER COLUMN id_role SET DEFAULT nextval('roles_id_role_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY system_settings ALTER COLUMN id SET DEFAULT nextval('system_settings_id_system_setting_seq'::regclass);


--
-- Name: id_user; Type: DEFAULT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY users ALTER COLUMN id_user SET DEFAULT nextval('users_id_user_seq1'::regclass);


--
-- Data for Name: alert_geom_line; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY alert_geom_line (id_geom, the_geom) FROM stdin;
\.


--
-- Data for Name: alert_geom_point; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY alert_geom_point (id_geom, the_geom) FROM stdin;
253	0101000020E61000001559A3D98FAD55C00930D71643752C40
\.


--
-- Data for Name: alert_geom_polygon; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY alert_geom_polygon (id_geom, the_geom) FROM stdin;
\.


--
-- Name: alert_geoms; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('alert_geoms', 253, true);


--
-- Name: alert_id_alert_seq; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('alert_id_alert_seq', 212, true);


--
-- Data for Name: alert_status; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY alert_status (c_status, name) FROM stdin;
R	Rechazado
I	Ingresado
S	En seguimiento
C	Comprobado
\.


--
-- Data for Name: alert_status_history; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY alert_status_history (id_alert, c_status, date_change, id_history, note) FROM stdin;
\.


--
-- Name: alert_status_history_id_history_seq; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('alert_status_history_id_history_seq', 77, true);


--
-- Data for Name: alert_types; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY alert_types (id_alert_type, name, key) FROM stdin;
1	Incendios	\N
2	Tala ilegal	
3	Plagas forestales	\N
11	A	\N
\.


--
-- Name: alert_types_id_alert_type_seq; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('alert_types_id_alert_type_seq', 11, true);


--
-- Data for Name: alerts; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY alerts (id_alert, id_user, title, description, c_status_curr, id_alert_type, insert_time, geometry_type, id_geom, reference_code, submitter_name, submitter_email, dep_name, dep_cod, inserted_by_muni_name, inserted_by_muni_cod, from_sit_muni, date_event, phone_num, mobile_num) FROM stdin;
212	40	\N		I	1	2015-05-27 09:46:03.56	point	253	GGff8QJ			El Paraiso	7		715	t	0032-11-04		
\.


--
-- Data for Name: alerts_intersections; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY alerts_intersections (id, name, id_layer, key_column_name, desc_column_name, geom_column_name, active) FROM stdin;
3	MUNICIPALITIES	55	cod_mun_	nombre	geom	t
2	DEPARTMENTS	54	dep	depto	geom	t
\.


--
-- Name: alerts_intersections_id_seq; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('alerts_intersections_id_seq', 4, true);


--
-- Data for Name: alerts_settings; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY alerts_settings (id, key, value) FROM stdin;
2	ALERTS_ADDED_NOTE_MESSAGE	
\.


--
-- Name: alerts_settings_id_seq; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('alerts_settings_id_seq', 2, true);


--
-- Data for Name: comments; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY comments (id_comment, id_user, value) FROM stdin;
\.


--
-- Name: comments_p_comment_seq; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('comments_p_comment_seq', 1, true);


--
-- Data for Name: departments_permissions_mapping; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY departments_permissions_mapping (id, c_permission, identif_value) FROM stdin;
1	ALERTS_EDIT_DEP_ATLANTIDA	1
2	ALERTS_EDIT_DEP_COMAYAGUA	3
3	ALERTS_EDIT_DEP_COPAN	4
4	ALERTS_EDIT_DEP_ELPARAISO	7
5	ALERTS_EDIT_DEP_FMORAZAN	8
6	ALERTS_EDIT_DEP_INTIBUCA	10
7	ALERTS_EDIT_DEP_LAPAZ	12
8	ALERTS_EDIT_DEP_LEMPIRA	13
9	ALERTS_EDIT_DEP_SANTABARBARA	16
10	ALERTS_EDIT_DEP_OLANCHO	15
11	ALERTS_EDIT_DEP_YORO	18
12	ALERTS_EDIT_DEP_ISLASBAHIA	11
13	ALERTS_EDIT_DEP_VALLE	17
14	ALERTS_EDIT_DEP_GRACIASDIOS	9
15	ALERTS_EDIT_DEP_CHOLUTECA	6
16	ALERTS_EDIT_DEP_COLON	2
17	ALERTS_EDIT_DEP_CORTEZ	5
18	ALERTS_EDIT_DEP_OCOTEPEQUE	14
\.


--
-- Name: departments_permissions_mapping_id_seq; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('departments_permissions_mapping_id_seq', 18, true);


--
-- Data for Name: general_settings; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY general_settings (id, key, value) FROM stdin;
1	INITIAL_MESSAGE	Bienvenidos al Geoportal de la IDE para la Administracion de Tierras (piloto)
2	SHOW_INITIAL_MESSAGE	false
3	INFORMATION_MESSAGE	<p>Geoportal de la IDE para la Administracion de Tierras (piloto)</p>
4	SHOW_INFORMATION_MESSAGE	true
\.


--
-- Name: general_settings_id_seq; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('general_settings_id_seq', 4, true);


--
-- Name: layer_config_id_layer_config_seq; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('layer_config_id_layer_config_seq', 87, true);


--
-- Name: layer_group_id_layer_group_seq; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('layer_group_id_layer_group_seq', 54, true);


--
-- Name: layer_id_layer_seq; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('layer_id_layer_seq', 27, true);


--
-- Name: layer_id_layer_seq1; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('layer_id_layer_seq1', 110, true);


--
-- Name: layer_type_id_layer_type_seq; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('layer_type_id_layer_type_seq', 4, true);


--
-- Data for Name: layer_types; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY layer_types (id_layer_type, s_type_name) FROM stdin;
1	wms
2	google
3	osm
4	bing
5	mapquest
\.


--
-- Data for Name: layerconfigs; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY layerconfigs (id_layer_config, s_options, s_ol_options, s_cache_url, cache_enabled, s_sld_url, sld_override, s_cache_workspace, attr_mapping) FROM stdin;
3	{"format": "image/png8","transparent" : true}	{"buffer": 0,"displayOutsideMaxExtent": true,"isBaseLayer": false,"singleTile": false}	\N	f	\N	f	\N	\N
4	{"format": "image/png8","transparent" : true}	{"buffer": 0,"displayOutsideMaxExtent": true,"isBaseLayer": false,"singleTile": false}	\N	f	\N	f	\N	\N
5	{"format": "image/png8","transparent" : true}	{"buffer": 0,"displayOutsideMaxExtent": true,"isBaseLayer": false,"singleTile": false,"opacity" : 0.5}	\N	f	\N	f	\N	\N
17	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0}		f	\N	f	\N	\N
28	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	t		f	icf	\N
18	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0}		f	\N	f	\N	\N
16	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0}		f	\N	f	\N	\N
15	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0}		f	\N	f	\N	\N
27	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	t		f	icf	\N
26	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	t		f	icf	\N
25	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	t		f	icf	\N
24	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	t		f	icf	\N
11	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0}		f	\N	f	\N	\N
23	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	t		f	icf	\N
14	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}		f	\N	f	\N	\N
22	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	t		f	icf	\N
21	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	t		f	icf	\N
13	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}		f		f	\N	\N
20	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	t		f	icf	\N
6	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	f		f	icf	\N
9	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":true,"singleTile":false,"opacity":0.5,"tileSize":[512,512]}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	t		f	icf	\N
51	{"format":"image/jpeg","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0}		f		f		\N
52	{"format":"image/jpeg","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0}		f		f		\N
54	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
43	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
44	{"format":"image/jpeg","transparent":false}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
45	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
46	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
47	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
48	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
30	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":0.8,"tileSize":[512,512]}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	t		f	icf	\N
8	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":0.0}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	t	\N	f	icf	\N
1	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	t		f	icf	\N
12	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	t		f	icf	\N
10	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":0.5,"tileSize":[512,512]}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	t	\N	f	icf	\N
7	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":0.4,"tileSize":[512,512]}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	t		f	icf	\N
19	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	f		f	icf	\N
2	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	t	\N	t	icf	\N
55	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	t		f	icf	\N
56	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	t		f	icf	\N
31	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	t		f	icf	\N
50	{"format":"image/jpeg","transparent":false}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":true,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}	http://geoportal.icf.gob.hn:8081/geoserver/gwc/service/wms	t		f	icf	\N
53	{"format":"image/jpeg","transparent":false}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":true,"singleTile":true,"opacity":1.0,"tileSize":[512,512]}		f		f	icf	\N
32	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0,"tileSize":[512,512]}		f		f	icf	\N
36	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0,"tileSize":[512,512]}		f		f	icf	\N
37	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0,"tileSize":[512,512]}		f		f	icf	\N
38	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0,"tileSize":[512,512]}		f		f	icf	\N
39	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}		f		f		\N
40	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0,"tileSize":[512,512]}		f		f	icf	\N
41	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0,"tileSize":[512,512]}		f		f	icf	\N
42	{"format":"image/jpeg","transparent":false}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":true,"singleTile":true,"opacity":1.0,"tileSize":[512,512]}		f		f	icf	\N
49	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0,"tileSize":[512,512]}		f		f	icf	\N
29	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":0.8,"tileSize":[512,512]}		f		f		\N
33	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}		f		f		\N
34	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}		f		f		\N
35	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}		f		f		\N
57	{"format":"image/png8","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
58	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
59	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
60	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
61	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
62	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
64	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
67	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}		f		f		\N
68	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}		f		f		\N
66	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}		f		f		\N
69	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0,"tileSize":[512,512]}		f		f		\N
73	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
70	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
71	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0}		f		f		\N
72	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
74	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[512,512]}		f		f		\N
76	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
77	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
75	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0,"tileSize":[512,512]}	https://geo.proadmintierra.info/geoserver/gwc/service/wms	f		f	interlis	\N
78	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
79	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
80	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
81	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
82	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
63	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0,"tileSize":[512,512]}		f		f		\N
83	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0}	http://geoportal-mosef.gesp.it/geoserver/gwc/service/wms	f		f		\N
84	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
85	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":true,"opacity":1.0}		f		f		\N
86	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0}		f		f		\N
65	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0,"tileSize":[256,256]}	http://geo.proadmintierra.info/geoserver/gwc/service/wms	t		f	interlis	\N
87	{"format":"image/png","transparent":true}	{"buffer":0,"displayOutsideMaxExtent":true,"isBaseLayer":false,"singleTile":false,"opacity":1.0}	http://localhost:8081/geoserver/gwc/service/wms	t		f	xxx	\N
\.


--
-- Data for Name: layergroups; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY layergroups (id_layergroup, s_name, id_map, "position", background) FROM stdin;
2	background	2	1	t
18	Cartografia	2	3	f
3	Recursos Naturales	2	5	f
34	Capas de fondo	8	1	t
42	Cartografía	8	10	f
53	ESRI	8	11	f
54	ESRI Cascaded	8	12	f
\.


--
-- Data for Name: layergroups_layers; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY layergroups_layers (id_layergroup, id_layer, enabled, "position") FROM stdin;
2	11	f	1
53	107	f	1
53	108	f	2
53	109	f	3
54	110	f	1
34	29	f	1
42	88	f	1
34	12	f	2
\.


--
-- Data for Name: layers; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY layers (id_layer, s_name, s_title, s_description, id_layersource, s_mode, id_layer_type, id_layer_config, base_layer, s_attribute_name_for_info, reference_layer_for_alerts, s_responsible, external, f_wfs_search_enabled, s_reference_date, s_metadata_uuid, s_wfs_url, s_wcs_url, downloadable, f_show_info_dialog) FROM stdin;
11	ROADMAP	Google ROADMAP	Google ROADMAP desc	\N	single	2	\N	t	\N	f	\N	f	f	\N	\N	\N	\N	f	f
12	SATELLITE	Google SATELLITE	Google SATELLITE desc	\N	single	2	\N	t	\N	f	\N	f	f	\N	\N	\N	\N	f	f
13	HYBRID	Google HYBRID	Google HYBRID desc	\N	single	2	\N	t	\N	f	\N	f	f	\N	\N	\N	\N	f	f
14	TERRAIN	Google TERRAIN	Google TERRAIN desc	\N	single	2	\N	t	\N	f	\N	f	f	\N	\N	\N	\N	f	f
15	AERIAL	Bing AERIAL	Bing AERIAL desc	\N	single	4	\N	t	\N	f	\N	f	f	\N	\N	\N	\N	f	f
16	ROAD	Bing ROAD	Bing ROAD desc	\N	single	4	\N	t	\N	f	\N	f	f	\N	\N	\N	\N	f	f
17	HYBRID	Bing HYBRID	Bing HYBRID desc	\N	single	4	\N	t	\N	f	\N	f	f	\N	\N	\N	\N	f	f
29	OSM	OSM	OSM	\N	single	3	\N	t	\N	f	\N	f	f	\N	\N	\N	\N	f	f
79	OSM	MAPQUEST OSM	MAPQUEST OSM	\N	single	5	\N	t	\N	f	\N	f	f	\N	\N	\N	\N	f	f
73	icf_fondo_forestal	Mapa Forestal	Mapa Forestal ICF	8	single	1	53	t		f	ICF	f	f					f	t
70	icf_fondo_dem	DEM	DEM	8	single	1	50	t		f	ICF	f	f				http://geoportal.icf.gob.hn:8081/geoserver/icf/wcs	f	f
52	m3101vl001970_hn	Red Vial - escala 1:50000	Red Vial - escala 1:50000	8	single	1	32	f		f	SINIT	t	f			http://geoportal.icf.gob.hn:8081/geoserver/icf/wfs		f	t
53	m2301vl001970_hn	Red Hídrica - escala 1:50000	Red Hídrica - escala 1:50000	8	single	1	33	f		f	SINIT	t	f			http://geoportal.icf.gob.hn:8081/geoserver/icf/wfs		f	t
54	m1102va001970_hn	Limites departamentales	Limites departamentales	8	single	1	34	f		t	SINIT	t	f		4a76139b-e195-464e-9851-c1ffe6c856c3	http://geoportal.icf.gob.hn:8081/geoserver/icf/wfs		t	t
56	m1105vp001988_hn	Asentamientos humanos	Asentamientos humanos	8	single	1	36	f	caserio	f	SINIT	t	t			http://geoportal.icf.gob.hn:8081/geoserver/icf/wfs		f	t
57	r1201vl001970_hn	Curvas de nivel (100m)	Curvas de nivel (100m)	8	single	1	37	f		f	SINIT	t	f			http://geoportal.icf.gob.hn:8081/geoserver/icf/wfs		f	t
58	n2303vl000000_hn	Hidrogeología	Hidrogeología	8	single	1	38	f		f	SINIT	t	f			http://geoportal.icf.gob.hn:8081/geoserver/icf/wfs		f	t
59	n2503va000000_hn	Zonas de Vida	Zonas de Vida	8	single	1	39	f		f	SINIT	t	f			http://geoportal.icf.gob.hn:8081/geoserver/icf/wfs		f	t
60	n2502va002001_hn	Ecosistemas vegetales	Ecosistemas vegetales	8	single	1	40	f	ecosistema	f	SINIT	t	f			http://geoportal.icf.gob.hn:8081/geoserver/icf/wfs		t	t
61	n2202va001973_hn	Tipo de suelos (Simmons)	Tipo de suelos (Simmons)	8	single	1	41	f	nombre_sue	f	SINIT	t	f			http://geoportal.icf.gob.hn:8081/geoserver/icf/wfs		f	t
62	honduras_base_layer	Limites Administrativos	Limites Administrativos	8	single	1	42	t		f	SINIT	f	f			http://geoportal.icf.gob.hn:8081/geoserver/icf/wfs		f	f
69	areas_protegidas	Areas Protegidas	Areas Protegidas de Honduras	8	single	1	49	f	nombre2	f	ICF	f	t		104cf197-f88e-11e4-a3e1-fc15b4ed182a	http://geoportal.icf.gob.hn:8081/geoserver/icf/wfs		t	t
55	m1103va002001_hn	Limites Municipios	Limites Municipios	8	single	1	35	f	nombre	f	SINIT	t	f			http://geoportal.icf.gob.hn:8081/geoserver/icf/wfs		f	t
80	microcuencas_16_5_32616	Microcuencas declaradas	La capa contiene datos sobre las Microcuencas declaradas legalmente.	8	single	1	57	f		f	ICF	f	f					f	f
81	Todas	Todas	Layer-Group type layer: Todas	11	single	1	58	f		f		f	f					f	f
82	idesc:mc_manzanas	Manzanas	Manzanas de la zona urbana del Municipio de Santiago de Cali. Escala 1:2000. Sistema de Coordenadas MAGNA SIRGAS. Metadato: http://idesc.cali.gov.co:8080/swami/services/reports?id=2968&type=html	12	single	1	59	f		f		f	f					f	f
83	PREDIOS_TITULADOS	PREDIOS_TITULADOS		13	single	1	60	f		f		f	f					f	f
84	6	Predial_Rural_2014		14	single	1	61	f		f		f	f					f	f
85	11	Fuentes Sismicidad Intermedia		15	single	1	62	f		f		f	f					f	f
86	GDBIDEAM.ZONIFICACION_HIDROGRAFICA_2013	Zonificación Hidrográfica de Colombia Año 2013	Servicio Web de mapas (WMS) que contiene las unidades de análisis para el ordenamiento ambiental de territorio definidas por el Ideam en convenio con el Instituto Geográfico Agustín Codazzi (IGAC), a escala 1:500.000 llamadas zonificación hidrográfica de Colombia. Estas unidades fueron modificadas por el IDEAM, generando esta versión en 2013.	16	single	1	63	f		f		f	f					f	f
87	GDBIDEAM.PARQUES_NACIONALES	Parques Nacionales de Colombia	Servicio web que muestra las areas correspondientes a los parques nacionales declarados oficialmente.	17	single	1	64	f		f		f	f					f	f
91	Corriente_de_agua	Corriente de Agua	Corrientes de Agua en la ciudad de Bogotá D.C.	18	single	1	68	f		f	IDECA	t	f					f	t
98	amenaza_inundacion	amenaza_inundacion		18	single	1	75	f		f		f	f					f	f
89	sit_interes	Sitios de Interes	Sitios de Interes de la ciudad de Bogotá D.C.	18	single	1	66	f		f	IDECA	t	f					f	t
90	cuer_agua	Cuerpo de Agua	Cuerpos de Agua en la ciudad de Bogotá D.C.	18	single	1	67	f		f	IDECA	t	f					f	t
101	vista_zonas_ot	Zonas OT		18	single	1	78	f		f		f	f					f	f
94	Corriente_de_agua	Corriente de Agua	Corrientes de Agua en la Ciudad de Bogotá D.C.	20	single	1	71	f		f	IDECA	t	f					f	t
102	curso_interlis_2017_julio_vista_predio	Curso 2017 Julio - Predios		18	single	1	79	f		f		f	f					f	f
103	curso_interlis_2017_agosto_vista_predio	Curso 2017 Agosto - Predios		18	single	1	80	f		f		f	f					f	f
97	vista_predio	Predios	Predios Práctica	18	single	1	74	f		f	AGENCIA DE IMPLEMENTACION	t	f			../geoserver/interlis/ows		f	t
104	predios_la_palma	predios_la_palma		18	single	1	81	f		f		f	f					f	f
105	ortofoto_la_palma_208IB2	ortofoto_la_palma_208IB2		23	single	1	82	f		f		f	f					f	f
107	2	Cabecera		25	single	1	84	f		f		f	f					f	f
108	28	Municipio		25	single	1	85	f		f		f	f					f	f
109	0	Ortofoto_CatastroRGB_2014-EPSG3857.img		26	single	1	86	f		f		f	f					f	f
88	mvi	Malla Vial Integral	Malla Vial de la ciudad de Bogotá D.C.	18	single	1	65	f		f	IDECA	t	f					f	t
110	catastro ESRI cascaded	catastro ESRI cascaded		27	single	1	87	f		f		f	f					f	f
\.


--
-- Data for Name: layersources; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY layersources (id_layersource, s_url, s_layersource_name, s_layersource_description, s_cache_url, enabled_external_wms_list) FROM stdin;
10	http://geoespacial.sinap.hn:8080/geoserver/wms	WMS Path 2	Nuevo servidor WMS del PATH		t
8	http://geoportal.icf.gob.hn:8081/geoserver/icf/wms	WMS Geoserver ICF	WMS Geoserver ICF		f
11	http://geocarto.igac.gov.co/geoservicios/cien_mil/wms	IGAC 100K			t
12	http://idesc.cali.gov.co:8081/geoserver/wms?	IDESC			t
13	http://190.60.226.98:6080/arcgis/services/DUT/TITULACION_PREDIAL/MapServer/WMSServer	IDECA CVP			t
15	http://srvags.sgc.gov.co/arcgis/services/Amenaza_Sismica/Amenaza_Sismica_Nacional/MapServer/WMSServer?	Servicio geológico			t
16	http://geoapps.ideam.gov.co:8080/geoserver/unidades_analisis/wms?	Zonificación hidrografica IDEAM			t
17	http://geoapps.ideam.gov.co:8080/geoserver/informacion_basica/wms	Parques			t
14	http://186.155.252.74:6080/arcgis/services/CHIA/Administrativo_T/MapServer/WMSServer	CHIA			f
19	http://geo.proadmintierra.info/geoserver/topp/wms?	prueba			f
20	http://geo.proadmintierra.info/geoserver/interlis/wms	Geoserver_publica2	Servidor practica		f
23	http://geo.proadmintierra.info/geoserver/ODK/wms	ODK la palma			f
18	http://geo.proadmintierra.info/geoserver/interlis/wms	Geoserver_publica	Servidor_practica	http://geo.proadmintierra.info/geoserver/gwc/service/wms	f
25	http://serviciosgis.catastrobogota.gov.co/arcgis/services/Mapa_Referencia/mapa_base_3857/MapServer/WMSServer	TEST ESRI	TEST ESRI		f
26	http://serviciosgis.catastrobogota.gov.co/arcgis/services/Imagenes/Ortho2014/MapServer/WMSServer	TEST ESRI 2	TEST ESRI 2		f
27	http://localhost:8081/geoserver/xxx/wms	LH	LH	http://localhost:8081/geoserver/gwc/service/wms	f
\.


--
-- Data for Name: logs; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY logs (id_log, id_user, operation, description, operation_time, context) FROM stdin;
\.


--
-- Name: logs_id_log_seq1; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('logs_id_log_seq1', 1474, true);


--
-- Name: map_id_map_seq; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('map_id_map_seq', 9, true);


--
-- Data for Name: maps; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY maps (id_map, s_name, s_projection, s_units, f_show_overview, j_custom_scales, d_dots_per_inch_override, j_custom_resolutions, custom_scales_resolutions, f_maxscale, f_default_extent_minx, f_default_extent_miny, f_default_extent_maxx, f_default_extent_maxy, thumbnail) FROM stdin;
2	mosef_map	EPSG:900913	m	t	[1000,2000,5000,10000,25000,50000,100000,150000,200000,250000,500000,1000000,2000000,3000000,4000000]	90.7142857142857224	[0.27999999999999997,0.5599999999999999,1.4,2.8,6.999999999999999,13.999999999999998,27.999999999999996,41.99999999999999,55.99999999999999,70.0,140.0,280.0,560.0,839.9999999999999,1120.0]	none	\N	-9973337	1439825	-9254827	1894167	\N
8	icf_map	EPSG:4326	m	t	[1000,2000,5000,10000,25000,50000,100000,150000,200000,250000,500000,1000000,2000000,3000000,4000000]	90.714285714285694	[0.2985821416974068,0.5971642833948135,1.194328566789627,2.388657133579254,4.777314267158508,9.554628534317017,19.109257068634033,38.218514137268066,76.43702827453613,152.87405654907226,305.74811309814453,611.4962261962891,1222.9924523925781,2445.9849047851562,4891.9698095703125,9783.939619140625]	resolutions	1066.36479177644992	74.1610000000000014	4.55799999999999983	-74.6666599999999931	4.5990000000000002	\N
9	testName	a	a	t	[1]	1	[1.0]		1	1	1	1	1	\N
\.


--
-- Name: modules_id_module_seq; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('modules_id_module_seq', 18, false);


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY permissions (id_permission, c_permission, description, description_en, description_es) FROM stdin;
17	USER_SELF_CHANGE_PASSWORD	USER_SELF_CHANGE_PASSWORD	Allows the user to change his password.	Permite al usuario modificar su contraseña.
18	USER_CHANGE_PASSWORD	USER_CHANGE_PASSWORD	Allows the user to change other users' passwords.	Permite al usuario modificar la contraseña de otros usuarios.
15	ROLE_ADMINISTRATION	ROLE_ADMINISTRATION_DESC	Allows the user to access the "Role administration" page of the administration panel.	Permite al usuario acceder a la pagina de "Configuración de roles".
16	USER_ADMINISTRATION	USER_ADMINISTRATION	Allows the user to access the "User administration" page of the administration panel.	Permite al usuario acceder a la pagina de "Configuración de usuarios".
32	ALERTS_WS_MUNI_SIT	ALERTS_WS_MUNI_SIT	Allows the user to invoke the Municipal SIT Service	Permite al usuario llamar al servicio de Reportes de Incidencias del SIT Municipal.
8	ALERTS_READ	ALERTS_READ	Allows the user to see the alerts (both the alphanumeric and the geometry components).	Permite al usuario ver los Reportes De incidencias (componente alfanumerica y geometria).
11	COMMENTS_READ	COMMENTS_READ	Allow to read the comments associated to the map.	Permite al usuario leer sus comentarios guardados en el sistema.
10	REDLINE_INSERT	REDLINE_INSERT	Allows the user to save his redlines in the system.	Permite al usuario guardar sus dibujos en el sistema.
12	COMMENTS_INSERT	COMMENTS_INSERT	Allow to add, modify or remove a comment associated to the map.	Permite insertar, modificar y remover los comentarios guardados en el sistema.
43	ALERTS_EDIT_DEP_YORO	ALERTS_EDIT_DEP_YORO	Allows the user to edit the Alerts located in the Yoro Department	Permite al usuatio editar los Reportes de Incidencias ubicadas en el departamento de Yoro
22	SHOW_LOGS_ADMINISTRATION	SHOW_LOGS_ADMINISTRATION	Allows the user to access the "Logs" page of the administration panel.	Permite al usuario acceder a la pagina de "Logs" en el panel de administracion.
23	TEST_REQUESTS_ADMINISTRATION	TEST_REQUESTS_ADMINISTRATION	Allows the user to access the "Test requests" page of the administration panel.	Permite al usuario acceder a la pagina de "Pruebas de llamadas" en el panel de administracion.
29	MAP_SETTING_CONFIG_ADMINISTRATION	MAP_SETTING_CONFIG_ADMINISTRATION	Allows the user to access the "Map settings" page of the administration panel.	Permite al usuario acceder a la pagina de "Parametros del mapa" en el panel de administracion.
24	ACCESS_ADMINISTRATION_PANEL	ACCESS_ADMINISTRATION_PANEL	Allows the user to access the Administration panel.	Permite al usuario acceder al panel de administracion del geoportal.
19	MAP_CONFIG_ADMINISTRATION	MAP_CONFIG_ADMINISTRATION	Allows the user to access the "Map configuration" page of the administration panel.	Permite al usuario acceder a la pagina de "Configuración del mapa".
21	SOURCE_CONFIG_ADMINISTRATION	SOURCE_CONFIG_ADMINISTRATION	Allows the user to access the "WMS Sources configuration" page of the administration panel.	Permite al usuario acceder a la pagina de "Configuración de Fuentes WMS".
20	LAYER_CONFIG_ADMINISTRATION	LAYER_CONFIG_ADMINISTRATION	Allows the user to access the "Layer configuration" page of the administration panel.	Permite al usuario acceder a la pagina de "Configuración de capas".
26	SYSTEM_CONFIG_ADMINISTRATION	SYSTEM_CONFIG_ADMINISTRATION	Allows the user to access the "System configuration" page of the administration panel.	Permite al usuario acceder a la pagina de "Configuración del sistema" en el panel de administracion.
27	GENERAL_CONFIG_ADMINISTRATION	GENERAL_CONFIG_ADMINISTRATION	Allows the user to access the "General configuration" page of the administration panel.	Permite al usuario acceder a la pagina de "Configuración general" en el panel de administracion.
30	ALERTS_CHANGE_STATUS	ALERTS_CHANGE_STATUS	Allows the user to change the status of an alert.	Permite al usuario modificar el estado de un Reporte de Incidencia.
33	ALERTS_EDIT_DEP_ATLANTIDA	ALERTS_EDIT_DEP_ATLANTIDA	Allows the user to edit the Alerts located in the Atlantida Department	Permite al usuatio editar los Reportes de Incidencias ubicadas en el departamento de Atlantida
34	ALERTS_EDIT_DEP_COMAYAGUA	ALERTS_EDIT_DEP_COMAYAGUA	Allows the user to edit the Alerts located in the Comayagua Department	Permite al usuatio editar los Reportes de Incidencias ubicadas en el departamento de Comayagua
35	ALERTS_EDIT_DEP_COPAN	ALERTS_EDIT_DEP_COPAN	Allows the user to edit the Alerts located in the Copan Department	Permite al usuatio editar los Reportes de Incidencias ubicadas en el departamento de Copan
36	ALERTS_EDIT_DEP_ELPARAISO	ALERTS_EDIT_DEP_ELPARAISO	Allows the user to edit the Alerts located in the El Paraiso Department	Permite al usuatio editar los Reportes de Incidencias ubicadas en el departamento de El Paraiso
37	ALERTS_EDIT_DEP_FMORAZAN	ALERTS_EDIT_DEP_FMORAZAN	Allows the user to edit the Alerts located in the Francisco Morazan Department	Permite al usuatio editar los Reportes de Incidencias ubicadas en el departamento de Francisco Morazan
38	ALERTS_EDIT_DEP_INTIBUCA	ALERTS_EDIT_DEP_INTIBUCA	Allows the user to edit the Alerts located in the Intibuca Department	Permite al usuatio editar los Reportes de Incidencias ubicadas en el departamento de Intibuca
39	ALERTS_EDIT_DEP_LAPAZ	ALERTS_EDIT_DEP_LAPAZ	Allows the user to edit the Alerts located in the La Paz Department	Permite al usuatio editar los Reportes de Incidencias ubicadas en el departamento de La Paz
40	ALERTS_EDIT_DEP_LEMPIRA	ALERTS_EDIT_DEP_LEMPIRA	Allows the user to edit the Alerts located in the Lempira Department	Permite al usuatio editar los Reportes de Incidencias ubicadas en el departamento de Lempira
41	ALERTS_EDIT_DEP_SANTABARBARA	ALERTS_EDIT_DEP_SANTABARBARA	Allows the user to edit the Alerts located in the Santa Barbara Department	Permite al usuatio editar los Reportes de Incidencias ubicadas en el departamento de Santa Barbara
42	ALERTS_EDIT_DEP_OLANCHO	ALERTS_EDIT_DEP_OLANCHO	Allows the user to edit the Alerts located in the Olancho Department	Permite al usuatio editar los Reportes de Incidencias ubicadas en el departamento de Olancho
44	ALERTS_EDIT_DEP_ISLASBAHIA	ALERTS_EDIT_DEP_ISLASBAHIA	Allows the user to edit the Alerts located in the Islas de la Bahia Department	Permite al usuatio editar los Reportes de Incidencias ubicadas en el departamento de Islas de la Bahia
45	ALERTS_EDIT_DEP_VALLE	ALERTS_EDIT_DEP_VALLE	Allows the user to edit the Alerts located in the Valle Department	Permite al usuatio editar los Reportes de Incidencias ubicadas en el departamento de Valle
46	ALERTS_EDIT_DEP_GRACIASDIOS	ALERTS_EDIT_DEP_GRACIASDIOS	Allows the user to edit the Alerts located in the Gracias a Dios Department	Permite al usuatio editar los Reportes de Incidencias ubicadas en el departamento de Gracias a Dios
47	ALERTS_EDIT_DEP_CHOLUTECA	ALERTS_EDIT_DEP_CHOLUTECA	Allows the user to edit the Alerts located in the Choluteca Department	Permite al usuatio editar los Reportes de Incidencias ubicadas en el departamento de Choluteca
48	ALERTS_EDIT_DEP_COLON	ALERTS_EDIT_DEP_COLON	Allows the user to edit the Alerts located in the Colon Department	Permite al usuatio editar los Reportes de Incidencias ubicadas en el departamento de Colon
28	ALERTS_CONFIG_ADMINISTRATION	ALERTS_CONFIG_ADMINISTRATION	Allows the user to access the "Alerts configuration" page of the administration panel.	Permite al usuario acceder a la pagina de "Configuración de los Reportes de Incidencia" en el panel de administracion.
49	ALERTS_EDIT_DEP_CORTEZ	ALERTS_EDIT_DEP_CORTEZ	Allows the user to edit the Alerts located in the Cortez Department	Permite al usuatio editar los Reportes de Incidencias ubicadas en el departamento de Cortez
50	ALERTS_EDIT_DEP_OCOTEPEQUE	ALERTS_EDIT_DEP_OCOTEPEQUE	Allows the user to edit the Alerts located in the Ocotepeque Department	Permite al usuatio editar los Reportes de Incidencias ubicadas en el departamento de Ocotepeque
25	ALERTS_DOWNLOAD	ALERTS_DOWNLOAD	Allows the user to download the Zip file of the alerts.	Permite al usuario descargar un archivo ZIP de los Reportes de Incidencia.
31	ALERTS_UPDATE	ALERTS_UPDATE	Allows the user to modify the information of an alert. It does not allow to change its status.	Permite al usuario modificar las informaciones de un Reporte de Incidencia. No permite modificar su estado.
51	TEST_PLUGIN	TEST_PLUGIN	Description of TEST_PLUGIN	\N
\.


--
-- Data for Name: redlining_line; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY redlining_line (id_redlining, id_user, type, label, geometry, the_geom) FROM stdin;
\.


--
-- Name: redlining_line_id_redlining_seq; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('redlining_line_id_redlining_seq', 40, true);


--
-- Data for Name: redlining_point; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY redlining_point (id_redlining, id_user, type, label, geometry, the_geom) FROM stdin;
\.


--
-- Name: redlining_point_id_redlining_seq; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('redlining_point_id_redlining_seq', 191, true);


--
-- Data for Name: redlining_polygon; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY redlining_polygon (id_redlining, id_user, type, label, geometry, the_geom) FROM stdin;
\.


--
-- Name: redlining_polygon_id_redlining_seq; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('redlining_polygon_id_redlining_seq', 19, true);


--
-- Name: redlining_redlining_seq; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('redlining_redlining_seq', 273, false);


--
-- Data for Name: role_permission; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY role_permission (id_role, id_permission) FROM stdin;
1	8
1	10
1	11
1	12
1	15
1	16
1	17
1	18
1	27
1	28
1	29
1	30
1	31
1	19
1	22
1	23
1	20
1	21
2	8
1	24
2	23
2	12
2	18
1	25
1	26
1	32
1	33
13	32
21	25
21	8
21	47
21	31
22	25
22	31
22	33
22	8
23	25
23	8
23	48
23	31
24	25
24	31
24	34
24	8
25	35
25	25
25	31
25	8
26	49
26	25
26	31
26	8
27	25
27	36
27	31
27	8
28	25
28	31
28	8
28	37
29	46
29	25
29	8
29	31
30	8
30	31
30	25
30	38
31	31
31	25
31	8
31	44
32	39
32	31
32	25
32	8
33	40
33	25
33	8
33	31
34	50
34	31
34	8
34	25
35	31
35	25
35	8
35	42
36	25
36	41
36	8
36	31
37	45
37	8
37	25
37	31
38	25
38	8
38	43
38	31
1	42
1	45
1	40
1	35
1	36
1	50
1	39
1	46
1	34
1	44
1	38
1	49
1	48
1	41
1	37
1	43
1	47
22	30
23	30
24	30
25	30
26	30
21	30
27	30
28	30
29	30
30	30
31	30
32	30
33	30
34	30
35	30
36	30
37	30
38	30
22	11
22	10
22	12
23	12
23	10
23	11
24	10
24	12
24	11
25	11
25	12
25	10
26	12
26	11
26	10
21	10
21	12
21	11
27	11
27	12
27	10
28	12
28	10
28	11
29	11
29	10
29	12
30	11
30	12
30	10
31	12
31	10
31	11
32	10
32	12
32	11
33	10
33	11
33	12
34	11
34	12
34	10
35	12
35	11
35	10
36	11
36	10
36	12
37	12
37	10
37	11
38	12
38	11
38	10
40	10
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY roles (id_role, role_name, description) FROM stdin;
2	normal user	desc normal
13	Rol SIT Municipal	Rol usado por el usuario del SIT Municipal
21	Rol Administrador Choluteca	Rol de Administracion Regional para el departamento de Choluteca
22	Rol Administrador Atlantida	Rol de Administracion Regional para el departamento de Atlantida
23	Rol Administrador Colon	Rol de Administracion Regional para el departamento de Colon
24	Rol Administrador Comayagua	Rol de Administracion Regional para el departamento de Comayagua
25	Rol Administrador Copan	Rol de Administracion Regional para el departamento de Copan
26	Rol Administrador Cortez	Rol de Administracion Regional para el departamento de Cortez
27	Rol Administrador el Paraiso	Rol de Administracion Regional para el departamento de el Paraiso
28	Rol Administrador F. Morazan	Rol de Administracion Regional para el departamento de F. Morazan
29	Rol Administrador Gracias a Dios	Rol de Administracion Regional para el departamento de Gracias a Dios
30	Rol Administrador Intibuca	Rol de Administracion Regional para el departamento de Intibuca
31	Rol Administrador Islas Bahia	Rol de Administracion Regional para el departamento de Islas Bahia
32	Rol Administrador La Paz	Rol de Administracion Regional para el departamento de La Paz
33	Rol Administrador Lempira	Rol de Administracion Regional para el departamento de Lempira
34	Rol Administrador Ocotepeque	Rol de Administracion Regional para el departamento de Ocotepeque
35	Rol Administrador Olancho	Rol de Administracion Regional para el departamento de Olancho
36	Rol Administrador Santa Barbara	Rol de Administracion Regional para el departamento de Santa Barbara
37	Rol Administrador Valle	Rol de Administracion Regional para el departamento de Valle
38	Rol Administrador Yoro	Rol de Administracion Regional para el departamento de Yoro
1	Administrator general	Administrador general del sistema. Tiene todos los permisos
40	Test usuario visualizacion	Test usuario visualizacion
\.


--
-- Name: roles_id_role_seq; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('roles_id_role_seq', 40, true);


--
-- Data for Name: system_settings; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY system_settings (id, key, value) FROM stdin;
1	PROXY_URL	/http_proxy/proxy?url=
8	PRINT_IMAGES_FOLDER	c:/print_images_data_folder
6	SEARCH_MAX_HITS_PER_LAYER	100
10	MAX_NUMBER_OF_SELECTABLE_LAYERS	50
7	AJAX_REQUEST_TIMEOUT_MSEC	20000
9	FEATURE_ATTRIBUTE_HYPERLINK_FIELD	et_source
12	ALERTS_LEGEND_URL	http://localhost:8080/geoportal/images/legends/denuncias.png
14	ALERTS_GEOSERVER_LAYER_NAME	icf:vw_alerts_publish
15	ALERTS_GEOSERVER_USERNAME	alerts_view
16	ALERTS_GEOSERVER_PASSWORD	alerts_view
2	GEOSERVER_URL	http://geoportal-mosef.gesp.it/geoserver
5	PRINT_SERVLET_URL	http://localhost:8081/print-servlet-mod2
17	AJAX_REQUEST_PRINT_TIMEOUT_MSEC	120000
4	GEONETWORK_URL	http://localhost:8081/geonetwork
13	REDLINES_LEGEND_URL	http://localhost:8080/geoportal/images/legends/dibujo.png
\.


--
-- Name: system_settings_id_system_setting_seq; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('system_settings_id_system_setting_seq', 17, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: geoportal; Owner: geoportal_user
--

COPY users (id_user, password_old, username, id_role, f_disabled, f_deleted, password_hash) FROM stdin;
1	mosef	mosef	1	f	f	dc736c46b66dc6293fe35ff89bc5205d
40	\N	sit_user	13	f	f	b0b5dbe047eb2bae669571e7259e2e3b
46	\N	colon	\N	f	t	cd474d96b7d33934e9dc47b57cb4c445
45	\N	atlantida	\N	f	t	02480b909b487ffa36e2ac38eb03c5ba
47	\N	comayagua	\N	f	t	e28be7150c8d2f164883b12876361200
48	\N	copan	\N	f	t	8dcd0920df22b4ebf7390321940c4fac
49	\N	cortez	\N	f	t	e9d8fd1a46b1cb02f90e7eb7e1c07377
50	\N	choluteca	\N	f	t	4d1007fd2b9077471c20da7fa73c5253
51	\N	paraiso	\N	f	t	77620f067dfe09605d7a8d94ea2aceb9
52	\N	morazan	\N	f	t	e9e6b5b47993cee7c8d1c7bc9fc5be16
53	\N	graciasadios	\N	f	t	13f87ac9e88c258970e563df85d2c66b
54	\N	intibuca	\N	f	t	67e0ca50b12ff66b4f2de5508fcdbf7d
55	\N	islasbahia	\N	f	t	0cd605cd9d29f181421521acd7736ba6
56	\N	lapaz	\N	f	t	24b95636d8b3f044eb23016b8a6b42ad
57	\N	lempira	\N	f	t	97827e9d64e3d7eac6584b1e53311f99
58	\N	ocotepeque	\N	f	t	bdfaaa461f115bdb624c4b6b5e07d26d
59	\N	olancho	\N	f	t	e44441f4c05181586606a136568d172a
60	\N	santabarbara	\N	f	t	fe058dd144ce2c584cdac0d30a1fd5f3
61	\N	valle	\N	f	t	4621dd08d8452ad13df5b30b29e5b9b7
62	\N	yoro	\N	f	t	8d12b031c734ae58a597256d14d8b8aa
63	\N	usuario1	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
64	\N	usuario2	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
65	\N	usuario3	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
66	\N	usuario4	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
67	\N	usuario5	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
68	\N	usuario6	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
69	\N	usuario7	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
70	\N	usuario8	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
71	\N	usuario9	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
73	\N	usuario11	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
72	\N	usuario10	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
76	\N	usuario14	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
74	\N	usuario12	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
77	\N	usuario15	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
79	\N	usuario17	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
75	\N	usuario13	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
80	\N	usuario18	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
78	\N	usuario16	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
82	\N	usuario20	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
83	\N	usuario21	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
81	\N	usuario19	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
85	\N	usuario23	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
94	\N	usuario32	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
84	\N	usuario22	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
87	\N	usuario25	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
97	\N	usuario35	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
88	\N	usuario26	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
86	\N	usuario24	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
101	\N	usuario39	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
92	\N	usuario30	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
89	\N	usuario27	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
91	\N	usuario29	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
95	\N	usuario33	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
105	\N	usuario43	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
90	\N	usuario28	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
96	\N	usuario34	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
93	\N	usuario31	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
106	\N	usuario44	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
99	\N	usuario37	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
100	\N	usuario38	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
107	\N	usuario45	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
98	\N	usuario36	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
103	\N	usuario41	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
104	\N	usuario42	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
108	\N	usuario46	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
102	\N	usuario40	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
112	\N	usuario50	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
110	\N	usuario48	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
109	\N	usuario47	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
111	\N	usuario49	\N	f	t	f8032d5cae3de20fcec887f395ec9a6a
\.


--
-- Name: users_id_user_seq1; Type: SEQUENCE SET; Schema: geoportal; Owner: geoportal_user
--

SELECT pg_catalog.setval('users_id_user_seq1', 112, true);


SET search_path = public, pg_catalog;

--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY spatial_ref_sys  FROM stdin;
\.


SET search_path = geoportal, pg_catalog;

--
-- Name: alert_type_id_alert_type; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY alert_types
    ADD CONSTRAINT alert_type_id_alert_type PRIMARY KEY (id_alert_type);


--
-- Name: fk_id_redlining_line; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY redlining_line
    ADD CONSTRAINT fk_id_redlining_line PRIMARY KEY (id_redlining);


--
-- Name: fk_id_redlining_point; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY redlining_point
    ADD CONSTRAINT fk_id_redlining_point PRIMARY KEY (id_redlining);


--
-- Name: fk_id_redlining_polygon; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY redlining_polygon
    ADD CONSTRAINT fk_id_redlining_polygon PRIMARY KEY (id_redlining);


--
-- Name: permissions_pkey; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id_permission);


--
-- Name: pk_alert_geom_line_id_geom; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY alert_geom_line
    ADD CONSTRAINT pk_alert_geom_line_id_geom PRIMARY KEY (id_geom);


--
-- Name: pk_alert_geom_point_id_geom; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY alert_geom_point
    ADD CONSTRAINT pk_alert_geom_point_id_geom PRIMARY KEY (id_geom);


--
-- Name: pk_alert_geom_polygon_id_geom; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY alert_geom_polygon
    ADD CONSTRAINT pk_alert_geom_polygon_id_geom PRIMARY KEY (id_geom);


--
-- Name: pk_alert_status_c_status; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY alert_status
    ADD CONSTRAINT pk_alert_status_c_status PRIMARY KEY (c_status);


--
-- Name: pk_alert_status_history; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY alert_status_history
    ADD CONSTRAINT pk_alert_status_history PRIMARY KEY (id_history);


--
-- Name: pk_alerts_id_alert; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY alerts
    ADD CONSTRAINT pk_alerts_id_alert PRIMARY KEY (id_alert);


--
-- Name: pk_alerts_intersections_id; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY alerts_intersections
    ADD CONSTRAINT pk_alerts_intersections_id PRIMARY KEY (id);


--
-- Name: pk_alerts_settings_id; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY alerts_settings
    ADD CONSTRAINT pk_alerts_settings_id PRIMARY KEY (id);


--
-- Name: pk_comments_id_comment; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT pk_comments_id_comment PRIMARY KEY (id_comment);


--
-- Name: pk_departments_permissions_mapping_id; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY departments_permissions_mapping
    ADD CONSTRAINT pk_departments_permissions_mapping_id PRIMARY KEY (id);


--
-- Name: pk_general_settings_id; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY general_settings
    ADD CONSTRAINT pk_general_settings_id PRIMARY KEY (id);


--
-- Name: pk_layer_config_id_layer_config; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY layerconfigs
    ADD CONSTRAINT pk_layer_config_id_layer_config PRIMARY KEY (id_layer_config);


--
-- Name: pk_layer_types_id_layer_type; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY layer_types
    ADD CONSTRAINT pk_layer_types_id_layer_type PRIMARY KEY (id_layer_type);


--
-- Name: pk_layergroup_id_layergroup; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY layergroups
    ADD CONSTRAINT pk_layergroup_id_layergroup PRIMARY KEY (id_layergroup);


--
-- Name: pk_layergroups_layers; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY layergroups_layers
    ADD CONSTRAINT pk_layergroups_layers PRIMARY KEY (id_layergroup, id_layer);


--
-- Name: pk_layers_id_layer; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY layers
    ADD CONSTRAINT pk_layers_id_layer PRIMARY KEY (id_layer);


--
-- Name: pk_layersources_id_layersource; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY layersources
    ADD CONSTRAINT pk_layersources_id_layersource PRIMARY KEY (id_layersource);


--
-- Name: pk_logs_id_log; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY logs
    ADD CONSTRAINT pk_logs_id_log PRIMARY KEY (id_log);


--
-- Name: pk_maps_id_map; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY maps
    ADD CONSTRAINT pk_maps_id_map PRIMARY KEY (id_map);


--
-- Name: pk_role_permission; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY role_permission
    ADD CONSTRAINT pk_role_permission PRIMARY KEY (id_role, id_permission);


--
-- Name: pk_roles_id_role; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT pk_roles_id_role PRIMARY KEY (id_role);


--
-- Name: pk_system_settings_id; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY system_settings
    ADD CONSTRAINT pk_system_settings_id PRIMARY KEY (id);


--
-- Name: uk_alerts_intersections_name; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY alerts_intersections
    ADD CONSTRAINT uk_alerts_intersections_name UNIQUE (name);


--
-- Name: uk_id_layergroup_position; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY layergroups_layers
    ADD CONSTRAINT uk_id_layergroup_position UNIQUE (id_layergroup, "position");


--
-- Name: uk_id_map_position; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY layergroups
    ADD CONSTRAINT uk_id_map_position UNIQUE (id_map, "position");


--
-- Name: uk_permissions_c_permission; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY permissions
    ADD CONSTRAINT uk_permissions_c_permission UNIQUE (c_permission);


--
-- Name: uk_system_settings_key; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY system_settings
    ADD CONSTRAINT uk_system_settings_key UNIQUE (key);


--
-- Name: unique_name_constraint; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY maps
    ADD CONSTRAINT unique_name_constraint UNIQUE (s_name);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id_user);


--
-- Name: fki_alerts_c_status_curr; Type: INDEX; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE INDEX fki_alerts_c_status_curr ON alerts USING btree (c_status_curr);


--
-- Name: fki_alerts_id_alert_type; Type: INDEX; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE INDEX fki_alerts_id_alert_type ON alerts USING btree (id_alert_type);


--
-- Name: fki_alerts_id_user; Type: INDEX; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE INDEX fki_alerts_id_user ON alerts USING btree (id_user);


--
-- Name: fki_alerts_intersections_id_layer; Type: INDEX; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE INDEX fki_alerts_intersections_id_layer ON alerts_intersections USING btree (id_layer);


--
-- Name: fki_comments_id_user; Type: INDEX; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE INDEX fki_comments_id_user ON comments USING btree (id_user);


--
-- Name: fki_departments_permissions_mapping_c_permission; Type: INDEX; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE INDEX fki_departments_permissions_mapping_c_permission ON departments_permissions_mapping USING btree (c_permission);


--
-- Name: fki_layers_id_layerconfig; Type: INDEX; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE INDEX fki_layers_id_layerconfig ON layers USING btree (id_layer_config);


--
-- Name: fki_layers_id_layersource; Type: INDEX; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE INDEX fki_layers_id_layersource ON layers USING btree (id_layersource);


--
-- Name: fki_layers_id_layertype; Type: INDEX; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE INDEX fki_layers_id_layertype ON layers USING btree (id_layer_type);


--
-- Name: fki_logs_id_user; Type: INDEX; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE INDEX fki_logs_id_user ON logs USING btree (id_user);


--
-- Name: fki_role_permission_id_permission; Type: INDEX; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE INDEX fki_role_permission_id_permission ON role_permission USING btree (id_permission);


--
-- Name: fki_users_role; Type: INDEX; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE INDEX fki_users_role ON users USING btree (id_role);


--
-- Name: idx_alert_geom_point_geom; Type: INDEX; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE INDEX idx_alert_geom_point_geom ON alert_geom_point USING gist (the_geom);


--
-- Name: idx_alerts_reference_code; Type: INDEX; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE INDEX idx_alerts_reference_code ON alerts USING btree (reference_code);


--
-- Name: idx_users_username; Type: INDEX; Schema: geoportal; Owner: geoportal_user; Tablespace: 
--

CREATE INDEX idx_users_username ON users USING btree (username);


--
-- Name: fk_alerts_c_status_curr; Type: FK CONSTRAINT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY alerts
    ADD CONSTRAINT fk_alerts_c_status_curr FOREIGN KEY (c_status_curr) REFERENCES alert_status(c_status);


--
-- Name: fk_alerts_id_alert_type; Type: FK CONSTRAINT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY alerts
    ADD CONSTRAINT fk_alerts_id_alert_type FOREIGN KEY (id_alert_type) REFERENCES alert_types(id_alert_type);


--
-- Name: fk_alerts_id_user; Type: FK CONSTRAINT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY alerts
    ADD CONSTRAINT fk_alerts_id_user FOREIGN KEY (id_user) REFERENCES users(id_user);


--
-- Name: fk_alerts_intersections_id_layer; Type: FK CONSTRAINT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY alerts_intersections
    ADD CONSTRAINT fk_alerts_intersections_id_layer FOREIGN KEY (id_layer) REFERENCES layers(id_layer);


--
-- Name: fk_comments_id_user; Type: FK CONSTRAINT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT fk_comments_id_user FOREIGN KEY (id_user) REFERENCES users(id_user);


--
-- Name: fk_departments_permissions_mapping_c_permission; Type: FK CONSTRAINT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY departments_permissions_mapping
    ADD CONSTRAINT fk_departments_permissions_mapping_c_permission FOREIGN KEY (c_permission) REFERENCES permissions(c_permission);


--
-- Name: fk_layergroups_id_map; Type: FK CONSTRAINT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY layergroups
    ADD CONSTRAINT fk_layergroups_id_map FOREIGN KEY (id_map) REFERENCES maps(id_map);


--
-- Name: fk_layergroups_layer_id_layer; Type: FK CONSTRAINT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY layergroups_layers
    ADD CONSTRAINT fk_layergroups_layer_id_layer FOREIGN KEY (id_layer) REFERENCES layers(id_layer);


--
-- Name: fk_layergroups_layer_id_layergroup; Type: FK CONSTRAINT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY layergroups_layers
    ADD CONSTRAINT fk_layergroups_layer_id_layergroup FOREIGN KEY (id_layergroup) REFERENCES layergroups(id_layergroup) ON DELETE CASCADE;


--
-- Name: fk_layers_id_layerconfig; Type: FK CONSTRAINT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY layers
    ADD CONSTRAINT fk_layers_id_layerconfig FOREIGN KEY (id_layer_config) REFERENCES layerconfigs(id_layer_config);


--
-- Name: fk_layers_id_layersource; Type: FK CONSTRAINT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY layers
    ADD CONSTRAINT fk_layers_id_layersource FOREIGN KEY (id_layersource) REFERENCES layersources(id_layersource);


--
-- Name: fk_layers_id_layertype; Type: FK CONSTRAINT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY layers
    ADD CONSTRAINT fk_layers_id_layertype FOREIGN KEY (id_layer_type) REFERENCES layer_types(id_layer_type);


--
-- Name: fk_logs_id_user; Type: FK CONSTRAINT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY logs
    ADD CONSTRAINT fk_logs_id_user FOREIGN KEY (id_user) REFERENCES users(id_user);


--
-- Name: fk_role_permission_id_permission; Type: FK CONSTRAINT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY role_permission
    ADD CONSTRAINT fk_role_permission_id_permission FOREIGN KEY (id_permission) REFERENCES permissions(id_permission);


--
-- Name: fk_role_permission_id_role; Type: FK CONSTRAINT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY role_permission
    ADD CONSTRAINT fk_role_permission_id_role FOREIGN KEY (id_role) REFERENCES roles(id_role) ON DELETE CASCADE;


--
-- Name: fk_users_id_role; Type: FK CONSTRAINT; Schema: geoportal; Owner: geoportal_user
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_users_id_role FOREIGN KEY (id_role) REFERENCES roles(id_role);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

