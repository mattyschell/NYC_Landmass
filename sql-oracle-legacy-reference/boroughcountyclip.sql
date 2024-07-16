INSERT INTO LANDMASSBOROCLIP_SDO_2263_2 (objectid, id, shape)
   SELECT a.objectid, a.id, SDO_GEOM.sdo_difference (a.shape, b.shape, .0005)
     FROM LANDMASSBOROCLIP_SDO_2263_1 a, 
          LANDMASSCOUNTY_SDO_2263_1 b
    WHERE     sdo_relate (a.shape, b.shape, 'mask=ANYINTERACT') = 'TRUE'
          AND b.geoid = '36119';

INSERT INTO LANDMASSBOROCLIP_SDO_2263_2 (objectid, id, shape)
   SELECT a.objectid, a.id, SDO_GEOM.sdo_difference (a.shape, b.shape, .0005)
     FROM LANDMASSBOROCLIP_SDO_2263_1 a, 
          LANDMASSCOUNTY_SDO_2263_1 b
    WHERE     sdo_relate (a.shape, b.shape, 'mask=ANYINTERACT') = 'TRUE'
          AND b.geoid = '36059';

INSERT INTO LANDMASSBOROCLIP_SDO_2263_2 (objectid, id, shape)
   SELECT a.objectid, a.id, a.shape
     FROM LANDMASSBOROCLIP_SDO_2263_1 a
    WHERE NOT EXISTS
             (SELECT b.objectid
                FROM LANDMASSBOROCLIP_SDO_2263_2 b
               WHERE b.objectid = a.objectid);

COMMIT;