--select * from potree_measurements where fid = 31
-- 1)obtener las coordenadas, 
-- 2) Generar tetrahedros

select st_astext(st_pointn(st_exteriorring(geom),1))  from potree_measurements where fid = 31;

select st_astext((geom))  from potree_measurements where fid = 31;


--alimentando con un triangulo la funcion que crea los tetrahedros, que en este caso proviene de unas mediciones sobre la nube de puntos
with triangle as (
	(select 
	 	array[st_x(st_pointn(st_exteriorring(geom),1)) ,	 st_y(st_pointn(st_exteriorring(geom),1)), st_z(st_pointn(st_exteriorring(geom),1))] v1,
		array[st_x(st_pointn(st_exteriorring(geom),2)) ,	 st_y(st_pointn(st_exteriorring(geom),2)), st_z(st_pointn(st_exteriorring(geom),2))] v2,
		array[st_x(st_pointn(st_exteriorring(geom),3)) ,	 st_y(st_pointn(st_exteriorring(geom),3)), st_z(st_pointn(st_exteriorring(geom),3))] v3

				from potree_measurements where fid = 32))--rasgo 31
select (t_createtet_array(triangle.v1, triangle.v2, triangle.v3,0.5,-0.5)).* 
--(t_createtet_array(triangle.v1, triangle.v2, triangle.v3,0.5,-0.5)).v_1 ,
--(t_createtet_array(triangle.v1, triangle.v2, triangle.v3,0.5,-0.5)).v_2 v2,
--(t_createtet_array(triangle.v1, triangle.v2, triangle.v3,0.5,-0.5)).v_3 v3,
--(t_createtet_array(triangle.v1, triangle.v2, triangle.v3,0.5,-0.5)).v_4 v4

from triangle;



--alimentando con un triangulo la funcion que crea los tetrahedros, que en este caso proviene de unas mediciones sobre la nube de puntos
with triangle as (
	(select 
	 	array[st_x(st_pointn(st_exteriorring(geom),1)) ,	 st_y(st_pointn(st_exteriorring(geom),1)), st_z(st_pointn(st_exteriorring(geom),1))] v1,
		array[st_x(st_pointn(st_exteriorring(geom),2)) ,	 st_y(st_pointn(st_exteriorring(geom),2)), st_z(st_pointn(st_exteriorring(geom),2))] v2,
		array[st_x(st_pointn(st_exteriorring(geom),3)) ,	 st_y(st_pointn(st_exteriorring(geom),3)), st_z(st_pointn(st_exteriorring(geom),3))] v3

				from potree_measurements where fid = 32))--rasgo 31
select 
(t_createtet_array(triangle.v1, triangle.v2, triangle.v3,0.5,-0.5)).* 
--(t_createtet_array(triangle.v1, triangle.v2, triangle.v3,0.5,-0.5)).v_1 ,
--(t_createtet_array(triangle.v1, triangle.v2, triangle.v3,0.5,-0.5)).v_2 v2,
--(t_createtet_array(triangle.v1, triangle.v2, triangle.v3,0.5,-0.5)).v_3 v3,
--(t_createtet_array(triangle.v1, triangle.v2, triangle.v3,0.5,-0.5)).v_4 v4

from triangle



----------------------------
--ahora haciendo llamada a la funcion real

with triangle as (
	(select 
	 	array[st_x(st_pointn(st_exteriorring(geom),1)) ,	 st_y(st_pointn(st_exteriorring(geom),1)), st_z(st_pointn(st_exteriorring(geom),1))] v1,
		array[st_x(st_pointn(st_exteriorring(geom),2)) ,	 st_y(st_pointn(st_exteriorring(geom),2)), st_z(st_pointn(st_exteriorring(geom),2))] v2,
		array[st_x(st_pointn(st_exteriorring(geom),3)) ,	 st_y(st_pointn(st_exteriorring(geom),3)), st_z(st_pointn(st_exteriorring(geom),3))] v3,
	 	0.1 dplus,
	 	-0.1 dminus,
	 	'centrogeo_1' pg_pointcloud,
	 	1 pg_schema
	from potree_measurements where fid = 36))--rasgo 31
select t_checkpointsagainsttriangle(triangle.v1, triangle.v2, triangle.v3, triangle.dplus, triangle.dminus, pg_pointcloud, pg_schema) FROM triangle;
--select triangle.v1, triangle.v2, triangle.v3, triangle.dplus, triangle.dminus, pg_pointcloud, pg_schema from triangle;


--aun falta devolver los puntos asociados.