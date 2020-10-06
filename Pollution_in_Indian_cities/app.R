library(shiny)
library(tidyverse)
library(plotly)
library(tidyr)


pollution <- read.csv('./Indian_cities_daily_pollution_2015-2020.csv', 
                      stringsAsFactor=FALSE, na.strings=c(""))

# Convert date column to Date format
pollution$Date <- as.Date(pollution$Date)

# Re-order bucket values in logical order in AQI_Bucket columns
pollution$AQI_Bucket <- factor(pollution$AQI_Bucket, levels = c('Severe', 'Very Poor', 'Poor', 'Moderate',
                                                                'Satisfactory', 'Good'))

# List of pollutants
pollutants <- c('PM2.5', 'PM10', 'NO', 'NO2', 'NOx', 'NH3', 'CO', 'SO2', 'O3', 'Benzene', 'Toluene', 'Xylene')

# Reshape data from wide to long to suit line chart
p_data <- pivot_longer(pollution, cols = pollutants, names_to = "pollutant", values_to = "reading")

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Air Quality in Indian cities"),
    sidebarLayout(
        sidebarPanel(
            selectInput("city", "Select City:", pollution$City),
            checkboxGroupInput("pollutant", "Select Pollutant:", pollutants, selected = "PM2.5")
        ),
        mainPanel(
            plotlyOutput("graph")  
        ),
        fluid = TRUE
        
    )
)

# Define server logic
server <- function(input, output, session) {
    # suppress warnings  
    storeWarn<- getOption("warn")
    options(warn = -1) 
    
    output$graph <- renderPlotly({
        
        filtered_data <- reactive({p_data %>%
                filter(City == input$city & pollutant %in% input$pollutant)
            
        })
        plot_ly(filtered_data(), x = ~Date, y = ~reading, color = ~pollutant) %>%
            add_lines() %>%
            layout(title = paste("Pollutants in", {input$city}, "over the years 2015-2020"),
                   xaxis = list(title = "Date"),
                   yaxis = list(title = "Pollutant Reading"),
                   showlegend = TRUE)  %>%
            config(displayModeBar = FALSE, responsive = TRUE)
    })
    #restore warnings, delayed so plot is completed
    shinyjs::delay(expr =({ 
        options(warn = storeWarn) 
    }) ,ms = 100) 
}

# Run the application 
shinyApp(ui = ui, server = server)
