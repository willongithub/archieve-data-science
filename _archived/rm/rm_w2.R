# RM Lab Week 2

library(readxl)

# 1.1
nbasalary <- read_excel("rm/data/nbasalary.csv")
head(nbasalary, 10)
attach(nbasalary)
Salary
mean(Salary)
median(Salary)
hist(Salary)
IQR(Salary)
boxplot(Salary)
qqnorm(Salary)
qqline(Salary)
logSalary <- log(Salary)
head(logSalary)

countries <- read.csv("rm/data/countries.csv")
attach(countries)
t.test(Life)
t.test(Life, conf.level=0.9)
t.test(Life, conf.level=0.99)

# a

# b

# c

# d

# e

# f

# g

# 1.4
# a

# b

# c

# d

# e

# f

# 1.5
# a

# b

# c
