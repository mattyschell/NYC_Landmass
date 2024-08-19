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

