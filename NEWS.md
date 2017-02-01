NEWS
====

Versioning
----------

Releases will be numbered with the following semantic versioning format:

&lt;major&gt;.&lt;minor&gt;.&lt;patch&gt;

And constructed with the following guidelines:

* Breaking backward compatibility bumps the major (and resets the minor
  and patch)
* New additions without breaking backward compatibility bumps the minor
  (and resets the patch)
* Bug fixes and misc changes bumps the patch


gofastr 0.2.0 -
----------------------------------------------------------------

**BUG FIXES**

**NEW FEATURES**

* `ngrams` argument added to `q_dtm` and `q_tdm` to allow ngrams in the matrix
  terms (see isue #3).

* `select_document` picks up an `invert` argument to pick documents not
  containing the regex match.

**MINOR FEATURES**

**IMPROVEMENTS**

**CHANGES**



gofastr 0.1.0 - 0.1.1
----------------------------------------------------------------

**NEW FEATURES**

* `partial_republican_debates_2015` data set added.



gofastr 0.0.1
----------------------------------------------------------------

**gofastr** is designed to do one thing really well...It harnesses the power of **data.table** and **stringi** to quickly generate **tm** `DocumentTermMatrix` and `TermDocumentMatrix` data structures.

