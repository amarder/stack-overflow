library(extrafont)
library(dplyr)
library(lubridate)
library(ggplot2)

WINDOW <- 30
set.seed(1)

db <- src_sqlite('my_db.sqlite', create=FALSE)
badges <- tbl(db, 'badges_of_interest')
actions <- tbl(db, 'actions')

get_data <- function(badge, n=250) {
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
    y <- y %>% sample_n(min(n, nrow(y)), replace=FALSE)

    f <- function(block) {
        counts <- block %>%
            group_by(k) %>%
            summarise(count=n(), t=min(t))
        expanded <- full_join(data.frame(k=-WINDOW:WINDOW), counts, by='k')
        expanded$count[is.na(expanded$count)] <- 0

        low <- min(block$t)
        high <- max(block$t)
        stopifnot(low == high)
        origin <- as.Date('1970-01-01')
        expanded$t <- as.Date(low, origin=origin) + expanded$k

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

get_data2 <- function(tags) {
    l <- lapply(tags, function(x) {
        df <- get_data(x)
        df$badge <- x
        return(df)
    })
    result <- do.call(bind_rows, l)

    # Make sure that all the dates are within the fence posts of all
    # actions.
    dates <- actions %>% summarise(start=min(CreationDate), stop=max(CreationDate)) %>% collect()
    result$out_of_range <- result$t <= dates$start | dates$stop <= result$t
    print(paste('Dropping', sum(result$out_of_range), 'observations out of range.'))
    result <- result %>% filter(!out_of_range)

    return(result)
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

plot_coefficients <- function(coefficients) {
    ylabels <- 2^(0:4) - 1
    ybreaks <- log(1 + ylabels)
    g <- (
        ggplot(coefficients, aes(x=k, y=estimate, group=k>0)) +
        geom_ribbon(aes(x=k, ymin=low, ymax=high, fill='grey'), alpha=0.25) +
        geom_line(aes(color='black')) +
        scale_color_manual(values="#000000", labels="Linear prediction") +
        scale_fill_manual(values=c('#555555', '#555555'), labels="95% Confidence interval") +
        theme_bw() +
        theme(text=element_text(family="Times New Roman")) +
        xlab('Days since receiving badge') +
        ylab('Number of actions') +
        facet_grid(badge ~ PostTypeId) +
        scale_x_continuous(breaks=seq(-30, 30, 15)) +
        scale_y_continuous(breaks=ybreaks, labels=ylabels) +
        theme(legend.direction="horizontal", legend.position="top", legend.box="horizontal") +
        guides(fill=guide_legend(title=NULL), color=guide_legend(title=NULL))
        )
    return(g)
}

plot_counts <- function(counts) {
    ylabels <- 2^(0:4) - 1
    ybreaks <- log(1 + ylabels)
    g <- (
        ggplot(counts, aes(x=k, y=log(1 + count), group=UserId)) +
        geom_line(alpha=0.1) +
        theme_bw() +
        xlab('Days since receiving badge') +
        ylab('Number of actions') +
        facet_grid(badge ~ PostTypeId) +
        scale_x_continuous(breaks=seq(-30, 30, 15)) +
        scale_y_continuous(breaks=ybreaks, labels=ylabels)
        )
    return(g)
}

plot_wrapper <- function(debug=FALSE) {
    # Set up data
    tags <- c("Strunk & White", "Copy Editor", "Archaeologist", "Curious", "Inquisitive", "Socratic")
    data <- get_data2(tags)
    data$badge <- factor(match(data$badge, tags), levels=1:length(tags), labels=tags, ordered=TRUE)

    if (debug) {
        g <- plot_counts(data)
    }
    else {
        coefficients <- data %>% group_by(badge, PostTypeId) %>% do(get_coefficients(.))
        g <- plot_coefficients(coefficients)
    }
    return(g)
}

g <- plot_wrapper()
path <- 'figures/badges.pdf'
ggsave(path, g, height=11, width=9)
embed_fonts(path)
