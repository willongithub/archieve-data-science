### EDA Lab Week 10

require(ggplot2)
require(tidyverse)
require(DMwR)
require(GGally)
require(car)
require(reshape)
require(Tmisc)

## 1
# a
?iris

iris4 <- iris %>% select(1:4)

# b
iris4 %>%
    melt() %>%
    ggplot(aes(x = variable, y = value)) +
    geom_boxplot()

for (index in seq(1:4)) {
    print(boxplot.stats(iris4[, index])$out)
}

# c
z_iris4 <- scale(iris4)
lof_iris4 <- lofactor(z_iris4, 5)
print(iris4[which(lof_iris4 > 1.5), ])

# d
model_iris4 <- lm(iris4$Sepal.Width ~ iris4$Sepal.Length +
                                      iris4$Petal.Length +
                                      iris4$Petal.Width)
plot(model_iris4, 1)
plot(model_iris4, 4)
outlierTest(model_iris4)
qqPlot(model_iris4)

## 2
# a
data(quartet)
View(quartet)

# b
quartet %>%
    group_by(set) %>%
    summarize(x_mean = mean(x, na.rm = T),
              y_mean = mean(y, na.rm = T),
              x_sd = sd(x, na.rm = T),
              y_sd = sd(y, na.rm = T),
              cor = cor(x, y))

# c
quartet %>%
    ggplot(aes(x, y)) +
        geom_point() +
        geom_smooth(method = "lm") +
        facet_grid(set ~ .)

# d
quartet %>%
    filter(set == "I") %>%
    lm(x ~ y, .) %>%
    outlierTest()

quartet %>%
    filter(set == "II") %>%
    lm(x ~ y, .) %>%
    outlierTest()

quartet %>%
    filter(set == "III") %>%
    lm(x ~ y, .) %>%
    outlierTest()

quartet %>%
    filter(set == "IV") %>%
    lm(x ~ y, .) %>%
    outlierTest()
