

## Historico de precio de un instrumento especifico + Cantidad de transacciones (Grafico de linea)

library(tidyverse)
library(lubridate)

opdiarias_rf <- readRDS("Modulo #2 Importacion Avanzada y Casos Practicos/Semana 4- Casos Practicos/data/operaciones_diarias_rf.rds")
opdiarias_rf <- na.omit(opdiarias_rf)

precios_bonos <- opdiarias_rf %>% select("codigo"= `Cód. Local`, 
                                         fecha_operacion, 
                                         Precio) %>% 
  mutate(semana= floor_date(fecha_operacion, "week"), 
         Precio= as.numeric(Precio)) %>% 
  select(-fecha_operacion) 

bonos_con_historia <- precios_bonos %>% group_by(codigo) %>%
  summarise(cantidad_semanas= n_distinct(semana))
vector_bonos_con_historia <- bonos_con_historia[bonos_con_historia$cantidad_semanas>2,]$codigo

for (bono in vector_bonos_con_historia) { 
  data_bono <- precios_bonos %>% filter(codigo==bono)
  intervalo_confianza <- predict(lm(Precio ~ semana, data= data_bono), interval="confidence")
  data_bono <- mutate(data_bono, intervalo_inf= intervalo_confianza[,2], intervalo_sup= intervalo_confianza[,3])
  data_bono <- data_bono %>% group_by(semana) %>% summarise(precio_promedio= mean(Precio),
                                                            intervalo_inferior= mean(intervalo_inf),
                                                            intervalo_superior= mean(intervalo_sup))
  
  titulo <- paste("Comportamiento del precio del instrumento de RF", bono)
  subtitulo <- paste("De", min(data_bono$semana), "a", max(data_bono[data_bono$semana < as.Date("2023-05-22"),]$semana))
  x_label <- "Semana"
  y_label <- "Precio"
  
  grafico <-  ggplot(data = data_bono, aes(x = semana, y = precio_promedio)) +
    geom_line(aes(group = 1)) +
    geom_ribbon(aes(ymin=intervalo_inferior, ymax= intervalo_superior), fill="lightblue", alpha=0.3) +
    scale_x_date(date_labels = "%W-%b")  +
    labs(title= titulo,
         subtitle = subtitulo, 
         x= x_label,
         y= y_label, 
         caption= "Datos de la BVRD") + 
    theme_classic() + 
    theme(legend.position = "none",
          legend.title = element_blank()) + 
    theme_classic()
  
  plot(grafico)
}

