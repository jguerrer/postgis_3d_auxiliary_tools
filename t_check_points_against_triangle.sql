/*
* This function creates  for a triangle, 
1) the set of tetrahedrals at a minus plus distance, 
2) search for the points within a bbox of the tetrahedrals and
3)checks which points lie within each tetrahedal , 

returning the points inside, the tetrahedral, side d+ d-, maybe distance.

--This function is different form checking for each tetrahedral, the density of points, which can be done later

--receives the points of the triangle and search  within a table
*/
drop function t_checkPointsAgainstTriangle;
CREATE OR REPLACE FUNCTION  t_checkPointsAgainstTriangle(
	v1 double precision[], 
	v2 double precision[], 
	v3 double precision[], 
	dplus double precision,
	dminus double precision,
	pg_pointcloud varchar,
	pg_schema integer
	) 
	RETURNS void AS  $$
<< checkPointsAgainstTriangle >>
DECLARE
	
	normal double precision;--used to compute the distance to the plane
	v2_v1 double precision[];
	v3_v1 double precision[];
	tets record;
--	searchbox double precision[6];--el bbox para limitar la busqueda de cada tetraedro, se define con dos puntos del bbox
	searchbox record;--el bbox para limitar la busqueda de cada tetraedro, se define con dos puntos del bbox
	papatch record;--el bbox para limitar la busqueda de cada tetraedro, se define con dos puntos del bbox

	points_bbox record;--donde se guardan los puntos  encontrados
	
	inpoint record;

	intet record;
	counter integer;
	BEGIN
		counter:=1;

	-- 1) tetrahedrals are created, six  t_Create_tet -> record 
		
	--The function used is select t_createtet_array(triangle.v1, triangle.v2, triangle.v3,0.5,-0.5) from triangle
		--https://www.postgresql.org/docs/11/plpgsql-control-structures.html#PLPGSQL-RECORDS-ITERATING
		FOR tets in select (t_createtet_array(v1, v2, v3,dplus,dminus)).*  
		LOOP
		
			raise notice '# ------------------------';

			raise notice '# %',counter || ' ' || tets.tet_id;
			--1) aqui deberia obtener el bbox, 
			
			--raise notice 'BBOX DIRECTO %', t_bbox(tets.v_1,tets.v_2,tets.v_3,tets.v_4);
			SELECT t_bbox(tets.v_1,tets.v_2,tets.v_3,tets.v_4) bbox into searchbox;
			
			--raise notice 'SEARCHBOX record %', (searchbox);
			/*
			raise notice 'BBOX minx %', searchbox.bbox[1];
			raise notice 'BBOX miny %', searchbox.bbox[2];
			raise notice 'BBOX minz %', searchbox.bbox[3];

			raise notice 'BBOX maxx %', searchbox.bbox[4];
			raise notice 'BBOX maxy %', searchbox.bbox[5];
			raise notice 'BBOX maxz %', searchbox.bbox[6];
*/
			

			--2) selecionaod puntos dentro del bbox y creando un pcpatch
			
			SELECT 
		
				patch.pa patch , 
				--st_Astext(PC_BoundingDiagonalGeometry(patch.pa)) diag,
				ST_MakeBox2d(st_pointn(PC_BoundingDiagonalGeometry(patch.pa),1),
							st_pointn(PC_BoundingDiagonalGeometry(patch.pa),2)) box
				--st_astext(st_pointn(PC_BoundingDiagonalGeometry(patch.pa),1)) bboxcoord1,
				--st_astext(st_pointn(PC_BoundingDiagonalGeometry(patch.pa),2)) bboxcoord2

				from 
				(SELECT  
					PC_MakePatch(1, 
					array[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0, searchbox.bbox[1] , searchbox.bbox[2] ,searchbox.bbox[3] , 	
						  0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0, searchbox.bbox[4] ,  searchbox.bbox[5] , searchbox.bbox[6] ]::double precision[]
								) pa 
										
				)patch
 			INTO papatch;
			
			RAISE NOTICE '#Despues de la consulta %' ,pc_astext(papatch.patch);
			
			--hasta aqui ya tengo un bbox sacado del tetraedro, que se puede simplificar


		------------------------ buscando solo los puntos que me interesan
		for points_bbox in (
		select 
			--st_force2d(st_geomfromtext('POINT (' ||
			--				  			pc_get(pc_explode(points.inters),'X') || ' ' ||
			--				   			pc_get(pc_explode(points.inters),'Y') || ' ' ||
			--							pc_get(pc_explode(points.inters),'Z') || ')')
			--			)
			--geom, 
			pc_get(pc_explode(points.inters),'X') x,--pc astext lo recorta, por lo que mejor nos quedamos con la funcion pc_Get
			pc_get(pc_explode(points.inters),'Y') y,--lo recorta
			pc_get(pc_explode(points.inters),'Z') z
		
			--st_Astext(inter) diag,
			--pc_astext(inters) intersected
		from (
			select 
				--cg.id, 
				pa pa,--el parche donde se busca
				--pa::geometry geom ,
				--PC_BoundingDiagonalGeometry(searchbox.patch) diag,
				--ST_MakeBox2d(st_pointn(PC_BoundingDiagonalGeometry(searchbox.patch),1),
				--			st_pointn(PC_BoundingDiagonalGeometry(searchbox.patch),2)
				--								) bbox,
				pc_intersection(cg.pa,
								st_setsrid(	
--						ST_MakeBox2D(st_pointn(PC_BoundingDiagonalGeometry(searchbox.patch),1),
--										 st_pointn(PC_BoundingDiagonalGeometry(searchbox.patch),2)
--										)
								papatch.box
					   			,32614
								)) inters
				from 
					centrogeo_1 cg ,  (select (papatch.patch) patch ) test
				where 
					PC_Intersects( pa , test.patch )
				)points 
				)
