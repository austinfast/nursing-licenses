library(tidyverse)
library(janitor)
library(httr)
library(rvest)
library(lubridate)
library(xml2)

#Set time zone to save files with correct date
Sys.setenv(TZ="America/Los_Angeles")
#Sys.setenv(TZ="Pacific/Honolulu")

#Pull in AzBN numbers
url <- "https://www.azbn.gov"

azbn <- read_html (url)
azbn2 <- azbn %>%
  html_nodes (xpath='//*[@id="block-nursestats-2"]/div/div/div/div')

azbn2 %>% html_nodes("ul") -> uls
az_df <- data.frame()
for (ul in uls) {
  ul %>% html_text("li") -> text
  type = gsub("\\d*,\\d*|\\d*", '', text)
  count <- parse_number(text)
  tmpdf <- data.frame(type,count) %>%
    add_column (archive_date = Sys.Date())
  az_df <- rbind(az_df,tmpdf)
}

#write AzBN license details
write_csv (az_df, paste0("/Users/austinfast/Documents/GitHub/nursing-licenses/AzBN_scrapes/AzBN_", Sys.Date(), ".csv"))

#Scrape active nursing license data from National Council of State Boards of Nursing

#Scrape RN data from https://www.ncsbn.org/6161.htm
url1 <- "https://www.ncsbn.org/Aggregate-RNActiveLicensesMap.html"
map_rn <- read_html(url1) %>%
  html_text()
last_updated_rn = gsub(".*Last updated\\(", '', map_rn)
last_updated_rn = mdy( gsub("\\).*", '', last_updated_rn) )

#Read FusionChart data pulled from XML URL in map above
map2_rn <- xml2::read_xml("https://www.ncsbn.org/Aggregate-RNActiveLicensesMap.xml")

counts_rn <- map2_rn %>%
  xml_nodes('entity') %>%
  xml_attr('value')

states_rn <- map2_rn %>%
  xml_nodes('entity') %>%
  xml_attr('toolText') %>%
  str_remove_all("[0-9]+") %>%
  str_remove_all(",") %>%
  str_squish()

df_rn <- data.frame(states_rn, counts_rn) %>%
  distinct(states_rn, counts_rn) %>% #remove repeat WV/CA
  mutate (counts_rn = as.numeric(counts_rn),
          updated_date = last_updated_rn,
          scrape_date = Sys.Date()) %>%
  rename (state = states_rn)

write_csv(df_rn, paste0("/Users/austinfast/Documents/GitHub/nursing-licenses/NCSBN_scrapes/RN_scrape_", Sys.Date(), ".csv"))

#Scrape LPN data from https://www.ncsbn.org/6162.htm
url2 <- "https://www.ncsbn.org/Aggregate-LPNActiveLicensesMap.html"
map_lpn <- read_html(url2) %>%
  html_text()
last_updated_lpn = gsub(".*Last updated\\(", '', map_lpn)
last_updated_lpn = mdy( gsub("\\).*", '', last_updated_lpn) )

#Read FusionChart data pulled from XML URL in map above
map2_lpn <- xml2::read_xml("https://www.ncsbn.org/Aggregate-LPNActiveLicensesMap.xml")

counts_lpn <- map2_lpn %>%
  xml_nodes('entity') %>%
  xml_attr('value')

states_lpn <- map2_lpn %>%
  xml_nodes('entity') %>%
  xml_attr('toolText') %>%
  str_remove_all("[0-9]+") %>%
  str_remove_all(",") %>%
  str_squish()

df_lpn <- data.frame(states_lpn, counts_lpn) %>%
  distinct(states_lpn, counts_lpn) %>% #remove repeat WV/CA
  mutate (counts_lpn = as.numeric(counts_lpn),
          updated_date = last_updated_lpn,
          scrape_date = Sys.Date()) %>%
  rename (state = states_lpn)

write_csv(df_lpn, paste0("/Users/austinfast/Documents/GitHub/nursing-licenses/NCSBN_scrapes/LPN_scrape_", Sys.Date(), ".csv"))

