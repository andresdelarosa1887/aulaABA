

##Importacion desde la WEB de un Excel
library(httr)
library(readxl)

linkBC<-  "https://cdn.bancentral.gov.do/documents/estadisticas/mercado-cambiario/documents/TASAS_CONVERTIBLES_OTRAS_MONEDAS.xlsx?v=1684715614947"
GET(linkBC, write_disk(tf <- tempfile(fileext = ".xlsx")))
tipodecambio <- read_excel(tf)


##Importacion desde la WEB de un PDF
suppressPackageStartupMessages(library(pdftools))
library(stringr)

link_pdf <- 
  
  {"https://cdn.bancentral.gov.do/documents/instrumentos-de-inversion/instrumentos-operaciones-de-mercado-abierto/documents/Resultados_Contraccion_Expansion.pdf?v=1648831730568"
}

PDF_contraccion <-  pdf_text(link_pdf) |>  str_split("\n")
PDF_contraccion[[1]]



library(jsonlite)





sb_get <- function(base_url = "https://apis.sb.gob.do/estadisticas", 
                   end_point, periodo_inicial, tipo_entidad = NULL, entidad = NULL){
  ## Api Key SB
  api_key <- "377833a9f00844b0975025d5f2d2c544"
  
  ## Definir url & endpoint
  base_url <- base_url
  end_point <- end_point
  
  ## Get json
  df <- GET(paste0(base_url, end_point),
            add_headers("Ocp-Apim-Subscription-Key" = api_key),
            query = list(
              periodoInicial = periodo_inicial,
              tipoEntidad = tipo_entidad,
              entidad = entidad),
            encode = "json")

  ## Parse json
  df <- content(df, as = "text", encoding = "UTF-8")
  df <- fromJSON(df)
  
  ## JSON to dataframe
  df <- as.data.frame(df$data)
  
  return(df)
}

### Cargar datos
estados_situacion <- sb_get("https://apis.sb.gob.do/estadisticas", 
                            "/estados/situacion/eif", "2016-01", "BM")


























