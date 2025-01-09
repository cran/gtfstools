## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = identical(tolower(Sys.getenv("NOT_CRAN")), "true"),
  out.width = "100%"
)

Sys.setenv(OMP_THREAD_LIMIT = 2)

## -----------------------------------------------------------------------------
# library(gtfstools)
# 
# latest_validator <- download_validator(tempdir())
# latest_validator

## -----------------------------------------------------------------------------
# data_path <- system.file("extdata/spo_gtfs.zip", package = "gtfstools")
# 
# path_output_dir <- tempfile("validation_from_path")
# validate_gtfs(data_path, path_output_dir, latest_validator)
# list.files(path_output_dir)

## ----echo = FALSE-------------------------------------------------------------
# knitr::include_graphics("../man/figures/html_validation_report.png")

## -----------------------------------------------------------------------------
# gtfs_url <- "https://github.com/ipeaGIT/gtfstools/raw/main/inst/extdata/spo_gtfs.zip"
# gtfs <- read_gtfs(data_path)
# 
# url_output_dir <- tempfile("validation_from_url")
# validate_gtfs(gtfs_url, url_output_dir, latest_validator)
# 
# object_output_dir <- tempfile("validation_from_object")
# validate_gtfs(gtfs, object_output_dir, latest_validator)
# 
# validation_content <- function(path) {
#   report_json_path <- file.path(path, "report.json")
#   suppressWarnings(report_json_content <- readLines(report_json_path))
#   return(report_json_content)
# }
# 
# path_output_content <- validation_content(path_output_dir)
# url_output_content <- validation_content(url_output_dir)
# object_output_content <- validation_content(object_output_dir)
# 
# identical(path_output_content, url_output_content)
# identical(path_output_content, object_output_content)

