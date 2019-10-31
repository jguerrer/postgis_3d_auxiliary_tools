--buscar para una ubicacion, los puntos cercanos, pero primero son los patches cercanos y luego los puntos extraerlos
WITH searchbox AS (
	SELECT PC_MakePatch(1, ARRAY[	0,0,0,0,0,0,0,0,0,0,0,0,0, 476733.120, 2133116.135, 2494.829,0,0,0,0,0,0,0,0,0,0,0,0,0,476732.281 ,2133131.641, 2485.322 ]) patch)		
select cg.id,pa::geometry geom , patch from centrogeo_1 cg , searchbox where PC_Intersects( pa , searchbox.patch )



--este es el patch creado para la prueba
SELECT pc_astext(PC_MakePatch(1, ARRAY[	0,0,0,0,0,0,0,0,0,0,0,0,0, 476733.120, 2133116.135, 2494.829, 0,0,0,0,0,0,0,0,0,0,0,0,0,476732.281 ,2133131.641, 2485.322])) 

--este es el patch creado para la prueba usando un esquema x,y,z,class, user, con id 2
SELECT pc_astext(PC_MakePatch(2, ARRAY[	 476733.120, 2133116.135, 2494.829, 0,0,476732.281 ,2133131.641, 2485.322,0,0])) 

----sacando una geometria especifica de centrogeo_1, la 28, como un polygon z
select st_astext(geom) from potree_measurements where fid=28

--select (st_dumppoints(geom)).* from potree_measurements where fid=28
select st_astext((st_dumppoints(geom)).geom) from potree_measurements where fid=28

--esta funcion sirve para generar el arreglo del pcpatch a partir de una geometria 3d, que se guardo con potree_measrements
select string_agg(coords.item,',') from 
(
	select '0,0,0,0,0,0,0,0,0,0,0,0,0,' || st_x(box.geom) || ','|| st_y(box.geom) || ','|| st_z(box.geom)   item from (select (st_dumppoints(geom)).geom geom from potree_measurements where fid=28) box
) coords

--el resultado de dicha consulta es
--con schema 2:  476733.159,2133116.63,2494.654,0,0,476731.956,2133130.836,2494.881,0,0,476731.929,2133131.8,2485.422,0,0,476733.358,2133116.764,2485.01,0,0,476733.159,2133116.63,2494.654,0,0
--con schema 1  :   0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.956,2133130.836,2494.881,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.929,2133131.8,2485.422,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.358,2133116.764,2485.01,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654


--buscar para una ubicacion, los puntos cercanos, pero primero son los patches cercanos y luego los puntos extraerlos
--el esquema debe ser semejante
WITH searchbox AS (
	SELECT PC_MakePatch(1, ARRAY[	0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.956,2133130.836,2494.881,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.929,2133131.8,2485.422,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.358,2133116.764,2485.01,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654]) patch)		
select cg.id,pa::geometry geom , patch from centrogeo_1 cg , searchbox where PC_Intersects( pa , searchbox.patch )


--ahora lo hacemos con cuidado para obtener los puntos

--esta es una forma de sacar la informacion como un arreglo de texto
select PC_AsText(PC_Explode(pa))::json -> 'pt' from centrogeo_1 limit 1


--esta consulta ya devuelve un conjunto de pcpatches que solo contienen los puntos intersectados, asi que solo hay que iterar sobre ellos

WITH searchbox AS (
	SELECT PC_MakePatch(1, ARRAY[	0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.956,2133130.836,2494.881,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.929,2133131.8,2485.422,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.358,2133116.764,2485.01,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654]) patch)		

select cg.id, pa::geometry geom , (pc_astext(pc_explode(patch))::json -> 'pt') jsonarray from centrogeo_1 cg , searchbox where PC_Intersects( pa , searchbox.patch )

--sacando los puntos xyz
WITH searchbox AS (
	SELECT PC_MakePatch(1, ARRAY[	0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.956,2133130.836,2494.881,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.929,2133131.8,2485.422,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.358,2133116.764,2485.01,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654]) patch)		
select points.jsonarray ->>13 x, points.jsonarray ->>14 x, points.jsonarray ->>15 z  from (
	select cg.id, pa::geometry geom , 
	(pc_astext(pc_explode(patch))::json -> 'pt') jsonarray 
	from centrogeo_1 cg , searchbox 
	where PC_Intersects( pa , searchbox.patch ))points


--tratando de verlo como geometrias 2d
WITH searchbox AS (
	SELECT PC_MakePatch(1, ARRAY[	0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.956,2133130.836,2494.881,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.929,2133131.8,2485.422,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.358,2133116.764,2485.01,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654]) patch)		
