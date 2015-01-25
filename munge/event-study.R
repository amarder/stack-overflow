library(dplyr)

db <- src_sqlite('my_db.sqlite', create=FALSE)

## construct query for table of edits
posts <- tbl(db, 'Posts')

edits <- tbl(db, 'PostHistory') %>%
    select(CreationDate, PostHistoryTypeId, PostId, UserId) %>%
    filter(PostHistoryTypeId %in% 4:6) %>%
    left_join(posts %>% select(Id, OwnerUserId), by=c('PostId'='Id')) %>%
    filter(UserId != OwnerUserId) %>%
    group_by(UserId, PostId) %>%
    summarise(CreationDate=min(CreationDate))

## combine questions, answers, and edits into a table of actions
actions <- posts %>%
    select(UserId=OwnerUserId, CreationDate, PostTypeId) %>%
    filter(PostTypeId %in% 1:2) %>%
    union(edits %>% select(UserId, CreationDate) %>% mutate(PostTypeId=3))

actions %>% compute(name='actions', temporary=FALSE)


## set up table of badges
x <- tbl(db, 'Badges')
y <- as.tbl(read.csv('munge/badges.csv')) %>% select(name)

badges_of_interest <- inner_join(x, y, by='Name', copy=TRUE) %>%
    select(Date, Name, UserId)

badges_of_interest %>% compute(name='badges_of_interest', temporary=FALSE)
