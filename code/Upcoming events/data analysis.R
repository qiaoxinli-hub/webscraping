library(tidyverse)
library(lubridate)

do215_events <- read_csv(
  "data/raw/events/Upcoming Events/do215_top_picks.csv",
  show_col_types = FALSE
)

view(do215_events)
dim(do215_events)
names(do215_events)

do215_events <- do215_events %>%
  mutate(
    event_name = str_squish(event_name),
    category = str_squish(category),
    byline = str_squish(byline),
    venue = str_squish(venue),
    city = str_squish(city),
    state = str_squish(state),
    zip_code = str_squish(zip_code),
    event_time = str_squish(event_time),
    series_info = str_squish(series_info),
    extra_text = str_squish(extra_text)
  )

do215_events <- do215_events %>%
  mutate(
    attendees = as.numeric(attendees),
    upvotes = as.numeric(upvotes),
    event_id = as.character(event_id)
  )

#check if there is any missing value
missing_summary <- do215_events %>%
  summarise(
    across(
      everything(),
      ~ sum(is.na(.))
    )
  ) %>%
  pivot_longer(
    everything(),
    names_to = "variable",
    values_to = "missing"
  ) %>%
  arrange(desc(missing))

missing_summary

#check if there is any duplicated data
duplicate_events <- do215_events %>%
  count(event_id, sort = TRUE) %>%
  filter(!is.na(event_id), n > 1)
duplicate_events

do215_events <- do215_events %>%
  distinct(event_id, .keep_all = TRUE)

#find the most popular upcoming events
top_10_events <- do215_events %>%
  arrange(desc(upvotes)) %>%
  select(
    event_name,
    category,
    venue,
    event_time,
    attendees,
    upvotes,
    is_free
  ) %>%
  slice_head(n = 10)

top_10_events

#analyze the category distribution
category_summary <- do215_events %>%
  group_by(category) %>%
  summarise(
    n_events = n(),
    total_upvotes = sum(upvotes, na.rm = TRUE),
    total_attendees = sum(attendees, na.rm = TRUE),
    avg_upvotes = mean(upvotes, na.rm = TRUE),
    avg_attendees = mean(attendees, na.rm = TRUE),
    median_upvotes = median(upvotes, na.rm = TRUE),
    median_attendees = median(attendees, na.rm = TRUE)
  ) %>%
  arrange(desc(total_upvotes))

category_summary

#data visualization

library(ggplot2)
library(dplyr)
library(tidyr)
library(forcats)

# Prepare data
category_plot <- category_summary %>%
  select(
    category,
    n_events,
    avg_upvotes,
    avg_attendees
  ) %>%
  pivot_longer(
    cols = c(avg_upvotes, avg_attendees),
    names_to = "measure",
    values_to = "value"
  ) %>%
  mutate(
    measure = recode(
      measure,
      avg_upvotes = "Average Upvotes",
      avg_attendees = "Average Attendees"
    ),
    category = fct_reorder(
      category,
      ifelse(
        measure == "Average Upvotes",
        value,
        NA_real_
      ),
      .fun = median,
      na.rm = TRUE
    ),
    category_label = paste0(
      str_to_title(as.character(category)),
      " (n = ", n_events, ")"
    )
  )

# Plot
ggplot(
  category_plot,
  aes(
    x = fct_reorder(
      category_label,
      value,
      .fun = median
    ),
    y = value,
    fill = measure
  )
) +
  geom_col(
    position = position_dodge(width = 0.75),
    width = 0.65
  ) +
  
  geom_text(
    aes(
      label = round(value, 1)
    ),
    position = position_dodge(width = 0.75),
    hjust = -0.15,
    size = 3.7,
    fontface = "bold"
  ) +
  
  scale_fill_manual(
    values = c(
      "Average Upvotes" = "#155A8A",
      "Average Attendees" = "#8BB8D8"
    )
  ) +
  
  coord_flip() +
  
  labs(
    title = "User Interest and Attendance by Event Category",
    subtitle = "Average upvotes and attendee counts per event",
    x = "Event Category",
    y = "Average Count",
    fill = NULL,
    caption = "Source: Do215 Top Picks"
  ) +
  
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(
      size = 18,
      face = "bold"
    ),
    plot.subtitle = element_text(
      size = 11.5,
      color = "gray40"
    ),
    plot.caption = element_text(
      size = 9,
      color = "gray50"
    ),
    axis.title = element_text(
      face = "bold"
    ),
    axis.text.y = element_text(
      size = 10.5
    ),
    legend.position = "top",
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(
      color = "gray85",
      linewidth = 0.4
    )
  )

#graph2
install.packages("ggrepel")

category_scatter <- category_summary %>%
  mutate(
    category_label = paste0(
      str_to_title(category),
      " (n = ", n_events, ")"
    ),
    log_avg_attendees = log1p(avg_attendees),
    log_avg_upvotes = log1p(avg_upvotes)
  )

ggplot(
  category_scatter,
  aes(
    x = log_avg_attendees,
    y = log_avg_upvotes
  )
) +
  geom_point(
    aes(size = n_events),
    color = "#176B9A",
    alpha = 0.75
  ) +
  
  geom_text_repel(
    aes(label = category_label),
    color = "#174A6E",
    size = 3.8,
    fontface = "bold",
    box.padding = 0.6,
    point.padding = 0.5,
    force = 2,
    max.overlaps = Inf,
    min.segment.length = 0,
    segment.color = "gray60"
  ) +
  
  scale_size(
    range = c(3, 9),
    guide = "none"
  ) +
  
  labs(
    title = "User Interest vs. Attendance Across Event Categories",
    subtitle = "Average values shown on a log(1 + x) scale",
    x = "Average Attendees [log(1 + x)]",
    y = "Average Upvotes [log(1 + x)]",
    caption = "Source: Do215 Top Picks"
  ) +
  
  theme_minimal(base_size = 13) +
  
  theme(
    plot.title = element_text(
      size = 18,
      face = "bold"
    ),
    plot.subtitle = element_text(
      size = 11.5,
      color = "gray40"
    ),
    panel.grid.minor = element_blank()
  )
