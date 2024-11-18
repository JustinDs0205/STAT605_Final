import pandas as pd
import glob
import os
import multiprocessing

# Function to calculate the rates
def calculate_rates(file_path):
    data = pd.read_csv(file_path)
    m = len(data)
    
    if 'SPEED' not in data.columns or 'LINK_ID' not in data.columns or 'BOROUGH' not in data.columns or 'LINK_NAME' not in data.columns:
        print(f"Missing required columns in {file_path}")
        return file_path, None, None, None, None, None

    if m < 10:
        print(f"Not enough data in {file_path}")
        return file_path, None, None, None, None, None

    overspeed_rate = sum(data['SPEED'] > 60) / m
    jam_rate = sum(data['SPEED'] <= 10) / m
    link_id = data['LINK_ID'].iloc[0]
    borough = data['BOROUGH'].iloc[0]
    link_name = data['LINK_NAME'].iloc[0]

    return link_id, overspeed_rate, jam_rate, borough, link_name

# Function to process a batch of files
def process_files(file_paths):
    results = []
    for file_path in file_paths:
        results.append(calculate_rates(file_path))
    return results

# Main function to parallelize processing
if __name__ == "__main__":
    # Get list of CSV files
    csv_files = glob.glob('/Users/zdliu/Desktop/605_2024fall/Data/*.csv')
    
    if not csv_files:
        print("No CSV files found in the specified directory.")
        exit()
    
    # Number of processes to run in parallel
    num_processes = min(multiprocessing.cpu_count(), len(csv_files))
    
    # Split files for each process
    chunk_size = max(1, len(csv_files) // num_processes)
    chunks = [csv_files[i:i + chunk_size] for i in range(0, len(csv_files), chunk_size)]

    # Create a pool of workers
    with multiprocessing.Pool(num_processes) as pool:
        # Process files in parallel
        all_results = pool.map(process_files, chunks)
    
    # Flatten the list of results
    all_results = [result for chunk in all_results for result in chunk]
    
    # Filter out invalid results
    valid_results = [result for result in all_results if result[1] is not None and result[2] is not None]
    
    if not valid_results:
        print("No valid results found.")
    else:
        # Create a DataFrame and save to CSV
        results_df = pd.DataFrame(valid_results, columns=['LINK_ID', 'overspeed_rate', 'jam_rate', 'borough', 'link_name'])
        results_df.to_csv('/Users/zdliu/Desktop/605_2024fall/summary_results.csv', index=False)
        
        # Print results
        for link_id, overspeed_rate, jam_rate, borough, link_name in valid_results:
            print(f"Link ID {link_id}: Overspeed Rate = {overspeed_rate:.2f}, Jam Rate = {jam_rate:.2f}, Borough = {borough}, Link Name = {link_name}")
