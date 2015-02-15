library(dplyr)
library(lubridate)
library(ggplot2)

set.seed(1)

WINDOW <- 60*24*30
RESOLUTION <- 60*24

get_data <- function(badge) {
    db <- src_sqlite('my_db.sqlite', create=FALSE)
    badges <- tbl(db, 'badges_of_interest')
    actions <- tbl(db, 'actions')

    y <- badges %>%
        filter(Name == badge) %>%
        select(UserId, Date) %>%
        collect()
    t <- ymd_hms(y$Date)
    keep <- (t - min(t) >= WINDOW * 60) & (max(t) - t >= WINDOW * 60)
    y <- y[keep, ]
    print(paste(badge, ':', nrow(y)))

    df <- inner_join(actions, y, by='UserId', copy=TRUE) %>% collect()

    seconds <- ymd_hms(df$CreationDate) - ymd_hms(df$Date)
    df$minute <- as.numeric(seconds) / 60

    df$minute <- ceiling(df$minute / RESOLUTION) * RESOLUTION

    f <- function(block) {
        counts <- block %>% group_by(minute) %>% summarise(count=n())
        expanded <- full_join(data.frame(minute=seq(-WINDOW, WINDOW, RESOLUTION)), counts, by='minute')
        expanded$count[is.na(expanded$count)] <- 0
        return(expanded)
    }
    counts <- df %>%
        filter(-WINDOW <= minute & minute <= WINDOW) %>%
        group_by(UserId, PostTypeId) %>%
        do(f(.))

    counts$PostTypeId <- factor(counts$PostTypeId, levels=1:3, labels=c('Question', 'Answer', 'Edit'))
    counts$badge <- badge
    return(counts)
}

get_data2 <- function(badges) {
    l <- lapply(badges, get_data)
    return(do.call(bind_rows, l))
}

get_coefficients <- function(counts) {
    data_path <- 'temp.csv'
    est_path <- 'beta.csv'

    shift <- min(counts$minute)
    counts$minute <- counts$minute - shift
    write.csv(counts, data_path, row.names=FALSE)
    cmd <- paste('stata-mp -b do figures/my_poisson.do', data_path, est_path)
    system(cmd)

    my.coefficients <- read.csv(est_path, skip=1)
    names(my.coefficients) <- c('minute', 'estimate', 'low', 'high')
    my.coefficients$minute <- as.numeric(gsub('[^-0-9]', '', my.coefficients$minute)) + shift

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
    g <- (
        ggplot(coefficients, aes(x=minute/60/24, y=estimate, group=minute>0)) +
        geom_ribbon(aes(x=minute/60/24, ymin=low, ymax=high), alpha=0.25) +
        geom_line() +
        theme_bw() +
        xlab(paste('Days since receiving badge')) +
        ylab('Number of actions, log(1 + y)') +
        facet_grid(PostTypeId ~ badge) +
        scale_x_continuous(breaks=seq(-30, 30, 15))
        )
    return(g)
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

main <- function() {
    edit_graph()
    question_graph()
}

badges <- list(
    editing=c("Strunk & White", "Archaeologist", "Copy Editor"),
    questions=c("Inquisitive", "Curious")
    )

df <- get_data2(badges$editing)

disaggregated_graph <- function(data) {
    g <- (
        ggplot(data, aes(x=minute/60/24, y=log(1 + count), group=UserId)) +
        geom_line(alpha=0.1) +
        theme_bw() +
        xlab(paste('Days since receiving badge')) +
        ylab('Number of actions, log(1 + y)') +
        facet_grid(PostTypeId ~ badge) +
        scale_x_continuous(breaks=seq(-30, 30, 15))
        )
    return(g)
}
g <- disaggregated_graph(df)
print(g)
