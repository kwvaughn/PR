# This script pulls suspended-sediment data (parameter #80154, "Suspended sediment concentration, 
# milligrams per liter") from the NWIS water-quality database for a given set of water-quality
# measurement locations.  Currently it collects all existing suspended-sediment data, regardless 
# of date, but that can be narrowed down if necessary.
#
# Original search; returns a lot of extra stuff
# https://nwis.waterdata.usgs.gov/nwis/qwdata?qw_count_nu=1&site_no=50147800&parameter_cd=80154&inventory_output=0&rdb_inventory_output=value&begin_date=&end_date=&TZoutput=0&pm_cd_va_search=&pm_cd_compare=Greater+than&pm_cd_result_va=&radio_previous_parm_cds=&param_cd_operator=&radio_parm_cds=all_parm_cds&radio_multiple_parm_cds=&radio_parm_cd_file=&qw_attributes=0&format=rdb&qw_sample_wide=0&rdb_qw_attributes=0&date_format=YYYY-MM-DD&rdb_compression=value
#
# Modified search: only returns 80154 data
# https://nwis.waterdata.usgs.gov/nwis/qwdata?qw_count_nu=1&site_no=50147800&parameter_cd=80154&inventory_output=0&rdb_inventory_output=value&begin_date=&end_date=&TZoutput=0&qw_attributes=0&format=rdb&qw_sample_wide=0&rdb_qw_attributes=0&date_format=YYYY-MM-DD&rdb_compression=value


require(dplyr)
library(data.table)

setwd("~/PR/00 Docs/")

# This collection lists all of the sites to collect data from.  The script will fail upon trying to collect nonexistent data.
sitelist = c(50051800, 50055000, 50055225, 50055750, 50057000)


# This loop will collect data from each site in the collection called 'sitelist'.  
for(i in sitelist){
  
  siteno <- i
  
  file_name = paste("sedqw_", siteno, ".csv", sep = "")
  
  str = "~/Box Sync/PR Raw Data/Originals/"
  
  file_path = paste(str, file_name, sep = "")
  
  query <- paste("https://nwis.waterdata.usgs.gov/nwis/qwdata?qw_count_nu=1&site_no=", siteno, "&parameter_cd=80154&inventory_output=0&rdb_inventory_output=value&begin_date=&end_date=&TZoutput=0&qw_attributes=0&format=rdb&qw_sample_wide=0&rdb_qw_attributes=0&date_format=YYYY-MM-DD&rdb_compression=value", sep = "")
  
  # Get the requested data from USGS
  odf <- fread(query, skip = 72L)
  
  # See what the data looks like pre-manipulation
  str(odf)
  
  # Save the original file for reference
  write.csv(odf, gsub(".csv", "_Precleaning.csv", file_path), row.names=FALSE, na = "")
  
  # Remove all the unnecessary columns and header information
  df <- cbind(odf[2:nrow(odf),3], odf[2:nrow(odf),4], odf[2:nrow(odf),15])
  str(df)
  df <- data.frame(df)
  colnames(df) <- c("date", "time", "sedmgl")
  
  # Reclassify discharge column as numeric
  df$sedmgl = as.numeric(df$sedmgl)
  
  # Create an hours column
  df <- dplyr::mutate(df, hh = substr(time, 1, 2))
  
  # Create a minutes column
  df <- dplyr::mutate(df, mm = substr(time, 4, 5))
  
  # Reclassify date column as Date type
  df$date = as.Date(as.character(df$date))
  
  # Trim dataset
  cleandf <- df %>% select(date, hh, mm, sedmgl)
  
  # Write information to a new file
  write.csv(cleandf, gsub("Originals", "Suspended Sediment", file_path), row.names=FALSE, na = "")
  
  print(paste("Files saved for site", siteno))
  
}
print("All tasks complete.")