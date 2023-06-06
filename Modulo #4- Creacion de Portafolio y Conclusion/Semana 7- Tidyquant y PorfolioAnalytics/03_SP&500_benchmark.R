


##Obtenemos nuestro objeto con los benchmarks obtenidos en la sección anterior para continuar con el análisis
benchmark_returns <- cbind(xtsSP500_daily_returns, Retornos_FAAN_EqualWeights)

data.frame(table.AnnualizedReturns(benchmark_returns))
charts.PerformanceSummary(benchmark_returns, main= "Desempeño del SP&500 y las Acciones FAANG")
print("Ciertamente las acciones FAANG superan en retornos a el SP&500, aunque con mayor volatilidad")