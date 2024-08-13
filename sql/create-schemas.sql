create schema if not exists landmass; -- authorization mobile_latlong;
grant usage on schema 
    landmass 
to 
    public;
grant usage on schema 
    landmass 
to 
    landmass;
-- secure schema usage pattern
-- https://www.postgresql.org/docs/current/ddl-schemas.html#DDL-SCHEMAS-PATTERNS
revoke create on schema 
    public 
from 
    public;