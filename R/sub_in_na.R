#' Regex Sub to Missing
#'
#' Use a regex to identify elements to sub out for missing \code{NA}.  Useful
#' within a \pkg{magrittr} pipeline before producing the
#' \code{\link[tm]{TermDocumentMatrix}} or \code{\link[tm]{DocumentTermMatrix}}.
#'
#' @param x A vector of text strings.
#' @param regex A regex to match strings in a vector.
#' @param \ldots Other arguments passed to \code{\link[base]{grepl}}
#' @return Returns a vector with \code{NA}s inserted.
#' @export
#' @examples
#' x <- c("45", "..", "", "   ", "dog")
#' sub_in_na(x)
#' sub_in_na(x, "^\\s*$")
#'
#' \dontrun{
#' library(tidyverse)
#' x %>%
#'     q_dtm() %>%
#'     as.matrix()
#'
#' x %>%
#'     sub_in_na() %>%
#'     q_dtm() %>%
#'     as.matrix()
#' }
sub_in_na <- function(x, regex = "^[^A-Za-z]*$", ...){
  x <- unlist(x)
  x[grepl(regex, x, ...)] <- NA
  x
}
