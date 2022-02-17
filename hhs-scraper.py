import pandas as pd
import time
import os
os.environ['TZ'] = 'America/Los_Angeles' # set new timezone
time.tzset()

url="https://healthdata.gov/api/views/g62h-syeh/rows.csv?accessType=DOWNLOAD"

#Read current data into dataframe
data = pd.read_csv(url)
#Save as CSV
#data.to_csv(f'./hhs/scrapes/{time.strftime("%Y-%m-%d-%H-%M")}.csv', index=False)

#Select columns
data2 = data[['date', 'state', 'critical_staffing_shortage_anticipated_within_week_yes',
                                 'critical_staffing_shortage_anticipated_within_week_no', 
                                 'critical_staffing_shortage_anticipated_within_week_not_reported']]

#Convert date to datetime
data2['date'] = pd.to_datetime(data2['date'])

#Check which are after Aug. 1, 2020 when data got better reported
start_date = "2020-8-1"
after_start_date = data2["date"] >= start_date

#Pull out Aug. 1, 2020 onward
data2 = data2.loc[after_start_date]

#Re-sort 
data2 = data2.sort_values(by = ['date', 'state'], ascending = (False, True))

#SAVE RAW DATA TO FILE
data2.to_csv(f'./hhs/scrapes/{time.strftime("%Y-%m-%d-%H-%M")}.csv', index=False)



#CALCULATE NATIONAL RATE ======================================= |
data3 = data2.groupby('date').agg(
    yes = pd.NamedAgg(column='critical_staffing_shortage_anticipated_within_week_yes', aggfunc=sum),
    no = pd.NamedAgg(column='critical_staffing_shortage_anticipated_within_week_no', aggfunc=sum),
    missing = pd.NamedAgg(column='critical_staffing_shortage_anticipated_within_week_not_reported', aggfunc=sum))

#Calculate total
data3["total"] = data3["yes"] + data3["no"] + data3["missing"]
#Calculate those saying yes of those that answered
data3["pct_yes"] = data3["yes"] / (data3["yes"] + data3["no"])
#Calculate those answering of all hospitals
data3["pct_reporting"] = ( data3["yes"] + data3["no"] ) / data3["total"]

#Calculate 7-day rolling average of percent of hospitals anticipating critical staffing shortages within a week
data3['roll_avg'] = data3["pct_yes"].rolling(7).mean()
#Calculate 7-day rolling average of percent of hospitals providing responses
data3['roll_reporting'] = data3["pct_reporting"].rolling(7).mean()

#Re-sort
data3 = data3.sort_values(by = 'date', ascending = False)

#SAVE NATIONAL RATE TO FILE
data3.to_csv(f'./hhs/national/{time.strftime("%Y-%m-%d-%H-%M")}.csv', index=False)



#CALCULATE STATE RATES ======================================= |
data4 = data2.groupby(['date','state']).agg(
    yes = pd.NamedAgg(column='critical_staffing_shortage_anticipated_within_week_yes', aggfunc=sum),
    no = pd.NamedAgg(column='critical_staffing_shortage_anticipated_within_week_no', aggfunc=sum),
    missing = pd.NamedAgg(column='critical_staffing_shortage_anticipated_within_week_not_reported', aggfunc=sum))

#Calculate total
data4["total"] = data4["yes"] + data4["no"] + data4["missing"]
#Calculate those saying yes of those that answered
data4["pct_yes"] = data4["yes"] / (data4["yes"] + data4["no"])
#Calculate those answering of all hospitals
data4["pct_reporting"] = ( data4["yes"] + data4["no"] ) / data4["total"]

#Calculate 7-day rolling average of percent of hospitals anticipating critical staffing shortages within a week
data4['roll_avg'] = data4["pct_yes"].rolling(7).mean()
data4['roll_reporting'] = data4["pct_reporting"].rolling(7).mean()

#Re-sort
data4 = data4.sort_values(by = ['date', 'state'], ascending = (False, True))

#SAVE STATE RATES TO FILE
data4.to_csv(f'./hhs/states/{time.strftime("%Y-%m-%d-%H-%M")}.csv', index=False)
