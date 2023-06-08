library(PerformanceAnalytics)
library(quantmod)
library(tidyverse)


fecha_inicio <- "2015-01-01"
fecha_final <- "2023-06-01"

getSymbols( 
  "^GSPC", 
  src= "yahoo", 
  from= fecha_inicio, 
  to=  fecha_final, 
  auto.assign =  TRUE, 
  warnings= FALSE) 

SP500 <- GSPC
SP500_mensual <- to.monthly(SP500, indexAt = "lastof", OHLC= FALSE)
retornos_mensuales_SP500 <- Return.calculate(SP500_mensual, method= "log") %>% 
  na.omit 

write_rds(retornos_mensuales_SP500, "retornos_mensuales_SP&500.rds")


