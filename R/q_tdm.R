#' Quick TermDocumentMatrix
#'
#' Make a \code{\link[tm]{TermDocumentMatrix}} from a vector of text and and
#' optional vector of documents.  To stem a document as well use the
#' \code{q_tdm_stem} version of \code{q_tdm} which uses \pkg{SnowballC}'s
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
#' @param \ldots Additional arguments passed to \code{\link[quanteda]{dfm}}
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
q_tdm <- function(text, docs = seq_along(text), to = "tm", keep.hyphen = FALSE, ...){

    t(q_dtm(text = text, docs = docs, to = to, keep.hyphen = keep.hyphen, ...))

}


#' @export
#' @rdname q_tdm
q_tdm_stem <- function(text, docs = seq_along(text), to = "tm", keep.hyphen = FALSE, ...){

    t(q_dtm_stem(text = text, docs = docs, to = to, keep.hyphen = keep.hyphen, ...))

}

