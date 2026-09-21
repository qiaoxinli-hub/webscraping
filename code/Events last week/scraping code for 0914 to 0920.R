library(rvest)
library(tidyverse)
library(here)

# -----------------------------------------
# Do215 Events: September 20, 2026
# -----------------------------------------

# 6 pages of events in Philadelphia on Sep 20
base_url <- "https://do215.com/events/"

page_urls <- c(
  base_url,
  paste0(
    base_url,
    "?page=",
    2:6
  )
)

# Quick check
page_urls


# Prepare a list to store data scraped from all 6 pages
all_pages <- vector(
  "list",
  length(page_urls)
)


# Loop through all pages
for (i in seq_along(page_urls)) {
  
  message(
    "Scraping page ",
    i,
    " of ",
    length(page_urls)
  )
  
  
  # Read the page
  page <- read_html(
    page_urls[i]
  )
  
  
  # Find all event cards
  event_nodes <- page |>
    html_elements(
      "div.ds-listing.event-card"
    )
  
  
  # Count how many events are listed on this page
  message(
    "  Events found: ",
    length(event_nodes)
  )
  
  
  # Extract event names
  titles <- event_nodes |>
    html_element(
      ".ds-listing-event-title-text"
    ) |>
    html_text2()
  
  
  # Extract event venues
  venues <- event_nodes |>
    html_element(
      ".ds-venue-name [itemprop='name']"
    ) |>
    html_text2()
  
  
  # Extract event start time
  start_datetime <- event_nodes |>
    html_element(
      "meta[itemprop='startDate']"
    ) |>
    html_attr(
      "datetime"
    )
  
  
  # Extract event categories
  category_raw <- event_nodes |>
    html_attr(
      "class"
    ) |>
    str_extract(
      "ds-event-category-[^ ]+"
    ) |>
    str_remove(
      "ds-event-category-"
    )
  
  
  # Extract event URLs
  # This will be useful later when we analyze Top Picks
  event_urls <- event_nodes |>
    html_element(
      "a[itemprop='url']"
    ) |>
    html_attr(
      "href"
    ) |>
    url_absolute(
      page_urls[i]
    )
  
  
  # Construct a tibble for this page
  page_data <- tibble(
    source_date = "2026-09-20",
    source_page = page_urls[i],
    page_number = i,
    title = titles,
    venue = venues,
    start_datetime = start_datetime,
    category_raw = category_raw,
    event_url = event_urls
  )
  
  
  # Store this page's data in the list
  all_pages[[i]] <- page_data
  
  
  # Pause between requests
  Sys.sleep(1)
}


# Combine data from all 6 pages
events_0920_raw <- bind_rows(
  all_pages
)


# -----------------------------------------
# Review the raw dataset
# -----------------------------------------

dim(events_0920_raw)

head(events_0920_raw)

View(events_0920_raw)


# Check the number of events by raw category
events_0920_raw |>
  count(
    category_raw,
    sort = TRUE
  )



# Check whether event URLs are duplicated
events_0920_raw |>
  count(
    event_url,
    sort = TRUE
  ) |>
  filter(
    n > 1
  )


# -----------------------------------------
# Save the raw data
# -----------------------------------------

RAW_DIR <- here(
  "data",
  "raw",
  "events"
)

dir.create(
  RAW_DIR,
  recursive = TRUE,
  showWarnings = FALSE
)


output_file <- here(
  "data",
  "raw",
  "events",
  "do215_events_2026-09-20_raw.csv"
)


write_csv(
  events_0920_raw,
  output_file
)

output_file

# -----------------------------------------
# Do215 Events: September 19, 2026
# -----------------------------------------

# 11 pages of events in Philadelphia on Sep 19
base_url <- "https://do215.com/events/2026/09/19"

page_urls <- c(
  base_url,
  paste0(
    base_url,
    "?page=",
    2:11
  )
)

# Quick check
page_urls


# Prepare a list to store data scraped from all 11 pages
all_pages <- vector(
  "list",
  length(page_urls)
)


