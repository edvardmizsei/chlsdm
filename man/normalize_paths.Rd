\name{normalize_paths}
\alias{normalize_paths}
\title{Normalize and Extract File Paths or URLs}
\description{
Normalizes a vector of file paths or URLs by flattening inputs, extracting
URLs from text blobs, trimming whitespace, and removing empty elements.
This helper function is useful when ingesting file lists that may come from
text files, data frames, or pasted strings.
}
\usage{
normalize_paths(x)
}
\arguments{
  \item{x}{
An object containing file paths or URLs. This may be a character vector,
list, data frame column, or a single text string containing multiple URLs.
}
}
\details{
The function performs several normalization steps:

\enumerate{
  \item Flattens the input using \code{unlist()} so lists or data frames
  become a character vector.
  \item Converts all elements to character strings.
  \item If the input consists of a single long string containing URLs
  (a common case when copying from text files or web listings), URLs
  are extracted using a regular expression.
  \item Leading and trailing whitespace is removed using
  \code{trimws()}.
  \item Empty elements are discarded.
}

This function is particularly useful in workflows that process large
lists of environmental raster URLs (e.g., CHELSA datasets) prior to
metadata extraction or raster processing.
}
\value{
A cleaned character vector of file paths or URLs.
}
\examples{
\dontrun{

# simple vector
normalize_paths(c(" file1.tif ", "file2.tif"))

# from a data frame column
df <- data.frame(paths = c("a.tif", "b.tif"))
normalize_paths(df$paths)

# extract URLs from a text blob
txt <- "download https://example.org/file1.tif and https://example.org/file2.tif"
normalize_paths(txt)

}
}
\seealso{
\code{\link{extract_chelsa_metadata}},
\code{\link{envproc_chelsa_parallel}}
}
\author{
Edvárd Mizsei
}
\keyword{utilities}
