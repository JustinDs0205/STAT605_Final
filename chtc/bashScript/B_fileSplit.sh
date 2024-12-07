#!/bin/bash

## Split the file according to time in month

# Set the working directory and input file
INPUT_FILE="DOT_Traffic_Speeds_NBE.csv"
OUTPUT_DIR="split_month"

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
BEGIN {
    OFS = ",";  # Ensure the output is comma-separated
}

{
    date_str = $5;

    # Parse the date string to extract year and month
    split(date_str, date_parts, "T");         # Split "YYYY-MM-DDTHH:MM:SS" into "YYYY-MM-DD" and "HH:MM:SS"
    split(date_parts[1], ymd, "-");          # Split "YYYY-MM-DD" into year, month, day
    year_month = ymd[1] "-" ymd[2];          # Combine year and month

    # Sanitize year_month to ensure no invalid characters
    gsub(/[^a-zA-Z0-9_-]/, "_", year_month);  # Replace invalid characters with underscores

    # Define the output file name
    file_name = output_dir "/month_" year_month ".csv";

    # If this is the first time writing to this file, add the header
    if (!(file_name in seen)) {
        seen[file_name] = 1;
        print header > file_name;
    }

    # Append the current row to the appropriate file
    print $0 >> file_name;
}
'

echo "Data splitting completed! Files are saved in '$OUTPUT_DIR'."
