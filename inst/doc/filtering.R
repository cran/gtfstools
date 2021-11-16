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
  geom <- gtfstools:::polygon_from_bbox(geom)

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

