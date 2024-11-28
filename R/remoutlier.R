# Function to remove outlier coordinates using a density kernel
remoutlier <- function(data, crs=4326, threshold = 90) {
  library(terra)
  library(sf)
  
  # Convert data to sf object
  data_sf <- st_as_sf(data, coords = c("x", "y"), crs = crs)
  
  # Create a terra SpatVector
  data_vect <- vect(data_sf)
  
  # Calculate kernel density estimate
  kde <- density(data_vect, adjust = 1, width = 1000, extent = 0.1)
  
  # Convert the density estimate to polygons representing the threshold percentile (e.g., 90%)
  kde_poly <- as.polygons(kde, levels = threshold / 100)
  
  # Convert polygons to sf object
  kde_poly_sf <- st_as_sf(kde_poly)
  
  # Identify points inside the kernel density polygon
  inside <- st_intersects(data_sf, kde_poly_sf, sparse = FALSE)
  
  # Filter the points that are inside the polygon
  filtered_data <- data[apply(inside, 1, any), ]
  
  return(filtered_data)
}
