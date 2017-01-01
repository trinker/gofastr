#' Remove Words Below a TF-IDF Threshold from a TermDocumentMatrix/DocumentTermMatrix
#'
#' Remove words from a \code{\link[tm]{TermDocumentMatrix}}
#' or \code{\link[tm]{DocumentTermMatrix}} not meeting a tf-idf threshold.  Code
#' is based on Gruen & Hornik's (2011) code but allows for easier chaining and
#' extends the filtering to a \code{\link[tm]{TermDocumentMatrix}}.  This can be
#' used to remove words that appear too frequently in a corpus, therefore these
#' words do not carry much information.
#'
#' @param x A \code{\link[tm]{TermDocumentMatrix}} or \code{\link[tm]{DocumentTermMatrix}}.
#' @param min A minimal threshold that a word tf-idf must exceed.  If \code{min = NULL}
#' the median of the tf-idf will be used.
#' @param verbose logical.  If \code{TRUE} the summary stats from the tf-idf are
#' printed.  This can be useful for exploration and setting the \code{min} value.
#' @return Returns a \code{\link[tm]{TermDocumentMatrix}} or \code{\link[tm]{DocumentTermMatrix}}.
#' @author Bettina Gr\"{u}n, Kurt Hornik, and Tyler Rinker <tyler.rinker@@gmail.com>.
#' @export
#' @references Bettina Gruen & Kurt Hornik (2011). topicmodels: An R Package for
#' Fitting Topic Models. Journal of Statistical Software, 40(13), 1-30.
#' \url{http://www.jstatsoft.org/article/view/v040i13/v40i13.pdf}
#' @examples
#' (x <-with(presidential_debates_2012, q_dtm(dialogue, paste(person, time, sep = "_"))))
#' filter_tf_idf(x)
#' filter_tf_idf(x, .5)
#' filter_tf_idf(x, verbose=TRUE)
#' (y <- with(presidential_debates_2012, q_tdm(dialogue, paste(person, time, sep = "_"))))
#' filter_tf_idf(y)
filter_tf_idf <- function(x, min = NULL, verbose = FALSE){

    UseMethod("filter_tf_idf")
}

#' @export
#' @method filter_tf_idf DocumentTermMatrix
filter_tf_idf.DocumentTermMatrix <- function(x, min = NULL, verbose = FALSE){

    term_tfidf <- tapply(x$v/slam::row_sums(x)[x$i], x$j, mean) *
            log2(tm::nDocs(x)/slam::col_sums(x > 0))

    if (is.null(min)) {
        min <- stats::median(term_tfidf)
    }
    if (isTRUE(verbose)) {
        cat("Summary stats for the tf-idf:\n\n")
        print(summary(term_tfidf))
        cat(sprintf("\n%s used for `min`\n\n", round(min, 5)))
    }
    x[, term_tfidf >= min]
}

#' @export
#' @method filter_tf_idf TermDocumentMatrix
filter_tf_idf.TermDocumentMatrix  <- function(x, min = NULL, verbose = FALSE){

    term_tfidf <- tapply(x$v/slam::col_sums(x)[x$j], x$i, mean) *
            log2(tm::nDocs(x)/slam::row_sums(x > 0))

    if (is.null(min)) {
        min <- stats::median(term_tfidf)
    }
    if (isTRUE(verbose)) {
        cat("Summary stats for the tf-idf:\n\n")
        print(summary(term_tfidf))
        cat(sprintf("\n%s used for `min`\n\n", round(min, 5)))
    }
    x[term_tfidf >= min, ]
}
