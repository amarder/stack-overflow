library(dplyr)
library(ggplot2)

cutoffs <- c(5, 10, 15, 20, 50, 75)

my_db <- src_sqlite("my_db.sqlite")
users <- tbl(my_db, "Users") %>% select(Reputation)
df <- head(users, n=nrow(users))
g <- (
    ggplot(df, aes(x=Reputation, y=..density..)) +
    geom_histogram(binwidth=5, origin=0.5, color='black', fill='white') +
    # geom_density() +
    xlim(2, 100) +
    geom_vline(xintercept=cutoffs, color='red') +
    theme_bw()
    )
print(g)
