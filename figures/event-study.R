library(dplyr)
library(lubridate)
library(ggplot2)
library(plm)
library(reshape2)

set.seed(1)

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
    print(paste(badge, ':', nrow(y)))
    ## if (nrow(y) > 1000) {
    ##     print('Selecting 1000 users at random.')
    ##     y <- y %>% sample_n(1000) %>% collect()
    ## }

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
    fit <- plm(log(1 + count) ~ factor(minute), data=counts, index='UserId')
    vcov <- vcovHC(fit, type="HC0", cluster="group")
    se <- sqrt(diag(vcov))
    z <- qnorm(c(0.025, 0.975))
    ci <- coefficients(fit) + se %o% z
    my.coefficients <- data.frame(ci, coefficients(fit))
    names(my.coefficients) <- c('low', 'high', 'estimate')
    my.coefficients$minute <- as.numeric(gsub('[^-0-9]', '', row.names(my.coefficients)))
    return(my.coefficients)
}

my_graph <- function(coefficients) {
    g <- (
        ggplot(coefficients, aes(x=minute/60/24 - 0.5, y=estimate, group=minute>0)) +
        geom_ribbon(aes(x=minute/60/24 - 0.5, ymin=low, ymax=high), alpha=0.25) +
        geom_line() +
        theme_bw() +
        xlab(paste('Days since receiving badge')) +
        ylab('log(1 + number of actions)') +
        facet_grid(PostTypeId ~ badge) +
        scale_x_continuous(breaks=seq(-30, 30, 15))
        )
    return(g)
}

combined_coefficients <- function(tags) {
    l <- lapply(tags, function(x) {
        df <- get_data(x, window=60*24*30, resolution=60*24)
        coefficients <- df %>% group_by(PostTypeId) %>% do(get_coefficients(.))
        coefficients$badge <- x
        return(coefficients)
    })
    return(do.call(bind_rows, l))
}

edit_graph <- function() {
    long <- combined_coefficients(c("Strunk & White", "Archaeologist", "Copy Editor"))
    g <- my_graph(long)
    ggsave('figures/editing.pdf', g, height=5, width=9)
}

question_graph <- function() {
    long <- combined_coefficients(c("Inquisitive", "Curious"))
    g <- my_graph(long)
    ggsave('figures/questions.pdf', g, height=5, width=9)
}

edit_graph()
question_graph()
