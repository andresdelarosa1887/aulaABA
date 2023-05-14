
##Importacion
letras_bc <- read.table("Semana 2/data/letras_bc_consolidado_clean.csv")
colnames(letras_bc)
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


##Diferencia entre vectores y concatenacion vertical y horizontal
nuevas_letras <- data.frame( 
  "FechaSubasta"= c("2023-06-01","2023-06-12", "2023-06-14"), 
  "FechaLiquidacion"= c("2023-06-01","2023-06-12", "2023-06-14"), 
  "MontoSubastado"= c(7400, 8000, 2400), 
  "MontoDemandado"= c(2000, 1500, 2222), 
  "MontoAdjudicado"= c(1800, 1499, 2200), 
  "RendimientoPPA"= c(0.05, 0.0555, 0.087)
)
##No puedo realizar la concatenacion porque el nombre de las columnas no es igual
rbind(letras_bc, nuevas_letras)

##Columnas que no hacen match
setdiff(colnames(letras_bc), colnames(nuevas_letras))
##Columnas que si hacen match
intersect(colnames(letras_bc), colnames(nuevas_letras))

##Dado este analisis modificoo el nombre de la columna para poder realizar la concatenacion
colnames(nuevas_letras)[1] <- "FechadeSubasta"
letras_bc_actualizado <- rbind(letras_bc, nuevas_letras) ##Procedo a realizar la concatenacion sin temas

##Verifico que realmente se realizo la concatenacion
cantidad_registros_nuevos <- nrow(letras_bc_actualizado) - nrow(letras_bc)
cantidad_registros_nuevos
tail(letras_bc_actualizado) ##Veo mi dataset


##Uniones
##Creamos un dataframe para unir con las letras del BC 

##Creamos una columna de FechaSubasta utilizando una secuencia de fechas de la fecha minima de subasta de nuestro dataframe original hasta la fecha maxima por dia
##Creamos una segunda columna que aleatoriamente nos dira 1 si fue declarado desierto y 0 si no fue declarada desierta
subasta_desierta <- data.frame(
  "FechadeSubasta" = seq(as.Date(min(letras_bc$FechadeSubasta)),as.Date(max(letras_bc$FechadeSubasta)), by="day" ), 
  "DeclaradaDesiesta"= sample(c(1,0),length(seq(as.Date(min(letras_bc$FechadeSubasta)),as.Date(max(letras_bc$FechadeSubasta)), by="day" )), TRUE)
)

##Este nuevo dataframe lo queremos unir con las letras del BC. Esta union lo hacemos por la FechadeSubasta
letras_bc$FechadeSubasta <- as.Date(letras_bc$FechadeSubasta)
merged_letras_bc <- merge(letras_bc, subasta_desierta, all.x= TRUE, all.y=FALSE)
head(merged_letras_bc)




