# Clear everything.
rm(list = ls())

# Source helpers.
source("./scripts/helpers/helpers.R")

# define / read in data
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
  list(SeKK = 0.7, SeCCA = 0.7, SeCAA = 0.7, SePCR = 0.7,
       SpKK = 0.8, SpCCA = 0.8, SpCAA = 0.8, SpPCR = 0.8, prev=0.9),
  list(SeKK = 0.5, SeCCA = 0.5, SeCAA = 0.5, SePCR = 0.5,
       SpKK = 0.5, SpCCA = 0.5, SpCAA = 0.5, SpPCR = 0.5, prev=0.8),
  list(SeKK = 0.5, SeCCA = 0.5, SeCAA = 0.5, SePCR = 0.5,
       SpKK = 0.9, SpCCA = 0.9, SpCAA = 0.9, SpPCR = 0.9, prev=0.7),
  list(SeKK = 0.6, SeCCA = 0.6, SeCAA = 0.6, SePCR = 0.6,
       SpKK = 0.8, SpCCA = 0.8, SpCAA = 0.8, SpPCR = 0.8, prev=0.9)
)

# parameters to be monitored
parameters <- c("SeKK", "SeCCA", "SeCAA", "SePCR",
                "SpKK", "SpCCA", "SpCAA", "SpPCR", "prev")

# MCMC
samples <- jags(data, inits=myinits, parameters,
                model.file ="./models/LCA_simple_flatPriors.txt", n.chains=4, n.iter=10000,
                n.burnin=2000, n.thin=1, DIC=F)

# Convergence diagnostics
traceplot(samples) # this should look like a hairy caterpillar
samples$BUGSoutput$summary[,"Rhat"] # Convergence: R-hat value is smaller or equal to 1; if R-hat > 1.05, increase n.burnin or n.thin to decrease R-hat, change starting values to something more reasonable; if none of this works, don't interpret parameter with high R-hat

# Information about posterior distributions
print(samples) # posterior mean, standard deviations, and quantiles

# Plot.
plot.estimates(samples)
