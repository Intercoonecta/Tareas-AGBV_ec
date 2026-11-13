
# PROYECTO FINAL - OCEANHACKWEEK 2026
# Analisis de lobos marinos de Galapagos
# Especie: Zalophus wollebaeki

# Funcion 1: calcular el promedio
Media <- function(x) {
  
  # Eliminar datos faltantes
  x <- x[!is.na(x)]
  
  # Calcular el promedio
  resultado <- sum(x) / length(x)
  
  return(resultado)
}


# Funcion 2: elaborar graficos de abundancia
graficar_abundancia <- function(datos, variable, titulo, color) {
  
  # Ordenar los datos por año
  datos <- datos[order(datos$SeasonOfRound_YearStart), ]
  
  # Seleccionar las variables
  anio <- datos$SeasonOfRound_YearStart
  abundancia <- datos[[variable]]
  
  # Crear el grafico
  plot(
    anio,
    abundancia,
    type = "b",
    col = color,
    pch = 19,
    lwd = 2,
    xlab = "Año de inicio de la temporada reproductiva",
    ylab = "Promedio de individuos observados",
    main = titulo
  )
  
  # Agregar cuadricula
  grid()
}
