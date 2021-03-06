library(shiny)
library(lubridate)
source("yahooQuotes.R")
source("quandlQuotes.R")
source("plotTicker.R")
source("cnnRSSFeed.R")

server <- function(input, output) {
  #
  # Reactive Inputs
  #
#  dataInput <- reactive({
#    start = input$dateRange[1]
#    end = input$dateRange[2]
#    if (start > end) {
#     start = end
#     end = input$dateRange[1]
#   }
#   quandl(input$ticker, start, end)
# })

  getDays <- function(selection) {
    days <- switch(as.character(selection),
           "1" = 30,
           "2" = 60,
           "3" = 180,
           "4" = 365,
           "5" = 730,
           "6" = 1825,
           30)
    return(days)
  }

  dataInput2 <- reactive({
    days <- getDays(input$radio)
    toDate <- today()
    fromDate <- toDate - days
    quandl(input$ticker, fromDate, toDate)
  })

  dataQuote <- reactive({
    yahooQuote(input$ticker)
  })

  historicQuote <- reactive({
    historicYahooQuote(input$ticker)
  })

  newsQuote <- reactive({
    news <- yahooNews(input$ticker)
    str <- tags$h4(paste0("Latest Yahoo News for ", input$ticker))
    for (i in 1:nrow(news)) {
      title <- news$Titles[i]
      date <- gsub('+0000', "", news$PubDates[i], fixed = TRUE)
      desc <- news$Descriptions[i]
      link <- news$Links[i]
      str <- paste(str,
                  tags$a(href = link, title),
                  tags$small(date),
                  tags$br(),
                  tags$p(tags$em(tags$small(desc)))
                  )
    }
    return(str)
  })

  #
  # CNN RSS feed for top/popular stories
  #
  cnnRSSQuote <- reactive({
    news <- cnnRSS()
    str <- tags$h4("Popular Stories from CNN")
    for (i in 1:nrow(news)) {
      title <- news$Titles[i]
      date <- gsub('+0000', "", news$PubDates[i], fixed = TRUE) # truncate seconds from dates
      desc <- gsub("(<img src=\"http://(.*)/>)", '', news$Descriptions[i]) # Get rid of image tags in descriptions
      link <- news$Links[i]
      str <- paste(str,
                   tags$a(href = link, title),
                   tags$small(date),
                   tags$br(),
                   tags$p(tags$em(tags$small(desc)))
      )
    }
    return(str)
  })

#  myHover <- reactive({
#    drawHover(input$plot_hover)
#  })

  #
  # Reactive Outputs
  #
  output$tickerPlot <- renderPlot({plotTicker(input$ticker, dataInput2())})

  output$volumePlot <- renderPlot({plotVolume(input$ticker, dataInput2())})

  output$tickerTable <- renderTable({dataQuote()}, bordered = TRUE, align = 'c', spacing = 's')

  output$historicValues <- renderTable({historicQuote()}, bordered = TRUE, align = 'c', spacing = 's')

  output$volumes <- renderTable({volumeTable(input$ticker, dataInput2())}, bordered = TRUE, align = 'c', spacing = 's')

  output$compTable <- renderTable({yahooBatch()}, bordered = TRUE, align = 'c', spacing = 'xs', striped = TRUE)

  output$newsHTML <- renderText({newsQuote()})

  output$cnnHTML <- renderText({cnnRSSQuote()})

  output$info <- renderText({
    x = round(as.numeric(input$plot_hover$x))
    y = round(as.numeric(input$plot_hover$y))
    date = as.Date(x, origin = "1970-01-01")
    paste0("Date=", format(date, "%a %b %d, %Y"), "\nClose=$", y)
  })
}


