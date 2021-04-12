### EDA Lab Week 9

require(ggplot2)
require(tidyverse)

## 1
# a
?iris
str(iris)

# b
iris %>%
    mutate(area = Sepal.Length * Sepal.Width) %>%
    ggplot(aes(x = Species, y = area)) +
        geom_jitter(width = 0.1, aes(colour = Species)) +
        ggtitle("Sepal Area vs Species")

# c
iris %>%
    mutate(ratio = Petal.Length / Sepal.Length) %>%
    ggplot(aes(x = Species, y = ratio)) +
        geom_jitter(width = 0.1, aes(colour = Species)) +
        ggtitle("Petal to Sepal Ratio vs Species")

# d
iris %>%
    mutate(total = Sepal.Length + Sepal.Width +
                   Petal.Length + Petal.Width) %>%
    ggplot(aes(x = Species, y = total)) +
        geom_jitter(width = 0.1, aes(colour = Species)) +
        ggtitle("Total Length vs Species")

## 2
# a
set.seed(3)
error <- rnorm(100, 0, 0.8)
x <- 1:100
alpha <- 10
beta <- 5
y <- alpha + beta * log(x) + error
sim <- data.frame("x" = x, "y" = y)
View(sim)

# b
ggplot(sim, aes(x, y)) +
    geom_point() +
    geom_smooth(method = "lm")

# c
ggplot(sim, aes(log(x), y)) +
    geom_point() +
    geom_smooth(method = "lm")

# d
ggplot(sim, aes(x, y)) +
    geom_point() +
    geom_smooth()

# e
poly_m <- lm(y ~ ., data = sim)
sim <- sim %>% mutate(poly_pred = predict(poly_m))
ggplot(sim, aes(x, y)) +
    geom_point() +
    geom_line(aes(x, poly_pred))

## 3
# a
?Seatbelts

# b
df <- data.frame(.preformat.ts(datasets::Seatbelts), stringsAsFactors = F)
df <- df %>% rownames_to_column(var = "Month")

# c
df <- df %>% separate(Month, c("Mon", "Year"), sep = " ")

# d
require(RColorBrewer)
df %>%
    ggplot(aes(x = Year, y = drivers, group = Year, fill = Mon)) +
        geom_bar(position = "stack", stat = "identity") +
        scale_fill_brewer(palette = "Paired")

# e
# number of drivers involved declined ovber the years

# f
df %>%
    group_by(Year) %>%
    summarize(yearly_driver_killed = sum(DriversKilled)) %>%
    ggplot(aes(x = Year, y = yearly_driver_killed, colour = Year)) +
        geom_line() +
        scale_colour_brewer(palette = "Paired")

# g
df %>%
    group_by(Year) %>%
    summarize(yearly_driver_killed = sum(DriversKilled)) %>%
    ggplot(aes(x = Year, y = yearly_driver_killed, colour = law)) +
        geom_col() +
        scale_colour_brewer(palette = "Paired")

# h

# i


