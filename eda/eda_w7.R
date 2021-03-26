# EDA Lab Week 7

require(ggplot2)
require(dplyr)
require(readr)
require(egg)

# 1a
head(economics)

# 1b
economics %>%
    filter(date > "2010-01-01") %>%
    ggplot(aes(x = date, y = pop)) +
        geom_line() +
        geom_smooth(se = FALSE)

# 1c
economics %>% select(date, psavert, uempmed)

# 1d
economics %>%
    select(date, psavert, uempmed) %>%
    filter(date < "2013-12-31" & date > "2010-01-01") %>%
    ggplot(aes(x = date)) +
        geom_line(aes(y = psavert)) +
        geom_line(aes(y = uempmed))

# 1e
economics %>%
    select(date, psavert, uempmed) %>%
    filter(date < "2013-12-31" & date > "2010-01-01") %>%
    ggplot(aes(x = date)) +
        geom_line(aes(y = psavert)) +
        geom_line(aes(y = uempmed)) +
        scale_x_date(date_breaks = "3 month", date_labels = "%m/%y")

# 2a
house_mel <- na.omit(read_csv("eda/Melbourne_housing_FULL.csv"))

median_house <- house_mel %>%
    group_by(Date, Type) %>%
    summarize(time = Date,
              median_price = median(Price, na.rm = T)) %>%
    ggplot(aes(x = time, y = median_price, group = Type, colour = Type)) +
        geom_line() +
        scale_colour_manual(name = "Type of Property",
                            labels = c("House", "Townhouse", "Unit"),
                            values = c("red", "yellow", "blue"))

# 2b
sales_house <- house_mel %>%
    group_by(Date) %>%
    summarize() %>%
    ggplot(aes(x = Date, y = Count,
                      colour = Type, group = Type)) +
    geom_line() +
    scale_colour_manual(name = "Type of Property",
                            labels = c("House", "Townhouse", "Unit"),
                            values = c("red", "yellow", "blue"))

ggarrange(sales_house, median_house, ncol = 1)

# 2c
sales_house +
    theme(axis.text.x = element_blank())
median_house +
    theme(legend.title = element_blank(),
          legend.position = "bottom",
          axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))

# 2d
