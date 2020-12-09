# clear workspace:  
rm(list=ls()) 

# open jags library
library(R2jags)

# define / read in data
# NOTE: This is data from the baseline measurement, replace with data from later measurement occasions
# NOTE: This is simulated data, replace with real data
sim <- sim.LCA(SeKK = 0.7, SeCCA = 0.7, SeCAA = 0.7, SePCR = 0.7,
                     SpKK = 1, SpCCA = 1, SpCAA = 1, SpPCR = 0.8,
                     prev = 0.9, n = 150)
counts <- sim[,5]
n <- sum(counts)

# define data object that is passed on to JAGS
data <- list("counts", "n") 

# define starting values for chains
myinits <-	list(
  list(theta1=0.9, theta2=0.6, theta4=0.5, theta5=0.5,
       theta8=0.8, theta9=0.8, theta10=0.7, theta11=0.7, theta16=0.5, 
       theta17=0.7, theta18=0.7, theta19=0.7, theta20=0.7, theta21=0.7,
       theta22=0.7, theta23=0.7, theta24=0.8),
  list(theta1=0.8, theta2=0.5, theta4=0.6, theta5=0.7,
       theta8=0.5, theta9=0.6, theta10=0.7, theta11=0.7, theta16=0.5, 
       theta17=0.9, theta18=0.8, theta19=0.6, theta20=0.5, theta21=0.5,
       theta22=0.9, theta23=0.7, theta24=0.9),
  list(theta1=0.7, theta2=0.7, theta4=0.7, theta5=0.4,
       theta8=0.7, theta9=0.7, theta10=0.7, theta11=0.7, theta16=0.5, 
       theta17=0.7, theta18=0.6, theta19=0.8, theta20=0.6, theta21=0.8,
       theta22=0.7, theta23=0.8, theta24=0.7),
  list(theta1=0.5, theta2=0.8, theta4=0.8, theta5=0.8,
       theta8=0.7, theta9=0.5, theta10=0.5, theta11=0.5, theta16=0.5, 
       theta17=0.5, theta18=0.5, theta19=0.5, theta20=0.5, theta21=0.5,
       theta22=0.5, theta23=0.5, theta24=0.5)
) 

# parameters to be monitored
parameters <- c("prev", "Se1", "Se2", "Se3", "Se4", "Sp4")

# MCMC
samples <- jags(data, inits=myinits, parameters,
                model.file ="../models/LCA_dependent_Spec123Is1.txt", n.chains=4, n.iter=100000, 
                n.burnin=3000, n.thin=20, DIC=F)

# Convergence diagnostics
traceplot(samples) # this should look like a hairy caterpillar
samples$BUGSoutput$summary[,"Rhat"] # Convergence: R-hat value is smaller or equal to 1; if R-hat > 1.05, increase n.burnin or n.thin to decrease R-hat, change starting values to something more reasonable; if none of this works, don't interpret parameter with high R-hat

# Information about posterior distributions
print(samples) # posterior mean, standard deviations, and quantiles
# for plots, you can use the samples directly
posteriorsamples <- samples$BUGSoutput$sims.matrix
