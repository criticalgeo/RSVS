# Script to open article links from Study 2 Sample CSVs and save media URLs

# INSTRUCTIONS:
# When you first open this file, run lines 6-49 (highlight and press Command + Enter). Then, run line 55 with the desired source table until the end of the table (a message will appear in the console). 

library(dplyr) # data wrangling


# DEFINING FUNCTIONS

# function to load files from specified directory
load_files <- function(folder) {
  file_list <<- list.files(paste0("data/processed/", folder), pattern = "*.csv")
  
  for (i in 1:length(file_list)) {
    name <- substr(file_list[i], 1, nchar(file_list[i]) - 4)
    assign(
      name, 
      read.csv(paste0(paste0("data/processed/", folder, "/"), file_list[i])),
      envir = .GlobalEnv
    )
  }
}

# function to open URLs in increments
open <- function(file, start, end) {
  # removing rows with no URLs
  file <- file %>%
    filter(!is.na(urls_t.co))
  
  # checking to see if we're at the end of the line
  if (start > nrow(file)) {
    stop("There are no more rows left!")
  }
  
  if (end > nrow(file)) {
    end <<- nrow(file)
    print("Last round!")
  }
  
  # slice main input data frame from start to end index (e.g. 1st to 30th row)
  slice <- file %>% 
    slice(start:end)
  
  # loop over URLs in sliced data frame 
  lapply(slice$urls_t.co, browseURL)
  
  # increment start and end indexes
  start <<- start + increment
  end <<- end + increment
}


### RUN CODE
load_files("study2_sample_malofiej_0414") # load files from directory


# set increments for opening browsers
increment <- 50 # how many URLs would you like to open at a time?
start <- 1 # start index
end <- start + (increment - 1) # end index

# run function 
# NOTE: replace first parameter with name of source (e.g. globeandmail, or CivilBeat, etc.) — use names in the Environment window (top right corner) as a guide. Variable names are case sensitive!
# After you finish a source, run lines 19-21 to reset your start and end indices!
open(Reuters, start, end)



