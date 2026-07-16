library(rmarkdown)

# Buscar y configurar Pandoc si no est\u00e1 en el PATH
configurar_pandoc <- function() {
  if (rmarkdown::pandoc_available()) return(TRUE)
  
  candidatos <- c(
    "C:/Users/PC/AppData/Local/Programs/Quarto/bin/tools",
    "C:/Program Files/Quarto/bin/tools",
    "C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools"
  )
  
  for (path in candidatos) {
    if (dir.exists(path) && file.exists(file.path(path, "pandoc.exe"))) {
      Sys.setenv(RSTUDIO_PANDOC = path)
      return(TRUE)
    }
  }
  FALSE
}

#' Generar un reporte estadístico para una unidad censal
#'
#' Renderiza un reporte detallado en HTML o PDF conteniendo gráficos y tablas
#' sobre demografía, educación, discapacidad, etnicidad y vivienda.
#'
#' @param unidad Nombre de la unidad (ej. "AMAZONAS", "CHACHAPOYAS" o "PERÚ").
#' @param formato Formato de salida ("html" o "pdf").
#' @param output_file Nombre opcional del archivo de salida.
#' @param output_dir Directorio donde guardar el archivo. Por defecto es el directorio de trabajo actual.
#' @return La ruta del archivo generado.
#' @export
#' @examples
#' \dontrun{
#' generar_reporte("AMAZONAS", formato = "html")
#' }
generar_reporte <- function(unidad, formato = c("html", "pdf"), output_file = NULL, output_dir = ".") {
  formato <- match.arg(formato)
  
  # Configurar pandoc si es necesario
  configurar_pandoc()
  
  # Validar unidad
  res_geo <- buscar_unidad(unidad)
  if (!res_geo$matched) {
    stop("No se encontr\u00f3 la unidad censal especificada: ", unidad)
  }
  
  # Encontrar plantilla Rmd en el paquete
  template_path <- system.file("reporte_unidad.Rmd", package = "censo2025pe")
  if (template_path == "") {
    # Para desarrollo local si no se ha instalado el paquete
    template_path <- "inst/reporte_unidad.Rmd"
    if (!file.exists(template_path)) {
      stop("No se pudo encontrar la plantilla del reporte en 'inst/reporte_unidad.Rmd'.")
    }
  }
  
  # Nombre de salida por defecto
  if (is.null(output_file)) {
    nombre_seguro <- gsub("[^A-Za-z0-9]", "_", res_geo$nombre)
    ext <- if (formato == "pdf") ".pdf" else ".html"
    output_file <- paste0("reporte_", tolower(res_geo$tipo), "_", tolower(nombre_seguro), ext)
  }
  
  # Renderizar
  cat("Generando reporte en formato", formato, "para", res_geo$nombre, "...\n")
  out <- rmarkdown::render(
    input = template_path,
    output_format = if (formato == "pdf") "pdf_document" else "html_document",
    output_file = output_file,
    output_dir = output_dir,
    params = list(unidad = res_geo$nombre),
    envir = new.env(parent = globalenv()),
    quiet = TRUE
  )
  
  cat("\u00a1Reporte generado con \u00e9xito en:", out, "\n")
  invisible(out)
}

#' Generar un reporte comparativo entre múltiples unidades censales
#'
#' Renderiza un reporte en HTML o PDF que compara los indicadores clave
#' del Censo 2025 de las unidades especificadas.
#'
#' @param unidades Vector de caracteres con las unidades a comparar (ej. `c("AMAZONAS", "AREQUIPA")`).
#' @param formato Formato de salida ("html" o "pdf").
#' @param output_file Nombre opcional del archivo de salida.
#' @param output_dir Directorio donde guardar el archivo.
#' @return La ruta del archivo generado.
#' @export
#' @examples
#' \dontrun{
#' comparar_unidades(c("AMAZONAS", "AREQUIPA"), formato = "html")
#' }
comparar_unidades <- function(unidades, formato = c("html", "pdf"), output_file = NULL, output_dir = ".") {
  formato <- match.arg(formato)
  
  # Configurar pandoc si es necesario
  configurar_pandoc()
  
  if (length(unidades) < 2) {
    stop("Se deben especificar al menos 2 unidades censales para realizar una comparaci\u00f3n.")
  }
  
  # Validar y estandarizar unidades
  unidades_est <- character()
  for (uni in unidades) {
    res_geo <- buscar_unidad(uni)
    if (!res_geo$matched) {
      stop("No se encontr\u00f3 la unidad censal especificada: ", uni)
    }
    unidades_est <- c(unidades_est, res_geo$nombre)
  }
  
  # Encontrar plantilla comparativa
  template_path <- system.file("reporte_comparativo.Rmd", package = "censo2025pe")
  if (template_path == "") {
    template_path <- "inst/reporte_comparativo.Rmd"
    if (!file.exists(template_path)) {
      stop("No se pudo encontrar la plantilla del reporte comparativo en 'inst/reporte_comparativo.Rmd'.")
    }
  }
  
  # Nombre de salida
  if (is.null(output_file)) {
    uni_labels <- tolower(gsub("[^A-Za-z0-9]", "_", unidades_est))
    ext <- if (formato == "pdf") ".pdf" else ".html"
    output_file <- paste0("comparativo_", paste(uni_labels, collapse = "_vs_"), ext)
  }
  
  cat("Generando reporte comparativo en formato", formato, "para:", paste(unidades_est, collapse = ", "), "...\n")
  out <- rmarkdown::render(
    input = template_path,
    output_format = if (formato == "pdf") "pdf_document" else "html_document",
    output_file = output_file,
    output_dir = output_dir,
    params = list(unidades = unidades_est),
    envir = new.env(parent = globalenv()),
    quiet = TRUE
  )
  
  cat("\u00a1Reporte comparativo generado con \u00e9xito en:", out, "\n")
  invisible(out)
}
