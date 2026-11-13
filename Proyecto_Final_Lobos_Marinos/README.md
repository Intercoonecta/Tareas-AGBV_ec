# Análisis exploratorio de la abundancia y reproducción del lobo marino de Galápagos en islote Caamaño (2003–2023)

**Proyecto final — Día 5 | Análisis de datos con R**

## 1. Descripción del proyecto

Este mini proyecto utiliza el lenguaje de programación **R** para explorar registros de censos de la colonia de lobos marinos de Galápagos (*Zalophus wollebaeki*) de **islote Caamaño**, en el archipiélago de Galápagos, Ecuador, durante las temporadas reproductivas de **2003 a 2023**. El propósito es describir la abundancia observada de distintas categorías de edad y sexo, visualizar sus cambios a lo largo del período y explorar la relación entre el promedio de hembras adultas observadas y el número de nacimientos registrados.

Se trata de un **análisis exploratorio y descriptivo**, no de una estimación independiente del tamaño poblacional total ni de las tasas de mortalidad o supervivencia.

## 2. Objetivos

- Cargar y explorar una matriz de datos científicos en formato CSV.
- Describir la variación temporal de la abundancia media observada de machos adultos, hembras adultas, adultos sin sexo identificado, juveniles y crías.
- Comparar los promedios por categoría de edad durante las 21 temporadas reproductivas.
- Visualizar los nacimientos registrados por temporada y explorar su relación con la abundancia media de hembras adultas.
- Crear y reutilizar funciones propias en R para cálculos y visualizaciones.

## 3. Fuente y estructura de los datos

**Fuente:** Childs, A. K., Stainfield, C., Stoehr, S., Twiss, S. D. y Krüger, O. (2026). *Pupping and yearling survival in Galápagos Sea Lions: impact of maternal investment, environmental fluctuations and population decline* [conjunto de datos]. Dryad. https://doi.org/10.5061/dryad.zs7h44jr0

Se utilizó el archivo `Datos/census_avg.csv`, que tiene **37 registros y 25 variables**. Para la comparación anual se extrajo **un registro por temporada reproductiva**, obteniendo 21 temporadas (2003–2023). El año mostrado en los gráficos corresponde al **inicio de la temporada reproductiva**, cuyo calendario va del 1 de julio al 30 de junio del año siguiente, según la documentación del conjunto de datos.

Variables principales:

| Variable | Significado |
|---|---|
| `SeasonOfRound` | Identificador de la temporada reproductiva |
| `SeasonOfRound_YearStart` | Año en que comienza la temporada reproductiva |
| `Females_avg` | Promedio de hembras adultas observadas |
| `Males_avg` | Promedio de machos adultos observados |
| `Adults_avg` | Promedio de adultos sin identificación positiva y/o cuyo sexo no pudo determinarse |
| `All_Adults_avg` | Promedio de todos los adultos observados |
| `Juveniles_avg` | Promedio de juveniles observados |
| `Pups_avg` | Promedio de crías observadas |
| `n_counts` | Número total de nacimientos registrados durante la temporada reproductiva |

De acuerdo con la documentación, las categorías corresponden a **adultos (5 años o más)**, **juveniles (6 meses a 4 años)** y **crías (0 a 6 meses)**. Los promedios de censos no equivalen necesariamente a individuos distintos ni a la población total de Galápagos.

## 4. Herramientas y funciones utilizadas

El análisis se realizó en **RStudio** con funciones de R base, sin necesidad de paquetes adicionales para las visualizaciones principales.

| Función | Uso en el proyecto |
|---|---|
| `read.csv()` | Importar la base de datos |
| `head()`, `dim()`, `names()`, `str()` | Explorar filas, dimensiones, variables y estructura |
| `duplicated()` | Seleccionar una observación por temporada reproductiva |
| `order()` | Ordenar cronológicamente las observaciones |
| `plot()` y `lines()` | Crear gráficos temporales y de dispersión |
| `barplot()` y `text()` | Comparar promedios y mostrar valores sobre las barras |
| `cor.test(..., method = "spearman")` | Explorar la asociación monotónica entre hembras y nacimientos |
| `png()` y `dev.off()` | Exportar figuras a archivos PNG |
| `source()` | Cargar funciones definidas en otro archivo R |

### Funciones propias

Se desarrollaron **dos funciones propias** en `R/funciones_lobos_marinos.R`:

**`Media(x)`** calcula la media aritmética de un vector, excluyendo valores faltantes:

```r
Media <- function(x) {
  x <- x[!is.na(x)]
  resultado <- sum(x) / length(x)
  return(resultado)
}
```

**`graficar_abundancia(datos, variable, titulo, color)`** ordena los registros por temporada y permite crear gráficos de variación temporal de diferentes categorías cambiando solamente la columna, el título y el color. Su definición completa está en `R/funciones_lobos_marinos.R`.

Ejemplo de reutilización:

```r
source("R/funciones_lobos_marinos.R")
graficar_abundancia(
  anuales, "Females_avg",
  "Variación temporal de la abundancia de hembras adultas (2003-2023)",
  "purple"
)
```

