---
title: Stack Overflow badges and user behavior
subtitle: An econometric approach
author: Andrew Marder
date: \today
nocite: |
  @Antin2011, @MSRChallenge2015, @se-dump
---

Stack Overflow is a question and answer community designed for programmers. It is the largest of 130 communities in the Stack Exchange network. Created in 2008, the knowledge organized by Stack Overflow has become a valuable resource for software developers. On January 20, @Spoelsky2015 announced that Stack Exchange had raised $40 million in venture capital funding. Stack Overflow gives users who ask questions access to expert technical help, while users who answer questions build their reputation for technical expertise and use that reputation to find better employment opportunities.

@Deterding2011 define "_gamification_ as the use of game design elements in non-game contexts." Stack Overflow gamifies the process of asking and answering questions as follows. A user earns reputation points when another user votes on her posts (5 points when a question is voted up, 10 points when an answer is voted up, 15 points when an answer is accepted, and 2 points when an edit is approved). As a user earns reputation points she unlocks privileges on the site. For instance, a user must have at least 15 reputation points to vote up a question or answer.[^privileges] Users are awarded badges for special achievements. For example, one receives the _Informed_ badge by reading the tour page.[^tour-badge]

[^privileges]: A full list of privileges and the corresponding reputation points is available at [http://stackoverflow.com/help/privileges](http://stackoverflow.com/help/privileges).
[^tour-badge]: The Stack Overflow tour can be found at [http://stackoverflow.com/tour](http://stackoverflow.com/tour), and all badges are listed on [http://stackoverflow.com/help/badges](http://stackoverflow.com/help/badges).

This paper takes a first step along the path of applying econometric analysis to publicly available Stack Overflow data. Do badges motivate users to contribute to the site? Which badges are most effective? What types of user contributions are responsive to gamification? To begin answering these questions, I study how users behave around the time they are awarded badges.

# Methods

@Grant2013 present empirical evidence that three badges awarded for editing encourage recipients to make more edits in the two months preceding receipt of the badge compared to the two months after receiving the badge. This paper extends their findings by examining all types of user activity (posting questions, posting answers, and editing posts), and exploring the impact of three new badges awarded for asking questions. Table \ref{tab:badges} describes the six badges considered in this paper.

\input{paper/table.tex}

Let $y_{it}$ be the number of edits user $i$ makes on day $t$, and $t_i^*$ denote the day user $i$ receives the badge of interest. Following the approach of @Jacobson1993, I regress the number of edits user $i$ makes on day $t$ on a user fixed effect $\alpha_i$, a set of dummy variables indicating whether the user received the badge on day $t-k$, while controlling for day of the week effects $\gamma_j$

$$
\log(1 + y_{it}) = \alpha_i + \sum_{k=-29}^{30} \1 \{ t = t_i^* + k \} \delta_k + \sum_{j=1}^6 \1 \{ t \bmod 7 = j \} \gamma_j + \epsilon_{it}.
$$

\footnotetext{A question is \textit{well-received} if it's open and has a score greater than 0. \url{http://meta.stackexchange.com/questions/234259/asking-days-badges}}

The model parameters are estimated using an ordinary least squares regression, and standard errors are clustered at the user level. Define $f(k)$ to be the expected number of actions taken on the $k$'th day since receiving the badge

$$
f(k) = \E \left[ \log(1 + y_{it}) \; | \; t=t^*_i + k \right].
$$

The predicted number of actions $\hat{f(k)}$ is presented in Figure \ref{fig:badges}. The 95% confidence interval is depicted as a gray band around the linear prediction, standard errors were calculated using the delta method [@Williams2012].

# Results

The first three rows of Figure \ref{fig:badges} illustrate how user activity changes around the time one earns a badge for editing. Each row is labeled with the name of the focal badge (_Strunk & White_, _Copy Editor_, and _Archaeologist_). There is one column for each type of user action (posting a question, posting an answer, or editing a post). The figure confirms the findings of @Grant2013. Editing increases gradually before receiving a badge for editing, with a large jump in activity on the award day. We also see that editing drops quickly after receiving the badge and gradually declines over time. It's interesting to see how few questions were asked by the recipients of the editing badges, and to see that the rate of answering questions has a very slight increase leading up to receiving the badge and a similarly slight decrease after receiving the badge.

![\label{fig:badges} User activity over time](figures/badges.pdf)

The results for the question-focused badges, _Curious_, _Inquisitive_, and _Socratic_, are quite different. In general, recipients of these badges are not particularly active on the site. The average level of questions, answers, and edits made all hover near zero. The uptick in questions asked on the day before receiving the badge is mechanical. Many users who earn these badges ask a question the day before they earn the badge.

By looking at a new set of badges we find that not all badges are effective at motivating user activity. The three badges for editing seem effective at changing user behavior around the time the badge is awarded. The three badges for questions do not appear effective at changing user behavior.

# Conclusion

Stack Overflow provides a platform for job searchers to signal their ability by answering difficult technical questions publicly. Unlike Spence's [-@Spence1973] model of job market signaling, Stack Overflow enables job searchers to signal their ability in the form of a valuable public good.

When interpreting the empirical results of this paper, please consider Holland and Rubin's motto "no causation without manipulation" [@Holland1986]. There is no manipulation of the explanatory variable in this study, consequently we have not identified the causal effect of badges. To estimate the causal impact of badges on user activity we need to find a source of exogenous variation [@Miller2013].

This paper confirms the empirical observation of @Grant2013, on average users who receive a badge for editing make more edits in the 30 days prior to receiving the badge compared to the 30 days after receiving the badge. In addition, we consider how other user actions respond to editing badges. The number of questions asked each day is near zero. The slight time trends in the number of answers posted hint at a potential spillover effect, editing badges may have a secondary effect of encouraging answers. Finally, we show that users who received badges for asking questions behaved differently. In particular, we found that users do not appear motivated to change their activity levels to earn badges for asking questions.

# References
