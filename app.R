# Install and load necessary packages
if (!require("shiny")) install.packages("shiny")
if (!require("dplyr")) install.packages("dplyr")
library(shiny)
library(dplyr)

# Create a sample dataset
traffic_data <- data.frame(
  STATUS = rep(c("Open", "Closed", "Under Maintenance"), length.out = 10),
  LINK_ID = 1:10,
  BOROUGH = c("Manhattan", "Brooklyn", "Queens", "Manhattan", "Queens", 
              "Brooklyn", "Manhattan", "Queens", "Brooklyn", "Manhattan"),
  SPEED = c(30, 50, 80, 60, 45, 70, 55, 65, 40, 75),  # Sample speed values
  TRAVEL_TIME = c(10, 20, 25, 15, 18, 12, 28, 22, 19, 30)  # Sample travel time values
)

# Define the UI
ui <- fluidPage(
  titlePanel("Traffic Data Interactive App"),
  
  sidebarLayout(
    sidebarPanel(
      # Speed slider
      sliderInput("speed", "Speed range (km/h):", min = 0, max = 120, value = c(20, 80)),
      
      # Travel time slider
      sliderInput("travel_time", "Travel time range (minutes):", min = 0, max = 60, value = c(10, 30)),
      
      # Status selection
      selectInput("status", "Status:", choices = unique(traffic_data$STATUS), multiple = TRUE),
      
      # Borough selection
      selectInput("borough", "Borough:", choices = unique(traffic_data$BOROUGH), multiple = TRUE)
    ),
    
    mainPanel(
      # Display the filtered data
      tableOutput("filtered_data")
    )
  )
)

# Define server logic
server <- function(input, output) {
  # Filter data based on user inputs
  filtered_data <- reactive({
    data <- traffic_data |>
      filter(
        SPEED >= input$speed[1],
        SPEED <= input$speed[2],
        TRAVEL_TIME >= input$travel_time[1],
        TRAVEL_TIME <= input$travel_time[2],
        STATUS %in% input$status
      )
    
    # Apply borough filter only if any borough is selected
    if (length(input$borough) > 0) {
      data <- data |> filter(BOROUGH %in% input$borough)
    }
    
    data
  })
  
  # Render the filtered data table
  output$filtered_data <- renderTable({
    filtered_data()
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)
