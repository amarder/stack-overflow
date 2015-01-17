---
title: Stack Overflow - Modeling user engagement
author: Andrew Marder
date: \today
---

# Next Steps

How many views does a user earn for reputation points, days on the platform, badges?

1. Event study approach: [@miller_principal_2013, @jacobson_earnings_1993, @ashenfelter_estimating_1978]

2. Sorting around discontinuity: [@lee_crime_2005, @mccrary_manipulation_2008, @urquiola_class-size_2009]

# Introduction

@deterding_game_2011 define "_gamification_ as the use of game design
elements in non-game contexts."
[Stack Overflow](http://stackoverflow.com/) is a question and answer
website designed for programmers. Stack Overflow is gamified as
follows:

1. A user earns reputation points when another user votes on her posts
   (5 points when a questions is voted up, 10 points when an answer is
   voted up, 15 points when an answer is accepted, and 2 points when
   an edit is approved).

2. As a user earns reputation points she unlocks privileges on the
   site. For instance, a user must have at least 15 reputation points
   to vote up a question or answer. A list of all privileges is
   available [here](http://stackoverflow.com/help/privileges).

3. Users are awarded badges for special achievements. One receives the
   "Informed" badge by reading the entire
   [tour page](http://stackoverflow.com/tour). A list of badges is
   available [here](http://stackoverflow.com/help/badges).

@grant_encouraging_2013 present empirical evidence that three of the
badges awarded for various editing accomplishments are effective in
encouraging users to make more edits in the two months preceding
receipt of the badge compared to the two months after receiving the
badge. This paper aims to build upon the contributions of
@grant_encouraging_2013 by:

1. Using regression discontinuity to measure the causal impact of
   badges on user activity (questions, answers, and edits).[^RDD]

2. Applying the same methodology to measure the causal impact of
   privileges on user activity.

3. Comparing the estimated effects of badges and privileges will help
   us understand which components of Stack Overflow's gamification are
   most effective at promoting user engagement.

[^RDD]: @lee_regression_2010 provide an excellent guide for applying
regression discontinuity designs in empirical research.

# Data

There are almost 3.5 million registered users on Stack Overflow. Less than one percent of those users have been awarded the Strunk & White, Copy Editor, or Archaeologist badges.


_Let's look at the Commentator badge to see how it affects comments, questions,
and answers._

![Kernel density estimates](figures/density-estimates.pdf)

# Results

![Views versus reputation](figures/views-vs-reputation.pdf)

Add a coefficient plot of badges. Where does it makes sense to put effort?

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

# Conclusion

# References
