


secuencia <- seq(from=1, to=7, by=1)

##If 

x <- 5 
if (x>=5) {
  print("x es mayor a 5")
} else {
  print("x es menor a 5")
}

##for
for (numero in secuencia) { 
  if (numero >= 1) {
    suma_2 <- numero + 2
    print(suma_2)
  } else {
    print('no aplica')
  }
  }

##while 
while (secuencia <4) { 
  cuentame <- secuencia +1 
  print(cuentame)
  }

##defino un contador 
contador <- 0 

while (contador <4) { 
  cuentame <- secuencia +1 
  contador <- contador + 1 
  print(cuentame)
}

















