#
# Quandl Wiki Free Financial Data Set Quoter
#
library(readr)
library(lubridate)
library(dplyr)

#
# If you have a private API Key for Quandl, put it in file APIKEY.txt
#
myAPIkey <- ifelse(file.exists("APIKEY.txt"), read_file("APIKEY.txt"), NA)

#
# Get a quote based on ticker name and start and end date range
#
quandl <- function(ticker, start_date, end_date) {
  #
  # Construct the service call using Quandl assigned API_KEY
  #
  if (is.na(myAPIkey)) {
    quandlArgs <- paste("start_date=", start_date, "&", "end_data=", end_date, "&ord=asc", sep = "")
  } else {
    myAPIkey <- trimws(myAPIkey, "r")
    quandlArgs <- paste("start_date=", start_date, "&", "end_data=", end_date, "&ord=asc", "&api_key=", myAPIkey, sep = "")
  }
  tickerArg <- paste(ticker, ".csv", sep = "")
  quandlUrl <- "https://www.quandl.com/api/v3/datasets/WIKI/"
  quandlSendURL <- paste(quandlUrl, tickerArg, "?", quandlArgs, sep = "")

  #
  # Call the Quandl service returning a tibble from the CSV. Catch HTTP Errors or Quandl Errors
  #
  tryCatch(
    {
      quandlCSV <- read_csv(quandlSendURL, col_names = TRUE, col_types = "Ddddddddddddd", na = c(NA, "", " "))
      quandlCSV$Date <- as.Date(quandlCSV$Date, format = "%Y-%m-%d", origin = "1970-01-01")
      return(quandlCSV)
    },
    error = function(e) {
      message(paste("Error:", e))
      return(NA)
    },
    warning = function(e) {
      message(paste("Warning:", e))
      return(NA)
    }
  )
}