### Preparación de los datos

```r
lobos <- read.csv("Datos/census_avg.csv")
head(lobos)
dim(lobos)
names(lobos)
str(lobos)

anuales <- lobos[!duplicated(lobos$SeasonOfRound), ]
anuales <- anuales[, c(
  "SeasonOfRound_YearStart", "All_Adults_avg",
  "Females_avg", "Males_avg", "Adults_avg",
  "Juveniles_avg", "Pups_avg"
)]
anuales <- anuales[order(anuales$SeasonOfRound_YearStart), ]
```

## 5. Figuras y explicación de los resultados

Las figuras se generan con `graficar_abundancia()`, `plot()`, `lines()` o `barplot()`, y se exportan con `png()` / `dev.off()`. **El código completo de cada figura se conserva en `analisis_lobos_marinos.R`.**

### Figura 1. Hembras adultas

![Variación temporal de hembras adultas](Figuras/01_hembras_adultas.png)

Muestra el promedio de hembras adultas observadas en cada temporada reproductiva. Permite apreciar fluctuaciones interanuales y comparar los registros iniciales y finales del período. **Código:** `graficar_abundancia(anuales, "Females_avg", ..., "purple")`.

### Figura 2. Machos adultos

![Variación temporal de machos adultos](Figuras/02_machos_adultos.png)

Representa los promedios de machos adultos observados por temporada. Facilita la descripción de su comportamiento temporal, sin asumir que los censos registraron todos los machos existentes. **Código:** `graficar_abundancia(anuales, "Males_avg", ..., "royalblue")`.

### Figura 3. Adultos sin sexo identificado

![Variación temporal de adultos sin sexo identificado](Figuras/03_adultos_sin_sexo_identificado.png)

Presenta los adultos sin identificación positiva y/o cuyo sexo no pudo determinarse. Es una categoría metodológica de observación, no un sexo biológico adicional. **Código:** `graficar_abundancia(anuales, "Adults_avg", ..., "brown")`.

### Figura 4. Juveniles

![Variación temporal de juveniles](Figuras/04_juveniles.png)

Describe la abundancia media observada de juveniles a lo largo del período. Las diferencias respecto de las crías no constituyen por sí mismas estimaciones de supervivencia juvenil. **Código:** `graficar_abundancia(anuales, "Juveniles_avg", ..., "darkgreen")`.

### Figura 5. Crías

![Variación temporal de crías](Figuras/05_crias.png)

Muestra las fluctuaciones del promedio de crías observadas por temporada. Este promedio difiere del número total de nacimientos del período, que se presenta por separado. **Código:** `graficar_abundancia(anuales, "Pups_avg", ..., "orange")`.

### Figura 6. Todos los adultos

![Variación temporal de todos los adultos](Figuras/06_todos_los_adultos.png)

Integra machos adultos, hembras adultas y adultos sin identificación positiva y/o sin sexo determinado mediante la variable `All_Adults_avg`. **Código:** `graficar_abundancia(anuales, "All_Adults_avg", ..., "steelblue")`.

### Figura 7. Comparación de abundancia media por edad

![Promedios por categoría de edad](Figuras/07_comparacion_abundancia_promedio.png)

Resume las 21 temporadas en un único valor por categoría. Los promedios calculados fueron **72,24 adultos**, **16,48 juveniles** y **39,71 crías** por temporada reproductiva. Los adultos registraron el promedio más alto. Las tres categorías no se superponen.

**Código principal:**

```r
promedios <- c(
  Adultos = Media(anuales$All_Adults_avg),
  Juveniles = Media(anuales$Juveniles_avg),
  Crias = Media(anuales$Pups_avg)
)
barras <- barplot(promedios,
                  col = c("steelblue", "darkgreen", "orange"),
                  ylim = c(0, max(promedios) * 1.25))
text(barras, promedios, labels = round(promedios, 2), pos = 3)
```

### Figura 8. Nacimientos registrados

![Variación temporal de nacimientos](Figuras/08_variacion_temporal_nacimientos.png)

Presenta el **número total de nacimientos registrados** en cada temporada (`n_counts`). A diferencia de las figuras de abundancia, su eje vertical muestra conteos de nacimientos, no promedios de individuos presentes durante un censo. **Código:** `plot(nacimientos$SeasonOfRound_YearStart, nacimientos$n_counts, type = "b", ...)`.

### Figura 9. Comparación temporal de categorías de edad

![Comparación temporal de adultos, juveniles y crías](Figuras/09_comparacion_temporal_categorias.png)

Permite comparar simultáneamente los promedios de adultos, juveniles y crías en cada temporada. Se observan diferencias y fluctuaciones entre las categorías; este gráfico no representa porcentajes ni permite calcular directamente tasas vitales. **Código:** `plot(... All_Adults_avg ...)` seguido de `lines(... Juveniles_avg ...)` y `lines(... Pups_avg ...)`.

