# EDA Lab Week 5

if (!("tidyverse" %in% rownames(installed.packages()))) {
  install.packages("tidyverse")
}
require(ggplot2)
require(dplyr)

# 1a
ggplot(mtcars, aes(x = mpg)) +
    geom_histogram(bins = 7, fill = "red", colour = "black") +
    xlab("MPG") +
    ylab("Observation") +
    ggtitle("MPG of Cars") +
    theme_grey()

# 1b
ggplot(mtcars, aes(x = mpg, fill = ..count..)) +
    geom_histogram(bins = 7, colour = "black") +
    scale_fill_gradient(name = "MPG", low = "blue", high = "red") +
    xlab("MPG") +
    ylab("Observation") +
    ggtitle("MPG of Cars") +
    theme_grey()

# 1c
ggplot(mtcars, aes(x = hp, y = mpg, colour = as.factor(cyl))) +
    geom_point(size = 5) +
    scale_colour_manual(name = "Cylinders",
                        values = c("red", "yellow", "blue")) +
    xlab("HP") +
    ylab("MPG") +
    ggtitle("MPG vs HP") +
    theme_grey()

# 1d
ggplot(mtcars, aes(x = hp, y = mpg, colour = cyl)) +
    geom_point(size = 5) +
    scale_colour_gradient(name = "Cylinder", low = "blue", high = "red") +
    xlab("HP") +
    ylab("MPG") +
    ggtitle("MPG vs HP") +
    theme_grey()

##########
# 2a
?txhousing

# 2b
ggplot(txhousing, aes(median, fill = ..count..)) +
    geom_histogram(binwidth = 10000, colour = "black") +
    scale_fill_gradient(name = "Observations",
                        low = "navy", high = "lightpink") +
    xlab("Median Price") +
    ylab("Observations") +
    ggtitle("Median Sale Price") +
    theme_grey()

# 2c
txhousing %>%
    group_by(city) %>%
    summarize(city_median = median(median, na.rm = TRUE)) %>%
    slice_max(n = 3, order_by = city_median) %>%
    ggplot(aes(x = reorder(city, city_median), y = city_median)) +
        geom_bar(stat = "identity", aes(fill = city)) +
        xlab("City") +
        ylab("Median Price") +
        ggtitle("Top 3 Median Sale Price by City") +
        theme_grey()

# 2d
txhousing %>%
    group_by(year) %>%
    summarize(year_median = median(median, na.rm = TRUE)) %>%
    ggplot(aes(x = reorder(year, year_median), y = year_median)) +
        geom_bar(stat = "identity", aes(fill = year)) +
        xlab("Year") +
        ylab("Median Price") +
        ggtitle("Median Sale Price by Year") +
        scale_fill_gradient(low = "white", high = "darkred") +
        theme_grey()

# 2e
ggplot(txhousing, aes(x = median, y = listings)) +
    geom_point(aes(colour = city)) +
    geom_smooth(method = "lm")
    xlab("Median Price") +
    ylab("Listings") +
    ggtitle("Median Sale Price vs Listings") +
    theme_grey()

# 2f
ggplot(txhousing, aes(x = median, y = sales)) +
    geom_point(aes(colour = city)) +
    geom_smooth(method = "lm")
    xlab("Median Price") +
    ylab("Sales") +
    ggtitle("Median Sale Price vs Sales") +
    theme_grey()

# 2g
ggplot(txhousing, aes(x = median, y = listings)) +
    geom_point(aes(colour = city)) +
    geom_smooth()
    xlab("Median Price") +
    ylab("Listings") +
    ggtitle("Median Sale Price vs Listings") +
    theme_grey()

ggplot(txhousing, aes(x = median, y = sales)) +
    geom_point(aes(colour = city)) +
    geom_smooth()
    xlab("Median Price") +
    ylab("Sales") +
    ggtitle("Median Sale Price vs Sales") +
    theme_grey()

# 2h
ggplot(txhousing, aes(x = sales, y = volume)) +
    geom_point(aes(colour = city)) +
    geom_smooth(method = "lm")
    xlab("Sales") +
    ylab("Volume") +
    ggtitle("Sales vs Volume") +
    theme_grey()

##########
# 3a
?diamonds

# 3b
ggplot(diamonds, aes(x = price, y = cut)) +
    geom_jitter(aes(colour = cut)) +
    geom_smooth() +
    xlab("Price") +
    ylab("Cut") +
    ggtitle("Price vs Cut") +
    theme_grey()

# 3c
ggplot(diamonds, aes(x = cut, y = price, fill = cut)) +
    geom_boxplot() +
    xlab("Cut") +
    ylab("Price") +
    ggtitle("Price vs Cut") +
    theme_grey()

# 3d
ggplot(txhousing, aes(median, fill = ..count..)) +
    geom_histogram(bins = 50, colour = "black") +
    scale_fill_gradient(name = "Count", low = "navy", high = "lightpink") +
    xlab("Median Price") +
    ylab("Observation") +
    ggtitle("Median Sale Price") +
    theme_grey()

# 3e
ggplot(txhousing, aes(x = sales, y = volume)) +
    geom_point(aes(colour = city)) +
    geom_smooth(method = "lm")
    xlab("Sales") +
    ylab("Volume") +
    ggtitle("Sales vs Volume") +
    theme_grey()