\name{extract_chelsa_metadata}
\alias{extract_chelsa_metadata}
\title{Extract Metadata from CHELSA File Paths}
\description{
Parses CHELSA raster file paths and extracts metadata from the directory
structure and file names. The function is intended for building a metadata table
used in downstream CHELSA processing workflows, including filtering variables,
grouping by climatology period, GCM, and scenario, and generating standardised
output file names.
}
\usage{
extract_chelsa_metadata(file_paths)
}
\arguments{
  \item{file_paths}{
A character vector of file paths or URLs pointing to CHELSA raster files.
These paths are first normalised with \code{normalize_paths()} and then parsed
to extract metadata.
}
}
\details{
The function assumes CHELSA files follow a directory structure such as:

\preformatted{
.../climatologies/<year_range>/bio/<filename>
.../climatologies/<year_range>/<gcm>/<scenario>/bio/<filename>
}

From each input path, the function extracts:

\describe{
  \item{\code{full_path}}{The normalised full file path.}
  \item{\code{filename}}{The file name only.}
  \item{\code{varname}}{The CHELSA variable name parsed from the file name.}
  \item{\code{vartype}}{Optional summary type, such as \code{max}, \code{min},
  \code{mean}, \code{range}, \code{sum}, or \code{sd}.}
  \item{\code{var_full}}{Combined variable name and variable type.}
  \item{\code{year_range}}{The climatology period parsed from the path.}
  \item{\code{gcm}}{The GCM name parsed from the path, if present.}
  \item{\code{scenario}}{The climate scenario parsed from the path, or
  \code{"current"} for non-future climatologies.}
  \item{\code{suffix}}{Version suffix parsed from the file name, such as
  \code{V2.1}.}
  \item{\code{new_filename}}{A simplified output file name ending in
  \code{.asc}, based on the variable name and optional variable type.}
}

The function is useful for preparing metadata tables that can be filtered before
calling raster processing functions such as \code{envproc_chelsa_parallel()}.
}
\value{
A data frame with one row per input file path and the following columns:

\describe{
  \item{\code{full_path}}{Normalised full file path.}
  \item{\code{filename}}{Source file name.}
  \item{\code{varname}}{Variable name extracted from the file name.}
  \item{\code{vartype}}{Optional variable type.}
  \item{\code{var_full}}{Combined variable name and type.}
  \item{\code{year_range}}{Climatology year range.}
  \item{\code{gcm}}{General circulation model name, if available.}
  \item{\code{scenario}}{Scenario name, if available.}
  \item{\code{suffix}}{Version suffix extracted from the file name.}
  \item{\code{new_filename}}{Output file name ending in \code{.asc}.}
}
}
\examples{
\dontrun{
files <- c(
  "/vsis3/example/chelsa/climatologies/1981-2010/bio/CHELSA_bio1_1981-2010_V2.1.tif",
  "/vsis3/example/chelsa/climatologies/2041-2070/MPI-ESM1-2-HR/ssp370/bio/CHELSA_rsds_2041-2070_mean_V2.1.tif"
)

fd <- extract_chelsa_metadata(files)

fd[, c("filename", "varname", "vartype", "year_range", "gcm", "scenario", "new_filename")]
}
}
\seealso{
\code{\link{envproc_chelsa_parallel}}
}
\author{
Edvárd Mizsei
}
\keyword{file}
\keyword{utilities}
