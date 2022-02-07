# Regression Modelling Lab Week 5

# 3.3
movie_data <- read.csv("rm/data/movies.csv")
View(movie_data)

# a
model_data <- movie_data[, -1]

result_1 <- lm(Box ~ Rate + User + Meta + Len + Win + Nom, data = model_data)
anova(result_1)

result_2 <- lm(Box ~ ., data = model_data)
anova(result_2)
deviance(result_2) # another method to get SSR, SSR is basically deviance of it.
# Residual sum of squares for this model:
#   32435

# b
result_3 <- lm(Box ~ Rate + User + Meta, data = model_data)
anova(result_3)
deviance(result_3) # another method to get SSR
# Residual sum of squares for this model:
#   32823

# c
# H0: b4 = b5 = b6 = 0; HA: at least 1 of them is not 0.
# F = (RSSR - RSSC)/(k - r) / RSSC/(n - k - 1) # nolint
#   = (32823 - 32435)/(6 - 3) / 32435/(25 - 6 - 1)
f_statistic <- (32823 - 32435) / (6 - 3) / 32435 / (25 - 6 - 1)
# Significance level = 5%
sl <- 0.05
# Critical value
df_num <- 6 - 3
df_den <- 25 - 6 - 1
f_critical <- qf(sl, df_num, df_den, lower.tail = F)
p_value <- pf(f_statistic, df_num, df_den, lower.tail = F)
# f_statistic < f_critical. Can not reject N0

# d
anova(result_2, result_3)

# e
summary(result_2)
summary(result_3)

# 3.6
smsa_data <- read.csv("rm/data/smsa.csv")
View(smsa_data)

# a
model_data_2 <- smsa_data[, -1]
result_4 <- lm(Mort ~ ., data = model_data_2)
anova(result_4)
deviance(result_4)

# b
model_data_3 <- smsa_data[, 2:7]
result_5 <- lm(Mort ~ ., data = model_data_3)
anova(result_5)
deviance(result_5)

# H0: b6 = b7 = 0; HA: at least 1 of them is not 0.
# F = (RSSR - RSSC)/(k - r) / RSSC/(n - k - 1) # nolint
#   = (60948 - 60417)/(7 - 5) / 60417/(56 - 7 - 1)
f_statistic <- (60948 - 60417) / (7 - 5) / 60417 / (56 - 7 - 1)
# Significance level = 5%
sl <- 0.05
# Critical value
df_num <- 7 - 5
df_den <- 56 - 7 - 1
f_critical <- qf(sl, df_num, df_den, lower.tail = F)
p_value <- pf(f_statistic, df_num, df_den, lower.tail = F)
# f_statistic < f_critical. Can not reject N0 which means the two extra
# predictors do not provide significant information

anova(result_4, result_5)
# F < F Critical and P-Value > 0.05

# c
summary(result_5)
# Since the absolute values of these statistics are all greater than the 97.5th
# percentile of the t distribution with 50 degrees of freedom (2.01), we reject
# the null hypothesis (in each case) in favour of the alternative. Meaning, all
# of them have significant relation with response.

# d
plot(result_5, 1) # Fitted value residuals
plot(result_5$residuals ~ Edu, data = model_data_3)
plot(result_5$residuals ~ Nwt, data = model_data_3)
plot(result_5$residuals ~ Jant, data = model_data_3)
plot(result_5$residuals ~ Rain, data = model_data_3)
plot(result_5$residuals ~ Nox, data = model_data_3)
hist(result_5$residuals) # Histogram for fitted value residuals
plot(result_5, 2) # Q-Q plot

# e
# Coefficients:
#              Estimate
# (Intercept) 1028.2323
# Edu          -15.5887
# Nwt            4.1807
# Jant          -2.1313
# Rain           1.6331
# Nox           18.4132

# f
new_sample <- data.frame(Edu = 10, Nwt = 15, Jant = 35, Rain = 40, Nox = 2)
conf_inter <- predict(result_5,
                      newdata = new_sample,
                      interval = "confidence")
View(conf_inter) # the Mort is between (,) with 95% CI

# g
pred_inter <- predict(result_5,
                      newdata = new_sample,
                      interval = "prediction")
View(pred_inter) # 95% of the Mort is predicted to be between (,)
