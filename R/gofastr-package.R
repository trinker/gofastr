#' Fast DocumentTermMatrix and TermDocumentMatrix Creation
#'
#' This package does one thing...It harness the power of \pkg{quanteda},
#' \pkg{data.table} & \pkg{stringi} to quickly generate \pkg{tm}
#' \code{\link[tm]{TermDocumentMatrix}} & \code{\link[tm]{DocumentTermMatrix}}
#' data structures without creating a \code{\link[tm]{Corpus}} first.
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


#' 2015 U.S. Partial Republican Primary Presidential Debates
#'
#' A dataset containing a cleaned version of four primary presidential debates for
#' the 2016 election.
#'
#' @details
#' \itemize{
#'   \item location. Where debate took place
#'   \item person. The speaker
#'   \item dialogue. The words spoken
#'   \item element_id. Original line number (turn of talk) within location
#'   \item sentence_id. Sentence number within \code{element_id}
#' }
#'
#' @docType data
#' @keywords datasets
#' @name partial_republican_debates_2015
#' @usage data(partial_republican_debates_2015)
#' @format A data frame with 7405 rows and 5 variables
#' @references \url{http://www.presidency.ucsb.edu}
NULL