--				INTO points_bbox;

---
				 loop
					
					BEGIN
					/*
					raise notice 'PROBANDO %', 
					tets.v_1[1] || ' ' || tets.v_1[2] || ' ' ||tets.v_1[3] || ' , ' ||
					tets.v_2[1] || ' ' || tets.v_2[2] || ' ' ||tets.v_2[3] || ' , ' ||
					tets.v_3[1] || ' ' || tets.v_3[2] || ' ' ||tets.v_3[3] || ' , ' ||
					tets.v_4[1] || ' ' || tets.v_4[2] || ' ' ||tets.v_4[3] || ' , '|| 
					points_bbox.x || ' , '||points_bbox.y || ' , '||points_bbox.z;
					*/
					SELECT  t_pointInTetrahedron(tets.v_1, tets.v_2, tets.v_3, tets.v_4 , ARRAY[pb.x,pb.y,pb.z]) isin
					--select pb.*
					FROM (SELECT points_bbox.x, points_bbox.y , points_bbox.z ) pb
					 into intet;--should be true but is false
					--raise notice '%',intet;
				
					IF intet.isin then 
						RAISE NOTICE 'v %',points_bbox.x || ' ' ||points_bbox.y || ' ' || points_bbox.z ;
					end if;
				
					EXCEPTION
						WHEN division_by_zero THEN 
							RAISE NOTICE '# ERROR DIV BY ZERO';
					END;
					

						

					
					
					
					
				end loop;
				

--------------------------------------


			
	--3) comparar los puntos con cada tetraedro primero 

			
			
			--y anexar los resultados a la salida


			
			counter:=counter + 1;
		END LOOP;
		RETURN;
		
		
		--raise notice '%', tets;
	-- 2) for each tetrahedal, and the DB,  the points inside the database or pointcloud are searched, reducing the points by a bbox query and saving them
	-- 3)  each point is stored with each triangle record -trianglev1v2v3 -point p -distance D+- -normDist
    --  4) if too big, a table of triangles is stored with ids, so each requested point is added to a triangle list.

	
	
	
		--return  tets;


END;

$$
LANGUAGE plpgsql;
