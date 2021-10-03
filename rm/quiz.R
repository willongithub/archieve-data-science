# QUIZ

# Quiz 1 Practice
# 3
data(trees)
head(trees)
md <- lm(trees$Volume ~ trees$Height)

# a, b
md

smr <- summary(md)
anv <- anova(md)

# c
sqrt(anv["Mean Sq"])
smr$sigma
sd(md$residuals) # n instead of n-2

# 4
md <- lm(trees$Volume ~ trees$Height + trees$Girth)
smr <- summary(md)
anv <- anova(md)

# a
anv["Mean Sq"]
anv["Sum Sq"] / anv["Df"]

# b
smr$r.squared

# c
plot(md, 2) # normal QQ plot close to linear

# d
scale(md$residuals)
plot(md, 4) # standard error: 3.75

# e
md$fitted.values[15]
md$residuals[15]


# Quiz 1
data(swiss)
head(swiss)

# q5
cor(swiss)

# q6
md <- lm(swiss$Fertility ~ swiss$Infant.Mortality)
md
smr <- summary(md)
smr
anv <- anova(md)
sqrt(anv["Mean Sq"])
md$fitted.values[37]
md$residuals[37]

# q7
data <- swiss[c(1, 2, 3, 6)]
md <- lm(data = data, Fertility ~ .)
md <- lm(swiss$Fertility ~  swiss$Agriculture +
                            swiss$Examination +
                            swiss$Infant.Mortality)
md
smr <- summary(md)
smr
anv <- anova(md)
new <- data.frame(Agriculture = 39.7, Examination = 5, Infant.Mortality = 20.2)
ci <- predict(md,
        level = 0.95, # this is the default, can drop
        newdata = new,
        interval = "confidence")
View(ci)


# Quiz 2 Practice
# q3
q3_data <- trees
q3_data <- cbind(q3_data, HS = q3_data$Height^2)
q3 <- lm(Volume ~ Height + HS, data = q3_data)
q3
summary(q3)

# q4
require(dplyr)
require(glmnet)
require(caret)
set.seed(123)

q4_train <- iris %>% sample_frac(0.8)
q4_test <- iris %>% setdiff(q4_train)

q4_y_train <- q4_train[, "Sepal.Length"]
q4_x_test <- data.matrix(q4_train[, c("Sepal.Width", "Petal.Length", "Petal.Width")])
# q4_x_train <- model.matrix(~., data = q4_train[, 2:4])

q4_y_test <- q4_test[, "Sepal.Length"]
q4_x_test <- data.matrix(q4_test[, c("Sepal.Width", "Petal.Length", "Petal.Width")])
# q4_x_test <- model.matrix(~., data = q4_test[, 2:4])

lambda_seq <- 10^seq(-3, 3, length = 100)

# ridge
# q4_cv <- cv.glmnet(q4_x_train, q4_y_train, alpha = 0, lambda = lambda_seq)
q4_cv <- cv.glmnet(q4_x_train, q4_y_train, alpha = 0, lambda = lambda_seq, n_folds = 5)

q4_lambda <- q4_cv$lambda.min
q4_model <- glmnet(q4_x_train, q4_y_train, alpha = 0, lambda = q4_lambda)
coef(q4_model)

q4_pred <- predict(q4_model, s = q4_lambda, newx = q4_x_test)
q4_r2 <- R2(q4_y_test, q4_pred)
q4_r2

# lasso
q4_cv <- cv.glmnet(q4_x_train, q4_y_train, alpha = 1, lambda = lambda_seq, n_folds = 5)
q4_lambda <- q4_cv$lambda.min
q4_model <- glmnet(q4_x_train, q4_y_train, alpha = 0, lambda = q4_lambda)
coef(q4_model)

q4_pred <- predict(q4_model, s = q4_lambda, newx = q4_x_test)
q4_r2 <- R2(q4_y_test, q4_pred)
q4_r2


# Quiz 2
# q11
q11 <- read.csv("rm/data/usap.csv")
q11_model <- lm(vs ~ gr + pr + gr:pr, data = q11)
summary(q11_model)

# q12
q12 <- longley
q12_train <- head(q12, 12)
q12_test <- setdiff(q12, q12_train)
dim(q12)
dim(q12_train)
dim(q12_test)

q12_y_train <- q12_train$Employed
q12_x_train <- q12_train[, 1:6]

q12_y_test <- q12_test$Employed
q12_x_test <- data.matrix(q12_test[, 1:6])

q12_model <- glmnet(q12_x_train, q12_y_train, alpha = 0, lambda = 0.01, nfolds = 5)
coef(q12_model)

q12_pred <- predict(q12_model, s = 0.01, newx = q12_x_test)
q12_rmse <- RMSE(q12_y_test, q12_pred)
q12_r2 <- R2(q12_y_test, q12_pred)

q12_pred
q12_y_test
q12_residual <- q12_y_test - q12_pred  # The working and response residuals are ‘observed - fitted’.
sum(q12_residual)
