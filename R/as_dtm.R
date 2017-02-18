#' Coerce Various Object Into a \code{DocumentTermMatrix}/\code{TermDocumentMatrix}
#'
#' Convenience functions to convert a objects from different packages into either a \code{tm::DocumentTermMatrix} or \code{tm::TermDocumentMatrix} object.  Grouping variables are used as the row/column names for the \code{DocumentTermMatrix}/\code{TermDocumentMatrix}.
#'
#' @param x A data object.
#' @param weighting A weighting function capable of handling a \code{tm::DocumentTermMatrix}. It defaults to \code{weightTf} for term frequency weighting. Available weighting functions shipped with the \pkg{tm} package are \code{weightTf}, \code{weightTfIdf}, \code{weightBin}, and \code{weightSMART}.
#' @param \ldots ignored.
#' @param docs The vector of integers or character strings denoting document
#' columns.
#' @param pos logical.  If \code{TRUE} parts of speech will be used.  If
#' \code{FALSE} the corresponding tokens will be used.
#' @return Returns a \code{tm::DocumentTermMatrix} or \code{tm::TermDocumentMatrix} object.
#' @keywords documenttermmatrix, termdocumentmatrix
#' @export
#' @rdname as_dtm
#' @examples
#' with(partial_republican_debates_2015,
#'     as_dtm(dialogue, paste(location, element_id, sentence_id, sep = "_"))
#' )
#'
#' as_dtm(mtcars)
#' as_dtm(CO2, docs = c('Plant', 'Type', 'Treatment'))
#' \dontrun{
#' ## termco object to DTM/TDM
#' library(termco)
#' as_dtm(markers)
#' as_dtm(markers,weighting = tm::weightTfIdf)
#' as_tdm(markers)
#'
#' cosine_distance <- function (x, ...) {
#'     x <- t(slam::as.simple_triplet_matrix(x))
#'     stats::as.dist(1 - slam::crossprod_simple_triplet_matrix(x)/(sqrt(slam::col_sums(x^2) %*%
#'         t(slam::col_sums(x^2)))))
#' }
#'
#'
#' mod <- hclust(cosine_distance(as_dtm(markers)))
#' plot(mod)
#' rect.hclust(mod, k = 5, border = "red")
#'
#' (clusters <- cutree(mod, 5))
#'
#' ## Parts of speech to DTM/TDM
#' library(tagger)
#' library(dplyr)
#' data(presidential_debates_2012_pos)
#'
#' pos <- presidential_debates_2012_pos %>%
#'     select_tags(c("NN", "NNP", "NNPS", "NNS"))
#'
#' as_dtm(pos_text)
#' as_dtm(pos_text, pos=FALSE)
#'
#' as_tdm(pos_text)
#' as_tdm(pos_text, pos=FALSE)
#'
#' presidential_debates_2012_pos %>%
#'     as_basic() %>%
#'     as_dtm()
#' }
as_dtm <- function(x, weighting = tm::weightTf, docs = NULL, pos = TRUE, ...){
    UseMethod('as_dtm')
}


#' @export
#' @method as_dtm term_count
as_dtm.term_count <- function(x, weighting = tm::weightTf, docs = NULL, pos = TRUE, ...){
    y <- as.matrix(term_cols(x))
    rownames(y) <- paste2(group_cols(x))
    tm::as.DocumentTermMatrix(slam::as.simple_triplet_matrix(y), weighting = weighting)
}

# # @export
# # @method as_dtm tbl_df
# as_dtm.tbl_df <- function(x, weighting = tm::weightTf, ...){
#     tm::as.DocumentTermMatrix(slam::as.simple_triplet_matrix(as.matrix(x)), weighting = weighting)
# }



#' @export
#' @method as_dtm data.frame
as_dtm.data.frame <- function(x, weighting = tm::weightTf, docs = NULL, pos = TRUE, ...){

    x <- as.data.frame(x, stringsAsFactors = FALSE)
    if (!is.null(docs)) {
        if (is.character(docs)) docs <- which(colnames(x) %in% docs)
        nms <- paste2(x[, docs, drop = FALSE], ...)
        ndocs <- setdiff(seq_len(ncol(x)), docs)
    } else {
        ndocs <- seq_len(ncol(x))
        nms <- seq_len(nrow(x))
    }

    stopifnot (!any(!unlist(lapply(x[, ndocs, drop=FALSE], function(y) is.numeric(y) | is.logical(y)))))
    out <- tm::as.DocumentTermMatrix(slam::as.simple_triplet_matrix(as.matrix(x[, ndocs, drop=FALSE])), weighting = weighting)
    rownames(out) <- nms
    out

}


#' @export
#' @method as_dtm matrix
as_dtm.matrix <- function(x, weighting = tm::weightTf, docs = NULL, pos = TRUE, ...){
    stopifnot (!any(!unlist(lapply(x, function(y) is.numeric(y) | is.logical(y)))))
    tm::as.DocumentTermMatrix(slam::as.simple_triplet_matrix(x), weighting = weighting)

}


