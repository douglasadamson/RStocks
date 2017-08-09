library(shiny)
library(shinythemes)
source("getTickers.R")

# Load default ticker List
choicesDF = getTickers("nasdaq100")

#ui <- fluidPage(shinythemes::themeSelector(),

# Create the UI components
ui <- fluidPage(theme=shinytheme("superhero"),
  wellPanel(
    fluidRow(
      column(3,
             radioButtons(inputId = "radio", label = "Select Market",
                          choices = list("NASDAQ100" = 1, "S&P500" = 2, "AMEX" = 3), 
                          selected = 1, inline = TRUE), 
             hr(),
             selectInput(inputId = "ticker", label = "Enter Ticker:", choices = as.vector(choicesDF$Symbol)),
             dateRangeInput(inputId = "dateRange", 
                            label = "Date Range:", 
                            start = Sys.Date() - 30,
                            end = Sys.Date(),
                            min = "1970-01-01",
                            max = Sys.Date(),
                            format = "yyyy-mm-dd"), 
             hr(),
             h4("Today's Values"),
             tableOutput("tickerTable"), 
             hr(),
             h4("52 Week Values"),
             tableOutput("historicValues")
             ),
      column(9, 
             plotOutput("tickerPlot")
            )
    )
  ), style = "padding: 20px;",
  wellPanel (
    fluidRow(
      column(12,
             h3("Comparable Companies"),
             tableOutput("compTable")
             )
    )
  )
)
#  sidebarLayout(
#    sidebarPanel(
#      selectInput(inputId = "ticker", label = "Enter Ticker:", choices = stockTicker),
#      dateRangeInput(inputId = "dateRange", 
#               label = "Date Range:", 
#                start = Sys.Date() - 30,
#                end = Sys.Date(),
#                format = "yyyy-mm-dd"),
      # Get a daily quote
#      h4("Today's Values"),
#      tableOutput("tickerTable"),
      # Get a 52 week quote
#      h4("52 Week Values"),
#      tableOutput("historicValues")
#    ),
#    mainPanel(
#      plotOutput("tickerPlot")
#    )
#  ),
#  h1("Comparable Companies"),
#  tableOutput("compTable")
#)