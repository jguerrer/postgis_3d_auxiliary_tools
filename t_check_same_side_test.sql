-- This is a test of a point inside a tetrahedral.
--for sake of simplcity, is a simple tetrahedral anchored to the origin.
-- the border is not considered as inside. Fix it later

--this should be true, if the point is colinear between points
WITH data as ( SELECT array[1.0,1.0,1.0] v1,array[2.0,1.0,1.0] v2,array[1.0,2.0,1.0] v3, array[1.0,1.0,2.0] v4, array[1.1,1.1,1.1] point)
SELECT  t_checksameside(data.v1, data.v2, data.v3, data.v4 , data.point) from data;


--this should be false, as vertices are not inside
--may cause trouble
WITH data as ( SELECT array[1.0,1.0,1.0] v1,array[2.0,1.0,1.0] v2,array[1.0,2.0,1.0] v3, array[1.0,1.0,2.0] v4, array[1.0,1.0,1.0] point)
SELECT  t_checksameside(data.v1, data.v2, data.v3, data.v4 , data.point) from data;


--this should be true, as a point within the face.
WITH data as ( SELECT array[1.0,1.0,1.0] v1,array[2.0,1.0,1.0] v2,array[1.0,2.0,1.0] v3, array[1.0,1.0,2.0] v4, array[1.1,1.0,1.1] point)
SELECT  t_checksameside(data.v1, data.v2, data.v3, data.v4 , data.point) from data;