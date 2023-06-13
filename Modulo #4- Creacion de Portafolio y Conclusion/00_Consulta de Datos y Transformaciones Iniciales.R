
library(PerformanceAnalytics)
library(quantmod)
library(tidyverse)


precios_FAANG_vect <- c("AMZN", "META", "NFLX", "GOOGL", "AAPL")

fecha_inicio <- "2015-01-01"
fecha_final <- "2023-06-01"

precios_FAANG <- getSymbols( 
  precios_FAANG_vect, 
  src= "yahoo", 
  from= fecha_inicio, 
  to=  fecha_final, 
  auto.assign =  TRUE, 
  warnings= FALSE) %>% 
  map(~Ad(get(.))) %>% 
  reduce(merge)

colnames(precios_FAANG) <- c("AMZN", "META", "NFLX", "GOOGL", "AAPL")

precios_mensuales <- to.monthly(precios_FAANG, indexAt = "lastof", OHLC= FALSE)
retornos_mensuales_FAANG <- Return.calculate(precios_mensuales, method ="log") %>%
  na.omit

write_rds(retornos_mensuales_FAANG, "retornos_mensuales_FAANG.rds")



retornos_mensuales_FAANG_largo <- retornos_mensuales_FAANG %>%
  data.frame(fecha= index(.)) %>%
  remove_rownames()  %>% 
  pivot_longer(cols =all_of(precios_FAANG_vect), names_to = "Stock", values_to = "Retornos") 





unidos <- ggplot(retornos_mensuales_FAANG_largo, aes(x= Retornos)) +
  geom_density(aes(color= Stock), alpha=0.5) + 
  geom_histogram(aes(fill= Stock), alpha=0.45, binwidth = .005) + 
  ggtitle("Retornos Mensuales desde en 2015 de las FAANG")

separados <-  ggplot(retornos_mensuales_FAANG_largo, aes(x= Retornos)) +
  geom_density(aes(color= Stock), alpha=0.5) + 
  geom_histogram(aes(fill= Stock), alpha=0.45, binwidth = .005) + 
  facet_wrap(~Stock)
ggtitle("Retornos Mensuales desde en 2015 de las FAANG")

plot(separados)




