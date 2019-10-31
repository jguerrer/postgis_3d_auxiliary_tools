--cross product between two normalized vectors anchored at 0
drop function t_cross_product;
CREATE OR REPLACE FUNCTION  t_cross_product(
	v1  double precision[], 
	v2  double precision[]
)
	RETURNS  double precision[] AS $$
<< t_cross_product >>
DECLARE
	nx double precision;
	ny double precision;
	nz double precision;
	norm double precision;
	
	
	
BEGIN
	
	
	nx:= v1[2]*v2[3] - v1[3]*v2[2];
	ny:= -(v1[1]*v2[3]) + v1[3]*v2[1];
	nz:= v1[1]*v2[2] - v1[2]*v2[1];

	
	norm= sqrt(nx*nx + ny*ny + nz*nz);
	nx:=nx/norm;
	ny:=ny/norm;
	nz:=nz/norm;
	-- result is returned as a row
	
	/*
	RAISE NOTICE 'nx %', nx;--
	RAISE NOTICE 'ny %', ny;--
	RAISE NOTICE 'nz %', nz;--
	*/
	
--  
	return array[nx,ny,nz];
END;
--no viene nada despues del end

$$
LANGUAGE plpgsql;
