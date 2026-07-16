# Población censada por tipo de discapacidad (Censo 2025)

Dataset ordenado (tidy long format) con la población de 5 y más años de
edad según su condición y tipo de discapacidad.

## Usage

``` r
censo_discapacidad
```

## Format

Un objeto tibble con 436 filas y 7 columnas:

- departamento:

  Nombre del departamento (o "PERÚ" para el total nacional).

- provincia:

  Nombre de la provincia (o "Total" para el consolidado).

- area:

  Área de residencia ("Total", "Urbana", "Rural").

- sexo:

  Sexo de la población ("Total", "Hombre", "Mujer").

- grupo_edad:

  Grupos de edad de la población.

- tipo_discapacidad:

  Tipo de dificultad ("ver", "oir", "hablar", "caminar",
  "usar_brazos_manos", "recordar_concentrarse", "relacionarse_demas",
  "ninguna", "total").

- poblacion:

  Cantidad de personas censadas.

## Source

Instituto Nacional de Estadística e Informática (INEI) - Censos
Nacionales 2025.
