#' Regex Sub to Missing
#' 
#' USe a regex to identify elements to sub out for missing \code{NA}.  USeful 
#' within a \pkg{magrittr} pipeline.
#' 
#' @param x A vector.
#' @param regex A regex to match strings in a vector.
#' @param \ldots Other arguments passed to \code{\link[base]{grepl}}
#' @return Returns a vector with \code{NA}s inserted.
#' @export
#' @examples 
#' x <- c("45", "..", "", "   ", "dog")
#' sub_in_na(x)
#' sub_in_na(x, "^\\s*$")
sub_in_na <- function(x, regex = "^[^A-Za-z]*$", ...){
  x <- unlist(x)
  x[grepl(regex, x, ...)] <- NA
  x
}
