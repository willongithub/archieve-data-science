# ARVR Lab Week 3

require("plot3D")
require("rlang")
require("threejs")
require("rgl")
require("magick")
require("plotly")
require("htmlwidgets")

data(iris)
View(iris)

x <- iris$Sepal.Length
y <- iris$Petal.Length
z <- iris$Sepal.Length

# 1.3D plots with plot3D
# Exercise 1
scatter3D(x, y, z, clab = c("Sepal", "Width (cm)"))

# remove color legend
scatter3D(x, y, z, colkey = F)

# different style
scatter3D(x, y, z, colvar = NULL, col = "blue", pch = 19, cex = 0.9)

# full box
scatter3D(x, y, z, colkey = F, bty = "f", main = "bty='f'")

# gray background
scatter3D(x, y, z, colkey = F, bty = "g", main = "bty='g'",
    ticktype = "detailed")

# user defined
scatter3D(x, y, z, colkey = F, bty = "u", main = "bty='u'",
    pch = 18, col.panel = "royalblue", expand = 0.4, col.grid = "linen")

# 2.3D plots with threejs
# Exercise 2
scatterplot3js(x, y, z, color = heat.colors(length(z)))

# specify color for each iris type
n <- length(levels(iris$Species))
scatterplot3js(x, y, z, size = 0.6, color = rainbow(n)[iris$Species])

# different style of the data point
scatterplot3js(x, y, z, pch = "o", color = rainbow(length(z)))

# network visualization
data(ego)
graphjs(ego, bg = "black")

# load the data
data(world.cities, package = "maps")
cities <- world.cities[order(world.cities$pop, decreasing = T)[1:500], ]
value <- 100 * cities$pop / max(cities$pop)

# plot by globejs
globejs(bg = "white",
    lat = cities$lat,
    long = cities$long,
    value = value,
    rotationlat = -0.34,
    rotationlong = -0.38,
    fov = 30)

# 3.3D plots with rgl
# Exercise 3
plot3d(x, y, z)

# add color
plot3d(x, y, z,
    size = 7,
    col = as.numeric(iris$Species))

# different style of data point
plot3d(x, y, z,
    size = 2,
    type = "s",
    col = as.numeric(iris$Species))

# add label
plot3d(x, y, z,
    size = 2,
    type = "s",
    col = as.numeric(iris$Species),
    xlab = "Sepal Length",
    ylab = "Sepal Width",
    zlab = "Petal Length")

# animated 3d scatterplot
plot3d(x, y, z,
    radius = .2,
    type = "s",
    col = as.numeric(iris$Species))

play3d(spin3d(axis = c(0, 1, 0), rpm = 20), duration = 10)

# save the figure as gif
movie3d(movie = "3dAnimatedScatterplot",
    spin3d(axis = c(0, 0, 1), rpm = 7),
    duration = 5,
    dir = getwd(),
    type = "gif",
    clean = T)

# 4.3D plots with ploty
# Exercise 4
plot_ly(iris, x = ~x, y = ~y, z = ~z)

# add label
plot_ly(iris,
    x = ~Sepal.Length,
    y = ~Sepal.Width,
    z = ~Petal.Length)

# add color
plot_ly(iris, x = ~x, y = ~y, z = ~z, color = ~Species)

p <- plot_ly(iris, x = ~x, y = ~y, z = ~z) %>%
p <- add_markers(p, color = ~Species)
p

# add label
variables <- names(iris)
layout(p, scene = list(xaxis = list(title = variables[1]),
    yaxis = list(title = variables[2]),
    zaxis = list(title = variables[3])))

# different palettes
p <- plot_ly(iris, x = ~x, y = ~y, z = ~z, color = ~Species)
add_markers(p, color = ~Species, colors = "Accent")
add_markers(p, color = ~Species, colors = "Set1")
add_markers(p, color = ~Species, colors = "PuBu")

# surface plot
p <- plot_ly(z = volcano, type = "surface")
p

# save the interactive plot
saveWidget(p, file = paste0(getwd(), "/3dSurface.html"))

# 5.Take Home Exercises
data(flights)
flight_list <- flights

# 1
flight_list$dest_lat_long <- sprintf("%.2f:%.2f", flights$dest_lat, flights$dest_long)

# 2
dest_count <- table(flight_list$dest_lat_long)

# 3
dest_count <- dest_count %>% sort(dest_count, decreasing = T)

# 4
dest_top10 <- dest_count %>% head(10) %>% names

# 5
origin_to_top10 <- flight_list[flight_list$dest_lat_long %in% dest_top10, ]

# 6
top10 <- data.frame(o_lat = origin_to_top10$origin_lat,
                o_long = origin_to_top10$origin_long,
                d_lat = origin_to_top10$dest_lat,
                d_long = origin_to_top10$dest_long)

# 7
globejs(lat = top10$d_lat,
        long = top10$d_long,
        arcs = top10,
        arcsHeight = 0.5,
        arcsLwd = 0.5,
        arcsColor = "magenta",
        atmosphere = T)
