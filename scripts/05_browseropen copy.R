# Script to open article links from Study 2 Sample CSVs

dir <- list.files("data/processed/study2_sample_0401")
for (i in 1:length(dir)) {
  assign(
    dir[i], 
    read.csv(paste0("data/processed/study2_sample_0401/", dir[i]))
    )
}

BetterGov <- BetterGov.csv %>%
  filter(!is.na(urls_t.co))

lapply(BetterGov$urls_t.co[1:30], browseURL)
