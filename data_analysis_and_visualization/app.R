#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(ggplot2)
library(shinythemes)
library(rsconnect)

rsconnect::setAccountInfo(name='zdliu0205', token='940F8917FF40332C00A790647AA652A6', secret='gBszGyPWTpZIJ0di5q7OCror/fuwS9vDOCKyaN8r')

# Load the dataset
data <- read.csv("summary_results.csv")

# Define UI for the application
ui <- fluidPage(
  theme = shinytheme("cosmo"),
  titlePanel(div(style = "text-align: center;", "Borough Traffic Analysis")),
  sidebarLayout(
    sidebarPanel(
      selectInput("borough", "Select a Borough:", 
                  choices = unique(data$borough),
                  selected = unique(data$borough)[1],
                  multiple = FALSE),
      hr(),
      p("Use the dropdown to select a borough and explore the traffic statistics for each link."),
      width = 3
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Overspeed Rate", 
                 plotOutput("overspeedPlot", height = "500px")
        ),
        tabPanel("Jam Rate", 
                 plotOutput("jamRatePlot", height = "500px")
        )
      ),
      width = 9
    )
  )
)

# Define server logic
server <- function(input, output) {
  # Reactive subset of data based on selected borough
  filtered_data <- reactive({
    subset(data, borough == input$borough)
  })
  
  # Plot for overspeed rate
  output$overspeedPlot <- renderPlot({
    ggplot(filtered_data(), aes(x = reorder(link_name, overspeed_rate), y = overspeed_rate)) +
      geom_bar(stat = "identity", fill = "#0073C2FF", width = 0.7) +
      theme_minimal() +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 10),
        plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
        axis.title = element_text(size = 14),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()
      ) +
      labs(title = paste("Overspeed Rate in", input$borough),
           x = "Link Name",
           y = "Overspeed Rate")
  })
  
  # Plot for jam rate
  output$jamRatePlot <- renderPlot({
    ggplot(filtered_data(), aes(x = reorder(link_name, jam_rate), y = jam_rate)) +
      geom_bar(stat = "identity", fill = "#E74C3CFF", width = 0.7) +
      theme_minimal() +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 10),
        plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
        axis.title = element_text(size = 14),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()
      ) +
      labs(title = paste("Jam Rate in", input$borough),
           x = "Link Name",
           y = "Jam Rate")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
