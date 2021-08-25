# Regression Modelling Lab Week 4

# 3.1
movie <- read.csv("RM/data/movies.csv")

# a
# Y|(X1i, X2i, ...) = E(Y|(X1i, X2i, ...)) + ei (i = 1, ..., n),
# where E(Y|(X1i, X2i, ...)) = b0 + b1X1i + b2X2i + ... (i = 1, ..., n).
# Here E = b0 + b1*Rate + b2*Meta + b3*User
# choose crosponding variables
movie_data <- movie[, 2:5]
attach(movie_data)

# b
# scatter plot matrix between each of all variables
pairs(movie_data)
cor(movie_data)

movie_result <- lm(Box ~ Rate + Meta + User)
summary(movie_result)
anova(movie_result)

# c

# 3.2
shipdept <- read.csv("RM/data/shipdept.csv")
attach(shipdept)

# a
model_4 <- lm(Lab ~ ., data = shipdept)
model_4 <- lm(Lab ~ Tws + Pst + Asw + Num)
summary(model_4)
anova(model_4)
confint(model_4, level = 0.9)

# b
model_2 <- lm(Lab ~ Tws + Asw)
summary(model_2)
anova(model_2)
confint(model_2, level = 0.9)

# 3.4
# a
test_data <- data.frame(Tws = c(6), Asw = c(20))

confidence_result <- predict.lm(model_2,
                                newdata = test_data,
                                se.fit = T,
                                interval = "confidence",
                                level = 0.9)

# b
predict_result <- predict.lm(model_2,
                             newdata = test_data,
                             se.fit = T,
                             interval = "prediction",
                             level = 0.9)
