library(dplyr)
library(ggplot2)
library(tidyr)

load('sim.RData')

ci.raw %>% 
  group_by(n) %>% 
  summarize(
    coverage.standard = mean(covered.standard),
    coverage.bayes = mean(covered.bayes)
  ) %>% 
  gather('Method', 'Coverage', -n) %>%
  mutate(Method=ifelse(Method=='coverage.standard','CLT CI', 'Bayesian CI')) %>%
  ggplot(aes(x=n, y=Coverage, color=Method)) +
    xlab('Sample size') + 
    geom_hline(yintercept = .95, lty=2) +
    geom_smooth(se = F) 
  
.Last=NULL