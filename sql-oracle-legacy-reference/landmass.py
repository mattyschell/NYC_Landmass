'''
Created on Jun 23, 2016

@author: mschell
'''

import sys
import src.database.dbutils
import src.geodatasharerepo.metadata
import src.geodatasharerepo.storagelayer
from time import strftime

##############################################################################
class landmassbase():
    
    ################
    def __init__(self):
        pass
    
    ###################
    def timestamper(self,
                    step,
                    task):
        
        print step + ": " + task + " at " + strftime("%Y-%m-%d %H:%M:%S")
    
    #################
    def removeholes(self,
                    thiseditlayer):
    
        print "   removing holes from " + thiseditlayer.getname() 
        
        thiseditlayer.removeholes()
        
    #################
    def dissolve(self,
                 thiseditlayer):
    
        print "   dissolving shared boundaries on " + thiseditlayer.getname() 
        
        thiseditlayer.dissolve()
        
    ###########################
    def addhydrostructure(self,
                          thiseditlayer,
                          hydrostructurelayer,
                          deletelayer = None):
        
        #remove structures on piers.  
        #its overlap in the inputs and results in overlap in output
        hydrostructurewhereclause = """a.sub_feature_code <> 280040""" 
        
        hydrostructurelayer.setwhereclause(hydrostructurewhereclause) 
        
        print "   unioning " + thiseditlayer.getname() + " with " + hydrostructurelayer.getname()
        thiseditlayer.unionwithlayer(hydrostructurelayer)
        
        #this is one step up from just manually editing
        #the hydro structure dataset includes junk in NJ and Nassau
        #should instead figure out how to remove these in advance
        #even if its a matter of applying a list of objectids to the 
        #   hydrostructurelayer whereclause
        #the area parameter is to avoid deleting ellis island
        
        if deletelayer is not None:
            
            #deletetable = landmasscounty_sdo_2263_1
            #these are unclipped counties from tiger
            
            #ran this by hand in initial run
            sql = """DELETE FROM """ +  thiseditlayer.getname() + """ a 
                     WHERE a.objectid IN ( 
                     SELECT a.objectid FROM """ + thiseditlayer.getname() + """ a,
                     """ + deletelayer.getname() + """ b
                     WHERE SDO_RELATE(a.shape, b.shape, 'mask=INSIDE+COVEREDBY') = 'TRUE'
                     AND b.geoid IN ('34023','34039','34017', '34003', '36059')
                     and sdo_geom.sdo_area(a.shape, .0005) < 100000);"""
            
            print "   executing dumb ad-hoc SQL to delete hydro structures outside NYC"
            print sql
            thiseditlayer.geomhandle.dbhandle.executecommand(sql)
            
    ###########################
    def explode(self,
                 thiseditlayer):
        
        print "   exploding " +  thiseditlayer.getname()
        
        thiseditlayer.explode()
        
    ####################
    def cliphydro(self,
                  thiseditlayer,
                  hydrolayer,
                  thiseditwhereclause = None,
                  hydrowhereclause = None):
        
        if thiseditwhereclause is not None:
            print "   applying whereclause " + thiseditwhereclause + " to " + thiseditlayer.getname()
            thiseditlayer.setwhereclause(thiseditwhereclause)
            
        if hydrowhereclause is not None:
            print "   applying whereclause " + hydrowhereclause + " to " + hydrolayer.getname()
            hydrolayer.setwhereclause(hydrowhereclause)
        
        print "   clipping " + thiseditlayer.getname() + " with " + hydrolayer.getname()
        thiseditlayer.clipbylayer(hydrolayer)
        
    ####################
    def clipextent(self,
                   thiseditlayer,
                   extentlayer,
                   thiseditwhereclause = None,
                   extentwhereclause = None):
        
        if thiseditwhereclause is not None:
            print "   applying whereclause " + thiseditwhereclause + " to " + thiseditlayer.getname()
            thiseditlayer.setwhereclause(thiseditwhereclause)
            
        if extentwhereclause is not None:
            print "   applying whereclause " + extentwhereclause + " to " + extentlayer.getname()
            extentlayer.setwhereclause(extentwhereclause)
        
        
        print "   clipping (intersecting) " + thiseditlayer.getname() + " with " + extentlayer.getname()

        thiseditlayer.clipbylayer(extentlayer,
                                  'INTERSECTION')
            
    ###########################
    def unionlayers(self,
                    thiseditlayer,
                    unionlayer,
                    thiseditwhereclause = None,
                    unionwhereclause = None,
                    uniondisjoint='Y'):
        
        #addhydrostructure (both versions) is just a klugey implementation of
        #this generic version. Should be refactored
        
        if thiseditwhereclause is not None:
            thiseditlayer.setwhereclause(thiseditwhereclause)
            
        if unionwhereclause is not None:
            unionlayer.setwhereclause(unionwhereclause)
            
        thiseditlayer.unionwithlayer(unionlayer,
                                     uniondisjoint)    
    
    ############################   
    def simplifylayer(self,
                      thiseditlayer,
                      thiseditwhereclause=None,
                      threshhold=.5):  
        
        if thiseditwhereclause is not None:
            thiseditlayer.setwhereclause(thiseditwhereclause)
            
        #tiny distance still removes a lot from trashy hydro data    
        thiseditlayer.simplify(threshhold) 
        
    ############################   
    def rectifylayer(self,
                     thiseditlayer,
                     thiseditwhereclause=None):  
        
        if thiseditwhereclause is not None:
            thiseditlayer.setwhereclause(thiseditwhereclause)
            
        #tiny distance still removes a lot from trashy hydro data    
        thiseditlayer.rectify()     
        
    ############################   
    def rolluplayer(self,
                    thiseditlayer,
                    overlaps = 'N',
                    thiseditwhereclause=None):  
        
        if thiseditwhereclause is not None:
            thiseditlayer.setwhereclause(thiseditwhereclause)
            
        #tiny distance still removes a lot from trashy hydro data    
        thiseditlayer.aggregate(overlaps)            
        
    ###########################
    def finalize(self,
                 thiseditlayer,
                 metadatarepo):
        
        thiseditlayer.writemetadata(metadatarepo,
                                    'N')
        
        thiseditlayer.validate()   
        

