/*
    t_interpolate_knn


	the general formula is, for a given set of positions, interpòlate the unsin g ide, 
    
*/
--drop function t_create_isoline;
CREATE OR REPLACE FUNCTION  t_interpolate_idwz(
	finalPoint double precision[],--the output position  
	points  double precision[], --set of coorindates where to interpolate Z value
	radius  double precision,--a distance to limit the search radius
    idwpower  double precision
)
	RETURNS  double precision AS $$
<< t_create_interpolate_idw >>
DECLARE

	weights double precision[];--pesos, ordenados
	x INTEGER;
	y INTEGER;
	z INTEGER;
	i INTEGER;
	distance double precision;
	distanceVector double precision[3];
	weight_i double precision;
	newpoint double precision[];
	weightedSum	double precision;
	weightedValuesSum	double precision;

	dims integer;
BEGIN
	
	/*
	

	1) First, ompute the weights for each point ans an inverse function of a distance

	3) The third point is to interplate using, requirig the sum of weights, and the sum if weights times the values
	
	.
	*/
	weightedSum:=0;
	weightedValuesSum:=0;
	x:=1;
	y:=2;
	z:=3;
	dims=array_length(points,1);
	weights=array_fill(0, array[dims]);

	RAISE NOTICE 'IDW P: %  N: % ', idwpower, array_length(points,1);
	RAISE NOTICE 'Computing Weights';
	RAISE NOTICE 'Dimensions% ', array_length(points,1);
	RAISE NOTICE 'Weights ARRAY % ', weights;
	RAISE NOTICE 'Weights % ', array_length(weights,1);
	RAISE NOTICE 'Points ARRAY % ', points;
	RAISE NOTICE 'Points % ', array_length(points,1);


	RAISE NOTICE '--------------------------------------';
	i:=1;
	FOREACH newpoint slice 1  IN array points
	LOOP
		RAISE NOTICE 'W: %		--------------------------------------',newpoint;

		--final point - point
		distanceVector[x]= finalPoint[x] - newpoint[x];
		distanceVector[y]= finalPoint[y] - newpoint[y];
        distanceVector[z]= finalPoint[z] - newpoint[z];

		RAISE NOTICE 'dv fx yx x y % % % % % %', finalPoint[x],finalPoint[y],finalPoint[z], distanceVector[x], distanceVector[y], distanceVector[z];

		--distanceVector[z]= finalPoint[i][z] - points[i][z];
--		distance=(sqrt(   distanceVector[x]*distanceVector[x] + distanceVector[y]*distanceVector[y] + distanceVector[z]*distanceVector[z]        ) );
		distance=power(sqrt(   distanceVector[x]*distanceVector[x] + distanceVector[y]*distanceVector[y] + + distanceVector[z]*distanceVector[z] ) ,idwpower);
		weights[i]= 1/distance;
		RAISE NOTICE 'Idx, Distance , Weight % % %', i , distance, weights[i];

		weightedSum=weightedSum+weights[i];
		weightedValuesSum=weightedValuesSum + (weights[i]*newpoint[z]);
		RAISE NOTICE 'weightedSum weightedValuesSum % %', weightedSum,weightedValuesSum;
		
		
		i=i+1;

	END LOOP;
	return weightedValuesSum/weightedSum;
END;

$$
LANGUAGE plpgsql;
