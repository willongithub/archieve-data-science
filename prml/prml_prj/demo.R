require(tidyverse)

df <- read_csv("prml/prml_prj/assets/data/main_dataset.csv")

head(df)

colnames(df)

data <- df %>%
    select(-c(movie, opinion, year))

model <- lm(box ~ ., data = data)

summary(model)

model_2 <- lm(box ~ pop_trailer + budget, data = data)

summary(model_2)
