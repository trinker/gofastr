#' Quick TermDocumentMatrix
#'
#' Make a \code{\link[tm]{TermDocumentMatrix}} from a vector of text and and
#' optional vector of documents.  To stem a document as well use the
#' \code{q_tdm_stem} version of \code{q_tdm} which uses \pkg{SnowballC}'s
#' \code{\link[SnowballC]{wordStem}}.
#'
#' @param text A vector of strings.
#' @param docs An optional vector of document names.
#' @param weighting A \pkg{tm} weighting: \code{\link[tm]{weightTf}},
#' \code{\link[tm]{weightTfIdf}}, \code{\link[tm]{weightBin}}, or
#' \code{\link[tm]{weightSMART}}.
#' @param \ldots Additional arguments passed to \code{\link[tm]{as.TermDocumentMatrix}}.
#' @param language The name of a recognized language (see \code{\link[SnowballC]{wordStem}})
#' @return Returns a \code{\link[tm]{TermDocumentMatrix}}.
#' @keywords tdm TermDocumentMatrix
#' @importFrom data.table :=
#' @export
#' @rdname q_tdm
#' @examples
#' (x <- with(presidential_debates_2012, q_tdm(dialogue, paste(time, tot, sep = "_"))))
#' tm::weightTfIdf(x)
#'
#' (x2 <- with(presidential_debates_2012, q_tdm_stem(dialogue, paste(time, tot, sep = "_"))))
#' remove_stopwords(x2, stem=TRUE)
q_tdm <- function(text, docs = seq_along(text), weighting = tm::weightTf, ...){
    . <- x <- y <- NULL
    dat <- data.table::data.table(y = stringi::stri_trans_tolower(text), x = docs)[,
        .(y = stringi::stri_extract_all_words(y)), by='x'][, .(y = unlist(y)), by = x]
    out <- suppressMessages(data.table::dcast(dat, y~x, fun=length, drop=FALSE, fill=0))[!is.na(y), ]
    out2 <- as.matrix(out[, -1, with = FALSE])
    row.names(out2) <- out[[1]]
    tm::as.TermDocumentMatrix(slam::as.simple_triplet_matrix(out2), weighting = weighting, ...)
}


#' @export
#' @rdname q_tdm
q_tdm_stem <- function(text, docs = seq_along(text), weighting = tm::weightTf, language = "porter", ...){
    . <- x <- y <- NULL
    dat <- data.table::data.table(y = stringi::stri_trans_tolower(text), x = docs)[,
        .(y = stringi::stri_extract_all_words(y)), by='x'][, .(y = unlist(y)), by = x][,
            y := SnowballC::wordStem(y, language)]
    out <- suppressMessages(data.table::dcast(dat, y~x, fun=length, drop=FALSE, fill=0))[!is.na(y), ]
    out2 <- as.matrix(out[, -1, with = FALSE])
    row.names(out2) <- out[[1]]
    tm::as.TermDocumentMatrix(slam::as.simple_triplet_matrix(out2), weighting = weighting, ...)
}


