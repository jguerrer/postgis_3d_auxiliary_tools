/*
* Checks wherer a point lies in the same side of several planes, the tet planes.
If it does, then the point is inside a tetrahedral, otherwise, is outside.
*/
DROP function t_pointInTetrahedron;
CREATE OR REPLACE FUNCTION  t_pointInTetrahedron(
	v1 double precision[], 
	v2 double precision[], 
	v3 double precision[], 
	v4 double precision[], 
	point double precision[]) 
	RETURNS boolean AS $$
<< pointInTet >>
DECLARE
	--todas las variables

	
	side1 boolean:= false;
	side2 boolean:= false;
	side3 boolean:= false;
	side4 boolean:= false;
	res boolean:= false;



BEGIN

	side1=t_checksameside(v1,v2,v3,v4,point);
	side2=t_checksameside(v2,v3,v4,v1,point);
	side3=t_checksameside(v3,v4,v1,v2,point);
	side4=t_checksameside(v4,v1,v2,v3,point);
		
  	res:= side1 AND side2 AND side3 AND side4;
  /*
  	raise notice 'side1 %', side1;
	raise notice 'side2 %', side2;
	raise notice 'side3 %', side3;
	raise notice 'side4 %', side4;
	raise notice 'result %', res;
  	*/

	return res;
END;

$$
LANGUAGE plpgsql;
