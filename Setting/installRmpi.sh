#!/bin/bash
module purge 
module load R

wget https://cran.r-project.org/src/contrib/Rmpi_0.6-6.tar.gz

R CMD INSTALL Rmpi_0.6-6.tar.gz --library=$R_LIBS --no-test-load
