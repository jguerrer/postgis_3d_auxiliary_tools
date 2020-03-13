	/*
	* This function creates  for a triangle, 
	1) the set of tetrahedrals at a minus plus distance, 
	2) search for the points within a bbox of the tetrahedrals and
	3)checks which points lie within each tetrahedal , 

	returning the points inside, the tetrahedral, side d+ d-, maybe distance.

	--This function is different form checking for each tetrahedral, the density of points, which can be done later

	--receives the points of the triangle and search  within a table


	PARAMS:
	v1,v2,v3 are the triangle verticesin r3
	dplus,dminus the ortogonal offset to create a buffer for a triangle
	pg_pointcloud , the table with a pointcloug stored with pgpointcloud
	pg_schema, the id of the used schema for the pg_pointcloud table
	pg_schema_template, an array with the dimension of a single point under the given schema
	xpos,ypos,zpos, que position within the template where tu update the coords

	*/
--	drop function t_checkPointsAgainstTriangleGeom_dynamic;
	CREATE OR REPLACE FUNCTION  t_checkPointsAgainstTriangleGeom_dynamic(
		v1 double precision[], 
		v2 double precision[], 
		v3 double precision[], 
		dplus double precision,
		dminus double precision,
		pg_pointcloud varchar,
		pg_schema integer

		) 
		RETURNS 
		TABLE(x double precision,y double precision,z double precision ,linearity double precision,planarity double precision,scattering double precision, verticality double precision)

		--void 
		AS  $$
		<< checkPointsAgainstTriangle >>
	DECLARE

		normal double precision;--used to compute the distance to the plane
		v2_v1 double precision[];
		v3_v1 double precision[];
		tets record;
	--	searchbox double precision[6];--el bbox para limitar la busqueda de cada tetraedro, se define con dos puntos del bbox
		searchbox record;--el bbox para limitar la busqueda de cada tetraedro, se define con dos puntos del bbox
		pa_patch record;--el bbox para limitar la busqueda de cada tetraedro, se define con dos puntos del bbox

		points_bbox record;--donde se guardan los puntos  encontrados

		inpoint record;

		intet record;
		counter integer;

		eachpoint record;
		
		pointcounter integer;
		intetpointcounter integer;
		
		--mytable varchar:=pg_pointcloud;--unable to use it

		bbox double precision[];


		BEGIN
			--raise notice 'START TIME: %', clock_timestamp();
			counter:=1;



		-- 1) tetrahedrals are created, six  t_Create_tet -> record 

		--The function used is select t_createtet_array(triangle.v1, triangle.v2, triangle.v3,0.5,-0.5) from triangle
			--https://www.postgresql.org/docs/11/plpgsql-control-structures.html#PLPGSQL-RECORDS-ITERATING
			FOR tets in select (t_createtet_array(v1, v2, v3,dplus,dminus)).*  order by tet_id asc
			LOOP
				--raise notice 'START TIME TET: %', clock_timestamp();
				intetpointcounter=0;
				--raise notice '# ------------------------';

				--raise notice '# %',counter || ' ' || tets.tet_id;
				--1) aqui deberia obtener el bbox, 

				--raise notice 'BBOX DIRECTO %', t_bbox(tets.v_1,tets.v_2,tets.v_3,tets.v_4);
				SELECT t_bbox(tets.v_1,tets.v_2,tets.v_3,tets.v_4) bbox  into searchbox;

				--raise notice 'SEARCHBOX record %', (searchbox);
				/*
				raise notice 'BBOX minx %', searchbox.bbox[1];
				raise notice 'BBOX miny %', searchbox.bbox[2];
				raise notice 'BBOX minz %', searchbox.bbox[3];

				raise notice 'BBOX maxx %', searchbox.bbox[4];
				raise notice 'BBOX maxy %', searchbox.bbox[5];
				raise notice 'BBOX maxz %', searchbox.bbox[6];
	*/




				--2) selecionaod puntos dentro del bbox y creando un pcpatch, que debe ser del mismo esquema

				-- hay que crear para un esquema, una plantilla y asignar valores
				-- TODO CREAR EL ARREGLO Y 

				--OBTENEMOS UN PUNTO DEL ESQUEMA DATO Y LO VACIAMOS A CERO, PARA ACTUALIZAR SU x;y;z

				--LO PASAMOS DESPUES
				SELECT 
					patch.pa patch	, 
					ST_MakeBox2d(st_pointn(PC_BoundingDiagonalGeometry(patch.pa),1),
								st_pointn(PC_BoundingDiagonalGeometry(patch.pa),2)) box
					FROM 
					(SELECT 
					PC_MakePatch(pg_schema, 
						array_cat(
							pc_createPointArray(pg_schema,	searchbox.bbox[1] , searchbox.bbox[2] ,searchbox.bbox[3]),
							pc_createPointArray(pg_schema,	searchbox.bbox[4] , searchbox.bbox[5] ,searchbox.bbox[6]))
									
									) pa 
					) patch
					
				INTO pa_patch;

				--RAISE NOTICE '#Despues de la consulta PAPATCH.PATCH %' ,pc_astext((pa_patch.patch));				
				--RAISE NOTICE '#Despues de la consulta PAPATCH.BOX %' ,st_astext(pa_patch.box);
				

				--hasta aqui ya tengo un bbox sacado del tetraedro, que se puede simplificar


			------------------------ buscando solo los puntos que me interesan
				pointcounter=0;
				intetpointcounter=0;
