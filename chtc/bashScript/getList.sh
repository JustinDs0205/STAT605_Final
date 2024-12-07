#!/bin/bash

# Directory to list
DIR=${1:-.} # Default to current directory if not provided
# Output file
OUTPUT_FILE=${2:-file_list.txt}
# Write the list of files to the output file
find "$DIR" -type f > "$OUTPUT_FILE"

echo "List of files in '$DIR' has been saved to '$OUTPUT_FILE'."

# call the function for task A
#get_list ./data/split_ID A_List
# call the function for task B
#get_list ./data/split_month B_List
