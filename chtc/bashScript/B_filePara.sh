#!/bin/bash

## Calculate the average speed of one link_id for 30 minutes for one CSV

# Set the input file from the first argument
INPUT_FILE=$1

# Check if the input file is provided and exists
if [ -z "$INPUT_FILE" ]; then
    echo "Usage: $0 <input_csv_file>"
    exit 1
fi

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found."
    exit 1
fi

# Create the output directory if it doesn't exist
OUTPUT_DIR="./data/avgspeed"
mkdir -p "$OUTPUT_DIR"

# Create the output file name based on the input file name
BASE_NAME=$(basename "$INPUT_FILE" .csv)
OUTPUT_FILE="$OUTPUT_DIR/avgspeed_${BASE_NAME}.csv"

# Extract the header line for output
OUTPUT_HEADER="link_id,start_time,end_time,average_speed"
echo "$OUTPUT_HEADER" > "$OUTPUT_FILE"

# Process the CSV file
tail -n +2 "$INPUT_FILE" | awk -F',' -v output_file="$OUTPUT_FILE" '
BEGIN {
    OFS = ",";  # Ensure the output is comma-separated
}

{
    link_id = $6;
    speed = $2;
    timestamp = $5;

    # Clean and validate speed
    gsub(/[^0-9.]/, "", speed);  # Remove non-numeric characters
    if (speed == "" || speed == 0) {
        next;  # Skip invalid or zero speed
    }
    speed = speed + 0;  # Convert to numeric

    # Validate timestamp
    if (timestamp == "" || split(timestamp, date_time, "T") < 2) {
        next;  # Skip invalid timestamp
    }

    # Parse the timestamp to extract year, month, day, hour, and minute
    split(date_time[2], time_parts, ":");
    hour = time_parts[1];
    minute = time_parts[2];

    # Calculate the 30-minute interval
    interval_start_minute = int(minute / 30) * 30;
    interval_end_minute = interval_start_minute + 30;

    start_time = date_time[1] "T" hour ":" sprintf("%02d", interval_start_minute) ":00";
    end_time = date_time[1] "T" hour ":" sprintf("%02d", interval_end_minute) ":00";

    interval_key = link_id "|" start_time "|" end_time;

    # Accumulate data for the interval
    total_speed[interval_key] += speed;
    total_records[interval_key]++;
}

END {
    for (key in total_speed) {
        split(key, keys, "|");
        link_id = keys[1];
        start_time = keys[2];
        end_time = keys[3];

        # Calculate average speed
        avg_speed = total_speed[key] / total_records[key];

        # Write results to the output file
        print link_id, start_time, end_time, avg_speed >> output_file;
    }
}
'

echo "Average speed calculation completed! Results are saved in '$OUTPUT_FILE'."
