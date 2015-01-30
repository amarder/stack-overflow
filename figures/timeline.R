library(ggplot2)
library(grid)
library(dplyr)
library(lubridate)

db <- src_sqlite('my_db.sqlite', create=FALSE)
badges <- tbl(db, 'Badges')
info <- read.csv('munge/badges.csv')
keep <- data.frame(Name=info$name)
badges_of_interest <- inner_join(badges, keep, by='Name', copy=TRUE)
intro <- badges_of_interest %>% group_by(Name) %>% summarise(t=min(Date)) %>% collect()

intro$time <- ymd_hms(intro$t)
intro$time <- year(intro$time) + month(intro$time)/12
intro <- intro[order(intro$time), ]

timeline <- function(data) {
    g <- (
        ggplot(data) +
        geom_point(aes(x=0, y=time)) +
        geom_text(aes(x=0.05, y=time, label=badges), hjust=0, size=4) +
        theme_classic() +
        theme(axis.line.x=element_blank(), axis.title=element_blank(), axis.ticks.x=element_blank(), axis.text.x=element_blank()) +
        xlim(0, 3) + ylim(2015, 2008)
        )
    return(g)
}

f <- function(x) {
    paste(x, collapse=', ')
}
df <- intro %>% group_by(time) %>% summarise(badges=f(Name))
df$y <- 0

g <- timeline(as.data.frame(df))
ggsave('figures/timeline.pdf', g, height=15, width=25)
