#' Remove Words Below a Threshhold TermDocumentMatrix/DocumentTermMatrix
#'
#' Remove words from a \code{\link[tm]{TermDocumentMatrix}}
#' or \code{\link[tm]{DocumentTermMatrix}} not meeting a \code{\link[base]{rowSums}}/
#' \code{\link[base]{colSums}} threshhold.
#'
#' @param x A \code{\link[tm]{TermDocumentMatrix}} or \code{\link[tm]{DocumentTermMatrix}}.
#' @param min A minimal threshhold that a words row/column must sum to.
#' @return Returns a \code{\link[tm]{TermDocumentMatrix}} or \code{\link[tm]{DocumentTermMatrix}}.
#' @export
#' @examples
#' (x <-with(presidential_debates_2012, q_dtm(dialogue, paste(time, tot, sep = "_"))))
#' filter_words(x)
#' filter_words(x, 5)
#' (y <- with(presidential_debates_2012, q_tdm(dialogue, paste(time, tot, sep = "_"))))
#' filter_words(y, 6)
filter_words  <- function(x, min = 1) {

    UseMethod("filter_words")

}

#' @export
#' @method filter_words TermDocumentMatrix
filter_words.TermDocumentMatrix  <- function(x, min = 1) {

    x[rowSums(as.matrix(x)) >= min, ]

}

#' @export
#' @method filter_words DocumentTermMatrix
filter_words.DocumentTermMatrix  <- function(x, min = 1) {

    x[, colSums(as.matrix(x)) >= min]

}


