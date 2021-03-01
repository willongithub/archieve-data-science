# EDA Lab Week 4

require(dplyr)
require(ggplot2)
require(MASS)

# 1a
air <- read.csv("airquality.csv")
air_neat <- air[which(is.na(air)), ]
# 1b
air_median_by_month <- 
  air_neat %>% 
  group_by(Month) %>% 
  summarize(Ozone_median = median(Ozone),
            Solar.R_median = median(Solar.R),
            Wind_median = median(Wind),
            Temp_median = median(Temp))
# 1c
ggplot(air_median_by_month, aes(x = Month, y = Ozone_median)) +
  geom_bar(aes(color = Ozone_median)) +
  xlab("Time (month)") +
  ylab("Median Level of Ozone") +
  ggtitle("Median Level of Ozone") +
  theme_gray()
# 1d
ggplot(air_neat, aes(x = Month, y = Temp)) +
  geom_point(aes(color = Temp)) +
  geom_smooth(method = "lm") +
  xlab("Time (month)") +
  ylab("Temperature") +
  ggtitle("Temp vs Time") +
  theme_gray()

# 2b & 2c
ggplot(Cars93, aes(x = Horsepower, y = MPG.city)) +
  geom_point(aes(color = Horsepower)) +
  geom_smooth(method = "lm")
  xlab("Power (hp)") +
  ylab("MPG") +
  ggtitle("Fuel Efficiency vs Power of Cars") +
  theme_gray()

# 2d
top_ten <- Cars93 %>%
  count(Manufacturer) %>%
  slice_max(n = 10, order_by = n) %>%
  as.data.frame()
Cars93 %>%
  filter(Manufacturer %in% top_ten$Manufacturer) %>%
  ggplot(aes(x = Manufacturer, fill = ..count..)) +
    geom_bar(aes(color = Manufacturer)) +
    xlab("Manufacturer") +
    ylab("Frequency") +
    ggtitle("Top 10 Car Manufacturer") +
    theme_gray()

# 2e

