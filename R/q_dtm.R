#' Quick DocumentTermMatrix
#'
#' Make a \code{\link[tm]{DocumentTermMatrix}} from a vector of text and and
#' optional vector of documents.
#'
#' @param text A vector of strings.
#' @param docs An optional vector of document names.
#' @param weighting A \pkg{tm} weighting: \code{\link[tm]{weightTf}},
#' \code{\link[tm]{weightTfIdf}}, \code{\link[tm]{weightBin}}, or
#' \code{\link[tm]{weightSMART}}.
#' @param \ldots Additional arguments passed to \code{\link[tm]{as.DocumentTermMatrix}}.
#' @return Returns a \code{\link[tm]{DocumentTermMatrix}}.
#' @keywords dtm DocumentTermMatrix
#' @export
#' @importFrom data.table :=
#' @examples
#' (x <- with(presidential_debates_2012, q_dtm(dialogue, paste(time, tot, sep = "_"))))
#' tm::weightTfIdf(x)
q_dtm <- function(text, docs = seq_along(text), weighting = tm::weightTf, ...){
    . <- x <- y <- NULL
    dat <- data.table::data.table(y = stringi::stri_trans_tolower(text), x = docs)[,
        y := stringi::stri_extract_all_words(y)][, .(y = unlist(y)), by = x][!is.na(y),]
    out <- suppressMessages(data.table::dcast(dat, x ~ y, fun=length, drop=FALSE, fill=0))
    out2 <- as.matrix(out[, -1, with = FALSE])
    row.names(out2) <- out[[1]]
    tm::as.DocumentTermMatrix(slam::as.simple_triplet_matrix(out2), weighting = weighting, ...)
}

