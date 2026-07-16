#' Limpiar texto para comparaciones insensibles a mayúsculas y acentos
#'
#' @param x Vector de caracteres.
#' @return Vector de caracteres limpio, en mayúsculas, sin acentos y recortado.
#' @export
#' @examples
#' limpiar_texto("Áncash ")
limpiar_texto <- function(x) {
  if (is.null(x)) return(NULL)
  x <- as.character(x)
  # A may\u00fasculas y recortar espacios
  x <- toupper(trimws(x))
  # Reemplazar vocales con acentos
  x <- chartr("\u00c1\u00c9\u00cd\u00d3\u00da\u00d1\u00dc", "AEIOUNU", x)
  # Eliminar prefijos comunes de geograf\u00eda si el usuario los escribe
  x <- gsub("^PROVINCIA\\s+", "", x)
  x <- gsub("^PROV\\.\\s+", "", x)
  x <- gsub("^DISTRITO\\s+", "", x)
  x <- trimws(x)
  x
}

#' Obtener lista única de departamentos disponibles
#'
#' @return Vector con los nombres de departamentos.
#' @export
listar_departamentos <- function() {
  # Cargar datos internos si no est\u00e1n cargados
  # Usamos censo_educacion como referencia
  unique(censo2025pe::censo_educacion$departamento)
}

#' Obtener lista única de provincias disponibles
#'
#' @param depto Opcional. Filtrar provincias por departamento.
#' @return Vector con los nombres de provincias.
#' @export
listar_provincias <- function(depto = NULL) {
  df <- censo2025pe::censo_educacion
  if (!is.null(depto)) {
    depto_clean <- limpiar_texto(depto)
    df <- df[limpiar_texto(df$departamento) == depto_clean, ]
  }
  provs <- unique(df$provincia)
  # Excluir la categor\u00eda "Total" que representa el agregado del departamento
  provs <- provs[provs != "Total"]
  provs
}

#' Validar y estandarizar el nombre de una unidad censal
#'
#' @param unidad Nombre de la unidad (ej. "Lima", "Chachapoyas", "Peru").
#' @return Una lista con:
#'   \item{matched}{Boolean indicando si se encontró coincidencia.}
#'   \item{tipo}{"nacional", "departamento", "provincia" o NULL.}
#'   \item{nombre}{Nombre estandarizado de la unidad tal como figura en los datos.}
#'   \item{departamento}{Si es provincia, el departamento al que pertenece.}
#' @export
buscar_unidad <- function(unidad) {
  if (is.null(unidad) || length(unidad) == 0 || unidad == "") {
    return(list(matched = FALSE, tipo = NULL, nombre = NULL, departamento = NULL))
  }
  
  unidad_clean <- limpiar_texto(unidad)
  
  # 1. Caso especial: Nacional
  if (unidad_clean %in% c("PERU", "NACIONAL", "TODO EL PAIS")) {
    return(list(matched = TRUE, tipo = "nacional", nombre = "PER\u00da", departamento = NULL))
  }
  
  # 2. Buscar en departamentos
  deptos <- listar_departamentos()
  deptos_clean <- limpiar_texto(deptos)
  idx_depto <- which(deptos_clean == unidad_clean)
  
  if (length(idx_depto) > 0) {
    return(list(
      matched = TRUE,
      tipo = "departamento",
      nombre = deptos[idx_depto[1]],
      departamento = NULL
    ))
  }
  
  # 3. Buscar en provincias
  # Obtenemos un mapeo de provincias a departamentos
  df_geo <- unique(censo2025pe::censo_educacion[, c("departamento", "provincia")])
  df_geo <- df_geo[df_geo$provincia != "Total", ]
  
  provs_clean <- limpiar_texto(df_geo$provincia)
  idx_prov <- which(provs_clean == unidad_clean)
  
  if (length(idx_prov) > 0) {
    return(list(
      matched = TRUE,
      tipo = "provincia",
      nombre = df_geo$provincia[idx_prov[1]],
      departamento = df_geo$departamento[idx_prov[1]]
    ))
  }
  
  # No hubo coincidencias
  # Buscar coincidencia parcial (fuzzy match)
  idx_depto_partial <- which(grepl(unidad_clean, deptos_clean))
  if (length(idx_depto_partial) > 0) {
    return(list(
      matched = TRUE,
      tipo = "departamento",
      nombre = deptos[idx_depto_partial[1]],
      departamento = NULL
    ))
  }
  
  idx_prov_partial <- which(grepl(unidad_clean, provs_clean))
  if (length(idx_prov_partial) > 0) {
    return(list(
      matched = TRUE,
      tipo = "provincia",
      nombre = df_geo$provincia[idx_prov_partial[1]],
      departamento = df_geo$departamento[idx_prov_partial[1]]
    ))
  }
  
  # Sin resultados
  return(list(matched = FALSE, tipo = NULL, nombre = unidad, departamento = NULL))
}

# Declarar variables globales para silenciar advertencias de enlace de variables globales no visibles en R CMD check
utils::globalVariables(c(
  "departamento", "provincia", "area", "sexo", "grupo_edad", 
  "nivel_educativo", "poblacion", "poblacion_plot", "porcentaje", 
  "grupo_etnico", "tipo_seguro", "tipo_vivienda", "condicion_ocupacion", 
  "valor", "procedencia_agua", "numero_hogares", "equipo_hogar", 
  "viviendas", "agua_label", "etnia_label", "nivel_label", "cantidad",
  "Unidad", "Tipo", "Hombres", "Mujeres", "Poblaci\u00f3n Total", "hogares"
))
