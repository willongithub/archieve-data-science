### DCP Lab Week 9

require(tidyverse)

## E1
# 2
url <- "https://extranet.who.int/tme/generateCSV.asp?ds=notifications"

# 3
data <- read_csv(url)

# 6
glimpse(data)

## E2
# 1
start <- colnames(data)[7]
end <- colnames(data)[ncol(data)]

# 2
data2 <- gather(data, "key", "cases", start:end, na.rm = T)

# 3
data2 <- gather(data, "key", "cases", all_of(start):all_of(end), na.rm = T)

# 4
glimpse(data2)

## E3
# 1
count_var <-
    data2 %>%
    group_by(key) %>%
    count()

# 2
ordered_count <-
    count_var %>%
    arrange(desc(n))

# 3
url2 <- "https://extranet.who.int/tme/generateCSV.asp?ds=dictionary"

# 4
dictionary <- read_csv(url2)

# 5
glimpse(dictionary)

# 6
keys <- count_var %>%
    filter(n > 3500) %>%
    pull(key)

dictionary %>%
    filter(variable_name %in% keys) %>%
    select(variable_name, definition) %>%
    print()

# 7
print(keys)

## E4
# first
# 1
View(count_var)
pattern <- c("newrel" = "new_rel",
             "newinc" = "new_inc",
             "rdxsurvey" = "rdx_survey",
             "agegroup" = "age_group",
             "labconf" = "lab_conf")

# 2
data2 <- data2 %>% mutate(key = str_replace_all(key, pattern))

# second
# 1
data3 <- data2 %>% filter(str_detect(key, "[0-9]"))

# 3
data4 <- data3 %>% separate(key, c("new", "type", "sexage"))

# 5
data5 <- data4 %>% separate(sexage, c("sex", "age"), sep = 1)

# third
# 1
data6 <- data5 %>% select(-c("new", "iso2", "iso3"))
