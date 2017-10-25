# This script automates the grabbing of files from USGS's water database.  Here's a link that generates
# a tab-delimited file showing the discharge rates (code 00060) for Guanajibo near Hormigueros 
# (code 50138000) for the calendar year of 1995:
# https://nwis.waterdata.usgs.gov/nwis/uv?cb_00060=on&format=rdb&site_no=50138000&period=&begin_date=2006-01-01&end_date=2006-12-31

# Site numbers of interest:
# 50138000: Rio Guanajibo near Hormigueros
# 50147800: Rio Culebrinas at Hwy 404 near Moca
# 50136400: Rio Rosario near Hormigueros
# 50144000: Rio Grande de Anasco near San Sebastian
# 50043800: Rio de la Plata at Comerio
# 50044810: Rio Guadiana near Guadiana (pre-2001 data unavailable)
# 50050900: Rio Grande de Loiza at Quebrada Arenas
# 50053025: Rio Turabo above Borinquen
# 50056400: Rio Valenciano near Juncos
# 50058350: Rio Canas at Rio Canas
# 50063800: Rio Espiritu Santo near Rio Grande
# 50065500: Rio Mameyes near Sabana
# 50071000: Rio Fajardo near Fajardo (missing data: 10/1/1997 - 9/30/2007)
# 50075000: Rio Icacos near Naguabo (missing data: 10/1/04 - 9/30/2007)
# 50110900: Rio Toa Vaca above Lago Toa Vaca
# 50114900: Rio Portugues near Tibes (pre-1997 data unavailable)
# 50051800
# 50055000
# 50055225
# 50055750
# 50057000


require(dplyr)
library(data.table)

setwd("~/PR/00 Docs/")

# This collection lists all of the sites to collect data from.
sitelist = c(50051800, 50055000, 50055225, 50055750, 50057000)


# This loop will collect data from each site in the collection called 'sitelist'.  
# For this loop to work, the range of available data for a site must include the years 1995-2015; 
# if that range isn't available, disable this loop, adjust the date range below, and run it manually.
for(i in sitelist){
  
  siteno <- i
  
  # This loop will collect a separate data file for every year in the date range (inclusive).
  # If the default date range isn't available, adjust these numbers to reflect available date range.
  for(j in 1995:2015){
    
    year <- j
    
    ofile_name = paste(siteno, "_", year, ".csv", sep = "")
    
    str = "~/Box Sync/PR Raw Data/Originals/"
    
    file_path = paste(str, ofile_name, sep = "")
    
    query <- paste("https://nwis.waterdata.usgs.gov/nwis/uv?cb_00060=on&format=rdb&site_no=", siteno, 
                   "&period=&begin_date=", year, "-01-01&end_date=", year, "-12-31", sep = "")
    
    # Get the requested data from USGS
    odf <- fread(query, skip = 24L)
    
    # See what the data looks like pre-manipulation
    str(odf)
    
    # Save the original file for reference
    write.csv(odf, gsub(".csv", "_Precleaning.csv", file_path), row.names=FALSE, na = "")
    
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
    
    # Set beginning date for finding elapsed time
    startdate <- as.Date(paste(year, "-01-01", sep = ""))
    
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
    fulldf <- dplyr::inner_join(newdf, meandism315, by = "elapsedhours")
    
    # Write 15-minute interval information to a new file
    # Commented out because the hourly data is more useful; change gsub before use
    #write.csv(fulldf, gsub("Precleaning_", "15_", file_path), row.names=FALSE, na = "")
    
    # Trim dataset to hourly averages
    hourlydf <- fulldf %>% group_by(date, elapseddays, elapsedhours, avgdism3) %>% summarise(avgdism315 = mean(dischargem3))
    
    # Write hourly information to a new file
    write.csv(hourlydf, gsub("Originals", "Discharge Yearly", file_path), row.names=FALSE, na = "")
    
  }
  
}