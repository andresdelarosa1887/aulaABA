


##Valor Presente
valor_presente <- function(valor_futuro, tasa_de_descuento, numero_de_periodos){ 
  vp <- valor_futuro / (1 + tasa_de_descuento)^numero_de_periodos
  return(vp)
  }

vector_valor_futuros <- seq(100, 1000, by= 100) 
vector_tasa_de_descuento <- seq(0.05, 0.09, by=0.005)
vector_periodos <- seq(1, 5, by=1)

for (valor_futuro in vector_valor_futuros){
  for (tasa_de_descuento in vector_tasa_de_descuento){
    for(periodos in vector_periodos){ 
      vector_valor_presente <- paste("Valor Futuro:", valor_futuro, 
                                     "Tasa de descuento:", tasa_de_descuento, 
                                     "Periodos:", periodos, 
                                     "Valor Presente:", valor_presente(
                                       valor_futuro, 
                                       tasa_de_descuento, 
                                       periodos))
      
      print(vector_valor_presente)
    }}}



##Valor futuro 
valor_futuro <- function(valor_presente, tasa_interes, numero_periodos)  { 
  vf <- valor_presente * (1+ tasa_interes)^numero_periodos
  return(vf)
  }












