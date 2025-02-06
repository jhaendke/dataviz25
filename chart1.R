# Working directory
# getwd()
# setwd("")

#install.packages("")

# Environment
# Sys.getenv("VAR1")
# rm(list = ls())  #ä clean global env

library(tidyverse)
library(ggplot2)
library(lubridate)
library(svglite)
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

# Drop spam users
view(twitter %>% 
  filter(grepl("thiago neuza", user, ignore.case = TRUE)))
twitter <- twitter %>% 
  filter(!grepl("thiago neuza", user, ignore.case = TRUE))

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
counts_date <- as.data.frame(twitter %>%
  group_by(date, month) %>%
  summarise(
    total = n(),
    positive = sum(sentiment == "positive"),
    negative = sum(sentiment == "negative"),
    neutral = sum(sentiment == "neutral")
    ))

counts_weekday <- as.data.frame(twitter %>%
  group_by(weekday) %>%
  summarise(
    total = n(),
    positive = sum(sentiment == "positive"),
    negative = sum(sentiment == "negative"),
    neutral = sum(sentiment == "neutral")
    ))

counts_month23 <- as.data.frame(twitter %>%
  filter(year(date) == 2023) %>% # year
  group_by(month) %>%
  summarise(
    total = n(),
    positive = sum(sentiment == "positive"),
    negative = sum(sentiment == "negative"),
    neutral = sum(sentiment == "neutral")
    ))
counts_month24 <- as.data.frame(twitter %>%
  filter(year(date) == 2024) %>% # year
  group_by(month) %>%
  summarise(
    total = n(),
    positive = sum(sentiment == "positive"),
    negative = sum(sentiment == "negative"),
    neutral = sum(sentiment == "neutral")
    ))

counts_numweek23 <- as.data.frame(twitter %>%
  filter(year(date) == 2023) %>% # year
  group_by(numweek) %>%
  summarise(
    total = n(),
    positive = sum(sentiment == "positive"),
    negative = sum(sentiment == "negative"),
    neutral = sum(sentiment == "neutral")
    ))
counts_numweek24 <- as.data.frame(twitter %>%
  filter(year(date) == 2024) %>% # year
  group_by(numweek) %>%
  summarise(
    total = n(),
    positive = sum(sentiment == "positive"),
    negative = sum(sentiment == "negative"),
    neutral = sum(sentiment == "neutral")
    ))

ggplot(counts_numweek23, aes(x = numweek, y = total)) +
  geom_point() +
  labs(title = "Total Counts by Week Number in 2023",
        x = "Week Number",
        y = "Total Count") +
  theme_minimal()
  #
  # Count "Thu"
  #filter(weekday == "Thu") %>%
  #count())

# sentiment (pos/neg/neut) per date


# Plot s

# Time-Series Trends

# "Post volume over time"
pvol <- ggplot(counts_date, aes(x = date, y = total)) +
  geom_point(color = "grey30") +
  geom_smooth(method = "lm", se = TRUE, color = "#e7421d", fill = "lightblue", alpha = 0.6) +
  geom_vline(xintercept = as.Date(c("2023-10-07", "2024-05-31", "2024-08-24")), linetype = "dashed", color = "black") +
  annotate("text",
    x = as.Date("2023-10-07") - 10, y = 3800,
    label = "Attack Hamas\n07.10.23", angle = 0, vjust = 0, hjust = 1, color = "black"
  ) +
  annotate("text",
    x = as.Date("2024-05-31") - 10, y = 4000,
    label = "Attack Mannheim\n31.05.23", angle = 0, vjust = 0, hjust = 1, color = "black"
  ) +
  annotate("text",
    x = as.Date("2024-08-24") + 10, y = 4300,
    label = "Attack Solingen\n24.08.24", angle = 0, vjust = 0, hjust = 0, color = "black"
  ) +
  labs(
    title = "Observations by Date",
    x = "", # Date
    y = "total"
  ) +
  ylim(0, 5000) +
  xlim(as.Date("2022-12-24"), as.Date("2024-12-31")) +
  theme_light() +
  # ggtitle("My Headline") +
  theme(
    axis.text.y = element_text(angle = 0, hjust = 1),
    plot.title = element_text(face = "bold")
  )

pvol
ggsave("chart1/pvol.png", plot = pvol, width = 10, height = 5.625, units = "in", dpi = 300)
ggsave("chart1/pvol.svg", plot = pvol, width = 10, height = 5.625, units = "in", dpi = 300)

# Summary statistics


# "Sentiment volume over time" (Line)
pvolsentimentline <- ggplot(counts_date, aes(x = date, y = total)) +
  geom_line(color = "grey90") +
  #geom_smooth(method = "lm", se = TRUE, color = "#e7421d", fill = "lightblue", alpha = 0.6) +
  geom_line(aes(y = negative), color = "#ff4444") +
  geom_line(aes(y = positive), color = "#0084ff") +
  geom_smooth(aes(y = negative), method = "lm", color = "black", se = FALSE, linewidth=0.5, linetype = "solid", alpha=0.5) +
  #geom_smooth(aes(y = positive), method = "lm", color = "white", se = FALSE, linewidth=0.5, linetype = "solid", alpha=0.5) +
  geom_vline(xintercept = as.Date(c("2023-10-07", "2024-05-31", "2024-08-24")), linetype = "dashed", color = "#00000085") +
  annotate("text",
    x = as.Date("2023-10-07") - 10, y = 3800,
    label = "Attack Hamas\n07.10.23", angle = 0, vjust = 0, hjust = 1, color = "black"
  ) +
  annotate("text",
    x = as.Date("2024-05-31") - 10, y = 4000,
    label = "Attack Mannheim\n31.05.23", angle = 0, vjust = 0, hjust = 1, color = "black"
  ) +
  annotate("text",
    x = as.Date("2024-08-24") + 10, y = 4300,
    label = "Attack Solingen\n24.08.24", angle = 0, vjust = 0, hjust = 0, color = "black"
  ) +
  labs(
    title = "Sentiment by Date",
    x = "", # Date
    y = "total"
  ) +
  ylim(0, 5000) +
  xlim(as.Date("2022-12-24"), as.Date("2024-12-31")) +
  theme_light() +
  # ggtitle("My Headline") +
  theme(
    axis.text.y = element_text(angle = 0, hjust = 1),
    plot.title = element_text(face = "bold")
  )