# Loop through all pages
for (i in seq_along(page_urls)) {
  
  message(
    "Scraping page ",
    i,
    " of ",
    length(page_urls)
  )
  
  
  # Read the page
  page <- read_html(
    page_urls[i]
  )
  
  
  # Find all event cards
  event_nodes <- page |>
    html_elements(
      "div.ds-listing.event-card"
    )
  
  
  # Count how many events are listed on this page
  message(
    "  Events found: ",
    length(event_nodes)
  )
  
  
  # Extract event names
  titles <- event_nodes |>
    html_element(
      ".ds-listing-event-title-text"
    ) |>
    html_text2()
  
  
  # Extract event venues
  venues <- event_nodes |>
    html_element(
      ".ds-venue-name [itemprop='name']"
    ) |>
    html_text2()
  
  
  # Extract event start time
  start_datetime <- event_nodes |>
    html_element(
      "meta[itemprop='startDate']"
    ) |>
    html_attr(
      "datetime"
    )
  
  
  # Extract event categories
  category_raw <- event_nodes |>
    html_attr(
      "class"
    ) |>
    str_extract(
      "ds-event-category-[^ ]+"
    ) |>
    str_remove(
      "ds-event-category-"
    )
  
  
  # Extract event URLs
  # This will be useful later when we analyze Top Picks
  event_urls <- event_nodes |>
    html_element(
      "a[itemprop='url']"
    ) |>
    html_attr(
      "href"
    ) |>
    url_absolute(
      page_urls[i]
    )
  
  
  # Construct a tibble for this page
  page_data <- tibble(
    source_date = "2026-09-19",
    source_page = page_urls[i],
    page_number = i,
    title = titles,
    venue = venues,
    start_datetime = start_datetime,
    category_raw = category_raw,
    event_url = event_urls
  )
  
  
  # Store this page's data in the list
  all_pages[[i]] <- page_data
  
  
  # Pause between requests
  Sys.sleep(1)
}


# Combine data from all 11 pages
events_0919_raw <- bind_rows(
  all_pages
)


# -----------------------------------------
# Review the raw dataset
# -----------------------------------------

dim(events_0919_raw)

head(events_0919_raw)

View(events_0919_raw)


# Check the number of events by raw category
events_0919_raw |>
  count(
    category_raw,
    sort = TRUE
  )



# Check whether event URLs are duplicated
events_0919_raw |>
  count(
    event_url,
    sort = TRUE
  ) |>
  filter(
    n > 1
  )


# -----------------------------------------
# Save the raw data
# -----------------------------------------

RAW_DIR <- here(
  "data",
  "raw",
  "events"
)

dir.create(
  RAW_DIR,
  recursive = TRUE,
  showWarnings = FALSE
)


output_file <- here(
  "data",
  "raw",
  "events",
  "do215_events_2026-09-19_raw.csv"
)


write_csv(
  events_0919_raw,
  output_file
)

output_file

# -----------------------------------------
# Do215 Events: September 18, 2026
# -----------------------------------------

# 7 pages of events in Philadelphia on Sep 19
base_url <- "https://do215.com/events/2026/09/18"

page_urls <- c(
  base_url,
  paste0(
    base_url,
    "?page=",
    2:7
  )
)

# Quick check
page_urls


# Prepare a list to store data scraped from all 7 pages
all_pages <- vector(
  "list",
  length(page_urls)
)


