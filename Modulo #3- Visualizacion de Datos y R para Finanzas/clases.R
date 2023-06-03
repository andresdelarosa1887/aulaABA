

library(xts)

secuencia_fechas <- seq(as.Date("2001-01-01"), today(), by= "day")
valores_aleatorios <- runif(length(secuencia_fechas))

serie_xts <- xts(valores_aleatorios, order.by = secuencia_fechas)
colnames(serie_xts) <- "nombre_columna"



# install.packages('quantmod')
library(quantmod)
library(lubridate)


FAANG <- c("AAPL", "GOOGL", "AMZN", "META", "NFLX")
getSymbols(FAANG, from= "2015-01-01", to= today())

FAANG_data <- merge(Cl(AAPL), Cl(GOOGL), Cl(AMZN), Cl(META), Cl(NFLX))
dailyReturn(FAANG_data$AAPL.Close)


chartSeries(dailyReturn(FAANG_data$GOOGL.Close))







FAANG_data$SMA_Google <-  SMA(FAANG_data$GOOGL.Close, n=10)

chartSeries(FAANG_data$GOOGL.Close, theme="white")
chartSeries(dailyReturn(FAANG_data$GOOGL.Close), theme="white")
addSMA(n= 10, on=1, with.col = Cl, overlay= TRUE, col= "blue")
addSMA(n= 150, on=1, with.col = Cl, overlay= TRUE, col= "blue")
addSMA(n= 360, on=1, with.col = Cl, overlay= TRUE, col= "blue")



chartSeries(FAANG_data$GOOGL.Close, theme="white")
addBBands(n=30, sd=2, ma= "SMA", draw= "bands", on= -1)

FAANG_data$BB_Google <-  BBands(FAANG_data$GOOGL.Close, n=10, sd=2)







library(PerformanceAnalytics)
library(quantmod)
library(lubridate)



FAANG <- c("AAPL", "GOOGL", "AMZN", "META", "NFLX")
getSymbols(FAANG, from= "2015-01-01", to= today())


retornos_diarios <- merge(dailyReturn(Cl(AAPL)),dailyReturn(Cl(GOOGL)),
                          dailyReturn(Cl(AMZN)), dailyReturn(Cl(META)),
                          dailyReturn(Cl(NFLX)))

retornos_diarios <- Return.calculate(FAANG_data)

chart.Histogram(retornos_diarios$AAPL.Close, 
                methods = c("add.density", "add.centered"))


VaR(retornos_diarios$AAPL.Close)

chart.VaRSensitivity(retornos_diarios$AAPL.Close, 
                     methods = c("HistoricalVaR", "GaussianVaR"), 
                     colorset =  bluefocus, lwd=2)



table.Stats(FAANG_data)
table.AnnualizedReturns(retornos_diarios)

table.Drawdowns(retornos_diarios$AAPL.Close, top=10)













