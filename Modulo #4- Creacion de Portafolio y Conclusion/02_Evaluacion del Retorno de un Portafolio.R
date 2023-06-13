
suppressPackageStartupMessages(library(quantmod))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(PerformanceAnalytics))


FAANG <- readRDS("Modulo #4- Creacion de Portafolio y Conclusion/Semana 7- Tidyquant y PorfolioAnalytics/portafolio_FAANG_EW.rds")

retornos_portf_faang <- FAANG$returns %>%
  data.frame(fecha= index(.)) %>%
  remove_rownames() 


retorno_FAANG <-  ggplot(data = retornos_portf_faang, aes(x = fecha,
                                                          y = portfolio.returns*100)) +
  geom_line() +
  scale_x_date(date_labels = "%b-%Y")  +
  labs(title= "Evolucion del Retorno del Portafolio FAANG",
       subtitle =  paste("Valores Mensuales de", min(retornos_portf_faang$fecha),
                         "a", max(retornos_portf_faang$fecha)), 
       x= "Fecha",
       y= "Retorno", 
       caption= "Yahoo Finance") + 
  theme_classic() 

plot(retorno_FAANG)



chart.Histogram(retornos_portf_faang$portfolio.returns, methods = c("add.density",
                                                                    "add.centered"),
                main = " Retorno del Portafolio FAANG", 
                xlab= "Retorno", 
                ylab= "Frecuencia")


sp500 <- Ad(readRDS("Modulo #4- Creacion de Portafolio y Conclusion/Semana 7- Tidyquant y PorfolioAnalytics/retornos_mensuales_SP&500.rds"))


###Adicionando Benchmark
benchmark_returns <- cbind(sp500, retornos_portf_faang$portfolio.returns)
colnames(benchmark_returns) <- c("SP&500","FAAG_PORT")

par(mfrow= c(1,2))

plot(density(benchmark_returns$`SP&500`*100),
     main = "Retornos SP&500", 
     xlab = "Retornos",
     ylab= "Frecuencia")

plot(density(benchmark_returns$FAAG_PORT*100),
     main = "Retornos FAANG",
     ylab= "Frecuencia", 
     xlab= "Retornos")




charts.PerformanceSummary(
  benchmark_returns, main= "Desempeño del SP&500 y las Acciones FAANG"
)


table.AnnualizedReturns(benchmark_returns)







