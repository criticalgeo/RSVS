############### CGSAL RS/VS ###################
### EXPLORING RSS SCRAPING & SCREENSHOTTING ###

library(tidyRSS)
library(dplyr)
library(googlesheets4)
library(webshot)

# testing ProPublica
pp <- tidyfeed("http://feeds.propublica.org/propublica/main")

lapply(pp$item_guid, function(x) {
  webshot(x, file=paste0("screenshots/", x, ".png"))
})


webshot(pp$item_guid[1], delay = 0.6)


#SCMP
scmp <- tidyfeed("https://www.scmp.com/rss/91/feed") %>%
  slice(1:10)

lapply(scmp$item_link, function(x) {
  webshot(x, file=paste0("screenshots/", x, ".png"))
})

webshot("https://www.scmp.com/news/world/united-states-canada/article/3122009/will-donald-trump-face-criminal-charges", selector=".generic-article__body", delay = 3)

webshot("https://www.nytimes.com/live/2021/02/17/us/winter-storm-weather-live")
webshot("https://www.washingtonpost.com/graphics/2019/investigations/opioid-pills-overdose-analysis/")

webshot("https://www.nytimes.com/interactive/2021/02/16/us/winter-storm-texas-power-outage-map.html")
webshot("https://www.nytimes.com/interactive/2020/09/02/upshot/america-political-spectrum.html", file ="nytimes2.png")  
webshot("https://www.nytimes.com/interactive/2021/upshot/2020-election-map.html", file="nytimes3.jpg", delay = 10)
webshot("https://www.nytimes.com/interactive/2020/us/coronavirus-us-cases.html", file="nytimes4.png", delay = 3)
