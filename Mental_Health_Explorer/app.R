library(shiny)
library(tidyverse)
library(rworldmap)
library(plotly)
#library(leaflet)

# Read data

data <- read_csv("../data/clean/data_clean.csv")
data$X1 <- NULL
treat_data <- read_csv("../data/clean/treatment_data.csv")
treat_data$X1 <- NULL

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Mental Health Explorer in the Workplace"),
   tags$head(
     tags$style(HTML("
                     body {
                      font-family: 'Helvetica';
                     }
                     "))
     ),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        h3("Filters", align="center"),
        br(),
        uiOutput("countryOutput"),
        uiOutput("ageOutput"),
        width = 2
      ),
      
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Socio-Demographic Plots",
          fluidRow(column(6, plotlyOutput("Age"), plotlyOutput("Gender")),
                   column(6,plotlyOutput("family_history")))),
          tabPanel("Workplace Related Plots",
                   fluidRow(column(6, plotlyOutput("work_interfere"),plotlyOutput("remote_work")),
                            column(6, plotlyOutput("benefit"),plotlyOutput("seek_help")),
                            column(6, plotlyOutput("obs_consequence")))),
          tabPanel("Data", tableOutput("table"))
          )
        )
      )
    )
server <- function(input, output) {
  
  output$countryOutput <- renderUI({
    selectInput('countryInput', 'Country', sort(unique(data$Country)), 
                selected = "Canada", multiple = TRUE, selectize=TRUE)
  })  
  
  output$ageOutput <- renderUI({
    selectInput('ageInput', 'Age groups', sort(unique(data$age_group)), 
                selected = "31-40", multiple = TRUE, selectize=TRUE)
  }) 
  
  filtered_data <- reactive(
    data %>%
      filter(Country %in% input$countryInput) %>% 
      filter(age_group %in%input$ageInput)
  )
  
  output$Age <- renderPlotly({
    age <- filtered_data() %>%  
      select(age_group, treatment) %>% 
      arrange(age_group,treatment) %>% 
      group_by(age_group,treatment) %>%
      summarize(Response=n()) %>% 
      ggplot(aes(age_group,Response, fill=treatment))+ 
      geom_bar(position="dodge", stat="identity")+
      ylab("Count")+
      xlab("Age groups")+
      ggtitle("Mental health treatment sought per age groups") +
      theme_bw()+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
      scale_fill_manual(values = alpha(c("honeydew3","grey52")))

  })
   
   output$Gender <- renderPlotly({
     gender <- filtered_data() %>%  
       select(Gender, treatment) %>% 
       arrange(Gender,treatment) %>% 
       group_by(Gender,treatment) %>%
       summarize(Response=n()) %>% 
       ggplot(aes(Gender,Response, fill=treatment))+ 
       geom_bar(position="dodge", stat="identity")+
       ylab("Count")+
       ggtitle("Mental health treatment sought per gender")+
       theme_bw()+
       theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
       scale_fill_manual(values = alpha(c("honeydew3","grey52")))

   })
   
    output$family_history <- renderPlotly({
     fam_hist <- filtered_data() %>%  
       select(family_history, treatment) %>% 
       arrange(family_history,treatment) %>% 
       group_by(family_history,treatment) %>%
       summarize(Response=n()) %>% 
       ggplot(aes(family_history,Response, fill=treatment))+ 
       geom_bar(position="dodge", stat="identity")+
       ylab("Count")+
       xlab("Family History")+
       ggtitle("Family history of mental illness and treatment sought")+
       theme_bw()+
       theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
       scale_fill_manual(values = alpha(c("honeydew3","grey52")))
     
   })
   
   output$work_interfere <- renderPlotly({
     work_int <- filtered_data() %>%  
       select(work_interfere, treatment) %>% 
       arrange(work_interfere,treatment) %>% 
       group_by(work_interfere,treatment) %>%
       summarize(Response=n()) %>% 
       ggplot(aes(work_interfere,Response, fill=treatment))+ 
       geom_bar(position="dodge", stat="identity")+
       ylab("Count")+
       xlab("Work interference")+
       ggtitle("Work inteference and treatment sought")+
       theme_bw()+
       theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
       scale_fill_manual(values = alpha(c("honeydew3","grey52")))
     
   })
   
   output$remote_work <- renderPlotly({
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
       theme_bw()+
       theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
       scale_fill_manual(values = alpha(c("honeydew3","grey52")))
   })
   
   output$benefit <- renderPlotly({
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
       theme_bw()+
       theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
       scale_fill_manual(values = alpha(c("honeydew3","grey52")))
   })
   
   output$seek_help <- renderPlotly({
     
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
       theme_bw()+
       theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
       scale_fill_manual(values = alpha(c("honeydew3","grey52")))
     
   })
   output$obs_consequence<- renderPlotly({
     
     filtered_data() %>%  
       select(obs_consequence, treatment) %>% 
       arrange(obs_consequence,treatment) %>% 
       group_by(obs_consequence,treatment) %>%
       summarize(Response=n()) %>% 
       ggplot(aes(obs_consequence,Response, fill=treatment))+ 
       geom_bar(position="dodge", stat="identity")+
       ylab("Count")+
       xlab("Observed negative consequences")+
       ggtitle(" Consequences of mental illness and treatment sought")+
       theme_bw()+
       theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
       scale_fill_manual(values = alpha(c("honeydew3","grey52")))
   })
   
   output$table <- renderTable(
     filtered_data()
   )
}


# Run the application 
shinyApp(ui = ui, server = server)

