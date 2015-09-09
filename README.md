gofastr
============


[![Build
Status](https://travis-ci.org/trinker/gofastr.svg?branch=master)](https://travis-ci.org/trinker/gofastr)
[![Coverage
Status](https://coveralls.io/repos/trinker/gofastr/badge.svg?branch=master)](https://coveralls.io/r/trinker/gofastr?branch=master)
<a href="https://img.shields.io/badge/Version-0.0.1-orange.svg"><img src="https://img.shields.io/badge/Version-0.0.1-orange.svg" alt="Version"/></a>
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

There are three functions:

<table>
<thead>
<tr class="header">
<th align="left">Function</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><code>q_tdm</code></td>
<td align="left"><code>TermDocumentMatrix</code> from string vector</td>
</tr>
<tr class="even">
<td align="left"><code>q_dtm</code></td>
<td align="left"><code>DocumentTermMatrix</code> from string vector</td>
</tr>
<tr class="odd">
<td align="left"><code>remove_stopwords</code></td>
<td align="left">Remove stopwords and minimal character words from <code>TermDocumentMatrix</code>/<code>DocumentTermMatrix</code></td>
</tr>
</tbody>
</table>


Table of Contents
============

-   [Installation](#installation)
-   [Contact](#contact)
-   [Examples](#examples)

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
    (x <-with(presidential_debates_2012, q_dtm(dialogue, paste(time, tot, sep = "_"))))

    ## <<DocumentTermMatrix (documents: 2910, terms: 3368)>>
    ## Non-/sparse entries: 37836/9763044
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

    remove_stopwords(x)

    ## <<DocumentTermMatrix (documents: 2910, terms: 3180)>>
    ## Non-/sparse entries: 19014/9234786
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

    (y <- with(presidential_debates_2012, q_tdm(dialogue, paste(time, tot, sep = "_"))))

    ## <<TermDocumentMatrix (terms: 3368, documents: 2910)>>
    ## Non-/sparse entries: 37836/9763044
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

    remove_stopwords(y)

    ## <<TermDocumentMatrix (terms: 3180, documents: 2910)>>
    ## Non-/sparse entries: 19014/9234786
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)