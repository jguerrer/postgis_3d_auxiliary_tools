drop function createTet_array;
CREATE OR REPLACE FUNCTION createTet_array(v1 numeric[] , v2 numeric[] , v3 numeric[] , dplus numeric, dminus numeric) RETURNS numeric[] AS $$

<< mainCreateTet >>
DECLARE
	-- This function starts by creating the normal vectors for each vertex of a triangle,
	v4 numeric[];
	v5 numeric[];
	v6 numeric[];
	v7 numeric[];
	v8 numeric[]; 
	v9 numeric[];
	normal numeric[];
	
BEGIN

	-- computing dplus vectors
	--the  ccw requires v2-v1 and v3-v1
	
	
	--calculamos la normal al triangulo
	SELECT normal2points_array(v1,v2,v3) INTO normal;--cambiar a from
	RAISE NOTICE 'createTet_array';
	RAISE NOTICE 'Normal X %', normal[1];
	RAISE NOTICE 'Normal Y %', normal[2];
	RAISE NOTICE 'Normal Z %', normal[3];
	
	--with a normal vector to a triangle, proceed to create the next vertices.
	--such creating will be created as a formula of precomputed vertices
	--in total, six vertices will be created and three tetrahedrals per side
	--results will be returned as collection of POLYHEDRALSURFACE Z
	
	--first, the new vertices will be computed as vk= v0 * D*v_n
	
	--v4 is an array as follows
	v4 := array[ v1[1] + dplus*normal[1], v1[2] + dplus*normal[2], v1[3] + dplus*normal[3]   ];
	v5 := array[ v2[1] + dplus*normal[1], v2[2] + dplus*normal[2], v2[3] + dplus*normal[3]   ];
	v6 := array[ v3[1] + dplus*normal[1], v3[2] + dplus*normal[2], v3[3] + dplus*normal[3]   ];
	
	v7 := array[ v1[1] + dminus*normal[1], v1[2] + dminus*normal[2], v1[3] + dminus*normal[3]   ];
	v8 := array[ v2[1] + dminus*normal[1], v2[2] + dminus*normal[2], v2[3] + dminus*normal[3]   ];
	v9 := array[ v3[1] + dminus*normal[1], v3[2] + dminus*normal[2], v3[3] + dminus*normal[3]   ];
	
	--para fines de prueba, cada tetrahedro se compondra de sus indices? hacer un obj??
	
	--primero hacemos uno
	--t1 es (1,3,2,1), (1,4,3,1), (3,4,2,3),(4,1,2,4), todos ccw
	
	--para facilitar la vida, primero jugamos al obj
	
	RAISE NOTICE '#OBJ TEST from PGSQL';
	RAISE NOTICE 'v %', v1[1] ||' '|| v1[2] ||' '|| v1[3];
	RAISE NOTICE 'v %',v2[1] ||' '|| v2[2] ||' '|| v2[3];
	RAISE NOTICE 'v %',v3[1] ||' '|| v3[2] ||' '|| v3[3];
	RAISE NOTICE 'v %',v4[1] ||' '|| v4[2] ||' '|| v4[3];
	RAISE NOTICE 'v %',v5[1] ||' '|| v5[2] ||' '|| v5[3];
	RAISE NOTICE 'v %',v6[1] ||' '|| v6[2] ||' '|| v6[3];
	RAISE NOTICE 'v %',v7[1] ||' '|| v7[2] ||' '|| v7[3];
	RAISE NOTICE 'v %',v8[1] ||' '|| v8[2]||' '||  v8[3];
	RAISE NOTICE 'v %',v9[1] ||' '|| v9[2]||' '||  v9[3];
	
	RAISE NOTICE 'f 1 3 2 1';
	RAISE NOTICE 'f 1 4 3 1';
	RAISE NOTICE 'f 3 4 2 3';
	RAISE NOTICE 'f 4 1 2 4';
	
	RAISE NOTICE 'f 4 5 6 4';
	RAISE NOTICE 'f 4 2 5 4';
	RAISE NOTICE 'f 2 4 6 2';
	RAISE NOTICE 'f 2 6 5 2';
	
	RAISE NOTICE 'f 3 4 6 3';
	RAISE NOTICE 'f 6 4 2 6';
	RAISE NOTICE 'f 3 2 4 3';
	RAISE NOTICE 'f 3 6 2 3';
	--el lado negativo
	
	RAISE NOTICE 'f 1 2 3 1';
	RAISE NOTICE 'f 1 3 7 1';
	RAISE NOTICE 'f 1 2 7 1';
	RAISE NOTICE 'f 7 2 3 7';
	
	RAISE NOTICE 'f 7 3 9 7';
	RAISE NOTICE 'f 7 9 8 7';
	RAISE NOTICE 'f 7 8 3 7';
	RAISE NOTICE 'f 9 3 8 9';
	
	RAISE NOTICE 'f 8 3 2 8';
	RAISE NOTICE 'f 8 2 7 8';
	RAISE NOTICE 'f 8 7 3 8';
	RAISE NOTICE 'f 3 7 2 3';
	
	
	
	
	return normal;
END;
--no viene nada despues del end



$$ LANGUAGE plpgsql;