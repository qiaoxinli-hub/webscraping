library(tidyverse)
library(here)


# -----------------------------------------
# Load cleaned data
# -----------------------------------------

events_week_listing <- read_csv(
  here(
    "data",
    "clean",
    "events",
    "do215_cleaned_weekly_events_listing.csv"
  )
)

events_week_unique <- read_csv(
  here(
    "data",
    "clean",
    "events",
    "do215_cleaned_weekly_events_unique.csv"
  )
)


# -----------------------------------------
# Create results and figure directories
# -----------------------------------------

RESULTS_DIR <- here(
  "results"
)

FIGURES_DIR <- here(
  "results",
  "figures"
)

dir.create(
  RESULTS_DIR,
  recursive = TRUE,
  showWarnings = FALSE
)

dir.create(
  FIGURES_DIR,
  recursive = TRUE,
  showWarnings = FALSE
)


# =========================================================
# 1. DAILY EVENT LISTING VOLUME
# =========================================================

daily_events <- events_week_listing |>
  count(
    source_date,
    weekend,
    name = "n_events"
  )

p_daily <- ggplot(
  daily_events,
  aes(
    x = source_date,
    y = n_events,
    fill = weekend
  )
) +
  geom_col(
    width = 0.75
  ) +
  geom_text(
    aes(label = n_events),
    vjust = -0.4,
    size = 4
  ) +
  scale_x_date(
    breaks = daily_events$source_date,
    date_labels = "%b %d",
    expand = expansion(mult = c(0.02, 0.02))
  ) +
  scale_fill_manual(
    values = c(
      "Weekday" = "#5B8FF9",
      "Weekend" = "#F6BD16"
    )
  ) +
  scale_y_continuous(
    expand = expansion(mult = c(0, 0.08))
  ) +
  labs(
    title = "Daily Event Listings on Do215",
    subtitle = "Philadelphia events listed from September 14–20, 2026",
    x = "Date",
    y = "Number of Event Listings",
    fill = "Day Type",
    caption = "Source: Do215 daily event pages"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(size = 20, face = "bold"),
    plot.subtitle = element_text(size = 12, color = "gray40"),
    axis.text.x = element_text(size = 11),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "top"
  )

p_daily


# Save figure

ggsave(
  filename = here(
    "results",
    "figures",
    "daily_events_volume.png"
  ),
  plot = p_daily,
  width = 9,
  height = 6,
  dpi = 300
)


# =========================================================
# 2. WEEKLY EVENT CATEGORY COMPOSITION
# =========================================================

category_counts <- events_week_unique |>
  count(
    category,
    name = "n_events",
    sort = TRUE
  ) |>
  mutate(
    share = n_events / sum(n_events)
  )

category_counts


# Plot category composition

p_category <- ggplot(
  category_counts,
  aes(
    x = reorder(category, n_events),
    y = n_events,
    fill = n_events
  )
) +
  geom_col(
    width = 0.7
  ) +
  
  # Add count and percentage labels
  geom_text(
    aes(
      label = paste0(
        n_events,
        " (",
        scales::percent(
          share,
          accuracy = 0.1
        ),
        ")"
      )
    ),
    hjust = -0.1,
    size = 4
  ) +
  
  # Color gradient based on number of events
  scale_fill_gradient(
    low = "#C6DBEF",
    high = "#2171B5"
  ) +
  
  # Leave space for labels
  scale_y_continuous(
    expand = expansion(
      mult = c(0, 0.15)
    )
  ) +
  
  coord_flip() +
  
  labs(
    title = "Event Composition by Category",
    subtitle = "Unique events listed on Do215, September 14–20, 2026",
    x = NULL,
    y = "Number of Unique Events",
    caption = "Labels show the number of events and their share of all unique events.",
    fill = "Number of Events"
  ) +
  
  theme_minimal(
    base_size = 13
  ) +
  
  theme(
    plot.title = element_text(
      size = 20,
      face = "bold"
    ),
    
    plot.subtitle = element_text(
      size = 12,
      color = "gray40"
    ),
    
    axis.text.y = element_text(
      size = 11
    ),
    
    axis.text.x = element_text(
      size = 10
    ),
    
    axis.title.x = element_text(
      size = 12
    ),
    
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    
    legend.position = "none",
    
    plot.caption = element_text(
      hjust = 0,
      size = 9,
      color = "gray50"
    )
  )

p_category

# Save figure

ggsave(
  filename = here(
    FIGURES_DIR,
    "event_category_composition.png"
  ),
  plot = p_category,
  width = 10,
  height = 6.5,
  dpi = 300
)

# =========================================================
# 3. WEEKDAY VS WEEKEND
# =========================================================

