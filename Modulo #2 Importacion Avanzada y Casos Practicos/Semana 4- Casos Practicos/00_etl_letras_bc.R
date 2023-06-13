

library(readxl)
library(stringr)

##Montos Colocados y Tasa de Rendimiento Promedio Ponderada 2007-2023
letras_bc_consolidado_raw <- suppressMessages(suppressWarnings(read_excel("data/letras_bc_consolidado_raw.xlsx")))


letras_bc_consolidado_raw <- letras_bc_consolidado_raw[5:nrow(letras_bc_consolidado_raw), 2:7]
colnames(letras_bc_consolidado_raw) <- c("FechaSubasta", "FechaLiquidacion", "MontoSubastado",
                                         "MontoDemandado", "MontoAdjudicado ", "RendimientoPPA")

letras_bc_consolidado_raw <- na.omit(letras_bc_consolidado_raw)


##TRansformacion de las fecha de la subasta
letras_bc_consolidado_raw$FechaSubasta_formato <- ifelse(
  str_detect(string = letras_bc_consolidado_raw$FechaSubasta, pattern = "/"), 1, 0)

fechasubastaformatoorg <- letras_bc_consolidado_raw[letras_bc_consolidado_raw$FechaSubasta_formato==1, ]
fechasubastaformatoorg$dia_subasta <- substr(fechasubastaformatoorg$FechaSubasta, 1,2)
fechasubastaformatoorg$mes_subasta <- substr(fechasubastaformatoorg$FechaSubasta, 4,5)
fechasubastaformatoorg$ano_subasta <- substr(fechasubastaformatoorg$FechaSubasta, 7,10)
fechasubastaformatoorg$FechaSubasta <- as.Date(
  paste0(
    fechasubastaformatoorg$ano_subasta, "-",
    fechasubastaformatoorg$mes_subasta, "-",
    fechasubastaformatoorg$dia_subasta 
  )
)

fechasubastaformatoorg <- fechasubastaformatoorg[,c( "FechaSubasta","FechaLiquidacion","MontoSubastado","MontoDemandado",      
                                                     "MontoAdjudicado ","RendimientoPPA","FechaSubasta_formato") ]

fechasubastaformatoexcel <- letras_bc_consolidado_raw[!letras_bc_consolidado_raw$FechaSubasta_formato==1, ]

fechasubastaformatoexcel$FechaSubasta <- as.Date(
  as.numeric(fechasubastaformatoexcel$FechaSubasta), origin= "1899-12-30"
)

intersect(colnames(fechasubastaformatoorg), colnames(fechasubastaformatoexcel))

fechasubastalista <- rbind(fechasubastaformatoorg,fechasubastaformatoexcel )


##Fecha liquidacion 
fechasubastalista$FechaLiquidacion_formato <- ifelse(
  str_detect(string = fechasubastalista$FechaLiquidacion, pattern = "/"), 1, 0)



fechaliquidacionformatoorg <- fechasubastalista[fechasubastalista$FechaLiquidacion_formato==1, ]

fechaliquidacionformatoorg$dia_liquidacion <- substr(fechaliquidacionformatoorg$FechaLiquidacion, 1,2)
fechaliquidacionformatoorg$mes_liquidacion <- substr(fechaliquidacionformatoorg$FechaLiquidacion, 4,5)
fechaliquidacionformatoorg$ano_liquidacion <- substr(fechaliquidacionformatoorg$FechaLiquidacion, 7,10)

fechaliquidacionformatoorg[4,10] <- "2023"

fechaliquidacionformatoorg$FechaLiquidacion <- as.Date(
  paste0(
    fechaliquidacionformatoorg$ano_liquidacion, "-",
    fechaliquidacionformatoorg$mes_liquidacion, "-",
    fechaliquidacionformatoorg$dia_liquidacion 
  )
)




fechaliquidacionformatoorg <- fechaliquidacionformatoorg[,
                                                         c("FechaSubasta","FechaLiquidacion","MontoSubastado","MontoDemandado",          
                                                           "MontoAdjudicado ","RendimientoPPA","FechaSubasta_formato","FechaLiquidacion_formato")
]




fechaliquidacionformatoexcel <- fechasubastalista[!fechasubastalista$FechaLiquidacion_formato==1, ]

fechaliquidacionformatoexcel$FechaLiquidacion <- as.Date(
  as.numeric(fechaliquidacionformatoexcel$FechaLiquidacion), origin= "1899-12-30"
)


setdiff(colnames(fechaliquidacionformatoorg), colnames(fechaliquidacionformatoexcel))



letras_fechas_listas <- rbind(fechaliquidacionformatoexcel, fechaliquidacionformatoorg)

colnames(letras_fechas_listas)

letras_fechas_listas <- letras_fechas_listas[ ,
  c("FechaSubasta","FechaLiquidacion","MontoSubastado","MontoDemandado",          
    "MontoAdjudicado ","RendimientoPPA")
  ]


letras_fechas_listas[c("MontoSubastado","MontoDemandado",          
                          "MontoAdjudicado ","RendimientoPPA")] <- sapply(
                            letras_fechas_listas[c("MontoSubastado","MontoDemandado",          
                            "MontoAdjudicado ","RendimientoPPA")], as.numeric)









