#' Scraping wikipedia country population data
#'
#' Sorce url
#' https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_population
#'
#' @importFrom xml2 read_html
#' @importFrom rvest html_nodes html_node html_attr html_table
#' @import dplyr
#'
#' @export

scrap_wiki_counry_pop <-  function(){
  url <- "https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_population"

  html <- read_html(url)

  wiki_table <- html %>% html_table()

  wiki_table[[1]] %>%
    transmute(
      country =
        `Country(or dependent territory)` %>%
        str_remove_all("\\[.*\\]")  %>%
        str_trim() %>%
        align_country_name(),
      population =
        Population %>%
        str_remove_all(",") %>%
        as.integer(),
      date = Date %>% lubridate::dmy()
    ) %>%
    drop_na()
}