# Loop through all pages
for (i in seq_along(page_urls)) {
  
  message(
    "Scraping page ",
    i,
    " of ",
    length(page_urls)
  )
  
  
  # Read the page
  page <- read_html(
    page_urls[i]
  )
  
  
  # Find all event cards
  event_nodes <- page |>
    html_elements(
      "div.ds-listing.event-card"
    )
  
  
  # Count how many events are listed on this page
  message(
    "  Events found: ",
    length(event_nodes)
  )
  
  
  # Extract event names
  titles <- event_nodes |>
    html_element(
      ".ds-listing-event-title-text"
    ) |>
    html_text2()
  
  
  # Extract event venues
  venues <- event_nodes |>
    html_element(
      ".ds-venue-name [itemprop='name']"
    ) |>
    html_text2()
  
  
  # Extract event start time
  start_datetime <- event_nodes |>
    html_element(
      "meta[itemprop='startDate']"
    ) |>
    html_attr(
      "datetime"
    )
  
  
  # Extract event categories
  category_raw <- event_nodes |>
    html_attr(
      "class"
    ) |>
    str_extract(
      "ds-event-category-[^ ]+"
    ) |>
    str_remove(
      "ds-event-category-"
    )
  
  
  # Extract event URLs
  # This will be useful later when we analyze Top Picks
  event_urls <- event_nodes |>
    html_element(
      "a[itemprop='url']"
    ) |>
    html_attr(
      "href"
    ) |>
    url_absolute(
      page_urls[i]
    )
  
  
  # Construct a tibble for this page
  page_data <- tibble(
    source_date = "2026-09-18",
    source_page = page_urls[i],
    page_number = i,
    title = titles,
    venue = venues,
    start_datetime = start_datetime,
    category_raw = category_raw,
    event_url = event_urls
  )
  
  
  # Store this page's data in the list
  all_pages[[i]] <- page_data
  
  
  # Pause between requests
  Sys.sleep(1)
}


# Combine data from all 11 pages
events_0918_raw <- bind_rows(
  all_pages
)


# -----------------------------------------
# Review the raw dataset
# -----------------------------------------

dim(events_0918_raw)

head(events_0918_raw)

View(events_0918_raw)


# Check the number of events by raw category
events_0918_raw |>
  count(
    category_raw,
    sort = TRUE
  )



# Check whether event URLs are duplicated
events_0918_raw |>
  count(
    event_url,
    sort = TRUE
  ) |>
  filter(
    n > 1
  )


# -----------------------------------------
# Save the raw data
# -----------------------------------------

RAW_DIR <- here(
  "data",
  "raw",
  "events"
)

dir.create(
  RAW_DIR,
  recursive = TRUE,
  showWarnings = FALSE
)


output_file <- here(
  "data",
  "raw",
  "events",
  "do215_events_2026-09-18_raw.csv"
)


write_csv(
  events_0918_raw,
  output_file
)

output_file

# -----------------------------------------
# Do215 Events: September 17, 2026
# -----------------------------------------

# 7 pages of events in Philadelphia on Sep 17
base_url <- "https://do215.com/events/2026/09/17"

page_urls <- c(
  base_url,
  paste0(
    base_url,
    "?page=",
    2:7
  )
)

# Quick check
page_urls


# Prepare a list to store data scraped from all 7 pages
all_pages <- vector(
  "list",
  length(page_urls)
)


# Loop through all pages
for (i in seq_along(page_urls)) {
  
  message(
    "Scraping page ",
    i,
    " of ",
    length(page_urls)
  )
  
  
  # Read the page
  page <- read_html(
    page_urls[i]
  )
  
  
  # Find all event cards
  event_nodes <- page |>
    html_elements(
      "div.ds-listing.event-card"
    )
  
  
  # Count how many events are listed on this page
  message(
    "  Events found: ",
    length(event_nodes)
  )
  
  
  # Extract event names
  titles <- event_nodes |>
    html_element(
      ".ds-listing-event-title-text"
    ) |>
    html_text2()
  
  
  # Extract event venues
  venues <- event_nodes |>
    html_element(
      ".ds-venue-name [itemprop='name']"
    ) |>
    html_text2()
  
  
  # Extract event start time
  start_datetime <- event_nodes |>
    html_element(
      "meta[itemprop='startDate']"
    ) |>
    html_attr(
      "datetime"
    )
  
  
  # Extract event categories
  category_raw <- event_nodes |>
    html_attr(
      "class"
    ) |>
    str_extract(
      "ds-event-category-[^ ]+"
    ) |>
    str_remove(
      "ds-event-category-"
    )
  
  
  # Extract event URLs
  # This will be useful later when we analyze Top Picks
  event_urls <- event_nodes |>
    html_element(
      "a[itemprop='url']"
    ) |>
    html_attr(
      "href"
    ) |>
    url_absolute(
      page_urls[i]
    )
  
  
  # Construct a tibble for this page
  page_data <- tibble(
    source_date = "2026-09-17",
    source_page = page_urls[i],
    page_number = i,
    title = titles,
    venue = venues,
    start_datetime = start_datetime,
    category_raw = category_raw,
    event_url = event_urls
  )
  
  
  # Store this page's data in the list
  all_pages[[i]] <- page_data
  
  
  # Pause between requests
  Sys.sleep(1)
}


