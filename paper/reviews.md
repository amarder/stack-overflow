# REVIEW 1

> The paper studies how users behave around the time they are awarded
> badges. The study includes six badges and all types of user activity
> (posting questions, posting answers, and editing posts) around the
> time of badge earning. The paper is well written. The motivation is
> nicely described and the results are clear.

> I would have liked to see some discussion around the results
> describing why they are important or what are their implications.

TODO: Why do we care? What are the implications of these results?

> I do understand there may not be much room for this in a 4 page
> paper. However, the paper is not in the correct format for the
> conference and will need to be reformatted in the final version. I
> believe there will be additional room in the correct format.

DONE

> The first paragraph of the conclusion implies that the only reason
> for using stack overflow is during a job search, which certainly is
> not the case.

DONE: Thank you for bringing this up. I have reworked this aspect of
the paper hoping to better represent the many motivations for
contributing to Stack Overflow.

> The authors should be careful with causation claims: “editing badges
> may have a secondary effect of encouraging answers”  Actually, the
> authors have only shown that edit badges are awarded when editing
> and answering seem to spike (not that the edit badge is the cause of
> those spikes).

DONE: Thanks for keeping me honest here. I was definitely guilty of
causation creep - I let a causal interpretation creep onto
correlational evidence. I have been more careful in the second draft.

# REVIEW 2

> The paper describes an evaluation of the impact that stack overflow
> badges has on user behavior. Using regression models trained using
> the stack overflow dataset, the results confirm the findings of
> Grant and Betts (MSR 2013), that is that the editing behavior of
> users changes in the period before and after receiving a
> badge. However, question-posting and answer-writing behaviour does
> not appear to change drastically, suggesting that user behavior is
> not heavily influenced by question- and answer-based badges.

> The paper tackles an interesting problem (albeit a revisited one)
> using (what appears to be) a technically sound approach. Perhaps the
> paper should be framed more carefully from this "revisiting"
> perspective.

TODO: I think this is a fair criticism of the paper. I need to
differentiate the paper enough from Granat and Betts (2013) to avoid
this "revisiting" classification. Why do we care? How is this paper
different from Grant and Betts (2013)?

> On the other hand, while the model is used to generate interesting
> response curves, it is unclear how accurately the response is
> modeled. In other words, how much error is there f^(k) with respect
> to f(k)? Without knowing this, it is difficult to interpret Figure
> 1.

TODO: I have included the 95% confidence interval in Figure 1. This
confidence interval was calculated using standard errors that were
clustered at the user level. I think the intervals look too tight and
it would be more reasonable to cluster the standard errors at both the
user and time levels.

> Moreover, many details about the fit are left unexplained. It would
> be great if the paper could go into more detail about the modeling
> approach that was applied. Currently, the description is quite terse
> and difficult to follow.  Especially, the finer details about the
> elements of Equation 1 were not defined.

TODO: Discuss equations more.
TODO: More details about the fit of the model.

> Finally, the paper is in the incorrect template. Please use one of
> the official MSR templates provided here:
> http://2015.icse-conferences.org/submission-guidelines

DONE

# REVIEW 3

> The paper studied how user activities change at the time around
> gaining badges.  The author used regression analysis to establish
> the relation.
>
> Pros:
>
> + Though not novel, the study is very interesting and the author is
>   up front about extending previous work.
> + Well written paper.
> + Studied effect of different badges for different activities.

> Cons:
> - Does not follow the conference format.

DONE

> - Authors claim that for some badges, edit activity changes
>   significantly. Please provide the effect size to understand the
>   deviance.

TODO: How much does behavior change around the time of earning badges?
