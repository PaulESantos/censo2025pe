# Viviendas y ocupantes por procedencia del agua (Censo 2025)

Dataset con la distribución de viviendas y ocupantes según la
procedencia del agua en la vivienda.

## Usage

``` r
censo_servicios
```

## Format

Un objeto tibble con 3,744 filas y 7 columnas:

- departamento:

  Nombre del departamento.

- provincia:

  Nombre de la provincia.

- area:

  Área de residencia.

- tipo_vivienda:

  Tipo de vivienda.

- indicador:

  "Viviendas particulares" o "Ocupantes presentes".

- procedencia_agua:

  Procedencia ("red_publica", "pozo", "camion_cisterna", etc.).

- valor:

  Cantidad medida (viviendas o personas).

## Source

Instituto Nacional de Estadística e Informática (INEI) - Censos
Nacionales 2025.
