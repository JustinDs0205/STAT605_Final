#!/bin/bash

# download the data from kaggle
curl -L -o archive.zip https://www.kaggle.com/api/v1/datasets/download/aadimator/nyc-realtime-traffic-speed-data

# unzip it
unzip archive.zip -d ./
