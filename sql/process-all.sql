set search_path to landmass, public;
\i ./sql/process-setup.sql;
\i ./sql/process.sql;
\i ./sql/process-validate.sql;
\i ./sql/process-teardown.sql;