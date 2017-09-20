library(shiny)
library(shinythemes)
library(Quandl)
source("getTickers.R")

# Load default ticker List
choicesDF = getTickers("nasdaq100")

#
# Just in case you want to play with all the shiny UI Themes
# Uncomment this line and then comment-out the ui <- fluidPage code below
#
#ui <- fluidPage(shinythemes::themeSelector(),

# Create the UI components
ui <- fluidPage(theme = shinytheme("cerulean"),
  navbarPage("Stocks!", id = "nav",
    tabPanel("Tickers",
      wellPanel(
        fluidRow(
          column(3,
                selectInput(inputId = "ticker", label = "Enter Ticker:", choices = as.vector(choicesDF$Symbol)),
                tags$hr(),
                radioButtons(inputId = "radio", label = "Date Range:",
                            choices = list("1 mo" = "1", "3 mo" = "2", "6 mo" = "3", "1 yr" = "4", "2 yr" = "5", "5 yr" = "6"),
                            selected = 1, inline = TRUE),
                tags$hr(),
                tags$h4("Today's Values", align = "center"),
                tableOutput("tickerTable"),
                tags$hr(),
                tags$h4("52 Week Values", align = "center"),
                tableOutput("historicValues")
          ),
          column(9, plotOutput("tickerPlot", hover = "plot_hover"))
        )
      ),
      wellPanel(style = "padding-top: 5px;",
        fluidRow(
          column(width = 3,tags$h4("Trade Volumes", align = "center"), tableOutput("volumes")),
          column(width = 9, plotOutput("volumePlot", height = "100px"))
        )
      ),
    wellPanel(style = "padding-top: 5px;",
      fluidRow(
        column(12, tags$h4("My Favorites"), tableOutput("compTable")))
      )
  ),
  tabPanel("News Feeds",
    wellPanel(
      fluidRow(
        column(width = 6, htmlOutput("newsHTML")),
        column(width = 6, htmlOutput("cnnHTML"))
        )
      )
    )
  )
)
