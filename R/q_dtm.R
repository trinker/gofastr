#' Quick DocumentTermMatrix
#'
#' Make a \code{\link[tm]{DocumentTermMatrix}} from a vector of text and and
#' optional vector of documents.  To stem a document as well use the
#' \code{q_dtm_stem} version of \code{q_dtm} which uses \pkg{SnowballC}'s
#' \code{\link[SnowballC]{wordStem}}.
#'
#' @param text A vector of strings.
#' @param docs An optional vector of document names.
#' @param weighting A \pkg{tm} weighting: \code{\link[tm]{weightTf}},
#' \code{\link[tm]{weightTfIdf}}, \code{\link[tm]{weightBin}}, or
#' \code{\link[tm]{weightSMART}}.
#' @param \ldots Additional arguments passed to \code{\link[tm]{as.DocumentTermMatrix}}.
#' @param language The name of a recognized language (see \code{\link[SnowballC]{wordStem}}).
#' @return Returns a \code{\link[tm]{DocumentTermMatrix}}.
#' @keywords dtm DocumentTermMatrix
#' @export
#' @rdname q_dtm
#' @importFrom data.table :=
#' @examples
#' (x <- with(presidential_debates_2012, q_dtm(dialogue, paste(time, tot, sep = "_"))))
#' tm::weightTfIdf(x)
#'
#' (x2 <- with(presidential_debates_2012, q_dtm_stem(dialogue, paste(time, tot, sep = "_"))))
#' remove_stopwords(x2, stem=TRUE)
q_dtm <- function(text, docs = seq_along(text), weighting = tm::weightTf, ...){
    . <- x <- y <- NULL

    dat <- data.table::data.table(y = stringi::stri_trans_tolower(text), x = docs)[,
        .(y = stringi::stri_extract_all_words(y)), by='x'][, .(y = unlist(y)), by = x] #[!is.na(y),]

    out <- suppressMessages(data.table::dcast(dat, x ~ y, fun=length, drop=FALSE, fill=0))
    suppressWarnings(out[, 'NA' := NULL])

    out2 <- as.matrix(out[, -1, with = FALSE])
    row.names(out2) <- out[[1]]
    tm::as.DocumentTermMatrix(slam::as.simple_triplet_matrix(out2), weighting = weighting, ...)
}


#' @export
#' @rdname q_dtm
q_dtm_stem <- function(text, docs = seq_along(text), weighting = tm::weightTf, language = "porter", ...){
    . <- x <- y <- NULL
    dat <- data.table::data.table(y = stringi::stri_trans_tolower(text), x = docs)[,
        .(y = stringi::stri_extract_all_words(y)), by='x'][, .(y = unlist(y)), by = x][, y := SnowballC::wordStem(y, language)]
    out <- suppressMessages(data.table::dcast(dat, x ~ y, fun=length, drop=FALSE, fill=0))
    suppressWarnings(out[, 'NA' := NULL])

    out2 <- as.matrix(out[, -1, with = FALSE])
    row.names(out2) <- out[[1]]
    tm::as.DocumentTermMatrix(slam::as.simple_triplet_matrix(out2), weighting = weighting, ...)
}


