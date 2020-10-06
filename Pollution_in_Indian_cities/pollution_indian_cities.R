library(shiny)
library(ggplot2)

data <- read.csv("https://raw.githubusercontent.com/learning-monk/datasets/master/ENVIRONMENT/Indian_cities_daily_pollution_2015-2020.csv")


# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Pollution in Indian Cities 2015-2020")
    
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {

}

# Run the application 
shinyApp(ui = ui, server = server)
