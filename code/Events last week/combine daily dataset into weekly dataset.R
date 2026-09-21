events_0914_raw <- read_csv(
  here(
    "data",
    "raw",
    "events",
    "do215_events_2026-09-14_raw.csv"
  )
)

events_0915_raw <- read_csv(
  here(
    "data",
    "raw",
    "events",
    "do215_events_2026-09-15_raw.csv"
  )
)

events_0916_raw <- read_csv(
  here(
    "data",
    "raw",
    "events",
    "do215_events_2026-09-16_raw.csv"
  )
)

events_0917_raw <- read_csv(
  here(
    "data",
    "raw",
    "events",
    "do215_events_2026-09-17_raw.csv"
  )
)

events_0918_raw <- read_csv(
  here(
    "data",
    "raw",
    "events",
    "do215_events_2026-09-18_raw.csv"
  )
)

events_0919_raw <- read_csv(
  here(
    "data",
    "raw",
    "events",
    "do215_events_2026-09-19_raw.csv"
  )
)

events_0920_raw <- read_csv(
  here(
    "data",
    "raw",
    "events",
    "do215_events_2026-09-20_raw.csv"
  )
)

events_week_raw <- bind_rows(
  events_0914_raw,
  events_0915_raw,
  events_0916_raw,
  events_0917_raw,
  events_0918_raw,
  events_0919_raw,
  events_0920_raw,
)

dim(events_week_raw)

head(events_week_raw)

events_week_raw |>
  count(
    source_date
  )

output_file <- here(
  "data",
  "raw",
  "events",
  "do215_events_2026-09-14_to_2026-09-20_raw.csv"
)

write_csv(
  events_week_raw,
  output_file
)

output_file