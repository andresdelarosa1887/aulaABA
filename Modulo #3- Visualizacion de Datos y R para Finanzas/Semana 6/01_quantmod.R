

#install.packages("quantmod")
library(quantmod)

symbol <- "AAPL"
start_date <- "2022-01-01"
end_date <- "2023-05-31"

getSymbols(symbol, from=start_date, to= end_date)
datos <-  AAPL
chartSeries(datos, theme="white")
addSMA(n=50, on=1)

returns <- dailyReturn(Cl(datos))
mean_return <- mean(returns)
sd_return <-  sd(returns)
max_return <- max(returns)
min_return <- min(returns)