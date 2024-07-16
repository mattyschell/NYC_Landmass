select * from LANDMASSEXT_SDO_2263_2

 PROCEDURE INSERT_GDS_METADATA (
      p_objectname      IN VARCHAR2,
      p_datastore       IN VARCHAR2,
      p_metadata_tab    IN VARCHAR2 DEFAULT 'GEODATASHARE_METADATA',
      p_metadata_seq    IN VARCHAR2 DEFAULT 'GEODATASHARE_METADATASEQ',
      p_replace         IN VARCHAR2 DEFAULT 'N'
   )
   AS
   
call gds_metadata.update_gds_metadata('LANDMASSEXT_SDO_2263_2', 'LANDMASS');

select * from geodatashare_metadata
where deleted = 'N'
order by date_last_modified desc

select * from geodatashare_metadata
where object_name like 'LANDMASSPANW%'


select gis_utils.dump_sdo(a.shape) from
landmassext_sdo_2263_1 a



--old extent landmassext_sdo_2263_1
MDSYS.SDO_GEOMETRY
(
   2003,
   2263,
   NULL,
   MDSYS.SDO_ELEM_INFO_ARRAY
   (
      1,
      1003,
      3
   ),
   MDSYS.SDO_ORDINATE_ARRAY
   (
      806000,
      -240000,
      1575600,
      590000
   )
)


--new western addition rectangle
SDO_GEOMETRY
(
   2003,
   2263,
   NULL,
   MDSYS.SDO_ELEM_INFO_ARRAY
   (
      1,
      1003,
      3
   ),
   MDSYS.SDO_ORDINATE_ARRAY
   (
      503666,
      -240000,
      806000,
      590000
   )
)

create table landmassbak
as select * from landmassfringe_sdo_2263_3

update landmassfringe_sdo_2263_3

select * from landmassfringe_sdo_2263_3
where objectid = 915

select sdo_geom.sdo_union(a.shape, SDO_GEOMETRY
(
   2003,
   2263,
   NULL,
   MDSYS.SDO_ELEM_INFO_ARRAY
   (
      1,
      1003,
      3
   ),
   MDSYS.SDO_ORDINATE_ARRAY
   (
      503666,
      -240000,
      806000,
      590000
   )
), .0005) from landmassfringe_sdo_2263_3 a
where a.objectid = 915

update landmassfringe_sdo_2263_3 a 
set a.shape =  sdo_geom.sdo_union(a.shape, SDO_GEOMETRY
(
   2003,
   2263,
   NULL,
   MDSYS.SDO_ELEM_INFO_ARRAY
   (
      1,
      1003,
      3
   ),
   MDSYS.SDO_ORDINATE_ARRAY
   (
      503666,
      -240000,
      806000,
      590000
   )
), .0005)
where a.objectid = 915

select * from geodatashare_metadata
where object_name = 'LANDMASSFRINGE_SDO_2263_3'
and deleted = 'N'


update geodatashare_metadata a
set a.comments = a.comments || '|Expanded the extent further west 20160926'
where a.object_name = 'LANDMASSFRINGE_SDO_2263_3'
and a.deleted = 'N'


------

drop table landmassbak

create table landmassbak as
select * from landmasspand_sdo_2263_3


select * from landmasspand_sdo_2263_3

update landmasspand_sdo_2263_3 a 
set a.shape =  sdo_geom.sdo_union(a.shape, SDO_GEOMETRY
(
   2003,
   2263,
   NULL,
   MDSYS.SDO_ELEM_INFO_ARRAY
   (
      1,
      1003,
      3
   ),
   MDSYS.SDO_ORDINATE_ARRAY
   (
      503666,
      -240000,
      806000,
      590000
   )
), .0005)

update geodatashare_metadata a
set a.comments = a.comments || '|Expanded the extent further west 20160926'
where a.object_name = 'LANDMASSPAND_SDO_2263_3'
and a.deleted = 'N'

-----

select * from landmassriftd_sdo_2263_3

create table landmassbak as
select * from landmassriftd_sdo_2263_3


update landmassriftd_sdo_2263_3 a 
set a.shape =  sdo_geom.sdo_union(a.shape, SDO_GEOMETRY
(
   2003,
   2263,
   NULL,
   MDSYS.SDO_ELEM_INFO_ARRAY
   (
      1,
      1003,
      3
   ),
   MDSYS.SDO_ORDINATE_ARRAY
   (
      503666,
      -240000,
      806000,
      590000
   )
), .0005)
where a.objectid = 335;

