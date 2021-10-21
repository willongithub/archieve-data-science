require(shiny)

# Source helper functions ----
source("helpers.R")

# User interface ----
ui <- navbarPage("Traffic OverWatch",

  tabPanel("Overview",
    sidebarLayout(
      sidebarPanel(
        width = 2,
        selectInput(
          inputId = "map_year",
          label = "Select a year to inspect:",
          choices = year_choices,
        ),
      ),
      mainPanel(
        mapdeckOutput("map_plot", width = "100%", height = "700px"),
      ),
    ),
  ),

  tabPanel("Trends",
    sidebarLayout(
      sidebarPanel(
        width = 2,
        selectInput(
          inputId = "trend_interval",
          label = "Select a interval to inspect:",
          choices = c("Hourly",
                      "Weekly",
                      "Monthly",
                      "Yearly"),
        ),
      ),
      mainPanel(
        plotOutput("trend_plot"),
      ),
    ),
  ),

  tabPanel("Ranks",
    sidebarLayout(
      sidebarPanel(
        width = 2,
        selectInput(
          inputId = "rank_num",
          label = "Select # of suburbs to rank:",
          choices = c("5", "10", "20"),
          selected = "10",
        ),
        selectInput(
          inputId = "rank_year",
          label = "Select a year to inspect:",
          choices = year_choices,
          selected = "2021",
        ),
      ),
      mainPanel(
        plotOutput("rank_plot"),
      ),
    ),
  ),

  tabPanel("Conditions",
    sidebarLayout(
      sidebarPanel(
        width = 2,
        selectInput(
          inputId = "cond_cond",
          label = "Select a condition to inspect:",
          choices = c("Lighting Condition",
                      "Road Condition",
                      "Weather Condition"),
        ),
        selectInput(
          inputId = "cond_suburb",
          label = "Select a suburb to inspect:",
          choices = c("Canberra Central",
                      "Woden Valley",
                      "Belconnen",
                      "Weston Creek",
                      "Tuggeranong",
                      "Gungahlin",
                      "Molonglo Valley"),
        ),
        selectInput(
          inputId = "cond_year",
          label = "Select a year to inspect:",
          choices = year_choices,
          selected = "2020",
        ),
      ),
      mainPanel(
        plotOutput("cond_plot"),
      ),
    ),
  ),

  tabPanel("VR View",
    sidebarLayout(
      sidebarPanel(
        width = 2,
        radioButtons(
          inputId = "density_selection",
          label = "Group cases by:",
          choices = c("Suburb" = TRUE,
                      "Residential District" = FALSE),
          selected = TRUE,
        ),
        verbatimTextOutput("density_status"),
      ),
      mainPanel(
        includeHTML("www/vr_view_list.html")
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
    withProgress(message = "Processing", {
      get_json(input$density_selection)
    })
  })

  output$map_plot <- renderMapdeck(
    get_map, env = parent.frame(), quoted = FALSE)

  output$trend_plot <- renderPlot({
    get_trend_plot(input$trend_interval)
  })

  output$rank_plot <- renderPlot({
    get_rank_plot(input$rank_year, input$rank_num)
  })

  output$cond_plot <- renderPlot({
    column <- switch(input$cond_cond,
      "Crash Severity" = "CRASH_SEVERITY",
      "Lighting Condition" = "LIGHTING_CONDITION",
      "Road Condition" = "ROAD_CONDITION",
      "Weather Condition" = "WEATHER_CONDITION"
    )
    suburb <- switch(input$cond_suburb,
      "Canberra Central" = "canberra_central",
      "Woden Valley" = "woden_valley",
      "Belconnen" = "belconnen",
      "Weston Creek" = "weston_creek",
      "Tuggeranong" = "tuggeranong",
      "Gungahlin" = "gungahlin",
      "Molonglo Valley" = "molonglo_valley"
    )
    get_cond_plot(input$cond_year, suburb, column)
  })

  output$density_status <- renderText({
    data_update()
    file <- switch(input$density_selection,
      "verbose" = TRUE,
      "condense" = FALSE
    )
    paste(file, "dataset loaded")
  })
}

# Run the app
shinyApp(ui, server)

# Deploy the app
# rsconnect::deployApp("the_watcher/")
