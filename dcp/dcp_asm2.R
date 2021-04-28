#' ---
#' title: "Data Capture and Preparations G (11520)"
#' subtitle: "Assignment 2"
#' author: ""
#' date: ""
#' output:
#'   pdf_document:
#'     highlight: breezedark
#'     df_print: kable
#' ---

# loading required libraries
library(rvest)
library(tidyverse)

#' ##################### Part 1 #####################
## 1
# store the url in a vector
url <- "https://en.wikipedia.org/wiki/List_of_World_Heritage_in_Danger"

# load the raw data from web page
raw_page <- read_html(url)

## 2
table_legends <- raw_page %>%
    # load all the descreption list elements from raw html
    html_elements("dl") %>%

    # second item it our target
    .[2] %>%

    # load each descreption
    html_elements("dd") %>%

    # retrive text
    html_text2() %>%

    # get rid of the reference notation at the end
    str_replace_all(pattern = "\\[.*]$", replacement = "") %>%

    # split titles and descriptions and store in a list
    str_split(": ") %>%
    as.list()

## 3
data_list <- raw_page %>%
    # load all the tables from raw html
    html_elements(".wikitable") %>%

    # the first table is endangered list required
    .[1] %>%

    # read it as table
    html_table()

## 4
links <- raw_page %>%
    # load all the links in the page
    html_elements("a")

## 5
new_page <- links %>%
    # find the link with regard to Criteria
    str_which(pattern = "Criteria") %>%

    # there are two identical links, get the fisrt
    .[1] %>%
    links[.] %>%
    # retrive the url
    html_attr("href") %>%

    # convert the relative path to absolute path
    # (same as simple paste in this case)
    url_absolute("https://en.wikipedia.org")

## 6
criteria_list <- vector("list", len = 2)
names(criteria_list) <- c("Cultural", "Natural")

for (i in 1:2) {
    criteria_list[[i]] <- new_page %>%
        read_html() %>%
        html_elements("ol") %>%
        .[i] %>%
        html_elements("li") %>%
        html_text2() %>%
        str_replace_all(pattern = "\\[.*]$", replacement = "") %>%
        str_replace_all(pattern = "\"", replacement = "") %>%
        as.data.frame()
}

#' ##################### Part 2 #####################
## 1
# drop the two undesired column
data_list <- data_list[[1]][, !names(data_list[[1]]) %in% c("Image", "Refs")]

## 2
# generate regex for different scenarios
re_country <- regex("
            # match country names with specific site locations
            ((?<=,\\s{0,2})[A-Z][^,]*[a-z](?=([,*]?\\s?\\d)|[.]))

            # match country names without specific site locations
            # |([A-Z][^,]*[a-z\\)](?=(\\[.{0,2}\\s?.?])?\\s?\\d))

            |([A-Z][^,]*[a-z\\)](?=(\\[.{4}])?\\s?\\d))

            # |((?<=Jer)[:print:]+(?=\\[.{4}]))
            # match Jerusalem
            ", comments = T)

str_view(a, "(\\[.{4}])?\\s?\\d")

data_list["Location"]

data_list$Location %>%
    str_extract(pattern = re_country) %>%
    str_replace(pattern = "[*]", replacement = " &") %>%
    as.data.frame()

## 3
re_types <- regex("^[:alpha:]+(?=:)")
re_criterias <- regex("(?<=:).*")

data_list["Type"] <- data_list$Criteria %>%
    str_extract(pattern = re_types) %>%
    as.data.frame()

data_list["Criteria"] <- data_list$Criteria %>%
    str_replace_all(pattern = "\\n", replacement = "") %>%
    str_extract(pattern = re_criterias) %>%
    str_replace_all(pattern = ", ", replacement = "") %>%
    as.data.frame()

## 4
names(data_list)[4] <- table_legends[[4]][1]

re_acres <- regex("(?<=[(]).*(?=[)])")

data_list["Area"] <- data_list$Area %>%
    str_extract(pattern = re_acres) %>%
    as.data.frame()

## 5
re_endangered <- regex("[:digit:]{4}.$")

data_list["Endangered"] <- data_list$Endangered %>%
    str_extract(pattern = re_endangered) %>%
    str_replace_all(pattern = ".$", replacement = "") %>%
    as.numeric() %>%
    as.data.frame()

## 6
glimpse(data_list)

#' ##################### Part 3 #####################
## 1
length(which(data_list$Type == "Cultural"))
length(which(data_list$Type == "Natural"))

## 2
data_list$Area %>%
    str_replace_all(pattern = ",", replacement = "") %>%
    as.numeric() %>%
    which.max() %>%
    data_list$Name[.]

data_list$Area %>%
    str_replace_all(pattern = ",", replacement = "") %>%
    as.numeric() %>%
    which.min() %>%
    data_list$Name[.]

## 3
plot <- hist(data_list[["Endangered"]],
     main = "Year of the sites appeared on the List",
     xlab = "year",
     ylab = "frequency",
     ylim = range(0, 20),
     col = "sienna2")
    
text(plot$mids,
     plot$counts,
     labels = plot$counts,
     adj = c(0.5, - 0.5))

## 4
data_list %>%
    group_by(Location) %>%
    summarize(site_count = n()) %>%
    arrange(desc(site_count))

## 5
data_list <- data_list %>%
    mutate(years_before_listed = .[["Endangered"]] - .[["Year (WHS)"]])

## 6
plot <- hist(data_list[["years_before_listed"]],
     main = "Years before the sites appeared on the endangered List",
     xlab = "year",
     ylab = "frequency",
     ylim = range(0, 20),
     col = "sienna2")
    
text(plot$mids,
     plot$counts,
     labels = plot$counts,
     adj = c(0.5, - 0.5))
