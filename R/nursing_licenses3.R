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
Sys.sleep(5)
if(lpn_page$response$status_code %in% c("520", "429", "523") | inherits(lpn_page, "try-error")){
  #Try again
  Sys.sleep(1)
  lpn_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  Sys.sleep(5)
  #Move on if fail second time
  if(lpn_page$response$status_code %in% c("520", "429", "523") | inherits(lpn_page, "try-error")){
    print ("ALERT: lpn_page failed")
  } else{
    print (lpn_page$response$status_code)
  }
} else{
  print (lpn_page$response$status_code)
}

#Save NCSBN RN counts
rn_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
Sys.sleep(5)
if(rn_page$response$status_code %in% c("520", "429", "523") | inherits(rn_page, "try-error")){
  #Try again
  Sys.sleep(1)
  rn_page <- try(html_session("https://web.archive.org/save/https://www.ncsbn.org/Aggregate-RNActiveLicensesTable.pdf"))
  Sys.sleep(5)
  #Move on if fail second time
  if(rn_page$response$status_code %in% c("520", "429", "523") | inherits(rn_page, "try-error")){
    print ("ALERT: rn_page failed")
  } else{
    print (rn_page$response$status_code)
  }
} else{
  print (rn_page$response$status_code)
}

#Save Calif. processing times to Archive.org
ca_page <- try(html_session("https://web.archive.org/save/https://www.rn.ca.gov/times.shtml"))
Sys.sleep(5)
if(ca_page$response$status_code %in% c("520", "429", "523") | inherits(ca_page, "try-error")){
  #Try again
  Sys.sleep(1)
  ca_page <- try(html_session("https://web.archive.org/save/https://www.rn.ca.gov/times.shtml"))
  Sys.sleep(5)
  #Move on if fail second time
  if(ca_page$response$status_code %in% c("520", "429", "523") | inherits(ca_page, "try-error")){
    print ("ALERT: ca_page failed")
  } else{
    print (ca_page$response$status_code)
  }
} else{
  print (ca_page$response$status_code)
}

#Save DC processing times to Archive.org
dc_page <- try(html_session("https://web.archive.org/save/https://dchealth.dc.gov/bon"))
  Sys.sleep(5)
if(dc_page$response$status_code %in% c("520", "429", "523") | inherits(dc_page, "try-error")){
  #Try again
  Sys.sleep(1)
  dc_page <- try(html_session("https://web.archive.org/save/https://dchealth.dc.gov/bon"))
  Sys.sleep(5)
  #Move on if fail second time
  if(dc_page$response$status_code %in% c("520", "429", "523") | inherits(dc_page, "try-error")){
    print ("ALERT: dc_page failed")
  } else{
    print (dc_page$response$status_code)
  }
} else{
  print (dc_page$response$status_code)
}

#Save Ga1 processing times to Archive.org
ga_page1 <- try(html_session("https://web.archive.org/save/https://sos.ga.gov/index.php/licensing/plb/45/faq"))
  Sys.sleep(5)
if(ga_page1$response$status_code %in% c("520", "429", "523") | inherits(ga_page1, "try-error")){
  #Try again
  Sys.sleep(1)
  ga_page1 <- try(html_session("https://web.archive.org/save/https://sos.ga.gov/index.php/licensing/plb/45/faq"))
  Sys.sleep(5)
  #Move on if fail second time
  if(ga_page1$response$status_code %in% c("520", "429", "523") | inherits(ga_page1, "try-error")){
    print ("ALERT: ga_page1 failed")
  } else{
    print (ga_page1$response$status_code)
  }
} else{
  print (ga_page1$response$status_code)
}

#Save Ga2 processing times to Archive.org
ga_page2 <- try(html_session("https://web.archive.org/save/https://sos.ga.gov/index.php/licensing/plb/45"))
  Sys.sleep(5)
if(ga_page2$response$status_code %in% c("520", "429", "523") | inherits(ga_page2, "try-error")){
  #Try again
  Sys.sleep(1)
  ga_page2 <- try(html_session("https://web.archive.org/save/https://sos.ga.gov/index.php/licensing/plb/45"))
  Sys.sleep(5)
  #Move on if fail second time
  if(ga_page2$response$status_code %in% c("520", "429", "523") | inherits(ga_page2, "try-error")){
    print ("ALERT: ga_page2 failed")
  } else{
    print (ga_page2$response$status_code)
  }
} else{
  print (ga_page2$response$status_code)
}

#Save Illinois processing times to Archive.org
il_page <- try(html_session("https://web.archive.org/save/https://online-dfpr.micropact.com"))
  Sys.sleep(5)