# Combine data from all 7 pages
events_0917_raw <- bind_rows(
  all_pages
)


# -----------------------------------------
# Review the raw dataset
# -----------------------------------------

dim(events_0917_raw)

head(events_0917_raw)

View(events_0917_raw)


# Check the number of events by raw category
events_0917_raw |>
  count(
    category_raw,
    sort = TRUE
  )



# Check whether event URLs are duplicated
events_0917_raw |>
  count(
    event_url,
    sort = TRUE
  ) |>
  filter(
    n > 1
  )


# -----------------------------------------
# Save the raw data
# -----------------------------------------

RAW_DIR <- here(
  "data",
  "raw",
  "events"
)

dir.create(
  RAW_DIR,
  recursive = TRUE,
  showWarnings = FALSE
)


output_file <- here(
  "data",
  "raw",
  "events",
  "do215_events_2026-09-17_raw.csv"
)


write_csv(
  events_0917_raw,
  output_file
)

output_file

# -----------------------------------------
# Do215 Events: September 16, 2026
# -----------------------------------------

# 5 pages of events in Philadelphia on Sep 16
base_url <- "https://do215.com/events/2026/09/16"

page_urls <- c(
  base_url,
  paste0(
    base_url,
    "?page=",
    2:5
  )
)

# Quick check
page_urls


# Prepare a list to store data scraped from all 5 pages
all_pages <- vector(
  "list",
  length(page_urls)
)


# Loop through all pages
for (i in seq_along(page_urls)) {
  
  message(
    "Scraping page ",
    i,
    " of ",
    length(page_urls)
  )
  
  
  # Read the page
  page <- read_html(
    page_urls[i]
  )
  
  
  # Find all event cards
  event_nodes <- page |>
    html_elements(
      "div.ds-listing.event-card"
    )
  
  
  # Count how many events are listed on this page
  message(
    "  Events found: ",
    length(event_nodes)
  )
  
  
  # Extract event names
  titles <- event_nodes |>
    html_element(
      ".ds-listing-event-title-text"
    ) |>
    html_text2()
  
  
  # Extract event venues
  venues <- event_nodes |>
    html_element(
      ".ds-venue-name [itemprop='name']"
    ) |>
    html_text2()
  
  
  # Extract event start time
  start_datetime <- event_nodes |>
    html_element(
      "meta[itemprop='startDate']"
    ) |>
    html_attr(
      "datetime"
    )
  
  
  # Extract event categories
  category_raw <- event_nodes |>
    html_attr(
      "class"
    ) |>
    str_extract(
      "ds-event-category-[^ ]+"
    ) |>
    str_remove(
      "ds-event-category-"
    )
  
  
  # Extract event URLs
  # This will be useful later when we analyze Top Picks
  event_urls <- event_nodes |>
    html_element(
      "a[itemprop='url']"
    ) |>
    html_attr(
      "href"
    ) |>
    url_absolute(
      page_urls[i]
    )
  
  
  # Construct a tibble for this page
  page_data <- tibble(
    source_date = "2026-09-16",
    source_page = page_urls[i],
    page_number = i,
    title = titles,
    venue = venues,
    start_datetime = start_datetime,
    category_raw = category_raw,
    event_url = event_urls
  )
  
  
  # Store this page's data in the list
  all_pages[[i]] <- page_data
  
  
  # Pause between requests
  Sys.sleep(1)
}


