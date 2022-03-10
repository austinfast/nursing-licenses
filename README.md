# nursing-licenses
This GitHub repo contains the code, raw data and methodology for an NPR investigation that aired March 9, 2022, on All Things Considered. 

* NPR.org: ["Nurses are waiting months for licenses as hospital staffing shortages spread"](https://www.npr.org/2022/03/10/1084897499/nurses-are-waiting-months-for-licenses-as-hospital-staffing-shortages-spread)

Two member station reporters produced localized versions and participated in a [reporter roundtable](https://www.npr.org/2022/03/10/1084897499/nurses-are-waiting-months-for-licenses-as-hospital-staffing-shortages-spread) on Morning Edition on March 10, 2022: 

* [Jayme Lozano - Texas Tech Public Media (Lubbock, Texas)](https://radio.kttz.org/news/2022-03-08/data-shows-nurses-may-face-above-average-processing-times-for-licenses-in-texas)
* [Brett Sholtis - WITF (Harrisburg, Pa.)](https://urldefense.com/v3/__https://www.witf.org/2022/03/10/nurses-in-pennsylvania-waited-months-to-get-licenses-to-work-during-historic-staffing-shortage/__;!!Iwwt!CynyfQoW6lmpSOB3yyliU9pazriGPwxigcsXmj9ZnJWW0J-33zzjONglotE$)

# Methodology
On Sept. 23, 2021, NPR requested records for all licensed practical nurses and registered nurses who applied for licensure from 2019 to 2021 from 54 nursing boards, including every state and the District of Columbia. (California, Louisiana and West Virginia have separate RN and LPN boards.)

We asked for each nurse's:

* name
* city
* state
* license type (RN or LPN)
* license duration (temporary or permanent)
* application type (by exam, exam-retest, endorsement, renewal, reinstatement, etc.)
* application status 
* relevant dates (application submission, date when all required documents received, license issuance date and license expiration date). 

California and Virginia provided anonymized records, citing the nurses' privacy, and Connecticut and Virginia couldn't provide details on application type.

States responded as follows: 

**Thirty-three boards granted NPR's request**: 

* Arkansas
* California *(provided anonymized records - charged $60.17)*
* Colorado 
* Connecticut
* Hawaii *(only Feb. 2021 onward because of system migration)*
* Illinois
* Indiana
* Iowa 
* Kentucky 
* Louisiana *(LPN board only)*
* Maine
* Massachusetts 
* Michigan 
* Minnesota 
* Mississippi 
* Montana 
* Nebraska 
* New Hampshire *(redacted city/state)*
* New Jersey 
* New Mexico 
* North Carolina *(charged $875)* 
* Ohio 
* Oklahoma 
* Oregon 
* Pennsylvania 
* South Carolina 
* Texas *(only June 2020 onward because of system migration)* 
* Tennessee *(charged $554)* 
* Vermont 
* Virginia *(provided anonymized records - charged $134)*
* West Virginia *(RN board only)*
* Wyoming *(RN board only)*

**Five boards provided partial data**:

* Alabama provided unusable records
* Four boards provided processing time summaries that NPR could not independently verify:
  + Arizona
  + Idaho
  + Missouri
  + Nevada 

**Two boards did not respond to repeated requests for records**:

* Kansas
* West Virginia (LPN board only)

**Ten boards denied NPR's request**:

* Alaska: Told NPR they have no way to export application dates from their database.
* Delaware: "A public body in Delaware is not required to construct a record that does not previously exist for the purpose of fulfilling a FOIA request."  
* District of Columbia: Told NPR they have no way to export application dates from their database.
* Florida: Initially claimed no responsive records exist. When NPR pointed out annual reports advertise license processing times, the Florida Department of Health charged NPR $150, but has not provided any records to NPR as of March 10, 2022.
* New York: Withheld application dates as invasion of nurses' privacy. NPR's appeal was denied Jan. 10, 2022.
* Maryland: Quoted $213 to provide the records, but a recent system hack prevented the board from providing them.
* Rhode Island: "There are no currently existing records that are responsive to the request."
* South Dakota: Told NPR they have no way to export application dates from their database.
* Utah: The board "is not required to compile, format, manipulate, package, summarize, or tailor information in order to fulfill a request."
* Washington: "Per WAC 44-14-04003 (6) No duty to create records, we do not have anything containing the above highlighted information." 

**Four boards wanted fees that NPR did not pay**:

* Georgia ($434,178)
* Louisiana (RN board only-$1,754)
* North Dakota ($25)
* Wisconsin ($600)

Some boards use different terms for the same idea. For example, licensed practical nurses can also be called licensed vocational nurses, and states refer to licensed nurses applying in a new state as "endorsement" or "reciprocity." NPR standardized these terms among the 32 states' records and combined them into one dataset. 

## [R/Nurse license dataset-publish.Rmd](https://github.com/austinfast/nursing-licenses/blob/main/R/Nurse%20license%20dataset-publish.Rmd)
This is the primary R script used in this investigation.

The first states to respond to NPR's request provided records through Sept. 23, 2021, so NPR removed all records after that date from subsequent states to standardize the timeframe. This resulted in a final dataset containing over 226,000 nurses issued new, permanent licenses in 2021.

NPR subtracted the application date from the license issue date to calculate each nurse's processing time in days. We removed 77 nurses' records showing an issue date earlier than their application date, apparently in error. NPR then grouped by state, license type and application type to find median processing times for each of the four major types and to count how many of the nurses' processing times stretched longer than three months, six months, etc.

## [hhs-scraper.py](https://github.com/austinfast/nursing-licenses/blob/main/hhs-scraper.py)

This Python code scrapes daily updates from the U.S. Department of Health and Human Services showing the number of hospitals reporting that they expect a critical staffing shortage within a week. Hospitals define critical staffing shortages based on their own needs and internal policies.

## [R/critical-staffing-shortages.Rmd](https://github.com/austinfast/nursing-licenses/blob/main/R/critical-staffing-shortages.Rmd)

This R script charts the number of hospitals reporting that they expect a critical staffing shortage within a week.

