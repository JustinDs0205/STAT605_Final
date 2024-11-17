# STAT 605 DSCP Group project

## data

- nyc real-time traffic speed

- link to the dataset:

	- kaggle: https://www.kaggle.com/datasets/aadimator/nyc-realtime-traffic-speed-data 
		- until 2022-10-22


	- nyc opendata: https://data.cityofnewyork.us/Transportation/DOT-Traffic-Speeds-NBE/i4gi-tjb9/about_data
		- real-time data, updated constantly


## problem

- identify anomalous traffic conditions through a systematic approach

## update at 11.16

- Data_Split.R: Split all files by link_id

- data_analysis_v2.py: Calculate the overspeed_rate and jam_rate in parallel

- summary_results.csv: output of data_analysis_v2.py, including 5 columns(LINK_ID, overspeed_rate, jam_rate, borough, link_name)

- Visualization_v2.R: Visualization of overspeed_rate and jam_rate in shinyapp
<img width="1288" alt="image" src="https://github.com/user-attachments/assets/59917146-ff19-42d0-9b1a-b96f8cc2a0ef">
<img width="1294" alt="image" src="https://github.com/user-attachments/assets/a632b776-0d7c-4a22-95c6-7797b4ec0d39">



