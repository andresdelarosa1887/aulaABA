

valor_presente <- function(valor_futuro,  tasa_de_descuento, numero_periodos) {
  pv <- valor_futuro / (1 + tasa_de_descuento)^numero_periodos
  return(pv)
} 


vector_valores_futuros <- seq(100, 1000, by=100)
vector_tasa_de_descuento <- seq(0.05, 0.09, by=0.005)
vector_periodos <- seq(1,5, by=1)


for (valor_futuro in vector_valores_futuros) { 
  for (tasa_de_descuento in vector_tasa_de_descuento) {
    for (periodos in vector_periodos){
      vector_valor_presente <- paste("Valor Futuro:", valor_futuro,
                                     "Tasa de Descuento:", tasa_de_descuento, 
                                     "Periodos:", periodos, 
                                     "Valor Presente:",
                                     valor_presente(valor_futuro, tasa_de_descuento, periodos))
      print(vector_valor_presente)
      }}}