select st_astext((st_geomfromtext('POINT (' || (points.jsonarray ->> 13) ||' '|| (points.jsonarray ->>14)  || ' ' || (points.jsonarray ->>15)  || ')'))) from (
select cg.id, pa::geometry geom , (pc_astext(pc_explode(patch))::json -> 'pt') jsonarray from centrogeo_1 cg , searchbox where PC_Intersects( pa , searchbox.patch ))points



--
WITH searchbox AS (
	SELECT PC_MakePatch(1, ARRAY[	0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.956,2133130.836,2494.881,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.929,2133131.8,2485.422,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.358,2133116.764,2485.01,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654]) patch)		
select 
cg.id, 
pa::geometry geom , 
pc_astext(pc_explode(patch))  
from centrogeo_1 cg , searchbox where PC_Intersects( pa , searchbox.patch )


--extrayendo solamenta la coodrenada X
SELECT pc_get(pc_explode(PC_MakePatch(1, ARRAY[	0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.956,2133130.836,2494.881,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.929,2133131.8,2485.422,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.358,2133116.764,2485.01,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654])) 		
					,'X')

-------
---- los cuatro puntos que se ingresan del poligono si funcionan bien
	SELECT st_force2d(st_makepoint(
	pc_get(pc_explode(PC_MakePatch(1, ARRAY[	0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.956,2133130.836,2494.881,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.929,2133131.8,2485.422,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.358,2133116.764,2485.01,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654])) ,'X'),
	pc_get(pc_explode(PC_MakePatch(1, ARRAY[	0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.956,2133130.836,2494.881,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.929,2133131.8,2485.422,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.358,2133116.764,2485.01,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654])) ,'Y'),
	pc_get(pc_explode(PC_MakePatch(1, ARRAY[	0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.956,2133130.836,2494.881,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.929,2133131.8,2485.422,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.358,2133116.764,2485.01,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654])) ,'Z')
))
		--

--------------------------------
--nuevamente, hay que buscar los patches que se intersectan con el patch de referencia y extraer sus puntos
---------
--ESTA version solo devuelve los puntos de los patches pero no los intersectados pero le falta su optimizada 23-10 2019
--de la forma que esta, toma una geometria de la db para hacer un bbox e intentar obtener los puntos de pg_pointcloud que intersectan.
--es un poco complicado porque 

WITH searchbox AS (--patch de busqueda
	SELECT 
	pc_astext(patch.pa) , 
	patch.pa patch , 
	st_Astext(PC_BoundingDiagonalGeometry(patch.pa)) diag,
	ST_MakeBox2d(st_pointn(PC_BoundingDiagonalGeometry(patch.pa),1),
				st_pointn(PC_BoundingDiagonalGeometry(patch.pa),2)) box,
	st_astext(st_pointn(PC_BoundingDiagonalGeometry(patch.pa),1)) bboxcoord1,
	st_astext(st_pointn(PC_BoundingDiagonalGeometry(patch.pa),2)) bboxcoord2

	from 
				(SELECT  
					PC_MakePatch(1, ARRAY[	0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.956,2133130.836,2494.881,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.929,2133131.8,2485.422,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.358,2133116.764,2485.01,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654] 
								) pa
										
				)patch
)		
select 
	--st_astext(
		st_force2d(st_geomfromtext('POINT (' ||
							  			pc_get(pc_explode(points.pa),'X') || ' ' ||
							   			pc_get(pc_explode(points.pa),'Y') || ' ' ||
										pc_get(pc_explode(points.pa),'Z') || ')')
	)
				   --)
	geom, 
	pc_get(pc_explode(points.pa),'X') x,--pc astext lo recorta, por lo que mejor nos quedamos con la funcion pc_Get
	pc_get(pc_explode(points.pa),'Y') y,--lo recorta
	pc_get(pc_explode(points.pa),'Z') z,
	--lo recorta
	--st_Astext(inter) diag,
	pc_astext(inters) intersected
	--st_Astext(points.bbox) bbox
from (
	select 
		cg.id, 
		pa pa,--el parche donde se busca
		pa::geometry geom ,
		--(pc_astext(pc_explode(pa))::json -> 'pt') jsonarray ,
		PC_BoundingDiagonalGeometry(searchbox.patch) inter,
		ST_MakeBox2d(st_pointn(PC_BoundingDiagonalGeometry(searchbox.patch),1),
					st_pointn(PC_BoundingDiagonalGeometry(searchbox.patch),2)
										) bbox,
		pc_intersection(cg.pa,
						st_setsrid(	
--						ST_MakeBox2D(st_pointn(PC_BoundingDiagonalGeometry(searchbox.patch),1),
--										 st_pointn(PC_BoundingDiagonalGeometry(searchbox.patch),2)
--										)
							searchbox.box
					   ,32614
						)) inters
	from 
		centrogeo_1 cg , searchbox 
	where 
		PC_Intersects( pa , searchbox.patch )
	)points

