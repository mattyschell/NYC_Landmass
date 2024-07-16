DECLARE
   --very fast, 1 minute or so
   countytab      varchar2(64) := 'LANDMASSCOUNTY_SDO_2263_1'; --original unprocessed tiger counties
   drytab         varchar2(64) := 'LANDMASSFRINGE_SDO_2263_1'; --clipped to water, removed interior, exploded
   addcounties    mdsys.string_array := mdsys.string_array('34021','34035',
                                                           '34027','34031','34037','36071',
                                                           '36105','36111','36027','36079',
                                                           '09005','09003','09013','09015');
   llxclip        NUMBER := 810000;
   llyclip        NUMBER := 3000;
   urxclip        NUMBER := 1584825;
   uryclip        NUMBER := 590000;
   tolerance      NUMBER := .0005;
   psql           varchar2(4000);
   geom           SDO_GEOMETRY;
   rectangle      SDO_GEOMETRY;
   curs_results   SYS_REFCURSOR;
   statefp        VARCHAR2(2);
   countyfp       VARCHAR2(3);
   recname        VARCHAR2(256);
   kount          PLS_INTEGER;
BEGIN

   rectangle := SDO_GEOMETRY(2003,2263,NULL,
                             SDO_ELEM_INFO_ARRAY(1,1003,3),
                             SDO_ORDINATE_ARRAY(llxclip,llyclip,urxclip,uryclip));
                             
   psql := 'select max(objectid) from ' || drytab;
   execute immediate psql into kount;

   psql := 'select '
        || 'LPAD(TO_CHAR(a.statefp),2,''0''),  '
        || 'LPAD(TO_CHAR(a.countyfp),3,''0''), '
        || 'a.name, '
        || 'gis_utils.GZ_INTERSECTION(a.shape,:p1,:p2) '
        || 'FROM ' || countytab || ' a '
        || 'WHERE LPAD(TO_CHAR(a.statefp),2,''0'') || LPAD(TO_CHAR(a.countyfp),3,''0'') '
        || 'IN (SELECT * FROM TABLE(:p3))';
   
   OPEN curs_results FOR psql USING rectangle, tolerance, addcounties; 
   LOOP
   
      FETCH curs_results INTO statefp, countyfp, recname, geom;
      EXIT WHEN curs_results%NOTFOUND;
      
      if geom is null
      then
         raise_application_error(-20001, 'Got a null intersection for ' || recname);
      end if;
      
      psql := 'insert into ' || drytab || ' '
           || '(objectid, statefp, countyfp, name, shape) '
           || 'VALUES(:p1,:p2,:p3,:p4,:p5)';          
      
      kount := kount + 1;
         
      EXECUTE IMMEDIATE psql USING kount,
                                   statefp,
                                   countyfp,
                                   recname,
                                   geom;
      COMMIT;
      
   END LOOP;
   
   CLOSE curs_results;
   
   --next: countyfinalunion.sql
   
END;