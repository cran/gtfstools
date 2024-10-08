% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_trip_geometry.R
\name{get_trip_geometry}
\alias{get_trip_geometry}
\title{Get trip geometry}
\usage{
get_trip_geometry(
  gtfs,
  trip_id = NULL,
  file = NULL,
  crs = 4326,
  sort_sequence = FALSE
)
}
\arguments{
\item{gtfs}{A GTFS object, as created by \code{\link[=read_gtfs]{read_gtfs()}}.}

\item{trip_id}{A character vector including the \code{trip_id}s to have their
geometries generated. If \code{NULL} (the default), the function generates
geometries for every \code{trip_id} in the GTFS.}

\item{file}{A character vector specifying the file from which geometries
should be generated (either one of or both \code{shapes} and \code{stop_times}). If
\code{NULL} (the default), the function attemps to generate the geometries from
both files, but only raises an error if none of the files exist.}

\item{crs}{The CRS of the resulting object, either as an EPSG code or as an
\code{crs} object. Defaults to 4326 (WGS 84).}

\item{sort_sequence}{A logical specifying whether to sort shapes and
timetables by \code{shape_pt_sequence} and \code{stop_sequence}, respectively.
Defaults to \code{FALSE}, otherwise spec-compliant feeds, in which
shape/timetables points are already ordered by
\code{shape_pt_sequence}/\code{stop_sequence}, would be penalized through longer
processing times. Geometries generated from unordered sequences do not
correctly depict the trip trajectories.}
}
\value{
A \verb{LINESTRING sf}.
}
\description{
Returns the geometry of each specified \code{trip_id}, based either on the
\code{shapes} or the \code{stop_times} file (or both).
}
\section{Details}{

The geometry generation works differently for the two files. In the case of
\code{shapes}, the shape as described in the text file is converted to an \code{sf}
object. For \code{stop_times} the geometry is the result of linking subsequent
stops along a straight line (stops' coordinates are retrieved from the
\code{stops} file). Thus, the resolution of the geometry when generated with
\code{shapes} tends to be much higher than when created with \code{stop_times}.
}

\examples{
data_path <- system.file("extdata/spo_gtfs.zip", package = "gtfstools")

gtfs <- read_gtfs(data_path)

trip_geometry <- get_trip_geometry(gtfs)
head(trip_geometry)

# the above is identical to
trip_geometry <- get_trip_geometry(gtfs, file = c("shapes", "stop_times"))
head(trip_geometry)

trip_ids <- c("CPTM L07-0", "2002-10-0")
trip_geometry <- get_trip_geometry(gtfs, trip_id = trip_ids)
trip_geometry
plot(trip_geometry["origin_file"])

}