--------------------------------------------------------------------------------------------------------------

--tratando de obtener las intersecciones
--ok-. functiona  3:25pm 23/10/2019
--ya devuelve los puntos que se intersectan con el bbox,
--ahora falta obtener los puntos y compararlos contra los tetraedros

--1) se define un box y se crea un pcpatch
WITH searchbox AS (--patch de busqueda
	SELECT 
	--pc_astext(patch.pa) , 
	patch.pa patch , 
	--st_Astext(PC_BoundingDiagonalGeometry(patch.pa)) diag,
	ST_MakeBox2d(st_pointn(PC_BoundingDiagonalGeometry(patch.pa),1),
				st_pointn(PC_BoundingDiagonalGeometry(patch.pa),2)) box
	--st_astext(st_pointn(PC_BoundingDiagonalGeometry(patch.pa),1)) bboxcoord1,
	--st_astext(st_pointn(PC_BoundingDiagonalGeometry(patch.pa),2)) bboxcoord2

	from 
				(SELECT  
					PC_MakePatch(1, ARRAY[	0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.956,2133130.836,2494.881,0,0,0,0,0,0,0,0,0,0,0,0,0,476731.929,2133131.8,2485.422,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.358,2133116.764,2485.01,0,0,0,0,0,0,0,0,0,0,0,0,0,476733.159,2133116.63,2494.654] 
								) pa
										
				)patch
)
--
select 
	st_force2d(st_geomfromtext('POINT (' ||
							  			pc_get(pc_explode(points.inters),'X') || ' ' ||
							   			pc_get(pc_explode(points.inters),'Y') || ' ' ||
										pc_get(pc_explode(points.inters),'Z') || ')')
	)
				   --)
	geom, 
	pc_get(pc_explode(points.inters),'X') x,--pc astext lo recorta, por lo que mejor nos quedamos con la funcion pc_Get
	pc_get(pc_explode(points.inters),'Y') y,--lo recorta
	pc_get(pc_explode(points.inters),'Z') z
	--lo recorta
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
							searchbox.box
					   ,32614
						)) inters
	from 
		centrogeo_1 cg , searchbox 
	where 
		PC_Intersects( pa , searchbox.patch )
	)points


------------------------- generando un pcpatch estatico

WITH searchbox AS (--patch de busqueda
	SELECT 
	--pc_astext(patch.pa) , 
	patch.pa patch , 
	--st_Astext(PC_BoundingDiagonalGeometry(patch.pa)) diag,
	ST_MakeBox2d(st_pointn(PC_BoundingDiagonalGeometry(patch.pa),1),
				st_pointn(PC_BoundingDiagonalGeometry(patch.pa),2)) box
	--st_astext(st_pointn(PC_BoundingDiagonalGeometry(patch.pa),1)) bboxcoord1,
	--st_astext(st_pointn(PC_BoundingDiagonalGeometry(patch.pa),2)) bboxcoord2

	from 
				(SELECT  
					PC_MakePatch(1, 
								 --ARRAY[
								 	'{' ||
									 '0,0,0,0,0,0,0,0,0,0,0,0,0,' || '476733.159,2133116.63,2494.654,' ||
									 '0,0,0,0,0,0,0,0,0,0,0,0,0,' || '476731.956,2133130.836,2494.881, ' ||
									 '0,0,0,0,0,0,0,0,0,0,0,0,0,' || '476731.929,2133131.8,2485.422,' ||
									 '0,0,0,0,0,0,0,0,0,0,0,0,0,' || '476733.358,2133116.764,2485.01,' ||
									 '0,0,0,0,0,0,0,0,0,0,0,0,0,' || '476733.159,2133116.63,2494.654' ||
									 '}':: double precision[]
								 --] 
								) pa
										
				)patch
)
--
select 
	st_force2d(st_geomfromtext('POINT (' ||
							  			pc_get(pc_explode(points.inters),'X') || ' ' ||
							   			pc_get(pc_explode(points.inters),'Y') || ' ' ||
										pc_get(pc_explode(points.inters),'Z') || ')')
	)
				   --)
	geom, 
	pc_get(pc_explode(points.inters),'X') x,--pc astext lo recorta, por lo que mejor nos quedamos con la funcion pc_Get
	pc_get(pc_explode(points.inters),'Y') y,--lo recorta
	pc_get(pc_explode(points.inters),'Z') z
	--lo recorta
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
							searchbox.box
					   ,32614
						)) inters
	from 
		centrogeo_1 cg , searchbox 
	where 
		PC_Intersects( pa , searchbox.patch )
	)points

---


