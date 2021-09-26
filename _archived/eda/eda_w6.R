### EDA Lab Week 6

require(ggplot2)
require(GGally)
require(reshape2)
require(readr)
require(dplyr)

## Exercise 1
# a
names(swiss)
head(swiss, 3)

# b
swiss_cor <- round(cor(swiss), 2)

# c
swiss_cor %>%
melt() %>%
ggplot(aes(x = Var1, y = Var2, fill = value)) +
    geom_tile()

# d
swiss_cor %>%
melt() %>%
ggplot(aes(x = Var1, y = Var2, fill = value)) +
    geom_tile(colour = "white") +
    scale_fill_gradient(low = "yellow", high = "black")

# e
swiss_cor %>%
melt() %>%
ggplot(aes(x = Var1, y = Var2, fill = value)) +
    geom_tile(colour = "white") +
    scale_fill_gradient2(low = "yellow", high = "black",
                        mid = "white", midpoint = 0,
                        limit = c(-1, 1), name = "Correlation") +
    ggtitle("Correlation Heatmap") +
    theme_grey() +
    theme(axis.text.x = element_text(angle = 45, vjust = 0.5),
          axis.text.y = element_text(angle = 45, hjust = 0.5),
          axis.title.x = element_blank(),
          axis.title.y = element_blank()) +
    coord_fixed()

# f
swiss_cor %>%
melt() %>%
ggpairs(aes(alpha = 0.4))


# Exercise 2
# a
melbourne_house <- na.omit(read_csv("eda/Melbourne_housing_FULL.csv"))

# b
ggplot(melbourne_house, aes(x = Price)) +
    geom_histogram(aes(fill = Regionname),
                        position = position_stack(),
                        binwidth = 100000) +
    ggtitle("House Price of Melbourne") +
    scale_x_continuous(name = "Price (AUD)", label = scales::comma)

# c
melbourne_house %>%
    group_by(Regionname, Type) %>%
    summarize(Count = n()) %>%
    ggplot(aes(x = Regionname, y = Count, fill = Type)) +
        geom_bar(position = "stack", stat = "identity") +
        xlab("Region") +
        ylab("Sales") +
        ggtitle("Sales by Region") +
        scale_fill_manual(name = "Type of Property",
                          labels = c("House", "Townhouse", "Unit"),
                          values = c("red", "yellow", "blue"))

# d
melbourne_house %>%
    group_by(Regionname) %>%
    mutate(count_region = n()) %>%
    summarize(count = n())
    group_by(Regionname, Type) %>%
    summarize(percent_type = n() / count_region) %>%
    ggplot(aes(x = Regionname, y = Percent, fill = Type)) +
        geom_bar(position = "stack", stat = "identity") +
        xlab("Region") +
        ylab("Sales (%)") +
        ggtitle("Sales (%) by Type") +
        scale_fill_manual(name = "Type of Property",
                          labels = c("House", "Townhouse", "Unit"),
                          values = c("red", "yellow", "blue"))

# e
 %>%
round(cor(), 2) %>%
melt() %>%
ggplot(aes(x = Var1, y = Var2, fill = value)) +
    geom_tile(colour = "black") +
    scale_fill_gradient2(low = "yellow", high = "black",
                        mid = "white", midpoint = 0,
                        limit = c(-1, 1), name = "Correlation") +
    ggtitle("Correlation Heatmap") +
    theme(axis.text.x = element_text(angle = 45, vjust = 0.5),
          axis.text.y = element_text(angle = 45, hjust = 0.5),
          axis.title.x = element_blank(),
          axis.title.y = element_blank())
