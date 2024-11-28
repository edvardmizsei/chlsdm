\name{envselect}
\alias{envselect}
\title{Select Environmental Variables Based on Presence and Background Data}
\description{
  This function selects relevant environmental variables for Species Distribution Modeling (SDM) by using correlation and Variance Inflation Factor (VIF)-based selection criteria. It is used to identify which environmental variables are most informative for predicting species presence while minimizing multicollinearity.
}
\usage{
envselect(pres, env, folds = 10, cutoff = 0.7)
}
\arguments{
  \item{pres}{A data frame containing presence locations with columns named \code{x} and \code{y} representing coordinates.}
  \item{env}{A \code{SpatRaster} object containing the environmental variables.}
  \item{folds}{The number of folds to be used to generate pseudo-absence points, with the default set to 10.}
  \item{cutoff}{A correlation threshold (between 0 and 1) to select the environmental variables. Variables that have a Variance Inflation Factor (VIF) higher than this threshold are excluded. Default is 0.7.}
}
\value{
  A character vector with the names of the selected environmental variables that passed the correlation-based selection criteria.
}
\examples{
# Example usage for envselect
pres <- read.csv("testdata/tesmar.csv")
env <- loadenv("c:/Users/edvar/Dropbox/sdm/envprep/", "asc")
selected_vars <- envselect(pres, env, folds = 10, cutoff = 0.7)
print(selected_vars)
}
\seealso{
  \code{\link{loadenv}}, \code{\link{corSelect}}
}
\keyword{SDM}
\keyword{environmental}
\keyword{variable selection}
\keyword{correlation}
