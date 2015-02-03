args infile outfile

insheet using `infile'
xtset userid

// xtpoisson count i.minute, fe vce(robust)
poisson count i.minute, vce(robust)

margins i.minute, post
estout using `outfile', cells("b ci_l ci_u") delimiter(",") replace
