WITH  coords AS (select 
	geom2array(st_geomfromtext('POINT(1 1 1)')) v1  ,
	geom2array(st_geomfromtext('POINT(2 1 1)')) v2,
	geom2array(st_geomfromtext('POINT(1 2 1)')) v3 ) 
select (t_createtet_Array(coords.v1, coords.v2, coords.v3, 1, -1)).* from coords order by tet_id ASC

