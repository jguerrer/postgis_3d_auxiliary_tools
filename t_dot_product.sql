--cross product between two normalized vectors anchored at 0
drop function t_dot_product;
CREATE OR REPLACE FUNCTION  t_dot_product(
	v1  double precision[], 
	v2  double precision[]
)
	RETURNS  double precision AS $$
<< t_dot_product >>


DECLARE
	--the dot product is a scalar value defined as  a⋅b=a1b1+a2b2+a3b3,
	dotproduct double precision;
BEGIN
	dotproduct := v1[1]*v2[1]  +v1[2]*v2[2] + v1[3]*v2[3];
	return dotproduct;
END;
--no viene nada despues del end

$$
LANGUAGE plpgsql;
