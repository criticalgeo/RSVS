# STUDY 1 DATA COLLECTION SCRIPT: PART 3 #
# takes a given data collection date and incrementally opens article links collected for that date from a folder of CSVs

library(dplyr)

# input date for which you would like to browse data (format: YYYY-MM-DD)
input_date <- "2021-05-03"

# create list of file names in target folder
file_list <- list.files(paste0("data/raw/study1/raw_feeds/", input_date), pattern = "*.csv") 

# looping over file list and reading tables into global environment
for (i in 1:length(file_list)) {
  name <- substr(file_list[i], 1, nchar(file_list[i]) - 4)
  assign(
    name,
    read.csv(paste0("data/raw/study1/raw_feeds/", input_date, "/", file_list[i])),
    envir = .GlobalEnv
  )
}

# creating list of objects to loop over
object_names <- lapply(file_list, function(name) {
  substr(name, 1, nchar(name) - 4)
})

# this code loops over each feed, and opens article links in those feeds in a set increment
for (feed in object_names) {
  print(paste0("Starting: ", feed))
  df <- get(feed) # storing table in empty data frame
  increment <- 20 # number of tabs to open
  start <- 1 # start index
  if (nrow(df) < increment) {
    end <- nrow(df)
  } else {
    end <- increment
  }
  
  while (start < nrow(df)) {
    sliced <- df %>%
      slice(start:end)
    
    lapply(sliced$item_link, browseURL)
    
    if (end < nrow(df)) {
      readline(prompt = paste0("Press [enter] to open next ", increment, " links in ", feed))
    }
    
    start <- start + increment
    end <- end + increment
    if (end > nrow(df)) {
      end <- nrow(df)
      print("Last round!")
    }
    }
}