if(il_page$response$status_code %in% c("520", "429", "523") | inherits(il_page, "try-error")){
  #Try again
  Sys.sleep(1)
  il_page <- try(html_session("https://web.archive.org/save/https://online-dfpr.micropact.com"))
  Sys.sleep(5)
  #Move on if fail second time
  if(il_page$response$status_code %in% c("520", "429", "523") | inherits(il_page, "try-error")){
    print ("ALERT: il_page failed")
  } else{
    print (il_page$response$status_code)
  }
} else{
  print (il_page$response$status_code)
}

#Save Kansas processing note to Archive.org
  ks_page <- try(html_session("https://web.archive.org/save/https://ksbn.kansas.gov"))
  Sys.sleep(5)
  if(ks_page$response$status_code %in% c("520", "429", "523") | inherits(ks_page, "try-error")){
    #Try again
    Sys.sleep(1)
    ks_page <- try(html_session("https://web.archive.org/save/https://ksbn.kansas.gov"))
    Sys.sleep(5)
    #Move on if fail second time
    if(ks_page$response$status_code %in% c("520", "429", "523") | inherits(ks_page, "try-error")){
      print ("ALERT: ks_page failed")
    } else{
      print (ks_page$response$status_code)
    }
  } else{
    print (ks_page$response$status_code)
  }

#Save Nevada processing times to Archive.org
nv_page <- try(html_session("https://web.archive.org/save/https://nevadanursingboard.org/covid-19-resource-and-information/"))
  Sys.sleep(5)
if(nv_page$response$status_code %in% c("520", "429", "523") | inherits(nv_page, "try-error")){
  #Try again
  Sys.sleep(1)
  nv_page <- try(html_session("https://web.archive.org/save/https://nevadanursingboard.org/covid-19-resource-and-information/"))
  Sys.sleep(5)
  #Move on if fail second time
  if(nv_page$response$status_code %in% c("520", "429", "523") | inherits(nv_page, "try-error")){
    print ("ALERT: nv_page failed")
  } else{
    print (nv_page$response$status_code)
  }
} else{
  print (nv_page$response$status_code)
}

#Save New York processing times to Archive.org
ny_page <- try(html_session("http://www.op.nysed.gov/prof/nurse/"))
  Sys.sleep(5)
if(ny_page$response$status_code %in% c("520", "429", "523") | inherits(ny_page, "try-error")){
  #Try again
  Sys.sleep(1)
  ny_page <- try(html_session("https://web.archive.org/save/http://www.op.nysed.gov/prof/nurse/"))
  Sys.sleep(5)
  #Move on if fail second time
  if(ny_page$response$status_code %in% c("520", "429", "523") | inherits(ny_page, "try-error")){
    print ("ALERT: ny_page failed")
  } else{
    print (ny_page$response$status_code)
  }
} else{
  print (ny_page$response$status_code)
}

#Save RI processing times to Archive.org
ri_page <- try(html_session("https://web.archive.org/save/https://health.ri.gov/licenses/"))
  Sys.sleep(5)
if(ri_page$response$status_code %in% c("520", "429", "523") | inherits(ri_page, "try-error")){
  #Try again
  Sys.sleep(1)
  ri_page <- try(html_session("https://web.archive.org/save/https://health.ri.gov/licenses/"))
  Sys.sleep(5)
  #Move on if fail second time
  if(ri_page$response$status_code %in% c("520", "429", "523") | inherits(ri_page, "try-error")){
    print ("ALERT: ri_page failed")
  } else{
    print (ri_page$response$status_code)
  }
} else{
  print (ri_page$response$status_code)
}

#Save Wash. processing times to Archive.org
wa_page <- try(html_session("https://web.archive.org/save/https://www.doh.wa.gov/AboutUs/ContactUs"))
  Sys.sleep(5)
if(wa_page$response$status_code %in% c("520", "429", "523") | inherits(wa_page, "try-error")){
  #Try again
  Sys.sleep(1)
  wa_page <- try(html_session("https://web.archive.org/save/https://www.doh.wa.gov/AboutUs/ContactUs"))
  Sys.sleep(5)
  #Move on if fail second time
  if(wa_page$response$status_code %in% c("520", "429", "523") | inherits(wa_page, "try-error")){
    print ("ALERT: wa_page failed")
  } else{
    print (wa_page$response$status_code)
  }
} else{
  print (wa_page$response$status_code)
}

#Save Missouri processing times to Archive.org
  mo_page <- try(html_session("https://web.archive.org/save/https://www.pr.mo.gov/nursing.asp"))
  Sys.sleep(5)
  if(mo_page$response$status_code %in% c("520", "429", "523") | inherits(mo_page, "try-error")){
    #Try again
    mo_page <- try(html_session("https://web.archive.org/save/https://www.pr.mo.gov/nursing.asp"))
    Sys.sleep(5)
    #Move on if fail second time
    if(mo_page$response$status_code %in% c("520", "429", "523") | inherits(mo_page, "try-error")){
      print ("ALERT: mo_page failed")
    } else{
      print (mo_page$response$status_code)
    }
  } else{
    print (mo_page$response$status_code)
  }
