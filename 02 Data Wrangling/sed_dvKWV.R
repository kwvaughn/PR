# This script pulls suspended-sediment data (parameter #80154, "Suspended sediment concentration, 
# milligrams per liter") from the NWIS water-quality database for a given set of water-quality
# measurement locations.  Currently it collects all existing suspended-sediment data, regardless 
# of date, but that can be narrowed down if necessary.
#
# Original search: 
# https://nwis.waterdata.usgs.gov/pr/nwis/dv?cb_80154=on&format=rdb&site_no=50050900&referred_module=qw&period=&begin_date=1960-01-01&end_date=2017-09-21


require(dplyr)
library(data.table)

setwd("~/PR/00 Docs/")

# This collection lists all of the sites to collect data from.
sitelist = c(50051800, 50055000, 50055225, 50055750, 50057000)


# This loop will collect data from each site in the collection called 'sitelist'.  
for(i in sitelist){
  
  siteno <- i
    
    file_name = paste("seddv_", siteno, ".csv", sep = "")
    
    str = "~/Box Sync/PR Raw Data/Originals/"
    
    file_path = paste(str, file_name, sep = "")
    
    query <- paste("https://nwis.waterdata.usgs.gov/pr/nwis/dv?cb_80154=on&format=rdb&site_no=", siteno, 
                   "&referred_module=qw&period=&begin_date=1960-01-01&end_date=2017-09-21", sep = "")
    
    # Get the requested data from USGS
    # If running by hand for 50071000, add "skip = 27L" to fread parameters
    odf <- fread(query)
    
    # See what the data looks like pre-manipulation
    str(odf)
    
    # Save the original file for reference
    write.csv(odf, gsub(".csv", "_Precleaning.csv", file_path), row.names=FALSE, na = "")
    
    # Remove all the unnecessary columns and header information
    df <- cbind(odf[2:nrow(odf),3], odf[2:nrow(odf),4])
    str(df)
    df <- data.frame(df)
    colnames(df) <- c("date", "sedmgl")
    
    # Reclassify discharge column as numeric
    df$sedmgl = as.numeric(df$sedmgl)
    
    # Reclassify date column as Date type
    df$date = as.Date(as.character(df$date))
    
    # Write information to a new file
    write.csv(df, gsub("Originals", "Suspended Sediment", file_path), row.names=FALSE, na = "")
    
    print(paste("Files saved for site", siteno))
  
}
print("All tasks complete.")
