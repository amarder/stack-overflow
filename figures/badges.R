library(dplyr)
library(ggplot2)
library(lubridate)

db <- src_sqlite('my_db.sqlite', create=FALSE)
badges <- tbl(db, 'Badges') %>% select(Name, Date)

info <- read.csv('munge/badges.csv')
keep <- data.frame(Name=info$name)
badges_of_interest <- inner_join(badges, keep, by='Name', copy=TRUE) %>% collect()
badges_of_interest$t <- ymd_hms(badges_of_interest$Date)

g <- (
    ggplot(badges_of_interest, aes(x=t, y=..density..)) +
    geom_histogram(binwidth=30*24*60*60) +
    facet_grid(Name ~ .)
    )
ggsave('temp.pdf', g, height=80, limitsize = FALSE)
