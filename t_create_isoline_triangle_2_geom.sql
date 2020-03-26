--Given a triangle specified by three points and a range of values, the corresponding isolines are created, one per value.
--first it checks wheter any value of the intervals lies within the z values.
--the list of values is ordered in ascending order
--drop function t_create_isoline_triangle_2_geom;
CREATE OR REPLACE FUNCTION  t_create_isoline_triangle_2_geom(
	triangle geometry, 
    elevation double precision 

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
	
	results double precision[];--sera un arreglo de seis cosas
	results_counter integer;
	line geometry;
	
BEGIN
	
	
	g1=st_pointn(st_exteriorring(triangle),1); 
	g2=st_pointn(st_exteriorring(triangle),2); 
	g3=st_pointn(st_exteriorring(triangle),3);
	
	/*
	RAISE NOTICE 'Geometries.. ';
	RAISE NOTICE 'g1 %', st_astext(g1);--
	RAISE NOTICE 'g2 %', st_Astext(g2);--	
	RAISE NOTICE 'g3 %', st_Astext(g3);--
	RAISE NOTICE 'v %', elevation;--
	*/
	
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




	p12[1]=-1;
	p23[1]=-1;
	p31[1]=-1;

	results[1]=-1;


	--para cada valor regresamos los puntos de entrada y salida
	--si coincide con un solo par, solo toma un punto
	--si coincide con dos pares, alli entra y sale, entre dos lineas
	-- si coincide con tres pares, entonces entra por un punto
	
	
	-- no es una unica salida, hay que encontrar
	
	results_counter=0;
		--RAISE NOTICE '-------------------------------------';

		--check if a given value falls inside
		--three combinations exists
		--z1 z2 , z2 z3, z3 z1
		--RAISE NOTICE 'VAL: %  ,   z1:% z2:% z3:%',elevation,z1, z2,z3;
		------------------------------------------------------------------------
		
		
		--RAISE NOTICE '-------------------------------------- 	Checking p12	';

		--ordenando valores
		zmin=z1;
		zmax=z2;
		IF (z1 > z2) THEN
			zmin=z2;
			zmax=z1;
		END IF;

		--si esta completamente dentro, no hay problemas de indefiniciones
		--se genera un punto
		
		IF (zmin < elevation  AND elevation < zmax ) THEN 	--excluimos  si son planos
			--RAISE NOTICE '>> % : BETWEEN Z1= % Z2= % ',elevation,z1,z2;--
			--we require an equation to solve the XY position

			--Vector de direccion
			d12[1]=v2[1]-v1[1];
			d12[2]=v2[2]-v1[2];
			d12[3]=v2[3]-v1[3];

			z12:=((elevation) - (z1))/d12[3];--la z conocida
			-- LA X, Y nuevas
			p12[1]= (z12*d12[1]) + v1[1];--TEMPORARY
			p12[2]= (z12*d12[2]) + v1[2];
			p12[3]=elevation;
			
			results[results_counter+1]=p12[1];
			results[results_counter+2]=p12[2];
			results[results_counter+3]=p12[3];
			results_counter=results_counter + 3;
			
			--return NEXT p12;

		END IF;
		--------------------------------------
		--RAISE NOTICE '-------------------------------------- 	Checking p23	';

		zmin=z2;
		zmax=z3;
		IF (z2 > z3) THEN
			zmin=z3;
			zmax=z2;
		END IF;

		IF (zmin < elevation  AND elevation < zmax ) THEN 	
			--RAISE NOTICE '>> % : BETWEEN Z2= % Z3= % ',elevation,z2,z3;--
			--we require an equation to solve the XY position	
			
			--Vector de direccion
			d23[1]=v3[1]-v2[1];
			d23[2]=v3[2]-v2[2];
			d23[3]=v3[3]-v2[3];--hay que tener cuidado cuano este valor sea igual, porque da cero

			z23:=((elevation) - (z2))/d23[3];--la z conocida
			-- LA X, Y nuevas
			p23[1]= (z23*d23[1]) + v2[1];--TEMPORARY
			p23[2]= (z23*d23[2]) + v2[2];
			p23[3]=elevation;
			
			results[results_counter+1]=p23[1];
			results[results_counter+2]=p23[2];
			results[results_counter+3]=p23[3];
			results_counter=results_counter + 3;

			--return NEXT p23;

		END IF;

		--------------------------------------
		--RAISE NOTICE '	-------------------------------------- Checking p31	';

		zmin=z3;
		zmax=z1;
		IF (z3 > z1) THEN
			zmin=z1;
			zmax=z3;
		END IF;

		IF (zmin < elevation  AND elevation < zmax ) THEN 	
			--RAISE NOTICE '>> % : BETWEEN Z3= % Z1= % ',elevation,z3,z1;--
			--we require an equation to solve the XY position	

--Vector de direccion
			d31[1]=v1[1]-v3[1];
			d31[2]=v1[2]-v3[2];
			d31[3]=v1[3]-v3[3];

			z31:=((elevation) - (z3))/d31[3];--la z conocida
			-- LA X, Y nuevas
			p31[1]= (z31*d31[1]) + v3[1];--TEMPORARY
			p31[2]= (z31*d31[2]) + v3[2];
			p31[3]=elevation;
			
			RAISE NOTICE 'Crosses P31= % % % ',p31[1],p31[2],p31[3];--

			results[results_counter+1]=p31[1];
			results[results_counter+2]=p31[2];
			results[results_counter+3]=p31[3];
			results_counter=results_counter + 3;
		END IF;

				
		--si el valor coincide con algun extremo, hay que extraer dicho punto y agregarlo
		
		IF ( elevation = z1) THEN 
			--RAISE NOTICE 'Crosses P1= % % % ',v1[1],v1[2],v1[3];--

			results[results_counter+1] =v1[1];
			results[results_counter+2]= v1[2];
			results[results_counter+3]= v1[3];
			results_counter=results_counter + 3;
		END IF;
		IF ( elevation = z2) THEN 	
			--RAISE NOTICE 'Crosses P2= % % % ',v2[1],v2[2],v2[3];--

			results[results_counter+1] =v2[1];
			results[results_counter+2]= v2[2];
			results[results_counter+3]= v2[3];
			results_counter=results_counter + 3;
		END IF;
		IF ( elevation = z3) THEN 	
			--RAISE NOTICE 'Crosses P3= % % % ',v3[1],v3[2],v3[3];--

			results[results_counter+1] =v3[1];
			results[results_counter+2]= v3[2];
			results[results_counter+3]= v3[3];
			results_counter=results_counter + 3;
		END IF;

		--RAISE NOTICE 'LINE % % % , % % %', results[1], results[2] , results[3] , results[4] ,results[5] ,results[6] ;


		
		line =  st_linefromtext('LINESTRING('|| results[1] ||' ' || results[2] ||' ' || results[3]  ||  ','|| results[4] ||' ' || results[5] ||' ' || results[6] ||')');
		--RAISE NOTICE 'LINE %',line;

		



	

	

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
