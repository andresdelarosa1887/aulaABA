
library(readxl)
library(stringr)
library(lubridate) ##para utilizar la funcion year


##Montos Colocados y Tasa de Rendimiento Promedio Ponderada 2007-2023
letras_bc_consolidado_raw <- read_excel("data/letras_bc_consolidado_raw.xlsx")

letras_bc_consolidado_raw <- letras_bc_consolidado_raw[5:nrow(letras_bc_consolidado_raw), 2:7]
colnames(letras_bc_consolidado_raw) <- c("FechadeSubasta", 
                                         "FechaLiquidacion",
                                         "MontoSubastado", 
                                         "MontoDemandado",
                                         "MontoAdjudicado", 
                                         "RendimientoPPA")

letras_bc_consolidado_raw <- na.omit(letras_bc_consolidado_raw)

##Creamos un indicador para las fechas que tienen un formato diferente al default de excel
letras_bc_consolidado_raw$FechadeSubasta_formato <-  ifelse(str_detect(letras_bc_consolidado_raw$FechadeSubasta, "/"), 1, 0 )
letras_bc_consolidado_raw$FechaLiquidacion_formato <-  ifelse(str_detect(letras_bc_consolidado_raw$FechaLiquidacion, "/"), 1, 0 )


substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

##Limpiando la fecha de la subasta
fechassubastaorg <- letras_bc_consolidado_raw[letras_bc_consolidado_raw$FechadeSubasta_formato==1, ]
fechassubastaorg$ano_subasta <- substrRight(fechassubastaorg$FechadeSubasta, 4)
fechassubastaorg$mes_subasta <- substr(fechassubastaorg$FechadeSubasta,4,5)
fechassubastaorg$dia_subasta <- substr(fechassubastaorg$FechadeSubasta,4,5)
fechassubastaorg$FechadeSubasta <- as.Date(paste0(fechassubastaorg$ano_subasta,"-",
                                           fechassubastaorg$mes_subasta, "-",
                                           fechassubastaorg$dia_subasta) )

fechassubastaexcel <- letras_bc_consolidado_raw[letras_bc_consolidado_raw$FechadeSubasta_formato !=1, ]
fechassubastaexcel$FechadeSubasta <- as.Date(as.numeric(fechassubastaexcel$FechadeSubasta),
                                             origin = "1899-12-30")

fechassubastaorg <- fechassubastaorg[, c("FechadeSubasta",   "FechaLiquidacion", "MontoSubastado",
                                                "MontoDemandado", "MontoAdjudicado",
                                                "RendimientoPPA", "FechaLiquidacion_formato")]

fechassubastaexcel <- fechassubastaexcel[, c("FechadeSubasta",   "FechaLiquidacion", "MontoSubastado",
                                             "MontoDemandado", "MontoAdjudicado",
                                             "RendimientoPPA", "FechaLiquidacion_formato")]

fechassubastalista <- rbind(fechassubastaorg, fechassubastaexcel)


##Limpiando le fecha de liquidacion

fechaliquidacionorg <- fechassubastalista[fechassubastalista$FechaLiquidacion_formato==1, ]
fechaliquidacionorg$ano_liquidacion <- substrRight(fechaliquidacionorg$FechaLiquidacion, 4)
fechaliquidacionorg$mes_liquidacion <- substr(fechaliquidacionorg$FechaLiquidacion,4,5)
fechaliquidacionorg$dia_liquidacion <- substr(fechaliquidacionorg$FechaLiquidacion,4,5)
##Error que mejor hacer el cambio manual
fechaliquidacionorg[4,8] <- "2023"

fechaliquidacionorg$FechaLiquidacion <- as.Date(paste0(fechaliquidacionorg$ano_liquidacion,"-",
                                                     fechaliquidacionorg$mes_liquidacion, "-",
                                                     fechaliquidacionorg$dia_liquidacion) )

fechasliquidacionexcel <- fechassubastalista[fechassubastalista$FechaLiquidacion_formato !=1, ]
fechasliquidacionexcel$FechaLiquidacion <- as.Date(as.numeric(fechasliquidacionexcel$FechaLiquidacion),
                                             origin = "1899-12-30")

fechaliquidacionorg <- fechaliquidacionorg[, c("FechadeSubasta",   "FechaLiquidacion", "MontoSubastado",
                                         "MontoDemandado", "MontoAdjudicado",
                                         "RendimientoPPA")]

fechasliquidacionexcel <- fechasliquidacionexcel[, c("FechadeSubasta",   "FechaLiquidacion", "MontoSubastado",
                                             "MontoDemandado", "MontoAdjudicado",
                                             "RendimientoPPA")]

fechasliquidacionlista <- rbind(fechaliquidacionorg, fechasliquidacionexcel)


##HAciendo las columnas numericas
letras_bc_consolidado <- fechasliquidacionlista
letras_bc_consolidado[, c("MontoSubastado", "MontoDemandado", "MontoAdjudicado", "RendimientoPPA")] <- sapply(letras_bc_consolidado[, c( "MontoSubastado",
                                 "MontoDemandado", "MontoAdjudicado", "RendimientoPPA")], as.numeric )

write.table(letras_bc_consolidado, "Semana 2/data/letras_bc_consolidado_clean.csv")
