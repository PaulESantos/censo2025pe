# Generar un reporte estadístico para una unidad censal

Renderiza un reporte detallado en HTML o PDF conteniendo gráficos y
tablas sobre demografía, educación, discapacidad, etnicidad y vivienda.

## Usage

``` r
generar_reporte(
  unidad,
  formato = c("html", "pdf"),
  output_file = NULL,
  output_dir = "."
)
```

## Arguments

- unidad:

  Nombre de la unidad (ej. "AMAZONAS", "CHACHAPOYAS" o "PERÚ").

- formato:

  Formato de salida ("html" o "pdf").

- output_file:

  Nombre opcional del archivo de salida.

- output_dir:

  Directorio donde guardar el archivo. Por defecto es el directorio de
  trabajo actual.

## Value

La ruta del archivo generado.

## Examples

``` r
if (FALSE) { # \dontrun{
generar_reporte("AMAZONAS", formato = "html")
} # }
```
