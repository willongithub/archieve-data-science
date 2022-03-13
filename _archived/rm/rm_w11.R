# Regression Modelling Lab Week 11

# 1
data_1 <- read.csv("rm/data/oscars.csv")
View(data_1)

# a
plot(data = data_1, Winner ~ OscarNominations)

# b
model_1 <- glm(data = data_1, Winner ~ OscarNominations, family = binomial)
summary(model_1)
coe_1 <- model_1$coefficients["OscarNominations"]
exp(coe_1) - 1
# - 1 for the increment portion only
# increase x% instead of increase to total odd of 1.x%
# odd equals p/(1-p)

# c
data_1 <- data_1[Title != "The Lord of the Rings: The Fellowship of the Ring", ]

model_1 <- glm(data = data_1, Winner ~ OscarNominations, family = binomial)
summary(model_1)
coe_1 <- model_1$coefficients["OscarNominations"]
(exp(coe_1) - 1) * 100

# d
movie_2018 <- data.frame(OscarNominations = 13)
predict(model_1, newdata = movie_2018, type = "response")

# 2
data_2 <- read.csv("rm/data/finratio.csv")
View(data_2)
# X1 = Retained Earnings/Total Assets,
# X2 = Earnings before Interest and Taxes/Total Assets,
# X3 = Sales/Total Assets,
# The response variable is defined as
# Y = 0 if bankrupt after 2 years, or = 1 if solvent after 2 years.

# a
model_2 <- glm(data = data_2, Y ~ X1 + X2 + X3, family = binomial)
summary(model_2)

# b
plot(model_2, 1)
# plot(model_2, 2)
plot(model_2, 3)
plot(model_2, 4)

# c
model_2 <- glm(data = data_2, Y ~ X1 + X2, family = binomial)
summary(model_2)

# 3
data_3 <- read.csv("rm/data/binary.csv")
View(data_3)

# a
require(caret)

split_3 <- createDataPartition(
    data_3$gpa,
    p = .8,
    list = F)

train_3 <- data_3[split_3, ]
test_3 <- data_3[-split_3, ]

# b
model_3 <- train(admit ~ gre + gpa + rank,
                 data = train_3,
                 trControl = trainControl(method = "cv", number = 10),
                 method = "glm",
                 family = "binomial")
summary(model_3)

# c
pred_3 <- predict(model_3, test_3)

mean(pred_3 == test_3$admit)

table(pred_3, test_3$admit)
