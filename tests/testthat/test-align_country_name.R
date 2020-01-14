library(electroprice)
library(tibble)



test_that("test vector", {
  expect_equal(
    align_country_name(
      c("Россия",
        NA,
        "РФ",
        "Russia",
        "USA",
        "США",
        "Burma",
        "Myanmar",
        "Burma (Myanmar)",
        "Какая-то страна",
        "Qatar")
    ),
    c("Russia",
      NA,
      "Russia",
      "Russia",
      "USA",
      "USA",
      "Myanmar",
      "Myanmar",
      "Myanmar",
      NA,
      "Qatar")
  )
})