#' @export
#' @method as_dtm character
as_dtm.character <- function(x, weighting = tm::weightTf, docs = NULL, pos = TRUE, ...){

    tm::weightTfIdf(q_dtm(x, ...))

}



#' @export
#' @method as_dtm count_tags
as_dtm.count_tags <- function(x, weighting = tm::weightTf, docs = NULL, pos = TRUE, ...){

    atts <- attributes(x)
    class(x) <- class(x)[!class(x) %in% "count_tags"]

    y <- as.matrix(x[, atts[['pos.vars']], with = FALSE])
    cols <- colnames(x)[!colnames(x) %in% c(atts[['pos.vars']], 'n.tokens')]
    if (length(cols) == 0) {
        rnms <- seq_len(nrow(y))
    } else {
        rnms <- paste2(x[, cols, with = FALSE])
    }
    rownames(y) <- rnms
    tm::as.DocumentTermMatrix(slam::as.simple_triplet_matrix(y), weighting = weighting)
}


#' @export
#' @method as_dtm tag_pos
as_dtm.tag_pos <- function(x, weighting = tm::weightTf, docs = NULL, pos = TRUE, ...){

    if (isTRUE(pos)) x <- get_pos(x) else x <- get_tokens(x)
    tm::weightTfIdf(q_dtm(x, ...))

}






#' @export
#' @rdname as_dtm
as_tdm <- function(x, weighting = tm::weightTf, docs = NULL, pos = TRUE, ...){
    UseMethod('as_tdm')
}


#' @export
#' @method as_tdm term_count
as_tdm.term_count <- function(x, weighting = tm::weightTf, docs = NULL, pos = TRUE, ...){
    y <- as.matrix(term_cols(x))
    rownames(y) <- paste2(group_cols(x))
    tm::as.TermDocumentMatrix(slam::as.simple_triplet_matrix(t(y)), weighting = weighting)
}

# # @export
# # @method as_tdm tbl_df
# as_tdm.tbl_df <- function(x, weighting = tm::weightTf, ...){
#
#     tm::as.TermDocumentMatrix(slam::as.simple_triplet_matrix(as.matrix(x)), weighting = weighting)
#
# }

#' @export
#' @method as_dtm data.frame
as_tdm.data.frame <- function(x, weighting = tm::weightTf, docs = NULL, pos = TRUE, ...){

    x <- as.data.frame(x, stringsAsFactors = FALSE)
    if (!is.null(docs)) {
        if (is.character(docs)) docs <- which(colnames(x) %in% docs)
        nms <- paste2(x[, docs, drop = FALSE], ...)
        ndocs <- setdiff(seq_len(ncol(x)), docs)
    } else {
        ndocs <- seq_len(ncol(x))
        nms <- seq_len(nrow(x))
    }

    stopifnot (!any(!unlist(lapply(x[, ndocs, drop=FALSE], function(y) is.numeric(y) | is.logical(y)))))
    out <- tm::as.TermDocumentMatrix(slam::as.simple_triplet_matrix(as.matrix(x[, ndocs, drop=FALSE])), weighting = weighting)
    rownames(out) <- nms
    out

}


#' @export
#' @method as_dtm matrix
as_tdm.matrix<- function(x, weighting = tm::weightTf, docs = NULL, pos = TRUE, ...){
    stopifnot (!any(!unlist(lapply(x, function(y) is.numeric(y) | is.logical(y)))))
    tm::as.TermDocumentMatrix(slam::as.simple_triplet_matrix(x), weighting = weighting)

}





#' @export
#' @method as_dtm character
as_tdm.character <- function(x, weighting = tm::weightTf, docs = NULL, pos = TRUE, ...){

    tm::weightTfIdf(q_tdm(x, ...))

}


#' @export
#' @method as_tdm count_tags
as_tdm.count_tags <- function(x, weighting = tm::weightTf, docs = NULL, pos = TRUE, ...){

    atts <- attributes(x)
    class(x) <- class(x)[!class(x) %in% "count_tags"]

    y <- as.matrix(x[, atts[['pos.vars']], with = FALSE])
    cols <- colnames(x)[!colnames(x) %in% c(atts[['pos.vars']], 'n.tokens')]
    if (length(cols) == 0) {
        rnms <- seq_len(nrow(y))
    } else {
        rnms <- paste2(x[, cols, with = FALSE])
    }
    rownames(y) <- rnms
    tm::as.TermDocumentMatrix(slam::as.simple_triplet_matrix(t(y)), weighting = weighting)
}



#' @export
#' @method as_tdm tag_pos
as_tdm.tag_pos <- function(x, weighting = tm::weightTf, docs = NULL, pos = TRUE,  ...){

    if (isTRUE(pos)) x <- get_pos(x) else x <- get_tokens(x)
    tm::weightTfIdf(q_tdm(x, ...))

}

