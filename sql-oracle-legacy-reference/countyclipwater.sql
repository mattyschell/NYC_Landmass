declare
   landmasstab    varchar2(64) := 'LANDMASSCOUNTY_SDO_2263_1';
   cliptab        varchar2(64) := 'LANDMASSCOUCLIP_SDO_2263_1';
   hydrotab       varchar2(64) := 'LANDMASSWATER_SDO_2263_1';
   tolerance      number := .0005;
   psql           varchar2(4000);
   hydroidz       gis_utils.numberarray;
   statez         gis_utils.stringarray;
   countiez       gis_utils.stringarray;   
   workinggeom    sdo_geometry;
   workingid      number;
   workingname    varchar2(64);
begin
   
   --get universe of state county from water table
   --county land table may have other interior counties we will not touch
   
   psql := 'select distinct statefp, countyfp '
        || 'from ' || hydrotab;
   execute immediate psql bulk collect into statez, countiez;
   
   for kk in 1 .. statez.count
   loop

      --dbms_output.put_Line('working state ' || statez(kk) || ' county ' || countiez(kk)); 
       
      psql := 'select a.objectid, a.shape, a.name '
           || 'from ' || landmasstab || ' a ' 
           || 'where a.statefp = :p1 AND '
           || 'a.countyfp = :p2 ';
      execute immediate psql into workingid, 
                                  workinggeom,
                                  workingname using to_number(statez(kk)),
                                                    to_number(countiez(kk));   
                                                               
      --dbms_output.put_line('clipping ' || landmasstab || ' id ' || workingid);             
       
      psql := 'select a.objectid from ' || hydrotab || ' a '
           || 'WHERE '
           || 'a.statefp = :p1 AND '
           || 'a.countyfp = :p2 '
           || 'order by sdo_util.getnumvertices(a.shape) asc';
      execute immediate psql bulk collect into hydroidz USING statez(kk),
                                                              countiez(kk);
                                                               
       for jj in 1 .. hydroidz.count
       loop
       
          --dbms_output.put_line('working hydro id ' || hydroidz(jj));
       
          psql := 'select sdo_geom.sdo_difference(:p1, a.shape, :p2) '
               || 'from ' || hydrotab || ' a '
               || 'where a.objectid = :p3';
          execute immediate psql into workinggeom using workinggeom,
                                                        tolerance,
                                                        hydroidz(jj);
                         
       end loop; --overy hydro for this state,county
       
      psql := 'delete from ' || cliptab || ' a ' 
           || 'where a.statefp = :p1 and a.countyfp = :p2';
      execute immediate psql using statez(kk), countiez(kk);
      commit;
      
       psql := 'insert into ' || cliptab || ' '
            || '(objectid, statefp, countyfp, name, shape) '
            || 'values(:p1,:p2,:p3,:p4,:p5)';
       execute immediate psql using workingid,
                                    statez(kk),
                                    countiez(kk),
                                    workingname,
                                    workinggeom;
       commit;        
    
   end loop; --over state,county
   
END;
/