WITH  coords AS (select 
	t_geom2array(st_geomfromtext('POINT(1 1 0.5)')) v1  ,
	t_geom2array(st_geomfromtext('POINT(2 1 2)')) v2 ,
	t_geom2array(st_geomfromtext('POINT(1 2 1.5)')) v3 ,
	array[0.0,0.5,1.0,1.5,2.0] AS vals
	) 
select t_create_isoline(coords.v1, coords.v2, coords.v3,vals ) from coords ;

