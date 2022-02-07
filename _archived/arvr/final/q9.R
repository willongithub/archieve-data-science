require(r2vr)
require(jsonlite)
require(ggplot2)

a_scatterplot <- function(json_data, x, y, z, ...) {
    .scatter_source <- paste0("https://cdn.rawgit.com/zcanter/",
                              "aframe-scatterplot/master/dist/",
                              "a-scatterplot.min.js")
    .d3_source <- "https://cdnjs.cloudflare.com/ajax/libs/d3/4.4.1/d3.min.js"

    json_file_asset <- a_in_mem_asset(id = "scatterdata",
        src = "./scatter_data.json",
        .data = json_data)
    a_entity(.tag = "scatterplot",
        src = json_file_asset,
        .js_sources = list(.scatter_source, .d3_source),
        x = x,
        y = y,
        z = z, ...)
}

# convert the dataset into a JSON file
iris_json <- jsonlite::toJSON(iris)

# create scene
my_scene <- a_scene(.template = "empty",
    .children = list(
    a_scatterplot(iris_json,
    x = "Petal.Width", y = "Sepal.Width", z = "Sepal.Length",
    xlabel = "Petal.Width", ylabel = "Sepal.Width", zlabel = "Sepal.Length",
    showFloor = TRUE,
    ycage = TRUE,
    title = "Scatter Plot of IRIS Dataset",
    pointsize = "7",
    position = c(0, 0, -2),
    scale = c(3, 3, 3)),
    a_pc_control_camera()))

# Serve a scene
my_scene$serve()

# View local web content within RStudio
rstudioapi::viewer("http://127.0.0.1:8080")

# Stop serving a scene
my_scene$stop()