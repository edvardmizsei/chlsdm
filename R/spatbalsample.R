#' Spatially Balanced Resampling
#'
#' This function performs spatially balanced resampling of input data, ensuring that selected points are not too close to each other based on a defined buffer distance. The coordinates expected to be in WGS84 decimal format.
#'
#' @param data A data frame containing at least two columns: 'x' and 'y' coordinates.
#' @param buffer Numeric, buffer distance within which points should be excluded. Default is 0.1.
#' @param reps Numeric, the number of repetitions for sampling. Default is 1000.
#' @return A data frame containing the selected points.
#' @examples
#' data <- data.frame(x = runif(100), y = runif(100))
#' result <- spatbalsample(data)
#' print(result)
spatbalsample <- function(data, buffer = 0.1, reps = 1000) {
    # Make list of suitable vectors
  suitable <- list()
  
  for (k in 1:reps) {
    # Make the output vector
    outvec <- as.numeric(c())
    # Make the vector of dropped (buffered out) points
    dropvec <- c()
    
    for (i in 1:nrow(data)) {
      # Stop running when all points exhausted
      if (length(dropvec) < nrow(data)) {
        # Set the rows to sample from
        if (i > 1) {
          rowsleft <- (1:nrow(data))[-c(dropvec)]
        } else {
          rowsleft <- 1:nrow(data)
        }
        
        # Randomly select point
        outpoint <- as.numeric(sample(as.character(rowsleft), 1))
        outvec[i] <- outpoint
        
        # Remove points within buffer
        outcoord <- data[outpoint, c("x", "y")]
        dropvec <- c(dropvec, which(sqrt((data$x - outcoord$x)^2 + (data$y - outcoord$y)^2) < buffer))
        
        # Remove unnecessary duplicates in the buffered points
        dropvec <- dropvec[!duplicated(dropvec)]
      } 
    } 
    
    # Populate the suitable points list
    suitable[[k]] <- outvec
  }
  
  # Go through the iterations and pick a list with the most data
  best <- unlist(suitable[which.max(lapply(suitable, length))])
  
  # Return the selected subset of the data
  return(data[best, ])
}
