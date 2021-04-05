### EDA Lab Week 9

require(ggplot2)
require(dplyr)

## 1
# a
?iris
str(iris)

# b
iris %>%
    mutate(area = Sepal.Length * Sepal.Width) %>%
    ggplot(aes(x = Species, y = area)) +
        geom_point(aes(colour = Species)) +
        ggtitle("Sepal Area vs Species")

# c
iris %>%
    mutate(ratio = Petal.Length / Sepal.Length) %>%
    ggplot(aes(x = Species, y = ratio)) +
        geom_point(aes(colour = Species)) +
        ggtitle("Petal to Sepal Ratio vs Species")

# d
iris %>%
    mutate(total = Sepal.Length + Sepal.Width +
                   Petal.Length + Petal.Width) %>%
    ggplot(aes(x = Species, y = total)) +
        geom_point(aes(colour = Species)) +
        ggtitle("Total Length vs Species")

## 2
# a


## 3
