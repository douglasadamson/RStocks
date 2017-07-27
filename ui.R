library(shiny)
ui <- fluidPage(
  titlePanel("Stock Quotes"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "ticker", label = "Enter Ticker:", choices = stockTicker),
      dateRangeInput(inputId = "dateRange", 
                label = "Date Range:", 
                start = Sys.Date() - 30,
                end = Sys.Date(),
                format = "yyyy-mm-dd"),
      # Get a daily quote
      h4("Today's Values"),
      tableOutput("tickerTable"),
      # Get a 52 week quote
      h4("52 Week Values"),
      tableOutput("historicValues")
    ),
    mainPanel(
      plotOutput("tickerPlot")
    )
  ),
  h1("Comparable Companies"),
  tableOutput("compTable")
)