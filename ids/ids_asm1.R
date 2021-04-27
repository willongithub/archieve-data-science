#' ---
#' title: "Introduction to Data Science 11516 G"
#' subtitle: "Assignment 1 - Data Wrangling and Exploration"
#' author: ""
#' date: "17/04/2021"
#' output:
#'   pdf_document:
#'     highlight: breezedark
#'     df_print: kable
#' ---

##################### Part A #####################

# install tidyverse if not installed
if (!("tidyverse" %in% rownames(installed.packages()))) {
  install.packages("tidyverse")
}

# load tidyverse library
require(tidyverse)

# suppress warning message for clean report
options(warn = - 1)  

## 1
# setup path to the 19 CSV files
# (the csv files are in the data/ folder under current working directory)
path <- "data/"

# list the files in the folder
filenames <- list.files(path)

# load the files one by one
# first 7 rows of meta-data skipped
for (item in filenames) {
    assign(paste0(item),
           read_csv(paste0(path, item),
                    skip = 7,
                    col_types = cols(.default = "?",
                                     "9am wind speed (km/h)" = "c",
                                     "3pm wind speed (km/h)" = "c")))
}

## 2
# store all the data frames in a list for bind_rows()
list_data <- list()

for (i in seq(filenames)) {
    list_data[[i]] <- get(filenames[i])
    remove(list = filenames[i])
}

# concatenate those files into one data frame
df_all <- bind_rows(list_data)

## 3
glimpse(df_all)
sum(!is.na(df_all$"Sunshine (hours)"))
sum(!is.na(df_all$"Evaporation (mm)"))
# We can see for the two columns regarding wind speed (km/h), the denotations
# are not consistent. There are numerical values as well as categorical values.
# The auto type imputation can fail so the type is supplied.
# And, the two columns checked as above is empty.

##################### Part B #####################
## 1
df_all <- select(df_all, -"Sunshine (hours)",
                         -"Evaporation (mm)")

## 2
# calculate the NA ratio of each column
col_na_ratio <- colSums(is.na(df_all)) / dim(df_all)[1]

# delete the column which consists of more than 90% NAs
for (item in names(col_na_ratio)) {
    if (col_na_ratio[item] > 0.9) {
        df_all <- select(df_all, -all_of(item))
    }
}

## 3
df_all <- rename_with(df_all, ~ gsub(" ", "_", .x))

## 4
df_all <- mutate(df_all, Date = as.Date(Date, "%d/%m/%Y"))

## 5
df_all <- mutate(df_all, Month = format(Date, "%m"),
                         Year = format(Date, "%Y"))

## 6
df_all[["Month"]] <- as.factor(as.numeric(df_all[["Month"]]))
df_all[["Year"]] <- as.factor(as.numeric(df_all[["Year"]]))

## 7
# count the number of NA in each column
col_with_na <- colSums(is.na(df_all))

# impute the NAs in numeric column with its median value 
for (item in names(col_with_na)) {
    if (col_with_na[item] > 0 && is.numeric(df_all[[item]])) {
        imput_value <- median(df_all[[item]], na.rm = T)
        df_all[is.na(df_all[item]), item] <- imput_value
    }
}

##################### Part C #####################
## 1
# put the column names to summarize in a vector
summary_col <- c("Minimum_temperature",
                 "Maximum_temperature",
                 "9am_Temperature",
                 "3pm_Temperature",
                 "Speed_of_maximum_wind_gust_(km/h)")

# put the statistics to show in a vector
summary_stat <- c(min = min,
                  median = median,
                  mean = mean,
                  max = max)

# show the minimum, median, mean, maximum of those columns
df_all %>%
    summarize(across(all_of(summary_col), summary_stat)) %>%
    glimpse()

## 2
df_all %>%
    group_by(Year, Month) %>%
    summarize(avg_min_temp = mean(Minimum_temperature))

## 3
df_all %>%
    group_by(Year, Month) %>%
    summarize(avg_max_temp = mean(Maximum_temperature))

## 4
df_all %>%
    group_by(Direction_of_maximum_wind_gust) %>%
    select("spd" = "Speed_of_maximum_wind_gust_(km/h)") %>%
    summarize(mean_by_dir = mean(spd))

## 5
df_all %>%
    group_by(Year, Month) %>%
    select("rf" = "Rainfall_(mm)") %>%
    summarize(rain_quantity = sum(rf)) %>%
    filter(rain_quantity == max(rain_quantity)) %>%
    arrange(desc(rain_quantity))
# here are the months with highest rainfall in each year

## 6
df_all %>%
    group_by(Year, Month) %>%
    select("rf" = "Rainfall_(mm)") %>%
    summarize(rain_quantity = sum(rf)) %>%
    filter(rain_quantity == min(rain_quantity)) %>%
    arrange(order(rain_quantity))
# here are the months with lowest rainfall in each year
# its almost dry in 12/2018

## 7
df_all %>%
    filter(Year == 2019) %>%
    group_by(Month) %>%
    select("am" = "9am_relative_humidity_(%)",
           "pm" = "3pm_relative_humidity_(%)") %>%
    summarize(hum_lvl = mean(am + pm)) %>%
    filter(hum_lvl == max(hum_lvl))

## 8
df_summary <- df_all %>%
    filter(Year == 2019) %>%
    mutate(Quarter = 1 + (as.numeric(Month) - 1) %/% 3) %>%
    select(Month, Quarter,
           "am_temp" = "9am_Temperature",
           "pm_temp" = "3pm_Temperature",
           "am_wind" = "9am_wind_speed_(km/h)",
           "pm_wind" = "3pm_wind_speed_(km/h)",
           "am_hum" = "9am_relative_humidity_(%)",
           "pm_hum" = "3pm_relative_humidity_(%)") %>%
    group_by(Quarter, Month) %>%
    summarize(max_temp = max(c(am_temp, pm_temp)),
              min_temp = min(c(am_temp, pm_temp)),
              avg_temp = mean(c(am_temp, pm_temp)),
              max_wind = max(c(as.numeric(am_wind),
                               as.numeric(pm_wind)), na.rm = T),
              min_wind = min(c(as.numeric(am_wind),
                               as.numeric(pm_wind)), na.rm = T),
              avg_wind = mean(c(as.numeric(am_wind),
                                as.numeric(pm_wind)), na.rm = T),
              max_hum = max(c(am_hum, pm_hum)),
              min_hum = min(c(am_hum, pm_hum)),
              avg_hum = mean(c(am_hum, pm_hum)))
# the non-numeric values in wind speed have been removed
# they represent very small wind so impute it with median value would not
# be proper

## 9
# store the names of columns to plot in a vector
col_name <- colnames(df_summary[, 3:11])

# plot each variable one by one
for (item in col_name) {
    barplot(df_summary[[item]],
            main = item,
            xlab = "Month",
            ylab = "Value",
            col = rainbow(12),
            names.arg = c(1:12))
}
