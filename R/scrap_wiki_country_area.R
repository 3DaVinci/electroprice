#' Scrap wikipedia country area data
#'
#' @importFrom xml2 read_html
#' @importFrom rvest html_nodes html_node html_attr html_table
#' @import dplyr
#' @import stringr
#'
#' @export


scrap_wiki_counry_area <-  function() {

  wiki_area_table <-
    read_html(
      "https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_area"
    ) %>%
    html_table()

  # tidy data
  country_area_df <-
    wiki_area_table[[1]] %>%
    filter(
      !str_detect(`Sovereign state/dependency`, "World")
    ) %>%
    transmute(
      country =
        `Sovereign state/dependency` %>%
        str_remove("\\[.*\\]") %>%
        str_remove("^The") %>%
        str_trim(),
      country = country %>%
        align_country_name(),
      total_area_km2  = `Total in km2 (mi2)` %>%
        str_remove("\\(.+\\)") %>%
        str_remove("\\[.+\\]") %>%
        str_remove_all(",") %>%
        as.integer(),
      land_area_km2 = `Land in km2 (mi2)` %>%
        str_remove("\\(.+\\)") %>%
        str_remove("\\[.+\\]") %>%
        str_remove_all(",") %>%
        as.integer(),
      water_area_km2 = `Water in km2 (mi2)` %>%
        str_remove("\\(.+\\)") %>%
        str_remove("\\[.+\\]") %>%
        str_remove_all(",") %>%
        as.integer(),
      water_pct = `% water` %>% as.double(),
      description = Notes,
    ) %>%
    # filter Denmark
    filter(!str_detect(description, "UN figure does not include the entire Kingdom of Denmark area")) %>%
    drop_na()
}
