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
require(GGally)

# load the data from csv file
trainer <- read_csv("eda/data/train.csv")
tester <- read_csv("eda/data/test.csv")

trainer <- trainer[-1, ]

# count the NAs in train dataset
missing <- colSums(is.na(trainer))

# plot the percentage of NAs for the involved variables
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
        theme(plot.title = element_text(hjust = 0.5, face = "bold"),
              axis.text.x = element_text(angle = 45, vjust = 0.5))

# There are 19 variables have missing values. 4 of them over 50%. Those NAs
# are missing features of the house such as alley access or fence. They
# are not error values so should not imput.

# plot the distribution of SalePrice
ggplot(trainer, aes(trainer$SalePrice)) +
    geom_histogram(aes(y = ..density..), fill = "lightblue", bins = 100) +
    geom_density(colour = "darkred") +
    ggtitle("Distribution of SalePrice") +
    xlab("SalePrice") +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"),
          axis.title.y = element_blank())

# it clear that SalePrice does not follow normal distribution
# try log trasformation
ggplot(trainer, aes(log(trainer$SalePrice))) +
    geom_histogram(aes(y = ..density..), fill = "lightblue", bins = 100) +
    geom_density(colour = "darkred") +
    ggtitle("Distribution of SalePrice (logarithmic)") +
    xlab("SalePrice") +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"),
          axis.title.y = element_blank())

# after the log trasformation it fits normal distribution well enough
# transforms the scale of SalePrice to log for the trainer set and tester set
trainer <- trainer %>%
    select(SalePrice) %>%
    mutate(SalePrice = log(SalePrice))

tester <- tester %>%
    select(SalePrice) %>%
    mutate(SalePrice = log(SalePrice))

#' ##################### Part 3 #####################
#' EDA
# use boxplot stats to find possible outliers
trainer %>%
    .[which(.$SalePrice %in% boxplot.stats(.$SalePrice)$out), ] %>%
    group_by(Neighborhood) %>%
    summarize(count = n()) %>%
    arrange(desc(count))

# amoung the outliers, nearly half of them comes from the neiborhood NridgHt

trainer %>%
    .[which(.$SalePrice %in% boxplot.stats(.$SalePrice)$out), ] %>%
    group_by(YrSold) %>%
    summarize(count = n()) %>%
    arrange(desc(count))

# out of the 61 outliers of sale price, they have no common in year of sale

# plot correlation matrix for all numaric variables
trainer %>%
    select_if(is.numeric) %>%
    select(names(which(colSums(is.na(.)) == 0))) %>%
    select(-Id) %>%
    ggcorr()

# save the variables with top 10 highest correlation coeficient
predictor <- trainer %>%
    select_if(is.numeric) %>%
    select(names(which(colSums(is.na(.)) == 0))) %>%
    select(-Id) %>%
    cor() %>%
    .[, "SalePrice"] %>%
    abs() %>%
    as.data.frame() %>%
    filter(. > 0.5) %>%
    arrange(desc(.)) %>%
    rownames()

# plot the distributions of these variables
trainer %>%
    select(all_of(top_var), -SalePrice) %>%
    gather() %>%
    ggplot(aes(value)) +
        geom_histogram(aes(y = ..density..), fill = "lightblue", bins = 50) +
        geom_density(colour = "darkred") +
        ggtitle("Distribution of variables with high r") +
        xlab("Variables") +
        facet_wrap(~ key, scales = "free") +
        theme(plot.title = element_text(hjust = 0.5, face = "bold"),
              axis.title.y = element_blank())

# we found there are variables which is not actually numeric but with
# numeric levels.
# 5 of them are promissing:
#   OverallQual, GrLivArea, GarageArea, TotalBsmtSF, 1stFlrSF.

predictor <- trainer %>%
    select(where(is.character), SalePrice) %>%
    gather("column", "category", -SalePrice) %>%
    group_by(column) %>%
    summarize(score = unlist((summary(aov(SalePrice ~ category, data = .)))))

a <- aov(SalePrice ~ Neighborhood, data = trainer)

names(unlist((summary(a))))

predictor <- trainer %>%
    select(where(is.character), SalePrice) %>%
    gather("column", "value", -SalePrice) %>%
    group_by(column, value) %>%
    summarize(mean_price = mean(SalePrice)) %>%
    group_by(column) %>%
    summarize(score = var(mean_price)) %>%
    arrange(desc(score))

predictor %>%
    ggplot(aes(reorder(column, -score), score, fill = score)) +
        geom_col(show.legend = F) +
        scale_fill_viridis_c() +
        ggtitle("Variance of mean between categories") +
        xlab("Variables") +
        ylab("Variance") +
        theme(plot.title = element_text(hjust = 0.5, face = "bold"),
              axis.text.x = element_text(angle = 45, vjust = 0.5))

predictor <- predictor$column[1:5]

trainer %>%
    select(all_of(predictor), SalePrice) %>%
    gather("column", "value", -SalePrice) %>%
    ggplot(aes(value, SalePrice)) +
        geom_boxplot(aes(fill = value), show.legend = F) +
        scale_fill_viridis_d() +
        ggtitle("Distribution of price between categories") +
        xlab("Category") +
        ylab("Price") +
        facet_wrap(~ column, scales = "free") +
        theme(plot.title = element_text(hjust = 0.5, face = "bold"))

#' ##################### Part 4 #####################
#' Further preprocessing
# select fitting variables as follow
model_var <- c("GrLivArea", "GarageArea", "TotalBsmtSF", "1stFlrSF")

# they also need log transformation to follow normal distribution
trainer <- trainer %>% mutate(across(model_var, log))
tester <- tester %>% mutate(across(model_var, log))

# here we remove the houses without garage or basement for modelling
trainer <- trainer %>%
    filter(GarageArea != -Inf) %>%
    filter(TotalBsmtSF != -Inf)

tester <- tester %>%
    filter(GarageArea != -Inf) %>%
    filter(TotalBsmtSF != -Inf)

#' ##################### Part 5 #####################
#' Modelling
# Model 1
model_1 <- lm(trainer[["SalePrice"]] ~ trainer[["GrLivArea"]] +
                                       trainer[["1stFlrSF"]] +
                                       trainer[["OverallQual"]])
tester$predict_1 <- predict(model_1, tester)

# Model 2
model_2 <- lm(trainer[["SalePrice"]] ~ trainer[["GrLivArea"]] +
                                       trainer[["1stFlrSF"]] +
                                       trainer[["GarageArea"]] +
                                       trainer[["TotalBsmtSF"]])
tester$predict_2 <- predict(model_2, tester)

#' ##################### Part 6 #####################
#' Evaluation
# model 1
summary(model_1)

sqrt(mean((tester$predict_1 - tester$SalePrice)^2))

plot(model_1$residuals)

ggplot(model_1, aes(model_1$residuals)) +
    geom_histogram(aes(y = ..density..), fill = "#C99800") +
    geom_density(color = "blue")

# model 2
summary(model_2)

sqrt(mean((tester$predict_2 - tester$SalePrice)^2))

plot(model_2$residuals)

ggplot(model_2, aes(model_2$residuals)) +
    geom_histogram(aes(y = ..density..), fill = "#C99800") +
    geom_density(color = "blue")

#' ##################### Part 7 #####################
#' Recommendations and final conclutions

#' ##################### Part 8 #####################
#' References
