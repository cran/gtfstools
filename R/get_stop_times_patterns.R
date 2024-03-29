#' Get stop times patterns
#'
#' Identifies spatial and spatiotemporal patterns within the `stop_times`
#' table. Please see the details to understand what a "pattern" means in each of
#' these cases.
#'
#' @template gtfs
#' @param trip_id A character vector including the `trip_id`s to have their
#'   `stop_times` entries analyzed. If `NULL` (the default), the function
#'   analyses the pattern of every `trip_id` in the GTFS.
#' @param type A string specifying the type of patterns to be analyzed. Either
#'   `"spatial"` (the default) or "spatiotemporal".
#'
#' @return A `data.table` associating each `trip_id` to a `pattern_id`.
#'
#' @section Details:
#' Two trips are assigned to the same spatial `pattern_id` if they travel along
#' the same sequence of stops. They are assigned to the same spatiotemporal
#' `pattern_id`, on the other hand, if they travel along the same sequence of
#' stops and they take the same time between stops. Please note that, in such
#' case, only the time between stops is taken into account, and the time that
#' the trip started is ignored (e.g. if two trips depart from stop A and follow
#' the same sequence of stops to arrive at stop B, taking both 1 hour to do so,
#' their spatiotemporal pattern will be considered the same, even if one
#' departed at 6 am and another at 7 am). Please also note that the
#' `stop_sequence` field is currently ignored - which means that two stops are
#' considered to follow the same sequence if one is listed right below the
#' other on the `stop_times` table (e.g. if trip X lists stops A followed by
#' stop B with `stop_sequence`s 1 and 2, and trip Y lists stops A followed by
#' stop B with `stop_sequence`s 1 and 3, they are assigned to the same
#' `pattern_id`).
#'
#' @examples
#' data_path <- system.file("extdata/ber_gtfs.zip", package = "gtfstools")
#'
#' gtfs <- read_gtfs(data_path)
#'
#' patterns <- get_stop_times_patterns(gtfs)
#' head(patterns)
#'
#' # use the trip_id argument to control which trips are analyzed
#' patterns <- get_stop_times_patterns(
#'   gtfs,
#'   trip_id = c("143765658", "143765659", "143765660")
#' )
#' patterns
#'
#' # use the type argument to control the type of pattern analyzed
#' patterns <- get_stop_times_patterns(
#'   gtfs,
#'   trip_id = c("143765658", "143765659", "143765660"),
#'   type = "spatiotemporal"
#' )
#' patterns
#'
#' @export
get_stop_times_patterns <- function(gtfs, trip_id = NULL, type = "spatial") {
  checkmate::assert_class(gtfs, "dt_gtfs")
  checkmate::assert_character(trip_id, null.ok = TRUE, any.missing = FALSE)
  checkmate::assert(
    checkmate::check_string(type),
    checkmate::check_names(type, subset.of = c("spatial", "spatiotemporal")),
    combine = "and"
  )

  must_exist <- c("trip_id", "stop_id")
  classes <- rep("character", 2)
  if (type == "spatiotemporal") {
    must_exist <- c(must_exist, "departure_time", "arrival_time")
    classes <- c(classes, rep("character", 2))

  }
  gtfsio::assert_field_class(
    gtfs,
    "stop_times",
    fields = must_exist,
    classes = classes
  )

  # select trips to check patterns of and raise warning if any of them doesn't
  # exist in stop_times

  if (!is.null(trip_id)) {
    relevant_trips <- trip_id

    invalid_trips <- trip_id[! trip_id %chin% gtfs$stop_times$trip_id]

    if (!identical(invalid_trips, character(0))) {
      warning(
        "'stop_times' doesn't contain the following trip_id(s): ",
        paste0("'", invalid_trips, "'", collapse = ", ")
      )
    }

    patterns <- gtfs$stop_times[trip_id %chin% relevant_trips]
  } else {
    patterns <- gtfs$stop_times
  }

  if (type == "spatial") {
    patterns <- patterns[
      ,
      .(data = paste0(stop_id, collapse = ";")),
      keyby = trip_id
    ]
  } else {
    if (
      !gtfsio::check_field_exists(gtfs, "stop_times", "departure_time_secs")
    ) {
      patterns[, departure_time_secs := string_to_seconds(departure_time)]
      created_departure_secs <- TRUE
    }
    if (
      !gtfsio::check_field_exists(gtfs, "stop_times", "arrival_time_secs")
    ) {
      patterns[, arrival_time_secs := string_to_seconds(arrival_time)]
      created_arrival_secs <- TRUE
    }

    patterns[
      ,
      `:=`(
        template_departure = departure_time_secs - min(departure_time_secs),
        template_arrival = arrival_time_secs - min(departure_time_secs)
      ),
      by = trip_id
    ]

    patterns <- patterns[
      ,
      .(
        data = paste(
          stop_id,
          template_departure,
          template_arrival,
          sep = "|",
          collapse = ";"
        )
      ),
      keyby = trip_id
    ]

    if (gtfsio::check_field_exists(gtfs, "stop_times", "template_arrival")) {
      gtfs$stop_times[, c("template_departure", "template_arrival") := NULL]
    }

    if (
      gtfsio::check_field_exists(gtfs, "stop_times", "departure_time_secs") &
      exists("created_departure_secs")
    ) {
      gtfs$stop_times[, departure_time_secs := NULL]
    }

    if (
      gtfsio::check_field_exists(gtfs, "stop_times", "arrival_time_secs") &
      exists("created_arrival_secs")
    ) {
      gtfs$stop_times[, arrival_time_secs := NULL]
    }
  }

  patterns[, pattern_id := .GRP, by = data]
  patterns[, data := NULL]

  return(patterns[])
}
