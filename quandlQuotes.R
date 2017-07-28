#
# Quandl Wiki Free Financial Data Set Quoter
#
library(readr)
#library(Quandl)

#
# Get a quote based on ticker name and start and end date range
#
quandl <- function(ticker, start_date, end_date) {
  # Construct the service call
  quandlArgs <- paste("start_date=", start_date, "&", "end_data=", end_date, "&ord=asc", sep="")
  tickerArg = paste(ticker, ".csv", sep="")
  quandlUrl <- "https://www.quandl.com/api/v3/datasets/WIKI/"
  quandlSendURL <- paste(quandlUrl, tickerArg, "?", quandlArgs, sep="")
  
  # Call the service returning a CSV
  quandlCSV <- read_csv(quandlSendURL, col_names=TRUE)
  
  # Convert everything to Date objects
  quandlCSV$Date <- as.Date(quandlCSV$Date, format = "%Y-%m-%d")
  
  return(quandlCSV)
}
