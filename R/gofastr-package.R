#' Fast DocumentTermMatrix and TermDocumentMatric Creation
#'
#' This package does one thing...It harness the power of \pkg{data.table} and
#' \pkg{stringi} to quickly generate \pkg{tm} \code{\link[tm]{TermDocumentMatrix}}
#' and \code{\link[tm]{DocumentTermMatrix}} data structures without creating a
#' \code{\link[tm]{Corpus}} first.
#' @docType package
#' @name gofastr
#' @aliases gofastr package-gofastr
NULL

#' 2012 U.S. Presidential Debates
#'
#' A dataset containing a cleaned version of all three presidential debates for
#' the 2012 election.
#'
#' @details
#' \itemize{
#'   \item person. The speaker
#'   \item tot. Turn of talk
#'   \item dialogue. The words spoken
#'   \item time. Variable indicating which of the three debates the dialogue is from
#' }
#'
#' @docType data
#' @keywords datasets
#' @name presidential_debates_2012
#' @usage data(presidential_debates_2012)
#' @format A data frame with 2912 rows and 4 variables
NULL
