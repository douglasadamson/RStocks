library(readr)

#
# Yahoo Constants
#
yahooFinanceURL <- "http://finance.yahoo.com/d/quotes.csv"
yahooNames <- c("Open", "Previous Close", "Ask", "Bid", "Yield", "Dividend", "52 Week High", 
                "52 Week Low", "Name", "Last", "Days High", "Days Low")
yahooArgs <- c("o", "p", "a", "b", "y", "d", "k", "j", "n", "l1", "h", "g")

#
# Read all the tickers in CSV file and get quotes from Yahoo
#
yahooBatch <- function() {
  # Exchange Ticker Symbols from CSV 
  TickerDF <- read_csv("./ticker.csv", col_names = TRUE)
  
  # Get some data from Yahoo Finance
  stockList <- paste(TickerDF$Symbol, collapse = ",")
  stockArgs <- paste(yahooArgs[1:12], collapse="")
  sendURL <- paste(yahooFinanceURL, "?s=", stockList, "&f=", stockArgs, sep="")
  
  # Read the data, calculate some values
  quotes <- read_csv(sendURL, col_names = yahooNames)
  Ticker <- TickerDF$Symbol
  quotes <- cbind(Ticker, quotes)
  quotes$Delta <- ((quotes$Last - quotes$Open) / quotes$Open) * 100
  quotes
}

#
# Get a short quote for this ticker
#
historicYahooQuote <- function(ticker) {
  args <- paste(c("k", "j", "d", "y"), collapse="")
  columns <- c("High", "Low", "Dividend", "Yield")
  URL <- paste(yahooFinanceURL, "?s=", ticker, "&f=", args, sep="")
  quote <- read_csv(URL, col_names = columns)
  quote
}

#
# Get historic quote for this ticker
#
yahooQuote <- function(ticker) {
  args <- paste(c("o", "l1", "h", "g"), collapse="")
  columns <- c("Open", "Last", "High", "Low")
  URL <- paste(yahooFinanceURL, "?s=", ticker, "&f=", args, sep="")
  quote <- read_csv(URL, col_names = columns)
  quote
}