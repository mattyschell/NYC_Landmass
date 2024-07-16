DECLARE
   --very slow.  3+ hours
   --just an sql
   --abstract: self geom = other.removerings - how to deal with ids?
   wettab         varchar2(64) := 'LANDMASSPANG_SDO_2263_3'; --pangaea wet 
   drytab         varchar2(64) := 'LANDMASSPANGDRY_SDO_2263_1';
   psql           varchar2(4000);
BEGIN

   psql := 'INSERT INTO ' || drytab || ' '
        || '(objectid, id, shape) '
        || 'SELECT rownum, a.objectid, GIS_UTILS.REMOVE_INNER_RINGS(a.shape) '
        || 'FROM ' || wettab || ' a';          
         
   EXECUTE IMMEDIATE psql;
   COMMIT;
   
END;