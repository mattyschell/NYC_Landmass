declare
   --approx 10 minutes
   countiestoprocess    varchar2(64) := 'LANDMASSFRINGE_SDO_2263_1';
   finalfringe          varchar2(64) := 'LANDMASSFRINGE_SDO_2263_2';
   tolerance            NUMBER := .0005;
   allobjectids         gis_utils.numberarray;
   seedobjectid         NUMBER;
   bucketobjectids      gis_utils.numberarray;
   processedids         mdsys.SDO_List_Type := mdsys.SDO_List_Type();
   psql                 varchar2(4000);
   bucketsql            varchar2(4000);
   workingblob          SDO_GEOMETRY;
   kount                pls_integer;
   finaldryexploded     SDO_GEOMETRY_ARRAY;
   finalkount           pls_integer := 0;
begin

   --get all objectids ordered by complexity
   psql := 'select a.objectid '
        || 'from ' || countiestoprocess || ' a '
        || 'order by sdo_util.getnumvertices(a.shape) asc ';
        
   execute immediate psql bulk collect into allobjectids;
   
   for i in 1 .. allobjectids.count
   loop
   
      --seed an objectid - not in already processed
      
      psql := 'select count(*) from TABLE(:p1) t '
           || 'where t.column_value = :p2 ';
      
      execute immediate psql into kount using processedids,
                                              allobjectids(i);
                                              
      IF kount = 1
      THEN
      
         dbms_output.put_line('skipping already processed ' || allobjectids(i));
         CONTINUE;
         
      ELSE
      
         dbms_output.put_line('outer loop working ' || allobjectids(i));
         seedobjectid := allobjectids(i);
         processedids.EXTEND(1);
         processedids(processedids.COUNT) := allobjectids(i);
         
         psql := 'select a.shape '
              || 'from ' ||  countiestoprocess || ' a '
              || 'where a.objectid = :p1 ';
         execute immediate psql into workingblob USING seedobjectid;              
         
      END IF;
      
      --get other objectids spatially related (may be zero) and not already processed
      
      bucketsql := 'select a.objectid '
                || 'from ' || countiestoprocess || ' a '
                || 'where '
                || 'sdo_relate(a.shape, :p1, :p2) = :p3 AND '
                || 'a.objectid NOT IN (SELECT * FROM TABLE(:p4)) '
                || 'order by sdo_util.getnumvertices(a.shape) asc ';
      
      EXECUTE IMMEDIATE bucketsql BULK COLLECT INTO bucketobjectids USING workingblob,
                                                                          'mask=ANYINTERACT',
                                                                          'TRUE',
                                                                          processedids;
                 
      dbms_output.put_line('initially added ' ||  bucketobjectids.COUNT || ' objectids to bucket ');
                                             
      WHILE bucketobjectids.COUNT > 0
      LOOP
      
         FOR jj IN 1 .. bucketobjectids.COUNT
         LOOP
         
            --union these one by one
            
            psql := 'SELECT sdo_geom.sdo_union(a.shape, :p1, :p2) '
                 || 'FROM ' || countiestoprocess || ' a '
                 || 'WHERE a.objectid = :p3 ';
            
            execute immediate psql into workingblob using workingblob, 
                                                          tolerance,
                                                          bucketobjectids(jj);
            
            processedids.EXTEND(1);
            processedids(processedids.COUNT) := bucketobjectids(jj);
            
         END LOOP;
            
         --dip back in for another bucket using expanded blob and excluding processed ids
         EXECUTE IMMEDIATE bucketsql BULK COLLECT INTO bucketobjectids USING workingblob,
                                                                             'mask=ANYINTERACT',
                                                                             'TRUE',
                                                                              processedids;
                                                           
         dbms_output.put_line('dipped ' ||  bucketobjectids.COUNT || ' more objectids into bucket ');
         
      END LOOP;
      
      dbms_output.put_line('exited spatial unioning portion of loop');
      
      --when complete remove holes and explode (holes exist for sure, explode to be safe, 
      --some of the input fringe fringe counties may be 2007s
      
      finaldryexploded := GIS_UTILS.EXPLODE_POLYGON(GIS_UTILS.REMOVE_INNER_RINGS(workingblob)); 
      
      dbms_output.put_line('got ' || finaldryexploded.COUNT || ' final dry exploded geoms');
      
      --insert this record(s)
      psql := 'insert into ' || finalfringe || ' '
           || '(objectid, shape) '
           || 'VALUES(:p1,:p2) ';
      
      for kk in 1 .. finaldryexploded.COUNT
      LOOP
      
         finalkount := finalkount + 1;
         
         execute immediate psql using finalkount,
                                      finaldryexploded(kk);
      
      END LOOP;
      
      commit;
      
   end loop;

end;