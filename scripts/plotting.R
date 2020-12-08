load("samples.RData")


data <- as.data.frame(samples$BUGSoutput$sims.matrix[, 1:8])

library(ggplot2)
library(reshape2)
library(RColorBrewer)



data <- melt(data)
data$group = NA
data$group[1:(4999 * 4)] <- "Sensitivity"
data$group[(4999 * 4 + 1):length(data$group)] <- "Specificity"


View(data)


ggplot(data, aes(x = value, fill = variable)) + 
    geom_density(alpha = 0.5) +
    facet_wrap(~ group, ncol = 1) +
    scale_fill_brewer(palette = "BuPu") +
    labs(
        x = NULL,
        y = "Density"
    ) +
    guides(fill = guide_legend(title = "Test")) +
    theme_bw() 



ggplot(data, aes(x = value, fill = variable)) + 
    geom_boxplot(alpha = 0.5) +
    facet_wrap(~ group) +
    scale_fill_brewer(palette = "BuPu") +
    labs(
        x = NULL,
        y = "Density"
    ) +
    guides(fill = guide_legend(title = "Test")) +
    theme_bw()


ggsave(filename = "density.svg", device = "svg", scale = .5)
ggsave(filename = "boxplot.svg", device = "svg", scale = .5)
