library(readr)
library(ggplot2)

yahoo <- function() {
  # Pricing names and symbols fpr Yahoo Finance API
  yahooNames <- c("Open", "Previous Close", "Ask", "Bid", "Yield", "Dividend per share", "52 Week High", 
                  "52 Week Low", "Name", "Last", "Days High", "Days Low")
  yahooArgs <- c("o", "p", "a", "b", "y", "d", "k", "j", "n", "l1", "h", "g")
  #yahooPricing <- cbind(yahooNames, yahooArgs)
  
  # Yahoo Finance API endpoint
  yahooFinanceURL <- "http://finance.yahoo.com/d/quotes.csv"
  
  # Exchange Ticker Symbols
  TickerDF <- read_csv("./ticker.csv", col_names = TRUE)
  
  # Get some data from Yahoo Finance
  stockList <- paste(TickerDF$Symbol, collapse = ",")
  stockArgs <- paste(yahooArgs[1:12], collapse="")
  sendURL <- paste(yahooFinanceURL, "?s=", stockList, "&f=", stockArgs, sep="")
  
  # Read the data, calculate some values
  quotes <- read_csv(sendURL, col_names = yahooNames)
  quotes <- cbind(TickerDF$Symbol, quotes)
  quotes$Delta <- ((quotes$Last - quotes$Open) / quotes$Open) * 100
  quotes
}

# Quandl Wiki Free Financial Data Set
quandl <- function(ticker, start_date, end_date) {
  quandlArgs <- paste("start_date=", start_date, "&", "end_data=", end_date, "&ord=asc", sep="")
  tickerArg = paste(ticker, ".csv", sep="")
  quandlUrl <- "https://www.quandl.com/api/v3/datasets/WIKI/"
  quandlSendURL <- paste(quandlUrl, tickerArg, "?", quandlArgs, sep="")
  quandlCSV <- read_csv(quandlSendURL, col_names=TRUE)
  quandlCSV
}

myYahooQuotes <- yahoo()
myQuandlQuotes <- quandl("AAPL", "2017-01-01", "2017-07-14")

# Build a Shiny App
library(shiny)
ui <- fluidPage()
server <- function(input, output) {}
shinyApp(ui = ui, server = server)



