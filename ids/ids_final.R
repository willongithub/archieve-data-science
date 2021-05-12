#' ---
#' title: "Introduction to Data Science G (11516)"
#' subtitle: "Final Assesment"
#' author: ""
#' date: "Semester 1, 2021"
#' output:
#'   pdf_document:
#'     highlight: breezedark
#'     df_print: kable
#' ---

#' ##################### Part B #####################

require(tidyverse)
require(ggplot2)

#' ## Task 1: Data Preparation and Wrangling

#' ### 1
covid19 <- read_csv("Covid19.csv")
tests <- read_csv("Tests.csv")
countries <- read_csv("Countries.csv")
recovered <- read_csv("Recovered.csv")

#' ### 2
recovered <- gather(recovered, key, value, 2:106)

#' ### 3
colnames(covid19) <- c("Code", "Country", "Continent",
                       "Date", "NewCases", "NewDeaths")

colnames(tests) <- c("Code", "Date", "NewTests")

colnames(countries) <- c("Code", "Country", "Population", "GDP", "GDPCapita")

colnames(recovered) <- c("Country", "Date", "Recovered")

#' ### 4
covid19[["Date"]] <- as.Date(covid19[["Date"]], format = "%Y-%m-%d")

tests[["Date"]] <- as.Date(tests[["Date"]], format = "%Y-%m-%d")

recovered[["Date"]] <- recovered[["Date"]] %>%
    str_replace_all("\\.", "-") %>%
    as.Date(format = "%Y-%m-%d")

#' ### 5
covid19 <- covid19 %>%
    merge(recovered, all = T) %>%
    merge(tests, all = T) %>%
    merge(countries, all = T)

a <- countries %>%
    merge(tests, all = T)

colSums(is.na(a))
length(unique(covid19$Country))
covid19 %>%
    filter(is.na(Code))

x <- data.frame(k1 = c(NA,NA,3,4,5), k2 = c(1,NA,NA,4,5), a = 1:5)
y <- data.frame(k1 = c(NA,2,NA,4,5), k2 = c(NA,NA,3,4,5), b = 1:5)
merge(x, y, by = c("k1","k2")) # NA's match
merge(x, y, by = "k1") # NA's match, so 6 rows
merge(x, y, by = "k2", incomparables = NA) # 2 rows


#' ### 6
colSums(is.na(covid19))

colSums(is.na(tests))

colSums(is.na(countries))

colSums(is.na(recovered))

covid19[is.na(covid19)] <- 0

#' ### 7
covid19 <- covid19 %>%
    mutate(Week = as.numeric(format(Date, "%W"))) %>%
    mutate(Month = as.numeric(format(Date, "%m")))

#' ## Task 2: Exploratory Data Analysis
View(head(covid19))
#' ### 1
covid19 <- covid19 %>%
    arrange(Date, Country) %>%
    group_by(Country) %>%
    mutate(CumCases = colSums(NewCases))

#' ### 2


#' ### 3


#' ### 4


#' ### 5


#' ### 6


#' ### 7


#' ### 8


#' ### 9


#' ### 10


#' ### 11


#' ### 12


#' ## Task 3: Data-Driven Modeling
#' ### 1


#' ### 2


#' ### 3


#' ### 4


#' ### 5


#' ### 6


#' ### 7

