select
    case
        when not 
            count(st_isvalid(geom)) = 0 then 'landmassnycwet: all valid'
        else 
            'landmassnycwet: some invalid'
    end as landmassnycwet
from landmassnycwet;
select
    case
        when not 
            count(st_isvalid(geom)) = 0 then 'landmasspangaeawet: all valid'
        else 
            'landmasspangaeawet: some invalid'
    end as landmasspangaeawet
from landmasspangaeawet;
select
    case
        when not 
            count(st_isvalid(geom)) = 0 then 'landmassnycdry: all valid'
        else 
            'landmassnycdry: some invalid'
    end as landmassnycdry
from landmassnycdry;
select
    case
        when not 
            count(st_isvalid(geom)) = 0 then 'landmasspangaeadry: all valid'
        else 
            'landmasspangaeadry: some invalid'
    end as landmassnycdry
from landmassnycdry;

