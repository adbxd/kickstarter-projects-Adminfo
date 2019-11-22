cargarData<-{
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      fileInput("file1", "Cargar Dataset .csv",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv"))
    ),
    
    mainPanel(
      tableOutput("tabla")
    )
    
  )
}