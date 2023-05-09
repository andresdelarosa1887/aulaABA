


##Vectores
vector_1 <- c(1,2,3,4,5,6)
vector_2 <- c(TRUE, FALSE, TRUE)
vector_3 <- c("mi", "nombre", "es", "andres")
vector_4 <- c(1,2, "andres")

secuencia <- seq(from=1, to=7, by=1)


##Matrices
matriz_1 <- matrix(c(1,2,3,4,5,6,7,8,9), nrow=3, ncol= 3)
matriz_2 <- matrix(c(1,2,3,4,5,6,7,8,9), nrow=3, ncol= 3)
matriz_1 + matriz_2

matriz_logica <- matrix(c(TRUE, FALSE, TRUE, TRUE), nrow=2, ncol= 2)
matriz_logica


##data frame
data_frame_1 <- data.frame(
  nombre= c("andres", "jorge", "maria"),
  edad= seq(from=31, to=33, by=1), 
  casado= c(TRUE, TRUE, FALSE)
)

data_frame_1


##Listas
mi_primera_lista <- list(
  matriz=  matriz_1, 
  data= data_frame_1,
  vector=  vector_1, 
  otro_vector= vector_2
)

mi_primera_lista$matriz
mi_primera_lista[[4]]



