-- Main example for testing a triangle against a pointcloud stored as a pgpointcloud
-- The points should be on the same coordinate system

EXPLAIN (ANALYZE , costs true , FORMAT text, verbose    )
with triangle as (
        (select 
                array[476741.806465,2133138.010946,2485.76] v1,
                array[476743.54,2133129.46,2485.45] v2,
                array[476741.865535,2133146.735643,2486.07] v3,
         
        0.4 dplus,
                -0.4 dminus,'centrogeo_1' pg_pointcloud,
                1 pg_schema
    ))
  
select (t_checkpointsagainsttrianglegeom(triangle.v1, triangle.v2, triangle.v3, triangle.dplus, triangle.dminus, triangle.pg_pointcloud, 1)).* FROM triangle;
	