pvolsentimentline
ggsave("chart1/pvolsentimentline.png", plot = pvolsentimentline, width = 10, height = 5.625, units = "in", dpi = 300)
ggsave("chart1/pvolsentimentline.svg", plot = pvolsentimentline, width = 10, height = 5.625, units = "in", dpi = 300)


# "Sentiment volume over time" (Area)
pvolsentimentarea <- ggplot(counts_date, aes(x = date)) +
  geom_area(aes(y = total), fill = "grey90", alpha = 1) +
  geom_area(aes(y = negative), fill = "#ff4444", alpha = 1) +
  geom_area(aes(y = positive), fill = "#0084ff", alpha = 1) +
  geom_smooth(aes(y = positive), method = "lm", color = "white", se = FALSE, linewidth=0.5, linetype = "dashed", alpha=0.5) +
  geom_smooth(aes(y = negative), method = "lm", color = "black", se = FALSE, linewidth=0.5, linetype = "dashed", alpha=0.5) +
  geom_vline(xintercept = as.Date(c("2023-10-07", "2024-05-31", "2024-08-24")), linetype = "dashed", color = "grey") +
  annotate("text",
    x = as.Date("2023-10-07") - 10, y = 3800,
    label = "Attack Hamas\n07.10.23", angle = 0, vjust = 0, hjust = 1, color = "grey"
  ) +
  annotate("text",
    x = as.Date("2024-05-31") - 10, y = 4000,
    label = "Attack Mannheim\n31.05.23", angle = 0, vjust = 0, hjust = 1, color = "grey"
  ) +
  annotate("text",
    x = as.Date("2024-08-24") + 10, y = 4300,
    label = "Attack Solingen\n24.08.24", angle = 0, vjust = 0, hjust = 0, color = "grey"
  ) +
  labs(
    title = "Sentiment by Date",
    x = "", # Date
    y = "Total"
  ) +
  ylim(0, 5000) +
  xlim(as.Date("2022-12-24"), as.Date("2024-12-31")) +
  theme_light() +
  theme(
    axis.text.y = element_text(angle = 0, hjust = 1),
    plot.title = element_text(face = "bold")
  )

ggsave("chart1/pvolsentimentarea.svg", plot = pvolsentimentarea, width = 10, height = 5.625, units = "in", dpi = 300)
ggsave("chart1/pvolsentimentarea.png", plot = pvolsentimentarea, width = 10, height = 5.625, units = "in", dpi = 300)



#pvolsentimentarea <- 
ggplot(counts_date, aes(x = date, y = total, fill = positive)) +
  geom_area() +
  #geom_smooth(method = "lm", se = TRUE, color = "#e7421d", fill = "lightblue", alpha = 0.6) +
  #geom_line(aes(y = positive), color = "#005cb3") +
  #geom_line(aes(y = negative), color = "#d04833") +
  geom_vline(xintercept = as.Date(c("2023-10-07", "2024-05-31", "2024-08-24")), linetype = "dashed", color = "black") +
  annotate("text",
    x = as.Date("2023-10-07") - 10, y = 3800,
    label = "Attack Hamas\n07.10.23", angle = 0, vjust = 0, hjust = 1, color = "black"
  ) +
  annotate("text",
    x = as.Date("2024-05-31") - 10, y = 4000,
    label = "Attack Mannheim\n31.05.23", angle = 0, vjust = 0, hjust = 1, color = "black"
  ) +
  annotate("text",
    x = as.Date("2024-08-24") + 10, y = 4300,
    label = "Attack Solingen\n24.08.24", angle = 0, vjust = 0, hjust = 0, color = "black"
  ) +
  labs(
    title = "Sentiment by Date",
    x = "", # Date
    y = "total"
  ) +
  ylim(0, 5000) +
  xlim(as.Date("2022-12-24"), as.Date("2024-12-31")) +
  theme_light() +
  # ggtitle("My Headline") +
  theme(
    axis.text.y = element_text(angle = 0, hjust = 1),
    plot.title = element_text(face = "bold")
  )



# Histogram
# ...

# Barplot by Month
ggplot(counts_date, aes(x = month, y = total)) +
  geom_col() +
  labs(title = "Total Observations by Month",
       x = "Month",
       y = "Total Count") +
  theme_light()
  # mark events (time boxes) ## TODO einfügen
    # Israel (2023-10-07)
    # Mannheim (2024-05-31)
    # Solingen (2024-08-24)

# "Sentiment over time"  ## TODO
# inkl Trendline        ## TODO
ggplot(counts_date, aes(x = date, y = n)) +
  geom_point() +
  labs(title = "Observations by Date",
       x = "Date",
       y = "n") +
  theme_minimal()

# Engagement Analysis
# "Engagement by sentiment"
# "Engagement correlation"

# Treemap
# count per user_id
# count reactions by user_id



# Text Analysis
# Word Frequencies
# "Sentiment Shifts"


# deviation from avg per month (bipolar)

# boxplot per month

# pie

# Steamgraph

# stacked grouped bars

# ) LM day_of_month <> sentiment