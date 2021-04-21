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

library(rvest)

#' ##################### Part 1 #####################
## 1
# store the url in a vector
url <- "https://en.wikipedia.org/wiki/List_of_World_Heritage_in_Danger"

# read the raw data from web
raw_page <- read_html(url)

## 2
table_legend <- html_elements("dl")

## 3
list_endg <- html_elements(".wikitable")

## 4
all_link <- c("")
page_link <- html_elements(all_link)

#' ##################### Part 2 #####################

#' ##################### Part 3 #####################
