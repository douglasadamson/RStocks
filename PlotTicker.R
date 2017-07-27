#
# Plot Date x Close$
#
library(ggplot2)

#
# Plot this ticker from for date range
# 
plotTicker <- function(ticker, closeValues) {
  # Find maximum 
  maxClose = max(closeValues$Close)
  minClose = min(closeValues$Close)
  maxIndex = which(closeValues$Close == maxClose)
  minIndex = which(closeValues$Close == minClose)
  maxDate = closeValues$Date[maxIndex]
  minDate = closeValues$Date[minIndex]
  
  # Create the plot and decorate
  p <- ggplot(closeValues, aes(x=Date, y=Close)) + 
    labs(title=ticker, x="Date", y="Close Value") + 
    scale_y_continuous(labels = scales::dollar) +
    scale_x_date(date_labels = "%b %d, %Y", date_minor_breaks = "1 week") +
    scale_color_manual(values = c("red", "blue")) +
    geom_line() + 
    geom_point(aes(x=Date, y=Close), color="blue") +
    geom_label(aes(x=Date, y=Close, label = ifelse(Close == maxClose, paste("High:", Close, "\n", Date), NA)), nudge_x=-3.0, show.legend=FALSE) +
    geom_label(aes(x=Date, y=Close, label = ifelse(Close == minClose, paste("Low: ", Close, "\n", Date), NA)), nudge_x=3.0, show.legend=FALSE)
  
  # Get Plot Ranges for Date and Close (same as min/max Close and min/max Date)
#  xRange <- ggplot_build(p)$layout$panel_ranges[[1]]$x.range
#  yRange <- ggplot_build(p)$layout$panel_ranges[[1]]$y.range
  
  
  # Add some lines down to axis
#  p <- p +
#    geom_segment(data = closeValues, aes(x = maxDate, y = maxClose, xend = maxDate, yend = minClose), color="red", linetype="dashed", alpha = 0.25) +
#    geom_segment(data = closeValues, aes(x = minDate, y = maxClose, xend = maxDate, yend = maxClose), color="red", linetype="dashed", alpha = 0.25)
  
  p <- p + geom_hline(data=closeValues, aes(yintercept=maxClose, color="green"), linetype="dashed", show.legend=FALSE)
  p <- p + geom_hline(data=closeValues, aes(yintercept=minClose, color="yellow"), linetype="dashed", show.legend=FALSE)
#  p <- p + geom_vline(data = closeValues, aes(xintercept=maxDate, color="red"), linetype="dashed")
    
  return(p)
}