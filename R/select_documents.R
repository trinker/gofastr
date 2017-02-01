#' Select Documents rom a TermDocumentMatrix/DocumentTermMatrix
#'
#' Select documents from a \code{\link[tm]{TermDocumentMatrix}}
#' or \code{\link[tm]{DocumentTermMatrix}} matching a regular expression.
#'
#' @param x A \code{\link[tm]{TermDocumentMatrix}} or \code{\link[tm]{DocumentTermMatrix}}.
#' @param pattern A regex pattern used to select documents.
#' @param invert logical.  If \code{TRUE} the pattern is inverted to exclude
#' these documents.
#' @param \ldots Other arguments passed to \code{\link[base]{grepl}}
#' (\code{perl = TRUE} is hard coded).
#' @return Returns a \code{\link[tm]{TermDocumentMatrix}} or \code{\link[tm]{DocumentTermMatrix}}.
#' @export
#' @examples
#' (x <-with(presidential_debates_2012, q_dtm(dialogue, paste(time, person, sep = "_"))))
#' select_documents(x, 'romney', ignore.case=TRUE)
#' select_documents(x, '^(?!.*romney).*$', ignore.case = TRUE)      # regex way to invert
#' select_documents(x, 'romney', ignore.case = TRUE, invert = TRUE) # easier way to invert
#' (y <- with(presidential_debates_2012, q_tdm(dialogue, paste(time, person, sep = "_"))))
#' select_documents(y, '[2-3]')
select_documents  <- function(x, pattern, invert = FALSE, ...) {

    UseMethod("select_documents")

}

#' @export
#' @method select_documents TermDocumentMatrix
select_documents.TermDocumentMatrix  <- function(x, pattern, invert = FALSE, ...) {

    vec <- ifelse(invert, `!`, c)
    x[, vec(grepl(pattern, colnames(x), perl=TRUE, ...))]

}

#' @export
#' @method select_documents DocumentTermMatrix
select_documents.DocumentTermMatrix  <- function(x, pattern, invert = FALSE, ...) {

    vec <- ifelse(invert, `!`, c)
    x[vec(grepl(pattern, rownames(x), perl=TRUE, ...)), ]

}



