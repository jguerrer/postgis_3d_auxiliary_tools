--Given a triangle specified by three points and a range of values, the corresponding isolines are created, one per value.
--first it checks wheter any value of the intervals lies within the z values.
--the list of values is ordered in ascending order
--drop function t_create_isoline;
CREATE OR REPLACE FUNCTION  t_create_isoline_triangle_2_geom(
	triangle geometry, 
    intervals double precision[] 

)
	RETURNS  geometry AS $$
<< t_create_isoline >>
DECLARE
    g1 geometry;
	g2 geometry;
	g3 geometry;
	
	v1  double precision[];
	v2  double precision[];
    v3  double precision[];

	z1 double precision;
	z2 double precision;
	z3 double precision;
	val double precision;

	z12 double precision;--the big Z, the constant
	z23 double precision;
	z31 double precision;


	zmin double precision;
	zmax double precision;
	zcounter integer;
	
	p12 double precision[];--puntos de interseccion
	p23 double precision[];
	p31 double precision[];


	d12 double precision[];--puntos de interseccion
	d23 double precision[];
	d31 double precision[];
	line geometry;
	
BEGIN
	
	
	g1=st_pointn(st_exteriorring(triangle),1); 
	g2=st_pointn(st_exteriorring(triangle),2); 
	g3=st_pointn(st_exteriorring(triangle),3);
	
	--RAISE NOTICE 'Geometries.. ';
	--RAISE NOTICE 'g1 %', st_astext(g1);--
	--RAISE NOTICE 'g2 %', st_Astext(g2);--	
	--RAISE NOTICE 'g3 %', st_Astext(g3);--
	
	v1[1]=st_x(g1);
	v1[2]=st_y(g1);
	v1[3]=st_z(g1);
	
	v2[1]=st_x(g2);
	v2[2]=st_y(g2);
	v2[3]=st_z(g2);
	
	v3[1]=st_x(g3);
	v3[2]=st_y(g3);
	v3[3]=st_z(g3);

	zcounter:=0;
	--direction vectors
	z1:=v1[3];
	z2:=v2[3];
	z3:=v3[3];

	--RAISE NOTICE 'Comparing Z values with list.. ';
	--RAISE NOTICE 'z1 %', z1;--
	--RAISE NOTICE 'z2 %', z2;--	
	--RAISE NOTICE 'z3 %', z3;--
	--for a given z value, it must be between the maximum and minimum of the array

	zmin=intervals[1];
	zmax=intervals[array_length(intervals,1)];

	--RAISE NOTICE 'zmin %', zmin;--	
	--RAISE NOTICE 'zmax %', zmax;--

	p12[1]=-1;
	p23[1]=-1;
	p31[1]=-1;

	IF (zmin <= z1  AND z1 <= zmax) THEN 	
		RAISE NOTICE 'z1 INSIDE ';--
		zcounter:=zcounter+1;
	END IF;

	IF (zmin <= z2  AND z2<= zmax) THEN 	
		RAISE NOTICE 'z2 INSIDE ';--	
		zcounter:=zcounter+1;
	END IF;
	IF (zmin <= z3  AND z3 <= zmax) THEN 	
		RAISE NOTICE 'z3 INSIDE ';--	
		zcounter:=zcounter+1;
	END IF;

	IF (zcounter = 0) THEN 
		RAISE NOTICE 'OUTSIDE... Skipping...';
	END IF;

	IF (zcounter = 1) THEN 
		RAISE NOTICE 'TOUCHES 1 POINT... DOING NOTHING';
	END IF;
	IF (zcounter = 2) THEN 
		RAISE NOTICE 'INSIDE, 2 VALUES...';
	END IF;
	IF (zcounter = 3) THEN 
		RAISE NOTICE 'INSIDE, 3 VALUES...';
	END IF;


	--para cada valor regresamos los puntos de entrada y salida
	--si coincide con un solo par, solo toma un punto
	--si coincide con dos pares, alli entra y sale, entre dos lineas
	-- si coincide con tres pares, entonces entra por un punto
	FOREACH val IN ARRAY intervals
	LOOP
		RAISE NOTICE '		--------------------------------------';
		--check if a given value falls inside
		--three combinations exists
		--z1 z2 , z2 z3, z3 z1
		RAISE NOTICE 'VAL: % z1:% z2:% z3:%',val,z1, z2,z3;
		
		zmin=z1;
		zmax=z2;
		IF (z1 >= z2) THEN
			zmin=z2;
			zmax=z1;
		END IF;

		IF (zmin <= val  AND val <= zmax AND zmin <> zmax) THEN 	
			RAISE NOTICE '% BETWEEN Z1= % Z2= % ',val,z1,z2;--
			--we require an equation to solve the XY position

			--Vector de direccion
			d12[1]=v2[1]-v1[1];
			d12[2]=v2[2]-v1[2];
			d12[3]=v2[3]-v1[3];

			z12:=((val) - (z1))/d12[3];--la z conocida
			-- LA X, Y nuevas
			p12[1]= (z12*d12[1]) + v1[1];--TEMPORARY
			p12[2]= (z12*d12[2]) + v1[2];
			p12[3]=val;

			RAISE NOTICE 'PUNTO_12: % % %',p12[1],p12[2],p12[3];
			--return NEXT p12;

		END IF;
		--------------------------------------
		zmin=z2;
		zmax=z3;
		IF (z2 >= z3) THEN
			zmin=z3;
			zmax=z2;
		END IF;

		IF (zmin <= val  AND val <= zmax AND zmin <> zmax) THEN 	
			RAISE NOTICE '% BETWEEN Z2= % Z3= % ',val,z2,z3;--
			--we require an equation to solve the XY position	
			
			--
			
			
			--Vector de direccion
			d23[1]=v3[1]-v2[1];
			d23[2]=v3[2]-v2[2];
			d23[3]=v3[3]-v2[3];--hay que tener cuidado cuano este valor sea igual, porque da cero

			z23:=((val) - (z2))/d23[3];--la z conocida
			-- LA X, Y nuevas
			p23[1]= (z23*d23[1]) + v2[1];--TEMPORARY
			p23[2]= (z23*d23[2]) + v2[2];
			p23[3]=val;

			RAISE NOTICE 'PUNTO_23 : % % %',p23[1],p23[2],p23[3];
			--return NEXT p23;

		END IF;

		--------------------------------------
		zmin=z3;
		zmax=z1;
		IF (z3 >= z1) THEN
			zmin=z1;
			zmax=z3;
		END IF;

		IF (zmin <= val  AND val <= zmax AND zmin <> zmax) THEN 	
			RAISE NOTICE '% BETWEEN Z3= % Z1= % ',val,z3,z1;--
			--we require an equation to solve the XY position	