# Combine data from all 5 pages
events_0916_raw <- bind_rows(
  all_pages
)


# -----------------------------------------
# Review the raw dataset
# -----------------------------------------

dim(events_0916_raw)

head(events_0916_raw)

View(events_0916_raw)


# Check the number of events by raw category
events_0916_raw |>
  count(
    category_raw,
    sort = TRUE
  )



# Check whether event URLs are duplicated
events_0916_raw |>
  count(
    event_url,
    sort = TRUE
  ) |>
  filter(
    n > 1
  )


# -----------------------------------------
# Save the raw data
# -----------------------------------------

RAW_DIR <- here(
  "data",
  "raw",
  "events"
)

dir.create(
  RAW_DIR,
  recursive = TRUE,
  showWarnings = FALSE
)


output_file <- here(
  "data",
  "raw",
  "events",
  "do215_events_2026-09-16_raw.csv"
)


write_csv(
  events_0916_raw,
  output_file
)

output_file

# -----------------------------------------
# Do215 Events: September 15, 2026
# -----------------------------------------

# 4 pages of events in Philadelphia on Sep 15
base_url <- "https://do215.com/events/2026/09/15"

page_urls <- c(
  base_url,
  paste0(
    base_url,
    "?page=",
    2:4
  )
)

# Quick check
page_urls


# Prepare a list to store data scraped from all 4 pages
all_pages <- vector(
  "list",
  length(page_urls)
)


# Loop through all pages
for (i in seq_along(page_urls)) {
  
  message(
    "Scraping page ",
    i,
    " of ",
    length(page_urls)
  )
  
  
  # Read the page
  page <- read_html(
    page_urls[i]
  )
  
  
  # Find all event cards
  event_nodes <- page |>
    html_elements(
      "div.ds-listing.event-card"
    )
  
  
  # Count how many events are listed on this page
  message(
    "  Events found: ",
    length(event_nodes)
  )
  
  
  # Extract event names
  titles <- event_nodes |>
    html_element(
      ".ds-listing-event-title-text"
    ) |>
    html_text2()
  
  
  # Extract event venues
  venues <- event_nodes |>
    html_element(
      ".ds-venue-name [itemprop='name']"
    ) |>
    html_text2()
  
  
  # Extract event start time
  start_datetime <- event_nodes |>
    html_element(
      "meta[itemprop='startDate']"
    ) |>
    html_attr(
      "datetime"
    )
  
  
  # Extract event categories
  category_raw <- event_nodes |>
    html_attr(
      "class"
    ) |>
    str_extract(
      "ds-event-category-[^ ]+"
    ) |>
    str_remove(
      "ds-event-category-"
    )
  
  
  # Extract event URLs
  # This will be useful later when we analyze Top Picks
  event_urls <- event_nodes |>
    html_element(
      "a[itemprop='url']"
    ) |>
    html_attr(
      "href"
    ) |>
    url_absolute(
      page_urls[i]
    )
  
  
  # Construct a tibble for this page
  page_data <- tibble(
    source_date = "2026-09-15",
    source_page = page_urls[i],
    page_number = i,
    title = titles,
    venue = venues,
    start_datetime = start_datetime,
    category_raw = category_raw,
    event_url = event_urls
  )
  
  
  # Store this page's data in the list
  all_pages[[i]] <- page_data
  
  
  # Pause between requests
  Sys.sleep(1)
}


# Combine data from all 4 pages
events_0915_raw <- bind_rows(
  all_pages
)


# -----------------------------------------
# Review the raw dataset
# -----------------------------------------

dim(events_0915_raw)

head(events_0915_raw)

View(events_0915_raw)


# Check the number of events by raw category
events_0915_raw |>
  count(
    category_raw,
    sort = TRUE
  )



