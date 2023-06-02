

library(tidyverse)


data <- data.frame(category = c("A", "B", "C", "D"),
                   value = c(10, 15, 8, 12))


grafico <- ggplot(data, aes(x= category, y= value)) +
  geom_bar(stat="identity", fill= "blue") + 
  labs(title= "Un grafico random", x= "Categoria", y= "Valor") 


opdiarias_rf <- readRDS("Modulo #2 Importacion Avanzada y Casos Practicos/Semana 4- Casos Practicos/data/operaciones_diarias_rf.rds")
opdiarias_rf <- na.omit(opdiarias_rf)

colnames()

library(lubridate)

data_barras <- opdiarias_rf %>%
  select("codigo"=`Cód. Local`,
         fecha_operacion
    ) %>% 
  mutate(semana= week(fecha_operacion)) %>% 
  select(codigo, semana  ) %>% 
  group_by(semana) %>% 
  summarise(cantidad_titulos= n_distinct(codigo))



titulo <- "Cantidad de Titulos Distintos Transados por Semana en 2023"
subtitulo <- paste("De", min(opdiarias_rf$fecha_operacion), "a", max(opdiarias_rf[opdiarias_rf$fecha_operacion < as.Date("2023-05-22"),]$fecha_operacion))
x_label <- "Semana del 2023"
y_label <- "Cantidad de Titulos Distintos Transados"
promedio_titulos <- mean(data_barras$cantidad_titulos)


ggplot(data_barras, aes(x= as.factor(semana), y= cantidad_titulos))+
  geom_bar(stat="identity", fill= "grey")   + 
  labs(title= titulo,
       subtitle = subtitulo, 
       x= x_label,
       y= y_label) + 
  geom_text(aes(label= cantidad_titulos), 
            vjust=-0.5, 
            color= "black"
    ) +
  geom_hline(yintercept = promedio_titulos, linetype = "dashed", color = "red", linewidth = 0.5) +
  theme_classic()



##Grafico de Dispersion 
#x dias de vencimiento 
#y precio
opdiarias_rf

grafico_dispersion <- opdiarias_rf %>% 
  select(Precio, `Días Venc.`, 
        "codigo_local"= `Cód. Local`) %>% 
  mutate(Precio= as.numeric(Precio), 
         dias_vencimiento= as.numeric(`Días Venc.`))


ggplot(grafico_dispersion, aes(x= dias_vencimiento, y= Precio)) + 
  geom_point(aes( color= codigo_local)) + 
  geom_smooth(method= "lm", se=TRUE, color= "red") +
  labs(x = "Dias al Vencimiento",
       y = "Precio del Título de Renta Fija",
       title = "Precio de los Bonos Transados y los Días al Vencimiento", 
       subtitle =  paste("De", min(opdiarias_rf$fecha_operacion), "a",
                         max(opdiarias_rf[opdiarias_rf$fecha_operacion < as.Date("2023-05-22"),]$fecha_operacion)), 
       caption= "Datos de la BVRD")  + 
  theme(legend.position = "none",
        legend.title = element_blank())



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




precio_bonos <- opdiarias_rf %>% 
  select("codigo_local"= `Cód. Local`, 
         fecha_operacion, 
        Precio) %>% 
  mutate(semana= floor_date(fecha_operacion, "week"), 
         Precio= as.numeric(Precio)) %>% 
  select(-fecha_operacion)

bonos_con_historia <- precio_bonos %>% group_by(codigo_local) %>% 
  summarise(cantidad_semana= n_distinct(semana))

vector_bonos_con_historia <- bonos_con_historia[bonos_con_historia$cantidad_semana >2,]$codigo_local



for (bono in vector_bonos_con_historia) {
  data_bono <- precio_bonos %>% filter(codigo_local== bono)
  intervalo_confianza <- predict(lm(Precio~ semana, data=data_bono), interval = "confidence")
  data_bono <- mutate(data_bono, intervalo_inf= intervalo_confianza[,2], intervalo_sup = intervalo_confianza[,3] )
  
  data_bono <- data_bono %>% group_by(semana) %>% summarise( 
    precio_promedio= mean(Precio),
    intervalo_inferior = mean(intervalo_inf), 
    intervalo_superior = mean(intervalo_sup)
  )
  
  titulo <- paste("Comportamiento del precio del instrumento de RF", bono)
  subtitulo <- paste("De", min(data_bono$semana), "a", max(data_bono[data_bono$semana < as.Date("2023-05-22"),]$semana))
  x_label <- "Semana"
  y_label <- "Precio Promedio"
  
  grafico <- ggplot(data= data_bono, aes(x= semana, y= precio_promedio))+ 
    geom_line() + 
    geom_ribbon(aes(ymin= intervalo_inferior, ymax= intervalo_superior), fill= "lightblue", alpha=0.3) + 
    scale_x_date(date_labels= "%W-%b") +
    labs(title= titulo,
         subtitle = subtitulo, 
         x= x_label,
         y= y_label, 
         caption= "Datos de la BVRD") + 
    theme_classic()
  
  plot(grafico)
  
}






























