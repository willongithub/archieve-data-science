# Load packages ----
library(shiny)
library(quantmod)

# Source helpers ----
source("helpers.R")

# User interface ----
ui <- fluidPage(
  titlePanel("stockVis"),

  sidebarLayout(
    sidebarPanel(
      helpText("Select a stock to examine.

        Information will be collected from Yahoo finance."),
      textInput("symb", "Symbol", "SPY"),

      dateRangeInput("dates",
                     "Date range",
                     start = "2013-01-01",
                     end = as.character(Sys.Date())),

      br(),
      br(),

      checkboxInput("log", "Plot y axis on log scale",
                    value = FALSE),

      checkboxInput("adjust",
                    "Adjust prices for inflation", value = FALSE)
    ),

    mainPanel(plotOutput("plot"))
  )
)

# Server logic
server <- function(input, output) {

  data_input <- reactive({
      getSymbols(input$symb, src = "yahoo",
          from = input$dates[1],
          to = input$dates[2],
          auto.assign = FALSE)
  })

  final_input <- reactive({
    if (!input$adjust) return(data_input())
    adjust(data_input())
  })

  output$plot <- renderPlot({
    chartSeries(final_input(), theme = chartTheme("white"),
        type = "line", log.scale = input$log, TA = NULL)
  })
}

# Run the app
shinyApp(ui, server)
