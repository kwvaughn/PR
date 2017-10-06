# Original query: https://nwis.waterdata.usgs.gov/pr/nwis/qwdata?chk_all=on&site_no=50010500&site_no=50011000&site_no=50011400&site_no=50020500&site_no=50021000&site_no=50021500&site_no=50023000&site_no=50025000&site_no=50027250&site_no=50028000&site_no=50029000&site_no=50031200&site_no=50034000&site_no=50035000&site_no=50035950&site_no=50038100&site_no=50038200&site_no=50038320&site_no=50039000&site_no=50039500&site_no=50043000&site_no=50044000&site_no=50046000&site_no=50047600&site_no=50047990&site_no=50048510&site_no=50048800&site_no=50049100&site_no=50050300&site_no=50055000&site_no=50055250&site_no=50055400&site_no=50056400&site_no=50057000&site_no=50059000&site_no=50061800&site_no=50063800&site_no=50065500&site_no=50071000&site_no=50072500&site_no=50075000&site_no=50082000&site_no=50083500&site_no=50086500&site_no=50091000&site_no=50092000&site_no=50106500&site_no=50114000&site_no=50115000&site_no=50116500&site_no=50121000&site_no=50124700&site_no=50129700&site_no=50138000&site_no=50143000&site_no=50144000&site_no=50146000&site_no=50147800&site_no=50149100&group_key=NONE&sitefile_output_format=html_table&column_name=agency_cd&column_name=site_no&column_name=station_nm&inventory_output=0&rdb_inventory_output=value&TZoutput=0&pm_cd_compare=Greater%20than&radio_parm_cds=previous_parm_cds&radio_previous_parm_cds=00060%2080154&param_cd_operator=AND&qw_attributes=0&format=rdb&qw_sample_wide=0&rdb_qw_attributes=0&date_format=YYYY-MM-DD&rdb_compression=value&submitted_form=brief_list
# Newer query; includes more sites: https://nwis.waterdata.usgs.gov/pr/nwis/qwdata?chk_all=on&site_no=50010500&site_no=50011000&site_no=50011400&site_no=50020500&site_no=50021000&site_no=50021500&site_no=50023000&site_no=50024950&site_no=50025000&site_no=50025600&site_no=50025850&site_no=50026000&site_no=50026025&site_no=50026050&site_no=50027000&site_no=50027250&site_no=50027750&site_no=50028000&site_no=50028400&site_no=50029000&site_no=50030700&site_no=50031200&site_no=50031500&site_no=50034000&site_no=50035000&site_no=50035500&site_no=50035950&site_no=50038100&site_no=50038191&site_no=50038200&site_no=50038320&site_no=50039000&site_no=50039500&site_no=50043000&site_no=50043800&site_no=50044000&site_no=50044830&site_no=50044850&site_no=50045010&site_no=50046000&site_no=50047530&site_no=50047560&site_no=50047600&site_no=50047820&site_no=50047990&site_no=50048510&site_no=50048770&site_no=50048800&site_no=50049100&site_no=50049820&site_no=50049920&site_no=50049940&site_no=50050300&site_no=50051150&site_no=50051180&site_no=50051310&site_no=50051800&site_no=50053025&site_no=50055000&site_no=50055100&site_no=50055170&site_no=50055225&site_no=50055250&site_no=50055390&site_no=50055400&site_no=50055750&site_no=50056000&site_no=50056400&site_no=50057000&site_no=50057025&site_no=50058350&site_no=50059000&site_no=50059050&site_no=50059100&site_no=50061800&site_no=50063800&site_no=50065500&site_no=50070500&site_no=50071000&site_no=50072500&site_no=50073400&site_no=50074950&site_no=50075000&site_no=50082000&site_no=50083500&site_no=50086500&site_no=50090500&site_no=50091000&site_no=50091800&site_no=50092000&site_no=50095500&site_no=50100450&site_no=50106500&site_no=50108000&site_no=50110900&site_no=50114000&site_no=50114400&site_no=50114900&site_no=50115000&site_no=50116200&site_no=50116500&site_no=50121000&site_no=50124700&site_no=50129700&site_no=50133600&site_no=50136000&site_no=50136400&site_no=50138000&site_no=50138800&site_no=50140900&site_no=50143000&site_no=50144000&site_no=50145395&site_no=50146000&site_no=50146100&site_no=50147600&site_no=50147800&site_no=50149100&group_key=NONE&sitefile_output_format=html_table&column_name=agency_cd&column_name=site_no&column_name=station_nm&inventory_output=0&rdb_inventory_output=file&TZoutput=0&pm_cd_compare=Greater%20than&radio_parm_cds=previous_parm_cds&radio_previous_parm_cds=00061%2080154&param_cd_operator=AND&qw_attributes=0&format=rdb&qw_sample_wide=wide&rdb_qw_attributes=0&date_format=YYYY-MM-DD&rdb_compression=value&submitted_form=brief_list
require(tidyr)
require(dplyr)
require(ggplot2)
library(data.table)

