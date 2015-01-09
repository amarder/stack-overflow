import pandas as pd
import sqlalchemy
import numpy as np

engine = sqlalchemy.create_engine('sqlite:///my_db.sqlite')
users = pd.read_sql('Users', engine)
print 'There are %d users on Stack Overflow.\n' % users.shape[0]

badges = pd.read_sql('Badges', engine)
print 'Here are the top ten badges awarded on Stack Overflow and the proportion of users holding each badge:'
print (badges.Name.value_counts().head(10) / users.shape[0]).round(2)

# Let's look at all the commentators.
commentators = badges[badges.Name == 'Commentator']
keep = ['Date', 'UserId']
commentators = commentators[keep]
commentators.reset_index(drop=True, inplace=True)
commentators.rename(columns={'Date': 'AwardDate'}, inplace=True)

comments = pd.read_sql('Comments', engine)
merged = comments.merge(commentators, on='UserId', how='inner')
merged['days'] = (merged.CreationDate - merged.AwardDate) / np.timedelta64(1, 'D')
merged.to_csv('comments.csv')
