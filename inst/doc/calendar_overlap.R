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

## ----message = FALSE, warning = FALSE,  eval = requireNamespace("ggplot2", quietly = TRUE)----
library(gtfstools)
library(ggplot2)

## ----message = FALSE----------------------------------------------------------
library(dplyr)

## -----------------------------------------------------------------------------
spo_path <- system.file("extdata/spo_gtfs.zip", package = "gtfstools")
poa_path <- system.file("extdata/poa_gtfs.zip", package = "gtfstools")

daily_trips <- get_calendar_overlap(c(spo_path, poa_path))

daily_trips |> 
  dplyr::filter( overlap == TRUE) |> 
  head()

## ----eval = has_dplyr && requireNamespace("ggplot2", quietly = TRUE), fig.width = 7, fig.height = 4, dpi = 96----
get_calendar_overlap(c(spo_path, poa_path), plot = TRUE)

## -----------------------------------------------------------------------------
overlap_days <- unique(daily_trips$date[daily_trips$overlap])
departure_date <- overlap_days[format(overlap_days, "%u") == "3"][1]

daily_trips |>
  filter(date == departure_date)

## -----------------------------------------------------------------------------
get_calendar_overlap(c(spo_path, poa_path), resolution = "periods")

## -----------------------------------------------------------------------------
ber_path <- system.file("extdata/ber_gtfs.zip", package = "gtfstools")
feeds <- c(spo_path, poa_path, ber_path)

get_calendar_overlap(feeds, resolution = "periods")

## ----eval = has_dplyr && requireNamespace("ggplot2", quietly = TRUE), fig.width = 7, fig.height = 2.5, dpi = 96----
get_calendar_overlap(feeds, resolution = "periods", plot = TRUE) +
  coord_cartesian(xlim = as.Date(c("2018-12-01", "2021-07-01")))

