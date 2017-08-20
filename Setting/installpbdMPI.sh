#!/bin/bash
module purge 
module load R
module load openmpi/1.10.2

wget https://cran.r-project.org/src/contrib/rlecuyer_0.3-4.tar.gz

R CMD INSTALL rlecuyer_0.3-4.tar.gz

wget https://cran.r-project.org/src/contrib/pbdMPI_0.3-3.tar.gz

R CMD INSTALL pbdMPI_0.3-3.tar.gz --configure-args=" \
  --with-mpi-type=OPENMPI \
  --with-mpi-include=$CURC_OPENMPI_INC \
  --with-mpi-libpath=$CURC_OPENMPI_LIB" \
  --library=/projects/$USER/R/library/ --no-test-load
