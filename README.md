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

- summary_results.csv: output of data_analysis_v2.py, including 5 columns(LINK_ID, overspeed_rate, jam_rate, borough, link_name)[updated]

- Visualization_v2.R: Visualization of overspeed_rate and jam_rate in shinyapp
<img width="1288" alt="image" src="https://github.com/user-attachments/assets/59917146-ff19-42d0-9b1a-b96f8cc2a0ef">
<img width="1294" alt="image" src="https://github.com/user-attachments/assets/a632b776-0d7c-4a22-95c6-7797b4ec0d39">

## Check the visualization by shinyapp.io:
- https://zdliu0205.shinyapps.io/visualization_v2/ (old version)
- https://zdliu0205.shinyapps.io/Visualization_v3/ (correct version)

## update at 11.17

- data_cleaning.py: Reclean dataset -- Delete Outliers where STATUS == -101,causing SPEED == 0 which influences the calculation of jam_rate.
	- After deleting outliers recalculate the overspeed_rate and jam_rate in parallel

- data_analysis_v3.py : redefine the jam rate as I(SPEED < 10)/m, reproduce the summary_results.csv

- Visualization_v3.R: Visualization of overspeed_rate and jam_rate in shinyapp by new summary_results.csv
        - https://zdliu0205.shinyapps.io/Visualization_v3/
  
- Interesting point: The highest street is '11th ave n ganservoort - 12th ave @ 40th st', where
	- A policy may cause the traffic jam: https://www.cbsnews.com/newyork/news/traffic-hours-nyc-11th-avenue/
	- Topic about the jam in 11th Ave: https://www.reddit.com/r/upstate_new_york/comments/1e2jpy9/so_many_terrible_drivers_on_the_thruway/

 ## update at 11.17 22:30pm

 - Final Visualization: https://zdliu0205.shinyapps.io/street_map_visualization_try/

 - Street_map_visualization_try.R: main script of street_map_visualization

 - shinyapp_start.R: Start to compile the street_map_visualization_try.R

 - Some data_cleaning scripts: I will add comments later lol

<img width="1505" alt="image" src="https://github.com/user-attachments/assets/0fb67cbc-03ed-4979-9255-bb01d78438f5">

## update at 12.10

- updata our new slides

- add the cluster method with K-means,overspeed rate and jam rate were used for cluster analysis of different link_name to 
find out the road sections with similar traffic patterns. 

- <img width="569" alt="image" src="https://github.com/user-attachments/assets/08246fd9-befc-4bda-9fe2-faaf637f7493">
- <img width="362" alt="image" src="https://github.com/user-attachments/assets/80373998-ddff-41ae-8cf9-f4bea5d5f702">

- Example: Validation of Data Analysis: Traffic Jam on 11th Avenue





 

