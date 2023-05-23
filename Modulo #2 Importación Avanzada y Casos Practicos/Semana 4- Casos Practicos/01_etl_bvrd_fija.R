


##Importacion desde la WEB de un Excel
library(httr)
library(readxl)

consolidadoBVRDLink  <-  "https://bvrd.com.do/boletines/boletin-bvrd-consolidado-excel-22-05-23/"
GET(consolidadoBVRDLink, write_disk(tf <- tempfile(fileext = ".xlsx")))
consolidadoBVRD <- read_excel(tf)


##Renta Fija, Emisiones Corporativas Vigentes
"BB_RFEmisionesCorpV"

##Renta Fija, Mercado Secundario Operaciones del día
"BB_RFMSOperDia"

##Renta Fija, Mercado Secundario los 15 Títulos más Transados en el Mes
"BB_RFMSTopTitTransMes"

