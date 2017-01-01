#' Remove Stopwords from a TermDocumentMatrix/DocumentTermMatrix
#'
#' \code{remove_stopwords} - Remove stopwords and < nchar words from a
#' \code{\link[tm]{TermDocumentMatrix}} or \code{\link[tm]{DocumentTermMatrix}}.
#'
#' @param x A \code{\link[tm]{TermDocumentMatrix}} or \code{\link[tm]{DocumentTermMatrix}}.
#' @param stopwords A vector of stopwords to remove.
#' @param min.char The minimal length character for retained words.
#' @param max.char The maximum length character for retained words.
#' @param stem Logical.  If \code{TRUE} the \code{stopwords} will be stemmed.
#' @param denumber Logical.  If \code{TRUE} numbers will be excluded.
#' @param \dots \code{\link[base]{vector}}s of words.
#' @return Returns a \code{\link[tm]{TermDocumentMatrix}} or \code{\link[tm]{DocumentTermMatrix}}.
#' @keywords stopwords
#' @rdname remove_stopwords
#' @export
#' @examples
#' (x <-with(presidential_debates_2012, q_dtm(dialogue, paste(time, tot, sep = "_"))))
#' remove_stopwords(x)
#' (y <- with(presidential_debates_2012, q_tdm(dialogue, paste(time, tot, sep = "_"))))
#' remove_stopwords(y)
#'
#' prep_stopwords("the", "ChIcken", "Hello", tm::stopwords("english"), c("John", "Josh"))
remove_stopwords  <- function(x, stopwords = tm::stopwords("english"),
    min.char = 3, max.char = NULL, stem = FALSE, denumber = TRUE) {

    UseMethod("remove_stopwords")

}

#' @export
#' @method remove_stopwords TermDocumentMatrix
remove_stopwords.TermDocumentMatrix  <- function(x, stopwords = tm::stopwords("english"),
    min.char = 3, max.char = NULL, stem = FALSE, denumber = TRUE) {

    if (!is.null(stopwords)){
        if (isTRUE(stem)) stopwords <- stem(stopwords)
        x <- x[!rownames(x) %in% stopwords, ]
    }
    if (!is.null(min.char)){
        x <- x[!is.na(rownames(x)) & nchar(rownames(x)) > min.char - 1, ]
    }
    if (!is.null(max.char)){
        x <- x[!is.na(rownames(x)) & nchar(rownames(x)) < max.char + 1, ]
    }
    if (isTRUE(denumber)){
        x <- x[!grepl(regex_pattern, rownames(x), perl=TRUE), ]
    }
    x
}

#' @export
#' @method remove_stopwords DocumentTermMatrix
remove_stopwords.DocumentTermMatrix  <- function(x, stopwords = tm::stopwords("english"),
    min.char = 3, max.char = NULL, stem = FALSE, denumber = TRUE) {

    if (!is.null(stopwords)){
        if (isTRUE(stem)) stopwords <- stem(stopwords)
        x <- x[, !colnames(x) %in% stopwords]
    }
    if (!is.null(min.char)){
        x <- x[, nchar(colnames(x)) > min.char - 1]
    }
    if (!is.null(max.char)){
        x <- x[, nchar(colnames(x)) < max.char + 1]
    }
    if (isTRUE(denumber)){
        x <- x[, !grepl(regex_pattern, colnames(x), perl=TRUE)]
    }
    x
}

regex_pattern <-"(?<=^| )[-.]*\\d+(?:\\.\\d+)?(?= |\\.?$)|\\d+(?:,\\d{3})+(\\.\\d+)*"


#' Remove Stopwords from a TermDocumentMatrix/DocumentTermMatrix
#'
#' \code{prep_stopwords} - Join multiple vectors of words, convert to lower case,
#' and return sorted unique words.
#'
#' @rdname remove_stopwords
#' @export
prep_stopwords <- function(...){
    sort(unique(tolower(unlist(list(...)))))
}
