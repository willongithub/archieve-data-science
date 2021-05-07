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

In this dataset, there are

#' ##################### Part 1 #####################
#' Problem identification



#' ##################### Part 2 #####################
#' Data preprocessing

# loading required libraries
require(tidyverse)
require(ggplot2)
require(GGally)

trainer <- read_csv("eda/data/train.csv")
tester <- read_csv("eda/data/test.csv")

missing <- colSums(is.na(trainer))
colSums(is.na(tester))

missing %>%
    tibble(rownames = names(.)) %>%
    rename(., na = .) %>%
    filter(na > 0) %>%
    mutate(na = round(na / nrow(trainer) * 100, digit = 2)) %>%
    ggplot(aes(rownames, na, label = na)) +
        ggtitle("Missing value ratio of Variables") +
        ylab("NAs (%)") +
        geom_col(aes(fill = na), show.legend = F) +
        geom_text(nudge_y = 2) +
        scale_fill_viridis_c() +
        theme(axis.text.x = element_text(angle = 45, vjust = 0.5))

# There are 19 variables have missing values. 4 of them over 50%. Those NAs
# are missing features of the house such as alley access and heating. They
# are not error values so no need to imput.

trainer %>%
    .[which(.$SalePrice %in% boxplot.stats(.$SalePrice)$out), ] %>%
    group_by(Neighborhood) %>%
    summarize(count = n())

trainer %>%
    .[which(.$SalePrice %in% boxplot.stats(.$SalePrice)$out), ] %>%
    group_by(YrSold) %>%
    summarize(count = n())

trainer %>%
    .[which(.$SalePrice %in% boxplot.stats(.$SalePrice)$out), ] %>%
    group_by(MSSubClass) %>%
    summarize(count = n())

# For the 61 outliers of price, they show no common

#' ##################### Part 3 #####################
#' EDA
ggplot(trainer, aes(trainer$SalePrice)) +
    geom_histogram(aes(y = ..density..), fill = "lightblue") +
    geom_density(colour = "darkred")

ggplot(trainer, aes(log(trainer$SalePrice))) +
    geom_histogram(aes(y = ..density..), fill = "lightblue") +
    geom_density(colour = "darkred")

trainer %>%
    select_if(is.numeric) %>%
    select(names(which(colSums(is.na(.)) == 0))) %>%
    gather() %>%
    ggplot(aes(value)) +
        geom_histogram(aes(y = ..density..), fill = "lightblue") +
        geom_density(colour = "darkred") +
        facet_wrap(~ key, scales = "free")

match_var_1 <- c("1stFlrSF", "GrLivArea", "TotalBsmtSF")
match_var_2 <- c("OverallQual", "OverallCond", "YearBuilt", "YearRemodAdd")

trainer %>%
    select_if(is.numeric) %>%
    ggcorr()

trainer %>%
    select_if(is.numeric) %>%
    cor() %>%
    order(decreasing=TRUE)[1:10]

trainer %>%
    select(where(is.character), SalePrice) %>%
    select(names(which(colSums(is.na(.)) == 0))) %>%
    gather("column", "value", -SalePrice) %>%
    ggplot(aes(value, SalePrice)) +
        geom_boxplot(aes(fill = value), show.legend = F) +
        scale_fill_viridis_d() +
        facet_wrap(~ column, scales = "free")

trainer %>%
    select(where(is.character), SalePrice) %>%
    gather("column", "value", -SalePrice) %>%
    group_by(column, value) %>%
    summarize(mean_price = mean(SalePrice)) %>%
    ungroup() %>%
    group_by(column) %>%
    summarize(cat_var = sd(mean_price)) %>%
    ungroup() %>%
    ggplot(aes(reorder(column, -cat_var), cat_var, fill = cat_var)) +
        geom_col(show.legend = F) +
        scale_fill_viridis_c() +
        theme(axis.text.x = element_text(angle = 45, vjust = 0.5))

cat_group_1 <- c("Heighborhood")
cat_group_2 <- c("ExterQual")

#' ##################### Part 4 #####################
#' Further preprocessing
train_model <- trainer %>%
    select()

#' ##################### Part 5 #####################
#' Modelling
# Model 1, using variables , , , and categorizes them into groups by
# Heighborhoods of 3 levels.
train_model %>%
    lm(SalePrice ~ ., .)

# Model 2, using OverallQual, OverallCond, YearBuilt, YearRemodAdd, and
# categorizes them into groups by ExterQual


#' ##################### Part 6 #####################
#' Evaluation

#' ##################### Part 7 #####################
#' Recommendations and final conclutions

#' ##################### Part 8 #####################
#' References