###############################################################################
class nycdry(landmassbase):
    
    #the object for building NYC landmass without interior
    #Copy landmassnycnos_sdo_2263_x to landmassnycdry_sdo_2263_x
    #Remove holes
    #spatially union hydro structure
    #pass through non-spatially related hydro structure
    #but delete annoying hydro structures in NJ and Nassau
    #explode all polys
    #final: landmassnycdry_sdo_2263_x
    
    
    ###################
    def __init__(self,
                 srcconnection,
                 metadatamanager,
                 countytable,
                 hydrostructuretable,
                 versionno,
                 restartstep):
        
        self.dbgeommanager = srcconnection
        self.metadatarepo  = metadatamanager
        self.versiontag = versionno
        
        self.nostructurestoragelayer = src.geodatasharerepo.storagelayer.StorageEditLayer(
                                                     srcconnection,
                                                     'LANDMASSNYCNOS_SDO_2263_' + self.versiontag, #determined in code module 1
                                                     'Landmassborough_SDO',  
                                                     'LANDMASS', 
                                                     2263,
                                                     .0005)
        
        self.countylayer = src.geodatasharerepo.storagelayer.StorageEditLayer(
                                                     srcconnection,
                                                     countytable,
                                                     'Landmasscounty_SDO',  
                                                     'LANDMASS', 
                                                     2263,
                                                     .0005)
        
        self.hydrostructurelayer = src.geodatasharerepo.storagelayer.StorageEditLayer(
                                                     srcconnection,
                                                     hydrostructuretable,
                                                     'Hydro_Structure_SDO',  
                                                     'HYDROSTRUCTURE', 
                                                     2263,
                                                     .0005)
        
        if restartstep != 'nycdry':  
        
            #copy to new table to chisel away at
            print "   copy " +  self.nostructurestoragelayer.getname() + " to LANDMASSNYCDRY_SDO_2263_" + self.versiontag
            self.nycdrylayer = self.nostructurestoragelayer.duplicate('LANDMASSNYCDRY_SDO_2263_' + self.versiontag, 
                                                                      self.metadatarepo)
            
        else:
            
            print '   restarting with existing layer ' + 'LANDMASSNYCDRY_SDO_2263_' + self.versiontag
            self.nycdrylayer = src.geodatasharerepo.storagelayer.StorageEditLayer(
                                                     srcconnection,
                                                     'LANDMASSNYCDRY_SDO_2263_' + self.versiontag,
                                                     'Landmassborough_SDO',  
                                                     'LANDMASS', 
                                                     2263,
                                                     .0005)
        
     