# Calculate daily event listings(weekday vs weekend)
# =========================================================
# 3. WEEKDAY VS WEEKEND
# =========================================================

# Calculate average daily event listings
weekend_counts <- events_week_listing |>
  count(
    source_date,
    weekend,
    name = "n_events"
  ) |>
  group_by(weekend) |>
  summarise(
    avg_daily_events = mean(n_events),
    .groups = "drop"
  )

weekend_counts


# Plot average daily event listings

p_weekend <- ggplot(
  weekend_counts,
  aes(
    x = weekend,
    y = avg_daily_events,
    fill = weekend
  )
) +
  geom_col(
    width = 0.65
  ) +
  
  geom_text(
    aes(
      label = round(avg_daily_events, 1)
    ),
    vjust = -0.4,
    size = 5
  ) +
  
  scale_fill_manual(
    values = c(
      "Weekday" = "#5B8FF9",
      "Weekend" = "#F6BD16"
    )
  ) +
  
  scale_y_continuous(
    expand = expansion(
      mult = c(0, 0.1)
    )
  ) +
  
  labs(
    title = "Average Daily Event Listings: Weekday vs Weekend",
    subtitle = "Average number of events listed per day on Do215",
    x = NULL,
    y = "Average Daily Event Listings",
    caption = "Source: Do215 daily event pages"
  ) +
  
  theme_minimal(
    base_size = 13
  ) +
  
  theme(
    plot.title = element_text(
      size = 20,
      face = "bold"
    ),
    
    plot.subtitle = element_text(
      size = 12,
      color = "gray40"
    ),
    
    axis.text.x = element_text(
      size = 12
    ),
    
    axis.text.y = element_text(
      size = 11
    ),
    
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    
    legend.position = "none",
    
    plot.caption = element_text(
      hjust = 0,
      size = 9,
      color = "gray50"
    )
  )

p_weekend


# Save figure

ggsave(
  filename = here(
    FIGURES_DIR,
    "weekday_vs_weekend.png"
  ),
  plot = p_weekend,
  width = 8,
  height = 6,
  dpi = 300
)


# =========================================================
# 4. CATEGORY COMPOSITION BY WEEKDAY / WEEKEND
# =========================================================

weekend_category <- events_week_listing |>
  count(
    weekend,
    category,
    name = "n_events"
  ) |>
  group_by(weekend) |>
  mutate(
    share = n_events / sum(n_events)
  ) |>
  ungroup()

category_order <- weekend_category |>
  group_by(category) |>
  summarise(
    total = sum(n_events),
    .groups = "drop"
  ) |>
  arrange(total) |>
  pull(category)

weekend_category <- weekend_category |>
  mutate(
    category = factor(
      category,
      levels = category_order
    )
  )


# Plot category composition by weekday/weekend

# Plot category composition by weekday/weekend

p_weekend_category <- ggplot(
  weekend_category,
  aes(
    x = category,
    y = share,
    fill = weekend
  )
) +
  geom_col(
    position = position_dodge(width = 0.75),
    width = 0.65
  ) +
  
  geom_text(
    aes(
      label = scales::percent(
        share,
        accuracy = 1
      )
    ),
    position = position_dodge(width = 0.75),
    hjust = -0.15,
    size = 3.5
  ) +
  
  scale_fill_manual(
    values = c(
      "Weekday" = "#5B8FF9",
      "Weekend" = "#F6BD16"
    )
  ) +
  
  scale_y_continuous(
    labels = scales::label_percent(
      accuracy = 1
    ),
    expand = expansion(
      mult = c(0, 0.12)
    )
  ) +
  
  coord_flip() +
  
  labs(
    title = "How Event Categories Differ by Day Type",
    subtitle = "Share of Do215 event listings within weekdays and weekends",
    x = NULL,
    y = "Share of Event Listings",
    fill = "Day Type",
    caption = "Percentages are calculated separately within weekdays and weekends."
  ) +
  
  theme_minimal(
    base_size = 13
  ) +
  
  theme(
    plot.title = element_text(
      size = 20,
      face = "bold"
    ),
    
    plot.subtitle = element_text(
      size = 12,
      color = "gray40"
    ),
    
    axis.text.y = element_text(
      size = 10.5
    ),
    
    axis.text.x = element_text(
      size = 10
    ),
    
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    
    legend.position = "top",
    
    plot.caption = element_text(
      hjust = 0,
      size = 9,
      color = "gray50"
    )
  )

p_weekend_category

# Save figure

ggsave(
  filename = here(
    FIGURES_DIR,
    "category_weekday_vs_weekend.png"
  ),
  plot = p_weekend_category,
  width = 10,
  height = 7,
  dpi = 300
)



