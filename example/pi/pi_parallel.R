# Description: Calculate pi using Monte Carlo (parallel)
# Run: Rscript pi_parallel.r

library(parallel)

approx.pi <- function(n) {
  # approximates pi via MC integration of unit disk
  RNGkind("L'Ecuyer-CMRG")
  set.seed(1.0)

  x <- runif(n, min = -1, max = 1)
  y <- runif(n, min = -1, max = 1)
  V <- 4
  f_hat <- ifelse(x^2 + y^2 <= 1, 1, 0)
  V * sum(f_hat) / n
}

#problem size (number of points)
npts <- 1E7

#cluster size 
ncores <- as.numeric(Sys.getenv("SLURM_NTASKS"))

npts.core <- npts/ncores  # points per core

cat('running parallel version with n.pts = ',npts,' and ncores = ',ncores,' (',npts.core,' pts per core) \n')

#start up and initialize the cluster
cl <- makeCluster(ncores)

time.start = Sys.time()

n <- rep(npts, ncores)
result = parSapply(cl, n, approx.pi)

#stop the cluster
stopCluster(cl)

pi.approx = mean(result)

cat('     pi estimate = ', pi.approx,'\n')

pi.err = abs(pi - pi.approx)/pi
cat('  relative error = ', pi.err,'\n')

tm.tot = as.numeric(Sys.time() - time.start, units="secs")
cat('          total time = ',tm.tot,'\n')
