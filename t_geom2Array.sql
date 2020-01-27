CREATE OR REPLACE FUNCTION t_geom2Array(point geometry) RETURNS double precision[] AS $$

<< geom2array >>
DECLARE
	coords double precision[];
	
BEGIN

	-- computing dplus vectors
	--the  ccw requires v2-v1 and v3-v1
	
	
	
	SELECT array[st_x(point), st_y(point), st_z(point)] INTO coords;
	
	return coords;
END;
--no viene nada despues del end



$$ LANGUAGE plpgsql;