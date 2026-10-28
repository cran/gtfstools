## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

Sys.setenv(OMP_THREAD_LIMIT = 2)
data.table::setDTthreads(2)

library(gtfstools)

## ----message = FALSE, eval = requireNamespace("ggplot2", quietly = TRUE)------
library(gtfstools)
library(ggplot2)
library(dplyr)

## -----------------------------------------------------------------------------
path <- system.file("extdata/spo_gtfs.zip", package = "gtfstools")
gtfs <- read_gtfs(path)

## ----eval = requireNamespace("ggplot2", quietly = TRUE), fig.width = 7, fig.height = 5, dpi = 96----
shapes <- get_shapes_geometry(gtfs)

ggplot() +
  geom_sf(data = shapes) +
  theme_void()

## -----------------------------------------------------------------------------
route_speed <- get_route_speed(gtfs)

head(route_speed)

## ----eval = requireNamespace("ggplot2", quietly = TRUE), fig.width = 7, fig.height = 5, dpi = 96----
# the sf object comes first, so that the result is also an sf object
routes <- get_route_geometry(gtfs) |>
  dplyr::inner_join(route_speed, by = "route_id")

ggplot() +
  geom_sf(data = routes, aes(color = mean_speed)) +
  scale_color_viridis_c(name = "Speed (km/h)") +
  theme_void()

## -----------------------------------------------------------------------------
weekday_gtfs <- filter_by_weekday(gtfs, "monday")

stop_frequency <- get_stop_frequency(
  gtfs = weekday_gtfs,
  from = "07:00:00",
  to = "09:00:00"
)

stop_frequency <- stop_frequency |>
  dplyr::group_by(stop_id) |>
  dplyr::summarise(
    departures = sum(departures), 
    .groups = "drop"
    )


## ----eval = requireNamespace("ggplot2", quietly = TRUE), fig.width = 7, fig.height = 5, dpi = 96----
stops <- get_stops_geometry(gtfs, stop_id = stop_frequency$stop_id)

stops <- stops |>
  dplyr::inner_join(stop_frequency, by = "stop_id")

# draws the busiest stops on top
stops <- stops |>
  dplyr::arrange(departures)

ggplot() +
  geom_sf(
    data = stops,
    aes(color = departures, size = departures),
    alpha = 0.7
  ) +
  scale_color_viridis_c(guide = "legend") +
  labs(color = "Departures", size = "Departures") +
  theme_void()

