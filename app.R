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
     h2("Mental Health Explorer in the Workplace"),
     h5("Need to encourage mental health check-ups? Consider these factors."),
   tags$hr(),
  tags$head(tags$style(
    HTML('
         #sidebar {
         background-color: whitesmoke;
         }


         body, label, input, button, select {
         font-family: "Arial";
         }')
  )),

   # Sidebar with a slider input for number of bins
   sidebarLayout(
     sidebarPanel(id="sidebar",
       h4("Data & Graph Filters:", align="left"),
       wellPanel(class="well", checkboxInput("countryCheck", "Country", FALSE),
                 uiOutput("countryOutput"),
                 checkboxInput("ageCheck", "Age", FALSE),
                 uiOutput("ageOutput")
                 ),
       br(),
       h4("Graph Filters:", align="left"),
       wellPanel(class="well",radioButtons("perproInput", label=NULL,
                              choices = c("Personal", "Professional"),
                              selected = "Personal")),
       width = 2),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Graphics", align="center",
                 conditionalPanel("input.perproInput == 'Personal'",
                                  plotlyOutput("personal", width="100%", heigh='55vw')),
                 conditionalPanel("input.perproInput == 'Professional'",
                                  plotlyOutput("professional",width="98%",height="55vw"))
        ),
        tabPanel("Data View", DT::dataTableOutput("table"))
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
      validate(
        need(input$countryInput,"Country or Age group must be provided.")
      )
      data <- data %>% filter(Country %in% input$countryInput)
    }
    if (input$ageCheck) {
      validate(
        need(input$ageInput, "Country or Age group must be provided.")
      )
      data <- data %>% filter(age_group %in%input$ageInput)
    }

    return(data)
  })

  # Creating personal plots
  label1<- c(
    `age_group` = "Age group",
    `family_history` = "Family history",
    `Gender` = "Gender",
    `obs_consequence` = "Observed negative consequences"
  )
  output$personal<- renderPlotly({
    personal <- filtered_data() %>%
      select(age_group,Gender,family_history,obs_consequence, treatment) %>%
      gather(variable,value,-treatment) %>%
      group_by(variable, value,treatment) %>%
      summarize(Response=n()) %>%
      ggplot(aes(value,Response, fill=treatment))+
      geom_bar(position=position_dodge(preserve = "single"), stat="identity")+
      facet_wrap(~variable, scales="free_x", labeller=as_labeller(label1))+
      theme_bw()+
      theme(panel.grid.major = element_blank(), 
            panel.grid.minor = element_blank(),
            strip.background = element_blank(), 
            strip.text.x = element_text(size = 11))+
      scale_y_continuous(expand = c(0,0,0,25)) + 
      scale_fill_manual(values = alpha(c("honeydew3","grey52")))+
      ylab("Count")+
      xlab("")+
      labs(fill="Treatment")
     ggplotly(personal) %>%
       layout(legend = list(orientation = "h",
                                          y = 1, x = 1.01))
  })

  # Creating professional plots
  label2<- c(
    `work_interfere` = "Experienced worked interference",
    `remote_work` = "Worked remotely",
    `benefits` = "Received work benefits",
    `seek_help` = "Help provided by employer "
  )

  output$professional <- renderPlotly({
    professional <- filtered_data() %>%
      select(work_interfere,remote_work ,benefits,seek_help, treatment) %>%
      gather(variable,value,-treatment) %>%
      group_by(variable, value,treatment) %>%
      summarize(Response=n()) %>%
      ggplot(aes(value,Response, fill=treatment))+
      geom_bar(position=position_dodge(preserve = "single"), stat="identity")+
      facet_wrap(~variable, scales="free_x", labeller=as_labeller(label2))+
      theme_bw()+
      theme(panel.grid.major = element_blank(), 
            panel.grid.minor = element_blank(),
            strip.background = element_blank(), 
            strip.text.x = element_text(size = 11))+
      scale_y_continuous(expand = c(0,0,0,25)) + 
      scale_fill_manual(values = alpha(c("honeydew3","grey52")))+
      ylab("Count")+
      xlab("")+
      labs(fill="Treatment")
    ggplotly(professional) %>%
      layout(legend = list(orientation = "h",
                           y = 1, x = 1.01))
  })

  # Rendering data view table
  output$table <- DT::renderDataTable({
    DT::datatable(filtered_data(),
                  options=list(lengthMenu=c(10,30,50), scrollX= TRUE),
                  container = htmltools::withTags(table(
                    class = 'display',
                    thead(
                      tr(
                        th('', title="Row Names"),
                        th('Age', title='Respondent age'),
                        th('Gender', title='Respondent gender'),
                        th('Country', title="Respondent country"),
                        th("Family History", title="Do you have a family history of mental illness?"),
                        th("Work Interfere", title="If you have a mental health condition, do you feel that it interferes with your work?"),
                        th("Treatment", title="Have you sought treatment for a mental health condition?"),
                        th("Remote Work", title="Do you work remotely (outside of an office) at least 50% of the time?"),
                        th("Benefits", title="Does your employer provide mental health benefits?"),
                        th('Seek Help', title="Does your employer provide resources to learn more about mental health issues and how to seek help?"),
                        th("Observed Negative Consequences", title="Have you heard of or observed negative consequences for coworkers with mental health conditions in your workplace?"),
                        th("Age Group", title="Age Group")
                      )
                    )
                  ))
    )
  }
  )
}

# Run the application
shinyApp(ui = ui, server = server)
