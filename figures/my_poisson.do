args infile outfile

insheet using `infile'
xtset userid

generate log_count = log(1 + count)
xtreg log_count i.k, fe vce(cluster userid)

// margins i.k, post
estout using `outfile', cells("b ci_l ci_u") delimiter(",") replace
