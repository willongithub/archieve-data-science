# IDS Lab Week 6

## E1
require(dplyr)
require(nycflights13)
# 1
filter(flights, arr_delay >= 120)

# 2
filter(flights, dest %in% c("IAH", "HOU"))

# 3
filter(flights, carrier %in% c("DL", "AA", "UA"))

# 4
filter(flights, between(month, 7, 9))

# 5
filter(flights, arr_delay > 120, dep_delay <= 0)

# 6
filter(flights, dep_delay >= 60, dep_delay - arr_delay > 30)

# 7
filter(flights, dep_time %% 2400 <= 600)

# 8
filter(flights, is.na(dep_time))

## E2
flights %>%
    group_by(month) %>%
    summarize(proportion_cancelled
        = sum(is.na(dep_time)) / length(dep_time)) %>%
    arrange(desc(proportion_cancelled))

## E3
require(ggplot2)

flights %>%
    group_by(tailnum) %>%
    summarize(from_nyc = sum(origin %in% c("JFK", "LGA", "EWR"))) %>%
    arrange(desc(from_nyc))

flights %>%
    mutate(week = 1 + (month - 1) * 4 + day %/% 7) %>%
    group_by(week) %>%
    summarize(trips = sum(!is.na(dep_time))) %>%
    ggplot(aes(x = week, y = trips, fill = trips)) +
        geom_bar(stat = "identity") +
        xlab("Weeks") +
        ylab("Trips") +
        ggtitle("Number of Trips per Week over the Year") +
        theme_grey()
# there is issue in the week count because the count based on individual
# month that lead to 48 weeks in total which ought to be 52,
# otherwise we need to count month by month.

## E4
flights %>%
    group_by(carrier) %>%
    summarize(avg_dep_delay = mean(dep_delay, na.rm = TRUE))

flights %>%
    group_by(dest) %>%
    summarize(min_arr_delay = min(arr_delay, na.rm = TRUE),
                max_arr_delay = max(arr_delay, na.rm = TRUE),
                avg_arr_delay = mean(arr_delay, na.rm = TRUE))
