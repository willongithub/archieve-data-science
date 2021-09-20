### IDS Lab Week 12

library(ggplot2)
library(tidyverse)
library(GGally)

##################### Exercise 1 #####################
data <- read.csv("ids/data/weather_data.csv")

glimpse(data)

data %>%
    group_by(month) %>%
    summarize(max = max(Maximum_temperature),
              min = min(Minimum_temperature),
              avg = mean((Maximum_temperature + Minimum_temperature) / 2),
              month = month) %>%
    gather(key = "metric", value = "value", -month) %>%
    ggplot(aes(x = month, y = value, group = metric, col = metric)) +
        geom_line() +
        geom_point(size = 3) +
        ggtitle("The average, minimum and maximum temperture in 2019") +
        xlim("Jan",
            "Feb",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep",
            "Oct",
            "Nov",
            "Dec") +
        scale_y_continuous(breaks = seq(0, 40, 10)) +
        theme(title = element_text(face = "bold", size = 15),
              axis.title = element_text(face = "bold"))

##################### Exercise 2 #####################
## 1
data <- read.csv("ids/data/Advertising.csv")

## 2
data <- data[, 2:5]

## 3
summary(data$sales)

##################### Exercise 3 #####################
## 1
plot <- data %>%
    gather(key = "category", value = "value", -sales) %>%
    ggplot(aes(x = value, y = sales, col = category)) +
        geom_point()

## 2
plot + stat_smooth(method = lm)

## 3
cor(data$sales, data$TV)
cor(data$sales, data$radio)
cor(data$sales, data$newspaper)

## 4
cor(data)

## 5
ggcorr(data)

##################### Exercise 4 #####################
## 1
result <- cor.test(data$sales, data$TV, method = "pearson")

## 2

## 3
result$p.value
result$estimate
