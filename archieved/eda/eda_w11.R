### EDA Lab Week 11

require(ggplot2)
require(dplyr)

## 1
# a
mtcars6 <- mtcars[, c(1, 3:7)]

# b
mtcars6 <- scale(mtcars6)

# c
dist_mtcars6 <- as.matrix(dist(mtcars6, method = "e"))

# d
hc_mtcars6 <- hclust(dist_mtcars6)
plot(hc_mtcars6)

hc_mtcars6 %>%
    cutree(k = 3) %>%
    as.factor() %>%
    data.frame(mtcars6, .)

hc_mtcars6 %>%
    rect.hclust(k = 3, border = "yellow")
    
# e
wss <- (nrow(mtcars6) - 1) * sum(apply(mtcars6, 2, var))
for (i in 2:15) wss[i] <- sum(kmeans(mtcars6,  centers = i)$withinss)
plot(1:15, wss, type = "b", xlab = "Number of Clusters",
     ylab = "Within groups sum of squares") +
     geom_vline(xintercept = 3, linetype = 2)

# f
fit_km <- kmeans(mtcars6, 6)
aggregate(mtcars6, by = list(fit_km$cluster), FUN = mean)
mtcars6_km <- data.frame(mtcars6, cluster = as.factor(fit_km$cluster))

# g
ggplot(mtcars6_km, aes(disp, mpg, col = cluster)) +
    geom_point(size = 5)

ggplot(mtcars6_km, aes(hp, mpg, col = cluster)) +
    geom_point(size = 5)

## 2
# a
data <- scale(USArrests)

# b
require(factoextra)

# c
fviz_nbclust(data, kmeans, method = "wss") +
geom_vline(xintercept = 3, linetype = 2)

fit_km <- kmeans(data, 4)

print(fit_km$cluster)
print(fit_km$size)
print(fit_km$centers)

# d
fviz_cluster(fit_km, data, ellipse.type = "norm")

# e
aggregate(data, by = list(fit_km$cluster), FUN = mean)
data_km <- data.frame(data, cluster = as.factor(fit_km$cluster))

# f
data_km %>%
    group_by(cluster) %>%
    summarize(Murder_avg = mean(Murder),
              Assault_avg = mean(Assault),
              UrbanPop_avg = mean(UrbanPop),
              Rape_avg = mean(Rape))
