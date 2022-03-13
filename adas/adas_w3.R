# Applied Data Analysis in Sport Lab Week 3

# Step 1.
require(tidyverse)

# Step 2.
getwd()
sprint <- read_csv("adas/assets/sprint-testing-data.csv")
str(sprint)

# Step 3.
View(sprint)

# Step 4.
head(sprint, 6)
tail(sprint, 6)

# Step 5.
which(is.na(sprint), arr.ind = T)

# Step 6.
naniar::vis_miss(sprint)

# Step 7.
# One record on each row;
# One value in each cell;
# One category on one column;
# No unattended NA.

# Step 8.
sprint_long <- pivot_longer(sprint,
    cols = c(pre_1:post_3),
    names_to = "time_point",
    values_to = "sprint_time")

head(sprint_long)

# Step 9.
sprint_long <- separate(sprint_long,
    col = "time_point",
    into = c("session", "trail"))

head(sprint_long)

# Step 10.
which(is.na(sprint_long), arr.ind = T)
naniar::vis_miss(sprint_long)

# Step 11.
sprint_tidy <- drop_na(sprint_long)
View(sprint_tidy)

# Step 12.
sprint_summary <- sprint_tidy %>%
    group_by(athlete, session) %>%
    summarise(
        avg = round(mean(sprint_time), 2),
        best = round(min(sprint_time), 2))

sprint_summary

# Step 13.
sprint_summary <- sprint_summary %>%
    pivot_wider(
        names_from = "session",
        values_from = c(avg, best))

sprint_summary

# Step 14.
sprint_summary <- sprint_summary %>%
    arrange(athlete, avg_pre, best_pre, avg_post, best_post)

sprint_summary

# Step 15.
sprint_summary <- sprint_summary %>%
    arrange(best_post)

sprint_summary

# Step 16.
sprint_summary <- sprint_summary %>%
    mutate(best_diff = best_post - best_avg)

sprint_summary

# Step 17.
require(readxl)
data_yyir <- read_excel("adas/assets/yyir.xlsx")

# Step 18.
testing <- full_join(sprint_summary, data_yyir, by = "athlete")

View(testing)
