library(shiny)
library(shinythemes)
source("getTickers.R")

# Load default ticker List
choicesDF = getTickers("nasdaq100")

#ui <- fluidPage(shinythemes::themeSelector(),

# Create the UI components
ui <- fluidPage(theme = shinytheme("superhero"),
  wellPanel(
    fluidRow(
      column(3,
             selectInput(inputId = "ticker", label = "Enter Ticker:", choices = as.vector(choicesDF$Symbol)),
             tags$hr(),
#             radioButtons(inputId = "radio", label = "Quick Range:",
#                          choices = list("1 mo" = 1, "3 mo" = 2, "6 mo" = 3, "1 yr" = 4, "2 yr" = 5),
#                          selected = 1, inline = TRUE),
#             tags$hr(),
             dateRangeInput(inputId = "dateRange",
                            label = "Date Range:",
                            start = Sys.Date() - 30,
                            end = Sys.Date(),
                            min = "1970-01-01",
                            max = Sys.Date(),
                            format = "yyyy-mm-dd"),
#              tags$hr(),
              tags$h4("Today's Values", align = "center"),
              tableOutput("tickerTable"),
#              tags$hr(),
              tags$h4("52 Week Values", align = "center"),
              tableOutput("historicValues")
             ),
      column(9,
             plotOutput("tickerPlot", hover = "plot_hover")
            )
    )
  ),
  wellPanel(
    fluidRow(
      column(width = 9, offset = 3,
             plotOutput("volumePlot", height = "100px")
      )
    )
  ),
  wellPanel(style = "overflow-y:scroll; max-height: 400px",
    fluidRow(
      column(width = 6,
             htmlOutput("newsHTML")
             ),
      column(width = 6,
             htmlOutput("cnnHTML")
             )
    )
  ),
  wellPanel(
    fluidRow(
      column(12,
             tags$h4("My Favorites"),
             tableOutput("compTable")
      )
    )
  )
)
