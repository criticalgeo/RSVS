# STUDY 1: SLICE OUT MAPS THAT CONTAIN MAPS 

library(dplyr)
library(googlesheets4)
library(lubridate)

# sheet containing raw feeds
ss <- "https://docs.google.com/spreadsheets/d/1vg1N83tw0_s9dcCf7amnF-1NGahtIv1sO9o-grRWXiA/edit#gid=794235562"

# new sheet for filtered data to be uploaded to
new_ss <- "https://docs.google.com/spreadsheets/d/1kSMYrBOMQI_N44-4GjkeNdOMJDvEAg8v_NtgpOUy0Vg/edit#gid=0"

# list containing feed names to loop through
# feed_list <- c("bbc_topstories", "bbc_uk", "bbc_world", "nyt_homepage","nyt_upshot", "nyt_us", "nyt_world", "propublica", "wapo_us", "wapo_world")

# shorter feed list for this study 
feed_list <- c("bbc_uk", "bbc_world", "nyt_us", "nyt_world", "propublica", "wapo_us", "wapo_world")

# creating empty data frame for summary stats
summary_df <- data.frame(feed = character(), no_articles = numeric(), yes_maps = numeric(), share_yes_maps = character(), maybe_maps = numeric(), share_maybe_maps = character()) 

# creating empty data frame to bind all filtered feeds together 
compiled_df <- data.frame(feed_name = character(), collection_date = character(), feed_pub_date = character(), item_title = character(), item_link = character(), item_pub_date = character(), maps = character(), notes = character())

lapply(feed_list, function(feed) {
  df <- read_sheet(ss, feed, col_types = "c") 
  names(df)[names(df) == "map?"] <- "maps"
  df$collection_date <- ymd(df$collection_date)
  df <- df %>%
    filter(!is.na(maps)) %>%
    filter(collection_date <= as.Date("2021-05-09"))
  df$maps <- gsub("yes", "y", df$maps)
  df$maps <- gsub("no", "n", df$maps)
  df$maps <- gsub ("maybe", "m", df$maps)
  
  df_maps <- df %>%
    filter(maps == "y" | maps == "m")
  
  write_sheet(df_maps, ss = new_ss, sheet = feed)
  write.csv(df_maps, paste0("data/processed/study1/study1_filtered_feeds/", feed, "_filtered.csv"))
  
  # add column for feed name in preparation for binding to other feeds & selecting columns to make sure all feeds have the same number of columns for row binding
  df_maps <- df_maps %>%
    mutate(feed_name = feed) %>%
    select(feed_name, collection_date, feed_pub_date, item_title, item_link, item_pub_date, maps, notes)
  
  compiled_df <<- rbind(compiled_df, df_maps)
  
  # create summary tables to see how many maps
  no_articles <- nrow(df)
  yes_maps <- nrow(df[df$maps == "y", ])
  share_yes_maps <- paste0(round((yes_maps / no_articles)*100, 1), "%")
  maybe_maps <- nrow(df[df$maps == "m", ])
  share_maybe_maps <- paste0(round((maybe_maps / no_articles)*100, 1), "%")

  sum_df <- data.frame(feed = feed,
                       no_articles = no_articles,
                       yes_maps = yes_maps,
                       share_yes_maps = share_yes_maps,
                       maybe_maps = maybe_maps,
                       share_maybe_maps = share_maybe_maps)


  summary_df <<- rbind(summary_df, sum_df)
})

write.csv(compiled_df, "data/processed/study1/study1_filteredfeeds/compiled_filtered_feeds.csv")
write.csv(summary_df, "data/processed/study1/study1_filtered_feeds/sum_stats.csv")


