#' @import ggplot2
#' @import dplyr
#' @importFrom scales comma percent
#' @importFrom stats reorder na.omit
#' @importFrom rmarkdown render
#' @importFrom purrr map_df
#' @importFrom readxl read_excel
#' @importFrom stringr str_detect str_starts
#' @importFrom tidyr pivot_longer pivot_wider
#' @importFrom knitr kable
NULL

library(ggplot2)
library(dplyr)
library(scales)

# Paleta de colores premium
PALETA_CENSO <- c(
  azul = "#1E3A8A",
  celeste = "#3B82F6",
  verde = "#10B981",
  naranja = "#F59E0B",
  rojo = "#EF4444",
  morado = "#8B5CF6",
  rosa = "#EC4899",
  gris = "#6B7280"
)

# Estilo com\u00fan para gr\u00e1ficos premium
theme_censo <- function() {
  theme_minimal(base_family = "sans") +
    theme(
      plot.title = element_text(face = "bold", size = 14, color = "#111827", margin = margin(b = 10)),
      plot.subtitle = element_text(size = 11, color = "#4B5563", margin = margin(b = 15)),
      axis.title = element_text(face = "bold", size = 10, color = "#374151"),
      axis.text = element_text(size = 9, color = "#4B5563"),
      legend.title = element_text(face = "bold", size = 10, color = "#374151"),
      legend.text = element_text(size = 9, color = "#4B5563"),
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.major.y = element_line(color = "#E5E7EB"),
      legend.position = "bottom",
      plot.margin = margin(15, 15, 15, 15)
    )
}

#' Graficar la pirámide de población de una unidad censal
#'
#' @param unidad Nombre de la unidad (ej. "AMAZONAS", "CHACHAPOYAS" o "PERÚ").
#' @return Un objeto ggplot2.
#' @export
plot_piramide_poblacion <- function(unidad) {
  res_geo <- buscar_unidad(unidad)
  if (!res_geo$matched) {
    stop("No se encontr\u00f3 la unidad censal especificada: ", unidad)
  }
  
  # Filtrar datos de educaci\u00f3n que tiene edad y sexo detallados
  df <- censo2025pe::censo_educacion
  
  if (res_geo$tipo == "nacional") {
    df <- df[df$departamento == "PER\u00da" & df$provincia == "Total" & df$area == "Total", ]
  } else if (res_geo$tipo == "departamento") {
    df <- df[df$departamento == res_geo$nombre & df$provincia == "Total" & df$area == "Total", ]
  } else {
    df <- df[df$provincia == res_geo$nombre & df$area == "Total", ]
  }
  
  # Agrupar poblaci\u00f3n por grupo de edad y sexo
  df_piramide <- df %>%
    filter(sexo %in% c("Hombre", "Mujer"), nivel_educativo == "total") %>%
    group_by(grupo_edad, sexo) %>%
    summarise(poblacion = sum(poblacion, na.rm = TRUE), .groups = "drop")
  
  # Hacer valores masculinos negativos para la pir\u00e1mide
  df_piramide <- df_piramide %>%
    mutate(poblacion_plot = ifelse(sexo == "Hombre", -poblacion, poblacion))
  
  # Orden de edad
  orden_edad <- c("De 3 a 4 a\u00f1os", "De 5 a 14 a\u00f1os", "De 15 a 24 a\u00f1os", 
                  "De 25 a 34 a\u00f1os", "De 35 a 44 a\u00f1os", "De 45 a 59 a\u00f1os", 
                  "De 60 y m\u00e1s a\u00f1os")
  df_piramide$grupo_edad <- factor(df_piramide$grupo_edad, levels = orden_edad)
  
  max_val <- max(df_piramide$poblacion, na.rm = TRUE)
  
  ggplot(df_piramide, aes(x = grupo_edad, y = poblacion_plot, fill = sexo)) +
    geom_col(width = 0.8, color = "white", linewidth = 0.2) +
    scale_y_continuous(
      labels = function(x) comma(abs(x)),
      limits = c(-max_val * 1.1, max_val * 1.1)
    ) +
    coord_flip() +
    scale_fill_manual(values = c("Hombre" = "#3B82F6", "Mujer" = "#EC4899")) +
    labs(
      title = paste("Pir\u00e1mide de Poblaci\u00f3n -", res_geo$nombre),
      subtitle = paste("Poblaci\u00f3n de 3 y m\u00e1s a\u00f1os de edad por sexo y grupo de edad"),
      x = "Grupo de edad",
      y = "Poblaci\u00f3n",
      fill = "Sexo"
    ) +
    theme_censo() +
    theme(panel.grid.major.y = element_blank(), panel.grid.major.x = element_line(color = "#E5E7EB"))
}

