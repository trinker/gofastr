#' Quick DocumentTermMatrix
#'
#' Make a \code{\link[tm]{DocumentTermMatrix}} from a vector of text and and
#' optional vector of documents.  To stem a document as well use the
#' \code{q_dtm_stem} version of \code{q_dtm} which uses \pkg{SnowballC}'s
#' \code{\link[SnowballC]{wordStem}}.
#'
#' @param text A vector of strings.
#' @param docs A vector of document names.
#' @param to target conversion format, consisting of the name of the package into
#' whose document-term matrix representation the dfm will be converted:
#' \describe{
#' \item{\code{"lda"}}{a list with components "documents" and "vocab" as needed by
#' \code{lda.collapsed.gibbs.sampler} from the \pkg{lda} package}
#' \item{\code{"tm"}}{a \link[tm]{DocumentTermMatrix} from the \pkg{tm} package}
#' \item{\code{"stm"}}{the  format for the \pkg{stm} package}
#' \item{\code{"austin"}}{the \code{wfm} format from the \strong{austin} package}
#' \item{\code{"topicmodels"}}{the "dtm" format as used by the \pkg{topicmodels} package}
#' }
#' @param keep.hyphen logical.  If \code{TRUE} hyphens are retained in the terms
#' (e.g., "math-like" is kept as "math-like"), otherwise they become a split for
#' terms (e.g., "math-like" is converted to "math" & "like").
#' @param ngrams A vector of ngrams (multiple wrds with spaces).  Using this
#' option results in the ngrams that will be retained in the matrix.
#' @param \ldots Additional arguments passed to \code{\link[quanteda]{dfm}}.
#' @return Returns a \code{\link[tm]{DocumentTermMatrix}}.
#' @keywords dtm DocumentTermMatrix
#' @export
#' @seealso \code{\link[quanteda]{dfm}},
#' \code{\link[quanteda]{convert}}
#' @rdname q_dtm
#' @examples
#' (x <- with(presidential_debates_2012, q_dtm(dialogue, paste(time, tot, sep = "_"))))
#' tm::weightTfIdf(x)
#'
#' (x2 <- with(presidential_debates_2012, q_dtm_stem(dialogue, paste(time, tot, sep = "_"))))
#' remove_stopwords(x2, stem=TRUE)
#'
#' bigrams <- c('make sure', 'governor romney', 'mister president',
#'     'united states', 'middle class', 'middle east', 'health care',
#'     'american people', 'dodd frank', 'wall street', 'small business')
#'
#' grep(" ", x$dimnames$Terms, value = TRUE) #no ngrams
#'
#' (x3 <- with(presidential_debates_2012,
#'     q_dtm(dialogue, paste(time, tot, sep = "_"), ngrams = bigrams)
#' ))
#'
#' grep(" ", x3$dimnames$Terms, value = TRUE) #ngrams
q_dtm <- function(text, docs = seq_along(text), to = "tm", keep.hyphen = FALSE,
    ngrams = NULL, ...){

    if (!keep.hyphen) text <- gsub("-", " ", text)
    if (!is.null(ngrams)) {
        ngrams_replace <- gsub('\\s+', 'gofastrseparatorgofastr', ngrams)
        text <- .mgsub(ngrams, ngrams_replace, text)
    }

    if (length(unique(docs)) != length(text)){
        text <- unlist(lapply(split(text, docs), paste, collapse = " "))
        docs <- sort(unique(docs))
    }

    out <- quanteda::convert(quanteda::dfm(text, stem = FALSE, verbose = FALSE, removeNumbers = FALSE, ...), to = to)
    row.names(out) <- docs
    if (!is.null(ngrams))colnames(out) <- gsub('gofastrseparatorgofastr', ' ', colnames(out))

    out
}


# q_dtm <- function(text, docs = seq_along(text), weighting = tm::weightTf, ...){
#     . <- x <- y <- NULL
#
#     dat <- data.table::data.table(y = stringi::stri_trans_tolower(text), x = docs)[,
#         .(y = stringi::stri_extract_all_words(y)), by='x'][, .(y = unlist(y)), by = x] #[!is.na(y),]
#
#     out <- suppressMessages(data.table::dcast(dat, x ~ y, fun=length, drop=FALSE, fill=0))
#     suppressWarnings(out[, 'NA' := NULL])
#
#     out2 <- as.matrix(out[, -1, with = FALSE])
#     row.names(out2) <- out[[1]]
#     tm::as.DocumentTermMatrix(slam::as.simple_triplet_matrix(out2), weighting = weighting, ...)
# }


#' @export
#' @rdname q_dtm
q_dtm_stem <- function(text, docs = seq_along(text), to = "tm", keep.hyphen = FALSE,
    ngrams = NULL, ...){

    if (!keep.hyphen) text <- gsub("-", " ", text)
    if (!is.null(ngrams)) {
        ngrams_replace <- gsub('\\s+', 'gofastrseparatorgofastr', ngrams)
        text <- .mgsub(ngrams, ngrams_replace, text)
    }

    if (length(unique(docs)) != length(text)){
        text <- unlist(lapply(split(text, docs), paste, collapse = " "))
        docs <- sort(unique(docs))
    }

    out <- quanteda::convert(quanteda::dfm(text, stem = TRUE, verbose = FALSE, removeNumbers = FALSE, ...), to = to)
    row.names(out) <- docs
    if (!is.null(ngrams))colnames(out) <- gsub('gofastrseparatorgofastr', ' ', colnames(out))

    out
}


# q_dtm_stem <- function(text, docs = seq_along(text), weighting = tm::weightTf, language = "porter", ...){
#     . <- x <- y <- NULL
#     dat <- data.table::data.table(y = stringi::stri_trans_tolower(text), x = docs)[,
#         .(y = stringi::stri_extract_all_words(y)), by='x'][, .(y = unlist(y)), by = x][, y := SnowballC::wordStem(y, language)]
#     out <- suppressMessages(data.table::dcast(dat, x ~ y, fun=length, drop=FALSE, fill=0))
#     suppressWarnings(out[, 'NA' := NULL])
#
#     out2 <- as.matrix(out[, -1, with = FALSE])
#     row.names(out2) <- out[[1]]
#     tm::as.DocumentTermMatrix(slam::as.simple_triplet_matrix(out2), weighting = weighting, ...)
# }


