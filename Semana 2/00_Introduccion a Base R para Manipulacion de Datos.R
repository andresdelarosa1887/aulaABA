


##Importacion
letras_bc <- read.table("Semana 2/data/letras_bc_consolidado_clean.csv")

##Slicing 
letras_bc[1:3,]
letras_monto_subastado_500 <- letras_bc[letras_bc$MontoSubastado==5000, ]

#dataframe[fila_inicio:fila_final, columna_inicia:columna_final]


#Filtering
letras_monto_subastado_500 <- subset(letras_bc, MontoSubastado==5000)

##Creacion de columnas
letras_monto_subastado_500$RendimientoPPA2 <- 1-(letras_monto_subastado_500$RendimientoPPA *100)

colnames(letras_bc) <- c("1", "2", "3", "4", "5",
                         "6")

names(letras_bc)[1:3] <- c("fecha", "fecha2", "monto")
names(letras_bc) <- letras_bc