update geodatashare_metadata a
set a.comments = a.comments || '|Expanded the extent further west 20160926'
where a.object_name = 'LANDMASSRIFTD_SDO_2263_3'
and a.deleted = 'N'

----

drop table landmassbak

create table landmassbak as
select * from landmassriftw_sdo_2263_3


update landmassriftw_sdo_2263_3 a 
set a.shape =  sdo_geom.sdo_union(a.shape, SDO_GEOMETRY
(
   2003,
   2263,
   NULL,
   MDSYS.SDO_ELEM_INFO_ARRAY
   (
      1,
      1003,
      3
   ),
   MDSYS.SDO_ORDINATE_ARRAY
   (
      503666,
      -240000,
      806000,
      590000
   )
), .0005)
where a.objectid = 1408;

update geodatashare_metadata a
set a.comments = a.comments || '|Expanded the extent further west 20160926'
where a.object_name = 'LANDMASSRIFTW_SDO_2263_3'
and a.deleted = 'N'


----

drop table landmassbak

select * from landmassbak

create table landmassbak as
select * from landmasspanw_sdo_2263_3

select * from landmasspanw_sdo_2263_3


FUNCTION SDO_ARRAY_TO_SDO (
      p_sdo_array   IN  GIS_UTILS.geomarray
   ) RETURN SDO_GEOMETRY
   AS
   
      FUNCTION GZ_SCRUB_POLY (
      p_incoming    IN SDO_GEOMETRY
   ) RETURN GIS_UTILS.geomarray
   AS
  
select * from landmasspanw_sdo_2263_3

select gis_utils.sdo_array_to_sdo(gis_utils.gz_scrub_poly(a.shape)) from  
landmasspanw_sdo_2263_3 a
where a.objectid = 1323

select gis_utils.gz_scrub_poly(a.shape) from  
landmasspanw_sdo_2263_3 a
where a.objectid = 1323

declare
   ingeom sdo_geometry;
   geomz gis_utils.geomarray;
   psql varchar2(4000);
   outgeom sdo_geometry;
begin
   psql := 'select a.shape from landmasspanw_sdo_2263_3 a where a.objectid = 1323';
   execute immediate psql into ingeom;
   geomz := gis_utils.gz_scrub_poly(ingeom);
   outgeom := gis_utils.sdo_array_to_sdo(geomz);
   psql := 'update landmasspanw_sdo_2263_3 a set a.shape = :p1 where a.objectid = 1323';
   execute immediate psql using outgeom;
   commit;
end;
   
select * from landmasspanw_sdo_2263_3

select sdo_geom.validate_geometry_with_context(a.shape,.0005) from
 landmasspanw_sdo_2263_3 a
 
 13351 [Element <759>] [Ring <1>][Edge <21>] [Element <763>] [Ring <1>][Edge <18>]
 
 
select sdo_util.getnumvertices(a.shape) from landmasspanw_sdo_2263_3 a

464932

select * from landmasspanw_sdo_2263_3

update landmasspanw_sdo_2263_3 a
set a.shape = sdo_util.rectify_geometry(SDO_UTIL.REMOVE_DUPLICATE_VERTICES(a.SHAPE,0.5),.0005)
where a.objectid = 1323;


select * from geodatashare_metadata
where object_name like 'LANDMASSPANW%'

update landmasspanw_sdo_2263_3 a 
set a.shape =  sdo_geom.sdo_union(a.shape, SDO_GEOMETRY
(
   2003,
   2263,
   NULL,
   MDSYS.SDO_ELEM_INFO_ARRAY
   (
      1,
      1003,
      3
   ),
   MDSYS.SDO_ORDINATE_ARRAY
   (
      503666,
      -240000,
      806000,
      590000
   )
), .0005)
where a.objectid = 1323;

---save reminder 
update geodatashare_metadata a
set a.comments = a.comments || '|Expanded the extent further west 20160926'
where a.object_name = 'LANDMASSPANW_SDO_2263_3'
and a.deleted = 'N'

select * from LANDMASSPANW_SDO_2263_3









