% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/opsnap.R
\name{download_and_read}
\alias{download_and_read}
\title{Download and read data from opsnap project}
\usage{
download_and_read(u, remove_nas = FALSE, dir = "raw_data/west-yorkshire")
}
\arguments{
\item{u}{URL of data}

\item{remove_nas}{Remove NA values?}

\item{dir}{Download directory}
}
\value{
Data frame
}
\description{
Download and read data from opsnap project
}
\examples{
if (FALSE) {
u = paste0(
  "https://www.westyorkshire.police.uk/sites/default/files/",
  "2023-10/operation_snap_july-sept_2023.xlsx"
)
download_and_read(, dir = ".")
}
}
