

## Historico de precio de un instrumento especifico + Cantidad de transacciones (Grafico de linea)


library(tidyverse)
library(lubridate)

opdiarias_rv <- readRDS("Modulo #2 Importacion Avanzada y Casos Practicos/Semana 4- Casos Practicos/data/operaciones_diarias_rv.rds")
opdiarias_rf <- readRDS("Modulo #2 Importacion Avanzada y Casos Practicos/Semana 4- Casos Practicos/data/operaciones_diarias_rf.rds")


colnames(opdiarias_rv)

ggplot(data = opdiarias_rv, aes(x = `Fecha Op.`, y = as.numeric(`Precio`))) +
  geom_line(aes(color = `Cód. Local`)) +
  scale_x_date(date_labels = "%b %Y", date_breaks = "1 month")


