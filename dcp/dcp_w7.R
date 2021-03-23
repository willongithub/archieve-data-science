# DCP Lab Week 7

# E1
df1 <- data.frame(
    col1 = c(1:3, NA),
    col2 = c("this", NA, "is", "text"),
    col3 = c(TRUE, FALSE, TRUE, TRUE),
    col4 = c(2.5, 4.2, 3.2, NA),
    stringsAsFactors = FALSE
)

# 1
sum(is.na(df1))

# 2
which(is.na(df1))

# 3
colSums(is.na(df1))

# 4
rowSums(is.na(df1))

# 5
df1[which(is.na(df1["col1"]) == T), "col1"] <- 0

# 6
mean(df1$col4, na.rm = T)

# 7
df1[which(is.na(df1["col4"]) == T), "col4"] <- mean(df1$col4, na.rm = T)

# E2
# 1
data(airquality)

# 2
dim(airquality)

# 3
head(airquality)
tail(airquality)

# 4
complete.cases(airquality)

# 5
colSums(is.na(airquality)) > 0

# 6
sum(complete.cases(airquality))

# 7
complete_aq <- airquality[complete.cases(airquality), ]

# 8
colMeans(complete_aq)

# E3
require(zoo)

airquality$Solar_m <- airquality$Solar.R
airquality$Solar_i <- airquality$Solar.R

airquality$Solar_m[is.na(airquality$Solar_m)] <- mean(airquality$Solar_m, na.rm = T)

airquality$Solar_i <- na.approx(airquality$Solar_i)
