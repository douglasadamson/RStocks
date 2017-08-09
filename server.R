library(shiny)
source("yahooQuotes.R")
source("quandlQuotes.R")
source("plotTicker.R")

server <- function(input, output) {
  #
  # Inputs
  #
  currentMarket <- reactive ({switch (input$radio,
                             1 : "NASDAQ100",
                             2: "S&P500",
                             3: "AMEX",
                             "NASDAQ100")
  })
  
  dataInput <- reactive ({
    start = input$dateRange[1]
    end = input$dateRange[2]
    if (start > end) {
      start = end
      end = input$dateRange[1]
    }
#    news <- yahooNews(input$ticker)
    quandl(input$ticker, start, end)
    
  })
  
  dataQuote <- reactive ({
    yahooQuote(input$ticker)
  })
  
  historicQuote <- reactive({
    historicYahooQuote(input$ticker)
  })
  
#  compQuote <- reactive ({
#    yahooBatch()
#  })
  
  #
  # Outputs
  #
  output$tickerPlot <- renderPlot(
#      plotTicker(input$ticker, isolate(dataInput()))
    # todo: add "submit" button and isolate(submit button)
#    plotTicker(input$ticker, dataInput())
    plotTicker(input$ticker, dataInput())
    )
  
  output$tickerTable <- renderTable(
    dataQuote(), bordered = TRUE, align = 'c', spacing = 's'
  )
  
  output$historicValues <- renderTable(
    historicQuote(), bordered = TRUE, align = 'c', spacing = 's'
  )
  
  output$compTable <- renderTable(
    yahooBatch(), bordered = TRUE, align = 'c', spacing = 's', striped = TRUE
  )
}