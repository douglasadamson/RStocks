library(readr)
#
# Ultimately, get this data from a service
#
getTickers <- function(index) {
  
  # Which Index?
  filename = switch(index,
                "nasdaq"    = "nasdaq100.csv",
                "nasdaq100" = "nasdaq100.csv",
                "favorites" = "ticker.csv",
                "ticker.csv")
  
  csv <- read_csv(filename, col_names = TRUE)
  
  # Put into aplhabetical order and put favorites at top
  df <- csv[order(-csv$Favorites, csv$Symbol),]
  
  return(df)
}
