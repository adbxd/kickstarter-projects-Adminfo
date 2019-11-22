#Verifica y carga las librerias
requiredPackages = c('ggplot2', 'fmsb', 'colormap', 'dplyr', 'shiny', 'class', 'plotly', 'scales')
for(p in requiredPackages){
  if(!require(p,character.only = TRUE)) install.packages(p)
  library(p,character.only = TRUE)
}

source("www/Tabs/TabPreprocesamiento.R")
source("www/Tabs/TabCarga.R")
source("www/Tabs/TabTratamiento.R")
source("www/Tabs/TabGraficos.R")
source("www/Scripts/Preprocesamiento.R")


ui <- fluidPage(
  tabsetPanel(
    tabPanel("Cargar Dataset",cargarData),
    tabPanel("Pre-Procesamiento",preprocesamiento),
    tabPanel("Tratamiento",tratamiento),
    tabPanel("Graficos",graficos)
  )
)

server <- function(input, output) {
  
  observeEvent(input$normalizar, {
    
    indices <<- colnames(select_if(datos, is.numeric))[2:length(colnames(select_if(datos, is.numeric)))]
    
    datosN <<- normalizarDataset(datos %>% filter(pledged > 0), indices)
    
    source("www/Scripts/Tratamiento.R")
    source("www/Scripts/Graficos.R")
  })
  
  observeEvent(input$guardar, {
    if(exists("datosN")){
      write.csv(vals$data, "ks-projects-201801-norm.csv")
      showNotification("Se ha guardado el Archivo")
    }
    else
      showNotification("Error")
  })
  
  
  output$tabla <- renderTable({
    inFile = input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    datos <<- read.csv(inFile$datapath)
    datos
  })
   
  output$tablaN <- renderTable({
    if (!exists("datosN"))
      return(NULL)
    datosN
  })
  
  output$tablaWA <- renderTable({
    if (!exists("datosWA"))
      return(NULL)
    head(datosWA, n = 5)
  })
  
  output$tablaMMAX <- renderTable({
    if (!exists("datosMMax"))
      return(NULL)
    head(datosMMax, n = 5)
  })
  output$tablaMMIN <- renderTable({
    if (!exists("datosMMin"))
      return(NULL)
    head(datosMMin, n = 5)
  })
  output$tablaLMAX <- renderTable({
    if (!exists("datosLMax"))
      return(NULL)
    head(datosLMax, n = 5)
  })
  output$tablaLMIN <- renderTable({
    if (!exists("datosLMin"))
      return(NULL)
    head(datosLMin, n = 5)
  })
  output$tablaSKLIN <- renderTable({
    if (!exists("datosSKlin"))
      return(NULL)
    head(datosSKlin, n = 5)
  })

  output$plotkmeans <- renderPlot({
    if (!exists("plotKmeans"))
      return(NULL)
    plotKmeans
  })
  
  output$plotPCA <- renderPlot({
    if (!exists("plotPCA"))
      return(NULL)
    plotPCA
  })
  
  ranges2 <- reactiveValues(x = NULL, y = NULL)
  
  output$plotComp <- renderPlot({
    plotComp
  })
  
  output$plotKnn1 <- renderPlot({
    plotKNN
  })
  
  output$plotKnn2 <- renderPlot({
    plotKNN +
      coord_cartesian(xlim = ranges2$x, ylim = ranges2$y, expand = FALSE)
  })
  
  observe({
    brush <- input$plotKnn1_brush
    if (!is.null(brush)) {
      ranges2$x <- c(brush$xmin, brush$xmax)
      ranges2$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges2$x <- NULL
      ranges2$y <- NULL
    }
  })
  
  output$plot1 <- renderPlotly({
    plot1
  })
  
  output$plot2 <- renderPlotly({
    plot2
  })
  
  output$plot3 <- renderPlot({
    radarchart( dt3  , axistype=1 , 
                #custom polygon
                pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1,
                #custom the grid
                cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,20,5), cglwd=0.8,
                #custom labels
                vlcex=0.8 
    )
  })
  
  output$plot4 <- renderPlotly({
    plot4
  })
  
  output$plot5 <- renderPlotly({
    plot5
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

