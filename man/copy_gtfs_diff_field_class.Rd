% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{copy_gtfs_diff_field_class}
\alias{copy_gtfs_diff_field_class}
\title{Make a GTFS copy with a field of a different class}
\usage{
copy_gtfs_diff_field_class(gtfs, file, field, class)
}
\arguments{
\item{gtfs}{A GTFS object, as created by \code{\link[=read_gtfs]{read_gtfs()}}.}

\item{file}{File whose field must have the class changed.}

\item{field}{Field to have the class changed.}

\item{class}{The desired class.}
}
\value{
A GTFS object with the field of desired class.
}
\description{
Creates a copy of a GTFS object while changing the class of a given field.
Used for testing.
}
\keyword{internal}
