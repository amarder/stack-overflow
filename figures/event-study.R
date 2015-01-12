library(dplyr)
library(lubridate)
library(ggplot2)
library(plm)
library(reshape2)

WINDOW <- 240
resolution <- 15

db <- src_sqlite('my_db.sqlite', create=FALSE)
badges <- tbl(db, 'Badges')
comments <- tbl(db, 'Comments')

a <- badges %>% filter(Name == 'Commentator') %>% select(UserId, Date)
b <- comments %>% select(CreationDate, UserId)
df <- data.frame(inner_join(a, b, by='UserId'))
seconds <- ymd_hms(df$CreationDate) - ymd_hms(df$Date)
df$minute <- as.numeric(seconds) / 60

# Remove the comment that secured the badge.
least_negative <- function(x) max(ifelse(x < 0, x, NA), na.rm=TRUE)
temp <- df %>% group_by(UserId) %>% mutate(winner = (minute == least_negative(minute)) & minute >= -5)

df <- temp %>% filter(!winner)
df$minute <- floor(df$minute / resolution) * resolution

f <- function(block) {
    counts <- block %>% group_by(minute) %>% summarise(count=n())
    expanded <- full_join(data.frame(minute=seq(-WINDOW, WINDOW, resolution)), counts, by='minute')
    expanded$count[is.na(expanded$count)] <- 0
    return(expanded)
}
counts <- df %>% filter(-WINDOW <= minute & minute <= WINDOW) %>% group_by(UserId) %>% do(f(.))

# user fixed effects
# cluster standard errors
# dummy for each minute
# plot 95% confidence interval
fit <- plm(count ~ factor(minute), data=counts, index='UserId')
my.coefficients <- data.frame(cbind(confint(fit), coefficients(fit)))
names(my.coefficients) <- c('low', 'high', 'estimate')
my.coefficients$minute <- as.numeric(gsub('[^-0-9]', '', row.names(my.coefficients)))
# my.coefficients <- melt(my.coefficients, id.vars='minute')
my.coefficients$after <- my.coefficients$minute >= 0

g <- (
    ggplot(my.coefficients, aes(x=minute, y=estimate, group=after)) +
    geom_ribbon(aes(x=minute, ymin=low, ymax=high, group=after), alpha=0.25) +
    geom_line() +
    geom_point() +
    theme_bw() +
    xlab('Minutes since receiving commentator badge') +
    ylab(paste('Number of comments posted per', resolution, 'minutes')) +
    ggtitle('Coefficient estimates with 95% confidence interval')
    )
print(g)