--Vector de direccion
			d31[1]=v1[1]-v3[1];
			d31[2]=v1[2]-v3[2];
			d31[3]=v1[3]-v3[3];

			z31:=((val) - (z3))/d31[3];--la z conocida
			-- LA X, Y nuevas
			p31[1]= (z31*d31[1]) + v3[1];--TEMPORARY
			p31[2]= (z31*d31[2]) + v3[2];
			p31[3]=val;

			RAISE NOTICE 'PUNTO_31  : % % %',p31[1],p31[2],p31[3];
			--return NEXT p31;

		END IF;

		--RAISE NOTICE '%',array_length(p12,1);
		--RAISE NOTICE '%',array_length(p23,1);
		--RAISE NOTICE '%',array_length(p31,1);

		--RAISE NOTICE '%',p12;
		--RAISE NOTICE '%',p23;
		--
		RAISE NOTICE '%',p31;


		IF (array_length(p31,1) = 1) THEN
			line =  st_linefromtext('LINESTRING('|| p12[1] ||' ' || p12[2] ||' ' || p12[3]  ||  ','|| p23[1] ||' ' || p23[2] ||' ' || p23[3] ||')');
			RAISE NOTICE '12 23 %',line;
		END IF;

		IF (array_length(p23,1)=1) THEN
			line =  st_linefromtext('LINESTRING('|| p12[1] ||' ' || p12[2] ||' ' || p12[3]  ||  ','|| p31[1] ||' ' || p31[2] ||' ' || p31[3] ||')');
			RAISE NOTICE '12 31 %',line;
		END IF;

		IF (array_length(p12,1)=1) THEN
			line =  st_linefromtext('LINESTRING('|| p23[1] ||' ' || p23[2] ||' ' || p23[3]  ||  ','|| p31[1] ||' ' || p31[2] ||' ' || p31[3] ||')');
			RAISE NOTICE '23 31 %',line;

	END IF;


	END LOOP;

	

	return line;
	-- result is returned as a row
	
	/*
	RAISE NOTICE 'nx %', nx;--
	RAISE NOTICE 'ny %', ny;--
	RAISE NOTICE 'nz %', nz;--
	*/
	
--  
	--return array[0.0,0.0,0.0];
END;
--no viene nada despues del end

$$
LANGUAGE plpgsql;
