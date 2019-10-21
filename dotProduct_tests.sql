WITH  coords AS (select normal2points(
	st_geomfromtext('POINT(1 1 1)') ,
	st_geomfromtext('POINT(2 1 1)') ,
	st_geomfromtext('POINT(1 2 1)') ) normal ) 
SELECT dotproduct(coords.normal, coords.normal)  FROM coords