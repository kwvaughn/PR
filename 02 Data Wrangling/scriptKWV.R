# If we wanted to automate the grabbing of files from USGS, we could.  Here's a link that generates
# a tab-delimited file showing the discharge rates (code 00060) for Guanajibo near Hormigueros 
# (code 50138000) for the calendar year of 1995:
# https://nwis.waterdata.usgs.gov/nwis/uv?cb_00060=on&format=rdb&site_no=50138000&period=&begin_date=2006-01-01&end_date=2006-12-31
# This file can be interpreted as-is by R, I think, if we can figure out how to store it once it's 
# downloaded.

require(dplyr)
library(data.table)

setwd("~/PR/00 Doc/")

year <- "2006"

siteno <- "50138000"

startdate <- as.Date(paste(year, "-01-01", sep = ""))

ofile_name = paste("Precleaning_", siteno, "_", year, ".csv", sep = "")

file_path = paste("../01 Data/", ofile_name, sep = "")

query <- paste("https://nwis.waterdata.usgs.gov/nwis/uv?cb_00060=on&format=rdb&site_no=", siteno, 
               "&period=&begin_date=", year, "-01-01&end_date=", year, "-12-31", sep = "")

# Get the requested data from USGS
odf <- fread(query)

# See what the data looks like pre-manipulation
str(odf)

# Save the original file for reference
write.csv(odf, file_path, row.names=FALSE, na = "")

# Remove all the unnecessary columns and header information
df <- cbind(odf[2:nrow(odf),3], odf[2:nrow(odf),5])
str(df)
df <- data.frame(df)
colnames(df) <- c("datetime", "dischargecfs")

# Reclassify discharge column as numeric
df$dischargecfs = as.numeric(df$dischargecfs)

# Break the date into its own column
df <- dplyr::mutate(df, date = substr(datetime, 0, 10))

# Create an hours column
df <- dplyr::mutate(df, hh = substr(datetime, 12, 13))

# Create a minutes column
df <- dplyr::mutate(df, mm = substr(datetime, 15, 16))

# Convert discharge from cfs to m3s
df$dischargem3 = df$dischargecfs * 0.0283168

# Reclassify date column as Date type
df$date = as.Date(as.character(df$date))

# Create new column with elapsed days since beginning of year (Jan 1 is day 0)
df <- dplyr::mutate(df, elapseddays = as.numeric(df$date - startdate))

# Create new column with elapsed hours since beginning of year (midnight Jan 1 is hour 0)
df <- dplyr::mutate(df, elapsedhours = df$elapseddays * 24 + as.numeric(df$hh))

# Get average discharge per hour
meandism3 <- df %>% group_by(elapsedhours) %>% summarise(avgdism3 = mean(dischargem3))

# Add hourly average to each reading
newdf <- dplyr::inner_join(df, meandism3, by = "elapsedhours")

# Drop all records that aren't from quarter-hour measurements
newdf <-  newdf[which(newdf[,"mm"]=="00"
                        |newdf[,"mm"]=="15"
                        |newdf[,"mm"]=="30"
                        |newdf[,"mm"]=="45"),]

# Get average discharge per hour, using 15-minute data
meandism315 <- newdf %>% group_by(elapsedhours) %>% summarise(avgdism315 = mean(dischargem3))

# Add hourly average to each reading
newdf <- dplyr::inner_join(newdf, meandism315, by = "elapsedhours")

# Here is where we'll need to reorganize the columns and strip unneeded data.
# I need some input here, or even just to see Cody's cleaned files.


# Write information to a new file
write.csv(newdf, gsub("Precleaning_", "", file_path), row.names=FALSE, na = "")





