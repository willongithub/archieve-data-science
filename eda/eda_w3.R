# EDA Lab Week 3

library(ggplot2)
library(MASS)
library(dplyr)

# 1b
ggplot(trees, aes(x = Height, fill = ..count..)) +
  geom_histogram(binwidth = 10) +
  xlab("Height (ft)") +
  ylab("Observations") +
  ggtitle("Heights of Black Cherry Trees") +
  theme_grey()

# 2b
# histogram for weight of cabbage head
ggplot(cabbages, aes(x = HeadWt, fill = ..count..)) +
  geom_histogram(binwidth = 0.3) +
  xlab("Weight (kg)") +
  ylab("Observations") +
  ggtitle("Weight of Cabbage Head") +
  theme_light()

# histogram for Vitamin C in the cabbage
ggplot(cabbages, aes(x = VitC, fill = ..count..)) +
  geom_histogram(binwidth  = 5) +
  xlab("Cabbages") +
  ylab("Observations") +
  ggtitle("Ascorbic Acid Content") +
  theme_grey()

# 2d
# group the dataset by Cult and summarise
group_cult <- 
  cabbages %>%
  group_by(Cult) %>%
  summarise(
    Mid_Vitamin_C_Content = median(VitC),
    Mid_Head_Weight = median(HeadWt)
  )
View(group_cult)

# 2e
# frequency bar plot of Cult and Date
ggplot(cabbages, aes(Cult, fill = Cult)) +
  geom_bar() +
  xlab("Cult") +
  ylab("Frequency") +
  ggtitle("Frequency of Cult")
  theme_gray()

ggplot(cabbages, aes(Date, fill = ..count..)) +
  geom_bar() +
  xlab("Cult") +
  ylab("Frequency") +
  ggtitle("Frequency of Cult")
  theme_gray()

# 3b
df <- read.csv("airquality.csv")
ggplot(df, aes(Ozone, fill = ..count..)) +
  geom_histogram(binwidth  = 10) +
  xlab("Ozone") +
  ylab("Observations") +
  ggtitle("Air Quality of New York") +
  theme_gray()
