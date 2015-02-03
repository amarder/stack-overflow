'
The Curious, Inquisitive, and Socratic badges were introduced on Stack Overflow on July 2, 2014. The closest badge introduction to these three were on ___ when the Informed badge was introduced. I am comfortable looking at user activity thirty days before and after the introduction of the question promoting badges.

I think the easiest approach here is to get counts by week, splitting it at the day is probably smart. In sqlite using the substr function to group by day will probably be helpful:

substr(CreationDate, 1, 10)
'

library(dplyr)
library(lubridate)
library(plm)
library(ggplot2)

start <- ymd('2008-07-31')

db <- src_sqlite('my_db.sqlite', create=FALSE)
actions <- tbl(db, 'actions') %>%
    filter(PostTypeId != 3) %>%
    mutate(day=substr(CreationDate, 1, 10)) %>%
    group_by(UserId, PostTypeId, day) %>%
    summarise(n=n()) %>%
    collect()
actions$t <- as.integer(ymd(actions$day) - start) / 60 / 60 / 24
actions$week <- floor(actions$t / 7)

weekly <- actions %>%
    group_by(UserId, PostTypeId, week) %>%
    summarise(n=sum(n)) %>%
    collect()

grid <- full_join(
    data.frame(id=1, week=-4:4),
    data.frame(id=1, PostTypeId=1:3),
    by='id'
    )
grid$id <- NULL
f <- function(x) {
    expanded <- left_join(grid, x, c("week", "PostTypeId"))
    expanded$n[is.na(expanded$n)] <- 0
    expanded$UserId <- x$UserId[1]
    return(expanded)
}
expanded <- weekly %>% group_by(UserId) %>% do(f(.))

get_coefficients <- function(data) {
    fit <- plm(log(1 + n) ~ factor(week), data=data, index='UserId')
    vcov <- vcovHC(fit, type="HC0", cluster="group")
    se <- sqrt(diag(vcov))
    z <- qnorm(c(0.025, 0.975))
    ci <- coefficients(fit) + se %o% z
    my.coefficients <- data.frame(ci, coefficients(fit))
    names(my.coefficients) <- c('low', 'high', 'estimate')
    my.coefficients$date <- as.Date(substr(row.names(my.coefficients), 13, 23))
    return(my.coefficients)
}
df <- expanded %>% group_by(PostTypeId) %>% do(get_coefficients(.))

my_graph <- function(data) {
    g <- (
        ggplot(data, aes(x=date, y=estimate, group=PostTypeId)) +
        geom_ribbon(aes(x=date, ymin=low, ymax=high), alpha=0.25) +
        geom_line(aes(color=factor(PostTypeId))) +
        theme_bw() +
        ylab('log(1 + number of actions)')
        )
    return(g)
}

my_graph(df %>% filter(PostTypeId != 3))


counts$t <- ymd(as.character(counts$date))
counts$wday <- wday(counts$t)
counts$week <- week(counts$t)
counts$post <- as.integer(counts$t >= intro)
counts$treatment <- as.integer(counts$PostTypeId == 1)
write.csv(counts, 'counts.csv')

## randomly select 1k or 10k users
## need them to be active

## intro: 2014-07-02

## let's do 30 days before and after
