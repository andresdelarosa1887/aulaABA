
suppressPackageStartupMessages(library(quantmod))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(PerformanceAnalytics))

FAANG_PORT <- readRDS("Modulo #4- Creacion de Portafolio y Conclusion/Semana 7- Tidyquant y PorfolioAnalytics/portafolio_FAANG_EW.rds")
retornos_mensuales_FAANG <- readRDS("Modulo #4- Creacion de Portafolio y Conclusion/Semana 7- Tidyquant y PorfolioAnalytics/retornos_mensuales_FAANG.rds")

n <- ncol(retornos_mensuales_FAANG)
pesos_iguales <- rep(1/n, n) ##Cada acción tendrá un peso inicial correspondiente al 20%


matriz_covarianzas<- cov(retornos_mensuales_FAANG)
matriz_desviaciones_estandar <- sqrt(t(pesos_iguales) %*% matriz_covarianzas %*% pesos_iguales)

FAANG_StdDev <-  StdDev(retornos_mensuales_FAANG, weights = pesos_iguales)
FAANG_StdDev <- data.frame(Stock= "FAANG Port", desviacion= FAANG_StdDev)


retornos_portf_faang <- FAANG_PORT$returns %>%
  data.frame(fecha= index(.)) %>%
  remove_rownames() 


desviacion_grafico <- sd(FAANG_PORT$returns)
promedio_grafico <- mean(FAANG_PORT$returns)




retornos_portf_faang <- retornos_portf_faang  |>
  mutate(hist_color_rojo= ifelse(portfolio.returns < (promedio_grafico- desviacion_grafico),portfolio.returns, as.numeric(NA)), 
         hist_color_verde= ifelse(portfolio.returns > (promedio_grafico+ desviacion_grafico),portfolio.returns, as.numeric(NA)),
         hist_color_azul= ifelse(portfolio.returns > (promedio_grafico- desviacion_grafico) &
                                   portfolio.returns < (promedio_grafico+ desviacion_grafico),portfolio.returns, as.numeric(NA)))



retorno_FAANG <-  ggplot(data = retornos_portf_faang, aes(x = fecha)) +
  geom_point(aes(y = hist_color_rojo*100), color= "red" )+
  geom_point(aes(y = hist_color_verde*100), color= "green" )+
  geom_point(aes(y = hist_color_azul*100), color= "blue" )+
  geom_hline(yintercept =((promedio_grafico + desviacion_grafico)*100), color="purple", linetype="dotted") + 
  geom_hline(yintercept =((promedio_grafico - desviacion_grafico)*100), color="purple", linetype="dotted") + 
  scale_x_date(date_labels = "%b-%Y")  +
  labs(title= "Evolucion del Retorno del Portafolio FAANG",
       subtitle =  paste("Valores Mensuales de", min(retornos_portf_faang$fecha), "a", max(retornos_portf_faang$fecha)), 
       x= "Fecha",
       y= "Retorno", 
       caption= "Yahoo Finance") + 
  theme(legend.position = "none",
        legend.title = element_blank()) + 
  theme_classic()

plot(retorno_FAANG)
suppressWarnings(plot(retorno_FAANG))





precios_FAANG_vect <- c("AMZN", "META", "NFLX", "GOOGL", "AAPL")

retornos_mensuales_FAANG_largo <- retornos_mensuales_FAANG %>%
  data.frame(fecha= index(.)) %>%
  remove_rownames() %>% 
  pivot_longer(cols =all_of(precios_FAANG_vect), names_to = "Stock", values_to = "Retornos") 


retornos_mensuales_FAANG_largo <- retornos_mensuales_FAANG_largo %>%
  group_by(Stock) %>% 
  summarise(desviacion= sd(Retornos)) %>% 
  add_row(FAANG_StdDev)


ggplot(data= retornos_mensuales_FAANG_largo, 
       aes(x= Stock, y= desviacion, color= Stock)) +
  geom_point()   +
  labs(title= "Desviacion del Portafolio FAANG vs. sus componentes",
       subtitle =  paste("Fecha de", min(retornos_portf_faang$fecha), "a", max(retornos_portf_faang$fecha)), 
       x= "Fecha",
       y= "Desviacion", 
       caption= "Yahoo Finance") + 
  theme(legend.position = "none",
        legend.title = element_blank()) + 
  theme_classic()








