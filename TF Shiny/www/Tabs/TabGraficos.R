graficos<-{
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
    ),
    
    mainPanel(
      # Sidebar with a slider input for number of bins 
      plotlyOutput("plot1", height = 800),
      plotlyOutput("plot2"),
      tags$h4("Grafico 3: Skylines"),
      plotOutput("plot3", height = 800),
      plotlyOutput("plot4", height = 400),
      plotlyOutput("plot5")
    )
    
  )

}