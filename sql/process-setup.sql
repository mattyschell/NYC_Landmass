-- temp
create table 
    clippedborough (gid serial4
                     ,geom geometry(multipolygon, 2263));

-- temp
create table 
    alignedborough (gid serial4
                      ,geom geometry(multipolygon, 2263));

-- deliverable
create table 
    landmassnycwet (gid serial4
                   ,geom geometry(polygon, 2263));

-- deliverable
create table 
    landmasspangaeawet (gid serial4
                       ,geom geometry(multipolygon, 2263));