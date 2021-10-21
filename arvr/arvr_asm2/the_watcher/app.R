# Load packages ----
library(shiny)

# Source helper functions ----
source("helpers.R")

# User interface ----
ui <- navbarPage("Traffic OverWatch",

  tabPanel("Overview",
    sidebarLayout(
      sidebarPanel(
        helpText("Heatmap of crashes:"),
        # width = 10,
      ),

      mainPanel(
        mapdeckOutput("map_plot", width = "100%", height = "900px"),
      ),
    ),
  ),

  tabPanel("Trends",
    sidebarLayout(
      sidebarPanel(
        # width = 10,
        selectInput(
          inputId = "trend_interval_input",
          label = "Select a time interval to inspect:",
          choices = c("Hourly",
                      "Yearly"),
        ),
        selectInput(
          inputId = "trend_col_input",
          label = "Select a condition to inspect:",
          choices = c("Crash Severity",
                      "Lighting Condition",
                      "Road Condition",
                      "Weather Condition"),
        ),
      ),
      mainPanel(
        plotOutput("trend_plot"),
      )
    )
  ),

  tabPanel("Top 10s",
    sidebarLayout(
      sidebarPanel(
        width = 10,
        helpText("Cases by Year:"),
        selectInput(
          inputId = "year_year_input",
          label = "Select a year to inspect:",
          choices = year_choices,
        ),
      ),
      mainPanel(
        plotOutput("top10_plot")
      ),
    ),
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

  tabPanel("VR View",
    sidebarLayout(
      sidebarPanel(
        width = 10,
        radioButtons(
          inputId = "density_selection",
          label = "Data point density:",
          choices = c("Suburb" = TRUE,
                      "Residential District" = FALSE),
          selected = TRUE,
        ),
        verbatimTextOutput("density_output")
      ),
      mainPanel(
        includeHTML("www/vr_view_list.html"),
      ),
    ),
  ),

  navbarMenu("More",
    tabPanel("Reference", includeHTML("www/reference.html")),
    tabPanel("About", includeHTML("www/about.html")),
  ),
)

# Server logic
server <- function(input, output) {

  data_update <- reactive({
    get_json(input$density_selection)
  })

  output$map_plot <- renderMapdeck(
    heatmap, env = parent.frame(), quoted = FALSE)

  output$trend_plot <- renderPlot({
    column <- switch(input$trend_col_input,
      "Crash Severity" = "CRASH_SEVERITY",
      "Lighting Condition" = "LIGHTING_CONDITION",
      "Road Condition" = "ROAD_CONDITION",
      "Weather Condition" = "WEATHER_CONDITION")

    get_trend_plot(input$trend_interval_input, column)
  })

  output$top10_plot <- renderPlot({
    # get_top10_plot()
  })

  output$year_plot <- renderPlot({
    get_year_plot(input$year_year_input)
  })

  output$suburb_plot <- renderPlot({
    get_suburb_plot()
  })

  output$density_output <- renderText({
    data_update()
    paste("Verbose: ", input$density_selection)
  })
}

# Run the app
shinyApp(ui, server)

# Deploy the app
# rsconnect::deployApp("the_watcher/")
