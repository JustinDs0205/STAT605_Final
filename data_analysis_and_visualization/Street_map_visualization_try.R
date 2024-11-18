library(shiny)
library(leaflet)
library(ggplot2)
library(dplyr)
library(lubridate)
library(shinythemes)
library(rsconnect)


# 加载已合并好的 CSV 文件
data <- read.csv("combined_output_filtered.csv")

# 处理数据
data$DATA_AS_OF <- as.POSIXct(data$DATA_AS_OF, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")

# 分离经纬度信息
data <- data %>%
  mutate(
    lat = as.numeric(sub(",.*", "", LINK_POINTS)),
    lng = as.numeric(sub(".*,", "", LINK_POINTS))
  )

# 移除无效的经纬度数据
data <- data %>% filter(!is.na(lat) & !is.na(lng))

# 提取所有的街道名供用户选择
street_choices <- unique(data$LINK_NAME)
start_date <- min(data$DATA_AS_OF)
end_date <- max(data$DATA_AS_OF)


# 创建 Shiny 应用程序
ui <- fluidPage(
  theme = shinythemes::shinytheme("cosmo"),
  titlePanel(div(style = "text-align: center;", "Interactive Map and Traffic Speed Visualization")),
  
  sidebarLayout(
    sidebarPanel(
      h3("Filter Options"),
      selectInput("street", "Select Street:",
                  choices = street_choices,
                  # selected = street_choices[-3]),
                  selected = '12th Ave S 57th St-45th St'),
      dateRangeInput("dateRange", "Select Date Range:",
                     start = as.Date("2020-01-01"),
                     end = as.Date("2020-01-07")),

      br(),
      h4("Filtered Data Table"),
      tableOutput("filteredTable"),
      width = 3
    ),
    
    mainPanel(
      leafletOutput("map", height = "600px"),
      br(),
      div(style = "text-align: center;",
          tags$footer("Developed by zdliu | Traffic Data Visualization", style = "font-size: 14px; color: grey;")
      ),
      width = 9
    )
  )
)

server <- function(input, output, session) {
  
  # 过滤数据基于用户选择的街道、时间范围和速度条件
  reactive_filtered_data <- reactive({
    data %>%
      filter(
        LINK_NAME == input$street,
        SPEED > 0.5 & SPEED < 5,
        DATA_AS_OF >= as.POSIXct(input$dateRange[1], tz = "UTC") &
          DATA_AS_OF <= as.POSIXct(input$dateRange[2] + 1, tz = "UTC") - 1
      )
  })
  
  # 输出交互式地图，标注速度在 0.5 到 5 之间的位置和时间
  output$map <- renderLeaflet({
    filtered_data <- reactive_filtered_data()
    if (nrow(filtered_data) > 0) {
      leaflet(filtered_data) %>%
        addTiles() %>%
        setView(lng = mean(filtered_data$lng), lat = mean(filtered_data$lat), zoom = 13) %>%
        addMarkers(
          lng = ~lng,
          lat = ~lat,
          popup = ~paste("Time:", format(DATA_AS_OF, "%Y-%m-%d %I:%M %p"), "<br>Speed:", SPEED)
        )
    } else {
      leaflet() %>%
        addTiles() %>%
        setView(lng = -74.01, lat = 40.75, zoom = 13)
    }
  })
  
  # 输出符合条件的数据表
  output$filteredTable <- renderTable({
    reactive_filtered_data() %>%
      select(DATA_AS_OF, SPEED) %>%
      mutate(DATA_AS_OF = format(DATA_AS_OF, "%m/%d/%Y %I:%M:%S %p"))
  })
}

shinyApp(ui, server)
