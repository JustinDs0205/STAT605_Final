# Data download

We need to download data from 

- kaggle: https://www.kaggle.com/datasets/aadimator/nyc-realtime-traffic-speed-data 

- nyc opendata: https://data.cityofnewyork.us/Transportation/DOT-Traffic-Speeds-NBE/i4gi-tjb9/about_data

---

## kaggle

Methods verified with `public04.stat.wisc.edu` ! 

### download

`curl -L -o ./data/archive.zip https://www.kaggle.com/api/v1/datasets/download/aadimator/nyc-realtime-traffic-speed-data`

The zip data is 9844M and needs about 22 minutes to finish download. My screen says:

```
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
 52 9844M   52 5188M    0     0  9960k      0  0:16:52  0:08:53  0:07:59 36.1M
 79 9844M   79 7806M    0     0  8732k      0  0:19:14  0:15:15  0:03:59 37.0M
100 9844M  100 9844M    0     0  7875k      0  0:21:19  0:21:19 --:--:-- 37.9M
```

### unzip

- `unzip archive.zip` (not recommeded)
	- I waited for about 40 minutes but it still hasn't finished. So I aborted the command, and the resulted csv is 9.7G - it should be 26.4G if fully unzipped.

- `7z x archive.zip -o./7z/`
	- I am trying it, and it should work well. It shows the progress of unzip on screen ;-) !!

---

## nyc opendata

Methods have only verified with local machine.

### python

```py
# !pip install sodapy
import pandas as pd
from sodapy import Socrata
```

#### download as one file (not recommeded)

`limit=10` needs 18-19 seconds to run, which leads to a huge timeout if we want to download more

```python
# Unauthenticated client only works with public data sets. Note 'None'
# in place of application token, and no username or password:
client = Socrata("data.cityofnewyork.us", None, timeout=20)

# First 10 results, returned as JSON from API / converted to Python list of
# dictionaries by sodapy.
results = client.get("i4gi-tjb9", limit=10)

# Convert to pandas DataFrame
results_df = pd.DataFrame.from_records(results)
results_df.to_csv("./data/results.csv")
```

#### download as several files

note that to use this method, you should replace `apptoken`,`username` and `password` with your own one

```py
# download `limit` rows into several files,
# each one has `batch_size` rows
batch_size = 5
limit = 20
timeout = 20

# Example authenticated client (needed for non-public datasets):
client = Socrata("data.cityofnewyork.us", 
                 "apptoken", username="username",password="password",
                 timeout=timeout)

# get and store data
for offset in range(0, limit, batch_size):
    batch = client.get("i4gi-tjb9", limit=batch_size, offset=offset)
    pd.DataFrame.from_records(batch).to_csv("./data/"+str(offset/batch_size)+".csv")
```

### powershell

substitute apptoken with your token

```powershell
$url = "https://data.cityofnewyork.us/resource/i4gi-tjb9?`$limit=10"
$apptoken = "apptoken"

# Set header to accept JSON
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Accept","application/json")
$headers.Add("X-App-Token",$apptoken)

$results = Invoke-RestMethod -Uri $url -Method get -Headers $headers
$csvContent = $results | ConvertTo-Csv -NoTypeInformation | ForEach-Object { $_ -replace '"', '' }
$csvContent | Set-Content -Path "./data/results.csv" -Encoding UTF8
```

### bash

substitute apptoken with your token

```powershell
#!/bin/bash

url="https://data.cityofnewyork.us/resource/i4gi-tjb9?\$limit=10"
apptoken="apptoken"

curl -s -H "Accept: application/json" -H "X-App-Token: $apptoken" "$url" | \
  jq -r '["id", "speed", "travel_time", "status", "data_as_of", "link_id", "link_points", "encoded_poly_line", "encoded_poly_line_lvls", "owner", "transcom_id", "borough", "link_n"], (.[] | [.id, .speed, .travel_time, .status, .data_as_of, .link_id, .link_points, .encoded_poly_line, .encoded_poly_line_lvls, .owner, .transcom_id, .borough, .link_n]) | @csv' > ./data/results.csv
```

