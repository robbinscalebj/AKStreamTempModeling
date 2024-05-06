# scrape downloads from AKTEMP database
library(tidyverse)
library(netstat)
library(jsonlite)
library(rvest)
library(httr)
library(RSelenium)

url_405 <- "https://aktemp.uaa.alaska.edu/#/explorer/stations/405"

#rvest
site_html <- read_html("https://aktemp.uaa.alaska.edu/#/explorer/stations/405")
#found this URL with developer tools>Network tab, then clicking on the download raw button 
#which shows 'values' as coming from the following server url
series_url <- "https://u5ozso2814.execute-api.us-west-2.amazonaws.com/api/public/series/552/values"

series_code <- str_remove(series_url,"https://u5ozso2814.execute-api.us-west-2.amazonaws.com/api/public/series/")|>
  str_remove("/values")

series_df <- read_json(series_url)|>map(as_tibble)|>list_rbind()|>mutate(series_code = series_code)


stations_url <- "https://u5ozso2814.execute-api.us-west-2.amazonaws.com/api/public/stations"
stations_df <- read_json(stations_url)|>
  map(~keep(., ~!is.null(.x))|>as_tibble())|>list_rbind()

site_id <- stations_df|>filter(series_count>1)|>first()|>pull(id)

site_url <- paste0("https://aktemp.uaa.alaska.edu/#/explorer/stations/", site_id)

site_series <- paste0(site_url, "/series")

site_ava_series_json <- read_html(site_series)|>
  html_element(".text")|>
  html_text()
  html_elements("pre")

https://u5ozso2814.execute-api.us-west-2.amazonaws.com/api/public/stations/32/series
# maybe can use IDs to go to webpage and retrieve info about series ID's available






#Try with RSelenium - needs open RDK Java or whatever installed and set to PATH



blah <- GET(url = url_405)

rs_driver_object <- rsDriver(browser = "chrome",
                             chromever = "latest",
                             verbose = FALSE,
                             port = free_port())
