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

server_3 <- function(input, output) {}

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
ui_5 <- fluidPage(

)

server_5 <- function()

shinyApp(ui = ui_5, server = server_5)


# Exercise 6
require(rgl)
library(car)

ui_5 <- fluidPage(
    rglwidget
)

server_6 <- function()

shinyApp(ui = ui_6, server = server_6)


# Exercise 7
ui_7 <- fluidPage(

)

server_7 <- function()

shinyApp(ui = ui_7, server = server_7)


# Exercise 8
# list all available examples
runExample()

# print the directory containing the code of the examples
system.file("examples", package = "shiny")

# run the examples
runExample("03_reactivity")


# Homework
data(iris)

# Exercise 5
ui_hw <- fluidPage(

)

server_hw <- function()

shinyApp(ui = ui_hw, server = server_hw)
