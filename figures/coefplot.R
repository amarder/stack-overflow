library(dplyr)
library(tidyr)
library(coefplot)

nusers=10000
db <- src_sqlite('my_db.sqlite', create=FALSE)

## Set up users
users <- tbl(db, 'Users') %>% filter(Reputation > 1) %>% collect() %>% sample_n(nusers)

users$log_views <- log(users$Views + runif(nrow(users)))
users$log_reputation <- log(users$Reputation + runif(nrow(users), min=0, max=15))
users$years <- as.integer(as.Date("2014-09-14") - as.Date(users$CreationDate)) / 365

## Set up badges
info <- read.csv('munge/badges.csv')
badges <- tbl(db, 'Badges')
keep <- data.frame(Name=info$name)
badges_of_interest <- inner_join(badges %>% select(UserId, Name), keep, by='Name', copy=TRUE)
long <- inner_join(badges_of_interest, users %>% select(UserId=Id), by='UserId', copy=TRUE) %>% collect()
long <- unique(long)
long$Name <- paste('B:', long$Name)

long$flag <- TRUE
wide <- long %>% spread(Name, flag, fill=FALSE)

merged <- left_join(users, wide, by=c('Id'='UserId'))
merged[is.na(merged)] <- FALSE
names(merged) <- gsub('[^a-zA-Z_]+', '_', names(merged))

badge_names <- grep('^B_', names(merged), value=TRUE)
my_formula <- paste(c('log_views ~ log_reputation + years', badge_names), collapse=' + ')
print(my_formula)
fit <- lm(my_formula, data=merged)

raw <- names(coefficients(fit))
clean <- gsub('_', ' ', gsub('TRUE$', '', gsub('^B_', '', raw)))
names(clean) <- raw

g <- coefplot(fit, sort='magnitude', newNames=clean) + theme_classic() + ylab('') + xlab('Coefficient Estimate') + ggtitle('')
ggsave('figures/coefplot.pdf', g, height=16, width=7)
