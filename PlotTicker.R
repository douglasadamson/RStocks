#
# Plot Date x Close$
#
library(ggplot2)
library(ggrepel)

#
# Plot this ticker from for date range
#
plotTicker <- function(ticker, closeValues) {
  # Find maximums & minimums
  maxClose = max(closeValues$Close)
  minClose = min(closeValues$Close)
  maxIndex = which(closeValues$Close == maxClose)
  minIndex = which(closeValues$Close == minClose)
#  maxDate = closeValues$Date[maxIndex]
#  minDate = closeValues$Date[minIndex]

  # Create the plot and decorate
  p <- ggplot(closeValues, aes(Date, Close)) +
    labs(title = paste(ticker, " Daily Closes"), x = "Date", y = "Closing Price") +
    scale_y_continuous(labels = scales::dollar) +
    scale_x_date(date_labels = "%b %d, %Y", date_minor_breaks = "1 week") +
    scale_color_manual(values = c("red", "blue")) +
    geom_line() +
    geom_point(aes(x = Date, y = Close), color = "blue") +
    geom_label_repel(aes(x = Date, y = Close, label = ifelse(Close == maxClose, paste("High:", Close, "\n", Date), NA)), show.legend = FALSE) +
    geom_label_repel(aes(x = Date, y = Close, label = ifelse(Close == minClose, paste("Low: ", Close, "\n", Date), NA)), show.legend = FALSE)

# Get Plot Ranges for Date and Close (same as min/max Close and min/max Date)
#  xRange <- ggplot_build(p)$layout$panel_ranges[[1]]$x.range
#  yRange <- ggplot_build(p)$layout$panel_ranges[[1]]$y.range


  # Add some lines down to axis
#  p <- p + geom_segment(data = closeValues, aes(x = maxDate, y = maxClose, xend = maxDate, yend = 0), color="red", linetype="dashed")
#  geom_segment(data = closeValues, aes(x = maxDate, y = maxClose, xend = maxDate, yend = minClose), color="red", linetype="dashed") +
#  geom_segment(data = closeValues, aes(x = maxDate, y = maxClose, xend = minDate, yend = maxClose), color="red", linetype="dashed", alpha = 0.25)


# hline and vlines from max and min values to axis
#  p <- p + geom_hline(data=closeValues, aes(yintercept=maxClose), linetype="dashed", show.legend=FALSE, color="purple")
#  p <- p + geom_hline(data=closeValues, aes(yintercept=minClose), linetype="dashed", show.legend=FALSE,color="red")
#  p <- p + geom_vline(data = closeValues, aes(x=Date, xintercept=as.numeric(Date[maxIndex])), linetype="dashed", show.legend=FALSE, color="purple")
#  p <- p + geom_vline(data = closeValues, aes(x=Date, xintercept=as.numeric(Date[minIndex])), linetype="dashed", show.legend=FALSE, color="purple")

  return(p)
}

plotVolume <- function(ticker, closeValues) {
  p <- ggplot(closeValues, aes(Date, Volume)) +
    labs(title = paste(ticker, " Daily Volumes"), x = "", y = "Volume") +
    scale_y_log10() +
    scale_x_date(date_labels = "%b %d, %Y", date_minor_breaks = "1 week") +
    geom_point() +
    geom_line()

  return(p)
}

drawHover <- function(e) {
  x = round(as.numeric(e$x))
  y = round(as.numeric(e$y))
  date = as.Date(x, origin = "1970-01-01")
  print(paste0("Date=", format(date, "%a %b %d, %Y"), "\nClose=$", y))
}
