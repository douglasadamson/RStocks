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
  
  # Create the plot and decorate
  p <- ggplot(closeValues, aes(x=Date, y=Close)) + 
    labs(title=ticker, x="Date", y="Close Value") + 
    geom_abline() + 
    scale_x_date(date_labels = "%b %d, %Y") +
    scale_color_manual(values = c("red", "blue")) +
    geom_line() + 
    geom_point(aes(x=Date, y=Close), color="blue") +
    geom_label(aes(x=Date, y=Close, label = ifelse(Close == maxClose, paste("High:", Close, "\n", Date), NA)), nudge_x=-3.0, show.legend=FALSE) +
    geom_label(aes(x=Date, y=Close, label = ifelse(Close == minClose, paste("Low: ", Close, "\n", Date), NA)), nudge_x=3.0, show.legend=FALSE) +
    geom_segment(aes(x=0,  y=maxClose))
  p
}
