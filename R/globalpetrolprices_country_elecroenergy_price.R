#' Scraping data from www.globalpetrolprices.com
#'
#' We use https://www.globalpetrolprices.com/electricity_prices/ url to download
#' electroenegy prices by counry
#'
#' @import rvest
#' @import dplyr
#' @import stringr
#' @import purrr


#' @export
scrap_globalpetrolprices_com  <- function() {
  # Intitial url list for scraping
  url_initial <-
    read_html("https://www.globalpetrolprices.com/electricity_prices/") %>%
    html_nodes(".graph_outside_link") %>%
    html_attr("href")

  url_initial <-  str_c("https://www.globalpetrolprices.com", url_initial)


  # Empty list for save html
  html_list <-  vector(mode = "list", length =  length(url_initial))

  #  Initialize progeress bar
  pb <- txtProgressBar(min = 0, max = length(html_list), style = 3)

  # Scruping cicle
  for (i in seq_along(url_initial)) {
    html_list[[i]] <-  read_html(url_initial[[i]])

    setTxtProgressBar(pb, i)
  }

  # close progress bar
  close(pb)

  # Parsing function
  get_price_table <- function(html, url) {

    table <-  html %>%
      html_table(header = T) %>%
      .[[1]]

    country <- colnames(table)[[1]] %>%
      str_remove(" electricity prices")

    colnames(table) <- c("currency", "household_kwh", "business_kwh")

    table %>%
      transmute(
        country = country,
        currency = currency,
        household_kwh = as.character(household_kwh),
        business_kwh = as.character(business_kwh),
        year = 2019,
        descr_html = html %>%
          html_node(".tipInfo") %>%
          html_text() %>%
          str_remove_all("\r|\n|\t") %>%
          str_extract(".*(?=The latest business and household electricity)"),
        data_source_url = url,
        data_source_read_date = Sys.Date()
      )
  }


  # Map parsing function
  country_electroenergy_price_df <-
    map2_dfr(html_list, url_initial, get_price_table)

  # tidy country_electroenergy_price_df
 country_electroenergy_price_df %>%
    mutate(
      household_kwh = household_kwh %>% str_remove(",") %>% as.double(),
      business_kwh = business_kwh %>% str_remove(",") %>% as.double()
    ) %>%
    # Delete repeated rows
    distinct()

}


