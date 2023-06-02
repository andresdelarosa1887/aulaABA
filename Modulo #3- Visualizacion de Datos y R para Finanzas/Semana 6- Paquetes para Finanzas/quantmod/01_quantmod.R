

#install.packages("quantmod")
library(quantmod)

FAANG <- c("AAPL", "GOOGL", "AMZN", "META", "NFLX")
start_date <- "2022-01-01"
end_date <- "2023-05-31"


## 
getSymbols(FAANG, from=start_date, to= end_date)
datos <-  merge(AAPL, AMZN)
chartSeries(datos, theme="white")
addSMA(n=50, on=2)

returns <- dailyReturn(Cl(datos))
mean_return <- mean(returns)
sd_return <-  sd(returns)
max_return <- max(returns)
min_return <- min(returns)


opdiarias_rv <- readRDS("Modulo #2 Importacion Avanzada y Casos Practicos/Semana 4- Casos Practicos/data/operaciones_diarias_rv.rds")
opdiarias_rv <- na.omit(opdiarias_rv)

un_instrumento_frecuente <- opdiarias_rv %>%select("codigo_local"= `Cód. Local`,
                                                   fecha_operacion
) %>% group_by(codigo_local) %>% 
  summarise(total_dias= n_distinct(fecha_operacion)) 

opdiarias_xts <- opdiarias_rv %>% 
  select("codigo_local"= `Cód. Local`, Precio,  fecha_operacion) %>% 
  filter(codigo_local %in% c("CP1EX201", "CP1JF201")) 
 
opdiarias_xts <-  unique(opdiarias_xts)

CP1EX201 <- opdiarias_xts %>% filter(codigo_local %in% c("CP1EX201")) %>% 
  select(fecha_operacion, Precio) %>% 
  mutate(fecha_operacion= as.Date(fecha_operacion), 
         Precio= as.numeric(Precio)) %>% 
  group_by(fecha_operacion) %>% 
  summarise(Open= mean(Precio, na.rm= TRUE),
            High= max(Precio), 
            Low= min(Precio), 
            Close= mean(Precio, na.rm= TRUE))

CP1EX201 <- xts(CP1EX201$High, order.by= CP1EX201$fecha_operacion)
colnames(CP1EX201)[1] <- "CP1EX201"
retornos_diarios <- dailyReturn(CP1EX201)
chartSeries(retornos_diarios, theme="white", name = "Retornos Diarios de META")


# opdiarias_xts <- opdiarias_xts%>%
#   pivot_wider(id_cols= fecha_operacion, names_from = codigo_local, values_from =Precio)