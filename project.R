# Working directory
#getwd()
#setwd("")

# Environment
#Sys.getenv("VAR1")

library(tidyverse)
library(ggplot2)
library(sf)

#library(leaflet)
#library(giscoR)
#library(ggthemes)
#library(rnaturalearth)

### Dataset 1 "Bahn"
bahn <- read.csv("bahnmails/data_exp1.csv")
head(bahn)
colnames(bahn)

# Drop cols/rows
bahn <- bahn %>% 
    #select() %>%
    #slice(1:5)
    filter(date != "date")

# Write bahn to CSV
write.csv2(bahn, "bahndata_cleaned.csv", row.names = FALSE)

# Clean
# 1) Remove blanks spaces
#bahn <- bahn %>%
#    mutate(across(where(is.character), str_trim))

# 2) Homogenize date format
#   (-> YYYY-MM-DD)
bahn <- bahn %>%
    mutate(date = dmy(date))

# 3) 

# 4) Homogenize stations
#    Berlin Hbf (tief) = Berlin Hbf

# Augment bahn
# prio
# - duration
# - journey
# - speed_avg
# - price_per_min
# - booking_day
# - booking_time
# - booking_leadtime

# stats
# - LM leadtime <> price

# optional
# - city

# - booking_weekday
# - timestamp_iso8601



### Dataset 2 "Twitter"
twitter <- read.csv("twitterSentiment.csv")
head(twitter)
colnames(twitter)

# Drop cols
twitter <- twitter %>% 
    select(-User.Name) %>%
    slice(1:5)
    #filter()

# Write twitter to CSV
write.csv2(twitter, "twitterSentiment_cleaned.csv", row.names = FALSE)

### Dataset 3 "Timeline"
df <- read.csv("timelineTest.csv")
head(df)
# Drop cols
df <- df %>% select(latitudeE7, longitudeE7, timestamp, source)
# filter
df <- df %>% filter(source == "GPS")

# Clean timestamp
# Convert ISO 8601 to POSIXct & CET timezone
#timestamp <- "2024-08-05T12:15:21.193Z"
#posix_timestamp <- as.POSIXct(timestamp, format="%Y-%m-%dT%H:%M:%OSZ", tz="CET")
#print(posix_timestamp)
# convert all timestamps
df$timestamp_CET <- as.POSIXct(df$timestamp, format="%Y-%m-%dT%H:%M:%OSZ", tz="CET")

# Clean coordinates
# Convert to scientific notation
df$latitude <- df$latitudeE7 / 1e7
df$longitude <- df$longitudeE7 / 1e7

# Write df to CSV
write.csv2(df, "timelineTest_cleaned.csv", row.names = FALSE)

# Create GEO objects
# Convert to sf object
sf_df <- st_as_sf(df, coords = c("longitude", "latitude"), crs = 4326)
# Transform coordinates to another CRS (e.g., UTM zone 33N)
sf_df_transformed <- st_transform(sf_df, crs = 32633)
# View transformed coordinates
print(sf_df_transformed)

# Display on map
