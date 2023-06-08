

library(PerformanceAnalytics)
library(quantmod)
library(tidyverse)
retornos_mensuales_FAANG <- readRDS("Modulo #4- Creacion de Portafolio y Conclusion/Semana 7- Tidyquant y PorfolioAnalytics/retornos_mensuales_FAANG.rds")

n <- ncol(retornos_mensuales_FAANG)
pesos_igual <- rep(1/n, n)

FAANG_EqualWeights <- Return.portfolio(
  R= retornos_mensuales_FAANG,
  weights = pesos_igual, 
  rebalance_on ="years", 
  verbose = TRUE 
)

Retornos_FAAN_EqualWeights <-  FAANG_EqualWeights$returns
colnames(Retornos_FAAN_EqualWeights) <- "FAANG-EqualWeights"



PesosFinalDelPeriodo <- data.frame(FAANG_EqualWeights$EOP.Weight)
PesosFinalDelPeriodo <- tibble::rownames_to_column(PesosFinalDelPeriodo, "fecha")
PesosFinalDelPeriodo2 <- gather(PesosFinalDelPeriodo, Acciones, Pesos, -fecha)

ggplot(PesosFinalDelPeriodo2,  aes(x=as.Date(fecha), y=Pesos, group=Acciones, color= Acciones)) +
  geom_line() + 
  ggtitle("Evolución de los Pesos de las Acciones FAANG") +
  labs(x= "Fecha") +
  geom_vline(xintercept = c(
    as.Date("2016-01-01"),
    as.Date("2017-01-01"),
    as.Date("2018-01-01"),
    as.Date("2019-01-01"),
    as.Date("2020-01-01"),
    as.Date("2021-01-01"),
    as.Date("2022-01-01")
  ) , linetype="dotted",  color = "blue", linewidth=0.2) +
  theme_minimal()








