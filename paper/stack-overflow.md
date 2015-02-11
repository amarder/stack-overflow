---
title: Stack Overflow and Gamification - Something from Nothing?
author: Andrew Marder
date: \today
---

"Stack Exchange is a network of 130+ Q&A communities including Stack Overflow, the preeminent site for programmers to find, ask, and answer questions about software development...Stack Overflow Careers connects Stack Overflow users with employers." On January 20, @Spoelsky2015 announced that Stack Exchange had raised $40 million in venture capital funding. Stack Exchange gives users who ask questions access to expert technical help for free. Users who answer questions build their reputation for technical expertise, and use that reputation to find better jobs.

Although Stack Overflow's creation was strongly rooted in computer science, the social sciences will play a large role as the platform matures. There are a number of big picture questions to consider. How should Stack Overflow design its platform to maximize profits? Is the firm's profit-maximizing strategy efficient, does it maximize total surplus? How equitable is the profit-maximizing strategy? Stack Overflow creates value by improving job matches, how much of that value is captured by the platform, employers, and employees? What motivates users to contribute to Stack Overflow, what do user preferences look like? How important are self-interested motives versus pro-social motives? What combination of reputation rules and badge awards maximize the quantity and quality of contributions on the site?

This paper takes a first step along the path of applying econometric analysis to publicly available Stack Overflow data. Specifically, I study how users behave around the time they are awarded badges. By taking a closer look at user actions we start to get an idea of how badges motivate user contributions.

# What is Stack Overflow?

@Deterding2011 define "_gamification_ as the use of game design
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

@Grant2013 present empirical evidence that three of the
badges awarded for various editing accomplishments are effective in
encouraging users to make more edits in the two months preceding
receipt of the badge compared to the two months after receiving the
badge. This paper builds on their findings by:

1. Looking at the impact of badges on all types of user activity (posting questions, posting answers, and editing posts).

3. Comparing the impact of different badges. Looking at three different badges, each aimed at promoting a different type of user activity.

# How do users behave when earning badges?

@Grant2013 find that users who receive a badge for editing make more edits in the two-month window before receiving the badge compared to the two-month window after receiving the badge. I extend their work by exploring, on average, how many questions, answers, and edits a user posts around the time of receiving a badge. Let $y_{it}$ be the number of edits user $i$ makes on day $t$. Following the approach of @Jacobson1993 define the dummy variable

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

The model parameters are estimated using an ordinary least squares regression, and standard errors are clustered at the user level.

Let $t_i^*$ denote the day user $i$ recieves the badge. Figure \ref{edit} plots the expected number of actions taken on the $k$'th day since receiving the badge

$$
f(k) = E \left[ \log(1 + y_{it}) \; | \; t=t^*_i + k \right].
$$

Strunk & White Edited 80 posts
Copy Editor Edited 500 posts (excluding own or deleted posts and tag edits)
Archaelogist Edited 100 posts that were inactive for 6 months
Curious Asked a well-received question on 5 separate days, and maintained a positive question record
Inquisitive Asked a well-received question on 30 separate days, and maintained a positive question record

The 95% confidence interval is tight around the line, standard errors were calculated using the delta method [@Williams2012]. Figure \ref{edit} confirms the findings of @Grant2013, editing increases gradually before receiving the badge with a large jump in activity in the day immediately before earning the badge. We also see that editing drops quickly immediately after receiving the badge and gradually declines over time. It's interesting to see how few questions were asked by the recipients of the editing badges in the two months around receiving the badge, and to see that the rate of answering questions tends to be constant throught the two month window.

![\label{edit} User activity over time - badges for edits](figures/editing.pdf)

Figure \ref{questioning} plots user activity around receiving badges for asking questions. User activity around question badges differs in interesting ways to badges for edits:

1. All types of actions tend to increase in the thirty days leading up to earning the badge. In Figure \ref{edit}, only edits increased. In Figure \ref{questioning}, the number of questions, answers, and edits posted all increased.

2. User activity stops almost immediately after receiving the badge. This makes me think something might be wrong with the data. It's too stark.

![\label{questioning} User activity over time - badges for questions](figures/questions.pdf)

# Conclusion

As a fan of Holland and Rubin's motto "no causation without manipulation", it is important to note that this paper does not identify the causal effect of badges [@Holland1986]. To reliably estimate the causal impact of badges of user activity we need a source of exogenous variation [@Miller2013]. This paper contributes to the literature by describing more clearly how users behave around receiving badges.

@Antin2011

# References
