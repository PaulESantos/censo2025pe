# Limpiar texto para comparaciones insensibles a mayúsculas y acentos

Limpiar texto para comparaciones insensibles a mayúsculas y acentos

## Usage

``` r
limpiar_texto(x)
```

## Arguments

- x:

  Vector de caracteres.

## Value

Vector de caracteres limpio, en mayúsculas, sin acentos y recortado.

## Examples

``` r
limpiar_texto("Áncash ")
#> [1] "ANCASH"
```
