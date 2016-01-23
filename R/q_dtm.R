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
#' @param regex A regex to match strings in a vector.
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
q_dtm <- function(text, docs = seq_along(text), to = "tm", regex = "^[^A-Za-z]*$", ...){

    if (length(unique(docs)) != length(text)){
        text <- unlist(lapply(split(text, docs), paste, collapse = " "))
        docs <- sort(unique(docs))
    }
#     if (any(grepl(regex, text))) {
#         text <- sub_in_na(text, regex = regex)
#     }

    if (anyNA(text)) {
        text[is.na(text)] <- ""
    }

    out <- quanteda::convert(quanteda::dfm(text, stem = FALSE, verbose = FALSE, ...), to = to)
    row.names(out) <- docs
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
q_dtm_stem <- function(text, docs = seq_along(text), to = "tm", regex = "^[^A-Za-z]*$", ...){

    if (length(unique(docs)) != length(text)){
        text <- unlist(lapply(split(text, docs), paste, collapse = " "))
        docs <- sort(unique(docs))
    }

#     if (any(grepl(regex, text))) {
#         text <- sub_in_na(text, regex = regex)
#     }

    if (anyNA(text)) {
        text[is.na(text)] <- ""
    }

    out <- quanteda::convert(quanteda::dfm(text, stem = TRUE, verbose = FALSE, ...), to = to)
    row.names(out) <- docs
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