#' Graficar la distribución del nivel educativo alcanzado
#'
#' @param unidad Nombre de la unidad censal.
#' @return Un objeto ggplot2.
#' @export
plot_educacion <- function(unidad) {
  res_geo <- buscar_unidad(unidad)
  if (!res_geo$matched) stop("No se encontr\u00f3 la unidad: ", unidad)
  
  df <- censo2025pe::censo_educacion
  if (res_geo$tipo == "nacional") {
    df <- df[df$departamento == "PER\u00da" & df$provincia == "Total" & df$area == "Total" & df$sexo == "Total", ]
  } else if (res_geo$tipo == "departamento") {
    df <- df[df$departamento == res_geo$nombre & df$provincia == "Total" & df$area == "Total" & df$sexo == "Total", ]
  } else {
    df <- df[df$provincia == res_geo$nombre & df$area == "Total" & df$sexo == "Total", ]
  }
  
  df_edu <- df %>%
    filter(nivel_educativo != "total") %>%
    group_by(nivel_educativo) %>%
    summarise(poblacion = sum(poblacion, na.rm = TRUE), .groups = "drop") %>%
    mutate(porcentaje = poblacion / sum(poblacion))
  
  # Nombres amigables para niveles educativos
  edu_labels <- c(
    sin_nivel = "Sin Nivel",
    inicial = "Inicial",
    primaria = "Primaria",
    secundaria = "Secundaria",
    basica_especial = "B\u00e1sica Especial",
    sup_no_univ_incompleta = "Sup. No Univ. Incorp.",
    sup_no_univ_completa = "Sup. No Univ. Compl.",
    sup_univ_incompleta = "Sup. Univ. Incorp.",
    sup_univ_completa = "Sup. Univ. Compl.",
    maestria_doctorado = "Posgrado"
  )
  
  df_edu$nivel_label <- edu_labels[df_edu$nivel_educativo]
  df_edu <- na.omit(df_edu)
  df_edu <- df_edu %>% arrange(desc(poblacion))
  
  ggplot(df_edu, aes(x = reorder(nivel_label, poblacion), y = poblacion, fill = poblacion)) +
    geom_col(show.legend = FALSE, fill = "#1E3A8A", width = 0.7) +
    scale_y_continuous(labels = comma) +
    coord_flip() +
    geom_text(aes(label = percent(porcentaje, accuracy = 0.1)), hjust = -0.1, size = 3, fontface = "bold") +
    labs(
      title = paste("Nivel Educativo Alcanzado -", res_geo$nombre),
      subtitle = "Poblaci\u00f3n de 3 y m\u00e1s a\u00f1os de edad por nivel m\u00e1ximo alcanzado",
      x = "Nivel Educativo",
      y = "Poblaci\u00f3n"
    ) +
    theme_censo() +
    theme(panel.grid.major.y = element_blank(), panel.grid.major.x = element_line(color = "#E5E7EB"))
}

