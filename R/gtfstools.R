#' gtfstools: General Transit Feed Specification (GTFS) Editing and Analysing
#' Tools
#'
#' Utility functions to read, manipulate, analyse and write transit feeds in the
#' General Transit Feed Specification (GTFS) data format.
#'
#' @section Usage:
#' Please check the vignettes for more on the package usage:
#' - Basic usage: reading, analysing, manipulating and writing feeds. Run
#' `vignette("gtfstools")` or check it on the [website](
#' https://ipeagit.github.io/gtfstools/articles/gtfstools.html).
#' - Filtering GTFS feeds. Run `vignette("filtering", package = "gtfstools")` or
#' check it on the [website](
#' https://ipeagit.github.io/gtfstools/articles/filtering.html).
#' - Validating GTFS feeds. Run `vignette("validating", package = "gtfstools")`
#' or check it on the
#' [website](https://ipeagit.github.io/gtfstools/articles/validating.html).
#'
#' @docType package
#' @name gtfstools
#' @aliases gtfstools-package
#' @useDynLib gtfstools, .registration = TRUE
#'
#' @importFrom data.table := .I .SD %chin% .GRP .N
#' @importFrom utils globalVariables
#'
#' @keywords internal
"_PACKAGE"

utils::globalVariables(
  c(
    ".",
    "stop_sequence",
    "departure_time_secs",
    "arrival_time_secs",
    "last_stop_departure",
    "segment",
    "duration",
    "result",
    "geometry",
    "shape_id",
    "shape_pt_sequence",
    "stop_sequence",
    "origin_file",
    "file_spec",
    "file_provided_status",
    "field_provided_status",
    "field_spec",
    "validation_details",
    "i.stop_lat",
    "i.stop_lon",
    "arrival_time",
    "departure_time",
    "i.duration",
    "speed",
    "route_id",
    "trip_id",
    "stop_id",
    "route_type",
    "parent_station",
    "agency_id",
    "fare_id",
    "service_id",
    "start_date",
    "end_date",
    "level_id",
    "origin_id",
    "destination_id",
    "contains_id",
    "from_stop_id",
    "to_stop_id",
    "start_time_secs",
    "start_time",
    "end_time_secs",
    "end_time",
    "start_time_secs",
    "end_time_secs",
    "headway_secs",
    "..other_cols",
    "checked",
    "children_list",
    "from_to_within",
    "within_from_to",
    "from_within",
    "to_within",
    "is_duplicated",
    "exact_times",
    "filtered_n_stops",
    "i.n_stops",
    "n_stops",
    "i.length",
    "pattern_id",
    "data",
    "template_departure",
    "template_arrival",
    "origin_gtfs",
    "feed_start_date",
    "feed_end_date",
    "dist_to_prev_point",
    "shape_dist_traveled",
    "from_route_id",
    "to_route_id",
    "from_trip_id",
    "to_trip_id",
    ".flagged"
  )
)
