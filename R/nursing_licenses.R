library(tidyverse)
library(janitor)
library(httr)
library(rvest)
library(lubridate)
library(xml2)

#Set time zone to save files with correct date
Sys.setenv(TZ="EST")

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
write_csv (az_df, paste0("AzBN_scrapes/AzBN_", Sys.Date(), ".csv"))

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

write_csv(df_rn, paste0("NCSBN_scrapes/RN_scrape_", Sys.Date(), ".csv"))

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

write_csv(df_lpn, paste0("NCSBN_scrapes/LPN_scrape_", Sys.Date(), ".csv"))

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

write_csv(df_all, paste0("NCSBN_scrapes/ALL_scrape_", Sys.Date(), ".csv"))

#Screenshot nurse board websites to Archive.org
#Save NCSBN LPN counts
lpn_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-LPNActiveLicensesTable.pdf"))
Sys.sleep(1)
if(!inherits(lpn_page, "try-error")){
  print (lpn_page$response$status_code)
} else{
  #Try again
  Sys.sleep(1)
  lpn_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!inherits(lpn_page, "try-error")){
    print (lpn_page$response$status_code)
  } else{
    print ("ALERT: lpn_page failed")
  }
}

#Save NCSBN RN counts
rn_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
Sys.sleep(1)
if(!inherits(rn_page, "try-error")){
  print (rn_page$response$status_code)
} else{
  #Try again 
  Sys.sleep(1)
  rn_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!inherits(rn_page, "try-error")){
    print (rn_page$response$status_code)
  } else{
  print ("ALERT: rn_page failed")
  }
}

#Save Calif. processing times to Archive.org
ca_page <- html_session("https://web.archive.org/save/https://www.rn.ca.gov/times.shtml")
Sys.sleep(1) 
if(!inherits(ca_page, "try-error")){
  print (ca_page$response$status_code)
} else{
  #Try again
  Sys.sleep(1) 
  ca_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!inherits(ca_page, "try-error")){
    print (ca_page$response$status_code)
  } else{
    print ("ALERT: ca_page failed")
  }
}

#Save DC processing times to Archive.org
dc_page <- html_session("https://web.archive.org/save/https://dchealth.dc.gov/bon")
  Sys.sleep(1)
if(!inherits(dc_page, "try-error")){
  print (dc_page$response$status_code)
} else{
  #Try again
  Sys.sleep(1)
  dc_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!inherits(dc_page, "try-error")){
    print (dc_page$response$status_code)
  } else{
    print ("ALERT: dc_page failed")
  }
}

#Save Ga1 processing times to Archive.org
ga_page1 <- html_session("https://web.archive.org/save/https://sos.ga.gov/index.php/licensing/plb/45/faq")
  Sys.sleep(1)
if(!inherits(ga_page1, "try-error")){
  print (ga_page1$response$status_code)
} else{
  #Try again
  Sys.sleep(1)
  ga_page1 <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!inherits(ga_page1, "try-error")){
    print (ga_page1$response$status_code)
  } else{
    print ("ALERT: ga_page1 failed")
  }
}

#Save Ga2 processing times to Archive.org
ga_page2 <- html_session("https://web.archive.org/save/https://sos.ga.gov/index.php/licensing/plb/45")
  Sys.sleep(1)
if(!inherits(ga_page2, "try-error")){
  print (ga_page2$response$status_code)
} else{
  #Try again
  Sys.sleep(1)
  ga_page2 <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!inherits(ga_page2, "try-error")){
    print (ga_page2$response$status_code)
  } else{
    print ("ALERT: ga_page2 failed")
  }
}

#Save Illinois processing times to Archive.org
il_page <- html_session("https://web.archive.org/save/https://online-dfpr.micropact.com")
  Sys.sleep(1)
if(!inherits(il_page, "try-error")){
  print (il_page$response$status_code)
} else{
  #Try again
  Sys.sleep(1)
  il_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!inherits(il_page, "try-error")){
    print (il_page$response$status_code)
  } else{
    print ("ALERT: il_page failed")
  }
}

#Save Missouri processing times to Archive.org
mo_page <- html_session("https://www.pr.mo.gov/nursing.asp")
  Sys.sleep(1)
if(!inherits(mo_page, "try-error")){
  print (mo_page$response$status_code)
} else{
  #Try again
  Sys.sleep(1)
  mo_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!inherits(mo_page, "try-error")){
    print (mo_page$response$status_code)
  } else{
    print ("ALERT: mo_page failed")
  }
}

#Save Nevada processing times to Archive.org
nv_page <- html_session("https://web.archive.org/save/https://nevadanursingboard.org/covid-19-resource-and-information/")
  Sys.sleep(1)
if(!inherits(nv_page, "try-error")){
  print (nv_page$response$status_code)
} else{
  #Try again
  Sys.sleep(1)
  nv_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!inherits(nv_page, "try-error")){
    print (nv_page$response$status_code)
  } else{
    print ("ALERT: nv_page failed")
  }
}

#Save New York processing times to Archive.org
ny_page <- html_session("http://www.op.nysed.gov/prof/nurse/")
  Sys.sleep(1)
if(!inherits(ny_page, "try-error")){
  print (ny_page$response$status_code)
} else{
  #Try again
  Sys.sleep(1)
  ny_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!inherits(ny_page, "try-error")){
    print (ny_page$response$status_code)
  } else{
    print ("ALERT: ny_page failed")
  }
}

#Save RI processing times to Archive.org
ri_page <- html_session("https://web.archive.org/save/https://health.ri.gov/licenses/")
  Sys.sleep(1)
if(!inherits(ri_page, "try-error")){
  print (ri_page$response$status_code)
} else{
  #Try again
  Sys.sleep(1)
  ri_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!inherits(ri_page, "try-error")){
    print (ri_page$response$status_code)
  } else{
    print ("ALERT: ri_page failed")
  }
}

#Save Wash. processing times to Archive.org
wa_page <- html_session("https://web.archive.org/save/https://www.doh.wa.gov/AboutUs/ContactUs")
  Sys.sleep(1)
if(!inherits(wa_page, "try-error")){
  print (wa_page$response$status_code)
} else{
  #Try again
  Sys.sleep(1)
  wa_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!inherits(wa_page, "try-error")){
    print (wa_page$response$status_code)
  } else{
    print ("ALERT: wa_page failed")
  }
}
