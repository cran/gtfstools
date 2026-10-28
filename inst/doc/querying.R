## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

Sys.setenv(OMP_THREAD_LIMIT = 2)
data.table::setDTthreads(2)

library(gtfstools)

## ----message = FALSE----------------------------------------------------------
library(gtfstools)

## -----------------------------------------------------------------------------
spo_path <- system.file("extdata/spo_gtfs.zip", package = "gtfstools")
gtfs <- read_gtfs(spo_path)

get_route_frequency(
  gtfs,
  route_id = c("CPTM L07", "2002-10"),
  from = "07:00:00",
  to = "09:00:00"
)

## -----------------------------------------------------------------------------
get_stop_frequency(
  gtfs,
  stop_id = c("18848", "18960"),
  from = "07:00:00",
  to = "09:00:00"
)

## -----------------------------------------------------------------------------
ber_path <- system.file("extdata/ber_gtfs.zip", package = "gtfstools")
ber_gtfs <- read_gtfs(ber_path)

timetable <- get_stop_timetable(
  ber_gtfs,
  stop_id = "100000720101",
  date = "2021-01-04"
)
head(timetable[, .(date, trip_id, route_id, trip_headsign, departure_time)])

## -----------------------------------------------------------------------------
trip_ids <- c("CPTM L07-0", "2002-10-0")

# 'unit' argument defaults to "km"
get_trip_length(gtfs, trip_ids)

## -----------------------------------------------------------------------------
# 'unit' argument defaults to "min"
get_trip_duration(gtfs, trip_ids)

## -----------------------------------------------------------------------------
# 'unit' argument defaults to "km/h"
get_trip_speed(gtfs, trip_ids)

## -----------------------------------------------------------------------------
get_route_speed(gtfs, route_id = c("CPTM L07", "2002-10"))

## ----eval = requireNamespace("ggplot2", quietly = TRUE) && requireNamespace("knitr", quietly = TRUE) && requireNamespace("rmarkdown", quietly = TRUE) && rmarkdown::pandoc_available()----
feed_summary <- get_summary(spo_path, html_preview = FALSE)

feed_summary$totals

