preprocesamiento<-{
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      div(actionButton("guardar", label = "Guardar .csv", icon = icon("save"))),
      div(actionButton("normalizar", label = "Normalizar Columnas", icon = icon("database")))

    ),
    
    mainPanel(
      tableOutput("tablaN")
    )
    
  )
}