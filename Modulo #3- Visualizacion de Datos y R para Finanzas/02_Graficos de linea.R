

## Historico de precio de un instrumento especifico + Cantidad de transacciones (Grafico de linea)

library(tidyverse)
library(lubridate)

opdiarias_rf <- readRDS("Modulo #2 Importacion Avanzada y Casos Practicos/Semana 4- Casos Practicos/data/operaciones_diarias_rf.rds")
opdiarias_rf <- na.omit(opdiarias_rf)

plot(ecdf(opdiarias_rf$Precio),  main = "Distribución Acumulativa Precios Instrumentos de Renta Fija R.D.", xlab = "Precios")

###Vamos a sacar primero el bono que tiene mayor variabilidad en su precio



ggplot(data = opdiarias_rf, aes(x = fecha_operacion, y = as.numeric(`Precio`))) +
  geom_line(aes(color = `Cód. Local`)) +
  scale_x_date(date_labels = "%b %Y", date_breaks = "1 month")  +
  theme_classic() + 
  theme(legend.position = "none",
        legend.title = element_blank())


