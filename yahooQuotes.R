library(tidyverse)
library(readr)
library(xml2)
source("getTickers.R")

#
# Yahoo API documentation: http://wern-ancheta.com/blog/2015/04/05/getting-started-with-the-yahoo-finance-api/
#

#
# Yahoo Constants
#
yahooFinanceURL <- "http://finance.yahoo.com/d/quotes.csv"
yahooDF <- data_frame(Names = c("Open", "Previous Close", "Ask", "Bid", "Yield", "Dividend", "52 Week High",
                                "52 Week Low", "Name", "Last", "Days High", "Days Low", "Ticker", "Delta"),
                      Args  = c("o", "p", "a", "b", "y", "d", "k", "j", "n", "l1", "h", "g", "", ""),
                      Types = c("d", "d", "d", "d", "d", "d", "d", "d", "c", "d", "d", "d", "c", "d")
                      )

#
# Read all the tickers in CSV file and get quotes from Yahoo
#
yahooBatch <- function() {
  # Exchange Ticker Symbols from CSV
  TickerDF <- getTickers("favorites")

  # Get some data from Yahoo Finance
  stockList <- paste(TickerDF$Symbol, collapse = ",")
  stockArgs <- paste(yahooDF$Args[1:12], collapse = "")
  sendURL   <- paste(yahooFinanceURL, "?s=", stockList, "&f=", stockArgs, sep = "")

  #
  # Read the data
  #
  quotes <- read_csv(sendURL, col_names = yahooDF$Names[1:12], col_types = paste(yahooDF$Types[1:12], collapse = ""), na = c(NA, " ", ""))

    # Add ticket sysmbol for table and day's high/low delta
  quotes$Ticker <- as.character(TickerDF$Symbol)
  quotes$Delta  <- as.double(((quotes$Last - quotes$Open) / quotes$Open) * 100)

  #
  # Reorder Columns for nicer Table output and return
  #
  quotes <- quotes[c(13, 9, 2, 1, 11, 12, 3, 4, 10, 5, 6, 7, 8, 14)]
  return(quotes)
}

#
# Get a short quote for this ticker
#
historicYahooQuote <- function(ticker) {
  args <- paste(c("k", "j", "d", "y"), collapse = "")
  columns <- c("High", "Low", "Dividend", "Yield")
  URL <- paste(yahooFinanceURL, "?s=", ticker, "&f=", args, sep = "")
  quote <- read_csv(URL, col_names = as.vector(columns), col_types = "dddd")
  return(quote)
}

#
# Get historic quote for this ticker
#
yahooQuote <- function(ticker) {
  args <- paste(c("o", "l1", "h", "g"), collapse = "")
  columns <- c("Open", "Last", "High", "Low")
  URL <- paste(yahooFinanceURL, "?s=", ticker, "&f=", args, sep = "")
  quote <- read_csv(URL, col_names = as.vector(columns), col_types = "dddd")
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
  yahooMsg <- paste(yahooNewsURL, ticker, yahooTail, sep = "")
  news <- read_xml(yahooMsg)

  #
  # Parse the RSS feed into text (delete <tags>)
  #
  titles <- news %>% xml_find_all(".//title") %>% xml_text() %>% as.character()
  descriptions <- news %>% xml_find_all(".//description") %>% xml_text() %>% as.character()
  links <- news %>% xml_find_all(".//link") %>% xml_text() %>% as.character()
  pubDates <- news %>% xml_find_all(".//pubDate") %>% xml_text() %>% as.character()

  #
  # Build a data frame
  #
  newsDF <- data_frame(Titles = titles[2:(length(titles) - 1)],
                       Descriptions = descriptions[2:length(descriptions)],
                       Links = links[2:(length(links) - 1)],
                       PubDates = pubDates)

  #
  # Return the dataframe with headers
  #
  return(newsDF)
}