setwd("~/PR/00 Docs/")

file_name = paste("sedqw_allsites.csv")

str = "~/Box Sync/PR Raw Data/Originals/"

file_path = paste(str, file_name, sep = "")

query <- paste("https://nwis.waterdata.usgs.gov/pr/nwis/qwdata?chk_all=on&site_no=50010500&site_no=50011000&site_no=50011400&site_no=50020500&site_no=50021000&site_no=50021500&site_no=50023000&site_no=50024950&site_no=50025000&site_no=50025600&site_no=50025850&site_no=50026000&site_no=50026025&site_no=50026050&site_no=50027000&site_no=50027250&site_no=50027750&site_no=50028000&site_no=50028400&site_no=50029000&site_no=50030700&site_no=50031200&site_no=50031500&site_no=50034000&site_no=50035000&site_no=50035500&site_no=50035950&site_no=50038100&site_no=50038191&site_no=50038200&site_no=50038320&site_no=50039000&site_no=50039500&site_no=50043000&site_no=50043800&site_no=50044000&site_no=50044830&site_no=50044850&site_no=50045010&site_no=50046000&site_no=50047530&site_no=50047560&site_no=50047600&site_no=50047820&site_no=50047990&site_no=50048510&site_no=50048770&site_no=50048800&site_no=50049100&site_no=50049820&site_no=50049920&site_no=50049940&site_no=50050300&site_no=50051150&site_no=50051180&site_no=50051310&site_no=50051800&site_no=50053025&site_no=50055000&site_no=50055100&site_no=50055170&site_no=50055225&site_no=50055250&site_no=50055390&site_no=50055400&site_no=50055750&site_no=50056000&site_no=50056400&site_no=50057000&site_no=50057025&site_no=50058350&site_no=50059000&site_no=50059050&site_no=50059100&site_no=50061800&site_no=50063800&site_no=50065500&site_no=50070500&site_no=50071000&site_no=50072500&site_no=50073400&site_no=50074950&site_no=50075000&site_no=50082000&site_no=50083500&site_no=50086500&site_no=50090500&site_no=50091000&site_no=50091800&site_no=50092000&site_no=50095500&site_no=50100450&site_no=50106500&site_no=50108000&site_no=50110900&site_no=50114000&site_no=50114400&site_no=50114900&site_no=50115000&site_no=50116200&site_no=50116500&site_no=50121000&site_no=50124700&site_no=50129700&site_no=50133600&site_no=50136000&site_no=50136400&site_no=50138000&site_no=50138800&site_no=50140900&site_no=50143000&site_no=50144000&site_no=50145395&site_no=50146000&site_no=50146100&site_no=50147600&site_no=50147800&site_no=50149100&group_key=NONE&sitefile_output_format=html_table&column_name=agency_cd&column_name=site_no&column_name=station_nm&inventory_output=0&rdb_inventory_output=file&TZoutput=0&pm_cd_compare=Greater%20than&radio_parm_cds=previous_parm_cds&radio_previous_parm_cds=00061%2080154&param_cd_operator=AND&qw_attributes=0&format=rdb&qw_sample_wide=wide&rdb_qw_attributes=0&date_format=YYYY-MM-DD&rdb_compression=value&submitted_form=brief_list")

# Get the requested data from USGS
odf <- fread(query, skip = 180L)

# See what the data looks like pre-manipulation
str(odf)

# Save the original file for reference
write.csv(odf, gsub(".csv", "_Precleaning.csv", file_path), row.names=FALSE, na = "")

# Remove all the unnecessary columns and header information
df <- cbind(odf[2:nrow(odf),2], odf[2:nrow(odf),3], odf[2:nrow(odf),4], 
            odf[2:nrow(odf),13], odf[2:nrow(odf),14])
str(df)
df <- data.frame(df)
colnames(df) <- c("site", "date", "time", "discfs", "sedmgl")


# # Create an hours column
# df <- dplyr::mutate(df, hh = substr(time, 1, 2))
# 
# # Create a minutes column
# df <- dplyr::mutate(df, mm = substr(time, 4, 5))

df$date = as.Date(as.character(df$date))

# Reclassify result column as numeric
df$discfs = as.numeric(df$discfs)

df$sedmgl = as.numeric(df$sedmgl)

df$dism3 = df$discfs * 0.0283168

newdf = dplyr::filter(df, !is.na(dism3))



summarydf = dplyr::group_by(newdf, site) %>% dplyr::summarize(count = n(), first = first(date), last = last(date))

studydf = dplyr::filter(newdf, date >= "1995-01-01") %>% dplyr::filter(date < "2015-01-01") %>% 
  dplyr::group_by(site) %>% dplyr::summarize(count = n(), first = first(date), last = last(date))

write.csv(summarydf, gsub("Originals/", "Summary_", file_path), row.names=FALSE, na = "")

write.csv(studydf, gsub("Originals/", "StudyPeriod_", file_path), row.names=FALSE, na = "")
