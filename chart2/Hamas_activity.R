library(tidyverse)
library(lubridate)

df <- read.csv("Final_unprocessed.csv")

# 1. Define the dates
Israel_dates <- as.Date(c("2023-10-06", "2023-10-07", "2023-10-08"))

# 2. Convert Created.At to a POSIXct datetime, then filter.
Final_Israel_specific <- df %>%
  mutate(Created.At = as.POSIXct(Created.At, format = "%a %b %d %H:%M:%S %z %Y")) %>%
  filter(as.Date(Created.At) %in% Israel_dates) %>%
  filter(str_detect(Text, regex("Israel|Hamas", ignore_case = TRUE)))

#3 Define start and end times for the plot y-axis
start_time <- as.POSIXct("2023-10-06 21:00:00", tz = "UTC")
end_time   <- ceiling_date(max(Final_Israel_specific$Created.At))

#4 Establish 3-hour breaks for better visibility
breaks_seq <- seq(from = start_time, to = end_time, by = "3 hours")
breaks_seq_num <- as.numeric(breaks_seq)

#5 Include variables for plot annotations at specific times
annotation_time <- as.numeric(as.POSIXct("2023-10-07 06:56:00", tz = "UTC"))
annotation_time_2_Israel <- as.numeric(as.POSIXct("2023-10-07 10:35:00", tz="UTC"))
annotation_time_3_Israel <- as.numeric(as.POSIXct("2023-10-08 09:00:00", tz="UTC"))

#6 Plot the graph using ggplot and ggbeeswarm, with time in the y-axis
p<-Final_Israel_specific %>% ggplot(
  aes(x = 1, y = as.numeric(Created.At), color = sentiment) # set x=1 to include all tweets in a single column
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
    title = "Timeline of the Hamas Attacks",
    subtitle = "Tweets between October 6th-8th",
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
    text = element_text(family = "Century Gothic", size=10)
  ) +
  annotate(
    "segment",
    x = 1.015,           y = annotation_time,  # from the dot in the swarm
    xend = 1,     yend =annotation_time,
    arrow = arrow(length = unit(0.15, "cm"))
  ) +
  annotate(
    "text",
    x = 1.015,
    y = annotation_time,
    label ="    06:56: First militants arrive to Be’eri 
                and initiate the Be'eri massacre.",
    hjust = 0,
    size= 1.5,
    family = "Century Gothic",
    fontface ="bold"
  ) +
  annotate(
    "segment",
    x = 1.015,           y = annotation_time_2_Israel,  # from the dot in the swarm
    xend = 1,     yend =annotation_time_2_Israel,
    arrow = arrow(length = unit(0.15, "cm"))
  ) +
  annotate(
    "text",
    x = 1.025,
    y = annotation_time_2_Israel,
    label ="    10:35: Benjamin Netanyahu declares 
                that Israel is at war on X.",
    hjust = 0,
    size= 1.5,
    family = "Century Gothic",
    fontface ="bold"
  ) +
  annotate(
    "segment",
    x = 1.02,           y = annotation_time_3_Israel - 30000,  # from the dot in the swarm
    xend = 1,     yend =annotation_time_3_Israel,
    arrow = arrow(length = unit(0.15, "cm"))
  ) +
  annotate(
    "text",
    x = 1.02,
    y = annotation_time_3_Israel - 30000,
    label ="    09:00: The Israeli government ratifies the state of war
                for the first time since 1970.",
    hjust = 0,
    size= 1.5,
    family = "Century Gothic",
    fontface ="bold"
  )
plot(p)

#Save the plot for hugher quality and aspect ratio
ggsave("Final_Hamas.png", width=6, height=25, dpi=320)



