/*
* Checks wherer a point lies in the same side of several planes, the tet planes.
If it does, then the point is inside a tetrahedral, otherwise, is outside.
*/
--drop function pc_getDimensions;
CREATE OR REPLACE FUNCTION  pc_getDimensions(
	schemaid integer
) 
	RETURNS table(schema_id integer) AS $$
<< getDimensionPosition >>
DECLARE
	dimensions integer;

BEGIN

	
with pg_schema(col) as (select schema::xml from pointcloud_formats where pcid =4)
select unnest((xpath(
	'//pc:PointCloudSchema/pc:dimension/pc:position/text() ',
	col,
	'{{pc,http://pointcloud.org/schemas/PC/}}'))  
			 ),
			unnest((xpath(
	'//pc:PointCloudSchema/pc:dimension/pc:name/text() ',
	col,
	'{{pc,http://pointcloud.org/schemas/PC/}}'))  
			 )
	
	
	INTO dimensions ;
	return dimensions;
END;

$$
LANGUAGE plpgsql;








