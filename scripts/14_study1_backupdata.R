# STUDY 1: DOWNLOAD / BACKUP DATA #########################
# DOWNLOAD BIG COMPILED RAW FEED DATA FROM GOOGLE SHEETS ##

library(googlesheets4)

# link to raw feeds
ss <- "https://docs.google.com/spreadsheets/d/1vg1N83tw0_s9dcCf7amnF-1NGahtIv1sO9o-grRWXiA/edit#gid=36595014" 

# link to list of RSS feed names
rss_ss <- "https://docs.google.com/spreadsheets/d/1YH1gRthVQjP33tTPxp4PAxlZSqzjfMo3b2-k2PjGqpM/edit?ouid=105047394448799337207&usp=sheets_home&ths=true"

# reading in names of RSS feeds
rss_names <- read_sheet(rss_ss)

lapply(rss_names$name, function(feed) {
  sheet <- read_sheet(ss = ss, sheet = feed) # read in feed 
  sheet$collection_date <- as.character(sheet$collection_date) # sometimes the collection date column is imported as a list...converting to character vector 
  sheet <- sheet[1:(ncol(sheet_nodups)-3)] # deselect map, video, and notes columns for a clean raw feed
  write.csv(sheet, paste0("data/raw/study1/raw_feeds/", feed, "_complete.csv"))
})

