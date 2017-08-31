library(tidyverse)
library(readr)
library(xml2)
#
# Get news for this stock
#
cnnRSS <- function() {
  #
  # Get the RSS news feed from CNN
  #
  #cnnRSSURL <- "http://rss.cnn.com/rss/money_topstories.rss"
  cnnRSSURL  <- "http://rss.cnn.com/rss/money_mostpopular.rss"
  news       <- read_xml(cnnRSSURL)

  #
  # Parse the RSS feed into text (delete <tags>)
  #
  titles       <- news %>% xml_find_all(".//title") %>% xml_text() %>% as.character()
  descriptions <- news %>% xml_find_all(".//description") %>% xml_text() %>% as.character()
  links        <- news %>% xml_find_all(".//link") %>% xml_text() %>% as.character()
  pubDates     <- news %>% xml_find_all(".//pubDate") %>% xml_text() %>% as.character()

  #
  # Build a data frame
  #
  newsDF <- data_frame(Titles = titles,
                       Descriptions = descriptions,
                       Links = links,
                       PubDates = pubDates)
  #
  # Return the dataframe with headers
  #
  return(newsDF)
}
