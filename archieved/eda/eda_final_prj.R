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
require(DMwR2)

# load the data from csv file
trainer <- read_csv("eda/data/train.csv")
tester <- read_csv("eda/data/test.csv")

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
              axis.text.x = element_text(angle = 45, vjust = 0.5)，
              axis.title.x = element_blank())

# There are 19 variables have missing values. 4 of them over 50%. Those NAs
# are missing features of the house such as alley access or fence. They
# are not error values so should not imput.

#' ##################### Part 3 #####################
#' EDA

# plot correlation matrix for all numeric variables
trainer %>%
    select_if(is.numeric) %>%
    select(-Id) %>%
    ggcorr()

# keep the variables with high correlation coeficient to SalePrice
num_predictor <- trainer %>%
    select_if(is.numeric) %>%
    select(names(which(colSums(is.na(.)) == 0))) %>%
    select(-Id) %>%
    cor() %>%
    .[, "SalePrice"] %>%
    abs() %>%
    as.data.frame() %>%
    filter(. > 0.5) %>%
    arrange(desc(.))

# plot the distributions of these variables
trainer %>%
    select(all_of(rownames(num_predictor)), -SalePrice) %>%
    gather() %>%
    ggplot(aes(value)) +
        geom_histogram(aes(y = ..density..), fill = "lightblue", bins = 50) +
        geom_density(colour = "darkred") +
        ggtitle("Distribution of variables with high r") +
        xlab("Variables") +
        facet_wrap(~ key, scales = "free") +
        theme(plot.title = element_text(hjust = 0.5, face = "bold"),
              axis.title.y = element_blank())

# show scatter plot of these variables
trainer %>%
    select(all_of(rownames(num_predictor))) %>%
    gather("column", "value", -SalePrice) %>%
    ggplot(aes(value, SalePrice)) +
        geom_point() +
        geom_smooth(method = "lm") +
        ggtitle("Scatter plot of variables with high r") +
        xlab("Variables") +
        facet_wrap(~ column, scales = "free") +
        theme(plot.title = element_text(hjust = 0.5, face = "bold"),
              axis.title.y = element_blank())

# 5 of them are promissing:
#   OverallQual, GrLivArea, GarageArea, TotalBsmtSF, 1stFlrSF.

# look at the boxplots of categorical variables, some of the categories have
# very different location than others, which means they might have huge
# impact on price, like Neiborhood, ExterQual or PoolQC
trainer %>%
    select(where(is.character), SalePrice) %>%
    gather("column", "value", -SalePrice) %>%
    ggplot(aes(value, SalePrice)) +
        geom_boxplot(aes(fill = value), show.legend = F) +
        scale_fill_viridis_d() +
        ggtitle("Distribution of price between categories") +
        xlab("Category") +
        ylab("Price") +
        facet_wrap(~ column, scales = "free") +
        theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# to evaluate the impact of these categorical variables on SalePrice,
# convert them based on mean price of each category
score <- trainer %>%
    select(where(is.character), SalePrice) %>%
    gather("column", "value", -SalePrice) %>%
    group_by(column, value) %>%
    summarize(level = mean(SalePrice))

# convert them to z-score
score$level <- scale(score$level)

# generate a new data frame to evaluate these categorical variables
cat_var <- trainer %>% select(where(is.character))

# put the coverted variables in
for (item in names(cat_var)) {
    value <- score %>% filter(column == item)
    colnames(value)[2] <- item
    cat_var <- cat_var %>% inner_join(value) %>% mutate(column = NULL)
    colnames(cat_var)[dim(cat_var)[2]] <- paste0(item, "_level")
}

# remove old data, put the SalePrice back
cat_var <- cat_var %>%
    select(where(is.numeric)) %>%
    mutate(SalePrice = trainer$SalePrice)

# visualize the correlation matrix
ggcorr(cat_var)

# keep the variables with high correlation coeficient
cat_predictor <- cat_var %>%
    cor() %>%
    .[, "SalePrice"] %>%
    abs() %>%
    as.data.frame() %>%
    filter(. > 0.5) %>%
    arrange(desc(.))

# append the conveted level data to training set
trainer <- trainer %>%
    mutate(SalePrice = NULL) %>%
    cbind(cat_var)

#' ##################### Part 4 #####################
#' Further preprocessing
trainer %>%
    select(all_of(rownames(num_predictor))) %>%
    ggcorr(label = T)

trainer %>%
    select(all_of(rownames(cat_predictor))) %>%
    ggcorr(label = T)

model_var <- c("OverallQual", "GrLivArea",
               "GarageArea", "TotalBsmtSF",
               "Neighborhood_level", "ExterQual_level")

# here we just remove small number of the houses without garage or basement
# because we use garage and basement as predictors
trainer <- trainer %>%
    filter(GarageArea > 0) %>%
    filter(TotalBsmtSF > 0)

tester <- tester %>%
    filter(GarageArea > 0) %>%
    filter(TotalBsmtSF > 0)

# indentify possible outliers based on thses variables
num_out <- trainer %>%
    select(all_of(model_var)) %>%
    scale() %>%
    lofactor(5)

