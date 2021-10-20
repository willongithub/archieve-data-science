# Load packages ----
library(shiny)

# Source helper functions ----
source("helpers.R")

# User interface ----
ui <- navbarPage("Traffic OverWatch",

  tabPanel("Overview",
    sidebarLayout(
      sidebarPanel(
        helpText("ACT Crash Heatmap:"),
      ),

      mainPanel(
        mapdeckOutput("map_plot", width = "100%", height = "700px"),
      ),
    ),
  ),

  tabPanel("Exploratory",
    sidebarLayout(
      sidebarPanel(
        selectInput(
          inputId = "exp_year_input",
          label = "Select a year to inspect:",
          choices = year_choices,
        ),
        selectInput(
          inputId = "exp_col_input",
          label = "Select a column to inspect:",
          choices = c("Crash Severity",
                      "Lighting Condition",
                      "Road Condition",
                      "Weather Condition"),
        ),
      ),
      mainPanel(
        h2("Canberra Crash Cases"),
        br(),
        plotOutput("bar_plot"),
      )
    )
  ),

  tabPanel("by Year",
    sidebarLayout(
      sidebarPanel(
        helpText("Cases by Year:"),
        selectInput(
          inputId = "year_year_input",
          label = "Select a year to inspect:",
          choices = year_choices,
        ),
      ),
      mainPanel(
        plotOutput("year_plot")
      ),
    ),
  ),

  tabPanel("by Suburb",
    sidebarLayout(
      sidebarPanel(
        helpText("Cases by Suburb:"),
      ),
      mainPanel(
        plotOutput("suburb_plot")
      ),
    ),
  ),

  navbarMenu("VR View",
    tabPanel("Cases by Suburb",
      includeHTML("www/by_suburb")),
    tabPanel("Cases by Road Condition",
      includeHTML("www/by_road.html")),
    tabPanel("Cases by Weather Condition",
      includeHTML("www/by_weather.html")),
    tabPanel("Cases by Lighting Condition",
      includeHTML("www/by_lighting.html")),
  ),

  navbarMenu("More",
    tabPanel("Reference", includeHTML("www/ref.html")),
    tabPanel("About", includeHTML("www/about.html")),
  ),
)

# Server logic
server <- function(input, output) {

  output$map_plot <- renderMapdeck(
    heatmap, env = parent.frame(), quoted = FALSE)

  output$bar_plot <- renderPlot({
    column <- switch(input$exp_col_input,
      "Crash Severity" = "CRASH_SEVERITY",
      "Lighting Condition" = "LIGHTING_CONDITION",
      "Road Condition" = "ROAD_CONDITION",
      "Weather Condition" = "WEATHER_CONDITION")
    get_exploratory_plot(input$exp_year_input, column)
  })

  output$year_plot <- renderPlot({
    get_year_plot(input$year_year_input)
  })

  output$suburb_plot <- renderPlot({
    get_suburb_plot()
  })
}

# Run the app
shinyApp(ui, server)
