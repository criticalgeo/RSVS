## STUDY 1 DATA COLLECTION SCRIPT: PART 3 —— GOOGLE SHEETS EDITION ##
# takes a given Google Sheet tab and incrementally opens article links in browser

library(dplyr)
library(googlesheets4)

# input Google Sheet
ss <- "https://docs.google.com/spreadsheets/d/1vg1N83tw0_s9dcCf7amnF-1NGahtIv1sO9o-grRWXiA/edit#gid=0"

# defining function that opens article links from given sheet tab
browse <- function(tab_name, start = 1, increment = 20) {
  df <- read_sheet(ss, sheet = tab_name) # reading in sheet
  
  start <- start # setting initial start index
  end <- start + increment - 1 # setting initial end index
  
  # loop that incrementally opens article links and stops when the start index is greater than number of rows (i.e. rows have run out)
  while (start < nrow(df)) { 
    # slicing data from from start to end index
    sliced <- df %>% 
      slice(start:end)
    
    lapply(sliced$item_link, browseURL) # opening article links

    start <- start + increment # increments start index
    
    # increments end index, accounting for end of data frame (i.e. if incrementing the end index surpasses the number of rows, then set end index to the number of rows in data frame )
    if (end + increment > nrow(df)) { 
      end <- nrow(df)
    } else {
      end <- end + increment
    }
    
    # this chunk of code spits out prompts to continue the loop; makes it easier to keep track of rows.
    if (start < nrow(df)) {
      if (end < nrow(df)) {
        readline(prompt = paste0("Press [enter] to open articles ", start, "-", end, "."))
      } else if (end == nrow(df)){ 
        readline(prompt = paste0("Press [enter] to open articles ", start, "-", nrow(df), ". —— LAST ROUND"))
      }
    } else {
      print("No more rows!")
    }
  }
}

# run function! 
# default increment (i.e. number of tabs to open) is set to 20 but you can change it by adding the increment parameter (e.g. browse("bbc_topstories", increment = 30))
# default start index is 1, but change if needed (i.e. if you left off mid-sheet) (e.g. browse("bbc_topstories", start = 30))

browse("bbc_uk")



  

