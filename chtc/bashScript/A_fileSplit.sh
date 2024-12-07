#!/bin/bash
### Split the file according to "Link_ID"

# Set the working directory and input file
INPUT_FILE="DOT_Traffic_Speeds_NBE.csv"
#TEMP_DIR=$_CONDOR_SCRATCH_DIR
#OUTPUT_DIR="$TEMP_DIR/split_ID"
OUTPUT_DIR="split_ID"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Check if the input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found."
    exit 1
fi

# Extract the header line
HEADER=$(head -n 1 "$INPUT_FILE")

# Process the CSV file
tail -n +2 "$INPUT_FILE" | awk -F',' -v header="$HEADER" -v output_dir="$OUTPUT_DIR" '
{
    link_id = $6;                          
    gsub(/^[ \t]+|[ \t]+$/, "", link_id);  # Remove leading and trailing whitespace.
    gsub(/[^a-zA-Z0-9_-]/, "_", link_id);  # Replace invalid characters with underscores.

    file_name = output_dir "/linkid_" link_id ".csv";

    if (!(file_name in seen)) {
        seen[file_name] = 1;
        print header > file_name;
    }

    print $0 >> file_name;
}'

echo "Data splitting completed! Files are saved in '$OUTPUT_DIR'."
