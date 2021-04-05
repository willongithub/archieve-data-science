# Introduction to Data Science 11516 G
# Siqi Wu (u3229442)
# Assignment 1 - Data Wrangling and Exploration

##################### Part A #####################
## 1
# install tidyverse if not installed
if (!("tidyverse" %in% rownames(installed.packages()))) {
  install.packages("tidyverse")
}

# load tidyverse library
require(tidyverse)

# setup path of the files for loading
path <- "ids/data/"
filenames <- list.files(path)

# load the csv files into workspace one by one
# first 7 rows of meta-data skiped
for (item in filenames) {
    assign(paste0("data_", item), read_csv(paste0(path, item), skip = 7))
}

## 2
# get all the name of the dataframe to concatenante
names <- ls(pattern = "*.csv")

# concatenate those files into one dataframe
list_names <- vector(mode = "list", length = length(names))

for (i in seq(names)) {
    list_names[[i]] <- get(names[i])
}

a <- bind_rows(list_names)

## 3

##################### Part B #####################

##################### Part C #####################

##################### Part D #####################