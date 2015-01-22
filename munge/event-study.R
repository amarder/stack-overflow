library(dplyr)

## 1. get list of badges of interest
db <- src_sqlite('my_db.sqlite', create=FALSE)

badges <- tbl(db, 'Badges') %>%
    select(Date, Name, UserId) %>%
    filter(Name == "Socratic" | Name == "Generalist" | Name == "Copy Editor") %>%
    collect()

copy_to(db, badges, 'badges_of_interest', temporary=FALSE)

## 2. get list of posts
users <- as.tbl(data.frame(UserId=unique(badges$UserId)))

posts <- tbl(db, 'Posts') %>%
    select(CreationDate, OwnerUserId, PostTypeId)

posts_of_interest <- inner_join(posts, users, by=c('OwnerUserId'='UserId'), copy=TRUE) %>%
    collect()

copy_to(db, posts_of_interest, 'posts_of_interest', temporary=FALSE)

## 3. get list of edits
edits <- tbl(db, 'PostHistory') %>%
    select(CreationDate, PostHistoryTypeId, RevisionGUID, UserId) %>%
    filter(PostHistoryTypeId == 4 | PostHistoryTypeId == 5 | PostHistoryTypeId == 6)

edits_of_interest <- inner_join(edits, users, by='UserId', copy=TRUE) %>% collect()

copy_to(db, edits_of_interest, 'edits_of_interest', temporary=FALSE)
