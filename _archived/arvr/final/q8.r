# ---
# title: "AR/VR Data Analysis and Communication G (11524)"
# subtitle: Final Test
# author: ""
# date: "Semester 2 2021"
# ---

require(shiny)
require(tidyverse)
require(ggplot2)

# **Topic 2 – Data Analysis and Visualisation.**
# Q8
# Look at the data.
glimpse(iris)

# Sidebar layout for iris dataset.
front <- fluidPage(
  titlePanel("Iris Dataset"),
  sidebarLayout(
    sidebarPanel(
      textInput("title",
                label = "Title input:",
                value = "Histograms of Iris"
      ),
      sliderInput("pt_l",
                  label = "Maximum value to plot (Petal.Length):",
                  min = min(iris$Petal.Length),
                  max = max(iris$Petal.Length),
                  value = max(iris$Petal.Length)
      ),
      sliderInput("pt_w",
                  label = "Maximum value to plot (Petal.Width):",
                  min = min(iris$Petal.Width),
                  max = max(iris$Petal.Width),
                  value = max(iris$Petal.Width)
      ),
      sliderInput("sp_l",
                  label = "Maximum value to plot (Sepal.Length):",
                  min = min(iris$Sepal.Length),
                  max = max(iris$Sepal.Length),
                  value = max(iris$Sepal.Length)
      ),
      sliderInput("sp_w",
                  label = "Maximum value to plot (Sepal.Width):",
                  min = min(iris$Sepal.Width),
                  max = max(iris$Sepal.Width),
                  value = max(iris$Sepal.Width)
      ),
    ),
    mainPanel(
      plotOutput("hist", height = 700)
    )
  )
)

back <- function(input, output) {
  output$hist <- renderPlot({

    iris_hist <- iris %>%
      gather("variables", "values", -Species) %>%
      filter(
        (variables == "Sepal.Length" & values <= input$sp_l) |
        (variables == "Sepal.Width" & values <= input$sp_w) |
        (variables == "Petal.Length" & values <= input$pt_l) |
        (variables == "Petal.Width" & values <= input$pt_w))

    iris_count <- iris_hist %>%
      group_by(variables, Species) %>%
      summarise(count = n())

    annotate_subplots <- data.frame(
      anno = c(
        paste("setosa:", iris_count$count[1],
          "versicolor:", iris_count$count[2],
          "virginica:", iris_count$count[3]
        ),
        paste("setosa:", iris_count$count[4],
          "versicolor:", iris_count$count[5],
          "virginica:", iris_count$count[6]
        ),
        paste("setosa:", iris_count$count[7],
          "versicolor:", iris_count$count[8],
          "virginica:", iris_count$count[9]
        ),
        paste("setosa:", iris_count$count[10],
          "versicolor:", iris_count$count[11],
          "virginica:", iris_count$count[12]
        )
      ),
      variables = c(
        "Petal.Length", "Petal.Width", "Sepal.Length", "Sepal.Width"),
      x = 4,
      y = -3
    )

    iris_hist %>%
      ggplot(aes(x = values)) +
        geom_histogram(
          position = "identity",
          alpha = 0.5,
          binwidth = 1,
          aes(color = Species, fill = Species)) +
        facet_grid(variables ~ .) +
        geom_text(
          data = annotate_subplots,
          mapping = aes(x, y, label = anno)
        ) +
        theme_minimal() +
        theme(
          axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          panel.spacing.y = unit(3, "lines"),
          legend.position = c(0.07, 0.95),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
        ggtitle(input$title)
  })
}

# Run the app.
shinyApp(front, back)
