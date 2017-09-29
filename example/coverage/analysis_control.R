# for parallel computations
library(Rmpi)
library(snow)
library(doSNOW)
library(foreach)
library(iterators)
library(doRNG)


#
# build and initialize cluster
#

cl = getMPIcluster()
ncores = length(cl)

registerDoSNOW(cl)

worker.script.path = 'analysis_fns.R'

clusterExport(cl, ls())

source(worker.script.path)

clusterEvalQ(cl, source(worker.script.path))


m = 8000
ci.raw = foreach(i.chunk=ichunk(1:m, ceiling(m/128)), .combine='rbind', .errorhandling='remove') %dorng% {
  analyze.nums(i.chunk)
}

save.image('sim.RData')

stopCluster(cl)
mpi.quit()
