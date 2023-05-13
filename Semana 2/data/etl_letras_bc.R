
library(readxl)
library(stringr)
library(lubridate) ##para utilizar la funcion year


##Montos Colocados y Tasa de Rendimiento Promedio Ponderada 2007-2023
letras_bc_consolidado_raw <- read_excel("Semana 2/data/letras_bc_consolidado_raw.xlsx")

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

##Creando la fecha de la subasta
fechassubastaorg <- letras_bc_consolidado_raw[letras_bc_consolidado_raw$FechadeSubasta_formato==1, ]
fechassubastaorg$FechadeSubasta2 <- as.Date(fechassubastaorg$FechadeSubasta)
fechassubastaorg$ano_subasta <- substrRight(fechassubastaorg$FechadeSubasta, 4)
fechassubastaorg$ano_subasta <- substrRight(fechassubastaorg$FechadeSubasta, 4)

fechassubastaexcel <- letras_bc_consolidado_raw[letras_bc_consolidado_raw$FechadeSubasta_formato !=1, ]



letras_bc_consolidado_raw$ano_subasta <- ifelse(
  letras_bc_consolidado_raw$FechadeSubasta_formato==1, 
  substrRight(letras_bc_consolidado_raw$FechadeSubasta, 4), ##Toma los 4 ultimos numeros del string de fecha
  year(as.Date(letras_bc_consolidado_raw$FechadeSubasta, origin = "1899-12-30"))
)