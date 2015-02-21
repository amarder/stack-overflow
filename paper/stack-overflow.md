---
title: Stack Overflow badges and user behavior
subtitle: An econometric perspective
author: Andrew Marder
date: \today
nocite: |
  @Antin2011, @MSRChallenge2015
---

# Introduction

Stack Overflow is a question and answer community designed for programmers. It is the largest of 130 communities in the Stack Exchange network. Created in 2008, the knowledge organized by Stack Overflow has become a valuable resource for software developers. On January 20, @Spoelsky2015 announced that Stack Exchange had raised $40 million in venture capital funding. Stack Exchange gives users who ask questions access to expert technical help, users who answer questions build their reputation for technical expertise and use that reputation to find better jobs.

Although Stack Overflow's creation was rooted in computer science, the social sciences will provide important insights as the platform matures. There are a number of big picture questions to consider. How should Stack Overflow design its platform to maximize profits? Is the firm's profit-maximizing strategy efficient - does it maximize total surplus? How equitable is the profit-maximizing strategy - Stack Overflow creates value by improving job matches, how much of that value is captured by the platform, employers, and employees? What motivates users to contribute to Stack Overflow - how important are self-interested motives versus pro-social motives? What combination of reputation rules and badge awards maximize the quantity and quality of user contributions?

This paper takes a first step along the path of applying econometric analysis to publicly available Stack Overflow data. Specifically, I study how users behave around the time they are awarded badges. Taking a closer look at user actions, we find some badges are effective at motivating user contributions while others are not.

# Rules of the game

@Deterding2011 define "_gamification_ as the use of game design elements in non-game contexts." Stack Overflow gamifies the process of asking and answering questions as follows. A user earns reputation points when another user votes on her posts (5 points when a question is voted up, 10 points when an answer is voted up, 15 points when an answer is accepted, and 2 points when an edit is approved). As a user earns reputation points she unlocks privileges on the site. For instance, a user must have at least 15 reputation points to vote up a question or answer.[^privileges] Users are awarded badges for special achievements. One receives the _Informed_ badge by reading the tour page.[^tour-badge]

[^privileges]: A full list of privileges and necessary reputation points is available at [http://stackoverflow.com/help/privileges](http://stackoverflow.com/help/privileges).
[^tour-badge]: The Stack Overflow tour can be found at [http://stackoverflow.com/tour](http://stackoverflow.com/tour), and all badges are listed on [http://stackoverflow.com/help/badges](http://stackoverflow.com/help/badges).

# How users behave when earning badges

@Grant2013 present empirical evidence that three of the
badges awarded for various editing accomplishments are effective in
encouraging users to make more edits in the two months preceding
receipt of the badge compared to the two months after receiving the
badge. This paper builds on their findings by:

1. Looking at the impact of badges on all types of user activity (posting questions, posting answers, and editing posts).

2. Comparing the impact of different badges. In addition to the three editing badges, this paper also looks at two badges awarded for asking questions.

@Grant2013 find that users who receive a badge for editing make more edits in the two-month window before receiving the badge compared to the two-month window after receiving the badge. I extend their work by exploring, on average, how many questions, answers, and edits a user posts around the time of receiving a badge. Let $y_{it}$ be the number of edits user $i$ makes on day $t$. Following the approach of @Jacobson1993 define the dummy variable

I regress the number of edits user $i$ makes on day $t$ on a user fixed effect $\alpha_i$ and a set of dummy variables indicating whether the user received the badge of interest on day $t+k$

$$
\log(1 + y_{it}) = \alpha_i + \sum_{k=-29}^{30} \1 \{ t = t_i^* + k \} \delta_k + \sum_{j=1}^6 \1 \{ t \bmod 7 = j \} \gamma_j + \epsilon_{it}.
$$

The model parameters are estimated using an ordinary least squares regression, and standard errors are clustered at the user level.

Let $t_i^*$ denote the day user $i$ recieves the badge. Figure \ref{edit} plots the expected number of actions taken on the $k$'th day since receiving the badge

$$
f(k) = \E \left[ \log(1 + y_{it}) \; | \; t=t^*_i + k \right].
$$

The 95% confidence interval is tight around the line, standard errors were calculated using the delta method [@Williams2012]. Figure \ref{edit} confirms the findings of @Grant2013, editing increases gradually before receiving the badge with a large jump in activity in the day immediately before earning the badge. We also see that editing drops quickly after receiving the badge and gradually declines over time. It's interesting to see how few questions were asked by the recipients of the editing badges in the two months around receiving the badge, and to see that the rate of answering questions tends to be constant throught the two month window.

Figure \ref{questioning} plots user activity around receiving badges for asking questions. User activity around question badges differs in interesting ways to badges for edits:

1. All types of actions tend to increase in the thirty days leading up to earning the badge. In Figure \ref{edit}, only edits increase. In Figure \ref{questioning}, the number of questions, answers, and edits posted all increased.

2. User activity stops almost immediately after receiving the badge.

\clearpage

\input{paper/table.tex}

![\label{fig:badges} User activity over time](figures/badges.pdf)

\clearpage

# Conclusion

Stack Overflow provides a platform for job searchers to signal their ability by answering difficult technical questions publicly. Unlike Spence's [-@Spence1973] model of job market signaling, Stack Overflow enables job searchers to signal their ability in the form of a valuable public good.

When interpreting the empirical results of this paper, please consider Holland and Rubin's motto "no causation without manipulation" [@Holland1986]. There is no manipulation of the explanatory variable in this study, consequently we have not identified the causal effect of badges. To estimate the causal impact of badges on user activity we need to find a source of exogenous variation [@Miller2013].

This paper confirms the empirical observation of @Grant2013, on average users who receive a badge for editing make more edits in the 30 days prior to receiving the badge compared to the 30 days after receiving the badge. In addition, we show that the average number of questions and answers posted do not change around the receipt of an editing badge. Finally, we show that users who received badges for asking questions behaved differently. In particular, we found that

# References
