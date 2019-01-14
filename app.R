library(shiny)
library(tidyverse)
library(leaflet)
data <- read.csv("data_clean.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("Test", 
             windowTitle = "BCL app"),
  
  sidebarLayout(
    sidebarPanel(
      checkboxInput("filters", "Country", FALSE),
      uiOutput("countryOutput"),
      uiOutput("typeOutput")
    ),
    mainPanel(
      plotOutput(outputId = "genderOutput"),
      tableOutput(outputId = "table")
    )
  )
   
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$countryOutput <- renderUI({
    selectInput('countryInput', 'Country', sort(unique(data$Country)), 
                selected = "Canada", multiple = TRUE, selectize=TRUE)
  })  
  
  filtered_data <- reactive(
    data %>%
      filter(Country %in% input$countryInput)
  )
  
  output$typeOutput <- renderUI({
    selectInput('typeInput', 'Personal vs Professional', c('Personal', 'Professional'), 
                multiple = FALSE)
  })
  
  output$genderOutput <- renderPlot(
    filtered_data() %>%
      ggplot(aes(Gender)) + 
      geom_bar() +
      theme_bw()
    )
  
    output$table <- renderTable(
      filtered_data()
    )
}

# Run the application 
shinyApp(ui = ui, server = server)
