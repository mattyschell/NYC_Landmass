DECLARE
   --time
   --abstract: self.geom = other.explode
   unexplodedtab  varchar2(64) := 'LANDMASSPANG_SDO_2263_3';   --pangea wet
   outputtab      varchar2(64) := 'LANDMASSRIFWET_SDO_2263_1'; --rifted wet goal 
   psql           varchar2(4000);
   geom           SDO_GEOMETRY;
   dryexploded    SDO_GEOMETRY_ARRAY;
   curs_results   SYS_REFCURSOR;
   objectid       NUMBER;
   kount          PLS_INTEGER := 0;
BEGIN

   --should only be 1 rec - its pangaea
   psql := 'select a.objectid, a.shape from ' || unexplodedtab || ' a';
   
   OPEN curs_results FOR psql; 
   LOOP
   
      FETCH curs_results INTO objectid, geom;
      EXIT WHEN curs_results%NOTFOUND;
      
      dryexploded := GIS_UTILS.EXPLODE_POLYGON(geom); 
      
      psql := 'insert into ' || outputtab || ' '
           || '(objectid, id, shape) '
           || 'VALUES(:p1,:p2,:p3)';          
      
      FOR i IN 1 .. dryexploded.COUNT
      LOOP
      
         kount := kount + 1;
         
         EXECUTE IMMEDIATE psql USING kount,
                                      objectid,
                                      dryexploded(i);
         COMMIT;

      END LOOP;
      
   END LOOP;
   
   CLOSE curs_results;
   
END;