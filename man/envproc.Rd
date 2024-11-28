\name{envproc}
\alias{envproc}
\title{Process Environmental Data for SDM}
\description{
  This function processes environmental data layers within a given study area, including cropping, masking, and projecting rasters.
}
\usage{
envproc(study_area, env_dir, file_ext = "asc", out_dir)
}
\arguments{
  \item{study_area_path}{Path to the shapefile defining the study area.}
  \item{env_dir}{Directory containing the environmental data files to be processed.}
  \item{file_ext}{File extension of the environmental data files to be processed. Default is \code{"asc"}.}
  \item{out_dir}{Output directory where the processed environmental rasters will be saved.}
}
\value{
  This function writes the processed raster files to the specified output directory.
}
\examples{
# Example usage for envproc
envproc(study_area, 
        "c:/Users/edvar/Documents/chelsa_cur2/", 
        "asc", 
        "c:/Users/edvar/Dropbox/sdm/envprep/")
}
\seealso{
  \code{\link{remoutlier}}
}
\keyword{environmental}
\keyword{raster}
\keyword{spatial}
