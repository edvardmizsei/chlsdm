\name{loadenv}
\alias{loadenv}
\title{Load Processed Raster Files into a Stack and Validate Consistency}
\description{
  This function loads processed raster files from a given directory into a raster stack and checks that they have consistent dimensions, coordinate reference system (CRS), and resolution.
}
\usage{
loadenv(env_dir, file_ext = "asc")
}
\arguments{
  \item{env_dir}{Directory containing the environmental raster files to be loaded.}
  \item{file_ext}{File extension of the raster files to be loaded (e.g., "asc"). Default is \code{"asc"}.}
}
\value{
  A \code{SpatRaster} stack containing the loaded raster files if all checks are passed.
}
\examples{
# Example usage for loadenv
r_stack <- loadenv("c:/Users/edvar/Dropbox/sdm/envprep/", "asc")
print(r_stack)
}
\seealso{
  \code{\link{envproc}}
}
\keyword{raster}
\keyword{spatial}
\keyword{stack}
