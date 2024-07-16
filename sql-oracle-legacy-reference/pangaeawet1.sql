declare
   --10 min
   explodedboroughs     varchar2(64) := 'LANDMASSNYCWET_SDO_2263_1';
   explodedfringe       varchar2(64) := 'LANDMASSFRINGE_SDO_2263_2';
   inputtable           varchar2(64) := 'LANDMASSPANG_SDO_2263_1';
   outputtable          varchar2(64) := 'LANDMASSPANG_SDO_2263_2';
   tolerance            NUMBER := .0005;
   maxid                NUMBER;
   allobjectids         gis_utils.numberarray;
   seedobjectid         NUMBER;
   bucketobjectids      gis_utils.numberarray;
   processedids         mdsys.SDO_List_Type := mdsys.SDO_List_Type();
   psql                 varchar2(4000);
   bucketsql            varchar2(4000);
   workingblob          SDO_GEOMETRY;
   kount                pls_integer;
   --finaldryexploded     SDO_GEOMETRY_ARRAY;
   finalkount           pls_integer := 0;
begin

   psql := 'select max(objectid + 1) from ' || explodedboroughs;
   execute immediate psql into maxid;
   
   psql := 'insert into ' || inputtable || ' (objectid, shape) '
        || 'select a.objectid, a.shape from ' || explodedboroughs || ' a';
   execute immediate psql;
   commit;
   
   psql := 'insert into ' || inputtable || ' (objectid, shape) '
        || 'select (rownum + :p1), a.shape from ' || explodedfringe || ' a';
   execute immediate psql using maxid;
   commit;   

   --get all objectids ordered by complexity
   psql := 'select a.objectid '
        || 'from ' || inputtable || ' a '
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
              || 'from ' ||  inputtable || ' a '
              || 'where a.objectid = :p1 ';
         execute immediate psql into workingblob USING seedobjectid;              
         
      END IF;
      
      --get other objectids spatially related (may be zero) and not already processed
      
      bucketsql := 'select a.objectid '
                || 'from ' || inputtable || ' a '
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
                 || 'FROM ' || inputtable || ' a '
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
      
      --huh?  NO.  Leave holes, hydro in NYC is the requirement
      --should not be holes on boundaries, they were clipped to same source
      --when complete remove holes and explode (holes exist for sure, explode to be safe, 
      --some of the input fringe fringe counties may be 2007s
      
      --finaldryexploded := GIS_UTILS.EXPLODE_POLYGON(GIS_UTILS.REMOVE_INNER_RINGS(workingblob)); 
      
      --dbms_output.put_line('got ' || finaldryexploded.COUNT || ' final dry exploded geoms');
      
      --insert this record(s)
      psql := 'insert into ' || outputtable || ' '
           || '(objectid, shape) '
           || 'VALUES(:p1,:p2) ';

      
      finalkount := finalkount + 1;
         
      execute immediate psql using finalkount,
                                   workingblob;

      
      commit;
      
   end loop;
   
   --next: pangaeawet2 to simplify and append the blobs into one geom

end;