# Do215 Event Market Web Scraping

## Project Overview

This project uses web scraping to explore the event market in Philadelphia through publicly available data from [Do215](https://do215.com/).

The main question is:

> **What can Do215 event listings tell us about the timing, composition, and user interest of events in Philadelphia?**

The project focuses on two related datasets:

1. **Daily event listings for September 14–20, 2026**
   - Used to examine the volume and composition of events across the week.
   - Used to compare weekdays and weekends.

2. **Do215 Top Picks**
   - All 13 available pages were scraped.
   - Used to examine user interaction with featured events.
   - Includes event characteristics such as category, venue, date/time, upvotes, and reported attendee counts.

The analysis is descriptive. It identifies patterns in the data and provides market signals that may help event organizers think about scheduling, competition, and event type.

## Repository Structure

```text
webscraping/
├── code/
│   ├── R scripts for scraping, cleaning, and analysis
│
├── data/
│   ├── raw/
│   │   └── events/
│   │       ├── Upcoming Events/
│   │       └── Top Picks/
│   └── cleaned/
│
├── results/
│   └── generated figures and analysis outputs
│
├── README.md
└── webscraping.Rproj
