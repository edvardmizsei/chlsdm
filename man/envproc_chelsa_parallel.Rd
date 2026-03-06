\name{envproc_chelsa_parallel}
\alias{envproc_chelsa_parallel}
\title{Process CHELSA Raster Layers in Parallel for a Study Area}
\description{
Reads CHELSA raster files from local paths or remote URLs, crops and masks them
to a study area, and writes the processed rasters to disk in parallel as
Arc/Info ASCII Grid files. Output rasters are organised into subdirectories by
year range, GCM, and scenario. Existing outputs are skipped.
}
\usage{
envproc_chelsa_parallel(study_area, file_url_df, out_dir, cores = 12, retries = 2)
}
\arguments{
  \item{study_area}{
A spatial object defining the study area used for cropping and masking.
This can be an object coercible by \code{terra::vect()}, such as an
\code{sf} object, \code{SpatVector}, or similar spatial polygon object.
}

  \item{file_url_df}{
A data frame of CHELSA raster metadata, typically produced by a helper such as
\code{extract_chelsa_metadata()}. Each row represents one raster layer to be
processed.

The following columns are required:

\describe{
  \item{\code{full_path}}{Character. Full local path or remote URL to the source raster.}
  \item{\code{year_range}}{Character. Time period label used in the output folder structure. Missing values are replaced by \code{"unknown"}.}
  \item{\code{gcm}}{Character. General circulation model label used in the output folder structure. Missing values are replaced by \code{"global"}.}
  \item{\code{scenario}}{Character. Scenario label used in the output folder structure. Missing values are replaced by \code{"current"}.}
  \item{\code{new_filename}}{Character. Output filename for the processed raster.}
}

Additional columns, such as \code{varname}, may be present and can be used
upstream for filtering the set of rasters to process.
}

  \item{out_dir}{
Character. Base output directory where processed rasters will be saved.
Subdirectories are created automatically if needed.
}

  \item{cores}{
Integer. Number of CPU cores to use for parallel processing. The value is
capped at the number of available logical cores. Defaults to \code{12}.
}

  \item{retries}{
Integer. Number of attempts for processing each raster before the file is
marked as failed. Defaults to \code{2}.
}
}
\details{
The function is designed for CHELSA climatology workflows in which a metadata
table is first prepared from a vector of CHELSA file paths or URLs, then
filtered to retain only variables shared across all year range--GCM--scenario
combinations.

For each row in \code{file_url_df}, the function:

\enumerate{
  \item reads the raster using \code{terra::rast()},
  \item crops it to \code{study_area} using \code{terra::crop()},
  \item masks it to \code{study_area} using \code{terra::mask()},
  \item writes the result to disk using \code{terra::writeRaster()}
        with \code{filetype = "AAIGrid"}.
}

Output rasters are written into nested folders with structure:

\preformatted{
out_dir/year_range/gcm/scenario/new_filename
}

If an output file already exists, it is skipped.

Parallel execution is implemented with \code{parallel::mclapply()}, so the
function is primarily intended for Unix-like systems such as Linux and macOS.
}
\value{
An invisible list with one element per input row. Each element is a list
containing processing results, including:

\describe{
  \item{\code{ok}}{Logical. Whether processing succeeded.}
  \item{\code{skipped}}{Logical. Whether processing was skipped because the output already existed.}
  \item{\code{out}}{Character. Output file path.}
  \item{\code{src}}{Character. Source raster path or URL.}
  \item{\code{err}}{Character. Error message for failed jobs, if applicable.}
}
}
\examples{
\dontrun{
library(terra)

files <- readLines("envidatS3paths_all.txt")

fd <- extract_chelsa_metadata(files)

grp <- interaction(fd$year_range, fd$gcm, fd$scenario, drop = TRUE)
vars_by_group <- tapply(fd$varname, grp, function(x) unique(x[!is.na(x)]))
common_vars <- Reduce(intersect, vars_by_group)

vars <- common_vars[!grepl("kg", common_vars)]  # remove Koppen-Geiger variables
fd <- fd[fd$varname %in% vars, ]

env_training <- normalize_paths(file.path(wd, spcode, "env_training"))

res <- envproc_chelsa_parallel(
  study_area = study_area,
  file_url_df = fd,
  out_dir = env_training,
  cores = 28
)
}
}
\seealso{
\code{\link[terra]{rast}},
\code{\link[terra]{vect}},
\code{\link[terra]{crop}},
\code{\link[terra]{mask}},
\code{\link[terra]{writeRaster}},
\code{\link[parallel]{mclapply}}
}
\author{
Edvárd Mizsei
}
\keyword{raster}
\keyword{file}
\keyword{utilities}
