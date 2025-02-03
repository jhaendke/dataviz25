
# GMaps Timeline Data
## Data
- timestamp
- latitude
- longitutde

- group by city
- group by month, weekday, time of day

## Goals
- flatten json
- heatmap
- travel time
- augment data per city

## corr: Bank statement
- timestamp
- amount

## corr: Weather
- sunset
- agg: rainy/cold/sunny/warm
- augment with weather per city

---

# Deutsche Bahn Travel Reporting

## Data
- departure_time_scheduled
- departure_time
- arrival_scheduled
- arrival_time
- duration_scheduled ##calc
- duration  ##calc
- delay ##calc

- departure_station
- arrival_station
- distance
- distance_direct ##calc via web
- journey ##calc (DUS-BER, DUS-MUC, BER-MUC, BER-HAM, HAM-DUS, other)
- journey_weekday ##calc
- journey_timeofday ## (morning, midday, afternoon, evening)

- price
- price per km ##calc
- price per 100km ##calc
- price per min delay ##calc

- price baseline by 2015 (share of "consumer bucket")
- price_real (by 2025 prices)

- booking_time
- booking_leadtime ##calc
- booking_price_per_day_lead ##calc