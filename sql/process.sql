-- the steps here could probably be refactored 
-- but the benefits of cleverness would be minimal
-- and the steps serve as breakpoints for understanding
-- the process and investigating issues
-- JUST SAY NO to being clever

-- Subtract all-water planimetrics hydrography 
-- (feature_code <> 2640 and feature_code <> 2650)
-- from our borough blobs

insert into 
    clippedborough (geom) 
select 
    st_difference(a.geom
                ,(select 
                      st_union(a.geom) as geom
                  from 
                      hydrography a
                   where 
                       a.feature_code not in (2640,2650)
                  )
                 )
from
    roughborough a;

-- Subtract Westchester and Nassau (use pre-existing landmassfringe)
-- union it all
-- must keep this output (alignedborough) as an input to landmassnycdry

insert into 
    alignedborough(geom)   
select 
    st_union(c.geom)
from 
    (
    select 
        st_difference(a.geom
                     ,(select st_union(b.geom) from landmassfringe b)) as geom
    from
        clippedborough a
    ) c;

-- Add planimetrics hydro_structure 
-- (except structures attached to NJ/Nassau and any way out in water)
-- Explode multipolygons into individual records
-- BEHOLD landmassnycwet

insert into 
    landmassnycwet (geom) 
select 
    (st_dump(
            st_union(st_union(a.geom)
                    ,(select geom from alignedborough)
                    )
            )
    ).geom  
from 
    hydro_structure a
where 
    a.sub_feature_code <> '280040'
and 
    st_distance(a.geom, (select geom from alignedborough)) < 500;
                       
-- union all polygons from landmassnycwet
-- with landmassfringe to produce one giant multipolygon
-- this is landmasspangaeawet

insert into 
    landmasspangaeawet (geom)
select 
    st_union(geom)
from
    (select 
        (st_dump(geom)).geom
    from
        landmassnycwet
    union 
    select 
        geom
    from
        landmassfringe); 

-- remove interior rings (water) from alignedborough stashed above  
-- union with hydro structure  
-- explode into individual polygons
-- this is landmassnycdry

with dry as (
    select
        st_makepolygon (
            st_exteriorring((st_dump(geom)).geom)
        ) as geom
    from 
        alignedborough
) 
insert into 
    landmassnycdry (geom)
select 
    (st_dump(
            st_union(st_union(a.geom)
                    ,(select st_union(geom) from dry)
                    )
            )
    ).geom  
from 
    hydro_structure a
where 
    a.sub_feature_code <> '280040'
and 
    st_distance(a.geom, (select geom from alignedborough)) < 500;

-- remove interior rings (water) from landmasspangaeawet
-- this is landmasspangaeadry

insert into 
    landmasspangaeadry (geom)
select
    st_makepolygon (
        st_exteriorring((st_dump(geom)).geom)
    ) as geom
from 
    landmasspangaeawet;

-- explode the landmasspangaeawet multipolygon
-- this is landmassriftedwet

insert into 
    landmassriftedwet (geom) 
select 
    (st_dump(geom)).geom as geom
from
    landmasspangaeawet;

        