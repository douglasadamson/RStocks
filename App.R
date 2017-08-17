#
# Build the UI and Server components
#
source(ui.R)
source(server.R)

#
# Build a Shiny App
#
app <- shinyApp(ui = ui, server = server)

#
# Run it
#
runApp(app)
