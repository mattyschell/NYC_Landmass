DECLARE
   --10s of minutes I think
   unexplodedtab  varchar2(64) := 'LANDMASSCOUCLIP_SDO_2263_1'; 
   drytab         varchar2(64) := 'LANDMASSFRINGE_SDO_2263_1';
   psql           varchar2(4000);
   geom           SDO_GEOMETRY;
   dryexploded    SDO_GEOMETRY_ARRAY;
   curs_results   SYS_REFCURSOR;
   objectid       NUMBER;
   statefp        VARCHAR2(2);
   countyfp       VARCHAR2(3);
   recname        VARCHAR2(256);
   kount          PLS_INTEGER := 0;
BEGIN

   psql := 'select LPAD(TO_CHAR(a.statefp),2,''0''), LPAD(TO_CHAR(a.countyfp),3,''0''), '
        || 'a.name, a.shape '
        || 'FROM ' || unexplodedtab || ' a ';
   
   OPEN curs_results FOR psql; 
   LOOP
   
      FETCH curs_results INTO statefp, countyfp, recname, geom;
      EXIT WHEN curs_results%NOTFOUND;
      
      dryexploded := GIS_UTILS.EXPLODE_POLYGON(GIS_UTILS.REMOVE_INNER_RINGS(geom)); 
      
      psql := 'insert into ' || drytab || ' '
           || '(objectid, statefp, countyfp, name, shape) '
           || 'VALUES(:p1,:p2,:p3,:p4,:p5)';          
      
      FOR i IN 1 .. dryexploded.COUNT
      LOOP
      
         kount := kount + 1;
         
         EXECUTE IMMEDIATE psql USING kount,
                                      statefp,
                                      countyfp,
                                      recname,
                                      dryexploded(i);
         COMMIT;

      END LOOP;
      
   END LOOP;
   
   CLOSE curs_results;
   
   --next: countyaddclippedrectangle.sql
   
END;