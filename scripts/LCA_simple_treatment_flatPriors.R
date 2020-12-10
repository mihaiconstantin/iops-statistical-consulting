# Clear everything.
rm(list = ls())

# Source helpers.
source("./scripts/helpers/helpers.R")

# define / read in data
# NOTE: This is simulated data, replace with real data
group1sim <- sim.LCA(SeKK = 0.7, SeCCA = 0.7, SeCAA = 0.7, SePCR = 0.7,
                     SpKK = 0.95, SpCCA = 0.95, SpCAA = 0.95, SpPCR = 0.95,
                     prev = 0.9, n = 350)
group2sim <- sim.LCA(SeKK = 0.7, SeCCA = 0.7, SeCAA = 0.7, SePCR = 0.7,
                     SpKK = 0.95, SpCCA = 0.95, SpCAA = 0.95, SpPCR = 0.95,
                     prev = 0.8, n = 350)
counts <- matrix(c(group1sim$counts, group2sim$counts), nrow=2, byrow=TRUE)
n1 <- sum(counts[1,])
n2 <- sum(counts[2,])

# define data object that is passed on to JAGS
data <- list("counts", "n1", "n2")

# define starting values for chains
myinits <-	list(
  list(SeKK = 0.7, SeCCA = 0.7, SeCAA = 0.7, SePCR = 0.7,
       SpKK = 0.8, SpCCA = 0.8, SpCAA = 0.8, SpPCR = 0.8, genprev=0.9, diff=0.1),
  list(SeKK = 0.5, SeCCA = 0.5, SeCAA = 0.5, SePCR = 0.5,
       SpKK = 0.5, SpCCA = 0.5, SpCAA = 0.5, SpPCR = 0.5, genprev=0.8, diff=0.01),
  list(SeKK = 0.5, SeCCA = 0.5, SeCAA = 0.5, SePCR = 0.5,
       SpKK = 0.9, SpCCA = 0.9, SpCAA = 0.9, SpPCR = 0.9, genprev=0.7, diff=0.2),
  list(SeKK = 0.6, SeCCA = 0.6, SeCAA = 0.6, SePCR = 0.6,
       SpKK = 0.8, SpCCA = 0.8, SpCAA = 0.8, SpPCR = 0.8, genprev=0.9, diff=0.05)
)

# parameters to be monitored
parameters <- c("SeKK", "SeCCA", "SeCAA", "SePCR",
                "SpKK", "SpCCA", "SpCAA", "SpPCR", "genprev", "diff")

# MCMC
samples <- jags(data, inits=myinits, parameters,
                model.file ="../models/LCA_simple_treatment_flatPriors.txt", n.chains=4, n.iter=10000,
                n.burnin=3000, n.thin=1, DIC=F)

# Convergence diagnostics
traceplot(samples) # this should look like a hairy caterpillar
samples$BUGSoutput$summary[,"Rhat"] # Convergence: R-hat value is smaller or equal to 1; if R-hat > 1.05, increase n.burnin or n.thin to decrease R-hat, change starting values to something more reasonable; if none of this works, don't interpret parameter with high R-hat

# Information about posterior distributions
print(samples) # posterior mean, standard deviations, and quantiles

# Plot.
plot.estimates(samples)
