import pandas as pd
import time
import os
os.environ['TZ'] = 'America/Los_Angeles' # set new timezone
time.tzset()

url="https://healthdata.gov/api/views/g62h-syeh/rows.csv?accessType=DOWNLOAD"

#Read current data into dataframe
data = pd.read_csv(url)
#Save as CSV
data.to_csv(f'/hhs/scrapes/{time.strftime("%Y%m%d")}.csv', index=False)
