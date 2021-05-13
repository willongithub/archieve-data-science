### IDS Lab Week 9

require(tidyverse)
require(ggplot2)

## E1
# 2
male <- read.csv("ids/data/1978-2017-australiansdg-indicator-8-5-2a-males.csv")
female <- read.csv("ids/data/1978-2017-australiansdg-indicator-8-5-2a-females.csv")

# 3
male <- male %>%
    separate(Month, c("m", "d"), sep = "-") %>%
    mutate(d = ifelse(m != "Dec", m, d), m = "Dec") %>%
    mutate(d = ifelse(as.numeric(d) > 50, paste("19", d, sep = ""),
        ifelse(as.numeric(d) > 9, paste("20", d, sep = ""),
                      paste("200", d, sep = "")))) %>%
    mutate(d = ifelse(d == 20000, 2000, d)) %>%
    unite(Month, c("m", "d"), sep = "-") %>%
    gather(age_group, rate, 2:7) %>%
    mutate(rate = as.numeric(rate)) %>%
    separate(age_group, c("gender", "al", "ah")) %>%
    unite(age_group, c("al", "ah"), sep = "-") %>%
    mutate(age_group = ifelse(age_group == "65-and", 65, age_group))

female <- female %>%
    separate(Month, c("m", "d"), sep = "-") %>%
    mutate(d = ifelse(m != "Dec", m, d), m = "Dec") %>%
    mutate(d = ifelse(as.numeric(d) > 50, paste("19", d, sep = ""),
        ifelse(as.numeric(d) > 9, paste("20", d, sep = ""),
                      paste("200", d, sep = "")))) %>%
    mutate(d = ifelse(d == 20000, 2000, d)) %>%
    unite(Month, c("m", "d"), sep = "-") %>%
    gather(age_group, rate, 2:7) %>%
    mutate(rate = as.numeric(rate)) %>%
    separate(age_group, c("gender", "al", "ah")) %>%
    unite(age_group, c("al", "ah"), sep = "-") %>%
    mutate(age_group = ifelse(age_group == "65-and", 65, age_group))

mf <- rbind(male, female)

mf %>%
    group_by(gender, age_group) %>%
    summarize(avg_rate = mean(rate, na.rm = T)) %>%
    ggplot(aes(x = age_group, y = avg_rate, fill = gender)) +
        geom_col(position = "dodge") +
        ggtitle("Unemployment Rate Average per Gender") +
        ylab("Unemployment Rate Average")
