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