###############################################################################
class fringe(landmassbase):
    
    #the object for building NYC landmass fringe without interior hydro
    #Copy tiger county table to landmassfringe_sdo_2263_x
    #apply whereclause filter for selected coastal counties
    #clip tiger areawater polys away from selected counties
    #Remove interior rings from selected counties
    #explode multipolygons from selected counties
    #remove whereclause
    #clip all shapes by rectangle
    #dissolve all shapes
    #remove interior rings
    #explode    
    
    ###################
    def __init__(self,
                 srcconnection,
                 metadatamanager,
                 countytable,
                 hydrotable,
                 extenttable,
                 versionno,
                 restartstep):
        
        self.dbgeommanager = srcconnection
        self.metadatarepo  = metadatamanager
        self.versiontag = versionno
        
        self.countylayer = src.geodatasharerepo.storagelayer.StorageEditLayer(
                                                     srcconnection,
                                                     countytable,
                                                     'Landmasscounty_SDO',  
                                                     'LANDMASS', 
                                                     2263,
                                                     .0005)
        
        self.hydrolayer = src.geodatasharerepo.storagelayer.StorageEditLayer(
                                                     srcconnection,
                                                     hydrotable,
                                                     'Landmasswater_SDO',  
                                                     'LANDMASS', 
                                                     2263,
                                                     .0005)
        
        self.extentlayer = src.geodatasharerepo.storagelayer.StorageEditLayer(
                                                     srcconnection,
                                                     extenttable,
                                                     'Landmassborough_SDO',  
                                                     'LANDMASS', 
                                                     2263,
                                                     .0005)
        
        
        #copy to new table to chisel away at
        print "   copy " +  self.countylayer.getname() + " to LANDMASSFRINGE_SDO_2263_" + self.versiontag
        
        self.fringelayer = self.countylayer.duplicate('LANDMASSFRINGE_SDO_2263_' + self.versiontag, 
                                                      self.metadatarepo)   

