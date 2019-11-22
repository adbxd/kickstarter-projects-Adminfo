indices = c(11,14,15)

weightedAverage <- function(data, w, l){
  df = data
  wa = replicate(length(data[,1]), 0)
  for(i in 1:length(l)){
    wa = wa + ((w[i] * df[l[i]]) / sum(w))
  }
  
  df['wa'] = wa
  
  df = df[order(df$wa, decreasing = TRUE),]
  
  return(df)
}

pesos = c(2,3,1)
datosWA = weightedAverage(datosN, pesos, indices)

minimax <- function(data, l){
  df = data
  df['mmax'] = apply(df[,l], 1, max)
  
  df = df[order(df$mmax, decreasing = TRUE),]
  
  return(df)
}

datosMMax = minimax(datosN, indices)


maximin <- function(data, l){
  df = data
  df['mmin'] = apply(df[,l], 1, min)
  
  df = df[order(df$mmin, decreasing = TRUE),]
  
  return(df)
}

datosMMin = maximin(datosN, indices)

leximax <- function(data, l){
  df = data
  mv = apply(df[,l], 1, function(x) sort(x, decreasing = TRUE))
  
  for(i in 1:(length(l))){
    print(i)
    df[[paste("C",i, sep="")]] = mv[i,]
  }
  
  df = df[do.call("order", c(df[,(length(data) + 1):length(df)], list(decreasing = TRUE))),]
  return(df)
}

datosLMax = leximax(datosN, indices)

leximin <- function(data, l){
  df = data
  mv = apply(df[,l], 1, function(x) sort(x, decreasing = FALSE))
  for(i in 1:(length(l))){
    df[[paste("C",i, sep="")]] = mv[i,]
  }
  
  df = df[do.call("order", c(df[,(length(data) + 1):length(df)], list(decreasing = TRUE))),]
  return(df)
}

datosLMin = leximin(datosN, indices)

paretoDomina = function(a, b){
  return(any(a > b) && all(a >= b))
}
skylines = function(data, l){
  df = data
  
  i = 1
  j = 1
  
  repeat{
    repeat{
      if(paretoDomina(df[i,l], df[j,l])){
        df = df[-j,]
        j = j - 1
      }
      
      if(paretoDomina(df[j,l], df[i,l])){
        df = df[-i,]
        j = 0
      }
      j = j + 1
      
      if(j == (nrow(df) + 1))
        break
    }
    j = 1
    i = i + 1
    
    if(i == (nrow(df) + 1))
      break
  }
  
  return(df)
}

datosSKlin = skylines(datosN, indices)

k <- as.integer(sqrt(length(datosN[,1])))
#Kmeans
clusters <- kmeans(datosN %>% select(11,14), k)
datosKmeans <- datosN
datosKmeans$Borough <- as.factor(clusters$cluster)
plotKmeans <- ggplot(datosKmeans) + geom_point(aes(x = backers, y = usd_pledged_real, colour = as.factor(Borough)))

datos[is.na(datos)] <- 0
#PCA
pca <- prcomp(select_if(datos, is.numeric)[2:7], scale = TRUE)
prop_varianza <- pca$sdev^2 / sum(pca$sdev^2)
prop_varianza_acum <- cumsum(prop_varianza)
plotPCA <- ggplot(data = data.frame(prop_varianza_acum, pc = 1:6),
       aes(x = pc, y = prop_varianza_acum, group = 1)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  labs(x = "Componente principal",
       y = "Prop. varianza explicada acumulada")

#KNN
temp <- select_if(datosN, is.numeric)[2:7]
n = length(datosN[,1])
n1 = as.integer(n * 0.8)
datos_train <- temp[1:n1,]
datos_test <- temp[(n1+1):n,]
datos_train_target <- datosN[1:n1, 10]
datos_test_target <- datosN[(n1+1):n, 10]
datos_test$predict <- knn(train=datos_train, test= datos_test, cl=datos_train_target, k=as.integer(sqrt(n)))
plotComp <- ggplot(datosN[(n1+1):n, ]) + geom_point(aes(x = backers, y = usd_pledged_real, colour = as.factor(state)))
plotKNN <- ggplot(datos_test) + geom_point(aes(x = backers, y = usd_pledged_real, colour = as.factor(predict)))
