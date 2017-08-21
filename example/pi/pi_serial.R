# Calculate PI with Monte Carlo
approx_pi <- function(n) {
  # approximates pi via MC integration of unit disk
  x <- runif(n, min = -1, max = 1)
  y <- runif(n, min = -1, max = 1)
  V <- 4
  f_hat <- ifelse(x^2 + y^2 <= 1, 1, 0)
  V * sum(f_hat) / n
}

time.start = Sys.time()

npts = 1E7
n <- rep(npts, 5)
result <- sapply(n, approx_pi)
pi.approx = mean(result)

cat('     pi estimate = ', pi.approx,'\n')

pi.err = abs(pi - pi.approx)/pi
cat('  relative error = ', pi.err,'\n')

tm.tot = as.numeric(Sys.time() - time.start, units="secs")
cat('          total time = ',tm.tot,'\n')
