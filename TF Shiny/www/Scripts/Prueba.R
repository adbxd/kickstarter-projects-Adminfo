temp <- select_if(datosN, is.numeric)[2:7]
n = length(datosN[,1])
n1 = as.integer(n * 0.8)
datos_train <- temp[1:n1,]
datos_test <- temp[(n1+1):n,]
datos_train_target <- datos[1:n1, 10]
datos_test_target <- datos[(n1+1):n, 10]
datosKnn <- knn(train=datos_train, test= datos_test, cl=datos_train_target, k=as.integer(sqrt(n)))
datosKnn <- table(datos_test_target, datosKnn)
