library(dplyr)
library(ggplot2)
library(grid)

db <- src_sqlite('my_db.sqlite', create=FALSE)
## focus on active users.
users <- tbl(db, 'Users') %>% filter(Reputation > 1) %>% collect()

users$log_views <- log(users$Views + runif(nrow(users)))
users$log_reputation <- log(users$Reputation + runif(nrow(users), min=0, max=15))
users$years <- as.integer(as.Date("2014-09-14") - as.Date(users$CreationDate)) / 365

# http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                    ncol = cols, nrow = ceiling(numPlots/cols))
  }

 if (numPlots==1) {
    print(plots[[1]])

  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

## views
g1 <- ggplot(users, aes(x=log_views, y=..density..)) + geom_density(fill='black', alpha=0.125) + theme_classic() + ylab('') + xlab('log(Views)')

## reputation
g2 <- ggplot(users, aes(x=log_reputation, y=..density..)) + geom_density(fill='black', alpha=0.125) + theme_classic() + ylab('') + xlab('log(Reputation)')

## years
g3 <- ggplot(users, aes(x=years, y=..density..)) + geom_density(fill='black', alpha=0.125) + theme_classic() + ylab('') + xlab('Years on Stack Overflow')
pdf('figures/density-estimates.pdf')
multiplot(g1, g2, g3)
dev.off()

## Let's control for years on platform
fit <- lm(log_views ~ years, data=users)
users$log_views_resid <- resid(fit)
fit <- lm(log_reputation ~ years, data=users)
users$log_reputation_resid <- resid(fit)

bin <- function(x, bins=100) {
    a <- min(x)
    b <- max(x)
    result <- a + round(bins * (x - a) / (b - a)) / bins * (b - a)
    return(result)
}
users$bin_views <- bin(users$log_views_resid)
users$bin_rep <- bin(users$log_reputation_resid)
counts <- users %>% group_by(bin_views, bin_rep) %>% summarise(count=n())
g <- (
    ggplot() +
    geom_tile(data=counts, aes(x=bin_rep, y=bin_views, fill=count)) +
    theme_classic() +
    scale_fill_gradient(low = "#ffffff", high = "#222222") +
    stat_smooth(data=users, aes(x=log_reputation_resid, y=log_views_resid), method='lm', se=FALSE) +
    xlab('log(Reputation)') +
    ylab('log(Views)') +
    guides(fill=guide_legend(title='Users'))
    )
ggsave('figures/views-vs-reputation.pdf', g)
