# parallel components
library(Rmpi)
library(doSNOW)
library(foreach)
library(doRNG)
library(iterators)
# set paths
working.directory = '~/lustrefs/Josh' #Change Path
worker.script = 'analysis_fns.R'

# set up cluster
cl = getMPIcluster()
clusterExport(cl, ls())
setwd(working.directory)
source(worker.script)
clusterEvalQ(cl, setwd(working.directory))
clusterEvalQ(cl, source(worker.script))
registerDoSNOW(cl)
# run test
res = foreach(param=iter(param.range, by = 'row'),
.combine = rbind, .errorhandling = 'remove') %dorng% {
clean.res = na.omit(replicate(reps,
run.sim(param$n, param$alpha, pval)))
data.frame(n=param$n,
alpha=param$alpha,
rejection.rate=sum(clean.res)/
length(clean.res))
}
save.image('cray_sim.RData')
stopCluster(cl)
mpi.quit()
