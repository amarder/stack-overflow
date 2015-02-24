library(dplyr)
library(lubridate)
library(ggplot2)

WINDOW <- 30
set.seed(1)

get_data <- function(badge, n=250) {
    db <- src_sqlite('my_db.sqlite', create=FALSE)
    badges <- tbl(db, 'badges_of_interest')
    actions <- tbl(db, 'actions')

    y <- badges %>%
        filter(Name == badge) %>%
        select(UserId, Date) %>%
        collect() %>%
        mutate(s=ymd_hms(substr(Date, 1, 19))) %>%
        filter(s > min(s)) %>%
        mutate(t=as.Date(substr(Date, 1, 10)))
    y$s <- NULL

    print(paste(badge, ':', nrow(y)))

    # Random sample of n users.
    y <- y %>% sample_n(n, replace=FALSE)

    f <- function(block) {
        counts <- block %>%
            group_by(k) %>%
            summarise(count=n())
        expanded <- full_join(data.frame(k=-WINDOW:WINDOW), counts, by='k')
        expanded$count[is.na(expanded$count)] <- 0
        return(expanded)
    }

    counts <- inner_join(actions, y, by='UserId', copy=TRUE) %>%
        collect() %>%
        mutate(s=as.Date(substr(CreationDate, 1, 10))) %>%
        mutate(k=as.integer(s - t)) %>%
        filter(-WINDOW <= k & k <= WINDOW) %>%
        group_by(UserId, PostTypeId) %>%
        do(f(.))

    counts$PostTypeId <- factor(counts$PostTypeId, levels=1:3, labels=c('Question', 'Answer', 'Edit'))
    counts$badge <- badge

    ## Add in weekday
    y$wday <- as.integer(y$t) %% 7
    counts <- left_join(counts, y %>% select(UserId, wday), by='UserId')
    counts$wday <- (counts$wday + counts$k) %% 7

    return(counts)
}

get_data2 <- function(badges) {
    l <- lapply(badges, get_data)
    return(do.call(bind_rows, l))
}

get_coefficients <- function(counts) {
    data_path <- 'temp.csv'
    est_path <- 'beta.csv'

    shift <- min(counts$k)
    counts$k <- counts$k - shift
    write.csv(counts, data_path, row.names=FALSE)
    cmd <- paste('stata-mp -b do figures/my_poisson.do', data_path, est_path)
    system(cmd)

    my.coefficients <- read.csv(est_path, skip=1)
    names(my.coefficients) <- c('k', 'estimate', 'low', 'high')
    my.coefficients$k <- as.numeric(gsub('[^-0-9]', '', my.coefficients$k)) + shift

    cleanup <- paste('rm', data_path, est_path, 'my_poisson.log')
    system(cleanup)

    return(my.coefficients)
}

combined_coefficients <- function(tags) {
    l <- lapply(tags, function(x) {
        df <- get_data(x)
        coefficients <- df %>% group_by(PostTypeId) %>% do(get_coefficients(.))
        coefficients$badge <- x
        return(coefficients)
    })
    return(do.call(bind_rows, l))
}

my_graph <- function(coefficients) {
    ylabels <- 2^(0:4) - 1
    ybreaks <- log(1 + ylabels)
    g <- (
        ggplot(coefficients, aes(x=k, y=estimate, group=k>0)) +
        geom_ribbon(aes(x=k, ymin=low, ymax=high), alpha=0.25) +
        geom_line() +
        theme_bw() +
        xlab('Days since receiving badge') +
        ylab('Number of actions') +
        facet_grid(badge2 ~ PostTypeId) +
        scale_x_continuous(breaks=seq(-30, 30, 15)) +
        scale_y_continuous(breaks=ybreaks, labels=ylabels)
        )
    return(g)
}

main <- function() {
    badges <- c("Strunk & White", "Copy Editor", "Archaeologist", "Curious", "Inquisitive")
    long <- combined_coefficients(badges)
    long$badge2 <- factor(match(long$badge, badges), levels=1:length(badges), labels=badges, ordered=TRUE)
    g <- my_graph(long)
    ggsave('figures/badges.pdf', g, height=8, width=9)
}

main()
