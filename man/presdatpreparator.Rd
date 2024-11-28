\name{presdatpreparator}
\alias{presdatpreparator}
\title{Spatially Balanced Resampling and Outlier Removal Combined}
\description{
  This function performs both spatially balanced resampling and outlier removal on input data within a given study area polygon. It integrates the use of \code{spatbalsample} and \code{remoutlier}.
}
\usage{
presdatpreparator(data, study_area, buffer = 0.1, reps = 1000, crs = "EPSG:4326", threshold = 90)
}
\arguments{
  \item{data}{A data frame containing the coordinates of the data points with at least two columns named \code{x} and \code{y}.}
  \item{study_area}{A polygon representing the study area. It should be an object that can be converted to an \code{sf} object.}
  \item{buffer}{Numeric value representing the buffer distance within which points should be excluded during resampling. Default is 0.1.}
  \item{reps}{Number of repetitions for the resampling process. Default is 1000.}
  \item{crs}{Coordinate reference system of the input data and study area. Default is \code{"EPSG:4326"}.}
  \item{threshold}{Percentile value for kernel density threshold used to determine outlier exclusion. Default is 90.}
}
\value{
  A subset of the input data frame, first spatially resampled and then filtered for outliers, clipped to the study area.
}
\examples{
study_area <- st_as_sf(st_sfc(st_polygon(list(rbind(c(0, 0), c(1, 0), c(1, 1), c(0, 1), c(0, 0)))), crs = "EPSG:4326"))
data <- data.frame(x = runif(100), y = runif(100))
prepared_data <- presdatpreparator(data, study_area)
print(prepared_data)
}
\seealso{
  \code{\link{spatbalsample}}, \code{\link{remoutlier}}
}
\keyword{spatial}
\keyword{resampling}
\keyword{outlier}
