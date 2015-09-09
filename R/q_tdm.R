#' Quick TermDocumentMatrix
#'
#' Make a \code{\link[tm]{TermDocumentMatrix}} from a vector of text and and
#' optional vector of documents.
#'
#' @param text A vector of strings.
#' @param docs An optional vector of document names.
#' @param weighting A \pkg{tm} weighting: \code{\link[tm]{weightTf}},
#' \code{\link[tm]{weightTfIdf}}, \code{\link[tm]{weightBin}}, or
#' \code{\link[tm]{weightSMART}}.
#' @param \ldots Additional arguments passed to \code{\link[tm]{as.TermDocumentMatrix}}.
#' @return Returns a \code{\link[tm]{TermDocumentMatrix}}.
#' @keywords tdm TermDocumentMatrix
#' @importFrom data.table :=
#' @export
#' @examples
#' with(presidential_debates_2012, q_tdm(dialogue, paste(time, tot, sep = "_")))
q_tdm <- function(text, docs = seq_along(text), weighting = tm::weightTf, ...){
    . <- x <- y <- NULL
    dat <- data.table::data.table(y = stringi::stri_trans_tolower(text), x = docs)[,
        y := stringi::stri_extract_all_words(y)][, .(y = unlist(y)), by = x][!is.na(y),]
    out <- suppressMessages(data.table::dcast(dat, y~x, fun=length, drop=FALSE, fill=0))
    out2 <- as.matrix(out[, -1, with = FALSE])
    row.names(out2) <- out[[1]]
    tm::as.TermDocumentMatrix(slam::as.simple_triplet_matrix(out2), weighting = weighting, ...)
}

