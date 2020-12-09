# clear workspace:  
rm(list=ls()) 

# open jags library
library(R2jags)

# define / read in data
# NOTE: This is data from the baseline measurement, replace with data from later measurement occasions
# NOTE: This is simulated data, replace with real data
sim <- sim.LCA(SeKK = 0.7, SeCCA = 0.7, SeCAA = 0.7, SePCR = 0.7,
                     SpKK = 0.95, SpCCA = 0.95, SpCAA = 0.95, SpPCR = 0.95,
                     prev = 0.9, n = 350)
counts <- sim[,5]
n <- sum(counts)

# define data object that is passed on to JAGS
data <- list("counts", "n") 

# define starting values for chains
myinits <-	list(
  list(theta1=0.8, theta2=0.7, theta3=0.9, theta4=0.6, theta5=0.4, theta6=0.7,
       theta7=0.6, theta8=0.7, theta12=0.8, theta16=0.7, theta24=0.9),
  list(theta1=0.9, theta2=0.6, theta3=0.8, theta4=0.5, theta5=0.5, theta6=0.8,
       theta7=0.7, theta8=0.8, theta12=0.9, theta16=0.5, theta24=0.8),
  list(theta1=0.5, theta2=0.8, theta3=0.7, theta4=0.7, theta5=0.7, theta6=0.5,
       theta7=0.5, theta8=0.7, theta12=0.6, theta16=0.6, theta24=0.7),
  list(theta1=0.7, theta2=0.5, theta3=0.8, theta4=0.8, theta5=0.6, theta6=0.6,
       theta7=0.4, theta8=0.6, theta12=0.5, theta16=0.4, theta24=0.6)
) 

# parameters to be monitored
parameters <- c("prev", "Se1", "Sp1", "Se2", "Sp2", "Se3", "Sp3", "Se4", "Sp4")

# MCMC
samples <- jags(data, inits=myinits, parameters,
                model.file ="../models/LCA_dependent_2Tests.txt", n.chains=4, n.iter=15000, 
                n.burnin=5000, n.thin=1, DIC=F)

# Convergence diagnostics
traceplot(samples) # this should look like a hairy caterpillar
samples$BUGSoutput$summary[,"Rhat"] # Convergence: R-hat value is smaller or equal to 1; if R-hat > 1.05, increase n.burnin or n.thin to decrease R-hat, change starting values to something more reasonable; if none of this works, don't interpret parameter with high R-hat

# Information about posterior distributions
print(samples) # posterior mean, standard deviations, and quantiles
# for plots, you can use the samples directly
posteriorsamples <- samples$BUGSoutput$sims.matrix
