CREATE OR REPLACE FUNCTION geom2Array(point geometry) RETURNS numeric[] AS $$

<< geom2array >>
DECLARE
	coords numeric[];
	
BEGIN

	-- computing dplus vectors
	--the  ccw requires v2-v1 and v3-v1
	
	
	
	SELECT array[st_x(point), st_y(point), st_z(point)] INTO coords;
	
	return coords;
END;
--no viene nada despues del end



$$ LANGUAGE plpgsql;