###############################################################################
class nycwet(landmassbase):
    
    #wrote this one before the base class
    #needs to be refactored

    
    #the object for building NYC landmass with interior hydro
    #Copy fatboro block to chisel away at into landmassnycnos_sdo_2263_x
    #clip planimetrics hydro
    #clip westchester county
    #clip nassau
    #copy landmassnycnos_sdo_2263_x (set aside for later) to landmassnycwet_sdo_2263_x
    #spatially union hydro structure
    #pass through non-spatially related hydro structure
    #explode all polys
    #final: landmassnycwet_sdo_2263_x    
    
    ###################
    def __init__(self,
                 srcconnection,
                 metadatamanager,
                 borotable,
                 hydrotable,
                 countytable,
                 hydrostructuretable,
                 versionno,
                 restartstep):
        
        self.dbgeommanager = srcconnection
        self.metadatarepo  = metadatamanager
        self.versiontag = versionno
        
        self.fatborostoragelayer = src.geodatasharerepo.storagelayer.StorageEditLayer(
                                                     srcconnection,
                                                     borotable,
                                                     'Landmassborough_SDO',  
                                                     'LANDMASS', 
                                                     2263,
                                                     .0005)
        
        self.hydrolayer = src.geodatasharerepo.storagelayer.StorageEditLayer(
                                                     srcconnection,
                                                     hydrotable,
                                                     'Landmasswater_SDO',  
                                                     'LANDMASS', 
                                                     2263,
                                                     .0005)
        
        self.countylayer = src.geodatasharerepo.storagelayer.StorageEditLayer(
                                                     srcconnection,
                                                     countytable,
                                                     'Landmasscounty_SDO',  
                                                     'LANDMASS', 
                                                     2263,
                                                     .0005)
        
        self.hydrostructurelayer = src.geodatasharerepo.storagelayer.StorageEditLayer(
                                                     srcconnection,
                                                     hydrostructuretable,
                                                     'Hydro_Structure_SDO',  
                                                     'HYDROSTRUCTURE', 
                                                     2263,
                                                     .0005)
        
        #copy to new table to chisel away at
        print "   copy " +  self.fatborostoragelayer.getname() + " to LANDMASSNYCNOS_SDO_2263_" + self.versiontag
        self.nycwetnostructure = self.fatborostoragelayer.duplicate('LANDMASSNYCNOS_SDO_2263_' + self.versiontag, 
                                                                    self.metadatarepo)
        
    ####################
    def cliphydro(self):
        
        #everything but marsh and beach
        hydrowhereclause = 'a.feature_code IN (2600,2610,2620,2630,2660)'

        self.hydrolayer.setwhereclause(hydrowhereclause)
        
        print "   clipping " + self.nycwetnostructure.getname() + " with " + self.hydrolayer.getname()
        self.nycwetnostructure.clipbylayer(self.hydrolayer)
       
    ######################    
    def clipcounty(self):
        
        #nassau and westchester
        countywhereclause = """a.geoid IN ('36059','36119')"""
        
        self.countylayer.setwhereclause(countywhereclause)
        
        print "   clipping " + self.nycwetnostructure.getname() + " with " + self.countylayer.getname()
        self.nycwetnostructure.clipbylayer(self.countylayer)
        
        #this produces the nycwet without hydro structure dataset
        
    #########################
    def copytofinal(self):
        
        #leave the nycwetnohydrostructure table behind
        #copy to final output dataset
        
        print "   copying " + self.nycwetnostructure.getname() + " to LANDMASSNYCWET_SDO_2263_" + self.versiontag
        
        self.nycwet = self.nycwetnostructure.duplicate('LANDMASSNYCWET_SDO_2263_' + self.versiontag, 
                                                        self.metadatarepo)
        
    ###########################
    def addhydrostructure(self,
                          deletetable = None):
        
        
        #remove structures on piers.  
        #its overlap in the inputs and results in overlap in output
        hydrostructurewhereclause = """a.sub_feature_code <> 280040""" 
        
        self.hydrostructurelayer.setwhereclause(hydrostructurewhereclause) 
        
        print "   unioning " + self.nycwet.getname() + " with " + self.hydrostructurelayer.getname()
        self.nycwet.unionwithlayer(self.hydrostructurelayer)
        
        #this is one step up from just manually editing
        #the hydro structure dataset includes junk in NJ and Nassau
        #should instead figure out how to remove these in advance
        #even if its a matter of applying a list of objectids to the 
        #   hydrostructurelayer whereclause
        #the area parameter is to avoid deleting ellis island
        
        if deletetable is not None:
            
            #deletetable = landmasscounty_sdo_2263_1
            #these are unclipped counties from tiger
            
            #ran this by hand in initial run
            sql = """DELETE FROM """ +  self.nycwet.getname() + """ a 
                     WHERE a.objectid IN ( 
                     SELECT a.objectid FROM """ + self.nycwet.getname() + """ a,
                     """ + deletetable + """ b
                     WHERE SDO_RELATE(a.shape, b.shape, 'mask=INSIDE+COVEREDBY') = 'TRUE'
                     AND b.geoid IN ('34023','34039','34017', '34003', '36059')
                     and sdo_geom.sdo_area(a.shape, .0005) < 100000)"""
            
            print "   executing ad-hoc SQL to delete hydro structures outside NYC"
            print sql
            self.nycwetnostructure.geomhandle.dbhandle.executecommand(sql)
        
    ###########################
    def finalize(self):
        
        print "   exploding " +  self.nycwet.getname()
        
        self.nycwet.explode()
        
        print "   updating metadata for " + +  self.nycwet.getname()
        
        self.nycwet.writemetadata(self.metadatarepo,
                                  'N')
        
        print "   validating " + self.nycwet.getname()
        
        self.nycwet.validate()
        
