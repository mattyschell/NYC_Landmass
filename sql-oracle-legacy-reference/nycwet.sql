DECLARE
   unexplodedtab  varchar2(64) := 'LANDMASSBOROCLIP_SDO_2263_3'; 
   explodedtab    varchar2(64) := 'LANDMASSNYCWET_SDO_2263_1';
   psql           varchar2(4000);
   geom           SDO_GEOMETRY;
   exploded       SDO_GEOMETRY_ARRAY;
   curs_results   SYS_REFCURSOR;
   objectid       NUMBER;
   kount          PLS_INTEGER := 0;
BEGIN

   psql := 'select a.objectid, a.shape from ' || unexplodedtab || ' a';
   
   OPEN curs_results FOR psql; 
   LOOP
   
      FETCH curs_results INTO objectid, geom;
      EXIT WHEN curs_results%NOTFOUND;
      
      exploded := GIS_UTILS.EXPLODE_POLYGON(geom); 
      
      psql := 'insert into ' || explodedtab || ' '
           || '(objectid, id, shape) '
           || 'VALUES(:p1,:p2,:p3)';          
      
      FOR i IN 1 .. exploded.COUNT
      LOOP
      
         kount := kount + 1;
         
         EXECUTE IMMEDIATE psql USING kount,
                                      objectid,
                                      exploded(i);
         COMMIT;

      END LOOP;
      
   END LOOP;
   
   CLOSE curs_results;
   
END;