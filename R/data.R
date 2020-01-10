#' Electroenergy price by countries
#'
#' A dataset containing the prices of electroenergy by counry in US dollars
#' and counry currency. You can srap this dataframe by \code{\link{scrap_globalpetrolprices_com}}
#'
#' @format A data frame with 231 rows and 8 variables:
#' \describe{
#'   \item{counry}{Country name}
#'   \item{currency}{Currency name}
#'   \item{household_kwh}{Electricity prices for households}
#'   \item{business_kwh}{Electricity prices for business}
#'   \item{year}{Year by information source}
#'   \item{descr_html}{Description by www.globalpetrolprices.com}
#'   \item{data_source_read_date}{Scraping date}
#'   ...
#' }
#'
#'
#'
#' @source \url{https://www.globalpetrolprices.com/electricity_prices/}

"electroprice2019"
