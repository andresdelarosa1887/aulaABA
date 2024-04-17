
library(httr)
library(readxl)
library(tidyverse)
library(pdftools)


## Origen https://www.bancentral.gov.do/a/d/2714-facilidades-permanentes-de-contraccion-y-expansion-monetaria-a-plazo-de-un-dia


# La contracción/expansion monetaria es un término utilizado en economía para describir una política implementada
# por un banco central para reducir la cantidad de dinero en circulación en una economía. Esta política 
# puede tener como objetivo controlar la inflación, 
# estabilizar la moneda o enfriar una economía que está experimentando un crecimiento demasiado rápido.


##Importacion desde la WEB de un PDF
URL <- {
  "https://cdn.bancentral.gov.do/documents/instrumentos-de-inversion/instrumentos-operaciones-de-mercado-abierto/documents/Resultados_Contraccion_Expansion.pdf?v=1648831730568"
}
PDF_Contraccion <- pdf_text(URL) %>% str_split("\n")

## Borrar primeras 21 lineas
for (i in 1:7) {
  PDF_Contraccion[[i]] <- PDF_Contraccion[[i]][-1:-21]
}


## Separar cada valor
PDF_Contraccion <- str_squish(PDF_Contraccion)

## Sacar cada linea
PDF_Contraccion <- PDF_Contraccion %>% strsplit(split= "\\,\\s\\\"")

## Quitar "c(\" al inicio de cada pagina
for(i in 1:length(PDF_Contraccion)) {
  PDF_Contraccion[[i]][1] <- PDF_Contraccion[[i]][1] %>%
    str_extract("(?<=c[:punct:]\\\").*")
}

## Quitar \ al final de cada linea
for(i in 1:length(PDF_Contraccion)) {
  for(j in 1:length(PDF_Contraccion[[i]])) {
    PDF_Contraccion[[i]][j] <- PDF_Contraccion[[i]][j] %>%
      stringr::str_extract(".*(?=\")")
  }
}


numbers_ex = list()
k=1
for(i in 1:length(PDF_Contraccion)) {
  for(j in 1:length(PDF_Contraccion[[i]])){
    numbers <- PDF_Contraccion[[i]][j] %>% str_extract("[:digit:]+.*")
    numbers_df <- data.frame(numbers)
    # need to figure out how to get a list of the numbers going!
    while(k <= 10000) {
      numbers_ex[[k]]<- numbers_df
      k <- k+1
      break
    }
  }
  NH_numbers <- dplyr::bind_rows(numbers_ex)
}


NH_numbers %>% 
  separate(numbers, c("A","B","C","D","E","F","G","H","I","J","K","L", "M", "N", "O", "P"), sep="\\s") -> NH_numbers

## Hacer cambios en las columnas
NH_numbers1 <- NH_numbers %>% 
  mutate(P = ifelse(str_detect(O, "%"), O, P),
         O = ifelse(nchar(N) < 8, N, O),
         N = ifelse(str_detect(M, "%"), N, M),
         M = ifelse(str_detect(L, "%"), L, M),
         L = ifelse(str_detect(L, "%"), K, L),
         K = ifelse(str_detect(K, "%"), K, "-")) %>% 
  drop_na() #quitar fila con NA

# Definir nombres de cada columna
colnames(NH_numbers1)[1] <- "Fecha"
colnames(NH_numbers1)[7] <- "Ofertas Adjudicadas - Valor Nominal"
colnames(NH_numbers1)[10] <- "Ofertas Adjudicadas - Tasa de Rendimiento"
colnames(NH_numbers1)[12] <- "Overnight - Monto"
colnames(NH_numbers1)[13] <- "Overnight - Tasa de Interes"
colnames(NH_numbers1)[14] <- "Total Contraccion"

# Seleccionar columnas
Contraccion_Monetaria <- NH_numbers1 %>% 
  select(Fecha, `Ofertas Adjudicadas - Valor Nominal`,
         `Ofertas Adjudicadas - Tasa de Rendimiento`,
         `Overnight - Monto`,
         `Overnight - Tasa de Interes`,
         `Total Contraccion`)

# Convertir "Fecha" a date
Contraccion_Monetaria <- Contraccion_Monetaria %>% 
  mutate(Fecha = as.Date(Fecha, "%d/%m/%Y"))




# Convertir a numeric y dar formato
Contraccion_Monetaria <- Contraccion_Monetaria %>% 
  mutate(`Ofertas Adjudicadas - Valor Nominal` = as.numeric(str_replace_all(`Ofertas Adjudicadas - Valor Nominal`, 
                                                                            ",", "")),
         `Ofertas Adjudicadas - Tasa de Rendimiento` = as.numeric(str_replace_all(`Ofertas Adjudicadas - Tasa de Rendimiento`, 
                                                                                  "%", ""))/100,
         `Overnight - Monto` = as.numeric(str_replace_all(`Overnight - Monto`, ",", "")),
         `Overnight - Tasa de Interes` = as.numeric(str_replace_all(`Overnight - Tasa de Interes`, 
                                                                    "%", ""))/100,
         `Total Contraccion` = as.numeric(str_replace_all(`Total Contraccion`, 
                                                          ",", "")),
         `Tasa Contraccion Monetaria` = ((`Ofertas Adjudicadas - Valor Nominal`*`Ofertas Adjudicadas - Tasa de Rendimiento`)+
                                           (`Overnight - Monto`*`Overnight - Tasa de Interes`))/`Total Contraccion`) %>% 
  filter(!is.na(`Total Contraccion`))


