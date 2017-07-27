library(shiny)
server <- function(input, output) {
  #
  # Inputs
  #
  dataInput <- reactive ({
    currentValues <- quandl(input$ticker, input$dateRange[1], input$dateRange[2])
  })
  
  dataQuote <- reactive ({
    quote <- yahooQuote(input$ticker)
  })
  
  historicQuote <- reactive({
    hquote <- historicYahooQuote(input$ticker)
  })
  
  compQuote <- reactive({
    isolate({cquote <- yahooBatch()})
  })
  
  #
  # Outputs
  #
  output$tickerPlot <- renderPlot(
      plotTicker(input$ticker, dataInput())
    )
  
  output$tickerTable <- renderTable(
    dataQuote(), bordered = TRUE, align = 'c', spacing = 's'
  )
  
  output$historicValues <- renderTable(
    historicQuote(), bordered = TRUE, align = 'c', spacing = 's'
  )
  
  output$compTable <- renderTable(
    compQuote(), bordered = TRUE, align = 'c', spacing = 's', striped = TRUE
  )
}