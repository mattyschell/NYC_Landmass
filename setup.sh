#!/usr/bin/env bash
psql -t -v v1=$LMPASSWORD -f ./sql/create-users.sql
export PGUSER=landmass
export PGPASSWORD=$LMPASSWORD
psql -t -f ./sql/create-database.sql
export PGDATABASE=scratchmass
psql -t -f ./sql/setup-database.sql
psql -t -f ./sql/create-schemas.sql
#psql -t -f ./sql/setup-schemas.sql