delete from LANDMASSBOROCLIP_SDO_2263_1

select * from LANDMASSBOROCLIP_SDO_2263_1

select * from LANDMASSBOROCLIP_SDO_2263_bak

create table LANDMASSBOROCLIP_SDO_2263_bak
as select * from LANDMASSBOROCLIP_SDO_2263_1

select SDO_GEOMETRY(
    2003, 
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1, 19,2003,1), -- polygon with hole
    SDO_ORDINATE_ARRAY(2,4, 4,3, 10,3, 13,5, 13,9, 11,13, 5,13, 2,11, 2,4,
        7,5, 7,10, 10,10, 10,5, 7,5)
  ) from dual
  
  select SDO_GEOMETRY(
    2003, 
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1, 19,2003,1), -- polygon with hole
    SDO_ORDINATE_ARRAY(22,24, 24,23, 30,23, 33,25, 33,29, 31,33, 25,33, 22,31, 22,24,
        27,25, 27,30, 30,30, 30,25, 27,25)
  ) from dual
  
select sdo_util.append((select SDO_GEOMETRY(
    2003, 
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1, 19,2003,1), -- polygon with hole
    SDO_ORDINATE_ARRAY(2,4, 4,3, 10,3, 13,5, 13,9, 11,13, 5,13, 2,11, 2,4,
        7,5, 7,10, 10,10, 10,5, 7,5)
  ) from dual),
  (select SDO_GEOMETRY(
    2003, 
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1, 19,2003,1), -- polygon with hole
    SDO_ORDINATE_ARRAY(22,24, 24,23, 30,23, 33,25, 33,29, 31,33, 25,33, 22,31, 22,24,
        27,25, 27,30, 30,30, 30,25, 27,25)
  ) from dual)
) from dual


  select * from 
  LANDMASSBOROCLIP_SDO_2263_1 a
  
  
  ingeom := MDSYS.SDO_GEOMETRY
            (
               2007,
               2263,
               NULL,
               MDSYS.SDO_ELEM_INFO_ARRAY
               (
                  1,
                  1003,
                  1,
                  19,
                  2003,
                  1,
                  29,
                  1003,
                  1,
                  47,
                  2003,
                  1
               ),
               MDSYS.SDO_ORDINATE_ARRAY
               (
                  2,
                  4,
                  4,
                  3,
                  10,
                  3,
                  13,
                  5,
                  13,
                  9,
                  11,
                  13,
                  5,
                  13,
                  2,
                  11,
                  2,
                  4,
                  7,
                  5,
                  7,
                  10,
                  10,
                  10,
                  10,
                  5,
                  7,
                  5,
                  22,
                  24,
                  24,
                  23,
                  30,
                  23,
                  33,
                  25,
                  33,
                  29,
                  31,
                  33,
                  25,
                  33,
                  22,
                  31,
                  22,
                  24,
                  27,
                  25,
                  27,
                  30,
                  30,
                  30,
                  30,
                  25,
                  27,
                  25
               )
            );
  
  select sdo_geom.validate_geometry_with_context(a.shape, .0005) from 
  LANDMASSBOROCLIP_SDO_2263_1 a
  
select gis_utils.dump_sdo((select sdo_util.append((select SDO_GEOMETRY(
    2003, 
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1, 19,2003,1), -- polygon with hole
    SDO_ORDINATE_ARRAY(2,4, 4,3, 10,3, 13,5, 13,9, 11,13, 5,13, 2,11, 2,4,
        7,5, 7,10, 10,10, 10,5, 7,5)
  ) from dual),
  (select SDO_GEOMETRY(
    2003, 
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1, 19,2003,1), -- polygon with hole
    SDO_ORDINATE_ARRAY(22,24, 24,23, 30,23, 33,25, 33,29, 31,33, 25,33, 22,31, 22,24,
        27,25, 27,30, 30,30, 30,25, 27,25)
  ) from dual)
) from dual)) from 
LANDMASSBOROCLIP_SDO_2263_1 a

MDSYS.SDO_GEOMETRY
(
   2007,
   NULL,
   NULL,
   MDSYS.SDO_ELEM_INFO_ARRAY
   (
      1,
      1003,
      1,
      19,
      2003,
      1,
      29,
      1003,
      1,
      47,
      2003,
      1
   ),
   MDSYS.SDO_ORDINATE_ARRAY
   (
      2,
      4,
      4,
      3,
      10,
      3,
      13,
      5,
      13,
      9,
      11,
      13,
      5,
      13,
      2,
      11,
      2,
      4,
      7,
      5,
      7,
      10,
      10,
      10,
      10,
      5,
      7,
      5,
      22,
      24,
      24,
      23,
      30,
      23,
      33,
      25,
      33,
      29,
      31,
      33,
      25,
      33,
      22,
      31,
      22,
      24,
      27,
      25,
      27,
      30,
      30,
      30,
      30,
      25,
      27,
      25
   )
)


MDSYS.SDO_GEOMETRY
(
   2003,
   2263,
   NULL,
   MDSYS.SDO_ELEM_INFO_ARRAY
   (
      1,
      1003,
      1
   ),
   MDSYS.SDO_ORDINATE_ARRAY
   (
      2,
      4,
      4,
      3,
      10,
      3,
      13,
      5,
      13,
      9,
      11,
      13,
      5,
      13,
      2,
      11,
      2,
      4
   )
)


select gis_utils.COUNT_RINGS(a.shape) from master.LANDMASSBOROCLIP_SDO_2263_1 a 
where a.objectid = 1


select sdo_geom.relate((select SDO_GEOMETRY(
    2003, 
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1, 19,2003,1), -- polygon with hole
    SDO_ORDINATE_ARRAY(2,4, 4,3, 10,3, 13,5, 13,9, 11,13, 5,13, 2,11, 2,4,
        7,5, 7,10, 10,10, 10,5, 7,5)
  ) from dual), 'INSIDE+EQUAL', (select SDO_GEOMETRY(
    2003, 
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1, 19,2003,1), -- polygon with hole
    SDO_ORDINATE_ARRAY(2,4, 4,3, 10,3, 13,5, 13,9, 11,13, 5,13, 2,11, 2,4,
        7,5, 7,10, 10,10, 10,5, 7,5)
  ) from dual), .0005) from dual

  
  ORA-01403: no data found
ORA-06512: at "MSCHELL.GIS_UTILS", line 23
ORA-06512: at "MSCHELL.GIS_UTILS", line 2832
ORA-06512: at "MSCHELL.GIS_UTILS", line 2911
ORA-06512: at line 11