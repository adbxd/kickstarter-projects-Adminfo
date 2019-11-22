#Excesos de dinero
dt1 <- datos
dt1$sob <- datos$usd_pledged_real - datos$usd_goal_real
dt1 <- dt1[dt1$sob > 0, ]
dt1 <- head(dt1, 50)
plot1 <- ggplot(dt1, aes(x=name, y=sob)) + geom_bar(stat="identity", fill="steelblue")+
  theme(axis.text.x = element_text(angle = 90)) + 
  labs(title = "Grafico 1: Kickstarters que superaron el objetivo", x = "Nombre", y = "Dinero (USD)")

#Categorias
dt2 <- datos %>% group_by(main_category) %>% summarise(cyl_n = n())
plot2 <- plot_ly(dt2, labels = ~main_category, values = ~cyl_n, type = 'pie') %>%
  layout(title = 'Grafico 2: Número de Kickstarters por categoria',
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

#Skylines
dt3 <- head(datosSKlin,3) %>% select(indices)
dt3 <-rbind(rep(1,3) , rep(0,3) , dt3)
colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )

#Kmeans + WA
clusters <- kmeans(datosWA %>% select(11,15), k)
datosKmeans <- datosWA
datosKmeans$Borough <- as.factor(clusters$cluster)
plot4 <- ggplot(datosKmeans) + geom_point(aes(x = backers, y = wa, colour = as.factor(Borough))) +
  labs(title = "Grafico 4: Kmeans + Weight Average")

#PCA + Maximin
pca <- prcomp(select_if(datosMMin, is.numeric)[c(4,6,7,8)], scale = TRUE)
prop_varianza <- pca$sdev^2 / sum(pca$sdev^2)
prop_varianza_acum <- cumsum(prop_varianza)
plot5 <- ggplot(data = data.frame(prop_varianza_acum, pc = 1:4),
                  aes(x = pc, y = prop_varianza_acum, group = 1)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  labs(title = "Grafico 5: PCA + Maximax",
       x = "Componente principal",
       y = "Prop. varianza explicada acumulada")


