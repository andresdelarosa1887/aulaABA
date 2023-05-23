

##Importacion desde la WEB de un Excel
library(httr)
library(readxl)
library(tidyverse)


##Creacion de fechas para el loop
inicio_fecha = as.Date("2023-01-01")
final_fecha = Sys.Date()

secuencia_fechas <- seq(inicio_fecha,final_fecha,by = 1)
secuencia_fechas <- secuencia_fechas[!weekdays(secuencia_fechas) %in% c('Saturday','Sunday')]
secuencia_fechas
##Feriados RD 2023
feriadosRD2023 <- c("2023-01-01", #Ano nuevo
                    "2023-01-02", #Dia de Fiesta random
                    "2023-01-09", #Dia de los reyes
                    "2023-01-21", #Dia de la altagracia
                    "2023-01-30", #Dia de duarte
                    "2023-02-27", #Dia de la independencia
                    "2023-04-07", # Viernes Santo
                    "2023-05-01", #Dia del trabajo
                    "2023-06-08", #Corpus Christi
                    "2023-08-16", #Dia de la Restauracion
                    "2023-09-24", # Dia de las mercedes
                    "2023-11-06", #Dia de la constitucion
                    "2023-12-25") ##Navidad

secuencia_fechas <- secuencia_fechas[!secuencia_fechas %in% as.Date(feriadosRD2023)]

data_fechas <- as.data.frame(secuencia_fechas)
data_fechas$mes <- ifelse(nchar(month(data_fechas$secuencia_fechas)) != 2,
                          paste0("0", as.character(month(data_fechas$secuencia_fechas))),
                          month(data_fechas$secuencia_fechas))

data_fechas$dia <- ifelse(nchar(day(data_fechas$secuencia_fechas)) != 2,
                          paste0("0", as.character(day(data_fechas$secuencia_fechas))),
                          day(data_fechas$secuencia_fechas))




for (mes in levels(as.factor((data_fechas$mes)))) {
  print(mes)
  dias <- data_fechas[data_fechas$mes== mes,]$dia
  for (dia in dias){ 
    consolidadoBVRDLink <- paste0("https://bvrd.com.do/boletines/boletin-bvrd-consolidado-excel-",dia,"-",mes,"-","23/")
    GET(consolidadoBVRDLink, write_disk(tf <- tempfile(fileext = ".xlsx")), add_headers(`Connection` = "keep-alive", `User-Agent` = UA))
  
    ##Instrumentos de Renta Variable
    ##Renta Variable, Emisiones Corporativas Vigentes
    emisionescorp_vigentes_rv <- read_excel(tf, sheet =  "BB_RVEmisionesCorpV")
    write_rds(emisionescorp_vigentes_rv, paste0("data/", dia,"-",mes,"-","23-","emisionescorp_vigentes_rv.rds"))
    
    ##Renta Variable, Mercado Secundario Operaciones del día
    operaciones_diarias_rv <- read_excel(tf, sheet =  "BB_RVMSOperDia")
    write_rds(operaciones_diarias_rv, paste0("data/", dia,"-",mes,"-","23-","operaciones_diarias_rv.rds"))
    
    ##Renta Variable, Mercado Secundario los 15 Títulos más Transados en el Mes
    topmensual_rv <- read_excel(tf, sheet =  "BB_RVMSTopTitTransMes")
    write_rds(topmensual_rv, paste0("data/", dia,"-",mes,"-","23-","topmensual_rv.rds"))
    
    
    ##Instrumentos de renta fija
    ##Renta Fija, Emisiones Corporativas Vigentes
    emisionescorp_vigentes_rf <- read_excel(tf, sheet =  "BB_RFEmisionesCorpV")
    write_rds(emisionescorp_vigentes_rf, paste0("data/", dia,"-",mes,"-","23-","emisionescorp_vigentes_rf.rds"))
    
    ##Renta Fija, Mercado Secundario Operaciones del día
    operaciones_diarias_rf <- read_excel(tf, sheet =  "BB_RFMSOperDia")
    write_rds(operaciones_diarias_rf, paste0("data/", dia,"-",mes,"-","23-","operaciones_diarias_rf.rds"))
    
    ##Renta Fija, Mercado Secundario los 15 Títulos más Transados en el Mes
    topmensual_rf <- read_excel(tf, sheet =  "BB_RFMSTopTitTransMes")
    write_rds(topmensual_rf, paste0("data/", dia,"-",mes,"-","23-","topmensual_rf.rds"))
    
    print(paste0(mes, "-", dia))
    }
  }
  















