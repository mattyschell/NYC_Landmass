select
    case
        when not 
            count(st_isvalid(geom)) = 0 then 'roughborough: all valid'
        else 
            'roughborough: some invalid'
    end as roughborough
from roughborough;
select
    case
        when not 
            count(st_isvalid(geom)) = 0 then 'landmassfringe: all valid'
        else 
            'landmassfringe: some invalid'
    end as landmassfringe
from landmassfringe;
select
    case
        when not 
            count(st_isvalid(geom)) = 0 then 'hydrography: all valid'
        else 
            'hydrography: some invalid'
    end as hydrography
from hydrography;
select
    case
        when not 
            count(st_isvalid(geom)) = 0 then 'hydro_structure: all valid'
        else 
            'hydro_structure: some invalid'
    end as hydro_structure
from hydro_structure;