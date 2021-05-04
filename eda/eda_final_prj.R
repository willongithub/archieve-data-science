#' ---
#' title: "Exploratory Data Analysis and Visualisation G (11517)"
#' subtitle: "Final Project"
#' author: ""
#' date: "Semester 1 2021"
#' output:
#'   pdf_document:
#'     highlight: breezedark
#'     df_print: kable
#' ---

#' ##################### Part 0 #####################
#' Title and abstract

#' ##################### Part 1 #####################
#' Problem identification



#' ##################### Part 2 #####################
#' Data preprocessing

# loading required libraries
require(tidyverse)
require(ggplot2)
require()

trainer <- read_csv("eda/data/train.csv")
tester <- read_csv("eda/data/test.csv")

a <- colSums(is.na(trainer)) / nrow(trainer)
colSums(is.na(tester))

a <- tibble(a, rownames = names(a))
a <- a[which(a$a > 0), ]

ggplot(a, aes(rownames, a, label = round(a * 100, 2))) +
    geom_col(aes(fill = a)) +
    geom_text(nudge_y = 0.03) +
    scale_y_continuous(labels = scales::percent) +
    scale_fill_viridis_c() +
    theme(axis.text.x = element_text(angle = 45, vjust = 0.5))

out <- boxplot.stats(trainer$SalePrice)$out
out <- (trainer[which(trainer$SalePrice %in% out), ])

#' ##################### Part 3 #####################
#' EDA

#' ##################### Part 4 #####################
#' Further preprocessing

#' ##################### Part 5 #####################
#' Modelling

#' ##################### Part 6 #####################
#' Evaluation

#' ##################### Part 7 #####################
#' Recommendations and final conclutions

#' ##################### Part 8 #####################
#' References
