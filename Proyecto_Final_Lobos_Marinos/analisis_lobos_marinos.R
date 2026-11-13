
# PROYECTO FINAL
# Analisis de la abundancia del lobo marino de Galapagos
# Isla Caamano, 2003-2023

# 1. Cargar las funciones propias
source("R/funciones_lobos_marinos.R")

# 2. Cargar los datos
lobos <- read.csv("Datos/census_avg.csv")

# 3. Exploracion inicial
head(lobos)
dim(lobos)
names(lobos)
str(lobos)

# 4. Seleccionar un registro por temporada reproductiva
anuales <- lobos[!duplicated(lobos$SeasonOfRound), ]

# 5. Seleccionar las variables de interes
anuales <- anuales[, c(
  "SeasonOfRound_YearStart",
  "All_Adults_avg",
  "Females_avg",
  "Males_avg",
  "Adults_avg",
  "Juveniles_avg",
  "Pups_avg"
)]

# 6. Ordenar los registros por año
anuales <- anuales[
  order(anuales$SeasonOfRound_YearStart),
]

# 7. Comprobar los datos seleccionados
dim(anuales)
head(anuales)


# Calculo de promedios de abundancia

promedio_hembras <- Media(anuales$Females_avg)
promedio_machos <- Media(anuales$Males_avg)
promedio_adultos_no_identificados <- Media(anuales$Adults_avg)
promedio_juveniles <- Media(anuales$Juveniles_avg)
promedio_crias <- Media(anuales$Pups_avg)

# Mostrar resultados
cat("Promedio de hembras adultas:",
    round(promedio_hembras, 2), "\n")

cat("Promedio de machos adultos:",
    round(promedio_machos, 2), "\n")

cat("Promedio de adultos sin sexo identificado:",
    round(promedio_adultos_no_identificados, 2), "\n")

cat("Promedio de juveniles:",
    round(promedio_juveniles, 2), "\n")

cat("Promedio de crias:",
    round(promedio_crias, 2), "\n")


# Grafico 1. Variacion temporal de hembras adultas

graficar_abundancia(
  anuales,
  "Females_avg",
  "Variación temporal de la abundancia de hembras adultas (2003-2023)",
  "purple"
)

# Grafico 2. Variacion temporal de machos adultos

graficar_abundancia(
  anuales,
  "Males_avg",
  "Variación temporal de la abundancia de machos adultos (2003-2023)",
  "royalblue"
)

# Grafico 3. Variacion temporal de adultos sin sexo identificado

graficar_abundancia(
  anuales,
  "Adults_avg",
  "Variación temporal de adultos sin sexo identificado (2003-2023)",
  "brown"
)

# Grafico 4. Variacion temporal de juveniles

graficar_abundancia(
  anuales,
  "Juveniles_avg",
  "Variación temporal de la abundancia de juveniles (2003-2023)",
  "darkgreen"
)

# Grafico 5. Variacion temporal de crias

graficar_abundancia(
  anuales,
  "Pups_avg",
  "Variación temporal de la abundancia de crías (2003-2023)",
  "orange"
)

# =====================================================
# GUARDAR FIGURAS
# =====================================================

# Grafico 1. Hembras adultas

png("Figuras/01_hembras_adultas.png",
    width = 1200, height = 800, res = 130)

graficar_abundancia(
  anuales,
  "Females_avg",
  "Variación temporal de la abundancia de hembras adultas (2003-2023)",
  "purple"
)

dev.off()


# Grafico 2. Machos adultos

png("Figuras/02_machos_adultos.png",
    width = 1200, height = 800, res = 130)

graficar_abundancia(
  anuales,
  "Males_avg",
  "Variación temporal de la abundancia de machos adultos (2003-2023)",
  "royalblue"
)

dev.off()


# Grafico 3. Adultos sin sexo identificado

png("Figuras/03_adultos_sin_sexo_identificado.png",
    width = 1200, height = 800, res = 130)

