require(shiny)
source("demo_app/helpers.R")

# Define UI layout
ui <- fluidPage(
	titlePanel(""),

	sidebarLayout(
		sidebarPanel(
			selectInput("var_0", 
		                label = "Choose a variable to display",
		                choices = c("Percent White", "Percent Black",
		                            "Percent Hispanic", "Percent Asian"),
		                selected = "Percent White"),
			sliderInput(),
			actionButton(),
			textOutput("var_2"),
			plotOutput("map"),
			tableOutput()
			),
		mainPanel(
			textInput("var_1"),
			htmlOutput(),
			h2(),
			br(),
			code()
			)
		)
)

# Define app logic
server <- function(input, output) {
	
	output$var_2 <- renderText({
		paste("Hello Shiny!", input$var_1)
	})

	output$map <- renderPlot({
    args <- switch(input$var_0,
      "Percent White" = list(counties$white, "darkgreen", "% White"),
      "Percent Black" = list(counties$black, "black", "% Black"),
      "Percent Hispanic" = list(counties$hispanic, "darkorange", "% Hispanic"),
      "Percent Asian" = list(counties$asian, "darkviolet", "% Asian"))
        
    args$min <- input$range[1]
    args$max <- input$range[2]
  
    do.call(percent_map, args)
    })
}

# Run the app
shinyApp(ui = ui, server = server)