###############################################################################
class pangaeawet(landmassbase):

    
    #object for building full extent, single record, with NYC hydro holes
    #used to make hydro shading
    #Copy nycwet to new pangaea wet starter shapes
    #union working layer (nycwet copy) with fringe shapes
    #   spatially union interacting records
    #   pass through disjoint records
    #   dissolve any new interior boundaries
    #Simplify shapes just a little
    #Roll up all shapes into a single record
    #Rectify (post-simplified disjoint shapes may overlap a little)   
    
    ###################
    def __init__(self,
                 srcconnection,
                 metadatamanager,
                 versionno,
                 restartstep):
        
        self.dbgeommanager = srcconnection
        self.metadatarepo  = metadatamanager
        self.versiontag = versionno
        
        self.nycwetlayer = src.geodatasharerepo.storagelayer.StorageEditLayer(
                                                self.dbgeommanager,
                                                'LANDMASSNYCWET_SDO_2263_' + self.versiontag,
                                                'Landmassborough_SDO',  
                                                'LANDMASS', 
                                                2263,
                                                .0005)
        
        self.fringelayer = src.geodatasharerepo.storagelayer.StorageEditLayer(
                                                self.dbgeommanager,
                                                'LANDMASSFRINGE_SDO_2263_' + self.versiontag,
                                                'Landmasscounty_SDO',  
                                                'LANDMASS', 
                                                2263,
                                                .0005)

        #copy to new table to start building out from
        print "   copy " +  self.nycwetlayer.getname() + " to LANDMASSPANW_SDO_2263_" + self.versiontag
        self.pangaeawetlayer = self.nycwetlayer.duplicate('LANDMASSPANW_SDO_2263_' + self.versiontag, 
                                                          self.metadatarepo)
        
###############################################################################
class pangaeadry(landmassbase):

    
    #object for building full extent, single record, withOUT NYC hydro holes
    #used to make hydro shading I think
    #Copy nycdry to new pangaea dry starter shapes
    #union working layer (nycdry copy) with fringe shapes
    #   spatially union interacting records
    #   pass through disjoint records
    #   dissolve any new interior boundaries
    #Roll up all shapes into a single record
    #Rectify (post-simplified disjoint shapes may overlap a little)   
    
    ###################
    def __init__(self,
                 srcconnection,
                 metadatamanager,
                 versionno,
                 restartstep):
        
        self.dbgeommanager = srcconnection
        self.metadatarepo  = metadatamanager
        self.versiontag = versionno
        
        self.nycdrylayer = src.geodatasharerepo.storagelayer.StorageEditLayer(
                                                self.dbgeommanager,
                                                'LANDMASSNYCDRY_SDO_2263_' + self.versiontag,
                                                'Landmassborough_SDO',  
                                                'LANDMASS', 
                                                2263,
                                                .0005)
        
        self.fringelayer = src.geodatasharerepo.storagelayer.StorageEditLayer(
                                                self.dbgeommanager,
                                                'LANDMASSFRINGE_SDO_2263_' + self.versiontag,
                                                'Landmasscounty_SDO',  
                                                'LANDMASS', 
                                                2263,
                                                .0005)

        #copy to new table to start building from
        print "   copy " +  self.nycdrylayer.getname() + " to LANDMASSPAND_SDO_2263_" + self.versiontag
        self.pangaeadrylayer = self.nycdrylayer.duplicate('LANDMASSPAND_SDO_2263_' + self.versiontag, 
                                                          self.metadatarepo)
        
