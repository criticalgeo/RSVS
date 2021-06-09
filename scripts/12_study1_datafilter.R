# FILTER OUT MAPS

library(dplyr)
library(googlesheets4)
library(lubridate)

ss <- "https://docs.google.com/spreadsheets/d/1vg1N83tw0_s9dcCf7amnF-1NGahtIv1sO9o-grRWXiA/edit#gid=794235562"

feed_list <- c("bbc_topstories", "bbc_uk", "bbc_world", "nyt_homepage","nyt_upshot", "nyt_us", "nyt_world", "propublica", "wapo_us", "wapo_world")

summary_df <- data.frame(feed = character(), no_articles = numeric(), yes_maps = numeric(), share_yes_maps = character(), maybe_maps = numeric(), share_maybe_maps = character())

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

# write.csv(summary_df, "data/processed/study1/sum_stats_march3to9.csv")


