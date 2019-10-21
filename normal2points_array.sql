CREATE OR REPLACE FUNCTION normal2points_array(point1 numeric[] , point2 numeric[] , point3 numeric[] ) RETURNS numeric[] AS $$

--todas las funciones se construyen de bloques
--[<<label>>]
--DECLARE
--   declarations  
--BEGIN
-- statements
--END  [<<label>>]

<< etiqueta1 >>
DECLARE
	--foo integer := 200;
	--pres_row record;--:=

	na record;--:= calculando el vector sobre el plano 
	nb record;--:=
	--results record;
	results numeric[];

	--myrow tablename%ROWTYPE;
	--myfield tablename.columnname%TYPE;
	--arow RECORD;
	
	--el vector normal resultante
	nx numeric;
	ny numeric;
	nz numeric;
	
	--los vectores de entrada deben de calcularse o normalizarse al cero
	norm numeric;
	
	
	
BEGIN

	
	-- as a preprocessing step, direction vectors are computed
	SELECT 
	(point2[1] -	point1[1] ) AS x ,
	(point2[2] -	point1[2] ) AS y ,
	(point2[3] -	point1[3] ) AS z 
	INTO na ;
	
	
	SELECT 
	point3[1] -	point1[1]  AS x ,
	point3[2] -	point1[2]  AS y ,
	point3[3] -	point1[3]  AS z 	
	INTO nb ;
	
	
	
	
		-- geometry is extracted to work with evary component i , j , k
	
	/*
	SELECT 
	st_x(point1) p1x, st_y(point1) p1y, st_z(point1) p1z,
	st_x(point2) p2x, st_y(point2) p2y, st_z(point2) p2z,
	st_x(point3) p3x, st_y(point3) p3y, st_z(point3) p3z
	INTO pres_row ;
	
	
	
	--RAISE NOTICE 'probando funcion pgsql... %', nxx;--
	--nxx:= nxx + 100;
	--RAISE NOTICE 'Operando %', nxx;--
	
	RAISE NOTICE 'P1.x %', pres_row.p1x;--
	RAISE NOTICE 'P1.y %', pres_row.p1y;--
	RAISE NOTICE 'P1.z %', pres_row.p1z;--
	RAISE NOTICE '------------------';--

	RAISE NOTICE 'P2.x %', pres_row.p2x;--
	RAISE NOTICE 'P2.y %', pres_row.p2y;--
	RAISE NOTICE 'P2.z %', pres_row.p2z;--
		RAISE NOTICE '------------------';--

	RAISE NOTICE 'P3.x %', pres_row.p3x;--
	RAISE NOTICE 'P3.y %', pres_row.p3y;--
	RAISE NOTICE 'P3.z %', pres_row.p3z;--
	
	*/
	--getting the normal vector to the direction vectors
	nx:= na.y*nb.z - na.z*nb.y;
	ny:= na.x*nb.z - na.z*nb.x;
	nz:= na.x*nb.y - na.y*nb.x;
	
	
	norm= sqrt(nx*nx + ny*ny + nz*nz);
	-- result is returned as a row
	RAISE NOTICE 'nx %', nx;--
	RAISE NOTICE 'ny %', ny;--
	RAISE NOTICE 'nz %', nz;--

	SELECT ARRAY[nx/norm :: numeric,ny/norm,nz::numeric/norm::numeric] INTO results;
	return results;
END;
--no viene nada despues del end

$$
LANGUAGE plpgsql;

