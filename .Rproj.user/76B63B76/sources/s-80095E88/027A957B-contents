# Gathering sample set of tweets for Study 2 to see assess occurrence of maps 
# 04/01/2021

library(googlesheets4) # for interfacing with source sheet
library(rtweet) # Twitter API wrapper 
library(dplyr) # data wrangling

sources <- read_sheet("https://docs.google.com/spreadsheets/d/12qBxLkx1_H5qQgsVDyf0FP3PasunNnpR3pDwd-qY_xM/edit#gid=0")

sources$twitter_handle <- gsub("@", "", sources$twitter_handle) # replace "@" signs in twitter_handle column
sources <- sources[!duplicated(sources$twitter_handle), ] # removing duplicate handles

# creating list of data frames from all sources
df_list <- lapply(sources$twitter_handle, function(x) {
  df <- get_timeline(x, n = 300) # dk why this returns 40?
}) 

# loop to export CSVs
lapply(df_list, function(df) {
  df_nodate <- apply(df, 2, as.character) # converting all columns to characters (some are lists)
  df_nodate <- as.data.frame(df_nodate) %>% # selecting relevant columns 
    select(c(user_id, status_id, screen_name, text, urls_t.co))
  df <- cbind(df_nodate, df$created_at) # joining back date column (character conversion had changed data format)
  df <- df[c(6, 1:5)] # arranging rows so date column is first
  names(df)[1] <- "created_at" # changing name of date column
  write.csv(df, paste0("data/processed/study2_sample_0401/", df$screen_name[1], ".csv")) # exporting CSV
})




