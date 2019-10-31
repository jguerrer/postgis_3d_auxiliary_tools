/*
* Checks wherer a point lies in the same side of several planes, the tet planes.
If it does, then the point is inside a tetrahedral, otherwise, is outside.
*/
drop function t_checkSameSide;
CREATE OR REPLACE FUNCTION  t_checkSameSide(
	v1 double precision[], 
	v2 double precision[], 
	v3 double precision[], 
	v4 double precision[], 
	point double precision[]) 
	RETURNS boolean AS $$
<< pointInTet >>
DECLARE
	--todas las variables

	v2_v1 double precision[];
	v3_v1 double precision[];
	v4_v1 double precision[];
	point_v1 double precision[];

	res boolean:= false;
	normal double precision[];
	dotV4 double precision;
	dotP double precision;


BEGIN

	SELECT array[
	(v2[1] -	v1[1] ) ,
	(v2[2] -	v1[2] ) ,
	(v2[3] -	v1[3] )] 
	INTO v2_v1 ;
	
	
	SELECT array[
	(v3[1] -	v1[1] ) ,
	(v3[2] -	v1[2] ) ,
	(v3[3] -	v1[3] )] 	
	INTO v3_v1 ;

	SELECT array[
	(v4[1] -	v1[1] ) ,
	(v4[2] -	v1[2] ) ,
	(v4[3] -	v1[3] )] 
	INTO v4_v1 ;
	
	SELECT array[
	(point[1] -	v1[1] ) ,
	(point[2] -	v1[2] ) ,
	(point[3] -	v1[3] )] 
	
	INTO point_v1 ;

	-- checks are made wrt v1

--    normal := crossProduct(v2 - v1, v3 - v1)
 --   dotV4 := dotProduct(normal, v4 - v1)
  --  dotP := dotProduct(normal, p - v1)
  --  return Math.Sign(dotV4) == Math.Sign(dotP);

	normal := t_cross_product(v2_v1,v3_v1);
	dotV4:=t_dot_product(normal, v4_v1);
	dotP:=t_dot_product(normal, point_v1);
	res=sign(dotv4) = sign(dotp);
	
	raise notice 'v2_v1 %',v2_v1[1] || ' '||v2_v1[2]|| ' '|| v2_v1[3];
	raise notice 'v3_v1 %',v3_v1[1] || ' '||v3_v1[2]|| ' '|| v3_v1[3];
	raise notice 'v4_v1 %',v4_v1[1] || ' '||v4_v1[2]|| ' '|| v4_v1[3];

	raise notice 'point_v1 %',point_v1[1] || ' '||point_v1[2]|| ' '|| point_v1[3];


	raise notice 'normal %',normal[1] || ' '||normal[2]|| ' '|| normal[3];
	raise notice 'dotv4 %',dotv4;
	raise notice 'dotv4 %',dotP;
	raise notice 'dotv4 sign %',sign(dotv4);
	raise notice 'dotv4 sign %',sign(dotP);
	raise notice 'result %',res;
	
  
  
  
	return res;
END;

$$
LANGUAGE plpgsql;
