#!/bin/bash

echo "LINK_ID,overspeed_rate,jam_rate,borough,link_name" > summary_results.csv

cat split_ID/A_summary_*.csv >> summary_results.csv

#TEMP_DIR=$(_CONDOR_SCRATCH_DIR)
#OUTPUT_DIR="$TEMP_DIR/split_ID"
#OUTPUT_DIR="./data/split_ID"

#rm -rf OUTPUT_DIR
rm -rf split_ID
