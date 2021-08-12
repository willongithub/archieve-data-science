#' ---
#' title: "Data Capture and Preparations G (11520)"
#' subtitle: "End-of-Semester Test"
#' author: ""
#' date: ""
#' output:
#'   pdf_document:
#'     highlight: breezedark
#'     df_print: kable
#' ---

require(tidyverse)
require(ggplot2)
require(rvest)

#' ## Topic 2
#' ### 8
# test set
words <- c("Africa", "identical", "ending", "rain", "Friday", "transport")

# vector for vowels (did not include "y")
vowels <- c("a", "e", "i", "o", "u")

for (item in words) {
    # first delete items with non-vowel begining letter
    if (!tolower(substring(item, 1, 1)) %in% vowels) {
        words <- words[-which(words == item)]
    # then print those longer than 5
    } else if (nchar(item) > 5) {
        print(item)
    }
}

# check result
View(words)

#' ## Topic 3
#' ### 17
# original set
data <- tibble(
    name = c("Carl", "Josh", "Laura"),
    wt_Tuesday_5pm = c(100, 150, 140),
    wt_Wednesay_3pm = c(104, 155, 138),
    wt_Friday_9m = c(NA, 160, 142)
)

data <- data %>%
    # fix the names (the time of friday is incomplete)
    rename(friday_9 = wt_Friday_9m,
           wednesday_3pm = wt_Wednesay_3pm,
           tuesday_5pm = wt_Tuesday_5pm) %>%
    # transfer from wide to long
    gather(time, weight, 2:4) %>%
    # separate the day of week and time
    separate(col = time, into = c("day", "time")) %>%
    # convert from lbs to kgs
    mutate(weight = weight * 0.45359)

# get average weight
data %>% summarize(avg_weight = mean(weight, na.rm = T))

#' ### 18
# solution from lab
# retrive data
url <- "https://extranet.who.int/tme/generateCSV.asp?ds=notifications"
data <- read_csv(url)

# convert from wide to long
start <- colnames(data)[7]
end <- colnames(data)[ncol(data)]
data2 <- gather(data, "key", "cases", all_of(start):all_of(end), na.rm = T)

# fix inconsistent names
pattern <- c("newrel" = "new_rel")
data2 <- data2 %>% mutate(key = str_replace_all(key, pattern))

# filter entries with age info
data3 <- data2 %>% filter(str_detect(key, "[0-9]"))

# separate the key into three column
data4 <- data3 %>% separate(key, c("new", "type", "sexage"))

# split sex and age
data5 <- data4 %>% separate(sexage, c("sex", "age"), sep = 1)

# remove redundant columns
data6 <- data5 %>% select(-c("new", "iso2", "iso3"))

# q18
# obtain total number for each country, year and sex
data7 <- data6 %>%
    group_by(country, year, sex) %>%
    summarize(cases = sum(cases))

# consider 2015 and newer cases, only male and female
data8 <- data7 %>%
    filter(year >= 2015) %>%
    filter(sex %in% c("m", "f")) %>%
    group_by(year, sex) %>%
    summarize(cases = sum(cases))

# plot for each gender
data8 %>%
    ggplot(aes(year, cases, group = sex, col = sex)) +
        geom_line() +
        ggtitle("# of Tuberculosis Cases per Gender") +
        theme(plot.title = element_text(hjust = 0.5, face = "bold"))

#' ## Topic 4
#' ### 20
# load the raw data from web page
url <- "https://www.amazon.com.au/s?k=Apple+iPhone+X+Space+Grey+256GB&i=electronics&ref=nb_sb_noss"
raw_page <- read_html(url)

# obtain link of the target page
links <- raw_page %>%
    html_elements("a")
    
page <- links %>%
    grep(pattern = "SIM-Free.+Premium-Renewed.+X.+Space.+Grey.+256") %>%
    .[1] %>%
    links[.] %>%
    html_attr("href") %>%
    url_absolute("https://www.amazon.com.au")

# load the raw data from target page
raw_page <- read_html(page)

# scrape required elements
title <- raw_page %>%
    html_elements("h1") %>%
    .[1] %>%
    html_text2()

rating <- raw_page %>%
    html_elements("i") %>%
    .[13] %>%
    html_text2()

price <- raw_page %>%
    html_elements("table") %>%
    .[2] %>%
    html_elements("td") %>%
    html_text2() %>%
    paste(collapse = " ")

size <- raw_page %>%
    html_elements("form") %>%
    .[5] %>%
    html_elements(".a-row") %>%
    .[1] %>%
    html_text2()

colour <- raw_page %>%
    html_elements("form") %>%
    .[5] %>%
    html_elements(".a-row") %>%
    .[2] %>%
    html_text2()

list <- raw_page %>%
    html_elements("ul") %>%
    .[7] %>%
    html_elements("li") %>%
    html_text2() %>%
    paste(collapse = "; ")

# initialize the tibble
info_tibble <- tibble_row()

# column names of the tibble
column_names <- c("title", "rating", "price", "size", "colour", "list")

# store the data in the tibble
for (item in column_names) {
    info_tibble[[item]] <- get(item)
}

#' ### 21
text <- "“An apple weights 250 grms, a mango weights 525 grms, in total they weight 773 grms."

# a)
weights <- text %>%
    str_extract_all(pattern = "(?<=weights\\s)[[:digit:]]{3}\\sgrms")

# b)
names <- text %>%
    str_extract_all(pattern = "\\b\\w+(?=\\sweights)")
