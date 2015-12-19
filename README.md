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


Table of Contents
============

-   [Function Usage](#function-usage)
-   [Installation](#installation)
-   [Contact](#contact)
-   [Demonstration](#demonstration)
    -   [Load Packages](#load-packages)
    -   [DocumentTerm/TermDocument Matrices](#documenttermtermdocument-matrices)
    -   [Stopwords](#stopwords)
    -   [Weighting](#weighting)
    -   [Stemming](#stemming)
    -   [Manipulating Words](#manipulating-words)
        -   [Filter Out Low Occurring Words](#filter-out-low-occurring-words)
        -   [Filter Out High Frequency (low information) Words](#filter-out-high-frequency-(low-information)-words)
    -   [Manipulating Documents](#manipulating-documents)
        -   [Filter Out Low Occurring Documents](#filter-out-low-occurring-documents)
        -   [Selecting Documents](#selecting-documents)
    -   [Putting It Together](#putting-it-together)
    -   [Comparing Timings](#comparing-timings)
        -   [With Stemming](#with-stemming)

Function Usage
============


Functions typically fall into the task category of matrix (1) creation &
(2) manipulating. The main functions, task category, & descriptions are
summarized in the table below:

<table>
<thead>
<tr class="header">
<th align="left">Function</th>
<th align="left">Category</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><code>q_tdm</code> &amp; <code>q_tdm_stem</code></td>
<td align="left">creation</td>
<td align="left"><code>TermDocumentMatrix</code> from string vector</td>
</tr>
<tr class="even">
<td align="left"><code>q_dtm</code> &amp; <code>q_dtm_stem</code></td>
<td align="left">creation</td>
<td align="left"><code>DocumentTermMatrix</code> from string vector</td>
</tr>
<tr class="odd">
<td align="left"><code>remove_stopwords</code></td>
<td align="left">manipulation</td>
<td align="left">Remove stopwords and minimal character words from <code>TermDocumentMatrix</code>/<code>DocumentTermMatrix</code></td>
</tr>
<tr class="even">
<td align="left"><code>filter_words</code></td>
<td align="left">manipulation</td>
<td align="left">Filter words from <code>TermDocumentMatrix</code>/<code>DocumentTermMatrix</code></td>
</tr>
<tr class="odd">
<td align="left"><code>filter_tf_idf</code></td>
<td align="left">manipulation</td>
<td align="left">Filter low tf_idf words from <code>TermDocumentMatrix</code>/<code>DocumentTermMatrix</code></td>
</tr>
<tr class="even">
<td align="left"><code>filter_documents</code></td>
<td align="left">manipulation</td>
<td align="left">Filter documents from a <code>TermDocumentMatrix</code>/<code>DocumentTermMatrix</code></td>
</tr>
<tr class="odd">
<td align="left"><code>select_documents</code></td>
<td align="left">manipulation</td>
<td align="left">Select documents from <code>TermDocumentMatrix</code>/<code>DocumentTermMatrix</code></td>
</tr>
</tbody>
</table>

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


Demonstration
=============

Load Packages
-------------

    if (!require("pacman")) install.packages("pacman")
    pacman::p_load(gofastr, tm, magrittr)

DocumentTerm/TermDocument Matrices
----------------------------------

    (w <-with(presidential_debates_2012, q_dtm(dialogue, paste(time, tot, sep = "_"))))

    ## <<DocumentTermMatrix (documents: 2912, terms: 3368)>>
    ## Non-/sparse entries: 37836/9769780
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

    (x <- with(presidential_debates_2012, q_tdm(dialogue, paste(time, tot, sep = "_"))))

    ## <<TermDocumentMatrix (terms: 3368, documents: 2912)>>
    ## Non-/sparse entries: 37836/9769780
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

Stopwords
---------

    with(presidential_debates_2012, q_dtm(dialogue, paste(time, tot, sep = "_"))) %>%
        remove_stopwords()

    ## <<DocumentTermMatrix (documents: 2912, terms: 3180)>>
    ## Non-/sparse entries: 19014/9241146
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

    with(presidential_debates_2012, q_tdm(dialogue, paste(time, tot, sep = "_"))) %>%
        remove_stopwords()

    ## <<TermDocumentMatrix (terms: 3180, documents: 2912)>>
    ## Non-/sparse entries: 19014/9241146
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

Weighting
---------

    with(presidential_debates_2012, q_dtm(dialogue, paste(time, tot, sep = "_"))) %>%
        tm::weightTfIdf()

    ## Warning in tm::weightTfIdf(.): empty document(s): time 1_88.1 time 2_52.1

    ## <<DocumentTermMatrix (documents: 2912, terms: 3368)>>
    ## Non-/sparse entries: 37836/9769780
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency - inverse document frequency (normalized) (tf-idf)

Stemming
--------

To stem words utilize `q_dtm_stem` and `q_tdm_stem` which utilize
**SnowballC**'s stemmer under the hood.

    with(presidential_debates_2012, q_dtm_stem(dialogue, paste(time, tot, sep = "_"))) %>%
        remove_stopwords()

    ## <<DocumentTermMatrix (documents: 2912, terms: 2334)>>
    ## Non-/sparse entries: 20170/6776438
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

Manipulating Words
------------------

### Filter Out Low Occurring Words

To filter out words with counts below a threshold we use `filter_words`.

    with(presidential_debates_2012, q_dtm(dialogue, paste(time, person, sep = "_"))) %>%
        filter_words(5)

    ## <<DocumentTermMatrix (documents: 10, terms: 959)>>
    ## Non-/sparse entries: 4960/4630
    ## Sparsity           : 48%
    ## Maximal term length: 14
    ## Weighting          : term frequency (tf)

### Filter Out High Frequency (low information) Words

To filter out words with high frequency in all documents (thus low
informaton) use `filter_tf_idf`.

    with(presidential_debates_2012, q_dtm(dialogue, paste(time, person, sep = "_"))) %>%
        filter_tf_idf(.002)

    ## <<DocumentTermMatrix (documents: 10, terms: 233)>>
    ## Non-/sparse entries: 347/1983
    ## Sparsity           : 85%
    ## Maximal term length: 14
    ## Weighting          : term frequency (tf)

Manipulating Documents
----------------------

### Filter Out Low Occurring Documents

To filter out documents with word counts below a threshold use
`filter_documents`. Remember the warning from above:

> `Warning message:`
> `In tm::weightTfIdf(.) : empty document(s): time 1_88.1 time 2_52.1`

Here we use `filter_documents`' default (a document must have a
rox/column sum greater than 1) to eliminate the warning:

    with(presidential_debates_2012, q_dtm(dialogue, paste(time, tot, sep = "_"))) %>%
        filter_documents() %>%
        tm::weightTfIdf()

    ## <<DocumentTermMatrix (documents: 2910, terms: 3368)>>
    ## Non-/sparse entries: 37836/9763044
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency - inverse document frequency (normalized) (tf-idf)

### Selecting Documents

To select only documents matching a regex use the `select_documents`
function.

    with(presidential_debates_2012, q_dtm(dialogue, paste(time, person, sep = "_"))) %>%
        select_documents('romney', ignore.case=TRUE)

    ## <<DocumentTermMatrix (documents: 3, terms: 3368)>>
    ## Non-/sparse entries: 3383/6721
    ## Sparsity           : 67%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

    with(presidential_debates_2012, q_dtm(dialogue, paste(time, person, sep = "_"))) %>%
        select_documents('^(?!.*romney).*$', ignore.case = TRUE)

    ## <<DocumentTermMatrix (documents: 7, terms: 3368)>>
    ## Non-/sparse entries: 4919/18657
    ## Sparsity           : 79%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

Putting It Together
-------------------

Of course we can chain matrix creation functions with several of the
manipulation function to quickly prepare data for analysis. Here I
demonstrate preparing data for a topic model using \***gofaster** and
then the analysis. Finally, I plot the results and use the **LDAvis**
package to interact with the results:

    pacman::p_load(tm, topicmodels, dplyr, tidyr, gofastr, devtools, LDAvis, ggplot2)

    ## Source topicmodels2LDAvis function
    devtools::source_url("https://gist.githubusercontent.com/trinker/477d7ae65ff6ca73cace/raw/79dbc9d64b17c3c8befde2436fdeb8ec2124b07b/topicmodels2LDAvis")

    ## SHA-1 hash of file is f9a066b61c9f992daff3991a3293e18897268598

    data(presidential_debates_2012)

    # Generate stop words based on short words, frequent words and contractions
    stops <- c(
            tm::stopwords("english"),
            "governor", "president", "mister", "obama","romney"
        ) %>%
        prep_stopwords() 

    ## Create the DocumentTermMatrix
    doc_term_mat <- pres_debates2012 %>%
        with(q_dtm_stem(dialogue, paste(person, time, sep = "_"))) %>%           
        remove_stopwords(stops, min.char = 3, stem = TRUE, denumber = TRUE)%>%                                                     
        filter_tf_idf(.001) %>%
        filter_words(4) %>%                       
        filter_documents() 

    ## Run the Model
    lda_model <- topicmodels::LDA(doc_term_mat, 10)

    ## Plot the Topics Per Person_Time
    topics <- posterior(lda_model, doc_term_mat)$topics
    topic_dat <- add_rownames(as.data.frame(topics), "Person_Time")
    colnames(topic_dat)[-1] <- apply(terms(lda_model, 10), 2, paste, collapse = ", ")

    gather(topic_dat, Topic, Proportion, -c(Person_Time)) %>%
        separate(Person_Time, c("Person", "Time"), sep = "_") %>%
        mutate(Person = factor(Person, 
            levels = c("OBAMA", "ROMNEY", "LEHRER", "SCHIEFFER", "CROWLEY", "QUESTION" ))
        ) %>%
        ggplot(aes(weight=Proportion, x=Topic, fill=Topic)) +
            geom_bar() +
            coord_flip() +
            facet_grid(Person~Time) +
            guides(fill=FALSE)

![](inst/figure/unnamed-chunk-12-1.png)

    ## LDAvis of Model
    lda_model %>%
        topicmodels2LDAvis() %>%
        LDAvis::serVis()

Comparing Timings
-----------------

On a smaller 2912 rows these are the time comparisons between
**gofastr** and **tm** using `Sys.time`:

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

    ## Time difference of 7.104778 secs

    tic <- Sys.time()
    x <-with(presidential_debates_2012, q_dtm(dialogue, paste(time, tot, sep = "_")))
    remove_stopwords(x)

    ## <<DocumentTermMatrix (documents: 2912, terms: 3180)>>
    ## Non-/sparse entries: 19014/9241146
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

    difftime(Sys.time(), tic)

    ## Time difference of 1.680189 secs

### With Stemming

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

    ## Time difference of 5.947203 secs

    tic <- Sys.time()
    x <-with(presidential_debates_2012, q_dtm_stem(dialogue, paste(time, tot, sep = "_")))
    remove_stopwords(x, stem=TRUE)

    ## <<DocumentTermMatrix (documents: 2912, terms: 2305)>>
    ## Non-/sparse entries: 18420/6693740
    ## Sparsity           : 100%
    ## Maximal term length: 16
    ## Weighting          : term frequency (tf)

    difftime(Sys.time(), tic)

    ## Time difference of 0.874619 secs