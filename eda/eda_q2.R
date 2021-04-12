### EDA Online Quiz 2 Part I
# u3229442 Siqi Wu

require(caret)
require(ggplot2)
require(dplyr)
require(GGally)

## Question A:
# 1
quakes %>%
    ggplot(aes(x = mag, y = stations)) +
    geom_point() +
    ggtitle("# of Repoting Stations vs Quake Magnitude") +
    xlab("Richter magnitude") +
    ylab("Number of stations reporting") +
    theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
          axis.title = element_text(size = 10, hjust = 0.5))

# 2
quakes %>%
    ggplot(aes(x = mag, y = stations)) +
    geom_jitter() +
    ggtitle("# of Repoting Stations vs Quake Magnitude") +
    xlab("Richter magnitude") +
    ylab("Number of stations reporting") +
    theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
          axis.title = element_text(size = 10, hjust = 0.5))

# With the help of jittering of data points the plot is clearer. Jitter
# solves the problem of overplotting.

# 3
?quakes
# It is logically to think as the magnitude of a earthquake getting higher,
# the area affected is wider, so we can see from the plot that, higer magnitude
# of earthquake were reported from more stations.
cor(x = quakes$stations, y = quakes$mag)

# 4
# The presumption is logical in concept but we still need to quantify the
# theory using the data.

# 5
quakes %>%
    ggplot(aes(x = mag, y = stations)) +
    geom_jitter(aes(colour = depth)) +
    ggtitle("# of Repoting Stations vs Quake Magnitude") +
    xlab("Richter magnitude") +
    ylab("Number of stations reporting") +
    theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
          axis.title = element_text(size = 10, hjust = 0.5)) +
    scale_colour_gradient(name = "Depth",
                          low = "yellow", high = "black")
# From this plot, we could not find significant relation between the depth
# and magnitude or number of reporting stations.

quakes %>%
    select(depth, mag, stations) %>%
    ggcorr(label = T, name = "rho")
# From this correlation heat map, we can see the relation between depth
# of the quakes and magnitudes or numbers of reporting stations is quite
# weak (correlation coefficient close to zero).

# 6
quakes %>%
    ggplot(aes(x = lat, y = long)) +
    geom_point() +
    ggtitle("Location of the Quakes") +
    xlab("Latitude") +
    ylab("Longtitude")

# 7
quakes %>%
    ggplot(aes(x = lat, y = long)) +
    geom_bin2d(bins = 10, aes(fill = ..count..)) +
    ggtitle("Location of the Quakes") +
    xlab("Latitude") +
    ylab("Longtitude") +
    scale_fill_gradient(low = "navy", high = "lightpink") +
    theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
          axis.title = element_text(size = 12, hjust = 0.5))

## Question B:
# 1
length(unique(mpg$manufacturer))

# 2
mpg %>%
    ggplot(aes(x = hwy)) +
        geom_histogram(binwidth = 2, aes(fill = ..count..)) +
        ggtitle("Distribution of vehicle's mpg on highway") +
        xlab("mpg on highway") +
        ylab("# of observations") +
        scale_fill_gradient(name = "# of observations",
                            low = "navy", high = "lightpink") +
        theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
              axis.title = element_text(size = 12, hjust = 0.5),
              axis.ticks = element_blank())

# From the histogram, we can see that most vehicles' mpg fall between
# 15 and 29, while the most are in the bin of 25 to 27.

# 3
mpg %>%
    ggplot(aes(x = hwy)) +
        geom_histogram(binwidth = 1,
                       aes(fill = as.character(cyl)),
                       position = "stack") +
        ggtitle("Distribution of vehicle's mpg on highway") +
        xlab("mpg on highway") +
        ylab("# of observations") +
        theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
              axis.title = element_text(size = 12, hjust = 0.5),
              axis.ticks = element_blank()) +
        scale_fill_manual(name = "# of engine cylinders",
                          labels = c("4", "5", "6", "8"),
                          values = c("red", "yellow", "blue", "green"))

# From this stacked histogram, we can see vehicles with 4 cylinders tend to be
# more fuel efficient, while 8 cylinder cars show poor fuel economy among all
# cars. And 5 cylinder cars perform similar to 6 cylinder cars.

# 4
mpg %>%
    ggplot(aes(x = cty)) +
        geom_histogram(binwidth = 4, aes(fill = ..count..)) +
        ggtitle("Distribution of vehicle's mpg in the city") +
        xlab("mpg in the city") +
        ylab("# of observations") +
        scale_fill_gradient(name = "# of observations",
                            low = "navy", high = "lightpink") +
        theme_gray()

# We can from the plot that most of the mpg in the city fall between 10 and
# 24, which is lower than those on highway.

