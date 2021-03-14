# EDA Lab Week 4

require(dplyr)
require(ggplot2)
require(MASS)

# 1a
air <- read.csv("eda/airquality.csv")
air_neat <- na.omit(air)

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
  geom_bar(aes(fill = Ozone_median), stat = "identity") +
  xlab("Time (month)") +
  ylab("Median Level of Ozone") +
  ggtitle("Median Level of Ozone") +
  theme_gray()

# 1d
ggplot(air_neat, aes(x = Month, y = Temp)) +
  geom_jitter(width = 0.5, aes(color = Temp)) +
  geom_smooth(method = "auto") +
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
  theme_minimal()

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
    theme_minimal()

# 2e
Cars93 %>%
  group_by(Type) %>%
  summarize(Price_median = median(Price)) %>%
  ggplot(aes(x = Type, y = Price_median)) +
    geom_bar(stat = "identity", aes(fill = Type)) +
    xlab("Car Type") +
    ylab("Median Price") +
    ggtitle("Median Price of Cars") +
    theme_minimal()

# 2f
Cars93 %>%
  group_by(Manufacturer) %>%
  summarize(Efficiency_avr = mean(c(mean(MPG.city), mean(MPG.highway)))) %>%
  ggplot(aes(x = Manufacturer, y = Efficiency_avr)) +
    geom_bar(stat = "identity", aes(fill = Manufacturer)) +
    xlab("Manufacturer") +
    ylab("Average Fuel Efficiency (mpg)") +
    ggtitle("Fuel Efficiency by Manufacturer") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    theme_minimal()

# 2g
Cars93 %>%
  group_by(Manufacturer) %>%
  summarize(Efficiency_avr = mean(c(mean(MPG.city), mean(MPG.highway)))) %>%
  slice_max(n = 5, order_by = Efficiency_avr) %>%
  ggplot(aes(x = Manufacturer, y = Efficiency_avr)) +
    geom_bar(stat = "identity", aes(fill = Manufacturer)) +
    xlab("Manufacturer") +
    ylab("Average Fuel Efficiency (mpg)") +
    ggtitle("Top 5 of Fuel Efficiency by Manufacturer") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    theme_minimal()

# 2h
Cars93 %>%
  group_by(Passengers) %>%
  summarize(Efficiency_avr = mean(c(mean(MPG.city), mean(MPG.highway)))) %>%
  ggplot(aes(x = Passengers, y = Efficiency_avr)) +
    geom_bar(stat = "identity", aes(fill = Passengers)) +
    xlab("Passenger Seats") +
    ylab("Average Fuel Efficiency (mpg)") +
    ggtitle("Fuel Efficiency by Seats") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    theme_minimal()

# 3b
ggplot(crabs, aes(x = FL, y = BD)) +
  geom_point() +
  geom_smooth() +
  xlab("Frontal Lobe Size (mm)") +
  ylab("Body Depth (mm)") +
  ggtitle("Leptograpsus Crabs") +
  theme_minimal()

# 3c
ggplot(crabs, aes(x = FL, y = BD)) +
  geom_point() +
  geom_jitter(width = 2) +
  xlab("Frontal Lobe Size (mm)") +
  ylab("Body Depth (mm)") +
  ggtitle("Leptograpsus Crabs") +
  theme_minimal()

# 3d
ggplot(crabs, aes(x = FL, y = BD)) +
  geom_point() +
  geom_jitter(width = 2) +
  geom_smooth(method = "lm") +
  xlab("Frontal Lobe Size (mm)") +
  ylab("Body Depth (mm)") +
  ggtitle("Leptograpsus Crabs") +
  theme_minimal()

# 3e
ggplot(crabs, aes(x = FL, y = BD)) +
  geom_bin2d(bins = 30) +
  # geom_jitter(width = 2) +
  geom_smooth(method = "lm") +
  xlab("Frontal Lobe Size (mm)") +
  ylab("Body Depth (mm)") +
  ggtitle("Leptograpsus Crabs") +
  theme_minimal()

# 3f
ggplot(crabs, aes(x = CL, y = CW)) +
  geom_bin2d(bins = 30) +
  # geom_jitter(width = 2) +
  geom_smooth(method = "lm") +
  xlab("Carapace Length (mm)") +
  ylab("Carapace Width (mm)") +
  ggtitle("Leptograpsus Crabs") +
  theme_minimal()
