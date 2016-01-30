#' Remove Documents Below a Threshold from a TermDocumentMatrix/DocumentTermMatrix
#'
#' Remove documents from a \code{\link[tm]{TermDocumentMatrix}}
#' or \code{\link[tm]{DocumentTermMatrix}} not meeting a \code{\link[base]{rowSums}}/
#' \code{\link[base]{colSums}} threshold.  Useful for removing empty documents.
#'
#' @param x A \code{\link[tm]{TermDocumentMatrix}} or \code{\link[tm]{DocumentTermMatrix}}.
#' @param min A minimal threshold that a documents row/column must sum to.
#' @return Returns a \code{\link[tm]{TermDocumentMatrix}} or \code{\link[tm]{DocumentTermMatrix}}.
#' @export
#' @examples
#' (x <-with(presidential_debates_2012, q_dtm(dialogue, paste(time, tot, sep = "_"))))
#' filter_documents(x)
#' (y <- with(presidential_debates_2012, q_tdm(dialogue, paste(time, tot, sep = "_"))))
#' filter_documents(y)
filter_documents  <- function(x, min = 1) {

    UseMethod("filter_documents")

}

#' @export
#' @method filter_documents TermDocumentMatrix
filter_documents.TermDocumentMatrix  <- function(x, min = 1) {

    x[, slam::col_sums(as.matrix(x)) >= min]

}

#' @export
#' @method filter_documents DocumentTermMatrix
filter_documents.DocumentTermMatrix  <- function(x, min = 1) {

    x[slam::row_sums(as.matrix(x)) >= min, ]

}


