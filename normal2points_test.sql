WITH  coords AS (select normal2points(
	st_geomfromtext('POINT(1 1 1)') ,
	st_geomfromtext('POINT(2 1 1)') ,
	st_geomfromtext('POINT(1 2 1)') ) normal ) 
SELECT coords.normal[1] x , coords.normal[2] y, coords.normal[3] z FROM coords