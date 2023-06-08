

suppressPackageStartupMessages(library(quantmod))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(PerformanceAnalytics))
suppressPackageStartupMessages(library(PortfolioAnalytics))

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

colnames(precios_FAANG) <- (precios_FAANG_vect)
retornos_diarios_FAANG <- Return.calculate(precios_FAANG, method= "log") %>% na.omit


init <- portfolio.spec(assets=precios_FAANG_vect)

##Restricciones al portafolio
init <- add.constraint(portfolio=init, type="leverage",
                       min_sum=0.99, max_sum=1.01)

init <- add.constraint(portfolio=init, type="box", min=0.05, max=0.65)

##Objetivos del Portafolio, maximixacion del retorno basado en el promedio
maxret <- add.objective(portfolio=init, type="return", name="mean")


##Optimizacion del portafolio
opt_maxret <- optimize.portfolio.rebalancing(R=retornos_diarios_FAANG, portfolio=maxret,
                                 optimize_method="ROI",
                                 trace=TRUE, 
                                 rebalance_on = "years", 
                                 training_period = 720, 
                                 rolling_window = 1)


chart.Weights(opt_maxret, main="Evolución de las Distribuciones de los\n Pesos de las Acciones Dado el Periodo de Rebalanceo")





