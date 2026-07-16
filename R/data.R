#' Población censada por tipo de discapacidad (Censo 2025)
#'
#' Dataset ordenado (tidy long format) con la población de 5 y más años
#' de edad según su condición y tipo de discapacidad.
#'
#' @format Un objeto tibble con 436 filas y 7 columnas:
#' \describe{
#'   \item{departamento}{Nombre del departamento (o "PERÚ" para el total nacional).}
#'   \item{provincia}{Nombre de la provincia (o "Total" para el consolidado).}
#'   \item{area}{Área de residencia ("Total", "Urbana", "Rural").}
#'   \item{sexo}{Sexo de la población ("Total", "Hombre", "Mujer").}
#'   \item{grupo_edad}{Grupos de edad de la población.}
#'   \item{tipo_discapacidad}{Tipo de dificultad ("ver", "oir", "hablar", "caminar", "usar_brazos_manos", "recordar_concentrarse", "relacionarse_demas", "ninguna", "total").}
#'   \item{poblacion}{Cantidad de personas censadas.}
#' }
#' @source Instituto Nacional de Estadística e Informática (INEI) - Censos Nacionales 2025.
"censo_discapacidad"

#' Población censada por nivel educativo alcanzado (Censo 2025)
#'
#' Dataset ordenado con la población de 3 y más años de edad
#' según el máximo nivel educativo alcanzado.
#'
#' @format Un objeto tibble con 10,750 filas y 7 columnas:
#' \describe{
#'   \item{departamento}{Nombre del departamento.}
#'   \item{provincia}{Nombre de la provincia.}
#'   \item{area}{Área de residencia.}
#'   \item{sexo}{Sexo de la población.}
#'   \item{grupo_edad}{Grupos de edad de la población.}
#'   \item{nivel_educativo}{Nivel alcanzado ("sin_nivel", "inicial", "primaria", "secundaria", etc.).}
#'   \item{poblacion}{Cantidad de personas.}
#' }
#' @source Instituto Nacional de Estadística e Informática (INEI) - Censos Nacionales 2025.
"censo_educacion"

#' Población censada por estado civil o conyugal (Censo 2025)
#'
#' Dataset ordenado con la población de 12 y más años de edad
#' según su estado civil o conyugal por grupos de edad.
#'
#' @format Un objeto tibble con 1,134 filas y 7 columnas:
#' \describe{
#'   \item{departamento}{Nombre del departamento.}
#'   \item{provincia}{Nombre de la provincia ("Total").}
#'   \item{area}{Área de residencia.}
#'   \item{sexo}{Sexo de la población.}
#'   \item{estado_civil}{Estado civil ("Soltero/a", "Casado/a", "Conviviente", etc.).}
#'   \item{grupo_edad}{Grupos de edad de la población.}
#'   \item{poblacion}{Cantidad de personas.}
#' }
#' @source Instituto Nacional de Estadística e Informática (INEI) - Censos Nacionales 2025.
"censo_estado_civil"

#' Población censada por tipo de seguro de salud (Censo 2025)
#'
#' Dataset ordenado con la afiliación a algún tipo de seguro de salud.
#'
#' @format Un objeto tibble con 1,323 filas y 7 columnas:
#' \describe{
#'   \item{departamento}{Nombre del departamento.}
#'   \item{provincia}{Nombre de la provincia.}
#'   \item{area}{Área de residencia.}
#'   \item{sexo}{Sexo de la población.}
#'   \item{grupo_edad}{Grupos de edad.}
#'   \item{tipo_seguro}{Seguro ("sis", "essalud", "ffaa_policiales", "privado", "otro", "ninguno", "total").}
#'   \item{poblacion}{Cantidad de personas.}
#' }
#' @source Instituto Nacional de Estadística e Informática (INEI) - Censos Nacionales 2025.
"censo_seguro_salud"

