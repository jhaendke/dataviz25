# Working directory
# getwd()
# setwd("")

# Environment
# Sys.getenv("VAR1")

library(tidyverse)
library(ggplot2)
#library(ggthemes)

### Dataset 2 "Twitter"
twitter <- read.csv("case_twitter/twitterSentiment.csv")
head(twitter)
colnames(twitter)

# Cleaning
# Drop cols
twitter <- twitter %>% 
    select(-User.Name)
    #select(timestamp)
    #filter(date != "date")
# Write twitter to CSV
write.csv2(twitter, "case_twitter/twitterSentiment_cleaned.csv", row.names = FALSE)

# Write shorter dataset
twitter_short <- twitter %>%
    slice(1:5000)
write.csv2(twitter_short, "case_twitter/twitterSentiment_cleaned_short.csv", row.names = FALSE)




# Clean timestamp
# Convert ISO 8601 to POSIXct & CET timezone
#timestamp <- "2024-08-05T12:15:21.193Z"
#posix_timestamp <- as.POSIXct(timestamp, format="%Y-%m-%dT%H:%M:%OSZ", tz="CET")
#print(posix_timestamp)
#
# convert all timestamps
#df$timestamp_CET <- as.POSIXct(df$timestamp, format="%Y-%m-%dT%H:%M:%OSZ", tz="CET")