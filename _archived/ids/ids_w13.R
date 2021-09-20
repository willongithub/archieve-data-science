### IDS Lab Week 13

library(tidyverse)
library(caret)
library(ggplot2)
library(GGally)
library(ellipse)

## Exercise 1
# 2
data <- read_csv("ids/data/Advertising.csv")

# 3
data <- data %>% mutate(X1 = NULL)

# 4
index <- createDataPartition(seq(nrow(data)), p = .60, list = F)

train <- data[index, ]
test <- data[-index, ]

# 5
model_1 <- lm(sales ~ TV, data = train)
summary(model_1)
plot(model_1$residuals)

# 6
model_2 <- lm(sales ~ ., data = train)
summary(model_2)
plot(model_2$residuals)

# 7
test$predict_model_1 <- predict(model_1, test)
test$predict_model_2 <- predict(model_2, test)

View(test[, c("sales", "predict_model_1", "predict_model_2")])

ggplot(model_1, aes(model_1$residuals)) +
  geom_histogram(aes(y = ..density..), fill = "#C99800") +
  geom_density(color = "blue")

ggplot(model_2, aes(model_2$residuals)) +
  geom_histogram(aes(y = ..density..), fill = "#00BCD8") +
  geom_density(color = "red")

# 8
RMSE(test$predict_model_1, test$sales)
RMSE(test$predict_model_2, test$sales)

## Exercise 2
# 2
data <- read_csv("ids/data/USA_Housing.csv")

# 3
ggplot(data, aes(Price)) +
    geom_histogram(aes(y = ..density..)) +
    geom_density()

# 4
ggcorr(data, label = T, label_alpha = T)

plotcorr(cor(data))

# 5
data %>%
    gather() %>%
    ggplot(aes(key, value)) +
    geom_boxplot() +
    facet_wrap(~key, scale = "free")

# 6
index <- createDataPartition(seq(nrow(data)), p = .70, list = F)

trainer <- data[index, ]
tester <- data[-index, ]

# 7
model_1 <- lm(Price ~ Area_Income, data = trainer)

# 8
summary(model_1)

# 9
plot(model_1)

# 10
tester$predict <- predict(model_1, tester)
RMSE(tester$predict_1, tester$Price)

# 11
model_2 <- lm(Price ~ ., data = trainer)

# 12
tester$predict_2 <- predict(model_2, tester)
RMSE(tester$predict_2, tester$Price)

# 13
ggplot(model_1, aes(model_1$residuals)) +
  geom_histogram(aes(y = ..density..), fill = "#C99800") +
  geom_density(color = "blue")

ggplot(model_2, aes(model_2$residuals)) +
  geom_histogram(aes(y = ..density..), fill = "#00BCD8") +
  geom_density(color = "red")
