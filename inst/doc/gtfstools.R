## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

Sys.setenv(OMP_THREAD_LIMIT = 2)
data.table::setDTthreads(2)

## ----eval = FALSE-------------------------------------------------------------
# install.packages("gtfstools")

## ----eval = FALSE-------------------------------------------------------------
# # install.packages("remotes")
# remotes::install_github("ipea/gtfstools")

## ----message = FALSE----------------------------------------------------------
library(gtfstools)

## ----eval = FALSE-------------------------------------------------------------
# # checks the number of threads currently used
# data.table::getDTthreads()
# 
# # uses 4 threads
# data.table::setDTthreads(4)

## -----------------------------------------------------------------------------
data_path <- system.file("extdata", package = "gtfstools")
list.files(data_path)

## -----------------------------------------------------------------------------
spo_path <- file.path(data_path, "spo_gtfs.zip")

# default behaviour
spo_gtfs <- read_gtfs(spo_path)
names(spo_gtfs)

# only reads the 'shapes.txt' and 'trips.txt' files
spo_shapes <- read_gtfs(spo_path, files = c("shapes", "trips"))
names(spo_shapes)

## -----------------------------------------------------------------------------
trip_geom <- get_trip_geometry(spo_gtfs)
plot(trip_geom$geometry)
single_trip <- spo_gtfs$trips$trip_id[1]
single_trip

shape_geom <- get_trip_geometry(spo_gtfs, trip_id = single_trip)
straight_geom <- get_trip_geometry(
  spo_gtfs,
  trip_id = single_trip,
  method = "euclidean"
)
plot(shape_geom$geometry)
plot(straight_geom$geometry, add = TRUE, col = "red")

## -----------------------------------------------------------------------------
trip_durtn <- get_trip_duration(spo_gtfs, unit = "s")
head(trip_durtn)

# 'unit' argument defaults to "min"
single_durtn <- get_trip_duration(spo_gtfs, trip_id = single_trip)
single_durtn

## -----------------------------------------------------------------------------
trip_seg_durtn <- get_trip_segment_duration(spo_gtfs, unit = "s")
head(trip_seg_durtn)

single_seg_durtn <- get_trip_segment_duration(spo_gtfs, trip_id = single_trip)
head(single_seg_durtn)

## -----------------------------------------------------------------------------
trip_length <- get_trip_length(spo_gtfs)
head(trip_length)

segment_length <- get_trip_length(spo_gtfs, single_trip, by = "segment")
head(segment_length)

## -----------------------------------------------------------------------------
trip_speed <- get_trip_speed(spo_gtfs, unit = "m/s")
head(trip_speed)

# 'unit' argument defaults to "km/h"
single_trip_speed <- get_trip_speed(spo_gtfs, trip_id = single_trip)
single_trip_speed

segment_speed <- get_trip_speed(spo_gtfs, single_trip, by = "segment")
head(segment_speed)

## -----------------------------------------------------------------------------
old_headway_secs <- spo_gtfs$frequencies$headway_secs

spo_gtfs$frequencies[, headway_secs := NULL]
head(spo_gtfs$frequencies)

spo_gtfs$frequencies[, headway_secs := old_headway_secs]
head(spo_gtfs$frequencies)

## -----------------------------------------------------------------------------
ggl_path <- file.path(data_path, "ggl_gtfs.zip")
ggl_gtfs <- read_gtfs(ggl_path)

names(spo_gtfs)
names(ggl_gtfs)

merged_gtfs <- merge_gtfs(spo_gtfs, ggl_gtfs)
names(merged_gtfs)

# only merges the 'shapes' and 'trips' tables
merged_files <- merge_gtfs(spo_gtfs, ggl_gtfs, files = c("shapes", "trips"))
names(merged_files)

## -----------------------------------------------------------------------------
selected_trips <- c("2002-10-0", "CPTM L07-0")

get_trip_speed(spo_gtfs, selected_trips, unit = "km/h")

# 'speed' is recycled to all trips if only a single value is given
new_speed_gtfs <- set_trip_speed(spo_gtfs, selected_trips, 50)
get_trip_speed(new_speed_gtfs, selected_trips)

# but you can also specify different speeds for each trip
new_speed_gtfs <- set_trip_speed(spo_gtfs, selected_trips, c(30, 40))
get_trip_speed(new_speed_gtfs, selected_trips)

## -----------------------------------------------------------------------------
temp_dir <- file.path(tempdir(), "gttools_vig")
dir.create(temp_dir)
list.files(temp_dir)

filename <- file.path(temp_dir, "spo_gtfs.zip")

write_gtfs(spo_gtfs, filename)
list.files(temp_dir)
zip::zip_list(filename)$filename

write_gtfs(spo_gtfs, filename, files = c("stop_times", "trips", "calendar"))
zip::zip_list(filename)$filename

