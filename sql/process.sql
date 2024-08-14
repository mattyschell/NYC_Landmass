set search_path to landmass, public;


--refactor with cte?  But seems slower
create table 
    hydrographyunion (gid serial4
                     ,geom geometry(multipolygon, 2263));

-- 4. Subtract all-water planimetrics hydrography 
-- (feature_code <> 2640 and feature_code <> 2650)
insert into 
    hydrographyunion(geom)
select 
    st_union(a.geom)
from 
    hydrography a
where 
    a.feature_code not in (2640,2650);

create table 
    hydroclipborough (gid serial4
                     ,geom geometry(multipolygon, 2263));

insert into 
    hydroclipborough (geom) 
select 
    st_difference(a.geom
                 ,(select geom from hydrographyunion))
from
    roughborough a;

-- 6. Subtract Westchester and Nassau (use landmassfringe)

create table 
    step6borough (gid serial4
                 ,geom geometry(multipolygon, 2263));

insert into 
    step6borough (geom) 
select 
    st_difference(a.geom
                 ,(select st_union(b.geom) from landmassfringe b))
from
    hydroclipborough a;