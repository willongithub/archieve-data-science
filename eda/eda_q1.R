# EDA Online Quiz 1

# Part I
# Q1
# a
?ChickWeight

# b
boxplot(ChickWeight$weight ~ ChickWeight$Diet,
    col = c("yellow", "orange", "red", "darkred"))

# c
summary(ChickWeight$weight)
legend(0.5, 370, c("Diet 1", "Diet 2", "Diet 3", "Diet 4"),
       fill = c("yellow", "orange", "red", "darkred"))
text(y = boxplot.stats(ChickWeight$weight)$stats,
    labels = boxplot.stats(ChickWeight$weight)$stats, x = 1)

# d

# e

# Q2
# a
?ToothGrowth

# b
hist(ToothGrowth$len)

# c
summary(ToothGrowth$len)

# d