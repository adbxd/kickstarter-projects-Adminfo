tratamiento<-{
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      style = "position:relative;width:inherit;",
      HTML("<a href='#WA'>Weighted Average</a><br>"),
      HTML("<a href='#MMAX'>Minimax</a><br>"),
      HTML("<a href='#MMIN'>Maximin</a><br>"),
      HTML("<a href='#LMAX'>Leximax</a><br>"),
      HTML("<a href='#LMIN'>Leximin</a><br>"),
      HTML("<a href='#SKLIN'>Skylines</a><br>"),
      HTML("<a href='#KMEANS'>Kmeans</a><br>"),
      HTML("<a href='#PCA'>PCA</a><br>"),
      HTML("<a href='#KNN'>KNN</a><br>")
    ),
    
    mainPanel(
      HTML("<h2 id='WA'>Weight Average </h2>"),
      tableOutput("tablaWA"),
      HTML("<h2 id='MMAX'>Minimax</h2>"),
      tableOutput("tablaMMAX"),
      HTML("<h2 id='MMIN'>Maximin</h2>"),
      tableOutput("tablaMMIN"),
      HTML("<h2 id='LMAX'>Leximax</h2>"),
      tableOutput("tablaLMAX"),
      HTML("<h2 id='LMIN'>Leximin</h2>"),
      tableOutput("tablaLMIN"),
      HTML("<h2 id='SKLIN'>Skylines</h2>"),
      tableOutput("tablaSKLIN"),
      HTML("<h2 id='KMEANS'>Kmeans</h2>"),
      plotOutput("plotkmeans"),
      HTML("<h2 id='PCA'>PCA</h2>"),
      plotOutput("plotPCA"),
      HTML("<h2 id='KNN'>KNN</h2>"),
      tags$h4("Datos normales"),
      plotOutput("plotComp"),
      tags$h4("Prediccion KNN"),
      fluidRow(
        column(width = 12, class = "well",
               fluidRow(
                 column(width = 6,
                        plotOutput("plotKnn1", height = 300,
                                   brush = brushOpts(
                                     id = "plotKnn1_brush",
                                     resetOnNew = TRUE
                                   )
                        )
                 ),
                 column(width = 6,
                        plotOutput("plotKnn2", height = 300)
                 )
               )
        )
        
      )
    )
    
  )
}