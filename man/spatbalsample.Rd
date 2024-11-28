\name{spatbalsample}
\alias{spatbalsample}
\title{Spatially Balanced Resampling}
\description{
  This function performs spatially balanced resampling of input data, ensuring that selected points are not too close to each other based on a defined buffer distance.
}
\usage{
spatbalsample(data, buffer = 0.1, reps = 1000)
}
\arguments{
  \item{data}{A data frame containing the coordinates of the data points with at least two columns named \code{x} and \code{y}.}
  \item{buffer}{Numeric value representing the buffer distance within which points should be excluded. Default is 0.1.}
  \item{reps}{Number of repetitions for resampling to find the best set of points that satisfy the spatial balance criteria. Default is 1000.}
}
\value{
  A subset of the input data frame containing the selected points after spatially balanced resampling.
}
\examples{
data <- data.frame(x = runif(100), y = runif(100))
result <- spatbalsample(data)  # Using default buffer = 0.1 and reps = 1000
print(result)
}
\keyword{spatial}
\keyword{resampling}
