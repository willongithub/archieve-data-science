# RM Lab Week 3

require("readxl")

# 2.1
# a
internet <- read_excel("RM/data/internet.xls")
head(internet)
attach(internet)
plot(Int ~ Gdp)

rm1 <- lm(Int ~ Gdp)
abline(rm1)

anova(rm1)
summary(rm1)

# b

# c

# d

# e

# 2.3
# a
electricity <- read_excel("RM/data/electricity.xls")
head(electricity)
plot(electricuty$ELec ~ electricity$Gdp)

rm2 <- lm(electricity$Elec ~ electricity$Gdp)
abline(rm2)

summary(rm2)

# b

# c

# d

# e

# 2.10
# a
costs <- c(1000, 2180, 2240, 2410, 2590, 2820, 3060)
covers <- c(0, 60, 120, 133, 143, 175, 175)

rm3 <- lm(costs ~ covers)
abline(rm3)

anova(rm3)
summary(rm3)

# b

# c

# d

# e