# 5
mpg %>%
    ggplot(aes(x = cty)) +
        geom_histogram(binwidth = 4,
                       aes(fill = as.character(cyl)),
                       position = "stack") +
        ggtitle("Distribution of vehicle's mpg in the city") +
        xlab("mpg in the city") +
        ylab("# of observations") +
        scale_fill_manual(name = "# of engine cylinders",
                          labels = c("4", "5", "6", "8"),
                          values = c("red", "yellow", "blue", "green")) +
        theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
              axis.title = element_text(size = 12, hjust = 0.5))

# The distribution of mpg on highway is bimodal while mpg in the city
# is monomodal. We can conclude that on highway the fuel efficiency of
# vehicles with different numbers of cylinders could perform much differently
# than in the city.

# 6
mpg %>%
    ggplot(aes(x = class)) +
        geom_bar(aes(fill = as.character(cyl)),
                 position = "stack") +
        ggtitle("Distribution of vehicle's class") +
        xlab("class") +
        ylab("# of observations") +
        scale_fill_manual(name = "class of cars",
                          labels = c("4", "5", "6", "8"),
                          values = c("tomato2", "yellowgreen",
                                     "cornflowerblue", "steelblue",
                                     "slateblue4")) +
        theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
              axis.title = element_text(size = 12, hjust = 0.5))

# 7
mpg %>%
    ggplot(aes(x = reorder(class, class, function(x) -length(x)))) +
        geom_bar(aes(fill = as.character(cyl)),
                 position = "stack") +
        ggtitle("Distribution of vehicle's class") +
        xlab("class") +
        ylab("# of observations") +
        scale_fill_manual(name = "class of cars",
                          labels = c("4", "5", "6", "8"),
                          values = c("tomato2", "yellowgreen",
                                     "cornflowerblue", "steelblue",
                                     "slateblue4")) +
        theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
              axis.title = element_text(size = 12, hjust = 0.5))

# From the plot, we can see SUV is the most popular while 2seater is the least
# popular. 4 cylinder cars are mainly in compact or subcompact class.

# 8
# The colour scale used is "scale_fill_manual" which suits the bar plot. It
# shows extra layer of information of cylinders by the colour filling the
# bar which help me gain insight of the engine setup of each class of cars.

# 9
cty <- mpg %>%
    group_by(fl) %>%
    summarize(avg = mean(cty),
              env = "cty")

hwy <- mpg %>%
    group_by(fl) %>%
    summarize(avg = mean(hwy),
              env = "hwy")

avg_cty_hwy <- rbind(cty, hwy)

avg_cty_hwy %>%
    ggplot(aes(x = reorder(fl, avg), y = avg, fill = env)) +
        geom_bar(position = "dodge",
                 stat = "identity") +
        ggtitle("Average MPG vs Fuel Type") +
        xlab("fuel type") +
        ylab("mpg") +
        scale_fill_manual(labels = c("cty" = "In the City",
                                     "hwy" = "On Highway"),
                          values = c("red", "blue"),
                          name = "") +
        scale_x_discrete(labels = c("c" = "CNG", "d" = "Diesel", "e" = "E95",
                                     "p" = "Premium", "r" = "Regular")) +
        theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
              axis.title = element_text(size = 12, hjust = 0.5))

# 10
# We can conclude from the plot that, generally, higher mpg can be achieved
# on highway on each fuel type. CNG is the most fuel efficient type while
# E95 is the worst on highway. But, in the city, diesel car can acheieve
# higher mpg than CNG.

# 11
mpg %>%
ggplot(aes(x = manufacturer, y = cty, fill = manufacturer)) +
    geom_boxplot() +
    ggtitle("MPG (city) vs Manufacturer") +
    xlab("manufacturer") +
    ylab("mpg (city)") +
    theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
          axis.title = element_text(size = 12, hjust = 0.5),
          axis.text.x = element_text(vjust = 0.5, angle = 45))

# From the boxplots, we can clearly see that the mean mpg and spread
# of the mpg distribution among different manufacturers are quite
# different. There are outliers from Volkswagen, Mercury, Honda and
# Chevolet. The reason here is different brands consist of different
# product line which means different type of car and different
# configration of engine. These boxplots could not deliver these extra
# information.

# 12
mpg %>%
ggplot(aes(x = manufacturer, y = cty)) +
    geom_boxplot() +
    geom_jitter(aes(colour = class),
                size = mpg$displ,
                width = 0.1) +
    ggtitle("MPG (city) vs Manufacturer") +
    xlab("manufacturer") +
    ylab("mpg (city)") +
    scale_colour_manual(name = "Type of Car",
                        values = c("red", "orange", "yellow",
                                   "green", "cyan", "blue",
                                   "purple"))
    theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
          axis.title = element_text(size = 12, hjust = 0.5),
          axis.text.x = element_text(vjust = 0.5, angle = 45))

# An extra layer of jitter points have been added. Now we are able to
# identify the product combination of each brand which significantly
# affect the location and variation of the boxplots. The colour of the
# dots represent the class of the car while the size of the dots represent
# the engine displacement. We can see the brands with more SUV and pickup
# truck as well as larger engine size average low mpg. And brands with
# wider product line like Nissan and Toyota show wider spread of the box.
