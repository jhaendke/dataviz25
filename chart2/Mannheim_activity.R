library(tidyverse)
library(lubridate)
library(beeswarm)

df <- read.csv("Final_unprocessed.csv")

#1 Define the dates
Mannheim_dates <- as.Date(c("2024-05-30", "2024-05-31", "2024-06-01","2024-06-02"))

#2 Convert Created.At to a POSIXct datetime, then filter.
Final_Mannheim_specific <- df %>%
  mutate(Created.At = as.POSIXct(Created.At, format = "%a %b %d %H:%M:%S %z %Y")) %>%
  filter(as.Date(Created.At) %in% Mannheim_dates) %>%
  filter(str_detect(Text, regex("Islam|Mannheim", ignore_case = TRUE)))

#3 set start and end times for the y-axis; include breaks for better visibility
start_time <- as.POSIXct("2024-05-30 09:00:00", tz = "UTC")
end_time   <- ceiling_date(max(Final_Mannheim_specific$Created.At))

breaks_seq <- seq(from = start_time, to = end_time, by = "3 hours")
breaks_seq_num <- as.numeric(breaks_seq)

#4 set variables for annotations at specific times
annotation_time <- as.numeric(as.POSIXct("2024-05-31 11:34:00", tz = "UTC"))
annotation_time_2 <- as.numeric(as.POSIXct("2024-06-02 18:30:00", tz = "UTC"))

#5 plot the graph
p3<-Final_Mannheim_specific %>% ggplot(
  aes(x = 1, y = as.numeric(Created.At), color = sentiment)
) +
  geom_beeswarm(
    cex = 2,
    method = "swarm",
    corral = "wrap",
    corral.width = 0.3
  ) +
  scale_y_reverse(
    limits = c(as.numeric(end_time), as.numeric(start_time)),
    breaks = breaks_seq_num,
    labels = function(x) {
      # Convert back to the original time scale
      times_original <- as.POSIXct(x,origin = "1970-01-01", tz = "UTC")
      lab <- format(times_original, "%H:%M")
      is_midnight <- format(times_original, "%H:%M") == "00:00"
      lab[is_midnight] <- format(times_original[is_midnight], "%A")
      lab
    },
  ) +
  scale_x_continuous(limits = c(0.95, 1.05)) +
  scale_color_manual(values = c("positive" = "green", "negative" = "red", "neutral" = "blue")) +
  labs(
    title = "Timeline of the Mannheim Attack",
    subtitle = "Tweets between May 30th-June 2nd",
    x = NULL,
    y = ""
  ) +
  theme_minimal() +
  theme(
    axis.text.x       = element_blank(),
    axis.ticks.x      = element_blank(),
    axis.line.x       = element_blank(),
    panel.grid.minor.x= element_blank(),
    panel.grid.major.x = element_blank(),
    axis.title.y = element_blank(),
    legend.title = element_blank(),
    text = element_text(family = "Century Gothic", size= 10)
  ) +
  annotate(
    "segment",
    x = 1.015,           y = annotation_time - 30000,  # from the dot in the swarm
    xend = 1,     yend =annotation_time,
    arrow = arrow(length = unit(0.15, "cm"))
  ) +
  annotate(
    "text",
    x = 1.015,
    y = annotation_time -30000,
    label ="    11:34: A man ambushes and stabs 7 people at
                a BPE rally, an anti-Islam group.",
    hjust = 0,
    size= 2,
    family = "Century Gothic",
    fontface ="bold"
  ) +
  annotate(
    "segment",
    x = 1.02,           y = annotation_time_2 - 30000,  # from the dot in the swarm
    xend = 1,     yend =annotation_time_2,
    arrow = arrow(length = unit(0.15, "cm"))
  ) +
  annotate(
    "text",
    x = 1.02,
    y = annotation_time_2 - 30000,
    label ="    18:30: Police officer Rouven Laur injured,
                during the knife attack dies.",
    hjust = 0,
    size= 2,
    family = "Century Gothic",
    fontface ="bold"
  )
plot(p3)

#6 save the graph for better visibility and quality
ggsave("Final_Mannheim.png", width=8, height=20, dpi=320)



