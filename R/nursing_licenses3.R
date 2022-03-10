library(tidyverse)
library(janitor)
library(httr)
library(rvest)
library(lubridate)
library(xml2)

#Set time zone to save files with correct date
Sys.setenv(TZ="America/Los_Angeles")

urls <- c("https://www.ncsbn.org/Aggregate-LPNActiveLicensesTable.pdf",
          "https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf",
          "https://www.rn.ca.gov/times.shtml",
          "https://dchealth.dc.gov/bon",
          "https://sos.ga.gov/page/faqs-nursing",
          #"https://sos.ga.gov/index.php/licensing/plb/45/faq",
          #"https://sos.ga.gov/index.php/licensing/plb/45", #did have processing delay note
          "https://online-dfpr.micropact.com",
          "https://ksbn.kansas.gov",
          "https://nevadanursingboard.org/covid-19-resource-and-information/",
          "http://www.op.nysed.gov/prof/nurse/",
          "https://health.ri.gov/licenses/",
          "https://www.doh.wa.gov/AboutUs/ContactUs",
          "https://www.pr.mo.gov/nursing.asp")

for (url in urls){
  link <- paste0 ("https://web.archive.org/save/", url)
  page <- try(html_session(link))
  Sys.sleep(5)
  if(inherits(page, "try-error")){ #page$response$status_code %in% c("520", "429", "523") |
    #Try again
    Sys.sleep(1)
    page <- try(html_session(link))
    Sys.sleep(5)
    #Move on if fail second time
    if(inherits(page, "try-error")){ #page$response$status_code %in% c("520", "429", "523") |
      print (page)
      print (paste0("ALERT: ", url, " failed."))
    } else{
      print (paste0(url, " -- ", page$response$status_code))
    }
  } else{
    print (paste0(url, " -- ", page$response$status_code))
  }
}
