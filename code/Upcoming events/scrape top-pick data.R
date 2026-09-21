library(rvest)
library(dplyr)
library(stringr)
library(readr)
library(lubridate)
library(tibble)


# ---------------------------------------------------------
# 1. Set up URLs
# ---------------------------------------------------------

base_url <- "https://do215.com/top-picks"

n_pages <- 13

all_events <- list()


# ---------------------------------------------------------
# 2. Scrape one page
# ---------------------------------------------------------

scrape_page <- function(page_number) {
  
  # Page 1
  if (page_number == 1) {
    url <- base_url
  } else {
    url <- paste0(base_url, "?page=", page_number)
  }
  
  cat("Scraping page", page_number, ":", url, "\n")
  
  
  # Read HTML
  page <- tryCatch(
    read_html(url),
    error = function(e) {
      message("Failed to read page ", page_number)
      return(NULL)
    }
  )
  
  if (is.null(page)) {
    return(tibble())
  }
  
  
  # Find event cards
  cards <- html_elements(
    page,
    "div.ds-listing.event-card"
  )
  
  cat("Number of event cards:", length(cards), "\n")
  
  if (length(cards) == 0) {
    message("No event cards found on page ", page_number)
    return(tibble())
  }
  
  
  # Extract data from each card
  page_data <- lapply(cards, function(card) {
    
    # Event name
    event_name <- card %>%
      html_element(".ds-listing-event-title-text") %>%
      html_text2()
    
    
    # Event URL
    event_url <- card %>%
      html_element(".ds-listing-event-title") %>%
      html_attr("href")
    
    
    # Byline / promoter
    byline <- card %>%
      html_element(".ds-byline") %>%
      html_text2()
    
    
    # Category
    card_class <- html_attr(card, "class")
    
    category <- str_extract(
      card_class,
      "ds-event-category-[^ ]+"
    )
    
    category <- str_remove(
      category,
      "ds-event-category-"
    )
    
    
    # Venue
    venue <- card %>%
      html_element(".ds-venue-name [itemprop='name']") %>%
      html_text2()
    
    
    # Venue URL
    venue_url <- card %>%
      html_element(".ds-venue-name a") %>%
      html_attr("href")
    
    
    # Street
    street <- card %>%
      html_element("[itemprop='streetAddress']") %>%
      html_attr("content")
    
    
    # City
    city <- card %>%
      html_element("[itemprop='addressLocality']") %>%
      html_attr("content")
    
    
    # State
    state <- card %>%
      html_element("[itemprop='addressRegion']") %>%
      html_attr("content")
    
    
    # ZIP code
    zip_code <- card %>%
      html_element("[itemprop='postalCode']") %>%
      html_attr("content")
    
    
    # Displayed event time
    event_time <- card %>%
      html_element(".ds-event-time") %>%
      html_text2()
    
    
    # Attendee count
    attendees_text <- card %>%
      html_element(".ds-listing-attendee-count") %>%
      html_text2()
    
    attendees <- parse_number(attendees_text)
    
    
    # Upvote count
    upvote_text <- card %>%
      html_element(".ds-upvote-default .ds-icon-text") %>%
      html_text2()
    
    upvotes <- parse_number(upvote_text)
    
    
    # Event ID
    event_id <- card %>%
      html_element(".ds-btn-container-upvote a[data-ds-id]") %>%
      html_attr("data-ds-id")
    
    event_id <- suppressWarnings(
      as.numeric(event_id)
    )
    
    
    # Banner text
    banner_text <- card %>%
      html_elements(".ds-listing-banners li") %>%
      html_text2()
    
    banner_text <- paste(
      banner_text,
      collapse = " | "
    )
    
    
    # Is free?
    is_free <- str_detect(
      str_to_lower(banner_text),
      "\\bfree\\b"
    )
    
    
    # Is recurring?
    is_series <- str_detect(
      str_to_lower(banner_text),
      "through"
    )
    
    
    # Series information
    series_info <- str_extract(
      banner_text,
      regex("Through.*", ignore_case = TRUE)
    )
    
    
    # Has a ticket button?
    has_ticket_button <- length(
      html_elements(card, ".ds-buy-tix")
    ) > 0
    
    
    # Ticket URL
    ticket_url <- card %>%
      html_element(".ds-buy-tix") %>%
      html_attr("href")
    
    
    # Extra text
    extra_text <- card %>%
      html_element(".ds-listing-extra") %>%
      html_text2()
    
    
    
    # Return one row
    tibble(
      event_name = event_name,
      category = category,
      byline = byline,
      event_url = event_url,
      venue = venue,
      venue_url = venue_url,
      street = street,
      city = city,
      state = state,
      zip_code = zip_code,
      event_time = event_time,
      attendees = attendees,
      upvotes = upvotes,
      event_id = event_id,
      is_free = is_free,
      is_series = is_series,
      series_info = series_info,
      has_ticket_button = has_ticket_button,
      ticket_url = ticket_url,
      extra_text = extra_text,
      page = page_number
    )
  })
  
  
  bind_rows(page_data)
}


# ---------------------------------------------------------
# 3. Loop through pages 1-13
# ---------------------------------------------------------

for (p in 1:n_pages) {
  
  all_events[[p]] <- scrape_page(p)
  
  # Wait between requests
  Sys.sleep(runif(1, 1.5, 3))
}


# ---------------------------------------------------------
# 4. Combine all pages
# ---------------------------------------------------------

do215_events <- bind_rows(all_events)


# ---------------------------------------------------------
# 6. Check data
# ---------------------------------------------------------

glimpse(do215_events)
nrow(do215_events)
head(do215_events)
view(do215_events)


# ---------------------------------------------------------
# 8. Check categories
# ---------------------------------------------------------

do215_events %>%
  count(
    category,
    sort = TRUE
  )


# ---------------------------------------------------------
# 9. See top events
# ---------------------------------------------------------

do215_events %>%
  arrange(desc(upvotes)) %>%
  select(
    event_name,
    category,
    venue,
    is_free,
    attendees,
    upvotes
  ) %>%
  head(10)


# ---------------------------------------------------------
# 10. Save data
# ---------------------------------------------------------

output_path <- "data/raw/events/Upcoming Events/do215_top_picks.csv"

write_csv(
  do215_events,
  output_path
)

cat("Data saved to:", output_path, "\n")