num_out <- which(num_out > 1.5)

trainer <- trainer %>% slice(-num_out)

# plot the distributions of these variables
trainer %>%
    select(all_of(model_var)) %>%
    gather() %>%
    ggplot(aes(value)) +
        geom_histogram(aes(y = ..density..), fill = "lightblue", bins = 50) +
        geom_density(colour = "darkred") +
        ggtitle("Distribution of variables with high r") +
        xlab("Variables") +
        facet_wrap(~ key, scales = "free") +
        theme(plot.title = element_text(hjust = 0.5, face = "bold"),
              axis.title.y = element_blank())

# show scatter plot of these variables
trainer %>%
    select(all_of(model_var), SalePrice) %>%
    gather("column", "value", -SalePrice) %>%
    ggplot(aes(value, SalePrice)) +
        geom_point() +
        geom_smooth(method = "lm") +
        ggtitle("Scatter plot of variables with high r") +
        xlab("Variables") +
        facet_wrap(~ column, scales = "free") +
        theme(plot.title = element_text(hjust = 0.5, face = "bold"),
              axis.title.y = element_blank())


# convert selected categorical variables in test set
var <- c("Neighborhood", "ExterQual")

# put the coverted variables in test set
for (item in var) {
    value <- score %>% filter(column == item)
    colnames(value)[2] <- item
    tester <- tester %>% inner_join(value) %>% mutate(column = NULL)
    colnames(tester)[dim(tester)[2]] <- paste0(item, "_level")
}

# plot the distribution of SalePrice
ggplot(trainer, aes(SalePrice)) +
    geom_histogram(aes(y = ..density..), fill = "lightblue", bins = 100) +
    geom_density(colour = "darkred") +
    ggtitle("Distribution of SalePrice") +
    xlab("SalePrice") +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"),
          axis.title.y = element_blank())

# it clear that SalePrice does not follow normal distribution
# try log trasformation
ggplot(trainer, aes(log(SalePrice))) +
    geom_histogram(aes(y = ..density..), fill = "lightblue", bins = 100) +
    geom_density(colour = "darkred") +
    ggtitle("Distribution of SalePrice (logarithmic)") +
    xlab("SalePrice") +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"),
          axis.title.y = element_blank())

# transforms the scale of SalePrice to log for the trainer set and tester set
trainer <- trainer %>% mutate(SalePrice = log(SalePrice))
tester <- tester %>% mutate(SalePrice = log(SalePrice))

#' ##################### Part 5 #####################
#' Modelling
# Model 1
model_1 <- lm(SalePrice ~ GrLivArea +
                          OverallQual +
                          GarageArea +
                          TotalBsmtSF, data = trainer)
tester$predict_1 <- predict(model_1, tester)

# Model 2
model_2 <- lm(SalePrice ~ GrLivArea +
                          OverallQual +
                          ExterQual_level +
                          Neighborhood_level, data = trainer)
tester$predict_2 <- predict(model_2, tester)

#' ##################### Part 6 #####################
#' Evaluation
# convert the price back to orinal scale
tester <- tester %>% mutate(SalePrice = exp(SalePrice))
tester <- tester %>% mutate(predict_1 = exp(predict_1))
tester <- tester %>% mutate(predict_2 = exp(predict_2))

# model 1
summary(model_1)

# rmse of model 1
sqrt(mean((tester$predict_1 - tester$SalePrice)^2))

# model 2
summary(model_2)

# rmse of model 2
sqrt(mean((tester$predict_2 - tester$SalePrice)^2))

# residuals plot
lm_result <- tester %>%
    filter(predict_1 < 6e+05) %>%
    filter(predict_2 < 6e+05) %>%
    mutate(diff_1 = abs(SalePrice - predict_1) / SalePrice) %>%
    mutate(diff_2 = abs(SalePrice - predict_2) / SalePrice)

bad_margain <- 0.15

bad_result_1 <- lm_result %>% filter(diff_1 > bad_margain)
bad_result_2 <- lm_result %>% filter(diff_2 > bad_margain)

lm_result %>%
    ggplot(aes(SalePrice, predict_1)) +
        geom_point(aes(col = diff_1)) +
        geom_point(data = bad_result_1, col = "red") +
        scale_color_gradient(name = "y - yBar (%)", limits = c(0, 50)) +
        geom_abline(slope = 1, intercept = 0) +
        ggtitle("Linear model 1 residuals") +
        xlab("Price") +
        ylab("Prediction") +
        theme(plot.title = element_text(hjust = 0.5, face = "bold"))

lm_result %>%
    ggplot(aes(SalePrice, predict_2)) +
        geom_point(aes(col = diff_2)) +
        geom_point(data = bad_result_2, col = "red") +
        scale_color_gradient(name = "y - yBar (%)", limits = c(0, 50)) +
        geom_abline(slope = 1, intercept = 0) +
        ggtitle("Linear model 2 residuals") +
        xlab("Price") +
        ylab("Prediction") +
        theme(plot.title = element_text(hjust = 0.5, face = "bold"))

#' ##################### Part 7 ##############857a6674##
#' Recommendations and final conclutions

#' ##################### Part 8 #####################
#' References
