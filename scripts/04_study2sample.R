# Gathering sample set of tweets for Study 2 to see assess occurrence of maps 
# 04/01/2021

# 04/12/2021 UPDATE:
# script to save a sample of tweets into a designated folder

library(googlesheets4) # for interfacing with source sheet
library(rtweet) # Twitter API wrapper 
library(dplyr) # data wrangling

api_key <- "a7CB7bUNNFrivMuDx96BJU18T"
api_secret <- "tnmAaz1Px4vF7iuxG6EnCn8afg3oa5uFJlfd9gdU3yQyHgmV57"

token <- create_token(
  app = "rsvs2",
  consumer_key = api_key,
  consumer_secret = api_secret
)

###### OJA #######
sources <- read_sheet("https://docs.google.com/spreadsheets/d/12qBxLkx1_H5qQgsVDyf0FP3PasunNnpR3pDwd-qY_xM/edit#gid=0")

sources$twitter_handle <- gsub("@", "", sources$twitter_handle) # replace "@" signs in twitter_handle column
sources <- sources[!duplicated(sources$twitter_handle), ] # removing duplicate handles

# creating list of data frames from all sources
df_list <- lapply(sources$twitter_handle, function(x) {
  df <- get_timeline(x, n = 300) # dk why this returns 400?
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

# GENERALIZING INTO FUNCTION

# PARAMETERS:
# 1. googlesheet — URL of googlesheet (or URL stored in variable)
# 2. tab — tab number on Google Sheet
# 2. no_tweets — number of tweets to retrieve
# 3. col_name — name of column containing twitter handles
# 4. folder — folder path to save to


generateFeed <- function(googlesheet, tab, no_tweets, col_name, folder) {
  
  sources <<- read_sheet(googlesheet, tab)
  names(sources)[names(sources) == col_name] <- "twitter_handle" # renaming column
  sources$twitter_handle <- gsub("@", "", sources$twitter_handle) # replace "@" signs in twitter_handle column
  sources <- sources[!duplicated(sources$twitter_handle), ] # removing duplicate handles
  sources <- sources %>%
    filter(twitter_handle != "")
  
  # creating list of data frames from all sources
  df_list <- lapply(sources$twitter_handle, function(x) {
    df <- get_timeline(x, n = no_tweets) 
  }) 
  
  # loop to export CSVs
  lapply(df_list, function(df) {
    df_nodate <- apply(df, 2, as.character) # converting all columns to characters (some are lists)
    print(df$screen_name[1])
    df_nodate <- as.data.frame(df_nodate) %>% # selecting relevant columns 
      select(c(user_id, status_id, screen_name, text, urls_t.co, media_url))
    df <- cbind(df_nodate, df$created_at) # joining back date column (character conversion had changed data format)
    df <- df[c(7, 1:6)] # arranging rows so date column is first
    names(df)[1] <- "created_at" # changing name of date column 
    
    write.csv(df, paste0("data/processed/", folder, "/", df$screen_name[1], ".csv")) # exporting CSV
  })
}
generateRandomFeed <- function(googlesheet, tab, no_tweets, col_name, folder) {
  
  sources <<- read_sheet(googlesheet, tab)
  names(sources)[names(sources) == col_name] <- "twitter_handle" # renaming column
  sources$twitter_handle <- gsub("@", "", sources$twitter_handle) # replace "@" signs in twitter_handle column
  sources <- sources[!duplicated(sources$twitter_handle), ] # removing duplicate handles
  sources <- sources %>%
    filter(twitter_handle != "") %>%
    filter(twitter_handle != "VisualCinnamon")
  
  # creating list of data frames from all sources
  df_list <- lapply(sources$twitter_handle, function(x) {
    set.seed(100)
    df <- get_timeline(x, n = 3200) 
    if(nrow(df) >= no_tweets) {
      df <- df %>% sample_n(size= no_tweets)
    } else {
      df <- df
    }
  }) 
  
  # loop to export CSVs
  lapply(df_list, function(df) {
    df_nodate <- apply(df, 2, as.character) # converting all columns to characters (some are lists)
    print(df$screen_name[1])
    df_nodate <- as.data.frame(df_nodate) %>% # selecting relevant columns 
      select(c(user_id, status_id, screen_name, text, urls_t.co, media_url))
    df <- cbind(df_nodate, df$created_at) # joining back date column (character conversion had changed data format)
    df <- df[c(7, 1:6)] # arranging rows so date column is first
    names(df)[1] <- "created_at" # changing name of date column 
    
    write.csv(df, paste0("data/processed/", folder, "/", df$screen_name[1], ".csv")) # exporting CSV
  })
}
malofiej <- "https://docs.google.com/spreadsheets/d/12qBxLkx1_H5qQgsVDyf0FP3PasunNnpR3pDwd-qY_xM/edit#gid=150388580"

generateFeed(malofiej, 3, 100, "twitter", "study2_sample_malofiej_0409")
generateFeed(malofiej, 3, 100, "twitter_graphics", "study2_sample_malofiejgraphics_0409")

generateRandomFeed(malofiej, 3, 100, "twitter_graphics", "study2_sample_malofiejgraphics_0412")
generateRandomFeed(malofiej, 3, 100, "twitter", "study2_sample_malofiej_0414")
