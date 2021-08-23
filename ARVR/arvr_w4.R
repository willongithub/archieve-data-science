# ARVR Lab Week 4

require(shiny)

# Exercise 1
new_ui <- fluidPage(
    titlePanel("Test App"),
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

new_server <- function(input, output) {
    output$new_output <- renderText({
        paste("Your lucky word is:", input$new_input)
    })
}

shinyApp(ui = new_ui, server = new_server)


# Exercise 2
new_ui <- fluidPage(
    titlePanel("Text App"),
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

new_server <- function(input, output) {
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

shinyApp(ui = new_ui, server = new_server)


# Exercise 3

