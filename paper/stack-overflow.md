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


# How do users behave when earning badges?

@grant_encouraging_2013 find that users who receive a badge for editing make more edits in the two-month window before receiving the badge compared to the two-month window after receiving the badge. I extend their work by exploring, on average, how many questions, answers, and edits a user posts around the time of receiving a badge. Let $y_{it}$ be the number of edits user $i$ makes on day $t$, and

@jacobson_earnings_1993

$$
D_{it}^k =
\begin{cases}
1 & \text{if user $i$ earns the badge on day } t+k, \\
0 & \text{otherwise.}
\end{cases}
$$

I regress the number of edits user $i$ makes on day $t$ on a user fixed effect $\alpha_i$ and a set of dummy variables indicating whether the user received the badge of interest on day $t+k$

$$
\log(1 + y_{it}) = \alpha_i + \sum_{k=-29}^{30} D_{it}^k \delta_k + \epsilon_{it}.
$$

This model was estimated using ordinary least squares, standard errors were clustered at the user level.

Let $t_i^*$ denote the day user $i$ recieves the badge. Figure \ref{edit} plots the expected number of actions taken on the $k$'th day since receiving the badge

$$
f(k) = E \left[ \log(1 + y_{it}) \; | \; t=t^*_i + k \right].
$$

The 95% confidence interval is tight around the line, standard errors were calculated using the delta method [@williams_using_2012]. Confirming the conclusion of @grant_encouraging_2013, we see that badge recipients drastically increase activity before receiving the Copy Editor badge making 24.6 edits in the 24 hours immediately before receiving the badge and dropping down to 2.9 edits in the 24 hours immediately after receiving the badge.

![\label{edit} Mean number of actions performed over time](figures/editing.pdf)

![\label{questioning} Event study around badges awarded for asking questions](figures/questions.pdf)

# Conclusion

As a fan of Holland and Rubin's motto "no causation without manipulation", it is important to note that this paper does not identify the causal effect of badges [@holland_statistics_1986]. To reliably estimate the causal impact of badges of user activity we need a source of exogenous variation [@miller_principal_2013]. This paper contributes to the literature by describing more clearly how users behave around receiving badges.

# References
