# EDA Online Quiz 1 Part I
# 3229442 Siqi Wu

require(ggplot2)
require(dplyr)

## Q1
# a
?ChickWeight
# The ChickWeight data frame has 578 rows and 4 columns
# from an experiment on the effect of diet on early growth
# of chicks.

# b
ggplot(ChickWeight, aes(x = Diet, y = weight)) +
    geom_boxplot() +
    xlab("experimental diet categories") +
    ylab("weight distributions") +
    ggtitle("Chicken Weight VS Diet Type") +
    theme_grey()
# From diet 1 to 4 the median weight increases while
# the distribution of weight spreads except diet 4.

# c
ggplot(ChickWeight, aes(x = Diet, y = weight, fill = Diet)) +
    geom_boxplot() +
    xlab("experimental diet categories") +
    ylab("weight distributions") +
    ggtitle("Chicken Weight VS Diet Type") +
    scale_fill_manual(name = "Diet Type",
                    values = c("yellow", "orange", "red", "darkred")) +
    theme_grey()

# d
ggplot(ChickWeight, aes(x = Diet, y = weight, fill = Diet)) +
    geom_violin(draw_quantiles = c(0.25, 0.5, 0.75)) +
    xlab("experimental diet categories") +
    ylab("weight distributions") +
    ggtitle("Chicken Weight VS Diet Type") +
    scale_fill_manual(name = "Diet Type",
                    values = c("yellow", "orange", "red", "darkred")) +
    theme_grey()
# Using violin plot, we are able to show more information
# regarding the distribution across the range of weight not
# just a summary of the distribution as a whole in boxplot.

# e
ChickWeight %>%
    group_by(Time) %>%
    summarize(median_weight_time = median(weight)) %>%
    ggplot(aes(x = Time, y = median_weight_time, fill = median_weight_time)) +
        geom_bar(stat = "identity") +
        xlab("number of days") +
        ylab("median weight (gm)") +
        ggtitle("Median Weight vs Time") +
        scale_fill_gradient(name = "weight (gm)",
                            low = "red", high = "black") +
        theme_grey()
# Along the x axis which is in days, the last data point has
# different time interval than the others that looks odd. But
# it is not an error.

##########
## Q2
# a
?ToothGrowth
# The ToothGrowth dataset shows the effect of Vitamin C on tooth growth
# in Guinea Pigs. The response is the length of the cells responsible
# for tooth growth in 60 pigs. Each received one of three dose levels
# of VC by one of two delivery methods.

# b
ggplot(ToothGrowth, aes(x = len)) +
    geom_histogram() +
    xlab("length of tooth") +
    ylab("observation") +
    ggtitle("Histogram of Tooth Length") +
    theme_grey()

# c
# There are very few observations above 30 while the most fall between
# 25 to 27.

# d
ggplot(ToothGrowth, aes(x = len, fill = ..count..)) +
    geom_histogram(bins = 8) +
    xlab("length of tooth") +
    ylab("observation") +
    ggtitle("Histogram of Tooth Length") +
    scale_fill_gradient(name = "count",
                        low = "red", high = "darkred") +
    theme_grey()

# e
ggplot(ToothGrowth, aes(x = len, fill = ..count..)) +
    geom_histogram(bins = 15) +
    xlab("length of tooth") +
    ylab("observation") +
    ggtitle("Histogram of Tooth Length") +
    scale_fill_gradient(name = "count",
                        low = "red", high = "darkred") +
    theme_grey()
# For the purpose of histgram, we want to reveal the distribution
# of observations, too wide of a binwidth may cover too many data
# points in one bin so that their distribution is hidden inside the
# bin. On the other hand, if the binwidth is too narrow, there will
# be very few data points in each bin or even none. In this case, it
# can be hard to find the distribution as well.

# f
ggplot(ToothGrowth, aes(x = dose, fill = ..count..)) +
    geom_bar() +
    xlab("dose (mg/day)") +
    ylab("observation") +
    ggtitle("Dose of Supplements") +
    scale_fill_gradient(name = "Dose Level",
                        low = "red", high = "darkred") +
    theme_grey()

# g
ToothGrowth %>%
    group_by(dose) %>%
    summarize(median_len_dose = median(len)) %>%
    View()

# h
ToothGrowth %>%
    group_by(dose, supp) %>%
    summarize(median_len_dose_supp = median(len)) %>%
    View()

# i
ToothGrowth %>%
    group_by(dose) %>%
    summarize(mean_len_dose = mean(len)) %>%
    View()