#' Población censada por autoidentificación étnica (Censo 2025)
#'
#' Dataset ordenado con la población que se identificó con algún grupo étnico.
#'
#' @format Un objeto tibble con 2,268 filas y 7 columnas:
#' \describe{
#'   \item{departamento}{Nombre del departamento.}
#'   \item{provincia}{Nombre de la provincia.}
#'   \item{area}{Área de residencia.}
#'   \item{sexo}{Sexo de la población.}
#'   \item{grupo_edad}{Grupos de edad.}
#'   \item{grupo_etnico}{Etnia ("quechua", "aimara", "mestizo", "blanco", etc.).}
#'   \item{poblacion}{Cantidad de personas.}
#' }
#' @source Instituto Nacional de Estadística e Informática (INEI) - Censos Nacionales 2025.
"censo_etnicidad"

#' Viviendas particulares por condición de ocupación (Censo 2025)
#'
#' Dataset ordenado de viviendas particulares según su tipo y
#' condición de ocupación.
#'
#' @format Un objeto tibble con 1,890 filas y 6 columnas:
#' \describe{
#'   \item{departamento}{Nombre del departamento.}
#'   \item{provincia}{Nombre de la provincia.}
#'   \item{area}{Área de residencia.}
#'   \item{tipo_vivienda}{Tipo de vivienda (Casa independiente, departamento, etc.).}
#'   \item{condicion_ocupacion}{Condición ("ocupada_total", "desocupada_total", etc.).}
#'   \item{valor}{Cantidad de viviendas.}
#' }
#' @source Instituto Nacional de Estadística e Informática (INEI) - Censos Nacionales 2025.
"censo_vivienda"

#' Viviendas y ocupantes por procedencia del agua (Censo 2025)
#'
#' Dataset con la distribución de viviendas y ocupantes según
#' la procedencia del agua en la vivienda.
#'
#' @format Un objeto tibble con 3,744 filas y 7 columnas:
#' \describe{
#'   \item{departamento}{Nombre del departamento.}
#'   \item{provincia}{Nombre de la provincia.}
#'   \item{area}{Área de residencia.}
#'   \item{tipo_vivienda}{Tipo de vivienda.}
#'   \item{indicador}{"Viviendas particulares" o "Ocupantes presentes".}
#'   \item{procedencia_agua}{Procedencia ("red_publica", "pozo", "camion_cisterna", etc.).}
#'   \item{valor}{Cantidad medida (viviendas o personas).}
#' }
#' @source Instituto Nacional de Estadística e Informática (INEI) - Censos Nacionales 2025.
"censo_servicios"

#' Viviendas particulares por número de hogares (Censo 2025)
#'
#' Distribución de viviendas particulares ocupadas según la cantidad de hogares
#' que albergan en su interior.
#'
#' @format Un objeto tibble con 2,808 filas y 7 columnas:
#' \describe{
#'   \item{departamento}{Nombre del departamento.}
#'   \item{provincia}{Nombre de la provincia.}
#'   \item{area}{Área de residencia.}
#'   \item{tipo_vivienda}{Tipo de vivienda.}
#'   \item{indicador}{"Viviendas particulares" o "Ocupantes presentes".}
#'   \item{numero_hogares}{Número de hogares ("hogares_1", "hogares_2", etc.).}
#'   \item{valor}{Cantidad.}
#' }
#' @source Instituto Nacional de Estadística e Informática (INEI) - Censos Nacionales 2025.
"censo_hogar_numero"

#' Hogares por equipamiento del hogar (Censo 2025)
#'
#' Distribución de hogares según la tenencia de equipamientos y artefactos.
#'
#' @format Un objeto tibble con 5,616 filas y 7 columnas:
#' \describe{
#'   \item{departamento}{Nombre del departamento.}
#'   \item{provincia}{Nombre de la provincia.}
#'   \item{area}{Área de residencia.}
#'   \item{tipo_vivienda}{Tipo de vivienda.}
#'   \item{indicador}{Indicador de tenencia.}
#'   \item{equipo_hogar}{Artefacto ("cocina_gas", "laptop", "televisor", etc.).}
#'   \item{valor}{Cantidad de hogares.}
#' }
#' @source Instituto Nacional de Estadística e Informática (INEI) - Censos Nacionales 2025.
"censo_hogar_equipamiento"
