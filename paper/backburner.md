2. Sorting around discontinuity: [@lee_crime_2005, @mccrary_manipulation_2008, @urquiola_class-size_2009]

3. How many views does a user earn for reputation points, days on the platform, badges?

[^RDD]: @lee_regression_2010 provide an excellent guide for applying
regression discontinuity designs in empirical research.

# Profile views

![Kernel density estimates](figures/density-estimates.pdf)

![Views versus reputation](figures/views-vs-reputation.pdf)

![](figures/coefplot.pdf)\

Add a coefficient plot of badges. Where does it makes sense to put effort?

# Reputation versus badges

For a number of badges users have complete control over the assignment variable. For privileges based on points, users do not have perfect control. Can I get a historical record of reputation points?

It looks like I'll have to use the API to get some record of reputation. Maybe I'll have to use this for a subsample of users with specific privileges. That could make things a bit faster.

Privileges are based on your current reputation. Unfortunately Stack Exchange does not want to share exact reputation data

Looking at the three endpoints for getting reputation data [here](http://api.stackexchange.com/docs/), we can get some seriously flawed public data that won't work well for determining priviliges or we'll have to authenticate users to get their full history. That doesn't seem feasible.

http://stackapps.com/questions/4670/users-id-and-users-id-reputation-disagree-over-2-accept-answer-bonuses/
http://stackapps.com/questions/3320/reputation-api-to-display-a-reputation-history/
http://stackapps.com/questions/2957/is-it-possible-to-get-daily-reputation-change-for-a-user-via-the-api/

http://api.stackexchange.com/docs/types/reputation-history

what reputation events are private?

I appreciate the API has three methods for retrieving a user's reputation history:

1. [/users/{id}/reputation-history/full](http://api.stackexchange.com/docs/full-reputation-history) requires the user to authorize access and returns a complete history of reputation changes.

2. [/users/{ids}/reputation-history](http://api.stackexchange.com/docs/reputation-history) returns all public changes in a user's reputation.

3. [/users/{ids}/reputation](http://api.stackexchange.com/docs/reputation-on-users) does some scrubbing of the reputation change events to keep private events private, but gives a "reasonable display of reputation trends."

The third option will be best for a fuzzy RD design.

Which reputation events are private?

I want to recreate a user's reputation history using the API. I understand that the public version of this data has been scrubbed to hide private reputation events, but I haven't been able to find a definitive list of private reputation events. Is there a list 

http://stackoverflow.com/help/whats-reputation

I can compute a rough reputation number, measurement error as motivation for fuzzy RD design. I will use this API endpoint [/users/{ids}/reputation](http://api.stackexchange.com/docs/reputation-on-users).
