\name{remoutlier}
\alias{remoutlier}
\title{Removing Outliers Using a Density Kernel}
\description{
  This function removes outlier coordinates based on kernel density estimation using the \code{terra} and \code{sf} packages.
}
\usage{
remoutlier(data, crs = "EPSG:4326", threshold = 90)
}
\arguments{
  \item{data}{A data frame containing at least two columns named \code{x} and \code{y}, which represent coordinates.}
  \item{crs}{Coordinate reference system of the input data. Default is \code{"EPSG:4326"}.}
  \item{threshold}{Percentile value (between 0 and 100) for kernel density threshold to determine outlier exclusion. Default is 90.}
}
\value{
  A subset of the input data frame with the outliers removed.
}
\examples{
data <- data.frame(x = runif(100), y = runif(100))
filtered_result <- remoutlier(data)
print(filtered_result)
}
\seealso{
  \code{\link{spatbalsample}}
}
\keyword{outlier}
\keyword{density}
