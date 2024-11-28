# Function: envproc - Process Environmental Data for SDM
# Description: This function processes environmental data layers within a given study area, including cropping, masking, and projecting.
envproc <- function(study_area, env_dir, file_ext = "asc", out_dir) {
  library(terra)
  library(sf)
  library(tools)

  # List all files with the specified extension in the environmental data directory
  files <- as.data.frame(list.files(env_dir, full.names = TRUE))
  files$ext <- file_ext(files[, 1])
  files <- files[files$ext == file_ext, ]
  files <- files[, 1]
  
  # Initialize variables for storing processed rasters
  i <- 1
  for (i in 1:length(files)) {
    rr <- rast(files[i])
    rr <- crop(rr, vect(study_area))
    rr <- mask(rr, vect(study_area))

    # Write the processed rasters to the output directory
    writeRaster(rr, paste0(out_dir, names(rr), ".asc"), filetype = "AAIGrid",overwrite=T)
  }
}

# Example usage for envproc
# The following code demonstrates how to use envproc to process environmental data for a study area.
# envproc("balkans_administrative_dissolved.shp", "c:/Users/edvar/Documents/chelsa_cur2/", "asc", "c:/Users/edvar/Dropbox/sdm/envprep/")
