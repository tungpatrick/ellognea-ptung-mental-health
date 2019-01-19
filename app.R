library(shiny)
library(tidyverse)
library(rworldmap)
library(plotly)
library(DT)

# Read data
data <- read_csv("data/clean/data_clean.csv")
data$X1 <- NULL

# Read variable descriptions
desc <- read_csv("data/variables_description.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(

   # Application title
   titlePanel("Mental Health Explorer in the Workplace"),
   tags$hr(),

   # Sidebar with a slider input for number of bins
   sidebarLayout(
     sidebarPanel(
       h4("Filter by:", align="left"),
       br(),
       wellPanel(checkboxInput("countryCheck", "Country", FALSE),
                 checkboxInput("ageCheck", "Age", FALSE),
                 radioButtons("perproInput", label="Subgroup",
                              choices = c("Personal", "Professional"),
                              selected = "Personal"
                 )),
       uiOutput("countryOutput"),
       uiOutput("ageOutput"),
       width = 2),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Graphics", 
           conditionalPanel("input.perproInput == 'Personal'",
                            fluidRow(column(6, plotlyOutput("Age"), br(), plotlyOutput("Gender")),
                                     column(6,plotlyOutput("family_history"),br(), plotlyOutput("obs_consequence")))),
           conditionalPanel("input.perproInput == 'Professional'",
                            fluidRow(column(6, plotlyOutput("work_interfere"),br(),plotlyOutput("remote_work")),
                                     column(6, plotlyOutput("benefit"),br(), plotlyOutput("seek_help"))
                            )
                 )
           ),
        tabPanel("Data View", DT::dataTableOutput("table")),
        tabPanel("Variable Descriptions", tableOutput("table2"))
          ),
      width=10)
    )
   )
server <- function(input, output) {

  output$countryOutput <- renderUI({
    if(input$countryCheck) {
      selectInput('countryInput', 'Country', sort(unique(data$Country)),
                  selected = "Canada", multiple = TRUE, selectize=TRUE)
      }
    })

  output$ageOutput <- renderUI({
    if(input$ageCheck) {
      selectInput('ageInput', 'Age groups', sort(unique(data$age_group)),
                  selected = "31-40", multiple = TRUE, selectize=TRUE)
    }
  })

  filtered_data <- reactive({
    if (input$countryCheck) {
      data <- data %>% filter(Country %in% input$countryInput)
    }
    if (input$ageCheck) {
      data <- data %>% filter(age_group %in%input$ageInput)
    }
    
    return(data)
    })
    
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
      ggtitle("Age Group vs Treatment") +
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
       ggtitle("Gender vs Treatment")+
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
       ggtitle("Family History vs Treatment")+
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
       xlab("Work Interference")+
       ggtitle("Work Interference vs Treatment")+
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
       xlab("Remote Location")+
       ggtitle("Work Location vs Treatment")+
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
       xlab("Benefits")+
       ggtitle("Benefits Provided vs Treatment")+
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
       xlab("Resources Availability")+
       ggtitle("Resources Availability vs Treatment")+
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
       xlab("Negative Observed Consequences")+
       ggtitle("Observed Consequences vs Treatment")+
       theme_bw()+
       theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
       scale_fill_manual(values = alpha(c("honeydew3","grey52")))
   })

   output$table <- DT::renderDataTable({
     DT::datatable(filtered_data(), options=list(lengthMenu=c(10,30,50), 
                                                 scrollX= TRUE))
   }
   )
   output$table2 <- renderTable(
     desc
   )
}

# Run the application
shinyApp(ui = ui, server = server)
