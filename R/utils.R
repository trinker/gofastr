stem <- function(x, language = "porter") SnowballC::wordStem(x, language)

.mgsub <- function (pattern, replacement, text.var, fixed = FALSE,
	order.pattern = fixed, perl = TRUE, ignore.case = TRUE, ...) {

    if (fixed && order.pattern) {
        ord <- rev(order(nchar(pattern)))
        pattern <- pattern[ord]
        if (length(replacement) != 1) replacement <- replacement[ord]
    }
    if (length(replacement) == 1) replacement <- rep(replacement, length(pattern))

    for (i in seq_along(pattern)){
        text.var <- gsub(pattern[i], replacement[i], text.var, fixed = fixed, perl = perl, ignore.case = ignore.case, ...)
    }

    text.var
}


paste2 <- function (multi.columns, sep = ".", handle.na = TRUE, trim = TRUE) {
    if (is.matrix(multi.columns)) {
        multi.columns <- data.frame(multi.columns, stringsAsFactors = FALSE)
    }
    if (trim)
        multi.columns <- lapply(multi.columns, function(x) {
            gsub("^\\s+|\\s+$", "", x)
        })
    if (!is.data.frame(multi.columns) & is.list(multi.columns)) {
        multi.columns <- do.call("cbind", multi.columns)
    }
    if (handle.na) {
        m <- apply(multi.columns, 1, function(x) {
            if (any(is.na(x))) {
                NA
            } else {
                paste(x, collapse = sep)
            }
        })
    } else {
        m <- apply(multi.columns, 1, paste, collapse = sep)
    }
    names(m) <- NULL
    return(m)
}

term_cols <- function(x, ...){

    terms <- ifelse(inherits(x, 'token_count'), "token.vars", "term.vars")
    type <- ifelse(inherits(x, 'token_count'), "token", "term")

    y <- validate_term_count(x, FALSE)
    if (!isTRUE(y)) stop(paste0('`x` does not appear to be a valid `', type, '_count` object.  Was the object altered after creation?'))
    x[unlist(attributes(x)[[terms]])]

}


group_cols <- function(x, ...){

    type <- ifelse(inherits(x, 'token_count'), "token", "term")

    y <- validate_term_count(x, FALSE)
    if (!isTRUE(y)) stop(paste0('`x` does not appear to be a valid `', type, '_count` object.  Was the object altered after creation?'))
    x[unlist(attributes(x)[['group.vars']])]

}

validate_term_count <- function(x, warn = FALSE, ...){

    terms <- ifelse(inherits(x, 'token_count'), "token.vars", "term.vars")
    nwords <- ifelse(inherits(x, 'token_count'), "n.tokens", "n.words")
    type <- ifelse(inherits(x, 'token_count'), "token", "term")

    nms2 <- unlist(list(attributes(x)[[terms]], nwords))
    nms <- unlist(list(attributes(x)[["group.vars"]], nms2))
    check <- all(nms %in% colnames(x)) && all(sapply(x[, nms2], is.numeric))
    check2 <- all(sapply(c("group.vars", terms, "weight", "pretty"), function(y){
        !is.null(attributes(x)[[y]])
    }))
    check3 <- !any(colnames(x) %in% c(nms2, nms, nwords))
    if (!check | !check2 | check3) {
        if (isTRUE(warn)){
            warning(paste0("Does not appear to be a `", type, "_count` object.\n"),
                "  Has the object or column names been altered/added?",
                immediate. = TRUE
            )
        }
        return(FALSE)
    }
    TRUE
}

