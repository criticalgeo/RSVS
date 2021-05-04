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
  temp_feed <- tidyfeed(rss_feeds$rss[row]) %>% # read RSS feed into data frame
    select(-c("item_category")) # remove last column of item_category (it's in list format and irrelevant to data collection)
  write.csv(temp_feed, paste0(target_folder, "/", rss_feeds$name[row], ".csv"))
}


