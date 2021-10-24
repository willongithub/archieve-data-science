require(shiny)

# Load helper functions and dataset ----
source("helpers.R")

# User interface ----
ui <- navbarPage(
    "Traffic OverWatch",

    # Page for crash case map
    tabPanel(
        "Exploratory",
        sidebarLayout(
            sidebarPanel(
                width = 3,
                helpText("Select a year to inspect:"),
                selectInput(
                    inputId = "map_year",
                    label = "Year",
                    choices = c("All", year_choices),
                ),
                helpText("Select case categories:"),
                selectizeInput(
                    inputId = "map_severity",
                    label = "Crash Severity",
                    choices = c("All", unique(data$CRASH_SEVERITY)),
                    selected = "All", multiple = FALSE,
                ),
                selectizeInput(
                    inputId = "map_lighting",
                    label = "Lighting Condition",
                    choices = c("All", unique(data$LIGHTING_CONDITION)),
                    selected = "All", multiple = FALSE,
                ),
                selectizeInput(
                    inputId = "map_road",
                    label = "Road Condition",
                    choices = c("All", unique(data$ROAD_CONDITION)),
                    selected = "All", multiple = FALSE,
                ),
                selectizeInput(
                    inputId = "map_weather",
                    label = "Weather Condition",
                    choices = c("All", unique(data$WEATHER_CONDITION)),
                    selected = "All", multiple = FALSE,
                ),
                verbatimTextOutput("map_data_status"),
            ),
            mainPanel(
                width = 9,
                mapdeckOutput("map_plot", width = "100%", height = "700px"),
            ),
        ),
    ),

    # Page showing suburbs with most cases
    tabPanel(
        "Ranks",
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
                    choices = c("All", year_choices),
                    selected = "All",
                ),
            ),
            mainPanel(
                width = 10,
                plotOutput("rank_plot", height = "700px"),
            ),
        ),
    ),

    # Page showing cases trend over time
    tabPanel(
        "Trends",
        sidebarLayout(
            sidebarPanel(
                width = 2,
                radioButtons(
                    inputId = "trend_district",
                    label = "Show trendline by:",
                    choices = c(
                        "Whole City" = FALSE,
                        "Residential Districts" = TRUE
                    ),
                    selected = TRUE,
                ),
                selectInput(
                    inputId = "trend_interval",
                    label = "Select a interval to inspect:",
                    choices = c(
                        "Hourly",
                        # "Weekly",
                        "Monthly",
                        "Yearly"
                    ),
                    selected = "Monthly",
                ),
            ),
            mainPanel(
                width = 10,
                plotOutput("trend_plot", height = "700px"),
            ),
        ),
    ),

    # Page showing cases compared by conditions
    tabPanel(
        "Conditions",
        sidebarLayout(
            sidebarPanel(
                width = 2,
                selectInput(
                    inputId = "cond_cond",
                    label = "Select a condition to inspect:",
                    choices = c(
                        "Crash Severity",
                        "Lighting Condition",
                        "Road Condition",
                        "Weather Condition"
                    ),
                ),
                selectInput(
                    inputId = "cond_suburb",
                    label = "Select a suburb to inspect:",
                    choices = c(
                        "All",
                        "Canberra Central",
                        "Woden Valley",
                        "Belconnen",
                        "Weston Creek",
                        "Tuggeranong",
                        "Gungahlin",
                        "Molonglo Valley"
                    ),
                    selected = "All",
                ),
                selectInput(
                    inputId = "cond_year",
                    label = "Select a year to inspect:",
                    choices = c("All", year_choices),
                    selected = "All",
                ),
            ),
            mainPanel(
                width = 10,
                plotOutput("cond_plot", height = "700px"),
            ),
        ),
    ),

    # VR map view in bird eye angle
    navbarMenu(
        "VR Map",
        # Overview of VR view, all cases displayed
        tabPanel("Overview", includeHTML("www/overview.html")),

        # VR maps for different comparison
        tabPanel(
            "Comparison",
            sidebarLayout(
                sidebarPanel(
                    width = 2,
                    radioButtons(
                        inputId = "vr_density",
                        label = "Group cases by:",
                        choices = c(
                            "Suburb" = TRUE,
                            "Residential District" = FALSE
                        ),
                        selected = TRUE,
                    ),
                    verbatimTextOutput("vr_data_status"),
                    helpText(paste(
                        "Note: Residential District consist of small ",
                        "suburbs within the area.",
                        sep = ""
                    )),
                ),
                mainPanel(
                    width = 10,
                    includeHTML("www/vr_view_list.html")
                ),
            ),
        ),
    ),
    navbarMenu(
        "About",
        tabPanel("Reference", includeHTML("www/reference.html")),
        tabPanel("About", includeHTML("www/about.html")),
    ),
)

# Server logic
server <- function(input, output) {

    # Load dataset by filter
    vr_data_update <- reactive({
        withProgress(message = "Loading", {
            get_vr_json(input$vr_density)
        })
    })

    # Load dataset by filter
    output$map_data_status <- renderText({
        file <- get_map_data(
            input$map_year,
            input$map_severity,
            input$map_lighting,
            input$map_road,
            input$map_weather
        )
        if (dim(file)[1] == 1) {
            paste("No crash filtered.")
        } else {
            filtered <- dim(file)[1]
        paste("Crash cases filtered:", filtered)
        }
    })

    # Draw map
    output$map_plot <- renderMapdeck(get_map(get_map_data(
        input$map_year,
        input$map_severity,
        input$map_lighting,
        input$map_road,
        input$map_weather
    )))

    output$trend_plot <- renderPlot({
        get_trend_plot(input$trend_interval, input$trend_district)
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
            "Molonglo Valley" = "molonglo_valley",
            "All" = "All"
        )
        get_cond_plot(input$cond_year, suburb, column)
    })

    # Show dataset loading status
    output$vr_data_status <- renderText({
        vr_data_update()
        file <- switch(input$vr_density,
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