# j
# Both of them are grouped by levels of doses, but the means
# all slight larger than median. This can be an indication
# of right skewness of the distribution

# k
ggplot(ToothGrowth, aes(x = dose, y = len)) +
    geom_point(aes(size = 3, colour = dose)) +
    xlab("dose (mg/day)") +
    ylab("length of tooth") +
    ggtitle("Length vs Dose") +
    theme_grey()
# From the plot we can see the tooth growth increases as dose
# level increases.

# l
ggplot(ToothGrowth, aes(x = dose, y = len)) +
    geom_jitter(aes(size = 3, colour = dose)) +
    geom_smooth(method = "lm") +
    xlab("dose (mg/day)") +
    ylab("length of tooth") +
    ggtitle("Length vs Dose") +
    theme_grey()
# The jitter plot spread the data points in dense area so that
# reveal the distribution more clearly. The smooth function reveals
# the relationship between the two sets of data as a linear trend line.

##########
## Q3
# a
?storms
# This dataset includes the positions and attributes of 198 tropocal
# storms, masured every 6 hours during the storm.

# b
ggplot(storms, aes(x = pressure, y = wind)) +
    geom_jitter(aes(colour = pressure)) +
    xlab("center air pressure (millibars)") +
    ylab("maximum sustained wind speed (knots)") +
    ggtitle("Wind Speed vs Air Pressure") +
    scale_colour_gradient(low = "yellow", high = "black") +
    theme_grey()

# c
ggplot(storms, aes(x = pressure, y = wind)) +
    geom_jitter(aes(colour = pressure)) +
    geom_smooth(method = "lm") +
    xlab("center air pressure (millibars)") +
    ylab("maximum sustained wind speed (knots)") +
    ggtitle("Wind Speed vs Air Pressure") +
    scale_colour_gradient(low = "yellow", high = "black") +
    theme_grey()

# d
ggplot(storms, aes(x = long, y = lat, colour = wind)) +
    geom_bin2d(bins = 50) +
    xlab("longitude") +
    ylab("latitude") +
    ggtitle("Wind Speed vs Location") +
    scale_fill_gradient(name = "Wind Speed (knots)",
                        low = "yellow", high = "black") +
    theme_grey()
# From this plot, more high wind speed happend in the west area.

# e
ggplot(storms, aes(x = category, y = wind)) +
    geom_boxplot(aes(fill = category)) +
    xlab("storm category") +
    ylab("wind speed (knots)") +
    ggtitle("Wind Speed vs Storm Category") +
    scale_fill_discrete(name = "Storm Category") +
    theme_grey()

# f
storms %>%
    group_by(name) %>%
    summarize(median_wind_name = median(wind)) %>%
    slice_max(n = 10, order_by = median_wind_name) %>%
    ggplot(aes(x = name, y = median_wind_name, fill = name)) +
        geom_bar(stat = "identity") +
        xlab("storm") +
        ylab("median wind speed (knots)") +
        ggtitle("Wind Speed of Top 10 Storms") +
        theme_grey()

# g
# Group by year and plot top 10 year of average wind speed.
storms %>%
    group_by(year) %>%
    summarize(mean_wind_year = mean(wind)) %>%
    slice_max(n = 10, order_by = mean_wind_year) %>%
    ggplot(aes(x = year, y = mean_wind_year)) +
        geom_bar(stat = "identity", aes(fill = mean_wind_year)) +
        xlab("year") +
        ylab("mean wind speed (knots)") +
        ggtitle("Top 10 Yearly Average Wind Speed of Storms") +
        scale_fill_gradient(low = "yellow", high = "darkred") +
        theme_grey()

# Group by month and show distribution of top 5 months of wind
# speed in parallel boxplot.
top_three_month <- storms %>%
    group_by(month) %>%
    summarize(mean_wind_month = mean(wind)) %>%
    slice_max(n = 3, order_by = mean_wind_month)

storms %>%
    filter(month %in% top_three_month$month) %>%
    ggplot(aes(x = as.factor(month), y = wind)) +
        geom_boxplot(aes(fill = as.factor(month))) +
        xlab("month") +
        ylab("wind speed (knots)") +
        ggtitle("Top 3 Monthly Average Wind Speed of Storms") +
        scale_fill_manual(name = "Month",
                        limit = c("9", "10", "11"),
                        values = c("red", "yellow", "blue")) +
        theme_grey()
