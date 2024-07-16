declare

   --this bad boy ran for ~20 hours on first attempt
   --the final BK/QN repeated union with little hydro structures was the baddie

   landmasstab    varchar2(64) := 'LANDMASSBOROCLIP_SDO_2263_2';
   uniontab       varchar2(64) := 'LANDMASSBOROCLIP_SDO_2263_3';
   hydrotab       varchar2(64) := 'PLANIMETRICS_2014.HYDRO_STRUCTURE_SDO_2263_1';
   tolerance      number       := .0005;
   psql           varchar2(4000);
   unionpsql      varchar2(4000);
   inputidz       gis_utils.numberarray;
   unionidz       gis_utils.numberarray;
   workinggeom    sdo_geometry;
   
begin
   
   --bring as little geom as possible into pl/sql
   
   psql := 'delete from ' || uniontab;
   execute immediate psql;
   commit;
   
   psql := 'select objectid from ' || landmasstab;
   execute immediate psql bulk collect into inputidz;
   
   FOR i in 1 .. inputidz.COUNT
   LOOP

      --dbms_output.put_Line('working ' || landmasstab || ' objectid ' || inputidz(i)); 
       
      psql := 'select a.shape '
           || 'from ' || landmasstab || ' a ' 
           || 'where a.objectid = :p1';
      execute immediate psql into workinggeom using inputidz(i);               
       
      unionpsql := 'select a.objectid from ' || hydrotab || ' a '
                || 'WHERE '
                || 'sdo_relate(a.shape, :p1, :p2) = :p3';
      execute immediate unionpsql bulk collect into unionidz USING workinggeom,
                                                                   'mask=ANYINTERACT',
                                                                   'TRUE';
                                                               
      WHILE unionidz.COUNT > 0
      LOOP
                                                 
         FOR jj in 1 .. unionidz.COUNT
         LOOP
          
            --dbms_output.put_line('working hydro id ' || unionidz(jj));
          
            psql := 'select sdo_geom.sdo_union(:p1, a.shape, :p2) '
                 || 'from ' || hydrotab || ' a '
                 || 'where a.objectid = :p3';
            execute immediate psql into workinggeom using workinggeom,
                                                          tolerance,
                                                          unionidz(jj);
               
               
         end loop; --this bucket of hydros to union
       
         --get another bucket - this time expensive TOUCH to avoid repeats
         execute immediate unionpsql bulk collect into unionidz USING workinggeom,
                                                                      'mask=TOUCH',
                                                                      'TRUE';
          
      END LOOP; --over chained outward hydros that interact with this landmass    
      
      --dbms_output.put_line('insert into ' || uniontab || ' id ' || inputidz(i));
      
      psql := 'insert into ' || uniontab || ' '
           || '(objectid, shape) '
           || 'values(:p1,:p2)';
      execute immediate psql using inputidz(i),
                                   workinggeom;
      commit;   
   
   END LOOP; --over a landmass
   
END;
/