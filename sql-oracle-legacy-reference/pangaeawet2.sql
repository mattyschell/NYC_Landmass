declare
   --10-20 min
   allshapes       varchar2(64) := 'LANDMASSPANG_SDO_2263_2'; --nyc wet unioned with fringe dry
   outputtab       varchar2(64) := 'LANDMASSPANG_SDO_2263_3';
   tolerance       NUMBER := .0005;
   threshhold      NUMBER := .05;
   simplifycutoff  NUMBER := 100; --less than x vertices dont simplify
   psql            VARCHAR2(4000);
   geom            SDO_GEOMETRY;
   finalgeom       SDO_GEOMETRY := NULL;
   curs_results    SYS_REFCURSOR;
begin
   psql := 'select aa.shape from '
        || '(select a.shape from ' || allshapes || ' a '
        || 'where sdo_util.getnumvertices(a.shape) <= :p1 '
        || 'UNION ALL '
        || 'select '
        || 'sdo_util.simplify(b.shape, :p2, :p3) '
        || 'from ' || allshapes || ' b '
        || 'where sdo_util.getnumvertices(b.shape) > :p4) aa '
        || 'order by sdo_util.getnumvertices(aa.shape) ASC ';
   
   OPEN curs_results FOR psql USING simplifycutoff, threshhold, tolerance, simplifycutoff; 
   LOOP
   
      FETCH curs_results INTO geom;
      EXIT WHEN curs_results%NOTFOUND;
      
      finalgeom := sdo_util.append(finalgeom, 
                                   geom);      
      
   END LOOP;
   
   CLOSE curs_results;
   
   --may result in intersecting rings
   --call rectify first no matter what
   finalgeom := sdo_util.rectify_geometry(finalgeom,
                                          tolerance);
   
   psql := 'insert into ' || outputtab || ' (objectid, shape) '
        || 'VALUES(:p1,:p2)';
        
   --this could take a few
   IF sdo_geom.validate_geometry_with_context(finalgeom,
                                              tolerance) = 'TRUE'
   THEN
      
      execute immediate psql using 1, finalgeom;
      commit; 
      
   ELSE
   
     raise_application_error(-20001, 'Didnt get a valid output geom');   
   
   END IF;

end;