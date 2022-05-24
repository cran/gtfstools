## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- message = FALSE---------------------------------------------------------
library(gtfstools)
library(ggplot2)

## -----------------------------------------------------------------------------
path <- system.file("extdata/spo_gtfs.zip", package = "gtfstools")
gtfs <- read_gtfs(path)
utils::object.size(gtfs)

head(gtfs$trips[, .(trip_id, trip_headsign, shape_id)])

# keeping trips CPTM L07-0 and CPTM L07-1
smaller_gtfs <- filter_by_trip_id(gtfs, c("CPTM L07-0", "CPTM L07-1"))
utils::object.size(smaller_gtfs)

head(smaller_gtfs$trips[, .(trip_id, trip_headsign, shape_id)])

unique(smaller_gtfs$shapes$shape_id)

## -----------------------------------------------------------------------------
# dropping trips CPTM L07-0 and CPTM L07-1
smaller_gtfs <- filter_by_trip_id(
    gtfs,
    c("CPTM L07-0", "CPTM L07-1"),
    keep = FALSE
)
utils::object.size(smaller_gtfs)

head(smaller_gtfs$trips[, .(trip_id, trip_headsign, shape_id)])

head(unique(smaller_gtfs$shapes$shape_id))

## -----------------------------------------------------------------------------
# keeping entries related to services than run on saturdays AND sundays
smaller_gtfs <- filter_by_weekday(
  gtfs,
  weekday = c("saturday", "sunday"),
  combine = "and"
)
smaller_gtfs$calendar[, c("service_id", "sunday", "saturday")]

# keeping entries related to services than run EITHER on saturdays OR on sundays
smaller_gtfs <- filter_by_weekday(
  gtfs,
  weekday = c("sunday", "saturday"),
  combine = "or"
)
smaller_gtfs$calendar[, c("service_id", "sunday", "saturday")]

# dropping entries related to services that run on saturdaus AND sundays
smaller_gtfs <- filter_by_weekday(
  gtfs,
  weekday = c("saturday", "sunday"),
  combine = "and",
  keep = FALSE
)
smaller_gtfs$calendar[, c("service_id", "sunday", "saturday")]

# dropping entries related to services than run EITHER on saturdays OR on
# sundays
smaller_gtfs <- filter_by_weekday(
  gtfs,
  weekday = c("sunday", "saturday"),
  combine = "or",
  keep = FALSE
)
smaller_gtfs$calendar[, c("service_id", "sunday", "saturday")]

## -----------------------------------------------------------------------------
smaller_gtfs <- filter_by_time_of_day(gtfs, from = "05:00:00", to = "06:00:00")

head(smaller_gtfs$frequencies)

# stop_times entries are preserved because they should be interpreted as
# "templates"
head(smaller_gtfs$stop_times[, c("trip_id", "departure_time", "arrival_time")])

# had the feed not had a frequencies table, the stop_times table would be
# adjusted
frequencies <- gtfs$frequencies
gtfs$frequencies <- NULL
smaller_gtfs <- filter_by_time_of_day(gtfs, from = "05:00:00", to = "06:00:00")

head(smaller_gtfs$stop_times[, c("trip_id", "departure_time", "arrival_time")])

## -----------------------------------------------------------------------------
smaller_gtfs <- filter_by_time_of_day(
    gtfs,
    "05:00:00",
    "06:00:00",
    full_trips = TRUE
)

# CPTM L07-0 trip is kept intact because it crosses the time block
head(smaller_gtfs$stop_times[, c("trip_id", "departure_time", "arrival_time")])

# dropping entries related to trips that cross the specified time block
smaller_gtfs <- filter_by_time_of_day(
    gtfs,
    "05:00:00",
    "06:00:00",
    full_trips = TRUE,
    keep = FALSE
)

# CPTM L07-0 trip is gone
head(smaller_gtfs$stop_times[, c("trip_id", "departure_time", "arrival_time")])

## -----------------------------------------------------------------------------
plotter <- function(gtfs,
                    geom,
                    spatial_operation = sf::st_intersects,
                    keep = TRUE,
                    do_filter = TRUE) {
  if (do_filter) {
    gtfs <- filter_by_sf(gtfs, geom, spatial_operation, keep)
  }

  shapes <- convert_shapes_to_sf(gtfs)
  trips <- get_trip_geometry(gtfs, file = "stop_times")
  geom <- sf::st_as_sfc(geom)

  ggplot() +
    geom_sf(data = trips) +
    geom_sf(data = shapes) +
    geom_sf(data = geom, fill = NA)
}

## -----------------------------------------------------------------------------
bbox <- sf::st_bbox(convert_shapes_to_sf(gtfs, shape_id = "68962"))

plotter(gtfs, bbox, do_filter = FALSE)

## -----------------------------------------------------------------------------
plotter(gtfs, bbox)

## -----------------------------------------------------------------------------
plotter(gtfs, bbox, keep = FALSE)

## -----------------------------------------------------------------------------
plotter(gtfs, bbox, spatial_operation = sf::st_contains)

## -----------------------------------------------------------------------------
plotter(gtfs, bbox, spatial_operation = sf::st_contains, keep = FALSE)

