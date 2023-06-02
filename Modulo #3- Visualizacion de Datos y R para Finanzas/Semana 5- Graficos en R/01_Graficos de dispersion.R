
library(tidyverse)
library(lubridate)


opdiarias_rf <- readRDS("Modulo #2 Importacion Avanzada y Casos Practicos/Semana 4- Casos Practicos/data/operaciones_diarias_rf.rds")

##  La relacion entre el precio la cantidad e coutas transadas para renta variable 


opdiarias_rf <- na.omit(opdiarias_rf)

##  Relacion entre el precio y la cantidad de cuotas transadas (Grafico de dispersion)
## Relacion entre el precio y la tasa de cupon de un instrumento financiero


##Creo el modelo de regresion lineal 
x=as.numeric(opdiarias_rf$`Días Venc.`)
y= as.numeric(opdiarias_rf$`Precio`)
modelo <- lm( y ~ x )
x_minimo <- min(x, na.rm = TRUE)
y_maximo <- max(y, na.rm = TRUE)


##Relacion entre el precio del titulo de renta fija y los dias al vencimiento
ggplot(data = opdiarias_rf, aes(x = as.numeric(`Días Venc.`) , y =  as.numeric(`Precio`))) +
  geom_point(aes(color = `Cód. Local`)) +
  geom_smooth(method = "lm", se = TRUE, color = "red") + 
  geom_text(x = x_minimo, y = y_maximo, 
            label = paste("y =", round(coef(modelo)[1], 2), "+", round(coef(modelo)[2], 4), "* x"), hjust = 0, vjust = 1) + 
  labs(x = "Dias al Vencimiento",
       y = "Precio del Título de Renta Fija",
       title = "Precio de los Bonos Transados y los Días al Vencimiento", 
       subtitle =  paste("De", min(opdiarias_rf$fecha_operacion), "a",
                         max(opdiarias_rf[opdiarias_rf$fecha_operacion < as.Date("2023-05-22"),]$fecha_operacion)), 
       caption= "Datos de la BVRD") + 
  scale_color_discrete(name = "`Cód. Local`") +
  theme_classic() + 
  theme(legend.position = "none",
        legend.title = element_blank())


