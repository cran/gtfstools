path <- system.file("extdata/spo_gtfs.zip", package = "gtfstools")
gtfs <- read_gtfs(path)
stop_ids <- c("18848", "940004157")
env <- environment()

# tests -------------------------------------------------------------------
# the large majority of tests are already conducted inside filter_by_trip_id(),
# which filter_by_stop_id() calls. only a few sanity checks are included here


test_that("raises error due to incorrect input types", {
  expect_error(filter_by_stop_id(unclass(gtfs), stop_ids))
  expect_error(filter_by_stop_id(gtfs, factor(stop_ids)))
  expect_error(filter_by_stop_id(gtfs, NA))
  expect_error(filter_by_stop_id(gtfs, stop_ids, keep = "TRUE"))
  expect_error(filter_by_stop_id(gtfs, stop_ids, NA))
})

test_that("results in a dt_gtfs object", {
  # a dt_gtfs object is a list with "dt_gtfs" and "gtfs" classes
  dt_gtfs_class <- c("dt_gtfs", "gtfs", "list")
  smaller_gtfs <- filter_by_stop_id(gtfs, stop_ids)
  expect_s3_class(smaller_gtfs, dt_gtfs_class)
  expect_type(smaller_gtfs, "list")

  # all objects inside a dt_gtfs are data.tables
  invisible(lapply(smaller_gtfs, expect_s3_class, "data.table"))
})

test_that("doesn't change given gtfs", {
  # (except for some tables' indices)

  original_gtfs <- read_gtfs(path)
  gtfs <- read_gtfs(path)
  expect_identical(original_gtfs, gtfs)

  smaller_gtfs <- filter_by_stop_id(gtfs, stop_ids)
  expect_false(identical(original_gtfs, gtfs))

  data.table::setindex(gtfs$agency, NULL)
  data.table::setindex(gtfs$calendar, NULL)
  data.table::setindex(gtfs$frequencies, NULL)
  data.table::setindex(gtfs$routes, NULL)
  data.table::setindex(gtfs$shapes, NULL)
  data.table::setindex(gtfs$stop_times, NULL)
  data.table::setindex(gtfs$stops, NULL)
  expect_identical(original_gtfs, gtfs)
})

test_that("'stop_id' and 'keep' arguments work correctly", {
  relevant_trips <- gtfs$stop_times[stop_id %chin% stop_ids]$trip_id
  smaller_gtfs_keeping <- filter_by_stop_id(gtfs, stop_ids)
  expect_true(all(smaller_gtfs_keeping$trips$trip_id %in% relevant_trips))

  smaller_gtfs_not_keeping <- filter_by_stop_id(gtfs, stop_ids, keep = FALSE)
  expect_true(!any(smaller_gtfs_not_keeping$trips$trip_id %in% relevant_trips))
})
