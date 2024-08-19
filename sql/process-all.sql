set search_path to landmass, public;
set client_min_messages TO warning;
\set QUIET 1
\i ./sql/process-setup.sql;
\i ./sql/process.sql;
\i ./sql/process-validate.sql;
\i ./sql/process-teardown.sql;