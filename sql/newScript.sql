-- drop unused fields from geoportal.maps
alter table geoportal.maps drop column s_max_extent;
alter table geoportal.maps drop column s_center;
alter table geoportal.maps drop column n_zoom;
alter table geoportal.maps drop column d_center_x;
alter table geoportal.maps drop column d_center_y;


-- add field for thumbnail in maps
alter table geoportal.maps add column thumbnail text;


ALTER TABLE geoportal.layerconfigs ALTER COLUMN attr_mapping TYPE JSON USING attr_mapping::JSON;
