#!/usr/bin/env bash
psql -t -c "drop database scratchmass"
psql -t -c "drop user landmass;"