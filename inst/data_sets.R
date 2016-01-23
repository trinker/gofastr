if (!require("pacman")) install.packages("pacman")
pacman::p_load(rvest, magrittr, xml2)

debates <- c(
    wisconsin = "110908",
    boulder = "110906",
    california = "110756",
    ohio = "110489"
)

partial_republican_debates_2015 <- lapply(debates, function(x){
    xml2::read_html(paste0("http://www.presidency.ucsb.edu/ws/index.php?pid=", x)) %>%
        rvest::html_nodes("p") %>%
        rvest::html_text() %>%
        textshape::split_index(., grep("^[A-Z]+:", .)) %>%
        #textshape::split_match("^[A-Z]+:", TRUE, TRUE) %>% #equal to line above
        textshape::combine() %>%
        textshape::split_transcript() %>%
        textshape::split_sentence()
}) %>%
    textshape::bind_list("location") %>%
    dplyr::mutate(dialogue = qdapRegex::rm_non_ascii(dialogue))


