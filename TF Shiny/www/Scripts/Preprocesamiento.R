#Carga el dataset
#datos = read.csv("ks-projects-2018012.csv")

#Funcion Normalizar MinMax por Columna
normalizarColumna <- function(v){
  menor = min(v)
  mayor = max(v)
  arr = NULL
  for (i in 1:length(v)){
    arr[i] = (v[i]-menor)/(mayor-menor)
  }
  return(arr)
}

#Funcion para normalizar dataset segun las columnas del indice
normalizarDataset <- function(df, indices){
  df[is.na(df)] <- 0
  dfaux = df
  for (i in indices) {
    dfaux[i] = normalizarColumna(df[i])
  }
  return(dfaux)
}

