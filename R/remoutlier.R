# Function: remoutlier - Removing Outliers Using a Density Kernel
# Description: This function removes outlier coordinates based on kernel density estimation using the terra and sf packages.
remoutlier <- function(data, crs = "EPSG:4326", threshold = 90) {
  library(terra)
  library(sf)
  
  # Convert data to sf object
  data_sf <- st_as_sf(data, coords = c("x", "y"), crs = crs)
  
  # Create a terra SpatVector from sf object
  data_vect <- vect(data_sf)
  
  # Create raster template to determine grid cell size for density calculation
  resolution <- 0.01  # Adjust this value based on the data's extent
  raster_template <- rast(ext(data_vect), resolution = resolution)
  
  # Rasterize the points to create an occurrence raster
  occurrence_raster <- rasterize(data_vect, raster_template, fun = "count", background = 0)
  
  # Apply a focal operation to create a density estimate
  # Define a 3x3 moving window to simulate kernel density
  kernel <- matrix(1, nrow = 3, ncol = 3)
  kde <- focal(occurrence_raster, w = kernel, fun = sum, na.rm = TRUE)
  
  # Define a threshold level to determine inclusion (e.g., values above the 90th percentile)
  threshold_value <- quantile(values(kde), probs = threshold, na.rm = TRUE)
  
  # Convert the raster density to polygons for areas above the threshold
  kde_poly <- as.polygons(kde > threshold_value, dissolve = TRUE)
  
  # Convert polygons to sf object
  kde_poly_sf <- st_as_sf(kde_poly)
  
  # Identify points inside the kernel density polygon
  inside <- st_intersects(data_sf, kde_poly_sf, sparse = FALSE)
  
  # Filter the points that are inside the polygon
  filtered_data <- data[apply(inside, 1, any), ]
  
  return(filtered_data)
}

# Example usage for remoutlier
# The following code demonstrates how to use remoutlier to remove outlier coordinates from input data.
data <- data.frame(x = runif(100), y = runif(100))
filtered_result <- remoutlier(data)
print(filtered_result)
