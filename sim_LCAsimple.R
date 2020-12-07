# Simulate data from a simple LCA model (no dependency, no treatment groups)

library(R2jags)
library(runjags)

# Parameters for simulation (set to realistic values)
SeKK <- 0.75
SeCCA <- 0.8
SeCAA <- 0.77
SePCR <- 0.85

SpKK <- 0.97
SpCCA <- 0.90
SpCAA <- 0.98
SpPCR <- 0.96

prev <- 0.8
n <- 350

sim.LCA <- function(SeKK=SeKK, SeCCA=SeCCA, SeCAA=SeCAA, SePCR=SePCR,
                    SpKK=SpKK, SpCCA=SpCCA, SpCAA=SpCAA, SpPCR=SpPCR,
                    prev=prev, n=n){
  data <- list(SeKK=SeKK, SeCCA=SeCCA, SeCAA=SeCAA, SePCR=SePCR,
               SpKK=SpKK, SpCCA=SpCCA, SpCAA=SpCAA, SpPCR=SpPCR,
               prev=prev, n=n)
  
  # Use JAGS to sample from model
  simres <- run.jags("sim_LCAsimple.txt", data=data, monitor=c("counts"), 
                     sample=1, n.chains=1, summarise=FALSE, silent.jags = TRUE)
  counts <- as.matrix(simres$mcmc)
  
  # Extend sample to full simulated data frame
  fullsimdat <- matrix(c(1,1,1,1,
                         1,1,1,0,
                         1,1,0,1,
                         1,1,0,0,
                         1,0,1,1,
                         1,0,1,0,
                         1,0,0,1,
                         1,0,0,0,
                         0,1,1,1,
                         0,1,1,0,
                         0,1,0,1,
                         0,1,0,0,
                         0,0,1,1,
                         0,0,1,0,
                         0,0,0,1,
                         0,0,0,0), byrow = T, ncol=4)
  fullsimdat <- cbind(fullsimdat, counts[1,])
  fullsimdat <- as.data.frame(fullsimdat)
  colnames(fullsimdat) <- c("KK", "CCA", "CAA", "PCR", "counts")
  return(fullsimdat)
}

simdata <- sim.LCA(SeKK=SeKK, SeCCA=SeCCA, SeCAA=SeCAA, SePCR=SePCR,
         SpKK=SpKK, SpCCA=SpCCA, SpCAA=SpCAA, SpPCR=SpPCR,
         prev=prev, n=n)



