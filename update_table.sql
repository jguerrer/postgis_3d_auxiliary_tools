alter table centrogeo_6 add column geom_idx geometry;
update centrogeo_6 set geom_idx=PC_EnvelopeGeometry(pa);
CREATE INDEX ON centrogeo_6 USING GIST(geom_idx);
