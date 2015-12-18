#' Select Documents TermDocumentMatrix/DocumentTermMatrix
#'
#' Select documents from a \code{\link[tm]{TermDocumentMatrix}}
#' or \code{\link[tm]{DocumentTermMatrix}} matching a regular expression.
#'
#' @param x A \code{\link[tm]{TermDocumentMatrix}} or \code{\link[tm]{DocumentTermMatrix}}.
#' @param pattern A regex pattern used to select documents.
#' @param \ldots Other arguments passed to \code{\link[base]{grepl}}
#' (\code{perl = TRUE} is hard coded).
#' @return Returns a \code{\link[tm]{TermDocumentMatrix}} or \code{\link[tm]{DocumentTermMatrix}}.
#' @export
#' @examples
#' (x <-with(presidential_debates_2012, q_dtm(dialogue, paste(time, person, sep = "_"))))
#' select_documents(x, 'romney', ignore.case=TRUE)
#' select_documents(x, '^(?!.*romney).*$', ignore.case = TRUE)
#' (y <- with(presidential_debates_2012, q_tdm(dialogue, paste(time, person, sep = "_"))))
#' select_documents(y, '[2-3]')
select_documents  <- function(x, pattern, ...) {

    UseMethod("select_documents")

}

#' @export
#' @method select_documents TermDocumentMatrix
select_documents.TermDocumentMatrix  <- function(x, pattern, ...) {

    x[, grepl(pattern, colnames(x), perl=TRUE, ...)]

}

#' @export
#' @method select_documents DocumentTermMatrix
select_documents.DocumentTermMatrix  <- function(x, pattern, ...) {

    x[grepl(pattern, rownames(x), perl=TRUE, ...),]

}


