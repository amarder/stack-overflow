---
title: Stack Overflow and Gamification - Something from Nothing?
author: Andrew Marder
date: \today
---

# What is Stack Overflow?

@deterding_game_2011 define "_gamification_ as the use of game design
elements in non-game contexts."
[Stack Overflow](http://stackoverflow.com/) is a question and answer
website designed for programmers that employs a few game elements:

1. A user earns reputation points when another user votes on her posts
   (5 points when a question is voted up, 10 points when an answer is
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
badge. This paper builds on their findings by:

1. Looking at the impact of badges on all types of user activity (posting questions, posting answers, and editing posts).

3. Comparing the impact of different badges. Looking at three different badges, each aimed at promoting a different type of user activity.

# Data

There are almost 3.5 million registered users on Stack Overflow. Less than one percent of those users have been awarded the Strunk & White, Copy Editor, or Archaeologist badges.


# Do badges encourage action?

@grant_encouraging_2013 find that users who receive a badge for editing make more edits in the two-month window before receiving the badge compared to the two-month window after receiving the badge. I extend their work by exploring, on average, how many questions, answers, and edits a user posts around the time of receiving a badge. Let $y_{it}$ be the number of edits user $i$ makes on day $t$, and

$$
D_{it}^k =
\begin{cases}
1 & \text{if user $i$ earns the badge on day } t+k, \\
0 & \text{otherwise.}
\end{cases}
$$

I regress the number of edits user $i$ makes on day $t$ on a user fixed effect and a set of dummy variables to measure indicating the number of days before receiving the badge of interest

$$
y_{it} = \alpha_i + \sum_{k=-29}^{30} D_{it}^k \delta_k + \epsilon_{it}.
$$

Figure \ref{edit} plots the mean number of actions taken in the days around receiving the badge. The 95% confidence interval is tight around the line, standard errors were clustered at the user level. Confirming the conclusion of @grant_encouraging_2013, we see that badge recipients drastically increase activity before receiving the Copy Editor badge making 24.6 edits in the 24 hours immediately before receiving the badge and dropping down to 2.9 edits in the 24 hours immediately after receiving the badge.

![\label{edit} Mean number of actions performed over time](figures/editing.pdf)

Although plotting the mean activity of the 1206 recipients of the Copy Editor badge it seems reasonable to conclude these users increase their activity on the site because they want to earn the badge, it seems unreasonable to assume these users would be completely inactive if the badge did not exist. I apply the event study approach of @jacobson_earnings_1993 to further explore how user behavior changes around the time of receiving a badge. I add a time fixed effect

$$
y_{it} = \alpha_i + \gamma_t + \sum_{k=-4}^{4} D_{it}^k \delta_k + \epsilon_{it}.
$$

I also include 1206 users that did not receive the Copy Editor badge in the regression, I find this synthetic control group using nearest neighbor matching based on account creation date [@ho_matching_2007].

TODO: Need to do clean event study approach.

# How much action?

As noted by @miller_principal_2013, one cannot make causal claims using an event study approach. We need a source of exogenous variation to reliably estimate the causal impact of badges.

TODO: Insert timeline of badges.

In this section we use a difference-in-differences model to estimate the causal impact of introducing three new badges to Stack Overflow.

# Conclusion

# References
