test_that("buscar_unidad funciona correctamente", {
  # Cargar datasets locales para test
  # testthat cargará el namespace del paquete si se corre vía devtools::test()
  
  res_nac <- buscar_unidad("PERÚ")
  expect_true(res_nac$matched)
  expect_equal(res_nac$tipo, "nacional")
  expect_equal(res_nac$nombre, "PERÚ")
  
  res_dep <- buscar_unidad("amazonas")
  expect_true(res_dep$matched)
  expect_equal(res_dep$tipo, "departamento")
  expect_equal(res_dep$nombre, "AMAZONAS")
  
  res_prov <- buscar_unidad("provincia chachapoyas")
  expect_true(res_prov$matched)
  expect_equal(res_prov$tipo, "provincia")
  expect_equal(res_prov$nombre, "PROVINCIA CHACHAPOYAS")
  
  # Coincidencia parcial / tolerante a tildes
  res_fuzzy <- buscar_unidad("Ancash")
  expect_true(res_fuzzy$matched)
  expect_equal(res_fuzzy$nombre, "ÁNCASH")
  
  # Caso inválido
  res_fail <- buscar_unidad("NoExiste")
  expect_false(res_fail$matched)
})

test_that("listas de geografía funcionan", {
  deptos <- listar_departamentos()
  expect_type(deptos, "character")
  expect_true("AMAZONAS" %in% deptos)
  expect_true("PERÚ" %in% deptos)
  
  provs <- listar_provincias()
  expect_type(provs, "character")
  expect_true("PROVINCIA CHACHAPOYAS" %in% provs)
  expect_false("Total" %in% provs) # No debe incluir "Total"
})

test_that("funciones de visualización devuelven objetos ggplot", {
  p1 <- plot_piramide_poblacion("AMAZONAS")
  expect_s3_class(p1, "ggplot")
  
  p2 <- plot_educacion("PERÚ")
  expect_s3_class(p2, "ggplot")
  
  p3 <- plot_etnicidad("AMAZONAS")
  expect_s3_class(p3, "ggplot")
  
  p4 <- plot_servicios_agua("PERÚ")
  expect_s3_class(p4, "ggplot")
})
