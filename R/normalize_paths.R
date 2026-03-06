normalize_paths <- function(x) {
  # flatten data.frame / list to character
  x <- unlist(x, use.names = FALSE)
  x <- as.character(x)
  
  # if it's a single long blob (often happens), extract all URLs with regex
  if (length(x) == 1L && grepl("https?://", x)) {
    m <- gregexpr("https?://[^\\s\",]+", x, perl = TRUE)
    x <- regmatches(x, m)[[1]]
  }
  
  # trim + drop empties
  x <- trimws(x)
  x[nchar(x) > 0]
}
