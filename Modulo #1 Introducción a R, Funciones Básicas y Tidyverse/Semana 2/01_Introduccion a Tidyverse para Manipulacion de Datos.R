
library(tidyverse)
library(lubridate)


##Leemos la tabla de letras
letras_bc <- read.table("Semana 2/data/letras_bc_consolidado_clean.csv")

##Seleccionando Columnas
letras_bc_selected_cols <- letras_bc |>
  select(FechadeSubasta, FechaLiquidacion, MontoAdjudicado)

##Filtrando datasets 
letras_monto_subastado_5000 <- letras_bc |>
  select(FechadeSubasta, FechaLiquidacion, MontoAdjudicado) |> 
  filter(MontoAdjudicado==5000)

glimpse(letras_monto_subastado_500)


## Modificacion de columnas 
letras_monto_subastado_5000 <- letras_bc |>
  select(FechadeSubasta, FechaLiquidacion, MontoAdjudicado) |> 
  filter(MontoAdjudicado==5000) %>% 
  mutate(RendimientoPPA= RendimientoPPA*100, 
         RendimientoPPA= RendimientoPPA*100
  )

glimpse(letras_monto_subastado_500)

##Group by
letras_agrupadas_mes <- letras_bc |>
  select(FechadeSubasta, MontoDemandado, RendimientoPPA) |> 
  filter(FechadeSubasta> as.Date('2022-12-31')) |>
  mutate(mesFechaSubasta= month(FechadeSubasta)) |>
  group_by(mesFechaSubasta) |>
  summarise( 
    PromedioTasa= mean(RendimientoPPA), 
    TotalSubastado= sum(MontoDemandado)) |> 
  arrange(mesFechaSubasta)


##Joins
##Creamos una columna de FechaSubasta utilizando una secuencia de fechas de la fecha minima de subasta de nuestro dataframe original hasta la fecha maxima por dia
##Creamos una segunda columna que aleatoriamente nos dira 1 si fue declarado desierto y 0 si no fue declarada desierta
subasta_desierta <- data.frame(
  "FechadeSubasta" = seq(as.Date(min(letras_bc$FechadeSubasta)),as.Date(max(letras_bc$FechadeSubasta)), by="day" ), 
  "DeclaradaDesierta"= sample(c(1,0),length(seq(as.Date(min(letras_bc$FechadeSubasta)),as.Date(max(letras_bc$FechadeSubasta)), by="day" )), TRUE)
)

letras_bc$FechadeSubasta <- as.Date(letras_bc$FechadeSubasta)

##Haciendo left join
union_de_desiertas <- left_join(letras_bc, subasta_desierta, by="FechadeSubasta")
glimpse(union_de_desiertas)

registros_no_unidos <- anti_join(subasta_desierta, letras_bc)
glimpse(registros_no_unidos)

## Transformaciones de ancho a largo y de largo a ancho.

##Usando el pivot wider ya que nuestro dataset esta en formato largo
letras_mes_columnas <- letras_bc |>
  select(FechadeSubasta, MontoDemandado) |> 
  mutate(mesFechaSubasta= month(FechadeSubasta), 
         anoFechaSubasta= year(FechadeSubasta)) |>
  group_by(anoFechaSubasta, mesFechaSubasta) |> 
  summarise(totalDemandado= sum(MontoDemandado)) |> 
  ungroup() |> 
  arrange(mesFechaSubasta)

letras_mes_columnas <- letras_mes_columnas |> 
  pivot_wider(
    names_from =mesFechaSubasta, 
    values_from= totalDemandado
  )


###Usando el pivot longer ajustamos la informacion transformada con el pivot wider

restaurando_dataset <- letras_mes_columnas |> 
  pivot_longer(
    cols=  2:ncol(letras_mes_columnas) , 
    names_to ="mesFechaSubasta", 
    values_to = "totalDemandado"
  )





