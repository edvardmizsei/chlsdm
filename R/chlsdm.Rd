\name{chlsdm}
\alias{chlsdm}
\title{Comprehensive Species Distribution Modeling Workflow}
\description{
  This function runs a complete species distribution modeling (SDM) workflow, including spatial sampling, outlier removal, environmental variable selection, and modeling using BIOMOD2. The function performs all the necessary steps to create a model of species distribution using various machine learning models.
}
\usage{
chlsdm(pres, env, sp, envselect, panum = 4, cvrep = 4, cores = 4)
}
\arguments{
  \item{pres}{A data frame containing the presence points with columns named \code{x} and \code{y} representing coordinates.}
  \item{env}{A \code{SpatRaster} object containing the environmental variables used for modeling.}
  \item{sp}{A character string specifying the species name for the modeling process.}
  \item{envselect}{A function to select environmental variables based on their correlation.}
  \item{panum}{Number of pseudo-absence repetitions to be created. Default is 4.}
  \item{cvrep}{Number of cross-validation repetitions for modeling. Default is 4.}
  \item{cores}{Number of cores to use for parallel processing during modeling. Default is 4.}
}
\value{
  A \code{SpatRaster} object containing the averaged ensemble model output for the species distribution, scaled down by a factor of 1000.
}
\examples{
# Example usage for chlsdm
pres <- read.csv("testdata/tesmar.csv")
env <- loadenv("c:/Users/edvar/Dropbox/sdm/envprep/", "asc")
result <- chlsdm(pres, env, sp = "MySpecies", envselect = envselect, panum = 4, cvrep = 4, cores = 4)
plot(result)
}
\seealso{
  \code{\link{spatbalsample}}, \code{\link{remoutlier}}, \code{\link{envselect}}, \code{\link{BIOMOD_FormatingData}}
}
\keyword{SDM}
\keyword{species}
\keyword{distribution}
\keyword{modeling}
\keyword{biomod2}
