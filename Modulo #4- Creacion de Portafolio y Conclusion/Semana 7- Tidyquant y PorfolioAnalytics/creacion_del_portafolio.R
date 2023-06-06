

n <- ncol(xtsFAANG_daily_returns)
equal_weights <- rep(1/n, n) ##Cada acción tendrá un peso inicial correspondiente al 20%

FAANG_EqualWeights <- Return.portfolio(
  R= xtsFAANG_daily_returns, 
  weights= equal_weights, 
  rebalance_on ="years", 
  verbose= TRUE ##Activamos el verbose para obtener una lista con diferentes parámetros relacionados al cálculo del retorno de este inndice
)

##Obtenemos el objeto de retornos del portafolio
Retornos_FAAN_EqualWeights <- FAANG_EqualWeights$returns
colnames(Retornos_FAAN_EqualWeights) <- "FAAMG-EqualWeights"


##Graficamos la evolución de los pesos de cada una de las acciones FAANG para tener una idea de como Return.portfolio hace los rebalanceos en los periodos especificados
PesosFinalDelPeriodo <- data.frame(FAANG_EqualWeights$EOP.Weight) 
PesosFinalDelPeriodo <- tibble::rownames_to_column(PesosFinalDelPeriodo, "fecha")
PesosFinalDelPeriodo2 <- gather(PesosFinalDelPeriodo, Acciones, Pesos, -fecha)
PesosFinalDelPeriodo2 %>%
  ggplot( aes(x=as.Date(fecha), y=Pesos, group=Acciones, color= Acciones)) +
  geom_line() + ggtitle("Evolución de los Pesos de las Acciones FAANG") + labs(x= "Fecha") +
  geom_vline(xintercept = c(as.Date("2018-01-01"),as.Date("2019-01-01"),as.Date("2020-01-01")) , linetype="dotted",  color = "blue", size=0.9)