### Figura 10 del informe. Relación entre hembras adultas y nacimientos

![Relación entre hembras y nacimientos](Figuras/11_relacion_hembras_nacimientos.png)

Es un gráfico de dispersión en el que cada punto representa una temporada reproductiva. Se explora si las temporadas con mayor promedio de hembras adultas observadas presentaron también un mayor número de nacimientos registrados. El coeficiente de **Spearman fue ρ = 0,1144** y su valor **p = 0,6216** (21 temporadas), por lo que **no se observó una asociación monotónica clara** en este análisis exploratorio.

**Código principal:**

```r
plot(datos_reproduccion$Females_avg,
     datos_reproduccion$n_counts,
     pch = 19, col = "purple",
     xlab = "Promedio de hembras adultas observadas",
     ylab = "Número de nacimientos registrados")

cor.test(datos_reproduccion$Females_avg,
         datos_reproduccion$n_counts,
         method = "spearman", exact = FALSE)
```

**Nota sobre la numeración:** el archivo de esta figura se denomina `11_relacion_hembras_nacimientos.png` porque se generó después de una regresión exploratoria que finalmente no se incluyó entre los resultados principales. El archivo `10_tendencia_lineal_adultos.png` se mantiene únicamente como material exploratorio y no es necesario presentarlo.

## 6. Principales resultados

El análisis de los promedios de abundancia por categoría de edad mostró una mayor abundancia media observada de adultos (**72,24**) que de crías (**39,71**) y juveniles (**16,48**). Las series temporales permiten apreciar variaciones considerables entre temporadas y valores relativamente bajos hacia el final del período en varias categorías. Los gráficos de hembras, machos y adultos no identificados permiten describir por separado los componentes adultos registrados durante los censos.

La comparación de nacimientos con la abundancia media de hembras adultas no evidenció una asociación monotónica clara mediante la correlación exploratoria de Spearman (ρ = 0,1144; p = 0,6216). Esto no demuestra ausencia de relación biológica: la cantidad de hembras observadas no equivale necesariamente al número de hembras reproductoras y pueden existir diferencias de esfuerzo de muestreo o dependencia temporal entre temporadas.

## 7. Conclusiones

1. R permitió organizar y explorar registros de 21 temporadas reproductivas de *Zalophus wollebaeki* en isla Caamaño mediante funciones propias y visualizaciones reproducibles.
2. Los adultos presentaron la mayor abundancia media observada (72,24 individuos por temporada), seguidos de crías (39,71) y juveniles (16,48).
3. Los gráficos temporales mostraron fluctuaciones entre temporadas y permitieron identificar diferencias entre las categorías observadas, pero **no permiten estimar directamente mortalidad, supervivencia ni causas de variación poblacional**.
4. La asociación exploratoria entre hembras adultas observadas y nacimientos registrados fue muy débil (Spearman ρ = 0,1144; p = 0,6216), por lo que no se identificó una relación monotónica clara con las variables utilizadas.
5. El ejercicio permitió practicar importación, exploración, selección, cálculo, construcción de funciones propias, visualización y exportación de resultados mediante R.

## 8. Organización y reproducción del proyecto

```text
Proyecto final/
├── README.md
├── Datos/
│   └── census_avg.csv
├── Figuras/
│   ├── 01_hembras_adultas.png
│   ├── 02_machos_adultos.png
│   ├── 03_adultos_sin_sexo_identificado.png
│   ├── 04_juveniles.png
│   ├── 05_crias.png
│   ├── 06_todos_los_adultos.png
│   ├── 07_comparacion_abundancia_promedio.png
│   ├── 08_variacion_temporal_nacimientos.png
│   ├── 09_comparacion_temporal_categorias.png
│   └── 11_relacion_hembras_nacimientos.png
├── R/
│   └── funciones_lobos_marinos.R
├── analisis_lobos_marinos.R
└── notebook.ipynb                 # Recomendado por la consigna; verificar antes de entregar
```

Para reproducir el análisis desde RStudio:

1. Abrir la carpeta **Proyecto final** como directorio de trabajo.
2. Verificar que los archivos `Datos/census_avg.csv` y `R/funciones_lobos_marinos.R` estén presentes.
3. Ejecutar el archivo `analisis_lobos_marinos.R` desde el inicio, después de retirar o separar cualquier bloque exploratorio descartado que dependa de objetos no creados.
4. Consultar las imágenes exportadas en `Figuras/`.

El archivo `notebook.ipynb` es parte de la **estructura recomendada** de la consigna. Antes de entregar se debe verificar que exista, contenga el análisis final y pueda ejecutarse. Si se entrega únicamente el script `.R`, confirmar que el docente lo acepte en lugar del notebook.

## 9. Referencia

Childs, A. K., Stainfield, C., Stoehr, S., Twiss, S. D., & Krüger, O. (2026). *Pupping and yearling survival in Galápagos Sea Lions: impact of maternal investment, environmental fluctuations and population decline* [Dataset]. Dryad. https://doi.org/10.5061/dryad.zs7h44jr0
