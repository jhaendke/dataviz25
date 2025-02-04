# Working directory
# getwd()
# setwd("")

# install.packages("")

# Environment
# Sys.getenv("VAR1")

library(tidyverse)
library(ggplot2)
library(lubridate)
#library(ggthemes)

### Dataset 2 "Twitter"
twitter <- read.csv("case_twitter/twitterSentiment.csv")
#head(twitter)
colnames(twitter)
view(head(twitter))

### Cleaning

# Drop & Rename cols, rows
twitter <- twitter %>% 
    select(-X,-Negative,-Neutral,-Positive) %>%
    rename(user=User.Name,text=Text,retweet=Retweet.Count,favorite=Favorite.Count,date=Date)
    #slice(1:1000)
    #filter()

# Anonymize usernames
# Alternatively: Fake Names library(randomNames) -> randomNames(692) 
unique_user <- unique(twitter$user)
user_to_id <- setNames(seq_along(unique_user), unique_user)
twitter$user_id <- user_to_id[twitter$user] # add col
user_id_table <- data.frame(user = names(user_to_id), id = user_to_id, row.names = NULL) # create mapping table
twitter <- twitter %>% 
    select(-user)

view(head(user_id_table))
view(head(twitter))

# Transform var types

# date: 692 unique dates in twitter
length(unique(twitter$date))

# sentiment: 3 levels
twitter <- twitter %>% 
    mutate(sentiment = as.factor(sentiment)) # fct (3)
unique(twitter$sentiment)
levels(twitter$sentiment)

# date
twitter$date <- as.Date(twitter$date, format = "%m/%d/%Y")
 #timestamp_new <- as.POSIXct(timestamp, format="%Y-%m-%dT%H:%M:%OSZ", tz="CET")

### Save
# to memory
twitter_long <- twitter
# to CSV
write.csv2(twitter, "case_twitter/twitterSentiment_cleaned.csv", row.names = FALSE)
# to shorter CSV
twitter_short <- twitter %>%
    slice(1:9000)
write.csv2(twitter_short, "case_twitter/twitterSentiment_cleaned_short.csv", row.names = FALSE)

### Analysis

twitter <- twitter_long
twitter <- twitter_short

# Sentiment by date

# 1) insert col weekday
#    insert col month
twitter <- twitter %>% 
    mutate(
        weekday = wday(date, label = TRUE), # ord fct (7)
        month = month(date, label = TRUE), # ord fct (12)
        numweek = as.numeric(strftime(date, format = "%U")) # num
    )

# 2) basic stats

min(twitter$date) # earliest: 2023-01-01
max(twitter$date) # latest: 2024-11-28


# ) Count
# observations per [..]
counts_date <- twitter %>%
  group_by(date) %>%
  summarise(n = n())

counts_weekday <- twitter %>%
  group_by(weekday) %>%
  summarise(n = n())

counts_month <- twitter %>%
  group_by(month) %>%
  summarise(n = n())

counts_numweek <- twitter %>%
  filter(year(date) == 2024) %>% # year 2024
  count(numweek)
  #
  # Count "Thu"
  #filter(weekday == "Thu") %>%
  #count())

# sentiment (pos/neg/neut) per date

# Plot 

ggplot(counts_date, aes(x = date, y = n)) +
  geom_point() +
  labs(title = "Observations by Date",
       x = "Date",
       y = "n") +
  theme_minimal()

  # mark events (time boxes)


# deviation from avg per month (bipolar)

# boxplot per month

# pie

# Steamgraph

# stacked grouped bars

# ) LM day_of_month <> sentiment