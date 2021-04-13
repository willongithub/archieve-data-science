### EDA Lab Week 10

require(ggplot2)
require(DMwR)

## 1
# a
?iris

iris4 <- iris %>% select(1:4)

# b
iris4 %>%
    ggplot(aes(x = iris4[, 1])) +
    geom_boxplot()

iris4 %>%
    ggplot(aes(x = iris4[, 2])) +
    geom_boxplot()

iris4 %>%
    ggplot(aes(x = iris4[, 3])) +
    geom_boxplot()

iris4 %>%
    ggplot(aes(x = iris4[, 4])) +
    geom_boxplot()

# c
z_iris4 <- scale(iris4)
lof_iris4 <- lofactor(z_iris4, 5)
print(iris4[which(lof_iris4 > 1.5), ])
