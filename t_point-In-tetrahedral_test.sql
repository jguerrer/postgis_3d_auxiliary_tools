-- This is a test of a point inside a tetrahedral.
--for sake of simplcity, is a simple tetrahedral anchored at 1,1,1


-- 1) testing a point in the vertices


WITH data as ( SELECT array[1.0,1.0,1.0] v1,array[2.0,1.0,1.0] v2,array[1.0,2.0,1.0] v3, array[1.0,1.0,2.0] v4, array[1.0,1.0,1.0] point)
SELECT  t_pointInTetrahedron(data.v1, data.v2, data.v3, data.v4 , data.point) from data;
WITH data as ( SELECT array[1.0,1.0,1.0] v1,array[2.0,1.0,1.0] v2,array[1.0,2.0,1.0] v3, array[1.0,1.0,2.0] v4, array[2.0,1.0,1.0] point)
SELECT  t_pointInTetrahedron(data.v1, data.v2, data.v3, data.v4 , data.point) from data;
WITH data as ( SELECT array[1.0,1.0,1.0] v1,array[2.0,1.0,1.0] v2,array[1.0,2.0,1.0] v3, array[1.0,1.0,2.0] v4, array[1.0,2.0,1.0] point)
SELECT  t_pointInTetrahedron(data.v1, data.v2, data.v3, data.v4 , data.point) from data;
WITH data as ( SELECT array[1.0,1.0,1.0] v1,array[2.0,1.0,1.0] v2,array[1.0,2.0,1.0] v3, array[1.0,1.0,2.0] v4, array[1.0,1.0,2.0] point)
SELECT  t_pointInTetrahedron(data.v1, data.v2, data.v3, data.v4 , data.point) from data;


-- 2) testing a point inside


WITH data as ( SELECT array[1.0,1.0,1.0] v1,array[2.0,1.0,1.0] v2,array[1.0,2.0,1.0] v3, array[1.0,1.0,2.0] v4, array[1.1,1.1,1.1] point)
SELECT  t_pointInTetrahedron(data.v1, data.v2, data.v3, data.v4 , data.point) from data;


-- 3) testing a point outside

WITH data as ( SELECT array[1.0,1.0,1.0] v1,array[2.0,1.0,1.0] v2,array[1.0,2.0,1.0] v3, array[1.0,1.0,2.0] v4, array[1.1,1.1,0.9] point)
SELECT  t_pointInTetrahedron(data.v1, data.v2, data.v3, data.v4 , data.point) from data;--must be false

WITH data as ( SELECT array[1.0,1.0,1.0] v1,array[2.0,1.0,1.0] v2,array[1.0,2.0,1.0] v3, array[1.0,1.0,2.0] v4, array[0.9,0.9,0.9] point)
SELECT  t_pointInTetrahedron(data.v1, data.v2, data.v3, data.v4 , data.point) from data;--must be false

-- 4) testing a point in the plane-- looks like the points are outside

WITH data as ( SELECT array[1.0,1.0,1.0] v1,array[2.0,1.0,1.0] v2,array[1.0,2.0,1.0] v3, array[1.0,1.0,2.0] v4, array[1.1,1.1,1.0] point)
SELECT  t_pointInTetrahedron(data.v1, data.v2, data.v3, data.v4 , data.point) from data;--should be true but is false

WITH data as ( SELECT array[1.0,1.0,1.0] v1,array[2.0,1.0,1.0] v2,array[1.0,2.0,1.0] v3, array[1.0,1.0,2.0] v4, array[1.0,1.1,1.1] point)
SELECT  t_pointInTetrahedron(data.v1, data.v2, data.v3, data.v4 , data.point) from data;--should be true but is false
-- 5) testing a point in the line

WITH data as ( SELECT array[1.0,1.0,1.0] v1,array[2.0,1.0,1.0] v2,array[1.0,2.0,1.0] v3, array[1.0,1.0,2.0] v4, array[1.0,1.0,1.1] point)
SELECT  t_pointInTetrahedron(data.v1, data.v2, data.v3, data.v4 , data.point) from data;--should be true but is false


WITH data as ( SELECT array[1.0,1.0,1.0] v1,array[2.0,1.0,1.0] v2,array[1.0,2.0,1.0] v3, array[1.0,1.0,2.0] v4, array[1.1,1.0,1.0] point)
SELECT  t_pointInTetrahedron(data.v1, data.v2, data.v3, data.v4 , data.point) from data;--should be true but is false
