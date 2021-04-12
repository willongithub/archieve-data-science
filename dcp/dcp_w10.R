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
sixth_j <- anti_join(superheroes, publishers)

## Exercise 4
require(nycflights13)
# 1
