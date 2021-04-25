#' ---
#' title: "Data Capture and Preparations G (11520)"
#' subtitle: "Assignment 2"
#' author: "Siqi Wu (u3229442)"
#' date: ""
#' output:
#'   pdf_document:
#'     highlight: breezedark
#'     df_print: kable
#' ---

# loading required libraries
library(rvest)

#' ##################### Part 1 #####################
## 1
# store the url in a vector
url <- "https://en.wikipedia.org/wiki/List_of_World_Heritage_in_Danger"

# load the raw data from web page
raw_page <- read_html(url)

## 2
table_legends <- raw_page %>%
    html_elements("dl") %>%
    .[2] %>%
    html_elements("dd") %>%
    html_text2() %>%
    gsub(pattern = "\\[.*]$", replacement = "") %>%
    strsplit(": ") %>%
    as.list()

## 3
edg_list <- raw_page %>%
    html_elements(".wikitable") %>%
    .[1] %>%
    html_table()

## 4
links <- raw_page %>%
    html_elements("a")

## 5
new_page <- links %>%
    grep(pattern = "Criteria", ignore.case = T) %>%
    .[1] %>%
    links[.] %>%
    html_attr("href") %>%
    url_absolute(., "https://en.wikipedia.org")

## 6
crtr_list <- vector("list", len = 2)
names(crtr_list) <- c("Cultural", "Natural")

for (i in 1:2) {
    crtr_list[[i]] <- new_page %>%
        read_html() %>%
        html_elements("ol") %>%
        .[i] %>%
        html_elements("li") %>%
        html_text2() %>%
        gsub(pattern = "\\[.*]$", replacement = "") %>%
        gsub(pattern = "\"", replacement = "") %>%
        as.list()
}

#' ##################### Part 2 #####################
## 1
edg_list <- edg_list[[1]][, !names(edg_list[[1]]) %in% c("Image", "Refs")]

## 2
country_list <- edg_list$Location %>%
    grep(pattern = ", .*")

#' ##################### Part 3 #####################
