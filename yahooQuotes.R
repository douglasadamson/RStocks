library(tidyverse)
library(readr)
library(xml2)
source("getTickers.R")

#
# Yahoo Constants
#
yahooFinanceURL <- "http://finance.yahoo.com/d/quotes.csv"
yahooDF <- data.frame(Names = c("Open", "Previous Close", "Ask", "Bid", "Yield", "Dividend", "52 Week High", 
                                "52 Week Low", "Name", "Last", "Days High", "Days Low"), 
                      Args = c("o", "p", "a", "b", "y", "d", "k", "j", "n", "l1", "h", "g"))

#
# Read all the tickers in CSV file and get quotes from Yahoo
#
yahooBatch <- function() {
  # Exchange Ticker Symbols from CSV 
  TickerDF <- getTickers("favorites")
  
  # Get some data from Yahoo Finance
  stockList <- paste(TickerDF$Symbol, collapse = ",")
  stockArgs <- paste(yahooDF$Args[1:12], collapse="")
  sendURL <- paste(yahooFinanceURL, "?s=", stockList, "&f=", stockArgs, sep="")
  
  # Read the data, calculate some values
  quotes <- read_csv(sendURL, col_names = as.vector(yahooDF$Names))
  Ticker <- TickerDF$Symbol
  quotes <- cbind(Ticker, quotes)
  quotes$Delta <- ((quotes$Last - quotes$Open) / quotes$Open) * 100
  return(quotes)
}

#
# Get a short quote for this ticker
#
historicYahooQuote <- function(ticker) {
  args <- paste(c("k", "j", "d", "y"), collapse="")
  columns <- c("High", "Low", "Dividend", "Yield")
  URL <- paste(yahooFinanceURL, "?s=", ticker, "&f=", args, sep="")
  quote <- read_csv(URL, col_names = columns)
  return(quote)
}

#
# Get historic quote for this ticker
#
yahooQuote <- function(ticker) {
  args <- paste(c("o", "l1", "h", "g"), collapse="")
  columns <- c("Open", "Last", "High", "Low")
  URL <- paste(yahooFinanceURL, "?s=", ticker, "&f=", args, sep="")
  quote <- read_csv(URL, col_names = columns)
  return(quote)
}

#
# Get news for this stock
#
yahooNews <- function(ticker) {
  #
  # Get the RSS feed for this ticker
  #
  yahooNewsURL <- "http://feeds.finance.yahoo.com/rss/2.0/headline?s="
  yahooTail <- "&region=US&lang=en-US"
  yahooMsg = paste(yahooNewsURL, ticker, yahooTail, sep="")
  news <- read_xml(yahooMsg)
  
  #
  # Parse the RSS feed into text (delete <tags>)
  #
  titles <- news %>% xml_find_all(".//title") %>% xml_text()
  descriptions <- news %>% xml_find_all(".//description") %>% xml_text()
  links <- news %>% xml_find_all(".//link") %>% xml_text()
  pubDates <- news %>% xml_find_all(".//pubDate") %>% xml_text()
  
  #
  # Build a data frame
  #
  newsDF <- data.frame(Titles=titles[2:(length(titles)-1)], Descriptions=descriptions[2:length(descriptions)], Links=links[2:(length(links)-1)], PubDates = pubDates)
  
  #
  # Return the dataframe with headers
  #
  return(newsDF)
}