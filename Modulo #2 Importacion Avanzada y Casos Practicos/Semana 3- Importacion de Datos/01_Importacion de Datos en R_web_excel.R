

##Importacion desde la WEB de un Excel
library(httr)
library(readxl)
library(tidyverse)
# "https://cdn.bancentral.gov.do/documents/estadisticas/mercado-cambiario/documents/TASAS_CONVERTIBLES_OTRAS_MONEDAS.xlsx?v=1713308248644"


linkBC<-  "https://cdn.bancentral.gov.do/documents/estadisticas/mercado-cambiario/documents/TASAS_CONVERTIBLES_OTRAS_MONEDAS.xlsx?v=1684715614947"
GET(linkBC, write_disk(tf <- tempfile(fileext = ".xlsx")))
tipodecambio <- read_excel(tf)


# [ rows, columns ]
cantidad_filas <- nrow(tipodecambio)-2

colnames(tipodecambio) <- tipodecambio[2,]
tipodecambio <- tipodecambio[3:nrow(tipodecambio),  ]
tipodecambio <- tipodecambio[1:cantidad_filas,  ]

tipodecambio <- tipodecambio %>% 
  mutate_at(vars(colnames(tipodecambio)[4:ncol(tipodecambio)]), 
            as.numeric)

tipodecambio$Mes <- tolower(tipodecambio$Mes)

meses_numericos <- c("ene" = 1, "feb" = 2, "mar" = 3, "abr" = 4, "may" = 5, "jun" = 6,
                     "jul" = 7, "ago" = 8, "sep" = 9, "oct" = 10, "nov" = 11, "dic" = 12)

tipodecambio$Mes %in% names(meses_numericos)

tipodecambio$mes_numerico <- ifelse(
  tipodecambio$Mes %in% names(meses_numericos), meses_numericos[tipodecambio$Mes], "mes_mal"
  )

tipodecambio$Año <- as.numeric(tipodecambio$Año)
tipodecambio$Día <- as.numeric(tipodecambio$Día)


tipodecambio$fecha <- as.Date(paste0(tipodecambio$Año, "-",
                                     tipodecambio$mes_numerico, "-", tipodecambio$Día))

tipodecambio <- tipodecambio %>% 
  select(fecha, colnames(tipodecambio)[4:18])

??write_csv


write.csv(tipodecambio,
          "Modulo #2 Importacion Avanzada y Casos Practicos/tipocambiodiario.csv",
          row.names = FALSE, na ="0")






















