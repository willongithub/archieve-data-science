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
library(tidyverse)

trainer <- read_csv("eda/data/train.csv")
tester <- read_csv("eda/data/test.csv")

colSums(is.na(trainer)) / nrow(trainer)
colSums(is.na(tester)) / nrow(tester)

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
