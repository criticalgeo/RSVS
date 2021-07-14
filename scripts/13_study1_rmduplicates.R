# STUDY 1: DATA FILTERING #######################
# REMOVE DUPLICATE LINKS TO EXPEDITE FILTERING ##

library(googlesheets4) # for interfacing with Google Sheets

# link to raw feeds
ss <- "https://docs.google.com/spreadsheets/d/1vg1N83tw0_s9dcCf7amnF-1NGahtIv1sO9o-grRWXiA/edit#gid=36595014" 

# link to list of RSS feed names
rss_ss <- "https://docs.google.com/spreadsheets/d/1YH1gRthVQjP33tTPxp4PAxlZSqzjfMo3b2-k2PjGqpM/edit?ouid=105047394448799337207&usp=sheets_home&ths=true"

# link to new spreadsheet where cleaned up feeds will be uploaded
new_ss <- "https://docs.google.com/spreadsheets/d/1zzRDai1VRg6lh31vfKwBT0qk8CY_w0kDVxQ4qGoNXBU/edit#gid=0"

# gathering list of rss feed names (i.e. tab names to loop through)
rss_names <- read_sheet(rss_ss)

summary_df <- data.frame(feed = character(), old_row_count = numeric(), new_row_count = numeric())

lapply(rss_names$name, function(feed) {
  sheet <- read_sheet(ss = ss, sheet = feed) # reading in sheet for a particular feed
  sheet$collection_date <- as.character(sheet$collection_date) # sometimes the collection date column is imported as a list...converting to character vector
  sheet_nodups <- sheet[!duplicated(sheet$item_link), ] # removing duplicates
  
  # creating a summary sheet of old row count and new row count to see how many were removed
  df_row <- data.frame(feed = feed, old_row_count = nrow(sheet), new_row_count = nrow(sheet_nodups)) 
  summary_df <<- rbind(summary_df, df_row)
  
  write_sheet(sheet_nodups, new_ss, sheet = feed) # write to GOogle Sheets
  write.csv(sheet_nodups, paste0("data/processed/study1/study1_feeds_nodups_0714/", feed, "_nodups_0714.csv")) # write local CSV
})

write.csv(summary_df, "data/processed/study1/study1_feeds_nodups_0714/summary_nodups_0714.csv")


