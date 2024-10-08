% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/write_gtfs.R
\name{write_gtfs}
\alias{write_gtfs}
\title{Write GTFS files}
\usage{
write_gtfs(
  gtfs,
  path,
  files = NULL,
  standard_only = FALSE,
  as_dir = FALSE,
  overwrite = TRUE,
  quiet = TRUE
)
}
\arguments{
\item{gtfs}{A GTFS object, as created by \code{\link[=read_gtfs]{read_gtfs()}}.}

\item{path}{The path to the \code{.zip} file in which the feed should be written
to.}

\item{files}{A character vector containing the name of the elements to be
written to the feed. If \code{NULL} (the default), all elements inside the GTFS
object are written.}

\item{standard_only}{Whether to write only standard files and fields
(defaults to \code{FALSE}, which doesn't drop extra files and fields).}

\item{as_dir}{Whether to write the feed as a directory, instead of a \code{.zip}
file (defaults to \code{FALSE}, which means that the field is written as a zip
file).}

\item{overwrite}{Whether to overwrite existing \code{.zip} file (defaults to
\code{TRUE}).}

\item{quiet}{Whether to hide log messages and progress bars (defaults to
\code{TRUE}).}
}
\value{
Invisibly returns the same GTFS object passed to the \code{gtfs}
parameter.
}
\description{
Writes GTFS objects as GTFS \code{.zip} files.
}
\examples{
data_path <- system.file("extdata/spo_gtfs.zip", package = "gtfstools")
gtfs <- read_gtfs(data_path)

tmp_dir <- file.path(tempdir(), "tmpdir")
dir.create(tmp_dir)
list.files(tmp_dir) #'
tmp_file <- tempfile(pattern = "gtfs", tmpdir = tmp_dir, fileext = ".zip")
write_gtfs(gtfs, tmp_file)
list.files(tmp_dir)

gtfs_all_files <- read_gtfs(tmp_file)
names(gtfs_all_files)

write_gtfs(gtfs, tmp_file, files = "stop_times")
gtfs_stop_times <- read_gtfs(tmp_file)
names(gtfs_stop_times)

}
\seealso{
Other io functions: 
\code{\link{read_gtfs}()}
}
\concept{io functions}
