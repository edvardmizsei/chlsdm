# chlsdm: Species Distribution Modelling Pipeline

The `chlsdm` package provides a comprehensive species distribution modeling pipeline developed by the Conservation Herpetology Lab. This package integrates spatial data processing, outlier removal, environmental variable selection, and species distribution modeling using advanced methods such as BIOMOD2, designed for herpetological conservation studies and beyond.

## Installation

To install the `chlsdm` package, use the following commands:

```r
library(devtools)
install_github("edvardmizsei/chlsdm")
```

## Usage Guide

This guide will walk you through processing presence point data, handling environmental raster data, and fitting species distribution models.

### Step 1: Process Presence Point Data

Begin by importing your species presence data, which should be in WGS84 coordinate system with columns named `x` (longitude) and `y` (latitude).

```r
# Load your presence data
pres <- read.csv("path/to/your/presence_data.csv") # WGS84 coordinates (x = lon, y = lat)

# Spatially balanced resampling of your points
pres2 <- spatbalsample(pres, buffer = 0.1, reps = 100) # Ensures points are not too close to each other

# Remove outlier points based on density estimation
pres3 <- remoutlier(pres2, crs = 4326, threshold = 90) # Removes spatial outliers using kernel density estimation
```

### Step 2: Process Environmental Raster Data

Load and process your environmental raster data. Start by defining your study area and environmental rasters, then prepare them for modeling.

```r
# Load the study area polygon
study_area <- st_read("path/to/your/study_area.shp") # Polygon of your study area

# Crop, mask, and save rasters using the study area
env_dir <- "path/to/environmental/rasters/"
out_dir <- "path/to/output/rasters/"
envproc(study_area, env_dir, "asc", out_dir) # Process and save the environmental rasters

# Load the processed rasters
env <- loadenv(out_dir) # Load the rasters prepared by envproc

# Select relevant environmental variables
envs_selected <- envselect(pres3, env, folds = 10, cutoff = 0.7) # Select variables based on correlation and VIF

# Subset the environmental raster stack with selected variables
env <- subset(env, envs_selected)
```

### Step 3: Fit Species Distribution Models

Fit species distribution models using the BIOMOD2 framework with `chlsdm` to predict species habitat suitability.

```r
# Run the species distribution modeling workflow
mysdm <- chlsdm(pres = pres3, env = env, sp = "My species", envselect = envselect, panum = 4, cvrep = 4, cores = 4)

# Plot the resulting SDM
plot(mysdm)
```

## Function Overview

- **`spatbalsample()`**: Performs spatially balanced sampling to ensure presence points are distributed evenly across space.
- **`remoutlier()`**: Removes outlier points using a kernel density estimation approach to improve the quality of the data.
- **`envproc()`**: Processes environmental raster data by cropping and masking to the study area, then saves the processed layers.
- **`loadenv()`**: Loads processed environmental rasters into a `SpatRaster` stack and checks for consistency.
- **`envselect()`**: Selects environmental variables based on correlation thresholds and variance inflation factors (VIF) to avoid collinearity.
- **`chlsdm()`**: Runs the full SDM pipeline, including pseudo-absence generation, modeling, projection, and ensemble forecasting using BIOMOD2.

## Example Workflow

Here's an example of how to use `chlsdm` to run a full species distribution modeling workflow:

```r
# Load presence data
pres <- read.csv("testdata/tesmar.csv")

# Load and process environmental data
env <- loadenv("c:/Users/edvar/Dropbox/sdm/envprep/", "asc")

# Run the SDM
temporary_dir <- "c:/Users/edvar/temp/"
mysdm <- chlsdm(pres = pres, env = env, sp = "MySpecies", envselect = envselect, panum = 4, cvrep = 4, cores = 4)

# Plot the results
plot(mysdm)
```

## Contributions

This pipeline is a valuable tool for researchers interested in herpetological conservation and spatial ecology. Contributions, suggestions, and improvements are welcome. Please submit issues or pull requests via the GitHub repository.

## License

This package is distributed under the GPL-3 license.