graficar_abundancia(
  anuales,
  "Adults_avg",
  "Variación temporal de adultos sin sexo identificado (2003-2023)",
  "brown"
)

dev.off()


# Grafico 4. Juveniles

png("Figuras/04_juveniles.png",
    width = 1200, height = 800, res = 130)

graficar_abundancia(
  anuales,
  "Juveniles_avg",
  "Variación temporal de la abundancia de juveniles (2003-2023)",
  "darkgreen"
)

dev.off()


# Grafico 5. Crias

png("Figuras/05_crias.png",
    width = 1200, height = 800, res = 130)

graficar_abundancia(
  anuales,
  "Pups_avg",
  "Variación temporal de la abundancia de crías (2003-2023)",
  "orange"
)

dev.off()


# Comprobar los archivos guardados
list.files("Figuras")


# Grafico 6. Variacion temporal de todos los adultos

graficar_abundancia(
  anuales,
  "All_Adults_avg",
  "Variación temporal de la abundancia de adultos (2003-2023)",
  "steelblue"
)

# Guardar grafico 6. Todos los adultos

png("Figuras/06_todos_los_adultos.png",
    width = 1200,
    height = 800,
    res = 130)

graficar_abundancia(
  anuales,
  "All_Adults_avg",
  "Variación temporal de la abundancia de adultos (2003-2023)",
  "steelblue"
)

dev.off()

# Grafico 7. Comparacion de abundancia promedio

# Calcular los promedios por categoria
promedio_adultos <- Media(anuales$All_Adults_avg)
promedio_juveniles <- Media(anuales$Juveniles_avg)
promedio_crias <- Media(anuales$Pups_avg)

# Crear un vector con los resultados
promedios <- c(
  Adultos = promedio_adultos,
  Juveniles = promedio_juveniles,
  Crias = promedio_crias
)

# Mostrar los resultados
round(promedios, 2)


# Crear grafico 7. Comparacion de abundancia promedio

barras <- barplot(
  promedios,
  col = c("steelblue", "darkgreen", "orange"),
  main = "Comparación de abundancia promedio (2003-2023)",
  xlab = "Categoría de individuos",
  ylab = "Promedio de individuos observados",
  ylim = c(0, max(promedios) * 1.25)
)

# Mostrar los valores encima de las barras
text(
  x = barras,
  y = promedios,
  labels = round(promedios, 2),
  pos = 3,
  cex = 0.9
)


# Guardar grafico 7. Comparacion de abundancia promedio

png("Figuras/07_comparacion_abundancia_promedio.png",
    width = 1200,
    height = 800,
    res = 130)

barras <- barplot(
  promedios,
  col = c("steelblue", "darkgreen", "orange"),
  main = "Comparación de abundancia promedio (2003-2023)",
  xlab = "Categoría de individuos",
  ylab = "Promedio de individuos observados",
  ylim = c(0, max(promedios) * 1.25)
)

text(
  x = barras,
  y = promedios,
  labels = round(promedios, 2),
  pos = 3,
  cex = 0.9
)

dev.off()

# Grafico 8. Variacion temporal de los nacimientos

# Seleccionar una observacion por temporada reproductiva
nacimientos <- lobos[
  !duplicated(lobos$SeasonOfRound),
  c("SeasonOfRound_YearStart", "n_counts")
]

# Ordenar por año
nacimientos <- nacimientos[
  order(nacimientos$SeasonOfRound_YearStart),
]

# Mostrar los registros
head(nacimientos)

# Crear el grafico
plot(
  nacimientos$SeasonOfRound_YearStart,
  nacimientos$n_counts,
  type = "b",
  col = "darkred",
  pch = 19,
  lwd = 2,
  xlab = "Año de inicio de la temporada reproductiva",
  ylab = "Número de nacimientos registrados",
  main = "Variación temporal de nacimientos (2003-2023)"
)

grid()


# Guardar grafico 8. Variacion temporal de nacimientos

png("Figuras/08_variacion_temporal_nacimientos.png",
    width = 1200,
    height = 800,
    res = 130)

