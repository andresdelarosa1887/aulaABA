
##Importacion
letras_bc <- read.table("Semana 2/data/letras_bc_consolidado_clean.csv")

##Slicing 
letras_bc[1:3,]
letras_monto_subastado_500 <- letras_bc[letras_bc$MontoSubastado==5000, ]
head(letras_monto_subastado_500)
#dataframe[fila_inicio:fila_final, columna_inicia:columna_final]


#Filtering
letras_monto_subastado_500 <- subset(letras_bc, MontoSubastado==5000)

##Creacion de columnas
letras_monto_subastado_500$RendimientoPPA2 <- 1-(letras_monto_subastado_500$RendimientoPPA *100)

##Cambio nombre de columnas
cambio_nombres <- letras_bc ##Asigno a un nuevo dataframe las letras del bc
head(cambio_nombres) #Utilizo head para ver los primero 5 registros del nuuevo dataframe. 
colnames(cambio_nombres) <- c("1", "2", "3", "4", "5", "6") #Le cambio el nombre a todas las columnas
names(cambio_nombres)[1:3] <- c("fecha", "fecha2", "monto") #Le cambio el nombre a las primeras 3 columnas
head(cambio_nombres) #Utilizo head para ver los cambios realizados


##Setdiff y Intersect

letras_bc2 <- letras_bc
colnames(letras_bc2)[1:2] <- c("columna1", "columna2")
colnames(letras_bc2)

setdiff(colnames(letras_bc), colnames(letras_bc2))

intersect(
  colnames(letras_bc), colnames(letras_bc2)
)


##Concatenacion - rbind()
nuevas_letras <- data.frame( 
  "FechaSubasta"= c("2023-06-01","2023-06-12", "2023-06-14"), 
  "FechaLiquidacion"= c("2023-06-01","2023-06-12", "2023-06-14"), 
  "MontoSubastado"= c(7400, 8000, 2400), 
  "MontoDemandado"= c(2000, 1500, 2222), 
  "MontoAdjudicado"= c(1800, 1499, 2200), 
  "RendimientoPPA"= c(0.05, 0.0555, 0.087)
)

setdiff(colnames(letras_bc), colnames(nuevas_letras))
intersect(colnames(letras_bc), colnames(nuevas_letras))
colnames(nuevas_letras)[1]  <- "FechadeSubasta"

nuevas_letras_completo <- rbind(letras_bc, nuevas_letras)


## cbind()
nueva_info_letras <- data.frame(
  rankeo= seq(1, nrow(letras_bc), by=1)
)

View(cbind(letras_bc, nueva_info_letras))


min(letras_bc$FechadeSubasta)
max(letras_bc$FechadeSubasta)

length(seq(as.Date(min(letras_bc$FechadeSubasta)),as.Date(max(letras_bc$FechadeSubasta)), by="day" ))

subasta_desierta <- data.frame(
  "FechadeSubasta" = seq(as.Date(min(letras_bc$FechadeSubasta)),as.Date(max(letras_bc$FechadeSubasta)), by="day" ), 
  "DeclaradaDesierta"= sample(c(1,0),length(seq(as.Date(min(letras_bc$FechadeSubasta)),as.Date(max(letras_bc$FechadeSubasta)),
                                                by="day" )), TRUE)
)


typeof(letras_bc$FechadeSubasta)
typeof(subasta_desierta$FechadeSubasta)

letras_bc$FechadeSubasta <- as.Date(letras_bc$FechadeSubasta)

View(merge(letras_bc, subasta_desierta, all.x=TRUE, all.y= FALSE))