###############################################################################
class rifted(landmassbase):

    
    #object for building full extent, exploded record, with or without NYC hydro 
    #Copy pangaeawet/dry to new rifted wet/dry working layer
    #Explode 
    #finalize

    ###################
    def __init__(self,
                 srcconnection,
                 metadatamanager,
                 versionno,
                 restartstep,
                 wetordry):  #W or D
        
        self.dbgeommanager = srcconnection
        self.metadatarepo  = metadatamanager
        self.versiontag = versionno
        
        #diff between rifted wet and rifted dry is just one letter naming convention
        #(W/D) in this input and in output name
        self.pangaealayer = src.geodatasharerepo.storagelayer.StorageEditLayer(
                                                  self.dbgeommanager,
                                                  'LANDMASSPAN' + wetordry + '_SDO_2263_' + self.versiontag,
                                                  'Landmassborough_SDO',  
                                                  'LANDMASS', 
                                                  2263,
                                                  .0005)

        #copy to new table to start working on
        print "   copy " +  self.pangaealayer.getname() + " to LANDMASSRIFT" + wetordry + "_SDO_2263_" + self.versiontag
        self.riftedlayer = self.pangaealayer.duplicate('LANDMASSRIFT' + wetordry + '_SDO_2263_' + self.versiontag, 
                                                       self.metadatarepo)

