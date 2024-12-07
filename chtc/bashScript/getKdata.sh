#!/bin/bash

# download the data from kaggle
curl -L -o data/archive.zip https://www.kaggle.com/api/v1/datasets/download/aadimator/nyc-realtime-traffic-speed-data

# unzip it
unzip data/archive.zip -d data/

# list
#ls -l data/
