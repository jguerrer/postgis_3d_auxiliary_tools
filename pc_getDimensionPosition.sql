/*
* Checks wherer a point lies in the same side of several planes, the tet planes.
If it does, then the point is inside a tetrahedral, otherwise, is outside.
*/
--drop function getDimensionPosition;
CREATE OR REPLACE FUNCTION  pc_getDimensionPosition(
	schemaID integer, 
	dimension varchar
	) 
	RETURNS integer AS $$
<< getDimensionPosition >>
DECLARE
	dimension_position integer;

BEGIN

	
	with pg_schema(col) as (select schema::xml from pointcloud_formats where pcid =schemaID)
select (xpath(
	'//pc:PointCloudSchema/pc:dimension[pc:name='''|| dimension ||''']/pc:position/text()',
	col,
	'{{pc,http://pointcloud.org/schemas/PC/}}'))[1] pos from pg_schema
	
	INTO dimension_position ;
	return dimension_position;
END;

$$
LANGUAGE plpgsql;








