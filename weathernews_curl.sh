#!/bin/bash

city="$1"
if [[ -z "$city" ]]; then
  echo "Usage: $0 <city>"
  exit 1
fi

if [[ -z "$MAPBOX_TOKEN" ]]; then
  echo "Error: MAPBOX_TOKEN env is not set."
  exit 1
fi

city_enc=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$city'''))")

read id lat lon short_code <<< $(curl -s "https://api.mapbox.com/geocoding/v5/mapbox.places/$city_enc.json?access_token=$MAPBOX_TOKEN" \
  | jq -r '
      .features[0] 
      | .id as $id 
      | .center[1] as $lat 
      | .center[0] as $lon 
      | (.context[] | select(.id|startswith("country.")) | .short_code) as $code 
      | [$id, $lat, $lon, $code] 
      | @tsv
  ')

if [[ -z "$id" || -z "$lat" || -z "$lon" || -z "$short_code" ]]; then
  echo "Error: '$city' not found."
  exit 1
fi

lat=$(printf "%.6f" "$lat")
lon=$(printf "%.6f" "$lon")
string="$id,$lat,$lon"
encoded=$(echo -n "$string" | base64)

short_code=$(echo "$short_code" | tr '[:upper:]' '[:lower:]')
link="https://weathernews.com/weather/en/$short_code/$encoded/"

curl -s "$link" \
  | grep -oP '__NUXT_DATA__">\K.*?(?=<\/script)' \
  | sed 's/^\["ShallowReactive",1\],//' \
  | python3 weather_parser.py
