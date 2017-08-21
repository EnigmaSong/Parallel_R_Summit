# Description: Calculate pi using Monte Carlo (parallel)
# Run: Rscript pi_parallel.r

## for random generator in parallel

library(pbdMPI)

init()

.comm.size <- comm.size()
.comm.rank <- comm.rank()

approx.pi <- function(n) {
  # approximates pi via MC integration of unit disk
  RNGkind("L'Ecuyer-CMRG")
  comm.set.seed(1.0, diff=TRUE)

  x <- runif(n, min = -1, max = 1)
  y <- runif(n, min = -1, max = 1)
  V <- 4
  f_hat <- ifelse(x^2 + y^2 <= 1, 1, 0)
  V * sum(f_hat) / n
}

#problem size (number of points)
npts <- 1E7

#cluster size 
ncores <- comm.size()

npts.core <- npts/ncores  # points per core

comm.cat('running parallel version with n.pts = ',npts,' and ncores = ',ncores,' (',npts.core,' pts per core) \n')

#start up and initialize the cluster

time.start = Sys.time()

n <- rep(npts.core, ncores)
result <- pbdSapply(n, approx.pi, pbd.mode="mw")
if (.comm.rank == 0) {
    pi.approx <- sum(unlist(result))/.comm.size
    pi.err = abs(pi - pi.approx)/pi

    tm.tot = as.numeric(Sys.time() - time.start, units="secs")
    cat('Pi approximation = ', pi.approx, 'n')
    cat('  relative error = ', pi.err,'\n')
    cat('          total time = ',tm.tot,'\n')
}
finalize()
