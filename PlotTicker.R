#
# Create plots of trade information over time
#
library(ggplot2)
library(ggrepel)
library(tidyverse)

#
# Plot this ticker from for date range
#
plotTicker <- function(ticker, closeValues) {
  #
  # Get Plot Ranges for Date and Close (same as min/max Close and min/max Date)
  #  xRange <- ggplot_build(p)$layout$panel_ranges[[1]]$x.range
  #  yRange <- ggplot_build(p)$layout$panel_ranges[[1]]$y.range
  #
  maxClose = max(closeValues$Close)
  minClose = min(closeValues$Close)

  # Create the plot and decorate
  p <- ggplot(closeValues, aes(Date, Close)) +
    labs(title = paste(ticker, " Daily Closes"), x = "Date", y = "Closing Price") +
    scale_y_continuous(labels = scales::dollar) +
    scale_x_date(date_labels = "%b %d, %Y", date_minor_breaks = "1 week") +
    scale_color_manual(values = c("red", "blue")) +
    geom_line() +
    geom_point(aes(x = Date, y = Close), color = "blue") +
    geom_label_repel(aes(x = Date, y = Close, label = ifelse(Close == maxClose, paste("High:", Close, "\n", Date), "")), show.legend = FALSE) +
    geom_label_repel(aes(x = Date, y = Close, label = ifelse(Close == minClose, paste("Low: ", Close, "\n", Date), "")), show.legend = FALSE)

  return(p)
}

#
# Plot Daily Trade Volumes
#
plotVolume <- function(ticker, closeValues) {
  p <- ggplot(closeValues, aes(Date, Volume)) +
    labs(title = paste(ticker, " Daily Volumes"), x = "", y = "Volume") +
    scale_y_log10() +
    scale_x_date(date_labels = "%b %d, %Y", date_minor_breaks = "1 week") +
    geom_point() +
    geom_line()

  return(p)
}

#
# Draw price and date when hovering over points in graph (experimental)
#
drawHover <- function(e) {
  x = round(as.numeric(e$x))
  y = round(as.numeric(e$y))
  date = as.Date(x, origin = "1970-01-01")
  print(paste0("Date=", format(date, "%a %b %d, %Y"), "\nClose=$", y))
}
