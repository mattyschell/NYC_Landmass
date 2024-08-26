set search_path to landmass, public;
set client_min_messages TO warning;
\set QUIET 1
\i ./data/roughborough.sql;
\i ./data/landmassfringe.sql;
\i ./data/hydrography.sql;
\i ./data/hydro_structure.sql;
\i ./data/validate.sql