# Generar un reporte comparativo entre múltiples unidades censales

Renderiza un reporte en HTML o PDF que compara los indicadores clave del
Censo 2025 de las unidades especificadas.

## Usage

``` r
comparar_unidades(
  unidades,
  formato = c("html", "pdf"),
  output_file = NULL,
  output_dir = "."
)
```

## Arguments

- unidades:

  Vector de caracteres con las unidades a comparar (ej.
  `c("AMAZONAS", "AREQUIPA")`).

- formato:

  Formato de salida ("html" o "pdf").

- output_file:

  Nombre opcional del archivo de salida.

- output_dir:

  Directorio donde guardar el archivo.

## Value

La ruta del archivo generado.

## Examples

``` r
if (FALSE) { # \dontrun{
comparar_unidades(c("AMAZONAS", "AREQUIPA"), formato = "html")
} # }
```
