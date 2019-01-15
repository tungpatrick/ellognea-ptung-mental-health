#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
#library(leaflet)

data <- read_csv("../data/clean/data_clean.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Mental Health Explorer in the Workplace"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         uiOutput("countryOutput")
         
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("Age"),
         plotOutput("Gender"),
         plotOutput("family_history"),
         plotOutput("work_interfere"),
         plotOutput("remote_work"),
         plotOutput("benefit"),
         plotOutput("seek_help"),
         plotOutput("obs_consequence"),
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
  
  output$Age <- renderPlot({
    filtered_data() %>%  
      select(age_group, treatment) %>% 
      arrange(age_group,treatment) %>% 
      group_by(age_group,treatment) %>%
      summarize(Response=n()) %>% 
      ggplot(aes(age_group,Response, fill=treatment))+ 
      geom_bar(position="dodge", stat="identity")+
      ylab("Count")+
      xlab("Age groups")+
      ggtitle("Mental heath treatment sought per age groups")+
      theme_bw()
    
  })
   
   output$Gender <- renderPlot({
     filtered_data() %>%  
       select(Gender, treatment) %>% 
       arrange(Gender,treatment) %>% 
       group_by(Gender,treatment) %>%
       summarize(Response=n()) %>% 
       ggplot(aes(Gender,Response, fill=treatment))+ 
       geom_bar(position="dodge", stat="identity")+
       ylab("Count")+
       ggtitle("Mental heath treatment sought per gender")+
       theme_bw()
     
   })
   
    output$family_history <- renderPlot({
     filtered_data() %>%  
       select(family_history, treatment) %>% 
       arrange(family_history,treatment) %>% 
       group_by(family_history,treatment) %>%
       summarize(Response=n()) %>% 
       ggplot(aes(family_history,Response, fill=treatment))+ 
       geom_bar(position="dodge", stat="identity")+
       ylab("Count")+
       xlab("Family History")+
       ggtitle("Family history of mental illness and treatment sought")+
       theme_bw()
     
   })
   
   output$work_interfere <- renderPlot({
     filtered_data() %>%  
       select(work_interfere, treatment) %>% 
       arrange(work_interfere,treatment) %>% 
       group_by(work_interfere,treatment) %>%
       summarize(Response=n()) %>% 
       ggplot(aes(work_interfere,Response, fill=treatment))+ 
       geom_bar(position="dodge", stat="identity")+
       ylab("Count")+
       xlab("Work interference")+
       ggtitle("Work inteference and treatment sought")+
       theme_bw()
     
   })
   
   output$remote_work <- renderPlot({
     filtered_data() %>%  
       select(remote_work, treatment) %>% 
       arrange(remote_work,treatment) %>% 
       group_by(remote_work,treatment) %>%
       summarize(Response=n()) %>% 
       ggplot(aes(remote_work,Response, fill=treatment))+ 
       geom_bar(position="dodge", stat="identity")+
       ylab("Count")+
       xlab("Remote location")+
       ggtitle("Work location and treatment sought")+
       theme_bw()
   })
   
   output$benefit <- renderPlot({
     filtered_data() %>%  
       select(benefits, treatment) %>% 
       arrange(benefits,treatment) %>% 
       group_by(benefits,treatment) %>%
       summarize(Response=n()) %>% 
       ggplot(aes(benefits,Response, fill=treatment))+ 
       geom_bar(position="dodge", stat="identity")+
       ylab("Count")+
       xlab("Mental Health benefits")+
      ggtitle("Mental health benefits provided at work and treatment sought")+
       theme_bw()
   })
   
   output$seek_help <- renderPlot({
     
     filtered_data() %>%  
       select(seek_help, treatment) %>% 
       arrange(seek_help,treatment) %>% 
       group_by(seek_help,treatment) %>%
       summarize(Response=n()) %>% 
       ggplot(aes(seek_help,Response, fill=treatment))+ 
       geom_bar(position="dodge", stat="identity")+
       ylab("Count")+
       xlab("Resources availability")+
       ggtitle("Resources availability and treatment sought")+
       theme_bw()
     
   })
   output$obs_consequence<- renderPlot({
     
     filtered_data() %>%  
       select(obs_consequence, treatment) %>% 
       arrange(obs_consequence,treatment) %>% 
       group_by(obs_consequence,treatment) %>%
       summarize(Response=n()) %>% 
       ggplot(aes(obs_consequence,Response, fill=treatment))+ 
       geom_bar(position="dodge", stat="identity")+
       ylab("Count")+
       xlab("Observed negaive consequences")+
       ggtitle(" Negative consequences due to mental illness and treatment sought")+
       theme_bw()
   })
   
   output$table <- renderTable(
     filtered_data()
   )
}


# Run the application 
shinyApp(ui = ui, server = server)

