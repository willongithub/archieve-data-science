require(r2vr)
require(jsonlite)
require(ggplot2)

a_scatterplot <- function(json_data, x, y, z, ...){
    ## js sources for scatterplot
    .scatter_source <- "https://cdn.rawgit.com/zcanter/aframe-scatterplot/master/dist/a-scatterplot.min.js"
    .d3_source <- "https://cdnjs.cloudflare.com/ajax/libs/d3/4.4.1/d3.min.js"

    ## Create in-memory asset for JSON data
    ## A regular a_asset could be used that points to a real file
    ## this is necessary in a vignette to avoid CRAN issues.
    json_file_asset <- a_in_mem_asset(id = "scatterdata",
        src = "./scatter_data.json",
        .data = json_data)
    a_entity(.tag = "scatterplot",
        src = json_file_asset,
        .js_sources = list(.scatter_source, .d3_source),
        x = x,
        y = y,
        z = z, ...)
} # end of function

# convert the dataset into a JSON file
diamonds_json <- jsonlite::toJSON(diamonds)

# create scene
my_scene <- a_scene(.template = "empty",
    .children = list(
    a_scatterplot(diamonds_json, # dataset
    x = "depth", y = "carat", z = "table", # choose columns in your dataset
    val = "price", # colour scale
    xlabel = "depth", ylabel = "carat", zlabel = "table", #axis labels
    showFloor = TRUE,
    ycage = TRUE,
    title = "Price of Diamonds in Dollars $$$",
    pointsize = "10", # try different values
    position = c(0, 0, -2),
    scale = c(3, 3, 3)),
    a_pc_control_camera()))

# Serve a scene
my_scene$serve()

# View local web content within RStudio
rstudioapi::viewer("http://127.0.0.1:8080")

# Stop serving a scene
my_scene$stop()