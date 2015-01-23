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

    df$minute <- ceiling(df$minute / resolution) * resolution

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

    counts$PostTypeId <- factor(counts$PostTypeId, levels=1:3, labels=c('Question', 'Answer', 'Edit'))
    return(counts)
}

get_coefficients <- function(counts) {
    ## user fixed effects
    ## cluster standard errors
    ## dummy for each minute
    ## plot 95% confidence interval
    fit <- lm(count ~ factor(minute), data=counts)
    my.coefficients <- data.frame(cbind(confint(fit), coefficients(fit))) + coefficients(fit)[[1]]
    names(my.coefficients) <- c('low', 'high', 'estimate')
    my.coefficients$minute <- as.numeric(gsub('[^-0-9]', '', row.names(my.coefficients)))
    my.coefficients$after <- my.coefficients$minute >= 0
    return(my.coefficients)
}

my_graph <- function(coefficients, badge) {
    g <- (
        ggplot(coefficients, aes(x=minute/60/24, y=estimate)) +
        geom_hline(yintercept=0, alpha=0.25) +
        geom_vline(xintercept=0, alpha=0.25) +
        geom_ribbon(aes(x=minute/60/24, ymin=low, ymax=high), alpha=0.25) +
        geom_line() +
        geom_point() +
        theme_classic() +
        xlab(paste('Days since receiving', badge, 'badge')) +
        ylab('Number of actions') +
        ggtitle('Mean number of actions performed over time') +
        facet_grid(PostTypeId ~ ., scales='free_y')
        )
    return(g)
}

main <- function() {
    graphs <- data.frame(
        badge=c("Copy Editor", "Generalist", "Socratic"),
        window=c(60*24*60, 60*24*60, 60*24*5),
        resolution=c(60*24, 60*24, 60*2)
        )

    for (i in 1:nrow(graphs)) {
        row <- graphs[i, ]
        k <- row$badge
        df <- get_data(k, row$window, row$resolution)
        coefficients <- df %>% group_by(PostTypeId) %>% do(get_coefficients(.))
        g <- my_graph(coefficients, k)
        ggsave(paste0('figures/', k, '.pdf'), g)
    }
}

main()
