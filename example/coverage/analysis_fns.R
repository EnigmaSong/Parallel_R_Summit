library(foreach)
library(coda)
library(doRNG)
library(ggplot2)
library(itertools)
library(dplyr)
library(reshape2)


# uniform prior
a = 1
b = 1

# "small p" prior
# a = 2
# b = 5

# population proportion and sample size
p = .2
n = 20

z = qnorm(.025, lower.tail = F)

analyze.nums = function(i.chunk) {
  foreach(i=unlist(i.chunk), .combine='rbind') %do% {
    foreach(n = seq(10,100,5), .combine='rbind') %do% {
      # simulate dataset
      x = rbinom(1,n,p)
      
      # check coverage for standard estimator
      p.hat = x/n
      se = z * sqrt(p.hat*(1-p.hat)/n)
      covered.standard = p.hat - se <= p & p <= p.hat + se
      
      # check coverage for bayesian estimator
      posterior.samples = rbeta(5e5, a + x, b + n - x)
      posterior.hpd = HPDinterval(mcmc(posterior.samples))
      covered.bayes = posterior.hpd[1] <= p & p <= posterior.hpd[2]
      
      data.frame(n = n,
                 covered.standard = covered.standard,
                 covered.bayes = covered.bayes) 
    }
  }
}