plot(
  nacimientos$SeasonOfRound_YearStart,
  nacimientos$n_counts,
  type = "b",
  col = "darkred",
  pch = 19,
  lwd = 2,
  xlab = "Año de inicio de la temporada reproductiva",
  ylab = "Número de nacimientos registrados",
  main = "Variación temporal de nacimientos (2003-2023)"
)

grid()

dev.off()


# Grafico 9. Comparacion temporal por categoria de edad

# Definir el limite del eje Y
limite_y <- max(
  anuales$All_Adults_avg,
  anuales$Juveniles_avg,
  anuales$Pups_avg,
  na.rm = TRUE
) * 1.15

# Graficar adultos
plot(
  anuales$SeasonOfRound_YearStart,
  anuales$All_Adults_avg,
  type = "b",
  col = "steelblue",
  pch = 19,
  lwd = 2,
  ylim = c(0, limite_y),
  xlab = "Año de inicio de la temporada reproductiva",
  ylab = "Promedio de individuos observados",
  main = "Comparación temporal por categoría de edad (2003-2023)"
)

# Agregar juveniles
lines(
  anuales$SeasonOfRound_YearStart,
  anuales$Juveniles_avg,
  type = "b",
  col = "darkgreen",
  pch = 17,
  lwd = 2
)

# Agregar crias
lines(
  anuales$SeasonOfRound_YearStart,
  anuales$Pups_avg,
  type = "b",
  col = "orange",
  pch = 15,
  lwd = 2
)

# Agregar leyenda
legend(
  "topright",
  legend = c("Adultos", "Juveniles", "Crías"),
  col = c("steelblue", "darkgreen", "orange"),
  lty = 1,
  pch = c(19, 17, 15),
  bty = "n"
)

grid()
dev.copy(
  png,
  filename = "Figuras/09_comparacion_temporal_categorias.png",
  width = 1200,
  height = 800,
  res = 130
)

dev.off()

# =====================================================
# ANALISIS ESTADISTICO
# Grafico 10. Tendencia lineal de adultos
# =====================================================

# Crear el modelo de regresion lineal
modelo_adultos <- lm(
  All_Adults_avg ~ SeasonOfRound_YearStart,
  data = anuales
)

# Mostrar los resultados estadisticos
summary(modelo_adultos)

# Crear el grafico
plot(
  anuales$SeasonOfRound_YearStart,
  anuales$All_Adults_avg,
  pch = 19,
  col = "steelblue",
  xlab = "Año de inicio de la temporada reproductiva",
  ylab = "Promedio de adultos observados",
  main = "Tendencia lineal de adultos (2003-2023)"
)

# Agregar la recta de regresion
abline(
  modelo_adultos,
  col = "red",
  lwd = 2
)

grid()

# Guardar grafico 10. Tendencia lineal de adultos

png("Figuras/10_tendencia_lineal_adultos.png",
    width = 1200,
    height = 800,
    res = 130)

plot(
  anuales$SeasonOfRound_YearStart,
  anuales$All_Adults_avg,
  pch = 19,
  col = "steelblue",
  xlab = "Año de inicio de la temporada reproductiva",
  ylab = "Promedio de adultos observados",
  main = "Tendencia lineal de adultos (2003-2023)"
)

abline(
  modelo_adultos,
  col = "red",
  lwd = 2
)

grid()

dev.off()

# Diagnostico del modelo de regresion de adultos

# Obtener residuos
residuos_adultos <- residuals(modelo_adultos)

# Grafico de residuos por año
plot(
  anuales$SeasonOfRound_YearStart,
  residuos_adultos,
  type = "b",
  pch = 19,
  col = "steelblue",
  xlab = "Año de inicio de la temporada reproductiva",
  ylab = "Residuos del modelo",
  main = "Residuos de la regresión de adultos"
)

abline(h = 0, col = "red", lty = 2)

grid()

# Autocorrelacion de los residuos
acf(
  residuos_adultos,
  main = "Autocorrelación de residuos - adultos"
)



