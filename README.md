gofastr
============


[![Build
Status](https://travis-ci.org/trinker/gofastr.svg?branch=master)](https://travis-ci.org/trinker/gofastr)
[![Coverage
Status](https://coveralls.io/repos/trinker/gofastr/badge.svg?branch=master)](https://coveralls.io/r/trinker/gofastr?branch=master)
<a href="https://img.shields.io/badge/Version-0.1.0-orange.svg"><img src="https://img.shields.io/badge/Version-0.1.0-orange.svg" alt="Version"/></a>
</p>
<img src="inst/gofastr_logo/r_gofastr.png" width="150" alt="readability Logo">

**gofastr** is designed to do one thing really well...It harnesses the
power of **data.table** and **stringi** to quickly generate **tm**
`DocumentTermMatrix` and `TermDocumentMatrix` data structures.

In my work I often get data in the form of large .csv files. The
`Corpus` structure is an unnecessary step that requires additional run
time. **gofastr** skips this step and uses **data.table** and
**stringi** to quickly make the `DocumentTermMatrix` and
`TermDocumentMatrix` data structures directly.

There are six functions:

<table>
<thead>
<tr class="header">
<th align="left">Function</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><code>q_tdm</code> &amp; <code>q_tdm_stem</code></td>
<td align="left"><code>TermDocumentMatrix</code> from string vector</td>
</tr>
<tr class="even">
<td align="left"><code>q_dtm</code> &amp; <code>q_dtm_stem</code></td>
<td align="left"><code>DocumentTermMatrix</code> from string vector</td>
</tr>
<tr class="odd">
<td align="left"><code>remove_stopwords</code></td>
<td align="left">Remove stopwords and minimal character words from <code>TermDocumentMatrix</code>/<code>DocumentTermMatrix</code></td>
</tr>
<tr class="even">
<td align="left"><code>filter_words</code></td>
<td align="left">Filter words from <code>TermDocumentMatrix</code>/<code>DocumentTermMatrix</code></td>
</tr>
<tr class="odd">
<td align="left"><code>filter_documents</code></td>
<td align="left">Filter documents from a <code>TermDocumentMatrix</code>/<code>DocumentTermMatrix</code></td>
</tr>
<tr class="even">
<td align="left"><code>select_documents</code></td>
<td align="left">Select documents from <code>TermDocumentMatrix</code>/<code>DocumentTermMatrix</code></td>
</tr>
</tbody>
</table>


Table of Contents
============

-   [Installation](#installation)
-   [Contact](#contact)
-   [Examples](#examples)
    -   [Comparing Timings](#comparing-timings)

Installation
============


To download the development version of **gofastr**:

Download the [zip
ball](https://github.com/trinker/gofastr/zipball/master) or [tar
ball](https://github.com/trinker/gofastr/tarball/master), decompress and
run `R CMD INSTALL` on it, or use the **pacman** package to install the
development version:

    if (!require("pacman")) install.packages("pacman")
    pacman::p_load_gh("trinker/gofastr")

Contact
=======

You are welcome to: 
* submit suggestions and bug-reports at: <https://github.com/trinker/gofastr/issues> 
* send a pull request on: <https://github.com/trinker/gofastr/> 
* compose a friendly e-mail to: <tyler.rinker@gmail.com>


Examples
========

    library(gofastr)
    (w <-with(presidential_debates_2012, q_dtm(dialogue, paste(time, tot, sep = "_"))))

    ## <<DocumentTermMatrix (documents: 2912, terms: 3368)>>
    ## Non-/sparse entries: 37836/9769780
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

    remove_stopwords(w)

    ## <<DocumentTermMatrix (documents: 2912, terms: 3180)>>
    ## Non-/sparse entries: 19014/9241146
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

    (x <- with(presidential_debates_2012, q_tdm(dialogue, paste(time, tot, sep = "_"))))

    ## <<TermDocumentMatrix (terms: 3368, documents: 2912)>>
    ## Non-/sparse entries: 37836/9769780
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

    remove_stopwords(x)

    ## <<TermDocumentMatrix (terms: 3180, documents: 2912)>>
    ## Non-/sparse entries: 19014/9241146
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

To change weighting...

    tm::weightTfIdf(w)

    ## Warning in tm::weightTfIdf(w): empty document(s): time 1_88.1 time 2_52.1

    ## <<DocumentTermMatrix (documents: 2912, terms: 3368)>>
    ## Non-/sparse entries: 37836/9769780
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency - inverse document frequency (normalized) (tf-idf)

To stem words utilize `q_dtm_stem` and `q_tdm_stem` which utilize
**SnowballC**'s stemmer under the hood.

    (y <-with(presidential_debates_2012, q_dtm_stem(dialogue, paste(time, tot, sep = "_"))))

    ## <<DocumentTermMatrix (documents: 2912, terms: 2495)>>
    ## Non-/sparse entries: 37516/7227924
    ## Sparsity           : 99%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

    remove_stopwords(y)

    ## <<DocumentTermMatrix (documents: 2912, terms: 2334)>>
    ## Non-/sparse entries: 20170/6776438
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

To filter out documents with word counts below a threshhold...

    (z <-with(presidential_debates_2012, q_dtm(dialogue, paste(time, person, sep = "_"))))

    ## <<DocumentTermMatrix (documents: 10, terms: 3368)>>
    ## Non-/sparse entries: 8302/25378
    ## Sparsity           : 75%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

    filter_words(z, 5)

    ## <<DocumentTermMatrix (documents: 10, terms: 959)>>
    ## Non-/sparse entries: 4960/4630
    ## Sparsity           : 48%
    ## Maximal term length: 14
    ## Weighting          : term frequency (tf)

To filter out word counts below a threshhold...

Remember the warning from above...Say good bye...

    tm::weightTfIdf(filter_documents(w))

    ## <<DocumentTermMatrix (documents: 2910, terms: 3368)>>
    ## Non-/sparse entries: 37836/9763044
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency - inverse document frequency (normalized) (tf-idf)

To select only documents matching a regex...

    select_documents(z, 'romney', ignore.case=TRUE)

    ## <<DocumentTermMatrix (documents: 3, terms: 3368)>>
    ## Non-/sparse entries: 3383/6721
    ## Sparsity           : 67%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

    select_documents(z, '^(?!.*romney).*$', ignore.case = TRUE)

    ## <<DocumentTermMatrix (documents: 7, terms: 3368)>>
    ## Non-/sparse entries: 4919/18657
    ## Sparsity           : 79%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

Comparing Timings
-----------------

On a smaller 2912 rows these are the time comparisons between
**gofastr** adn **tm** using `Sys.time`:

    pacman::p_load(gofastr, tm)

    pd <- presidential_debates_2012
    tic <- Sys.time()
    rownames(pd) <- paste("docs", 1:nrow(pd))
    pd[['groups']] <- with(pd, paste(time, tot, sep = "_"))
    pd <- Corpus(DataframeSource(pd[, 5:6, drop=FALSE]))

    (out <- DocumentTermMatrix(pd,
        control = list(
            tokenize=scan_tokenizer,
            stopwords=TRUE,
            removeNumbers = TRUE,
            removePunctuation = TRUE,
            wordLengths=c(3, Inf)
        )
    ) )

    ## <<DocumentTermMatrix (documents: 2912, terms: 3243)>>
    ## Non-/sparse entries: 22420/9421196
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

    difftime(Sys.time(), tic)

    ## Time difference of 6.813922 secs

    tic <- Sys.time()
    x <-with(presidential_debates_2012, q_dtm(dialogue, paste(time, tot, sep = "_")))
    remove_stopwords(x)

    ## <<DocumentTermMatrix (documents: 2912, terms: 3180)>>
    ## Non-/sparse entries: 19014/9241146
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

    difftime(Sys.time(), tic)

    ## Time difference of 1.514115 secs

Here I include stemming:

    pd <- presidential_debates_2012
    tic <- Sys.time()
    rownames(pd) <- paste("docs", 1:nrow(pd))
    pd[['groups']] <- with(pd, paste(time, tot, sep = "_"))
    pd <- Corpus(DataframeSource(pd[, 5:6, drop=FALSE]))
    pd <- tm_map(pd, stemDocument)

    (out <- DocumentTermMatrix(pd,
        control = list(
            tokenize=scan_tokenizer,
            stopwords=TRUE,
            removeNumbers = TRUE,
            removePunctuation = TRUE,
            wordLengths=c(3, Inf)
        )
    ) )

    ## <<DocumentTermMatrix (documents: 2912, terms: 2931)>>
    ## Non-/sparse entries: 22982/8512090
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

    difftime(Sys.time(), tic)

    ## Time difference of 7.004719 secs

    tic <- Sys.time()
    x <-with(presidential_debates_2012, q_dtm_stem(dialogue, paste(time, tot, sep = "_")))
    remove_stopwords(x, stem=TRUE)

    ## <<DocumentTermMatrix (documents: 2912, terms: 2305)>>
    ## Non-/sparse entries: 18420/6693740
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

    difftime(Sys.time(), tic)

    ## Time difference of 1.09792 secs