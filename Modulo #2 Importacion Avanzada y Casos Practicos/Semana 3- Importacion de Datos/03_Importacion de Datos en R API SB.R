
library(tidyverse)
library(httr)
library(jsonlite)


## Creacion de API KEY - https://medium.com/@SB-ESTUDIOS/c%C3%B3mo-registrarte-en-el-portal-de-apis-de-la-superintendencia-de-bancos-b8a59acf3f9a
## Referencia - https://medium.com/@SB-ESTUDIOS/usar-el-api-v2-de-estad%C3%ADstica-desde-python-y-r-857bf76fdf7f

get_num_registros <- function(api_key, end_point, periodo_inicial, periodo_final = NULL,
                              entidad = NULL, tipo_entidad = NULL, registros = NULL){
  # base_url
  base_url <- "https://apis.sb.gob.do/estadisticas/v2"
  
  # API Key
  api_key <- "377833a9f00844b0975025d5f2d2c544"
  
  response <- GET(paste0(base_url, end_point),
                  add_headers("Ocp-Apim-Subscription-Key" = api_key),
                  query = list(
                    periodoInicial = periodo_inicial,
                    periodoFinal = periodo_final,
                    tipoEntidad = tipo_entidad,
                    entidad = entidad),
                  encode = "json")
  
  num_records <- fromJSON(headers(response)$`x-pagination`)$TotalRecords
  
  return(as.character(num_records))
}



sb_get <- function(base_url = "https://apis.sb.gob.do/estadisticas/v2", 
                   end_point, periodo_inicial, periodo_final = NULL, 
                   tipo_entidad = NULL, 
                   entidad = NULL){
  
  ## get registros
  registros <- get_num_registros(end_point = end_point, 
                                 periodo_inicial = periodo_inicial,
                                 periodo_final = periodo_final,
                                 entidad = entidad,
                                 tipo_entidad = tipo_entidad)
  
  ## Api Key SB
  api_key <- "377833a9f00844b0975025d5f2d2c544"
  
  ## Definir url & endpoint
  base_url <- base_url
  end_point <- end_point
  
  ## Get json
  response <- GET(paste0(base_url, end_point),
                  add_headers("Ocp-Apim-Subscription-Key" = api_key),
                  query = list(
                    periodoInicial = periodo_inicial,
                    periodoFinal = periodo_final,
                    tipoEntidad = tipo_entidad,
                    entidad = entidad,
                    registros = registros),
                  encode = "json")
  
  if (status_code(response) == 200 & registros != 0){
    ## Parse json
    df <- content(response, as = "text", encoding = "UTF-8")
    df <- fromJSON(df)
    return(df)
  } else{
    # print("Error: Status code ", status_code(response))
    return(NULL)
  }
}


### Sacar todas las entidades
entidades <- c("ADEMI","BANESCO","BANRESERVAS","BDI","BHD",
               "BLH","CARIBE","CITIBANK","LAFISE","POPULAR","PROMERICA",
               "QIK BANCO DIGITAL","SANTA CRUZ","SCOTIABANK","TODOS","VIMENCA")




##Detalles de Estadisticas- https://desarrollador.sb.gob.do/api-details#api=estad-sticas-del-sistema-financiero-con-paginacion&operation=captacionesLocalidad


"/estados/resultados/eif" # Estado de resultados
"/estados/situacion/eif" #  Estados de situacion
"/indicadores/riesgo-credito" #Indicadores de Riesgo de Credito 
"/solvencia/componentes" #Solvencia
"/captaciones/localidad" # Captaciones por localidad
"/carteras/creditos/sectores-economicos" #Creditos Sectores Economicos


periodo_inicial <- '2023-01'
periodo_final <- '2024-01'

captaciones_por_localidad  <- sb_get(end_point = "/captaciones/localidad",
                            periodo_inicial = periodo_inicial,
                            periodo_final = periodo_final,
                            tipo_entidad = "BM")


credito_sectores_economicos  <- sb_get(end_point = "/carteras/creditos/sectores-economicos",
                                     periodo_inicial = periodo_inicial,
                                     periodo_final = periodo_final,
                                     tipo_entidad = "BM")