--				[forpointinbbox]
				for points_bbox in --iterando en cada resultado
					EXECUTE
				-----------------------------------------
					'SELECT 
						pc_get(pc_explode(points.inters),''X'') x,
						pc_get(pc_explode(points.inters),''Y'') y,
						pc_get(pc_explode(points.inters),''Z'') z,
						pc_get(pc_explode(points.inters),''Linearity'') linearity,
						pc_get(pc_explode(points.inters),''Planarity'') planarity,
						pc_get(pc_explode(points.inters),''Scattering'') scattering,
						pc_get(pc_explode(points.inters),''Verticality'') verticality

					FROM (
						select 
							pa pa,
							pc_intersection(cg.pa,
											st_setsrid(	
												st_makebox2d(
													st_point(' ||searchbox.bbox[1] ||','|| searchbox.bbox[2]|| '),st_point(' ||searchbox.bbox[4] || ',' ||searchbox.bbox[5] || '))
											,32614
											)) inters
							from 
								'||  pg_pointcloud ||' cg ,  
								(select PC_MakePatch(' ||pg_schema||', 
											array_cat(
												pc_createPointArray('||pg_schema||', '||searchbox.bbox[1]||' , '||searchbox.bbox[2]||' ,'||searchbox.bbox[3]||'),
												pc_createPointArray('||pg_schema||', '||searchbox.bbox[4]||' , '||searchbox.bbox[5]||' ,'||searchbox.bbox[6]||')
												)
									
								) patch  
									) test
							WHERE 
								PC_BoundingDiagonalGeometry(test.patch) &&& cg.geom_idx
							)points 
							' 
							--es necesario que exist la columna geom_idx, que esta indexaada por el bbox?
							--para cada conjunto de untos, calcular la interseccion, usando LOOP
					------------------------------		

					---				para  los puntos de cada patch, verificamos los tetrahedros si estan dentro
					 loop
						--para cada  conjunto de puntos que intersecten el bbox del tetraedro y la nube de puntos
						BEGIN

						/*
						raise notice 'PROBANDO POINT IN TET%', 
						tets.v_1[1] || ' ' || tets.v_1[2] || ' ' ||tets.v_1[3] || ' , ' ||
						tets.v_2[1] || ' ' || tets.v_2[2] || ' ' ||tets.v_2[3] || ' , ' ||
						tets.v_3[1] || ' ' || tets.v_3[2] || ' ' ||tets.v_3[3] || ' , ' ||
						tets.v_4[1] || ' ' || tets.v_4[2] || ' ' ||tets.v_4[3] || ' , '|| 
						points_bbox.x || ' , '||points_bbox.y || ' , '||points_bbox.z;
						*/

						pointcounter=pointcounter+1;
						SELECT  t_pointInTetrahedron(tets.v_1, tets.v_2, tets.v_3, tets.v_4 , ARRAY[pb.x,pb.y,pb.z]) isin
						FROM (SELECT points_bbox.x, points_bbox.y , points_bbox.z ) pb
						 into intet;--should be true but is false
						raise notice '%',intet;

						IF intet.isin then 
							--RAISE NOTICE 'v %',points_bbox.x || ' ' ||points_bbox.y || ' ' || points_bbox.z ;
							intetpointcounter=intetpointcounter+1;
							return query select 
							points_bbox.x::double precision x, 
							points_bbox.y::double precision y ,
							points_bbox.z::double precision z ,
							points_bbox.linearity::double precision linearity ,
							points_bbox.planarity::double precision planarity ,
							points_bbox.scattering::double precision scattering ,
							points_bbox.verticality::double precision verticality ;

						end if;

						EXCEPTION
							WHEN division_by_zero THEN 
								RAISE NOTICE '# ERROR DIV BY ZERO';
						END;








					end loop ;
									

					--raise notice ' TIME checkingPointsInTet: %', pointcounter || ' '|| intetpointcounter|| ' '|| clock_timestamp();





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
