### DCP Lab Week 10

## Exercise 1
require(rcfss)
# 2
data(superheroes)
data(publishers)

# 3
class(superheroes)
class(publishers)

## Exercise 2
require(tidyverse)
# 1
first_j <- merge(superheroes, publishers, all = F)

# 2
# Sabrina

# 3
second_j <- left_join(superheroes, publishers)

# 4

# 5
third_j <- right_join(superheroes, publishers)

# 6

# 7
fourth_j <- full_join(superheroes, publishers)

## Exercise 3
# 1
fifth_j <- semi_join(superheroes, publishers)

# 2

# 3

# 4
sixth_j <- anti_join(superheroes, publishers)

# 5

## Exercise 4
## relationship between the age of plane and its departure delay
require(nycflights13)
require(dplyr)
require(ggplot2)
# 1
year_of_data <- 2013

# 2
planes <- planes %>%
    mutate(age = year_of_data - year)

# 3
plane_ages <- planes %>%
    select(tailnum, age)

# 4
join1 <- inner_join(plane_ages, flights)

# 5
result <- join1 %>%
    group_by(age) %>%
    summarize(delay = mean(dep_delay, na.rm = T))

# 6
result %>%
    ggplot(mapping = aes(x = age, y = delay)) +
        geom_point() +
        geom_line()

# 7
# the probability of delay and age show no significant relationship

## coordinates of the origin and destination airport
# 1
