# IDS lab week 3

library(tidyverse)

# Vectors
# 1 (Vectors)
weight_before <- c(78, 72, 78, 79, 105)
weight_after <- c(67, 65, 79, 70, 93)
people <- c("Jack", "Dione", "Reda", "Sally", "Adam")
weight_lost <- before - after
weight_lost_average <- mean(weight_lost)
people_lost_max <- people[which.max(weight_lost)]
if (any(weight_lost < 0)) {
  weight_lost_not <- people[which(weight_lost < 0)]
  cat("Yes, someone did gain weight:", weight_lost_not)
}

# 2 (Sub-setting)
head(LETTERS, n = 12)
LETTERS[seq(1, 26, by = 2)]
vowels <- c("A", "E", "I", "O", "U", "Y", "W")
consonants <- LETTERS[which(!(LETTERS %in% vowels))]

# 3 (Vectors with random values)
x <- rnorm(30)
x[which(x < 1)]
x[which(x > 0.5 & x < 1)]
x[which(abs(x) > 1.5)]

# Conditional statements
# 4 (Conditional statements)
source("simple_calculator_with_if.R")

# Loops
a <- 1:10
b <- 1:10
res <- numeric(length=length(a))
for(i in a){
  res[i] = a[i] + b[i]
}
# str(res)
# > num [1:10] 2 4 6 8 10 12 14 16 18 20
res <- a + b
# str(res)
# > int [1:10] 2 4 6 8 10 12 14 16 18 20

# 5
emails <- c('myname@mycompany.com',
            'my@mycompany.com',
            'name@mycompany.net',
            'work@mycompany.org',
            'mywork#mycompany.net',
            'myproduct#mycompany.com',
            'myCoffee2mycompany.org',
            'mycar@mycompany.com',
            'mypet@mycompany.com',
            'hobbies!mycompany.com')
valid <- grep("@", emails, value = TRUE)

