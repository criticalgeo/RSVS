## STUDY 1 DATA COLLECTION SCRIPT: PART 2 ##
# transfer locally-stored CSVs created in Part 1 to aggregated Google Sheets document

# This script can be run all at once (Cmd + Shift + S). If this is the first transferring of data to Google Sheets, uncomment line 33 to do an initial writing of data to Google Sheets. Otherwise, LEAVE THIS LINE COMMENTED OUT. Read comments throughout script — hopefully thought process will be clear. 

library(dplyr) # for tidying data
library(googlesheets4) # for interfacing with Google Sheets

ss <- "https://docs.google.com/spreadsheets/d/1vg1N83tw0_s9dcCf7amnF-1NGahtIv1sO9o-grRWXiA/edit#gid=0" # link to Google Sheet
file_path <- "data/raw/study1/raw_feeds/" # file path containing raw feds

start_date <- "2021-05-03" # data collection start date ——— CHANGE THIS FOR REAL DATA COLLECTION DATE
# start date is in format "YYYY-MM-DD" (unless your system prints dates differently — check your folder names to confirm)

# Defining a function to write the first day of data into Google Sheet — this is done to create a "base" table with all the correct columns on which to append future days of data. Function only needs to be run once.
initial_write <- function(start_date) {
  file_list <- list.files(paste0(file_path, start_date), pattern = "*.csv") # create character vector of file names in local directory
  
  # loop that goes over files in local directory and writes a new google sheet for each table
  lapply(file_list, function(file) { 
    
    temp_df <- read.csv(paste0(file_path, start_date, "/", file)) %>% # read in CSV into R environment
      mutate(collection_date = start_date) %>% # add data collection date column
      select(-c("item_description", "X")) # delete item_description column (sometimes too many characters for Google Sheets) and "X", which is just row indices — also unnecessary
    
    temp_df <- temp_df[c(ncol(temp_df), 1:(ncol(temp_df)-1))] # reordering columns to place year column first
    tab_name <- substr(file, 1, nchar(file) - 4) # cutting ".csv" from file name to serve as tab name
    write_sheet(temp_df, ss, tab_name) # writing sheet to Google Sheets file
  })
}

# RUN THIS NEXT LINE OF CODE ONLY ONE TIME WHEN FIRST TRANSFERRING DATA TO GOOGLE SHEETS— if run again, tables on Google Sheets will be overwritten (I commented it out for safety)
# initial_write(start_date) 

#######################################################
# This next chunk of code (lines 41-56):
# a) checks the Google Sheet for dates already uploaded
# b) checks local folder for dates not uploaded
# c) appends data for dates that have not been updated

df <- read_sheet(ss, sheet = 1) # reading in Google Sheet
uploaded_dates <- unique(df$collection_date) # creating character vector of all dates that have been uploaded
all_dates <- list.files(file_path) # creating character vector of all dates collected
todo_dates <- all_dates[!(all_dates %in% uploaded_dates)] # creating a character vector of dates to be uploaded
lapply(todo_dates, function(date) {
  file_list <- list.files(paste0(file_path, date), pattern = "*.csv") # creating character vector containing list of files in folder with particular date
  lapply(file_list, function(file) {
    temp_df <- read.csv(paste0(file_path, date, "/", file)) %>%
      mutate(collection_date = date) %>%
      select(-c("item_description", "X"))
    
    temp_df <- temp_df[c(ncol(temp_df), 1:(ncol(temp_df)-1))] # reordering columns to place year column first
    tab_name <- substr(file, 1, nchar(file) - 4) # cutting ".csv" from file name to serve as tab name
    sheet_append(ss, temp_df, tab_name)
  })
})




