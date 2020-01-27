WITH testData AS (
    SELECT 
        array[3,3,0]::double precision[] finalpoint,
        array[[0,1,0 ],[1,0,1 ],[1,1,2 ],[2,1,3 ],[1,3,4 ],[5,3,5 ]]::double precision[] points,
        1.0::double precision radius,
        2.0::double precision idwpower
        

)
select 
t_interpolate_idw(finalpoint, points, radius, idwpower) FROM testData;
--select array_fill(1,ARRAY[3],ARRAY[2]) --from testData;
----------------------------
--Ahora intentamos desde la tablad e lidar, buscando una vecindad

select st_distance (t1.geom, t2.geom),t2.* from tarango t1,tarango t2 where st_dwithin(t1.geom,t2.geom ,10.0) AND t1.id=9545079 
select count(t2.geom) from tarango t1,tarango t2 where st_dwithin(t1.geom,t2.geom ,10.0) AND t1.id=9545079 

--lo siguiente es convertir esta consulta en un arreglo de resultados

select array_length(array(SELECT array[t2.x,t2.y,t2.z] from tarango t1,tarango t2 where st_dwithin(t1.geom,t2.geom ,10.0) AND t1.id=9545079  ),1)
select array( SELECT array[t2.x,t2.y,t2.z] from tarango t1,tarango t2 where st_dwithin(t1.geom,t2.geom ,10.0) AND t1.id=9545079  );-- este genera el arreglo


-------,, aqui el punto tenia un valor de 2401.56 y el interpolado es de 2393.7092 r 5
--esta es la consulta final donde para un punto dado por su id, se buscan sus vecinos a distancia R y con cierta potencia, se asigna un valor nuevo
with test_data as (
select 
	array( SELECT  array[t2.x,t2.y,t2.z] from tarango t1,tarango t2 where st_dwithin(t1.geom,t2.geom ,5.0) AND t1.id=9545079 and  t1.id<>t2.id ) points,
	array[t.x,t.y,t.z] final_point 
	from tarango t  
	where t.id=9545079  -- este genera el arreglo

)
select test_data.final_point[1],test_data.final_point[2] , t_interpolate_idwz(test_data.final_point, test_data.points, 10, 1.3) z    FROM test_data;

--tarda pero funciona





