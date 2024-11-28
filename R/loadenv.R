# Function: loadenv - Load Processed Raster Files into a Stack and Validate Consistency
# Description: This function loads the processed raster files into a raster stack and checks that they have the same dimensions, CRS, and resolution.
loadenv <- function(env_dir, file_ext = "asc") {
  library(terra)
  library(tools)
  
  # List all files with the specified extension in the environmental data directory
  files <- as.data.frame(list.files(env_dir, full.names = TRUE))
  files$ext <- file_ext(files[, 1])
  files <- files[files$ext == file_ext, ]
  files <- files[, 1]
  
  # Load the rasters into a SpatRaster stack
  r_stack <- rast(files)
  
  # Check for consistency in dimensions, CRS, and resolution
  dims <- sapply(r_stack, dim)
  crs_list <- sapply(r_stack, crs)
  res_list <- sapply(r_stack, res)
  
  if (!all(dims == dims[, 1])) {
    stop("Error: Not all rasters have the same dimensions.")
  }
  if (!all(crs_list == crs_list[1])) {
    stop("Error: Not all rasters have the same CRS.")
  }
  if (!all(res_list == res_list[, 1])) {
    stop("Error: Not all rasters have the same resolution.")
  }
  
  return(r_stack)
}

# Example usage for loadenv
# The following code demonstrates how to use loadenv to load and validate processed raster files.
# r_stack <- loadenv("c:/Users/edvar/Dropbox/sdm/envprep/", "asc")