####################################################
if __name__ == "__main__":
    
    #python landmass.py 
    #MASTER 
    #GISCMNT   
    #
    #
    #> D:\matt_projects_data\mschell_data\datarefresh\geoserver\workforce_20160304geocdev.log
    
    try:
        schema           = sys.argv[1]  
        db               = sys.argv[2]  
        versionno        = str(sys.argv[3])
        step             = sys.argv[4]
        borotable        = sys.argv[5]
        nychydrotable    = sys.argv[6]
        fringehydrotable = sys.argv[7]
        countytable      = sys.argv[8]
        hydrostrtable    = sys.argv[9]
        extenttable      = sys.argv[10]
        restartstep      = sys.argv[11]
    except:
        raise ValueError('Expected 11 inputs')
        #schema           = MASTER
        #db               = GISCMNT
        #versionno        = 3
        #step             = nycwet
        #borotable        = LANDMASSFATBORO_SDO_2263_1
        #nychydrotable    = PLANIMETRICS_2014.HYDROGRAPHY_SDO_2263_1
        #fringehydrotable = LANDMASSWATER_SDO_2263_1
        #countytable      = LANDMASSCOUNTY_SDO_2263_2
        #hydrostrtable    = PLANIMETRICS_2014.HYDRO_STRUCTURE_SDO_2263_1
        #extenttable      = LANDMASSEXT_SDO_2263_1
        #restartstep      = nope

    print "starting step " + step + " at " + strftime("%Y-%m-%d %H:%M:%S")
    
    print "opening database connection for " + schema + " on " + db
    dbmanager = src.database.dbutils.OracleGeomManager(src.database.dbutils.oracle(schema,
                                                                                   db))
    
    metadatarepo = src.geodatasharerepo.metadata.Metadata(dbmanager)
    
    #compile packages, just in case
    #though bad idea when running more than one
    #yup, this should be in a build script, not here
    #dbmanager.initializeschema()

    if step == 'nycwet':
        
        #approx 24 hours for step. This is the long one
        
        nycwetloader = nycwet(dbmanager,
                              metadatarepo,
                              borotable,
                              nychydrotable,
                              countytable,
                              hydrostrtable,
                              versionno,
                              restartstep)

        nycwetloader.timestamper(step, 'clipping hydro')        
        nycwetloader.cliphydro()
        
        nycwetloader.timestamper(step, 'clipping counties')        
        nycwetloader.clipcounty()
        
        nycwetloader.timestamper(step, 'setting aside no structures dataset')        
        nycwetloader.copytofinal()
        
        nycwetloader.timestamper(step, 'adding hydro structures')        
        nycwetloader.addhydrostructure(countytable)
        
        nycwetloader.timestamper(step, 'exploding and validating')        
        nycwetloader.finalize()
        
        nycwetloader.timestamper(step, 'complete')
        
    ######################
    if step == 'nycdry': 
        
        #approx 12 hours for step
        
        nycdryloader = nycdry(dbmanager,
                              metadatarepo,
                              countytable,
                              hydrostrtable,
                              versionno,
                              restartstep)
        
        nycdryloader.timestamper(step, 'removing holes')        
        nycdryloader.removeholes(nycdryloader.nycdrylayer)
                
        nycdryloader.timestamper(step, 'adding hydro structures')        
        nycdryloader.addhydrostructure(nycdryloader.nycdrylayer, 
                                       nycdryloader.hydrostructurelayer, 
                                       nycdryloader.countylayer)
        
        nycdryloader.timestamper(step, 'exploding polygons')        
        nycdryloader.explode(nycdryloader.nycdrylayer)
        
        nycdryloader.timestamper(step, 'finalizing')        
        nycdryloader.finalize(nycdryloader.nycdrylayer,
                              nycdryloader.metadatarepo)
       
        nycdryloader.timestamper(step, 'complete')
        
        print step + ": complete at " + strftime("%Y-%m-%d %H:%M:%S")
        
    ##########################    
    if step == 'fringe':
        
        #approx 3 hours for step
        
        fringeloader = fringe(dbmanager,
                              metadatarepo,
                              countytable,
                              fringehydrotable, #this is a different hydro table. Tiger arewater, selected counties
                              extenttable,
                              versionno,
                              restartstep)
        
        coastalcounties =  """('09001','09007','09009','09011','34003','34013','34017','34023',""" \
                           + """'34025','34029','34039','36059','36087','36103','36119')""" 
        
        fringeloader.timestamper(step, 'clipping hydro')        
        fringeloader.cliphydro(fringeloader.fringelayer, 
                               fringeloader.hydrolayer, 
                               """a.geoid IN """ + coastalcounties,
                               None)
        
        fringeloader.timestamper(step, 'removing holes')        
        fringeloader.removeholes(fringeloader.fringelayer)
        
        fringeloader.timestamper(step, 'exploding polygons')        
        fringeloader.explode(fringeloader.fringelayer)
        
        fringeloader.timestamper(step, 'clipping to extent window')        
        fringeloader.clipextent(fringeloader.fringelayer, 
                                fringeloader.extentlayer,  #just one rec 
                                """1=1""", #unset clause, clip all counties to rectangle
                                None) #just a rectangle record, no clause
        
        fringeloader.timestamper(step, 'dissolving shapes')        
        fringeloader.dissolve(fringeloader.fringelayer)        
        
        fringeloader.timestamper(step, 'removing new holes')        
        fringeloader.removeholes(fringeloader.fringelayer)
        
        fringeloader.timestamper(step, 'exploding polygons')        
        fringeloader.explode(fringeloader.fringelayer)
        
        fringeloader.timestamper(step, 'finalizing')        
        fringeloader.finalize(fringeloader.fringelayer, 
                              metadatarepo)
        
        fringeloader.timestamper(step, 'complete')
    
    ##########################    
    if step == 'pangaeawet':
        
        #approx 45 min for step
        
        #pangaea needs not input names, all inputs are generated in prev steps
        pangaeawetloader = pangaeawet(dbmanager,
                                      metadatarepo,
                                      versionno,
                                      restartstep)
        
        pangaeawetloader.timestamper(step, 'union nycwet shapes and fringe')
        pangaeawetloader.unionlayers(pangaeawetloader.pangaeawetlayer, 
                                     pangaeawetloader.fringelayer)
        
        pangaeawetloader.timestamper(step, 'dissolve any new boundaries')
        pangaeawetloader.dissolve(pangaeawetloader.pangaeawetlayer)
        
        pangaeawetloader.timestamper(step, 'simplify shapes just a little')
        pangaeawetloader.simplifylayer(pangaeawetloader.pangaeawetlayer)
        
        #a few shapes may now overlap.  Dissolve them
        pangaeawetloader.timestamper(step, 'dissolve again - overlaps after simplification')
        pangaeawetloader.dissolve(pangaeawetloader.pangaeawetlayer)
        
        #because of oracle bugs, which are kinda understandable given
        #the shapes involved, there may be a few small overlaps even after dissolve
        #the same math apparently runs in rectify and doesnt see the overlaps
        #ESRI sees it though
        #so use the sdo_aggr_union version of rollup
        pangaeawetloader.timestamper(step, 'combine all shapes into one record')
        pangaeawetloader.rolluplayer(pangaeawetloader.pangaeawetlayer,
                                     'Y') 
        
        #no need to rectify, output of rollwup should be approved
        #will still check in finalize
        
        ######################################################
        #NEED TO ADD A STEP HERE in the future
        #final version was problematic for both ESRI and Geoserver
        #run SDO_UTIL.REMOVE_DUPLICATE_VERTICES(a.SHAPE,0.5)
        #(note NOT .0005)
        
        pangaeawetloader.timestamper(step, 'finalizing')        
        pangaeawetloader.finalize(pangaeawetloader.pangaeawetlayer, 
                                  metadatarepo)
        
        pangaeawetloader.timestamper(step, 'complete')   
        
    ##########################    
    if step == 'pangaeadry':
        
        #approx 30 min for step
        
        #pangaea needs not input names, all inputs are generated in prev steps
        pangaeadryloader = pangaeadry(dbmanager,
                                      metadatarepo,
                                      versionno,
                                      restartstep)
        
        pangaeadryloader.timestamper(step, 'union nycdry shapes and fringe')
        pangaeadryloader.unionlayers(pangaeadryloader.pangaeadrylayer, 
                                     pangaeadryloader.fringelayer)
        
        pangaeadryloader.timestamper(step, 'dissolve any new boundaries')
        pangaeadryloader.dissolve(pangaeadryloader.pangaeadrylayer)
        
        #a little simplification may be necessary if the inputs change a bit
        #currently 1007518 squeezes just under the bar
        #pangaeadryloader.simplifylayer(pangaeadryloader.pangaeadrylayer,None,.05)
        
        pangaeadryloader.timestamper(step, 'combine all shapes into one record')
        pangaeadryloader.rolluplayer(pangaeadryloader.pangaeadrylayer)
        
        pangaeadryloader.timestamper(step, 'rectify geometry of final record')
        pangaeadryloader.rectifylayer(pangaeadryloader.pangaeadrylayer)
        
        pangaeadryloader.timestamper(step, 'finalizing')        
        pangaeadryloader.finalize(pangaeadryloader.pangaeadrylayer, 
                                  metadatarepo)
        
        pangaeadryloader.timestamper(step, 'complete')   
        
    ##############################################    
    if step == 'riftedwet' or step == 'rifteddry':
        
        #just a few minutes.  Maybe 5
        
        if step == 'riftedwet':
            wetordryflag = 'W'
        else:
            wetordryflag = 'D'
            
        #rifted needs not input names, all inputs are generated in prev steps
        #difference between wet and dry is just one letter in input and output
        riftedloader= rifted(dbmanager,
                             metadatarepo,
                             versionno,
                             restartstep,
                             wetordryflag)
        
        riftedloader.timestamper(step, 'exploding polygon')
        riftedloader.explode(riftedloader.riftedlayer)
        
        riftedloader.timestamper(step, 'finalizing')
        riftedloader.finalize(riftedloader.riftedlayer,
                              riftedloader.metadatarepo)
        
        riftedloader.timestamper(step, 'complete')
        