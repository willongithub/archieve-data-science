# ARVR Lab Week 5

require(shiny)

# Exercise 1
ui_1 <- fluidPage(
    titlePanel("Test App 1"),
    sidebarLayout(
        sidebarPanel(
            textInput("new_input",
                      "Enter your lucky word:",
                      "I'm Feeling Lucky!")
        ),
        mainPanel(
            textOutput("new_output")
        )
    )
)

server_1 <- function(input, output) {
    output$new_output <- renderText({
        paste("Your lucky word is:", input$new_input)
    })
}

shinyApp(ui = ui_1, server = server_1)


# Exercise 2
ui_2 <- fluidPage(
    titlePanel("Text App 2"),
    sidebarLayout(
        sidebarPanel(
            textInput("new_text",
                      "Enter your lucky word:"),
            numericInput("new_num",
                         "Choose a number:",
                         value = 99),
            selectInput("new_select",
                        "Select your favorite:",
                        choices = LETTERS[5:15])
        ),
        mainPanel(
            h2("Render HTML in Shiny App"),
            p("First paragrapgh of the text.", strong("Bold Text")),
            textOutput("text_output"),
            textOutput("num_output"),
            textOutput("select_output")
        )
    )
)

server_2 <- function(input, output) {
    output$text_output <- renderText({
        paste("Your lucky word is:", input$new_text)
    })
    output$num_output <- renderText({
        paste("Your lucky num is:", input$new_num)
    })
    output$select_output <- renderText({
        paste("Your lucky select is:", input$new_select)
    })
}

shinyApp(ui = ui_2, server = server_2)


# Exercise 3
ui_3 <- fluidPage(
    tags$h1("Test App 3"),
    tags$hr(),
    tags$br(),
    tags$p(strong("Greatest Product")),
    tags$p(em("Sponsored by me")),
    tags$a(href = "https://www.google.com.au/", "Google")
)

server_3 <- function(input, output) {

}

shinyApp(ui = ui_3, server = server_3)


# Exercise 4
ui_4 <- fluidPage(
    numericInput(
        inputId = "n",
        "Sample size",
        value = 500
    ),
    plotOutput(outputId = "hist")
)

server_4 <- function(input, output) {
    output$hist <- renderPlot({
        hist(rnorm(input$n))
    })
}

shinyApp(ui = ui_4, server = server_4)


# Exercise 5
require(rgl)
require(car)

data(iris)
x <- iris$Sepal.Length
y <- iris$Petal.Length
z <- iris$Sepal.Width

ui_5 <- fluidPage(
    rglwidgetOutput("plot", width = 1024, height = 768)
)

server_5 <- function(input, output) {
    output$plot <- renderRglwidget({
        rgl.open(useNULL = T)
        scatter3d(x, y, z,
                  groups = iris$Species,
                  col = as.numeric(iris$Species), surface = F)
        rglwidget()
    })
}

shinyApp(ui = ui_5, server = server_5)


# Exercise 6
set.seed(111)

ui_6 <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            sliderInput("n",
                        label = "n",
                        min = 10,
                        max = 100,
                        value = 10,
                        step = 10)
        ),
        mainPanel(
            rglwidgetOutput("plot", width = 1024, height = 768)
        )
    )
)

server_6 <- function(input, output) {
    output$plot <- renderRglwidget({
        n <- input$n
        rgl.open(useNULL = T)
        scatter3d(rnorm(n), rnorm(n), rnorm(n))
        rglwidget()
    })
}

shinyApp(ui = ui_6, server = server_6)


# Exercise 7
require(threejs)

ui_7 <- fluidPage(
    titlePanel("Population of world cities"),

    sidebarLayout(
        sidebarPanel(
            sliderInput("n", "# of cities to show",
                        value = 5000,
                        min = 100,
                        max = 30000,
                        step = 100),
            br(),
            p("Use the mouse zoom to zoom in/out."),
            p("Click and drag to rotate.")
        ),
        mainPanel(
            globeOutput("globe")
        )
    )
)

data(world.cities, package = "maps")
earth_dark <- list(img = system.file("images/world.jpg", package = "threejs"),
                                     bodycolor = "blue",
                                     emissive = "#073826",
                                     lightcolor = "#211212")

server_7 <- function(input, output) {
    options(warn = -1) # suppress warning
    h <- 300 # height of the population bar

    cull <- reactive({
        world.cities[order(world.cities$pop, decreasing=TRUE)[1:input$n], ]
    })

    values <- reactive({
        cities <- cull()
        value <- h * cities$pop / max(cities$pop)
        col <- rainbow(10, start=2.8 / 6, end=3.4 / 6)
        names(col) <- c()
        # Extend palette to data values
        col <- col[floor(length(col) * (h - value) / h) + 1]
        list(value=value, color=col, cities=cities)
    })

    output$globe <- renderGlobe({
        v <- values()
        # p <- input$map
        args <- c(earth_dark, list(lat=v$cities$lat, long=v$cities$long,
                                   value=v$value, color=v$col, 
                                   atmosphere=TRUE))
        do.call(globejs, args=args)
    })

}

shinyApp(ui_7, server_7)


# Exercise 8
# list all available examples
runExample()

# print the directory containing the code of the examples
system.file("examples", package = "shiny")

# run the examples
runExample("03_reactivity")


# Homework
ui_hw <- fluidPage(
    titlePanel("Data Viwer"),
    sidebarLayout(
        
        sidebarPanel(
            helpText("Please select the column to plot as histogram."),
            
            numericInput("sample",
                     "# of samples to plot:",
                     value = 500, min = 100, max = 1000, step = 100),
            
            selectInput("selection",
                        "Select the columns to show",
                        choices = c("Population",
                                    "Latitude",
                                    "Longitude"),
                        selected = "pop")
        ),
        mainPanel(
            plotOutput("plot")
        )
    )
)

server_hw <- function(input, output) {
    output$plot <- renderPlot({
        data <- switch(input$selection,
                       "Population" = world.cities$pop,
                       "Latitude" = world.cities$lat,
                       "Longitude" = world.cities$long)
        
        num <- input$sample
        
        hist(data[1:num])
    })
}

shinyApp(ui_hw, server_hw)
