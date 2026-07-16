# Validar y estandarizar el nombre de una unidad censal

Validar y estandarizar el nombre de una unidad censal

## Usage

``` r
buscar_unidad(unidad)
```

## Arguments

- unidad:

  Nombre de la unidad (ej. "Lima", "Chachapoyas", "Peru").

## Value

Una lista con:

- matched:

  Boolean indicando si se encontró coincidencia.

- tipo:

  "nacional", "departamento", "provincia" o NULL.

- nombre:

  Nombre estandarizado de la unidad tal como figura en los datos.

- departamento:

  Si es provincia, el departamento al que pertenece.
