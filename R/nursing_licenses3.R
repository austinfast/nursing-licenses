library(tidyverse)
library(janitor)
library(httr)
library(rvest)
library(lubridate)
library(xml2)

#Set time zone to save files with correct date
Sys.setenv(TZ="America/Los_Angeles")

#Screenshot nurse board websites to Archive.org
#Save NCSBN LPN counts
lpn_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-LPNActiveLicensesTable.pdf"))
Sys.sleep(1)
if(!(lpn_page$response$status_code %in% c("520", "429"))){
  print (lpn_page$response$status_code)
} else{
  #Try again
  Sys.sleep(1)
  lpn_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!(lpn_page$response$status_code %in% c("520", "429"))){
    print (lpn_page$response$status_code)
  } else{
    print ("ALERT: lpn_page failed")
  }
}

#Save NCSBN RN counts
rn_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
Sys.sleep(1)
if(!(rn_page$response$status_code %in% c("520", "429"))){
  print (rn_page$response$status_code)
} else{
  #Try again
  Sys.sleep(1)
  rn_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!(rn_page$response$status_code %in% c("520", "429"))){
    print (rn_page$response$status_code)
  } else{
  print ("ALERT: rn_page failed")
  }
}

#Save Calif. processing times to Archive.org
ca_page <- html_session("https://web.archive.org/save/https://www.rn.ca.gov/times.shtml")
Sys.sleep(1)
if(!(ca_page$response$status_code %in% c("520", "429"))){
  print (ca_page$response$status_code)
} else{
  #Try again
  Sys.sleep(1)
  ca_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!(ca_page$response$status_code %in% c("520", "429"))){
    print (ca_page$response$status_code)
  } else{
    print ("ALERT: ca_page failed")
  }
}

#Save DC processing times to Archive.org
dc_page <- html_session("https://web.archive.org/save/https://dchealth.dc.gov/bon")
  Sys.sleep(1)
if(!(dc_page$response$status_code %in% c("520", "429"))){
  print (dc_page$response$status_code)
} else{
  #Try again
  Sys.sleep(1)
  dc_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!(dc_page$response$status_code %in% c("520", "429"))){
    print (dc_page$response$status_code)
  } else{
    print ("ALERT: dc_page failed")
  }
}

#Save Ga1 processing times to Archive.org
ga_page1 <- html_session("https://web.archive.org/save/https://sos.ga.gov/index.php/licensing/plb/45/faq")
  Sys.sleep(1)
if(!(ga_page1$response$status_code %in% c("520", "429"))){
  print (ga_page1$response$status_code)
} else{
  #Try again
  Sys.sleep(1)
  ga_page1 <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!(ga_page1$response$status_code %in% c("520", "429"))){
    print (ga_page1$response$status_code)
  } else{
    print ("ALERT: ga_page1 failed")
  }
}

#Save Ga2 processing times to Archive.org
ga_page2 <- html_session("https://web.archive.org/save/https://sos.ga.gov/index.php/licensing/plb/45")
  Sys.sleep(1)
if(!(ga_page2$response$status_code %in% c("520", "429"))){
  print (ga_page2$response$status_code)
} else{
  #Try again
  Sys.sleep(1)
  ga_page2 <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!(ga_page2$response$status_code %in% c("520", "429"))){
    print (ga_page2$response$status_code)
  } else{
    print ("ALERT: ga_page2 failed")
  }
}

#Save Illinois processing times to Archive.org
il_page <- html_session("https://web.archive.org/save/https://online-dfpr.micropact.com")
  Sys.sleep(1)
if(!(il_page$response$status_code %in% c("520", "429"))){
  print (il_page$response$status_code)
} else{
  #Try again
  Sys.sleep(1)
  il_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!(il_page$response$status_code %in% c("520", "429"))){
    print (il_page$response$status_code)
  } else{
    print ("ALERT: il_page failed")
  }
}

#Save Nevada processing times to Archive.org
nv_page <- html_session("https://web.archive.org/save/https://nevadanursingboard.org/covid-19-resource-and-information/")
  Sys.sleep(1)
if(!(nv_page$response$status_code %in% c("520", "429"))){
  print (nv_page$response$status_code)
} else{
  #Try again
  Sys.sleep(1)
  nv_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!(nv_page$response$status_code %in% c("520", "429"))){
    print (nv_page$response$status_code)
  } else{
    print ("ALERT: nv_page failed")
  }
}

#Save New York processing times to Archive.org
ny_page <- html_session("http://www.op.nysed.gov/prof/nurse/")
  Sys.sleep(1)
if(!(ny_page$response$status_code %in% c("520", "429"))){
  print (ny_page$response$status_code)
} else{
  #Try again
  Sys.sleep(1)
  ny_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!(ny_page$response$status_code %in% c("520", "429"))){
    print (ny_page$response$status_code)
  } else{
    print ("ALERT: ny_page failed")
  }
}

#Save RI processing times to Archive.org
ri_page <- html_session("https://web.archive.org/save/https://health.ri.gov/licenses/")
  Sys.sleep(1)
if(!(ri_page$response$status_code %in% c("520", "429"))){
  print (ri_page$response$status_code)
} else{
  #Try again
  Sys.sleep(1)
  ri_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!(ri_page$response$status_code %in% c("520", "429"))){
    print (ri_page$response$status_code)
  } else{
    print ("ALERT: ri_page failed")
  }
}

#Save Wash. processing times to Archive.org
wa_page <- html_session("https://web.archive.org/save/https://www.doh.wa.gov/AboutUs/ContactUs")
  Sys.sleep(1)
if(!(wa_page$response$status_code %in% c("520", "429"))){
  print (wa_page$response$status_code)
} else{
  #Try again
  Sys.sleep(1)
  wa_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  #Move on if fail second time
  if(!(wa_page$response$status_code %in% c("520", "429"))){
    print (wa_page$response$status_code)
  } else{
    print ("ALERT: wa_page failed")
  }
}

#Save Missouri processing times to Archive.org
  mo_page <- html_session("https://www.pr.mo.gov/nursing.asp")
  Sys.sleep(1)
  if(!(mo_page$response$status_code %in% c("520", "429"))){
    print (mo_page$response$status_code)
  } else{
    #Try again
    Sys.sleep(1)
    mo_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
    #Move on if fail second time
    if(!(mo_page$response$status_code %in% c("520", "429"))){
      print (mo_page$response$status_code)
    } else{
      print ("ALERT: mo_page failed")
    }
  }

