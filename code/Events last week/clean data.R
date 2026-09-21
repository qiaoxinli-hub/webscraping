library(tidyverse)
library(here)
library(lubridate)


# -----------------------------------------
# Load weekly raw data
# -----------------------------------------

events_week_raw <- read_csv(
  here(
    "data",
    "raw",
    "events",
    "do215_weekly_2026-09-14_to_2026-09-20_raw.csv"
  )
)


# -----------------------------------------
# Clean listing data
# -----------------------------------------

events_week_listing <- events_week_raw |>
  mutate(
    title = str_squish(title),
    venue = str_squish(venue),
    category_raw = str_squish(category_raw),
    source_date = as.Date(source_date),
    
    weekday_num = wday(
      source_date,
      week_start = 1
    ),
    
    weekday = wday(
      source_date,
      label = TRUE,
      abbr = TRUE,
      week_start = 1
    ),
    
    weekend = if_else(
      weekday_num >= 6,
      "Weekend",
      "Weekday"
    )
  )


# -----------------------------------------
# Adjust category names
# -----------------------------------------

events_week_listing <- events_week_listing |>
  mutate(
    category = case_when(
      
      category_raw == "music" ~
        "Live Music",
      
      category_raw == "comedy" ~
        "Comedy",
      
      category_raw == "food-drink" ~
        "Food & Drink",
      
      category_raw == "dj-parties" ~
        "DJ Parties",
      
      category_raw == "arts-culture" ~
        "Arts & Culture",
      
      category_raw == "outdoors" ~
        "Sports & Fitness",
      
      category_raw == "film" ~
        "Film",
      
      category_raw %in% c("family-kids", "arts-family") ~
        "Family & Kids",
      
      category_raw == "charity-activism" ~
        "Charity & Activism",
      
      category_raw == "trivia-open-mics-other" ~
        "Trivia, Open Mics & Other",
      
      category_raw == "theatre-performing-arts" ~
        "Theatre & Performing Arts",
      
      TRUE ~
        "Other"
    )
  )


# -----------------------------------------
# Check for missing values
# -----------------------------------------

events_week_listing |>
  summarise(
    total_rows = n(),
    missing_title = sum(is.na(title)),
    missing_venue = sum(is.na(venue)),
    missing_category = sum(is.na(category)),
    missing_url = sum(is.na(event_url)),
    missing_source_date = sum(is.na(source_date))
  )


# -----------------------------------------
# Check category mapping
# -----------------------------------------

events_week_listing |>
  count(
    category_raw,
    category,
    sort = TRUE
  )


# Check final category distribution
events_week_listing |>
  count(
    category,
    sort = TRUE
  )


# -----------------------------------------
# Calculate how many days each event
# appears on the daily Do215 pages
# -----------------------------------------

event_frequency <- events_week_listing |>
  distinct(
    event_url,
    source_date
  ) |>
  count(
    event_url,
    name = "listed_days"
  )


# -----------------------------------------
# Add listed_days back to the listing data
# -----------------------------------------

events_week_listing <- events_week_listing |>
  left_join(
    event_frequency,
    by = "event_url"
  ) |>
  mutate(
    single_day_listing = listed_days == 1
  )


# -----------------------------------------
# Check events appearing across
# multiple daily pages
# -----------------------------------------

events_week_listing |>
  filter(listed_days > 1) |>
  select(
    title,
    event_url,
    source_date,
    listed_days
  ) |>
  arrange(
    event_url,
    source_date
  )


# -----------------------------------------
# Create unique-event dataset
# One row = one event_url
# -----------------------------------------

events_week_unique <- events_week_listing |>
  arrange(
    event_url,
    source_date
  ) |>
  distinct(
    event_url,
    .keep_all = TRUE
  )


# -----------------------------------------
# Check number of listing records
# and unique events
# -----------------------------------------

nrow(events_week_listing)

nrow(events_week_unique)


# -----------------------------------------
# Daily event listing volume
# -----------------------------------------

events_week_listing |>
  count(
    source_date,
    name = "n_listings"
  )


# -----------------------------------------
# Category distribution
# -----------------------------------------

events_week_unique |>
  count(
    category,
    sort = TRUE
  )


# -----------------------------------------
# Create clean data directory
# -----------------------------------------

CLEAN_DIR <- here(
  "data",
  "clean",
  "events"
)

dir.create(
  CLEAN_DIR,
  recursive = TRUE,
  showWarnings = FALSE
)


# -----------------------------------------
# Save cleaned listing-level data
# -----------------------------------------

write_csv(
  events_week_listing,
  here(
    "data",
    "clean",
    "events",
    "do215_cleaned_weekly_events_listing.csv"
  )
)


# -----------------------------------------
# Save cleaned unique-event data
# -----------------------------------------

write_csv(
  events_week_unique,
  here(
    "data",
    "clean",
    "events",
    "do215_cleaned_weekly_events_unique.csv"
  )
)

