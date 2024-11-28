# presdatpreparator - Spatially Balanced Resampling and Outlier Removal Combined
# Description: This function performs both spatially balanced resampling and outlier removal on input data within a given study area polygon.
presdatpreparator <- function(data, study_area, buffer = 0.1, reps = 1000, crs = 4326, threshold = 90) {
  library(terra)
  library(sf)
  
  # Ensure study area is an sf object
  study_area_sf <- st_as_sf(study_area)
  
  # Convert input data to sf object
  data_sf <- st_as_sf(data, coords = c("x", "y"), crs = crs)
  
  # Clip the data to the study area
  data_clipped <- st_intersection(data_sf, study_area_sf)
  
  # Convert clipped data to data frame for further processing
  data_clipped_df <- as.data.frame(data_clipped)
  
  # Step 1: Perform spatially balanced resampling
  resampled_data <- spatbalsample(data_clipped_df, buffer = buffer, reps = reps)
  
  # Step 2: Remove outliers using kernel density estimation
  final_data <- remoutlier(resampled_data, crs = crs, threshold = threshold)
  
  return(final_data)
}

# Example usage for presdatpreparator
# The following code demonstrates how to use presdatpreparator to perform both resampling and outlier removal on input data within a study area.
study_area <- st_as_sf(st_sfc(st_polygon(list(rbind(c(0, 0), c(1, 0), c(1, 1), c(0, 1), c(0, 0)))), crs = "EPSG:4326"))
prepared_data <- presdatpreparator(data, study_area)
print(prepared_data)