# Check whether event URLs are duplicated
events_0915_raw |>
  count(
    event_url,
    sort = TRUE
  ) |>
  filter(
    n > 1
  )


# -----------------------------------------
# Save the raw data
# -----------------------------------------

RAW_DIR <- here(
  "data",
  "raw",
  "events"
)

dir.create(
  RAW_DIR,
  recursive = TRUE,
  showWarnings = FALSE
)


output_file <- here(
  "data",
  "raw",
  "events",
  "do215_events_2026-09-15_raw.csv"
)


write_csv(
  events_0915_raw,
  output_file
)

output_file

# -----------------------------------------
# Do215 Events: September 14, 2026
# -----------------------------------------

# 3 pages of events in Philadelphia on Sep 14
base_url <- "https://do215.com/events/2026/09/14"

page_urls <- c(
  base_url,
  paste0(
    base_url,
    "?page=",
    2:3
  )
)

# Quick check
page_urls


# Prepare a list to store data scraped from all 3 pages
all_pages <- vector(
  "list",
  length(page_urls)
)


# Loop through all pages
for (i in seq_along(page_urls)) {
  
  message(
    "Scraping page ",
    i,
    " of ",
    length(page_urls)
  )
  
  
  # Read the page
  page <- read_html(
    page_urls[i]
  )
  
  
  # Find all event cards
  event_nodes <- page |>
    html_elements(
      "div.ds-listing.event-card"
    )
  
  
  # Count how many events are listed on this page
  message(
    "  Events found: ",
    length(event_nodes)
  )
  
  
  # Extract event names
  titles <- event_nodes |>
    html_element(
      ".ds-listing-event-title-text"
    ) |>
    html_text2()
  
  
  # Extract event venues
  venues <- event_nodes |>
    html_element(
      ".ds-venue-name [itemprop='name']"
    ) |>
    html_text2()
  
  
  # Extract event start time
  start_datetime <- event_nodes |>
    html_element(
      "meta[itemprop='startDate']"
    ) |>
    html_attr(
      "datetime"
    )
  
  
  # Extract event categories
  category_raw <- event_nodes |>
    html_attr(
      "class"
    ) |>
    str_extract(
      "ds-event-category-[^ ]+"
    ) |>
    str_remove(
      "ds-event-category-"
    )
  
  
  # Extract event URLs
  # This will be useful later when we analyze Top Picks
  event_urls <- event_nodes |>
    html_element(
      "a[itemprop='url']"
    ) |>
    html_attr(
      "href"
    ) |>
    url_absolute(
      page_urls[i]
    )
  
  
  # Construct a tibble for this page
  page_data <- tibble(
    source_date = "2026-09-14",
    source_page = page_urls[i],
    page_number = i,
    title = titles,
    venue = venues,
    start_datetime = start_datetime,
    category_raw = category_raw,
    event_url = event_urls
  )
  
  
  # Store this page's data in the list
  all_pages[[i]] <- page_data
  
  
  # Pause between requests
  Sys.sleep(1)
}


# Combine data from all 3 pages
events_0914_raw <- bind_rows(
  all_pages
)


# -----------------------------------------
# Review the raw dataset
# -----------------------------------------

dim(events_0914_raw)

head(events_0914_raw)

View(events_0914_raw)


# Check the number of events by raw category
events_0914_raw |>
  count(
    category_raw,
    sort = TRUE
  )



# Check whether event URLs are duplicated
events_0914_raw |>
  count(
    event_url,
    sort = TRUE
  ) |>
  filter(
    n > 1
  )


# -----------------------------------------
# Save the raw data
# -----------------------------------------

RAW_DIR <- here(
  "data",
  "raw",
  "events"
)

dir.create(
  RAW_DIR,
  recursive = TRUE,
  showWarnings = FALSE
)


output_file <- here(
  "data",
  "raw",
  "events",
  "do215_events_2026-09-14_raw.csv"
)


write_csv(
  events_0914_raw,
  output_file
)

output_file
