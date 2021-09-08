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
