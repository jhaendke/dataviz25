library(tidyverse)    
library(lubridate)  
library(ggbeeswarm)

# 1. Filter the data for the specific day of the attack and the day before
Solingen_dates <- as.Date(c("2024-08-23", "2024-08-24"))

#2 Convert Created.AT to POSIXct and then filter for tweets related to Solingen
Final_Solingen_specific <- df %>%
  mutate(Created.At = as.POSIXct(Created.At, format = "%a %b %d %H:%M:%S %z %Y")) %>%
  filter(as.Date(Created.At) %in% Solingen_dates) %>%
  filter(str_detect(Text, regex("Solingen", ignore_case = TRUE)))

# 3. Define the overall time range and create breaks every 3 hours for better visibility
start_time <- as.POSIXct("2024-08-23 18:00:00", tz = "UTC")
end_time <- as.POSIXct("2024-08-25 00:00:00", tz = "UTC")


breaks_seq <- seq(from = start_time, to = end_time, by = "3 hours")
breaks_seq_num <- as.numeric(breaks_seq)

# 4. define limits for plotting the y-axis
min_y <- as.POSIXct(min(Final_Solingen_specific$Created.At), unit= "day")

# 5. create a variable for annotating the plot at a specific time
annotation_time <- as.numeric(as.POSIXct("2024-08-23 21:37:00", tz = "UTC"))

# 6. Plot the graph
p <- ggplot(
  Final_Solingen_specific,
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
    title = "Timeline of the Solingen Attacks",
    subtitle = "Tweets between August 23rd-24th",
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
    text = element_text(family = "Century Gothic", size =10)
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
    label ="    21:37: on the Fronhof, in front of one of the three stages of 
    the Solingen City Festival, listeners were randomly attacked",
    hjust = 0,
    size= 1.5,
    family = "Century Gothic",
    fontface ="bold"
  )

print(p)

#7 save the plot in a format which allows for optimal visibility
ggsave("Final_Solingen.png", width=8, height=20, dpi=320)


