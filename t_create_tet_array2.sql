--drop function t_createTet_array_simple;
CREATE OR REPLACE FUNCTION t_createTet_array_simple(v1 double precision[] , v2 double precision[] , v3 double precision[] , dplus double precision, dminus double precision) 
RETURNS table(tet_id text, v_1 double precision[],v_2 double precision[],v_3 double precision[], v_4 double precision[]) AS $$

<< mainCreateTet >>
DECLARE
	-- This function starts by creating the normal vectors for each vertex of a triangle,
	v4 double precision[];
	v5 double precision[];
	v6 double precision[];
	v7 double precision[];
	v8 double precision[]; 
	v9 double precision[];
	normal double precision[];
	results  record;
		
BEGIN

	-- computing dplus vectors
	--the  ccw requires v2-v1 and v3-v1
	
	
	--calculamos la normal al triangulo
	--SELECT normal2points_array(v1,v2,v3) INTO normal;--cambiar a from
	SELECT t_getnormal_from3points_array(v1,v2,v3) INTO normal;--cambiar a from
	/*
	RAISE NOTICE 't_createTet_array';
	RAISE NOTICE 'Normal X %', normal[1];
	RAISE NOTICE 'Normal Y %', normal[2];
	RAISE NOTICE 'Normal Z %', normal[3];
	*/
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
	
	/*
		RAISE NOTICE 'v %', v1[1] ||' '|| v1[2] ||' '|| v1[3];
	RAISE NOTICE 'v %',v2[1] ||' '|| v2[2] ||' '|| v2[3];
	RAISE NOTICE 'v %',v3[1] ||' '|| v3[2] ||' '|| v3[3];
	RAISE NOTICE 'v %',v4[1] ||' '|| v4[2] ||' '|| v4[3];
	RAISE NOTICE 'v %',v5[1] ||' '|| v5[2] ||' '|| v5[3];
	RAISE NOTICE 'v %',v6[1] ||' '|| v6[2] ||' '|| v6[3];
	RAISE NOTICE 'v %',v7[1] ||' '|| v7[2] ||' '|| v7[3];
	RAISE NOTICE 'v %',v8[1] ||' '|| v8[2]||' '||  v8[3];
	RAISE NOTICE 'v %',v9[1] ||' '|| v9[2]||' '||  v9[3];
*/
	
	--el obj

/*
	RAISE NOTICE '#OBJ TEST from PGSQL';
	RAISE NOTICE 'v %',v1[1] ||' '|| v1[2] ||' '|| v1[3]|| ' 0.0 0.0 0.0';
	RAISE NOTICE 'v %',v2[1] ||' '|| v2[2] ||' '|| v2[3] || ' 0.0 0.0 0.0';
	RAISE NOTICE 'v %',v3[1] ||' '|| v3[2] ||' '|| v3[3] || ' 0.0 0.0 0.0';
	RAISE NOTICE 'v %',v4[1] ||' '|| v4[2] ||' '|| v4[3] || ' 1.0 0.0 0.0';
 	RAISE NOTICE 'v %',v5[1] ||' '|| v5[2] ||' '|| v5[3] || ' 1.0 0.0 0.0';
	RAISE NOTICE 'v %',v6[1] ||' '|| v6[2] ||' '|| v6[3] || ' 1.0 0.0 0.0';
	RAISE NOTICE 'v %',v7[1] ||' '|| v7[2] ||' '|| v7[3] || ' 0.0 0.0 1.0';
	RAISE NOTICE 'v %',v8[1] ||' '|| v8[2]||' '||  v8[3] || ' 0.0 0.0 1.0';
	RAISE NOTICE 'v %',v9[1] ||' '|| v9[2]||' '||  v9[3] || ' 0.0 0.0 1.0';

	RAISE NOTICE '#T1';
	RAISE NOTICE 'f 1 3 2';
	RAISE NOTICE 'f 1 4 3';
	RAISE NOTICE 'f 3 4 2';
	RAISE NOTICE 'f 4 1 2';
	
	RAISE NOTICE '#T2';
	RAISE NOTICE 'f 4 5 6';
	RAISE NOTICE 'f 4 2 5';
	RAISE NOTICE 'f 2 4 6';
	RAISE NOTICE 'f 2 6 5';
	
	RAISE NOTICE '#T3';
	RAISE NOTICE 'f 3 4 6';
	RAISE NOTICE 'f 6 4 2';
	RAISE NOTICE 'f 3 2 4';
	RAISE NOTICE 'f 3 6 2';
	--el lado negativo
	RAISE NOTICE '#T4';
	RAISE NOTICE 'f 1 2 3';
	RAISE NOTICE 'f 1 3 7';
	RAISE NOTICE 'f 1 7 2';
	RAISE NOTICE 'f 7 2 3';
	
	RAISE NOTICE '#T5';
	RAISE NOTICE 'f 7 3 9';
	RAISE NOTICE 'f 7 9 8';
	RAISE NOTICE 'f 7 8 3';
	RAISE NOTICE 'f 9 3 8';
	
	RAISE NOTICE '#T6';
	RAISE NOTICE 'f 8 3 2';
	RAISE NOTICE 'f 8 2 7';
	RAISE NOTICE 'f 8 7 3';
	RAISE NOTICE 'f 3 7 2';
*/
	
	-------------------
	--once tetrahedrals are defined, they are returned as a set of records
	--there are six tetrahedrals.
	
	return query 
--	SELECT 'tet1' tet_id , v1 v_1, v2 v_2, v3 v_3, v4 v_4 
--	UNION ALL
--	SELECT 'tet2' tet_id , v4 v_1, v5 v_2, v6 v_3, v2 v_4
--	UNION ALL
--	SELECT 'tet3' tet_id , v3 v_1, v4 v_2, v6 v_3, v2 v_4 
	SELECT 'tet1' tet_id , v7 v_1, v8 v_2, v9 v_3, v4 v_4 
	UNION ALL
	SELECT 'tet2' tet_id , v4 v_1, v5 v_2, v6 v_3, v8 v_4
	UNION ALL
	SELECT 'tet3' tet_id , v9 v_1, v4 v_2, v6 v_3, v8 v_4 
	
	
	
	;
	/*
	UNION ALL
	SELECT 'tet4' tet_id , v1 v_1, v2 v_2, v3 v_3, v7 v_4 
	UNION ALL
	SELECT 'tet5' tet_id , v7 v_1, v3 v_2, v9 v_3, v8 v_4 
	UNION ALL
	SELECT 'tet6' tet_id , v8 v_1, v3 v_2, v2 v_3, v7 v_4 
	;
	*/
	
--	INTO results;

	--raise notice '%',results;

	--return results;
END;



$$ LANGUAGE plpgsql;