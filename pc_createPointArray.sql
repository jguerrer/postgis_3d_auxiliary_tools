/*
* Checks wherer a point lies in the same side of several planes, the tet planes.
If it does, then the point is inside a tetrahedral, otherwise, is outside.
*/
--drop function pc_createPointArray;
CREATE OR REPLACE FUNCTION  pc_createPointArray(
	schemaid integer,
	x double precision,
	y double precision,
	z double precision
) 
	RETURNS 
	 double precision[] AS $$
<< pc_createPointArray >>
DECLARE
	point_array double precision[];
	datos record;

BEGIN

with pg_schema(col) as (select schema::xml from pointcloud_formats where pcid =schemaid)
select array_fill(0.0,array[size.al])::double precision[] array_template, xpos,ypos,zpos
from (SELECT	
	array_length(xpath(
	'//pc:PointCloudSchema/pc:dimension ',
	col,
	'{{pc,http://pointcloud.org/schemas/PC/}}'),1) al ,
	  
	  pc_getDimensionPosition(schemaid,'X') xpos,
	  pc_getDimensionPosition(schemaid,'Y') ypos,
	  pc_getDimensionPosition(schemaid,'Z') zpos
	  
	  
	  from pg_schema) size
	  into datos;
	 ----- 
 	
	datos.array_template[datos.xpos]=x;
	datos.array_template[datos.ypos]=y;
  	datos.array_template[datos.zpos]=z;
			 
	return datos.array_template;

END;

$$
LANGUAGE plpgsql;








