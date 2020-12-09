# Priors used in Clemens et al.

x <- seq(0,1,by=0.0001)
par(mfrow=c(2,2), oma=c(0, 0, 2, 0))
plot(x, dbeta(x, 1.43, 1.129), type="l", xlab="Sensitivity", ylab="Prior Plausibility", ylim=c(0,8))
mtext("Kato-Katz", 3, adj=0)
plot(x, dbeta(x, 3.05, 1.51), type="l", xlab="Sensitivity", ylab="Prior Plausibility", ylim=c(0,8))
mtext("Circulating Cathodic Antigen (B)", 3, adj=0)
mtext("Circulating Cathodic Antigen (L)", 3, adj=0, line=1)
mtext("Circulating Anodic Antigen", 3, adj=0, line=2)

plot(x, dbeta(x, 21.2, 2.06), type="l", xlab="Specificity", ylab="Prior Plausibility", ylim=c(0,8))
mtext("Kato-Katz", 3, adj=0)
plot(x, dbeta(x, 5.38, 1.49), type="l", xlab="Specificity", ylab="Prior Plausibility", ylim=c(0,8))
mtext("Circulating Cathodic Antigen (B)", 3, adj=0)
mtext("Circulating Cathodic Antigen (L)", 3, adj=0, line=1)
mtext("Circulating Anodic Antigen", 3, adj=0, line=2)
mtext("Prior Distributions (Clements et al., 2018)", side=3, outer=T, cex=1.5)

# Priors used in this study
dev.off()
x <- seq(0,1,by=0.0001)
par(mfrow=c(2,2))
plot(x, dbeta(x, 1.43, 1.129), type="l", xlab="Sensitivity", ylab="Prior Plausibility", ylim=c(0,8))
mtext("Kato-Katz", 3, adj=0)
plot(x, dbeta(x, 3.05, 1.51), type="l", xlab="Sensitivity", ylab="Prior Plausibility", ylim=c(0,8))
mtext("Circulating Cathodic Antigen", 3, adj=0)
mtext("Circulating Anodic Antigen", 3, adj=0, line=1)
mtext("PCR", 3, adj=0, line=2)

plot(x, dbeta(x, 21.2, 2.06), type="l", xlab="Specificity", ylab="Prior Plausibility", ylim=c(0,8))
mtext("Kato-Katz", 3, adj=0)
mtext("Circulating Anodic Antigen", 3, adj=0, line=1)
mtext("PCR", 3, adj=0, line=2)

plot(x, dbeta(x, 5.38, 1.49), type="l", xlab="Specificity", ylab="Prior Plausibility", ylim=c(0,8))
mtext("Circulating Cathodic Antigen", 3, adj=0)
