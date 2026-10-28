## ----include = FALSE----------------------------------------------------------
# the queries in this vignette use {dplyr}, which gtfstools only suggests
has_dplyr <- requireNamespace("dplyr", quietly = TRUE)

knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = has_dplyr
)

Sys.setenv(OMP_THREAD_LIMIT = 2)
data.table::setDTthreads(2)

library(gtfstools)

## ----message = FALSE, eval = requireNamespace("ggplot2", quietly = TRUE)------
library(gtfstools)
library(ggplot2)

## ----message = FALSE----------------------------------------------------------
library(dplyr)

## -----------------------------------------------------------------------------
path <- system.file("extdata/spo_gtfs.zip", package = "gtfstools")
gtfs <- read_gtfs(path)
utils::object.size(gtfs)

gtfs$trips |>
  select(trip_id, trip_headsign, shape_id) |>
  head()

# keeping trips CPTM L07-0 and CPTM L07-1
smaller_gtfs <- filter_by_trip_id(gtfs, c("CPTM L07-0", "CPTM L07-1"))
utils::object.size(smaller_gtfs)

smaller_gtfs$trips |>
  select(trip_id, trip_headsign, shape_id) |>
  head()

unique(smaller_gtfs$shapes$shape_id)

## -----------------------------------------------------------------------------
# dropping trips CPTM L07-0 and CPTM L07-1
smaller_gtfs <- filter_by_trip_id(
    gtfs,
    c("CPTM L07-0", "CPTM L07-1"),
    keep = FALSE
)
utils::object.size(smaller_gtfs)

smaller_gtfs$trips |>
  select(trip_id, trip_headsign, shape_id) |>
  head()

head(unique(smaller_gtfs$shapes$shape_id))

## -----------------------------------------------------------------------------
# keeping entries related to services than run on saturdays AND sundays
smaller_gtfs <- filter_by_weekday(
  gtfs,
  weekday = c("saturday", "sunday"),
  combine = "and"
)
smaller_gtfs$calendar |>
  select(service_id, sunday, saturday)

# keeping entries related to services than run EITHER on saturdays OR on sundays
smaller_gtfs <- filter_by_weekday(
  gtfs,
  weekday = c("sunday", "saturday"),
  combine = "or"
)
smaller_gtfs$calendar |>
  select(service_id, sunday, saturday)

# dropping entries related to services that run on saturdaus AND sundays
smaller_gtfs <- filter_by_weekday(
  gtfs,
  weekday = c("saturday", "sunday"),
  combine = "and",
  keep = FALSE
)
smaller_gtfs$calendar |>
  select(service_id, sunday, saturday)

# dropping entries related to services than run EITHER on saturdays OR on
# sundays
smaller_gtfs <- filter_by_weekday(
  gtfs,
  weekday = c("sunday", "saturday"),
  combine = "or",
  keep = FALSE
)
smaller_gtfs$calendar |>
  select(service_id, sunday, saturday)

## -----------------------------------------------------------------------------
smaller_gtfs <- filter_by_time_of_day(gtfs, from = "05:00:00", to = "06:00:00")

head(smaller_gtfs$frequencies)

# stop_times entries are preserved because they should be interpreted as
# "templates"
smaller_gtfs$stop_times |>
  select(trip_id, departure_time, arrival_time) |>
  head()

# had the feed not had a frequencies table, the stop_times table would be
# adjusted
frequencies <- gtfs$frequencies
gtfs$frequencies <- NULL
smaller_gtfs <- filter_by_time_of_day(gtfs, from = "05:00:00", to = "06:00:00")

smaller_gtfs$stop_times |>
  select(trip_id, departure_time, arrival_time) |>
  head()

## -----------------------------------------------------------------------------
smaller_gtfs <- filter_by_time_of_day(
    gtfs,
    "05:00:00",
    "06:00:00",
    full_trips = TRUE
)

# CPTM L07-0 trip is kept intact because it crosses the time block
smaller_gtfs$stop_times |>
  select(trip_id, departure_time, arrival_time) |>
  head()

# dropping entries related to trips that cross the specified time block
smaller_gtfs <- filter_by_time_of_day(
    gtfs,
    "05:00:00",
    "06:00:00",
    full_trips = TRUE,
    keep = FALSE
)

# CPTM L07-0 trip is gone
smaller_gtfs$stop_times |>
  select(trip_id, departure_time, arrival_time) |>
  head()

## -----------------------------------------------------------------------------
plotter <- function(gtfs,
                    geom,
                    spatial_operation = sf::st_intersects,
                    keep = TRUE,
                    do_filter = TRUE) {
  if (do_filter) {
    gtfs <- filter_by_spatial_extent(gtfs, geom, spatial_operation, keep)
  }

  shapes <- get_shapes_geometry(gtfs)
  trips <- get_trip_geometry(gtfs, method = "euclidean")
  geom <- sf::st_as_sfc(geom)

  ggplot() +
    geom_sf(data = trips) +
    geom_sf(data = shapes) +
    geom_sf(data = geom, fill = NA)
}

## ----eval = has_dplyr && requireNamespace("ggplot2", quietly = TRUE)----------
bbox <- sf::st_bbox(get_shapes_geometry(gtfs, shape_id = "68962"))

plotter(gtfs, bbox, do_filter = FALSE)

## ----eval = has_dplyr && requireNamespace("ggplot2", quietly = TRUE)----------
plotter(gtfs, bbox)

## ----eval = has_dplyr && requireNamespace("ggplot2", quietly = TRUE)----------
plotter(gtfs, bbox, keep = FALSE)

## ----eval = has_dplyr && requireNamespace("ggplot2", quietly = TRUE)----------
plotter(gtfs, bbox, spatial_operation = sf::st_contains)

## ----eval = has_dplyr && requireNamespace("ggplot2", quietly = TRUE)----------
plotter(gtfs, bbox, spatial_operation = sf::st_contains, keep = FALSE)

