library(Rmpi)
library(doSNOW)

cl <- getMPIcluster()
registerDoSNOW(cl)

approx.pi <- function(n) {
  # approximates pi via MC integration of unit disk
  x <- runif(n, min = -1, max = 1)
  y <- runif(n, min = -1, max = 1)
  V <- 4
  f_hat <- ifelse(x^2 + y^2 <= 1, 1, 0)
  V * sum(f_hat) / n
}

#problem size (number of points)
npts <- 1E7

#cluster size 
ncores <- 10

npts.core <- npts/ncores  # points per core

message(paste('running parallel version with n.pts = ',npts,' and ncores = ',ncores,' (',npts.core,' pts per core) \n'))

#start up and initialize the cluster

time.start = Sys.time()

n <- rep(npts.core, ncores)
result <- parSapply(cl,n, approx.pi)
    pi.approx <- sum(unlist(result))/npts
    pi.err = abs(pi - pi.approx)/pi

    tm.tot = as.numeric(Sys.time() - time.start, units="secs")
    cat('Pi approximation = ', pi.approx, 'n')
    cat('  relative error = ', pi.err,'\n')
    cat('          total time = ',tm.tot,'\n')
    
stopCluster(cl)
mpi.quit()
