### IDS Lab Week 11

require(tidyverse)
require(ggplot2)

## Exercise 1
gender <- sample(c("Male", "Female", "Not-mentioned"),
                 100, replace = TRUE)
subject <- sample(c("Math", "Science", "Other"),
                  100, replace = TRUE)
data <- tibble(gender, subject)

# 1
data %>%
    filter(subject == "Math") %>%
    summarize(p_math = n() / dim(data)[1])

# 2
data %>%
    filter(gender == "Male") %>%
    summarize(p_male = n() / dim(data)[1])

# 3
c_total <- dim(data)[1]
c_math <- data %>% filter(subject == "Math") %>% count()
c_female_math <- data %>%
    filter(gender == "Female", subject == "Math") %>%
    count()

# 4

# 5
data %>%
    ggplot(aes(x = gender, y = ..prop.., group = subject, fill = subject)) +
        geom_bar(position = "dodge")

## Exercise 2
data <- c(199, 201, 236, 269, 271, 278, 283, 291, 301, 303, 341)

# 1
summary(data)

# 2
boxplot(data)

# 3

## Exercise 3
data <- data.frame(
    gender = factor(rep(c("F", "M"), each = 200)),
    weight = round(c(rnorm(200, mean = 55, sd = 5),
                     rnorm(200, mean = 65, sd = 5))))

# 1
ggplot(data, aes(weight)) +
    geom_histogram()

# 2
ggplot(data, aes(weight)) +
    geom_histogram() +
    facet_grid(. ~ gender)

# 3
ggplot(data, aes(weight)) +
    geom_histogram() +
    geom_vline(xintercept = mean(data$weight)) +
    facet_grid(. ~ gender)

# 4
ggplot(data, aes(y = weight, group = gender)) +
    geom_boxplot()

## Exercise 4
# 1
data <- read_csv("ids/data/surveys_complete.csv")

# 2
ggplot(data, aes(y = weight, group = species_id, fill = species_id)) +
    geom_boxplot()

# 3
ggplot(data, aes(species_id, weight, group = species_id, fill = species_id)) +
    geom_boxplot() +
    geom_point()

# 4
ggplot(data, aes(species_id, weight, group = species_id, fill = species_id)) +
    geom_boxplot() +
    geom_point(alpha = 0.1)
