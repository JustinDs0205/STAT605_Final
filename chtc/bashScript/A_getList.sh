#!/bin/bash

# change the permission of the file
chmod u+x ./getList.sh

# call the function for task A
#TEMP_DIR=$_CONDOR_SCRATCH_DIR
#OUTPUT_DIR="$TEMP_DIR/split_ID"
OUTPUT_DIR="split_ID"

./getList.sh $OUTPUT_DIR A_List
