
library(tidyverse)
library(lubridate)

opdiarias_rv <- readRDS("Modulo #2 Importacion Avanzada y Casos Practicos/Semana 4- Casos Practicos/data/operaciones_diarias_rv.rds")
opdiarias_rf <- readRDS("Modulo #2 Importacion Avanzada y Casos Practicos/Semana 4- Casos Practicos/data/operaciones_diarias_rf.rds")

##Gramatica de graficos de GGPLOT

## Cantidad de titulos transados cada semana (Grafico de barra)
## Top 10 de titulos mas transados
data_barras <- opdiarias_rf |> 
  select(fecha_operacion, 
         "codigo"= `Cód. Local`, 
         ) %>% 
  mutate(mes= month(fecha_operacion), 
         dia= day(fecha_operacion), 
         semana= week(fecha_operacion)) |> 
  select(semana, codigo) |> 
  group_by(semana) |> 
  summarise(cantidad_titulos= n_distinct(codigo)) |>
  filter(semana != 21)

titulo <- "Cantidad de Titulos Distintos Transados por Semana en 2023"
subtitulo <- paste("De", min(opdiarias_rf$fecha_operacion), "a", max(opdiarias_rf[opdiarias_rf$fecha_operacion < as.Date("2023-05-22"),]$fecha_operacion))
x_label <- "Semana del 2023"
y_label <- "Cantidad de Titulos Distintos Transados"
promedio_titulos <- mean(data_barras$cantidad_titulos)

# Creando el grafico
titulos_semanales <- ggplot(data_barras, aes(x = as.factor(semana), y = cantidad_titulos)) +
  geom_bar(stat = "identity", fill = "grey") +
  labs(title = titulo,
       subtitle = subtitulo, 
       x = x_label,
       y = y_label)  +
    geom_text(aes(label = cantidad_titulos),
              vjust = -0.5, 
              color = "black") + 
  geom_hline(yintercept = promedio_titulos, linetype = "dashed", color = "red", linewidth = 0.5) +
theme_classic()

plot(titulos_semanales)




##Cantidad de dias en los que se transo 
titulos_dias_transados <- opdiarias_rf |> 
  select(fecha_operacion, 
         "codigo"= `Cód. Local`, 
  ) %>% 
  filter(fecha_operacion < as.Date("2023-05-22")) |>
  group_by(codigo) |> 
  summarise(dias_transado= n_distinct(fecha_operacion)) %>% 
  # arrange(desc(dias_transado)) %>% 
  filter(dias_transado > 6 ) %>% 
  mutate(codigo = fct_reorder(codigo, dias_transado))



titulos_dias_trans_chart <- ggplot(titulos_dias_transados, aes(y =dias_transado,
                                                        x = codigo)) +
  geom_bar(stat = "identity", fill = "grey") +
  labs(title = "Número de días en los que el instrumento de renta fija fue transado",
       subtitle =  paste("De", min(opdiarias_rf$fecha_operacion), "a", max(opdiarias_rf[opdiarias_rf$fecha_operacion < as.Date("2023-05-22"),]$fecha_operacion)), 
       y = "Número de días",
       x = "Cod. Local")  +
  geom_text(aes(label = dias_transado),
            vjust = 0.5, 
            color = "black",
            size= 3) +
  coord_flip() +
  theme_classic()

plot(titulos_dias_trans_chart)
