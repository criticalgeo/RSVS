#### TESTING MASS GATHERING OF LINKS FROM RSS FEEDS ####

library(tidyRSS)
library(dplyr)
library(googlesheets4)

# read data sheet from Google
data <- read_sheet("https://docs.google.com/spreadsheets/d/12qBxLkx1_H5qQgsVDyf0FP3PasunNnpR3pDwd-qY_xM/edit#gid=0", sheet = 2)

# create NYTimes RSS links from base RSS URLs
data$rss <- ifelse(is.na(data$rss), paste0(data$base_rss, data$section, ".xml"), data$rss)

# running tidyfeed across dataframe
df_list <- lapply(data$rss, function(x) {
  print(x)
  tidyfeed(x)
})

df <- do.call("rbind", list) # this can't run because data frames in list have different number of columns





