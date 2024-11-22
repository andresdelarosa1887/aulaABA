
##Importacion desde la WEB de un Excel
library(httr)
library(readxl)
library(tidyverse)
library(lubridate)



## Origen - https://boletines.bvrd.com.do/

##Creacion de fechas para el loop
inicio_fecha = as.Date("2023-01-01")
final_fecha = as.Date("2023-12-31")

secuencia_fechas <- seq(inicio_fecha,final_fecha,by = 1)
secuencia_fechas <- secuencia_fechas[!weekdays(secuencia_fechas) %in% c('Saturday','Sunday')]

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


meses <- function(month) {
  case_when(
    month == "01" ~ "Enero",
    month == "02" ~ "Febrero",
    month == "03" ~ "Marzo",
    month == "04" ~ "Abril",
    month == "05" ~ "Mayo",
    month == "06" ~ "Junio",
    month == "07" ~ "Julio",
    month == "08" ~ "Agosto",
    month == "09" ~ "Septiembre",
    month == "10" ~ "Octubre",
    month == "11" ~ "Noviembre",
    month == "12" ~ "Diciembre",
    TRUE ~ NA_character_
  )
}

data_fechas <- data_fechas %>% filter(mes!= "01")
data_fechas$mes_nombre <- sapply(data_fechas$mes, meses)
data_fechas$mes_numerico <- as.numeric(data_fechas$mes)

"https://boletin.bvrd.com.do/BOLETINES+Y+PRECIOS+2023/Boletin+Consolidado/3.+Marzo/10-03-2023-Boletin+BVRD+Consolidado+excel.xlsx"



UA <- "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:93.0) Gecko/20100101 Firefox/93.0"

for (mes in levels(as.factor((data_fechas$mes)))) {
  dias <- data_fechas[data_fechas$mes== mes,]$dia
  mes_numerico <- data_fechas[data_fechas$mes== mes,]$mes_numerico
  nombre_mes <- data_fechas[data_fechas$mes== mes,]$mes_nombre
  
  for (dia in dias){ 
    # consolidadoBVRDLink <- paste0("https://bvrd.com.do/boletines/boletin-bvrd-consolidado-excel-",dia,"-",mes,"-","23/")
    consolidadoBVRDLink <- paste0("https://boletin.bvrd.com.do/BOLETINES+Y+PRECIOS+2023/Boletin+Consolidado/",mes_numerico,".+",nombre_mes,"/",dia,"-",mes,"-","2023","-", "Boletin+BVRD+Consolidado+excel.xlsx")
    print(unique(consolidadoBVRDLink))
    GET(unique(consolidadoBVRDLink), write_disk(tf <- tempfile(fileext = ".xlsx")), add_headers(`Connection` = "keep-alive", `User-Agent` = UA))
    ##Instrumentos de Renta Variable
    
    ##Renta Variable, Emisiones Corporativas Vigentes
    emisionescorp_vigentes_rv <- read_excel(tf, sheet =  "BB_RVEmisionesCorpV")
    write_rds(emisionescorp_vigentes_rv, paste0("data2/", dia,"-",mes,"-","23-","emisionescorp_vigentes_rv.rds"))
    
    ##Renta Variable, Mercado Secundario Operaciones del día
    operaciones_diarias_rv <- read_excel(tf, sheet =  "BB_RVMSOperDia")
    write_rds(operaciones_diarias_rv, paste0("data2/", dia,"-",mes,"-","23-","operaciones_diarias_rv.rds"))
    
    ##Renta Variable, Mercado Secundario los 15 Títulos más Transados en el Mes
    topmensual_rv <- read_excel(tf, sheet =  "BB_RVMSTopTitTransMes")
    write_rds(topmensual_rv, paste0("data2/", dia,"-",mes,"-","23-","topmensual_rv.rds"))
    
    ##Instrumentos de renta fija
    ##Renta Fija, Emisiones Corporativas Vigentes
    emisionescorp_vigentes_rf <- read_excel(tf, sheet =  "BB_RFEmisionesCorpV")
    write_rds(emisionescorp_vigentes_rf, paste0("data/", dia,"-",mes,"-","23-","emisionescorp_vigentes_rf.rds"))
    ##Renta Fija, Mercado Secundario Operaciones del día
    operaciones_diarias_rf <- read_excel(tf, sheet =  "BB_RFMSOperDia")
    write_rds(operaciones_diarias_rf, paste0("data2/", dia,"-",mes,"-","23-","operaciones_diarias_rf.rds"))
    ##Renta Fija, Mercado Secundario los 15 Títulos más Transados en el Mes
    topmensual_rf <- read_excel(tf, sheet =  "BB_RFMSTopTitTransMes")
    write_rds(topmensual_rf, paste0("data2/", dia,"-",mes,"-","23-","topmensual_rf.rds"))
    print(paste0(mes, "-", dia))
    }
  }
  




