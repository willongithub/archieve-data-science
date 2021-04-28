### EDA Lab Week 12

library(lme4, ggplot2, tidyverse)

##################### Exercise 1 #####################
## a
?sleepstudy

## b
ggplot(sleepstudy, aes(Days, Reaction, col = Subject)) + geom_point()

## c
sleepstudy %>%
    filter(Subject == sample(sleepstudy$Subject, size = 3)) %>%
    ggplot(aes(Days, Reaction, col = Subject,
               label = paste(Days, Reaction, sep = ", "))) +
        geom_point(size = 3) +
        geom_label(nudge_x = 0.5)

##################### Exercise 2 #####################
## a
data <- read.csv("eda/data/liquor3.csv")

ggplot(data, aes(income, liquor, col = hh)) + geom_point()

## b
