# Function: envselect - Select Environmental Variables Based on Presence and Background Data
# Description: This function selects relevant environmental variables for SDM by using correlation and VIF-based selection criteria.
envselect <- function(pres, env, folds = 10, cutoff = 0.7) {
  library(fuzzySim)
  library(sf)
  library(terra)
  
  # Extract presence locations
  pres <- pres[, c("x", "y")]
  
  # Generate pseudo-absence locations by sampling from the environment
  psea <- as.data.frame(spatSample(env, nrow(st_as_sf(pres, coords = c("x", "y"), crs = 4326)) * folds, values = FALSE, xy = TRUE))
  
  # Add presence column to differentiate presence (1) and pseudo-absence (0)
  pres$pres <- 1
  psea$pres <- 0
  
  # Combine presence and pseudo-absence data
  pr <- rbind(pres, psea)
  
  # Extract environmental values at presence and pseudo-absence locations
  pa <- extract(env, pr[, c("x", "y")], cells = FALSE, xy = TRUE, raw = FALSE)
  
  # Add presence/absence column to the extracted data
  pa$pres <- as.integer(pr$pres)
  
  # Remove rows with missing values
  pa <- pa[complete.cases(pa), ]
  pa <- pa[, -1]  # Remove cell ID if present
  pa$x <- NULL
  pa$y <- NULL
  
  # Rename environmental variables for easier handling
  names <- colnames(pa)
  colnames(pa)[1:(ncol(pa) - 1)] <- paste0("var", 1:length(colnames(pa)[1:(ncol(pa) - 1)]))
  
  # Perform correlation-based variable selection
  res <- corSelect(pa, sp.cols = ncol(pa), var.cols = 1:(ncol(pa) - 1), cor.thresh = cutoff, select = "VIF")
  
  # Return the names of the selected environmental variables
  return(names[res$selected.var.cols])
}

# Example usage for envselect
# The following code demonstrates how to use envselect to select relevant environmental variables.
# pres <- read.csv("testdata/tesmar.csv")
# env <- loadenv("c:/Users/edvar/Dropbox/sdm/envprep/", "asc")
# selected_vars <- envselect(pres, env, folds = 10, cutoff = 0.7)
# print(selected_vars)
