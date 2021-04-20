### DCP Lab Week 11

library(rvest)

## Exercise 3
# define strings
string <- c("this is", "a string", "vector", "this")

# match “this”
grep(pattern = "this", string)

# match “this”
grepl(pattern = "this", string)

# replaces all “s” for a “k”
gsub(pattern = "s", replacement = "k", string)

# split the words in a sentence, check the data type
strsplit(string, " ")

# define another string
dates <- c("1999-05-23", "2001-12-30", "2004-12-17")

# split string returns a list
strsplit(dates, "-")

# replaces all “-” for a “ ”
gsub(pattern = "-", replacement = " ", dates)

## Exercise 4
# 2
url <- "http://www.ieeessci2020.org/index.html"

# 3
content_page <- read_html(url)

# 4
h1 <- html_elements(content_page, "h1")

# 5
h1 %>% html_text()

# 6
h2 <- html_elements(content_page, "h2")

# 7
h2 %>%
    html_text() %>%
    grep(pattern = "Coronavirus", ignore.case = T, value = T)

# 8
p <- html_elements(content_page, "p")

# 9
p %>%
    html_text() %>%
    grep(pattern = "Coronavirus", ignore.case = T, value = T)

# 10

# 11
table <- html_elements(content_page, "table")

# 12
table %>% html_text()

# 13
table %>% html_text() %>% gsub(pattern = "\n", replacement = "")

# 14
