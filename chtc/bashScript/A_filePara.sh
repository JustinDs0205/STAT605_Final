#!/bin/bash
##data cleaning (remove "status" == -101) & compute jam rate & compute overspeed rate

# Directory containing CSV files
INPUT_ORIGINAL_FILE=$1 # e.g. ./data/spilt_ID/ID_1.csv
#INPUT_FILE="$_CONDOR_SCRATCH_DIR/split_ID/$(basename "$1")"
INPUT_FILE="split_ID/$(basename "$1")"

OUTPUT_FILE="split_ID/A_summary_$(basename "$1")"
#OUTPUT_FILE="summary_results.csv"

# Check if the input file is provided and exists
if [ -z "$INPUT_FILE" ]; then
  echo "Usage: $0 <input_csv_file> from filePara"
  exit 1
fi

if [ ! -f "$INPUT_FILE" ]; then
  echo "Error: File '$INPUT_FILE' not found from filePara."
  exit 1
fi

# Process the file
process_file() {
  local file_path="$1"

  # Extract the column headers
  header=$(head -n 1 "$file_path")

  # Check if required columns are present
  if ! echo "$header" | grep -q "SPEED" || \
     ! echo "$header" | grep -q "LINK_ID" || \
     ! echo "$header" | grep -q "BOROUGH"; then
    echo "Missing required columns in $file_path"
    return
  fi

  # Read the data excluding the header
  total_rows=$(tail -n +2 "$file_path" | wc -l)

  # Check if there are enough rows
  #if [ "$total_rows" -lt 10 ]; then
  #  echo "Not enough data in $file_path"
  #  return
  #fi

  # Calculate metrics
  overspeed_count=$(awk -F',' '$2 > 60 {count++} END {print count+0}' "$file_path")
  jam_count=$(awk -F',' '$2 <= 10 {count++} END {print count+0}' "$file_path")
  overspeed_rate=$(echo "$overspeed_count $total_rows" | awk '{printf "%.2f", $1 / $2}')
  jam_rate=$(echo "$jam_count $total_rows" | awk '{printf "%.2f", $1 / $2}')

  # Extract metadata
  link_id=$(awk -F',' 'NR==2 {print $6}' "$file_path")
  borough=$(awk -F',' 'NR==2 {print $(NF-1)}' "$file_path")
  link_name=$(awk -F',' 'NR==2 {print $(NF-0)}' "$file_path")

  # Append the results to the summary file
  echo "$link_id,$overspeed_rate,$jam_rate,$borough,$link_name" > "$OUTPUT_FILE"
  echo "Processed $file_path: Link ID $link_id, Overspeed Rate $overspeed_rate, Jam Rate $jam_rate"
}

# Initialize the summary file if it doesn't exist
#if [ ! -f "$OUTPUT_FILE" ]; then
#  echo "LINK_ID,overspeed_rate,jam_rate,borough,link_name" > "$OUTPUT_FILE"
#fi

# Process the file
process_file "$INPUT_FILE"
