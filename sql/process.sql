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


create table 
    step6boroughunion (gid serial4
                      ,geom geometry(multipolygon, 2263));

-- 7. Add planimetrics hydro_structure
-- 8. Explode multipolygons into individual records.

insert into 
    step6boroughunion(geom)
select 
    st_union(a.geom)
from 
    step6borough a;

create table 
    landmassnycwet (gid serial4
                   ,geom geometry(multipolygon, 2263));

insert into 
    landmassnycwet (geom) 
select 
    (st_dump(
            st_union(st_union(a.geom)
                    ,(select geom from step6boroughunion)
                    )
            )
    ).geom  
from 
    hydro_structure a
where 
    a.sub_feature_code <> '280040'
and 
    st_distance(a.geom, (select geom from step6boroughunion)) < 500;
                       

-- LandmassPangaeaWet

create table 
    pangaeawetpolys (gid serial4
                     ,geom geometry(polygon, 2263));

insert into 
    pangaeawetpolys (geom)
select 
    (st_dump(geom)).geom
from
    landmassnycwet;

insert into 
    pangaeawetpolys (geom)
select 
    geom
from
    landmassfringe;

create table 
    landmasspangaeawet (gid serial4
                       ,geom geometry(polygon, 2263));

insert into 
    landmasspangaeawet (geom)
select 
    (st_dump(st_union(geom))).geom
from
    pangaeawetpolys 

