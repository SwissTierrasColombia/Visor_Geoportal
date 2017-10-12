-- drop unused fields from geoportal.maps
alter table geoportal.maps drop column s_max_extent;
alter table geoportal.maps drop column s_center;
alter table geoportal.maps drop column n_zoom;
alter table geoportal.maps drop column d_center_x;
alter table geoportal.maps drop column d_center_y;