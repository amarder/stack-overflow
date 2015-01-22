library(dplyr)
library(tidyr)
library(ggplot2)

fwl <- function(y, X, data) {
    residuals <- lapply(1:length(X), function(i) {
        l <- lapply(c(y, X[i]), function(yy) {
            f <- paste(yy, '~', paste(X[-i], collapse=' + '))
            fit <- lm(f, data)
            data.frame(id=1:nrow(data), resid=resid(fit), y=ifelse(yy == y, 'y', 'x'), excluded=X[i])
        })
        do.call(bind_rows, l)
    })
    do.call(bind_rows, residuals)
}

fwl_graph <- function(y, X, data) {
    long <- fwl(y, X, data)
    wide <- spread(long, y, resid)
    g <- (
        ggplot(wide, aes(x=x, y=y)) +
        facet_grid(excluded ~ .) +
        geom_point(alpha=0.1) +
        stat_smooth()
        )
    return(g)
}


inactive <- tbl(db, 'Users') %>% filter(Reputation == 1) %>% collect() %>% sample_n(1000)
merged <- inner_join(tbl(db, 'Badges'), inactive, by=c('UserId'='Id'), copy=TRUE)
