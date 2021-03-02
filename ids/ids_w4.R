# IDS Lab Week 4

# e1
v1 <- c(3, 9, -1, 4, 2, 6)
v2 <- c(5, 2, 0, 9, 3, 4)
m1 <- matrix(data = v1, nrow = 2)
m2 <- matrix(data = v2, nrow = 2)
m1 + m2
m1 * m2
m3 <- t(m2)
dim(m1 %*% m3)
rbind(m2, c(2, 4, 6))
m1[1, ]
m1[, 1]

# e2
boxes_color <- c("purple", "red", "yellow", "brown")
boxes_color[2]
boxes_weight <- c(40, 30, 18, 23)
boxes_info <- data.frame(color = boxes_color, weight = boxes_weight)
boxes_info
boxes_info[3, ]
boxes_info[, 1]
boxes_info[4, 1]

# e3
tiny_titles <- c()
tiny_directors <- c()
tiny_years <- c()
tiny_countries <- c()
tiny_movies <- data.frame(tiny_titles, tiny_directors, tiny_years, tiny_countries)
new_movies <- list()
rbind(tiny_movies, new_movies)
tiny_movies$tiny_titles
sort(tiny_movies$tiny_years)
order(tiny_movies$tiny_years)
