library(shiny)
library(tidyverse)
library(shinythemes)
library(tidyverse)
library(plotly)
library(DT)
library(rsconnect)

# Read data
data <- read_csv("data/clean/data_clean.csv")
data$X1 <- NULL

# Read variable descriptions
desc <- read_csv("data/variables_description.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(
  tags$style(HTML('table.dataTable.hover tbody tr:hover,
                  table.dataTable.display tbody tr:hover
                  {background-color: pink !important;}')),
  theme=shinytheme("lumen"),
   # Application title
   titlePanel("Mental Health Explorer in the Workplace"),
   tags$hr(),

   # Sidebar with a slider input for number of bins
   sidebarLayout(
     sidebarPanel(
       h4("Filter by:", align="left"),
       wellPanel(checkboxInput("countryCheck", "Country", FALSE),
                 uiOutput("countryOutput"),
                 checkboxInput("ageCheck", "Age", FALSE),
                 uiOutput("ageOutput")
                 ),
       br(),
       h4("Type:", align="left"),
       wellPanel(radioButtons("perproInput", label=NULL,
                              choices = c("Personal", "Professional"),
                              selected = "Personal")),
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
        tabPanel("Variable Descriptions", DT::dataTableOutput("table2"))
          ),
      width=10)
    )
   )
server <- function(input, output) {
  
  # Render the selectInput for countries
  output$countryOutput <- renderUI({
    if(input$countryCheck) {
      selectInput('countryInput', 'Country', sort(unique(data$Country)),
                  selected = "Canada", multiple = TRUE, selectize=TRUE)
      }
    })

  # Render the selectInput for ages
  output$ageOutput <- renderUI({
    if(input$ageCheck) {
      selectInput('ageInput', 'Age groups', sort(unique(data$age_group)),
                  selected = "31-40", multiple = TRUE, selectize=TRUE)
    }
  })

  # Filter data based on above filters
  filtered_data <- reactive({
    if (input$countryCheck) {
      data <- data %>% filter(Country %in% input$countryInput)
    }
    if (input$ageCheck) {
      data <- data %>% filter(age_group %in%input$ageInput)
    }
    
    return(data)
    })
    
  # Create plotly plots
  output$Age <- renderPlotly({
    age <- filtered_data() %>%
      select(age_group, treatment) %>%
      arrange(age_group,treatment) %>%
      group_by(age_group,treatment) %>%
      summarize(Response=n()) %>%
      ggplot(aes(age_group,Response, fill=treatment))+
      geom_bar(position=position_dodge(preserve = "single"), stat="identity")+
      labs(fill="Treatment", y="Count", x="Age groups")+
      ggtitle("Age Group") +
      theme_bw()+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
      scale_fill_manual(values = alpha(c("honeydew3","grey52")))
    ggplotly(age) %>%
      layout(legend=list(orientation="h", x=0.6, y=0.95))
  })

   output$Gender <- renderPlotly({
     gender <- filtered_data() %>%
       select(Gender, treatment) %>%
       arrange(Gender,treatment) %>%
       group_by(Gender,treatment) %>%
       summarize(Response=n()) %>%
       ggplot(aes(Gender,Response, fill=treatment))+
       geom_bar(position=position_dodge(preserve = "single"), stat="identity")+
       ylab("Count")+
       ggtitle("Gender")+
       theme_bw()+
       theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),legend.position = "none")+
       scale_fill_manual(values = alpha(c("honeydew3","grey52")))

   })

    output$family_history <- renderPlotly({
     fam_hist <- filtered_data() %>%
       select(family_history, treatment) %>%
       arrange(family_history,treatment) %>%
       group_by(family_history,treatment) %>%
       summarize(Response=n()) %>%
       ggplot(aes(family_history,Response, fill=treatment))+
       geom_bar(position=position_dodge(preserve = "single"), stat="identity")+
       ylab("Count")+
       xlab("Family History")+
       ggtitle("Family History")+
       theme_bw()+
       theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),legend.position = "none")+
       scale_fill_manual(values = alpha(c("honeydew3","grey52")))

   })

   output$work_interfere <- renderPlotly({
     work_int <- filtered_data() %>%
       select(work_interfere, treatment) %>%
       arrange(work_interfere,treatment) %>%
       group_by(work_interfere,treatment) %>%
       summarize(Response=n()) %>%
       ggplot(aes(work_interfere,Response, fill=treatment))+
       geom_bar(position=position_dodge(preserve = "single"), stat="identity")+
       labs(y="Count",x="Work Interference",fill="Treatment")+
       ggtitle("Work Interference")+
       theme_bw()+
       theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
       scale_fill_manual(values = alpha(c("honeydew3","grey52")))
     ggplotly(work_int) %>%
       layout(legend=list(orientation="h", x=0.1, y=0.7))
   })

   output$remote_work <- renderPlotly({
     filtered_data() %>%
       select(remote_work, treatment) %>%
       arrange(remote_work,treatment) %>%
       group_by(remote_work,treatment) %>%
       summarize(Response=n()) %>%
       ggplot(aes(remote_work,Response, fill=treatment))+
       geom_bar(position=position_dodge(preserve = "single"), stat="identity")+
       ylab("Count")+
       xlab("Remote Location")+
       ggtitle("Work Location")+
       theme_bw()+
       theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),legend.position = "none")+
       scale_fill_manual(values = alpha(c("honeydew3","grey52")))
   })

   output$benefit <- renderPlotly({
     filtered_data() %>%
       select(benefits, treatment) %>%
       arrange(benefits,treatment) %>%
       group_by(benefits,treatment) %>%
       summarize(Response=n()) %>%
       ggplot(aes(benefits,Response, fill=treatment))+
       geom_bar(position=position_dodge(preserve = "single"), stat="identity")+
       ylab("Count")+
       xlab("Benefits")+
       ggtitle("Benefits Provided")+
       theme_bw()+
       theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),legend.position = "none")+
       scale_fill_manual(values = alpha(c("honeydew3","grey52")))
   })

   output$seek_help <- renderPlotly({

     filtered_data() %>%
       select(seek_help, treatment) %>%
       arrange(seek_help,treatment) %>%
       group_by(seek_help,treatment) %>%
       summarize(Response=n()) %>%
       ggplot(aes(seek_help,Response, fill=treatment))+
       geom_bar(position=position_dodge(preserve = "single"), stat="identity")+
       ylab("Count")+
       xlab("Resources Availability")+
       ggtitle("Resources Availability")+
       theme_bw()+
       theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),legend.position = "none")+
       scale_fill_manual(values = alpha(c("honeydew3","grey52")))

   })
   output$obs_consequence<- renderPlotly({

     filtered_data() %>%
       select(obs_consequence, treatment) %>%
       arrange(obs_consequence,treatment) %>%
       group_by(obs_consequence,treatment) %>%
       summarize(Response=n()) %>%
       ggplot(aes(obs_consequence,Response, fill=treatment))+
       geom_bar(position=position_dodge(preserve = "single"), stat="identity")+
       ylab("Count")+
       xlab("Negative Consequences Observedin")+
       ggtitle("Observed Consequences")+
       theme_bw()+
       theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),legend.position = "none")+
       scale_fill_manual(values = alpha(c("honeydew3","grey52")))
   })

   output$table <- DT::renderDataTable({
     DT::datatable(filtered_data(), 
                   options=list(lengthMenu=c(10,30,50), scrollX= TRUE),
                   container = htmltools::withTags(table(
                     class = 'display',
                     thead(
                       tr(
                         th('', title="Row Names"),
                         th('Age', title='Age'),
                         th('Gender', title='Gender'),
                         th('Country', title="Country"), 
                         th("Family History", title="Family History"),
                         th("Work Interfere", title="Work Interfere"),
                         th("Treatment", title="Treatment"),
                         th("Remote Work", title="Remote Work"),
                         th("Benefits", title="Benefits"),
                         th('Seek Help', title="Seek Help"),
                         th("Observed Negative Consequences", title="Observed Negative Consequences"),
                         th("Age Group", title="Age Group")
                       )
                     )
                   ))
                   )
   }
   )
   output$table2 <- DT::renderDataTable(
     DT::datatable(desc,
     container = htmltools::withTags(table(
       class = 'display',
       thead(
         tr(
           th('', title="Row Names"),
           th('Variables', title='Variables'),
           th('Descriptions', title='Descriptions')
         )
       )
     ))
    )
   )
}

# Run the application
shinyApp(ui = ui, server = server)
