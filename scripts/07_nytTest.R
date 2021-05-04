# comparing Tweets from one day to RSS feed from one day (NYTimes)

library(tidyRSS)
library(dplyr)
library(rtweet)
library(googlesheets4)

ss <- "https://docs.google.com/spreadsheets/d/12qBxLkx1_H5qQgsVDyf0FP3PasunNnpR3pDwd-qY_xM/edit#gid=621326267"
rss_links <- read_sheet(ss, 4) # reading in RSS links from Google Sheets

nyt_rss <- rss_links %>%
  filter(name == "The New York Times") %>% # filtering out NYTimes
  mutate(rss = paste0(base_rss, section, ".xml")) # concatenating to generate unique RSS links

df <- tidyfeed(nyt_rss$rss[1])

for (i in 2:nrow(nyt_rss)) {
  rss <- tidyfeed(nyt_rss$rss[i])
  df <- rbind(df, rss)
}

length(unique(df$item_title)) # number of unique articles?

nyt <- get_timeline("nytimes", n=300) %>% # retrieving Twitter timeline
  slice(1:78)

length(unique(nyt$urls_url)) # number of unique articles?
       