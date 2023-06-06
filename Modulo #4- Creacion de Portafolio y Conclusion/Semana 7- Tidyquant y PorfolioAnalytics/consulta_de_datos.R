

##Instalar los paquetes necesarios##
install.packages("pacman")
pacman::p_load(xts, zoo, PerformanceAnalytics, quantmod, plotly,
               tidyverse, dplyr, PortfolioAnalytics, tidyquant,ROI,
               ROI.plugin.quadprog, ROI.plugin.glpk, timetk)


##Primero buscamos los retornos de los mencionados benchmarks y analizamos su tendencia en los últimos 4 anos
#En este caso nos auxiliaremos de la función [tq_get](https://www.rdocumentation.org/packages/tidyquant/versions/1.0.1/topics/tq_get) 
#del paquete tidyquant que busca la información en un formato conveniente
start_date <- "2017-01-01"
SP500 <- tq_get("SP500", get = "economic.data",
                from = start_date,to = Sys.Date())

##Grupo de acciones FAANG##
FAANG <- c("AAPL", "GOOG", "AMZN", "FB", "NFLX")
FAANG_data <- FAANG %>% 
  tq_get(get = "stock.prices",
         from = start_date, to = Sys.Date()) %>% 
  group_by(symbol)


##Para el S&P500
xtsSP500_daily_returns  <-  SP500 %>% 
  tq_transmute(select = price,
               mutate_fun = periodReturn,   
               period="daily", 
               type="arithmetic") %>%
  select(date,daily.returns) %>%
  tk_xts(silent = TRUE)

colnames(xtsSP500_daily_returns) <- "SP500"

##Para el set de datos FAANG
xtsFAANG_daily_returns <- FAANG_data %>% 
  tq_transmute(select = adjusted,
               mutate_fun = periodReturn,   
               period="daily", 
               type="arithmetic") %>%
  select(symbol, date, daily.returns) %>%
  spread(symbol,daily.returns) %>%
  tk_xts(silent = TRUE)

print("Retorno diario de las Acciones FAANG y el SP500 para el periodo seleccionado:")
print(cbind(head(xtsFAANG_daily_returns[, 1:3]) , head(xtsSP500_daily_returns)))