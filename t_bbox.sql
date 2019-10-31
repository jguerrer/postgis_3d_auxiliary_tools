-------------------------------------
/*
* Auxiliary function to compute the bbox, which is a common function
*/
--drop function t_bbox;
CREATE OR REPLACE FUNCTION t_bbox(
	v1 double precision[] , 
	v2 double precision[] ,
	v3 double precision[] ,
	v4 double precision[] 

	
) RETURNS double precision[] AS $$
<< t_bbox >>
DECLARE
	--getting a bbox3d
	minx double precision:= '+infinity';--the bbox is an array
	miny double precision:= '+infinity';--the bbox is an array
	minz double precision:= '+infinity';--the bbox is an array
	
	maxx double precision:= '-infinity';--the bbox is an array
	maxy double precision:= '-infinity';--the bbox is an array
	maxz double precision:= '-infinity';--the bbox is an array
	
	bbox double precision[];
	
BEGIN

	

--minimos	
	IF (v1[1] <= v2[1] AND  v1[1] <= v3[1] AND  v1[1] <= v4[1])  THEN minx:=v1[1]; END IF;--ok
	IF (v2[1] <= v3[1] AND  v2[1] <= v1[1] AND  v2[1] <= v4[1])  THEN minx:=v2[1];END IF;--ok--ok
	IF (v3[1] <= v2[1] AND  v3[1] <= v1[1] AND  v3[1] <= v4[1])  THEN minx:=v3[1];END IF;--ok--ok
	IF (v4[1] <= v2[1] AND  v4[1] <= v1[1] AND  v4[1] <= v3[1])  THEN minx:=v4[1];END IF;--ok--ok


	IF (v1[2] <= v2[2] AND  v1[2] <= v3[2] AND  v1[2] <= v4[2]) THEN miny:=v1[2];END IF;--ok--ok
	IF (v2[2] <= v3[2] AND  v2[2] <= v1[2] AND  v2[2] <= v4[2]) THEN miny:=v2[2];END IF;--ok--ok
	IF (v3[2] <= v2[2] AND  v3[2] <= v1[2] AND  v3[2] <= v4[2]) THEN miny:=v3[2];END IF;--ok--ok
	IF (v4[2] <= v2[2] AND  v4[2] <= v1[2] AND  v4[2] <= v3[2]) THEN miny:=v4[2];END IF;--ok--ok


	IF (v1[3] <= v2[3] AND  v1[3] <= v3[3] AND  v1[3] <= v4[3]) THEN minz:=v1[3];END IF;--ok--ok
	IF (v2[3] <= v3[3] AND  v2[3] <= v1[3] AND  v2[3] <= v4[3]) THEN minz:=v2[3];END IF;--ok--ok
	IF (v3[3] <= v2[3] AND  v3[3] <= v1[3] AND  v3[3] <= v4[3]) THEN minz:=v3[3];END IF;--ok--ok
	IF (v4[3] <= v2[3] AND  v4[3] <= v1[3] AND  v4[3] <= v3[3]) THEN minz:=v4[3];END IF;--ok--ok

	
	
	
	IF (v1[1] >= v2[1] AND  v1[1] >=  v3[1] AND  v1[1] >=  v4[1]) THEN maxx:=v1[1];END IF;--ok--ok
	IF (v2[1] >= v3[1] AND  v2[1] >=  v1[1] AND  v2[1] >=  v4[1]) THEN maxx:=v2[1];END IF;--ok--ok
	IF (v3[1] >= v2[1] AND  v3[1] >=  v1[1] AND  v3[1] >=  v4[1]) THEN maxx:=v3[1];END IF;--ok--ok
	IF (v4[1] >= v2[1] AND  v4[1] >=  v1[1] AND  v4[1] >=  v3[1]) THEN maxx:=v4[1];END IF;--ok--ok


	IF (v1[2] >=  v2[2] AND  v1[2] >=  v3[2] AND  v1[2] >=  v4[2]) THEN maxy:=v1[2];END IF;--ok--ok
	IF (v2[2] >=  v3[2] AND  v2[2] >=  v1[2] AND  v2[2] >=  v4[2]) THEN maxy:=v2[2];END IF;--ok--ok
	IF (v3[2] >=  v2[2] AND  v3[2] >=  v1[2] AND  v3[2] >=  v4[2]) THEN maxy:=v3[2];END IF;--ok--ok
	IF (v4[2] >=  v2[2] AND  v4[2] >=  v1[2] AND  v4[2] >=  v3[2]) THEN maxy:=v4[2];END IF;--ok--ok


	IF (v1[3] >=  v2[3] AND  v1[3] >=  v3[3] AND  v1[3] >=  v4[3]) THEN maxz:=v1[3];END IF;--ok--ok
	IF (v2[3] >=  v3[3] AND  v2[3] >=  v1[3] AND  v2[3] >=  v4[3]) THEN maxz:=v2[3];END IF;--ok--ok
	IF (v3[3] >=  v2[3] AND  v3[3] >=  v1[3] AND  v3[3] >=  v4[3]) THEN maxz:=v3[3];END IF;--ok--ok
	IF (v4[3] >=  v2[3] AND  v4[3] >=  v1[3] AND  v4[3] >=  v3[3]) THEN maxz:=v4[3];END IF;--ok--ok

	/*--
	raise notice 'minx %', minx;
	raise notice 'miny %', miny;
	raise notice 'minz %', minz;
	
	raise notice 'maxx %', maxx;
	raise notice 'maxy %', maxy;
	raise notice 'maxz %', maxz;
	*/
	
	RETURN array[minx, miny, minz, maxx, maxy, maxz];

	END;
$$ LANGUAGE plpgsql;

