# If we wanted to automate the grabbing of files from USGS, we could.  Here's a link that generates
# a tab-delimited file showing the discharge rates (code 00060) for Guanajibo near Hormigueros 
# (code 50138000) for the calendar year of 1995:
# https://nwis.waterdata.usgs.gov/nwis/uv?cb_00060=on&format=rdb&site_no=50138000&period=&begin_date=2006-01-01&end_date=2006-12-31
# This file can be interpreted as-is by R, I think, if we can figure out how to store it once it's 
# downloaded.

require(dplyr)
library(data.table)

year <- "2006"

siteno <- "50138000"

query <- paste("https://nwis.waterdata.usgs.gov/nwis/uv?cb_00060=on&format=rdb&site_no=", siteno, 
               "&period=&begin_date=", year, "-01-01&end_date=", year, "-12-31", sep = "")

# Get the requested data from USGS
odf <- fread(query)

# See what the data looks like pre-manipulation
str(odf)

# Remove all the unnecessary columns and header information
df <- cbind(odf[2:nrow(odf),3], odf[2:nrow(odf),5])
str(df)

# Break the date into its own column
df <- dplyr::mutate(df, date = substr(datetime, 0, 10))

# Create an hours column
df <- dplyr::mutate(df, hh = substr(datetime, 12, 13))

# Create a minutes column
df <- dplyr::mutate(df, mm = substr(datetime, 15, 16))









