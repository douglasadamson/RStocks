library(readr)
#
# Ultimately, get this data from a service
#
getTickers <- function(whichList) {
  # Which Symbol list
  file = ifelse(whichList == "nasdaq100", "./nasdaq100list.csv", "ticker.csv")
  csv <- read_csv(file, col_names = TRUE)
  
  # Put into aplhabetical order
  df <- csv[order(-csv$Favorites, csv$Symbol),]
  return(df)
}
