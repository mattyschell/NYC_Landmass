declare
   psql varchar2(4000);
   ingeom sdo_geometry;
   outgeomz gis_utils.geomarray;
   outidz   gis_utils.numberarray;
begin
   psql := 'select a.shape from master.LANDMASSBOROCLIP_SDO_2263_1 a '
        || 'where a.objectid = 1';
  execute immediate psql into ingeom;

   outgeomz := GIS_UTILS.EXPLODE_FILL_POLY(ingeom);
   
   for i in 1 .. outgeomz.count
   loop
       outidz(i) := i;
   end loop;
   
   forall ii in 1 .. outgeomz.count
      execute immediate 'insert into LANDMASSBOROCLIP_SDO_2263_1 (objectid, shape) values(:p1,:p2)'
      using outidz(ii), outgeomz(ii);
      
   commit;
   
end;
