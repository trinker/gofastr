#' Remove Stopwords from a TermDocumentMatrix/DocumentTermMatrix
#'
#' Remove stopwords and < nchar words from a \code{\link[tm]{TermDocumentMatrix}}
#' or \code{\link[tm]{DocumentTermMatrix}}.
#'
#' @param x A \code{\link[tm]{TermDocumentMatrix}} or \code{\link[tm]{DocumentTermMatrix}}.
#' @param stopwords A vector of stopwords to remove.
#' @param min.char The minial length character for retained words.
#' @return Returns a \code{\link[tm]{TermDocumentMatrix}} or \code{\link[tm]{DocumentTermMatrix}}.
#' @keywords stopwords
#' @export
#' @examples
#' (x <-with(presidential_debates_2012, q_dtm(dialogue, paste(time, tot, sep = "_"))))
#' remove_stopwords(x)
#' (y <- with(presidential_debates_2012, q_tdm(dialogue, paste(time, tot, sep = "_"))))
#' remove_stopwords(y)
remove_stopwords  <- function(x, stopwords = tm::stopwords("english"), min.char = 3) {
    UseMethod("remove_stopwords")
}

#' @export
#' @method remove_stopwords TermDocumentMatrix
remove_stopwords.TermDocumentMatrix  <- function(x, stopwords = tm::stopwords("english"), min.char = 3) {

    if (!is.null(stopwords)){
        x <- x[!rownames(x) %in% stopwords, ]
    }
    if (!is.null(min.char)){
        x <- x[nchar(rownames(x)) > min.char - 1, ]
    }
    x
}

#' @export
#' @method remove_stopwords DocumentTermMatrix
remove_stopwords.DocumentTermMatrix  <- function(x, stopwords = tm::stopwords("english"), min.char = 3) {

    if (!is.null(stopwords)){
        x <- x[, !colnames(x) %in% stopwords]
    }
    if (!is.null(min.char)){
        x <- x[, nchar(colnames(x)) > min.char - 1]
    }
    x
}


