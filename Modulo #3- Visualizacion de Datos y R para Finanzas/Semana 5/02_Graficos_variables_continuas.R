

library(tidyverse)
library(lubridate)

opdiarias_rv <- readRDS("Modulo #2 Importacion Avanzada y Casos Practicos/Semana 4- Casos Practicos/data/operaciones_diarias_rv.rds")
opdiarias_rv$Precio <- as.numeric(opdiarias_rv$Precio)
opdiarias_rv <- na.omit(opdiarias_rv)
precios_instrumento_renta_variable <- opdiarias_rv[opdiarias_rv$Precio<1000,]$Precio

hist(precios_instrumento_renta_variable,
     breaks = 20,  xlab = "Precios",
     main = "Histograma Precios Instrumentos de Renta Variable R.D.")


plot(ecdf(precios_instrumento_renta_variable),  main = "Distribución Acumulativa Precios Instrumentos de Renta Variable R.D.", xlab = "Precios")
plot(density(precios_instrumento_renta_variable), main = "Densidad Precios Instrumentos de Renta Variable R.D.", xlab = "Precios")
boxplot(precios_instrumento_renta_variable, horizontal = TRUE, main = "Diagrama de Caja Precios Instrumentos de Renta Variable R.D.", xlab = "Precios")





vector_precios_rf <- as.numeric(opdiarias_rf$Precio)
vector_precios_rv <- as.numeric(opdiarias_rv[as.numeric(opdiarias_rv$Precio) <10000, ]$Precio)

#Histogramas
hist(vector_precios_rf, breaks= 30,
     main = "Histograma Instrumentos de Renta Variable R.D.", 
     xlab = "Precios",
     ylab= "Frecuencia")
plot(density(vector_precios_rf))
boxplot(vector_precios_rf)

plot(ecdf(vector_precios_rf))

plot(ecdf(vector_precios_rv))



