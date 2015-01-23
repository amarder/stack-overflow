library(ggplot2)
library(grid)
library(dplyr)
library(lubridate)

db <- src_sqlite('../my_db.sqlite', create=FALSE)
badges <- tbl(db, 'Badges')
info <- read.csv('../munge/badges.csv')
keep <- data.frame(Name=info$name)
badges_of_interest <- inner_join(badges, keep, by='Name', copy=TRUE)
intro <- badges_of_interest %>% group_by(Name) %>% summarise(t=min(Date)) %>% collect()

intro$time <- ymd_hms(intro$t)
intro$time <- year(intro$time) + month(intro$time) / 12
intro <- intro[order(intro$time), ]
intro$y <- 1 + nrow(intro) - (1:nrow(intro))

timeline <- function(data) {
    g <- (
        ggplot(data) +
        geom_segment(aes(x=time, y=y, xend=time), yend=0) +
        geom_hline(yintercept=0) +
        geom_text(aes(x=time, y=y, label=Name), hjust=-0.1, vjust=0, parse=FALSE) +
        geom_point(aes(x=time, y=y)) +
        theme_classic() +
        theme(axis.line.y=element_blank(), axis.title=element_blank(), axis.ticks.y=element_blank(), axis.text.y=element_blank())
        )
    return(g)
}

print(
    timeline(as.data.frame(intro)) + xlim(2008, 2015)
    )