#Scrape ALL license data from https://www.ncsbn.org/Aggregate-AllActiveLicensesMap.html
url3 <- "https://www.ncsbn.org/Aggregate-AllActiveLicensesMap.html"
map_all <- read_html(url3) %>%
  html_text()
last_updated_all = gsub(".*Last updated\\(", '', map_all)
last_updated_all = mdy( gsub("\\).*", '', last_updated_all) )

#Read FusionChart data pulled from XML URL in map above
map_all <- read_xml("https://www.ncsbn.org/Aggregate-AllActiveLicensesMap.xml")

counts_all <- map_all %>%
  xml_nodes('entity') %>%
  xml_attr('value')

states_all <- map_all %>%
  xml_nodes('entity') %>%
  xml_attr('toolText') %>%
  str_remove_all("[0-9]+") %>%
  str_remove_all(",") %>%
  str_squish()

df_all <- data.frame(states_all, counts_all) %>%
  distinct(states_all, counts_all) %>% #remove repeat WV/CA
  mutate (counts_all = as.numeric(counts_all),
          updated_date = last_updated_all,
          scrape_date = Sys.Date()) %>%
  rename (state = states_all) %>%
  filter (!(state %in% c("CALIFORNIA-RN", "CALIFORNIA-VN", "LOUISIANA-PN", "LOUISIANA-RN", "WEST VIRGINIA-RN", "WEST VIRGINIA-PN", "TOTALS"))) %>%
  mutate (state = case_when (
    str_detect(state, "^CALIF") ~ "CALIFORNIA",
    str_detect(state, "^WEST V") ~ "WEST VIRGINIA",
    str_detect(state, "^LOUIS") ~ "LOUISIANA",
    TRUE ~ state))

write_csv(df_all, paste0("/Users/austinfast/Documents/GitHub/nursing-licenses/NCSBN_scrapes/ALL_scrape_", Sys.Date(), ".csv"))

#Screenshot nurse board websites to Archive.org
#Save NCSBN LPN counts
lpn_page <- html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-LPNActiveLicensesTable.pdf")
print (lpn_page$response$status_code)
#Save NCSBN RN counts
rn_page <- html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf")
print (rn_page$response$status_code)

#Save Calif. processing times to Archive.org
ca_page <- html_session("https://web.archive.org/save/https://www.rn.ca.gov/times.shtml")
print (ca_page$response$status_code)

#Save DC processing times to Archive.org
dc_page <- html_session("https://web.archive.org/save/https://dchealth.dc.gov/bon")
print (dc_page$response$status_code)

#Save Ga1 processing times to Archive.org
ga_page1 <- html_session("https://web.archive.org/save/https://sos.ga.gov/index.php/licensing/plb/45/faq")
print (ga_page1$response$status_code)
#Save Ga2 processing times to Archive.org
ga_page2 <- html_session("https://web.archive.org/save/https://sos.ga.gov/index.php/licensing/plb/45")
print (ga_page2$response$status_code)

#Save Illinois processing times to Archive.org
il_page <- html_session("https://web.archive.org/save/https://online-dfpr.micropact.com")
print (il_page$response$status_code)

#Save Missouri processing times to Archive.org
mo_page <- html_session("https://www.pr.mo.gov/nursing.asp")
print (mo_page$response$status_code)

#Save Nevada processing times to Archive.org
nv_page <- html_session("https://web.archive.org/save/https://nevadanursingboard.org/covid-19-resource-and-information/")
print (nv_page$response$status_code)

#Save New York processing times to Archive.org
ny_page <- html_session("http://www.op.nysed.gov/prof/nurse/")
print (ny_page$response$status_code)

#Save RI processing times to Archive.org
ri_page <- html_session("https://web.archive.org/save/https://health.ri.gov/licenses/")
print (ri_page$response$status_code)

#Save Wash. processing times to Archive.org
wa_page <- html_session("https://web.archive.org/save/https://www.doh.wa.gov/AboutUs/ContactUs")
print (wa_page$response$status_code)
