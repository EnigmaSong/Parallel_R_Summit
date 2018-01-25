library(sn)
library(compiler)
# set the range of the parameters to test
pval = .05
alpha.range = 1:100
n.range = seq(100,1000,10)
param.range = expand.grid(alpha=alpha.range, n=n.range)
# set test parameters
# simulation runs for each combination of parameters
reps = 1000

run.sim = cmpfun(function(n, alpha, pval){
x = rsn(n, alpha=alpha)
# log-likelihood for MLE SN fit
logLik.mle = as.numeric(logLik(selm(x~1)))
# log-likelihood for MLE N fit
logLik.dev = logLik(selm(x~1,
fixed.param = list(alpha = 0)))
# compute deviance of SN vs N fit
x.fit.dev = 2 * (logLik.mle - logLik.dev)
# compute deviance p-value for SN vs. N fit
pval.dev = pchisq(x.fit.dev, df=1, lower.tail = F)
pval.dev < pval
})
