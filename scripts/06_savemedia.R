# Script to save media from Twitter media URLs

library(dplyr)

# function to save media URLs from CSVs in directory
save_media <- function(folder) {
  file_list <<- list.files(paste0("data/processed/", folder), pattern = "*.csv")
  
  for (i in 1:length(file_list)) {
    # read in CSVs and filter out rows 
    df <- read.csv(paste0("data/processed/", folder, "/", file_list[i])) 
    
    # define target folder where images should be saved
    target_folder <- paste0("data/processed/", folder, "/media/", df$screen_name[1])
    
    # check if target folder exists; if not, create new directory
    if (!dir.exists(target_folder)) {
      dir.create(target_folder)
    }
    
    # filter out rows without media
    df <- df %>%
      filter(!is.na(media_url))
    
    # if data frame is not empty, download files into target directory
    if (nrow(df) != 0) {
      for (i in 1:length(df$media_url)) {
        download.file(df$media_url[i], destfile = paste0("data/processed/", folder, "/media/", df$screen_name[1], "/", i, ".jpg"))
      }
      
    }
    
  }
}


save_media("study2_sample_malofiej_0409")
save_media("study2_sample_malofiejgraphics_0409")
save_media("study2_sample_malofiejgraphics_0412")
save_media("study2_sample_malofiejgraphics_0414")
usa <- read.csv("data/processed/study2_sample_malofiejgraphics_0412/usatgraphics.csv") %>%
  filter(!is.na(media_url))


for(i in 1:34) {
  tryCatch(
    expr = {
      download.file(usa$media_url[i], destfile = paste0("data/processed/study2_sample_malofiejgraphics_0412/media/usatgraphics/", i, ".jpg"))
      },
    error = function(e) {simpleError('failed')},
    warning = function(e){ message('warning') },
    finally = function(e) {print('done')}
      )
  
}
