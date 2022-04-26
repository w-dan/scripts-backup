import pandas as pd
import googlemaps
import os

# dataset
df = pd.read_csv("N1.csv")
df

# LON and LAN from gmaps API

gmaps_key = googlemaps.Client(key = "AIzaSyCEMMCfQt8HDkViey1Tvgdu_gK2c2W32vQ")

# create geocode result object
# get lon and lan
df["LON"] = None
df["LAT"] = None

for i in range(0, len(df), 1):
    geocode_result = gmaps_key.geocode(df.iat[i, 0])

    try:
        lon = geocode_result[0]["geometry"]["location"]["lng"]
        lat = geocode_result[0]["geometry"]["location"]["lat"]
        df.iat[i, df.columns.get_loc("LON")] = lon
        df.iat[i, df.columns.get_loc("LAT")] = lat

    except:
        lat = None
        lon = None

print(df)
# df.to_csv('out1.csv')
