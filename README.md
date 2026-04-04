# Weather Fetcher

## Description
👉👈


## Project structure

```bash
.
├── .env                # For MAPBOX_TOKEN
├── README.md
├── weathernews_curl.sh
└── weather_parser.py   # will be added
```


## How to use

You need to set Mapbox token as an environment variable in order to use the script.
The token can be obtained by signing up at [Mapbox Console](https://console.mapbox.com/account/access-tokens/).

Then, you can put the token in the `.env` file in the form of:

```env
MAPBOX_TOKEN='YOUR TOKEN'
```

Clone the repository to your local machine.

```bash
git clone https://github.com/prosk-sudo/weather_fetcher.git
cd weather_fetcher
```

Make sure `weathernews_curl.sh` has exec permission, you can set it by running:

```bash
sudo chmod +x weathernews_curl.sh
```

Run the script and specify the city you want the weather for as a parameter.

```bash
# Leipzig, as an example
./weathernews_curl.sh leipzig
```