#' Graficar la distribución de autoidentificación étnica
#'
#' @param unidad Nombre de la unidad censal.
#' @return Un objeto ggplot2.
#' @export
plot_etnicidad <- function(unidad) {
  res_geo <- buscar_unidad(unidad)
  if (!res_geo$matched) stop("No se encontr\u00f3 la unidad: ", unidad)
  
  df <- censo2025pe::censo_etnicidad
  if (res_geo$tipo == "nacional") {
    df <- df[df$departamento == "PER\u00da" & df$provincia == "Total" & df$area == "Total" & df$sexo == "Total", ]
  } else if (res_geo$tipo == "departamento") {
    df <- df[df$departamento == res_geo$nombre & df$provincia == "Total" & df$area == "Total" & df$sexo == "Total", ]
  } else {
    df <- df[df$provincia == res_geo$nombre & df$area == "Total" & df$sexo == "Total", ]
  }
  
  df_etn <- df %>%
    filter(grupo_etnico != "total") %>%
    group_by(grupo_etnico) %>%
    summarise(poblacion = sum(poblacion, na.rm = TRUE), .groups = "drop") %>%
    mutate(porcentaje = poblacion / sum(poblacion)) %>%
    arrange(desc(poblacion))
  
  # Seleccionar las principales y colapsar las dem\u00e1s como "Otros" si hay muchas
  # En nuestro caso son 11 grupos, podemos graficar las principales 6 y agrupar el resto
  top_etn <- df_etn %>% slice_head(n = 6)
  other_etn <- df_etn %>% slice_tail(n = -6)
  
  if (nrow(other_etn) > 0) {
    other_row <- tibble(
      grupo_etnico = "otros",
      poblacion = sum(other_etn$poblacion),
      porcentaje = sum(other_etn$porcentaje)
    )
    df_etn_plot <- bind_rows(top_etn, other_row)
  } else {
    df_etn_plot <- top_etn
  }
  
  etn_labels <- c(
    quechua = "Quechua",
    aimara = "Aimara",
    indigena_amazonia = "Ind\u00edgena Amazon\u00eda",
    otro_indigena = "Otro Ind\u00edgena",
    afrodescendiente = "Afrodescendiente",
    nikkei = "Nikkei",
    tusan = "Tusan",
    blanco = "Blanco",
    mestizo = "Mestizo",
    otro = "Otro",
    no_sabe_no_responde = "No responde/NS",
    otros = "Otros"
  )
  
  df_etn_plot$etnia_label <- etn_labels[df_etn_plot$grupo_etnico]
  df_etn_plot$etnia_label <- factor(df_etn_plot$etnia_label, levels = df_etn_plot$etnia_label)
  
  ggplot(df_etn_plot, aes(x = etnia_label, y = poblacion, fill = etnia_label)) +
    geom_col(show.legend = FALSE, fill = "#10B981", width = 0.6) +
    scale_y_continuous(labels = comma) +
    geom_text(aes(label = percent(porcentaje, accuracy = 0.1)), vjust = -0.5, size = 3, fontface = "bold") +
    labs(
      title = paste("Autoidentificaci\u00f3n \u00c9tnica -", res_geo$nombre),
      subtitle = "Poblaci\u00f3n que se identific\u00f3 con alg\u00fan grupo \u00e9tnico",
      x = "Grupo \u00c9tnico",
      y = "Poblaci\u00f3n"
    ) +
    theme_censo()
}

#' Graficar la distribución de viviendas por procedencia de agua
#'
#' @param unidad Nombre de la unidad censal.
#' @return Un objeto ggplot2.
#' @export
plot_servicios_agua <- function(unidad) {
  res_geo <- buscar_unidad(unidad)
  if (!res_geo$matched) stop("No se encontr\u00f3 la unidad: ", unidad)
  
  df <- censo2025pe::censo_servicios
  if (res_geo$tipo == "nacional") {
    df <- df[df$departamento == "PER\u00da" & df$provincia == "Total" & df$area == "Total" & df$tipo_vivienda == "Total" & df$indicador == "Viviendas particulares", ]
  } else if (res_geo$tipo == "departamento") {
    df <- df[df$departamento == res_geo$nombre & df$provincia == "Total" & df$area == "Total" & df$tipo_vivienda == "Total" & df$indicador == "Viviendas particulares", ]
  } else {
    df <- df[df$provincia == res_geo$nombre & df$area == "Total" & df$tipo_vivienda == "Total" & df$indicador == "Viviendas particulares", ]
  }
  
  df_agua <- df %>%
    filter(procedencia_agua != "total") %>%
    group_by(procedencia_agua) %>%
    summarise(viviendas = sum(valor, na.rm = TRUE), .groups = "drop") %>%
    mutate(porcentaje = viviendas / sum(viviendas)) %>%
    arrange(desc(viviendas))
  
  agua_labels <- c(
    red_publica = "Red P\u00fablica",
    pilon_pileta = "Pil\u00f3n/Pileta",
    camion_cisterna = "Cami\u00f3n-Cisterna",
    pozo = "Pozo",
    manantial = "Manantial",
    rio_acequia = "R\u00edo/Acequia",
    otro = "Otro"
  )
  
  df_agua$agua_label <- agua_labels[df_agua$procedencia_agua]
  df_agua$agua_label <- factor(df_agua$agua_label, levels = df_agua$agua_label)
  
  ggplot(df_agua, aes(x = agua_label, y = viviendas, fill = agua_label)) +
    geom_col(show.legend = FALSE, fill = "#F59E0B", width = 0.6) +
    scale_y_continuous(labels = comma) +
    geom_text(aes(label = percent(porcentaje, accuracy = 0.1)), vjust = -0.5, size = 3, fontface = "bold") +
    labs(
      title = paste("Abastecimiento de Agua en la Vivienda -", res_geo$nombre),
      subtitle = "Distribuci\u00f3n de viviendas particulares seg\u00fan procedencia del agua",
      x = "Procedencia del agua",
      y = "Viviendas Particulares"
    ) +
    theme_censo() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}
