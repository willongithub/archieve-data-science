# IDS Lab Week 5

# e1
require(tidyverse)

# 1
anything_df <- data.frame(
 A = 1:1000,
 B = A * 2 + rnorm(length(A))
)
anything_tbl <- tibble(
 A = 1:1000,
 B = A * 2 + rnorm(length(A))
)

# 2
anything_tbl$A
anything_tbl$B

# 3
anything_tbl[["C"]] <-  anything_tbl$B / anything_tbl$A
anything_tbl <- mutate(anything_tbl, "C" = anything_tbl$B / anything_tbl$A)
anything_tbl

# 4
anything_tbl <- rename(anything_tbl, First = "A", Second = "B", Third = "C")
glimpse(anything_tbl)

# e2

# e3

# e4
