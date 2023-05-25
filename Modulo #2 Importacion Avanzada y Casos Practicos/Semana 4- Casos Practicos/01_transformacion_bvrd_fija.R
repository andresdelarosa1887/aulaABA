
##Importacion desde la WEB de un Excel
library(httr)
library(readxl)
library(tidyverse)

################## Operaciones diarias de renta fija ################## 
limpieza_operaciones_diarias <- function(archivo_operaciones_diarias, fecha_operacion){
  operaciones_diarias <- readRDS(paste0("data/", archivo_operaciones_diarias))
  colnames(operaciones_diarias) <- operaciones_diarias[4,]
  operaciones_diarias <- operaciones_diarias[5:(nrow(operaciones_diarias)-2),]
  operaciones_diarias <- operaciones_diarias %>% select(-"NA")
  operaciones_diarias$`Fecha Venc.` <- as.numeric(operaciones_diarias$`Fecha Venc.`)
  operaciones_diarias$`Fecha Venc.` <- as.Date(operaciones_diarias$`Fecha Venc.`, origin= "1899-12-30")
  operaciones_diarias$`Fecha Liq` <- as.numeric(operaciones_diarias$`Fecha Liq`)
  operaciones_diarias$`Fecha Liq` <- as.Date(operaciones_diarias$`Fecha Liq`, origin= "1899-12-30")
  operaciones_diarias$fecha_operacion <- fecha_operacion
  return(operaciones_diarias)
}


listado_operaciones_diarias = list()
for (archivo in list.files("data/", pattern = "operaciones_diarias_rf")){ 
  print(paste("Procesando:", archivo))
  ##Sacando el mes y el dia de la operacion del nombre del archivo
  dia_operacion= substr(archivo, 1,2)
  mes_operacion= substr(archivo, 4,5)
  ano_operacion= 2023
  fecha_operacion= as.Date(paste0(ano_operacion, "-", mes_operacion,"-",dia_operacion))
  tryCatch({operaciones_transformadas= limpieza_operaciones_diarias(archivo, fecha_operacion)}, error = function(e) {
    warning(paste("Error leyendo archivo:", archivo))
  })
  
  listado_operaciones_diarias[[archivo]] <- operaciones_transformadas
  }
listado_operaciones_diarias = do.call(rbind, listado_operaciones_diarias)

rownames(listado_operaciones_diarias) <- NULL
write_rds(listado_operaciones_diarias, "Modulo #2 Importacion Avanzada y Casos Practicos/Semana 4- Casos Practicos/data/operaciones_diarias_rf.rds")

##################  Renta Fija, Emisiones Corporativas Vigentes ################## 
limpieza_emisiones_corporativasvig <- function(archivo_emisiones_vigentes, fecha_operacion){
  emisiones_corporativas <- readRDS(paste0("data/", archivo_emisiones_vigentes))
  colnames(emisiones_corporativas) <- emisiones_corporativas[4,]
  emisiones_corporativas <- emisiones_corporativas[5:nrow(emisiones_corporativas),]
  emisiones_corporativas <- emisiones_corporativas %>% select(-"NA")
  emisiones_corporativas$`Fecha de Emisión` <- as.numeric(emisiones_corporativas$`Fecha de Emisión`)
  emisiones_corporativas$`Fecha de Emisión` <- as.Date(emisiones_corporativas$`Fecha de Emisión`, origin= "1899-12-30")
  emisiones_corporativas$`Fecha de Vencimiento` <- as.numeric(emisiones_corporativas$`Fecha de Vencimiento`)
  emisiones_corporativas$`Fecha de Vencimiento` <- as.Date(emisiones_corporativas$`Fecha de Vencimiento`, origin= "1899-12-30")
  emisiones_corporativas$fecha_operacion <- fecha_operacion
  return(emisiones_corporativas)
}


listado_emisiones_corp_vigentes = list()
for (archivo in list.files("data/", pattern="emisionescorp_vigentes_rf")){ 
  print(paste("Procesando:", archivo))
  ##Sacando el mes y el dia de la operacion del nombre del archivo
  dia_operacion= substr(archivo, 1,2)
  mes_operacion= substr(archivo, 4,5)
  ano_operacion= 2023
  fecha_operacion= as.Date(paste0(ano_operacion, "-", mes_operacion,"-",dia_operacion))
  tryCatch({operaciones_transformadas= limpieza_emisiones_corporativasvig(archivo, fecha_operacion)}, error = function(e) {
    warning(paste("Error leyendo archivo:", archivo))
  })
  
  listado_emisiones_corp_vigentes[[archivo]] <- operaciones_transformadas
}

listado_emisiones_corp_vigentes = do.call(rbind, listado_emisiones_corp_vigentes)
rownames(listado_emisiones_corp_vigentes) <- NULL

write_rds(listado_emisiones_corp_vigentes, "Modulo #2 Importacion Avanzada y Casos Practicos/Semana 4- Casos Practicos/data/emisiones_corp_vigentes_rf.rds")


##################  Renta Fija, Mercado Secundario los 15 Títulos más Transados en el Mes ################## 

limpieza_titulos_rf_15 <- function(archivo_top_15_titulos, fecha_operacion){
  top_15_titulos <- readRDS(paste0("data/", archivo_top_15_titulos))
  colnames(top_15_titulos) <- top_15_titulos[4,]
  top_15_titulos <- top_15_titulos[5:nrow(top_15_titulos),]
  top_15_titulos <- top_15_titulos %>% select(-"NA")
  top_15_titulos$`Fecha Emi.` <- as.numeric(top_15_titulos$`Fecha Emi.`)
  top_15_titulos$`Fecha Emi.` <- as.Date(top_15_titulos$`Fecha Emi.`, origin= "1899-12-30")
  top_15_titulos$`Fecha Ult. Oper.` <- as.numeric(top_15_titulos$`Fecha Ult. Oper.`)
  top_15_titulos$`Fecha Ult. Oper.` <- as.Date(top_15_titulos$`Fecha Ult. Oper.`, origin= "1899-12-30")
  top_15_titulos$`Fecha Venc.` <- as.numeric(top_15_titulos$`Fecha Venc.` )
  top_15_titulos$`Fecha Venc.`  <- as.Date(top_15_titulos$`Fecha Venc.` , origin= "1899-12-30")
  top_15_titulos$fecha_publicacion <- fecha_operacion
  return(top_15_titulos)
}


listado_titulos_rf_15 = list()
for (archivo in list.files("data/", pattern="topmensual_rf")){ 
  print(paste("Procesando:", archivo))
  ##Sacando el mes y el dia de la operacion del nombre del archivo
  dia_operacion= substr(archivo, 1,2)
  mes_operacion= substr(archivo, 4,5)
  ano_operacion= 2023
  fecha_operacion= as.Date(paste0(ano_operacion, "-", mes_operacion,"-",dia_operacion))
  tryCatch({operaciones_transformadas= limpieza_titulos_rf_15(archivo, fecha_operacion)}, error = function(e) {
    warning(paste("Error leyendo archivo:", archivo))
  })
  
  listado_titulos_rf_15[[archivo]] <- operaciones_transformadas
}

listado_titulos_rf_15 = do.call(rbind, listado_titulos_rf_15)

rownames(listado_titulos_rf_15) <- NULL

write_rds(listado_titulos_rf_15, "Modulo #2 Importacion Avanzada y Casos Practicos/Semana 4- Casos Practicos/data/titulos_rf_15.rds")




