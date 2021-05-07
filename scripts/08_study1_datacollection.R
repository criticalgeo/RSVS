# STUDY 1 DATA COLLECTION SCRIPT: PART 1 #
# saves articles links from RSS feeds into folder 

library(googlesheets4) # for interfacing with data stored in Google Sheets 
library(dplyr) # data wrangling
library(tidyRSS) # for reading RSS feeds

today <- Sys.Date() # storing today's date

# define target folder where feeds should be saved
target_folder <- paste0("data/raw/study1/raw_feeds/", today)

# check if target folder exists; if not, create new directory
if (!dir.exists(target_folder)) {
  dir.create(target_folder)
}

# storing Google Sheet URL containing RSS feeds
ss <- "https://docs.google.com/spreadsheets/d/1YH1gRthVQjP33tTPxp4PAxlZSqzjfMo3b2-k2PjGqpM/edit?usp=sharing"

rss_feeds <- read_sheet(ss) # reading in sheet


for (row in 1:nrow(rss_feeds)) {
  tryCatch(
    # attempt to retrieve RSS feed
    {tidyfeed(rss_feeds$rss[row]) %>%
        select(-c("item_category")) %>%
        write.csv(paste0(target_folder, "/", rss_feeds$name[row], ".csv"))
      },
    # if error, push error message
    error = function(cond) {
      message(paste0("ERROR (", rss_feeds$name[row], "):\n"))
      message(cond)
      message("\nExamine RSS feed link. Once feed is succesfully retrieved in your browser, use code at the bottom of this script to collect this feed separately. \n")
    },
    # if warning, push warning message
    warning = function(cond) {
      message(paste0("WARNING (", rss_feeds$name[row], "):\n"))
      message(cond)
      message("\nExamine RSS feed link. Once feed is succesfully retrieved in your browser, use code at the bottom of this script to collect this feed separately. \n")
    }
  )
}

# IF THE ABOVE LOOP MISSED A FEED, UNCOMMENT (Cmd + Shift + C) LINES 48 - 53, INSERT MISSING FEED NAME IN LINE 48, THEN RUN LINES 48-53 UNTIL FEED IS SUCCESSFULLY SAVED
# input missing feed in line 48, e.g. "wapo_world"
# missing_feed <- "INSERT MISSING FEED HERE"
# 
# temp_df <- tidyfeed(rss_feeds$rss[rss_feeds$name == missing_feed]) %>%
#     select(-c("item_category"))
#   
# write.csv(temp_df, paste0(target_folder, "/", missing_feed, ".csv"))




