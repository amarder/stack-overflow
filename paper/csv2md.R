library(pander)

args <- commandArgs(trailingOnly=TRUE)

df <- read.csv(args)
pandoc.table(df, caption='Badges of interest', justify=c('left', 'left', 'center'), split.cells=54, split.tables=Inf)
