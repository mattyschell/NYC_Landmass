declare
   landmasstab    varchar2(64) := 'LANDMASSBOROUGH_SDO_2263_1';
   cliptab        varchar2(64) := 'LANDMASSBOROCLIP_SDO_2263_1';
   hydrotab       varchar2(64) := 'PLANIMETRICS_2014.HYDROGRAPHY_SDO_2263_1';
   tolerance      number := .0005;
   psql           varchar2(4000);
   unclipidz      gis_utils.numberarray;
   hydroidz       gis_utils.numberarray;
   workinggeom    sdo_geometry;
begin
   
   --bring as little geom as possible into pl/sql
   
   psql := 'delete from ' || cliptab;
   execute immediate psql;
   commit;
   
   psql := 'select objectid from ' || landmasstab;
   execute immediate psql bulk collect into unclipidz;
   
   FOR i in 1 .. unclipidz.COUNT
   LOOP

       --dbms_output.put_Line('working ' || landmasstab || ' objectid ' || unclipidz(i)); 
       
       psql := 'select shape '
            || 'from ' || landmasstab || ' a ' 
            || 'where a.objectid = :p1';
       execute immediate psql into workinggeom using unclipidz(i);               
       
       --consider ordering by hydro ordinatecount asc 
       psql := 'select a.objectid from ' || hydrotab || ' a '
            || 'WHERE '
            || 'sdo_relate(a.shape, :p1, :p2) = :p3 AND '
            || 'a.feature_code NOT IN (:p4,:p5)';
       execute immediate psql bulk collect into hydroidz USING workinggeom,
                                                               'mask=ANYINTERACT',
                                                               'TRUE',
                                                               2640,
                                                               2650;
                                                               
       for jj in 1 .. hydroidz.count
       loop
       
          --dbms_output.put_line('working hydro id ' || hydroidz(jj));
       
          psql := 'select sdo_geom.sdo_difference(:p1, a.shape, :p2) '
               || 'from ' || hydrotab || ' a '
               || 'where a.objectid = :p3';
          execute immediate psql into workinggeom using workinggeom,
                                                        tolerance,
                                                        hydroidz(jj);
                         
       end loop;
       
       psql := 'insert into ' || cliptab || ' '
            || '(objectid, shape) '
            || 'values(:p1,:p2)';
       execute immediate psql using unclipidz(i),
                                    workinggeom;
       commit;        
   
   END LOOP;
   
END;
/