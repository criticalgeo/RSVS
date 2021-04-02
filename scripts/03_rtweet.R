## Exploring rtweet package for RSVS studies ##

library(rtweet) # interface with Twitter API
library(dplyr) # for data wrangling

# AUTHENTICATION #
api_key <- "a7CB7bUNNFrivMuDx96BJU18T"
api_secret <- "tnmAaz1Px4vF7iuxG6EnCn8afg3oa5uFJlfd9gdU3yQyHgmV57"

token <- create_token(
  app = "rsvs2",
  consumer_key = api_key,
  consumer_secret = api_secret
)

# package authors encourage use of Twitter User IDs (as opposed to user names) for long-term reliability
# use https://tweeterid.com/ to retrieve user ID

# Testing first with @PostGraphics (user ID: 87968068)

pgTL <- get_timeline(user = "87968068", n=100000) # retrieving timeline
# get_timeline returns maximum of 3200 tweets according to R documentation -- check Twitter API for limits


###########

# Rehydrating Chen et al. (2020) dataset 

# reading in data set of tweet IDs
tweetIDs <- read.delim("data/raw/lee_supplementary/tweetIDs.txt", 
                       col.names="tweetID", 
                       colClasses = "character") 

# slicing first 90,000 rows for testing (non-academic API limit)
tweet_slice <- tweetIDs %>%
  slice(1:90000)

# creating atomic vector of tweetIDs
tweet_atomic <- unlist(tweet_slice[1])

#retrieving tweets
tweets <- lookup_tweets(tweet_atomic)

set.seed(1)
# sampling random set to explore nature of maps in dataset
tweet_random <- tweetIDs %>%
  slice_sample(n=50000)

tweet_random <- unlist(tweet_random) # atomatizing 

tweets_random_hyd <- lookup_tweets(tweet_random)

# filtering out rows without images
tweets_random_pics <- tweets_random_hyd %>%
  filter(!is.na(media_url))

for (i in 1:nrow(tweets_random_pics)) {
  download.file(as.character(tweets_random_pics$media_url[i]), paste0("images/0330_sample/", i,".jpg"))
}

as.character(tweets_random_pics$media_url[1])

?download.file
