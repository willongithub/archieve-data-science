# Regression Modelling Lab Week 12

# 1
data_1 <- read.csv("rm/data/twomodes.csv")
head(data_1)

# a
hist(data_1$failures)
# plot(density(data_1$failures))

# b
model_1 <- glm(data = data_1,
    failures ~ mode1 * mode2,
    family = poisson)
# model_1 <- glm(data = data_1,
#     failures ~ mode1 + mode2 + mode1:mode2,
#     family = poisson)

summary(model_1)

# c
model_1 <- glm(data = data_1,
    failures ~ mode1 + mode2,
    family = poisson)

summary(model_1)

# d
model_1 <- glm(data = data_1,
    failures ~ mode1,
    family = poisson)

summary(model_1)

predict(model_1, type = "response")

new_1 <- data.frame(mode1 = 19)

predict(model_1, newdata = new_1, type = "response")

# 2
require(faraway)
data_2 <- wafer
head(data_2)
plot(density(data_2$resist))
# hist(data_2$resist)

# a
model_2 <- lm(data =  data_2,
    log(resist) ~ x1 + x2 + x3 + x4)

summary(model_2)

exp(coef(model_2))

# b
model_2 <- glm(data =  data_2,
    resist ~ x1 + x2 + x3 + x4,
    family = Gamma(link = "link"))

summary(model_2)

exp(coef(model_2))

# c

# 3
data_3 <- read.csv("rm/data/crab.csv")
head(data_3)

# a
hist(data_3$Sa)
# plot(density(data_3$Sa))
plot(data = data_3,
    Sa ~ W)

# b
model_3 <- glm(data =  data_3,
    Sa ~ W,
    family = poisson(link = "log"))

summary(model_3)

# c
data_3$C <- as.factor(data_3$C)

model_3 <- glm(data =  data_3,
    Sa ~ C + W,
    family = poisson(link = "log"))

summary(model_3)

# d
data_3$C <- as.numeric(data_3$C)

model_3 <- glm(data =  data_3,
    Sa ~ C + W,
    family = poisson(link = "log"))

summary(model_3)

# e
model_3 <- glm(data =  data_3,
    Sa ~ C + S + Wt + W,
    family = poisson(link = "log"))

summary(model_3)