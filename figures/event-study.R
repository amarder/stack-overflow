library(dplyr)
library(lubridate)
library(ggplot2)
library(plm)
library(reshape2)

get_data <- function(badge, window, resolution) {
    db <- src_sqlite('my_db.sqlite', create=FALSE)
    badges <- tbl(db, 'badges_of_interest')
    actions <- tbl(db, 'actions')

    y <- badges %>%
        filter(Name == badge) %>%
        select(UserId, Date) %>%
        collect()
    t <- ymd_hms(y$Date)
    keep <- (t - min(t) >= window * 60) & (max(t) - t >= window * 60)
    y <- y[keep, ]

    df <- inner_join(actions, y, by='UserId', copy=TRUE) %>% collect()

    seconds <- ymd_hms(df$CreationDate) - ymd_hms(df$Date)
    df$minute <- as.numeric(seconds) / 60

    df$minute <- floor(df$minute / resolution) * resolution

    f <- function(block) {
        counts <- block %>% group_by(minute) %>% summarise(count=n())
        expanded <- full_join(data.frame(minute=seq(-window, window, resolution)), counts, by='minute')
        expanded$count[is.na(expanded$count)] <- 0
        return(expanded)
    }
    counts <- df %>%
        filter(-window <= minute & minute <= window) %>%
        group_by(UserId, PostTypeId) %>%
        do(f(.))

    return(counts)
}

get_coefficients <- function(counts) {
    ## user fixed effects
    ## cluster standard errors
    ## dummy for each minute
    ## plot 95% confidence interval
    fit <- plm(count ~ factor(minute), data=counts, index='UserId')
    my.coefficients <- data.frame(cbind(confint(fit), coefficients(fit)))
    names(my.coefficients) <- c('low', 'high', 'estimate')
    my.coefficients$minute <- as.numeric(gsub('[^-0-9]', '', row.names(my.coefficients)))
    my.coefficients$after <- my.coefficients$minute >= 0
    return(my.coefficients)
}

my_graph <- function(coefficients) {
    g <- (
        ggplot(coefficients, aes(x=minute/60/24, y=estimate)) +
        geom_hline(yintercept=0, alpha=0.25) +
        geom_vline(xintercept=0, alpha=0.25) +
        geom_ribbon(aes(x=minute/60/24, ymin=low, ymax=high), alpha=0.25) +
        geom_line() +
        geom_point() +
        theme_classic() +
        xlab('Days since receiving badge') +
        ylab('Number of actions') +
        ggtitle('Coefficient estimates with 95% confidence intervals') +
        facet_grid(PostTypeId ~ ., scales='free_y')
        )
    return(g)
}

for (k in c("Copy Editor", "Generalist")) {
    df <- get_data(k, 60*24*60, 60*24)
    df$PostTypeId <- factor(df$PostTypeId, levels=1:3, labels=c('Question', 'Answer', 'Edit'))
    coefficients <- df %>% group_by(PostTypeId) %>% do(get_coefficients(.))
    g <- my_graph(coefficients)
    ggsave(paste0('figures/', k, '.pdf'), g)
}
