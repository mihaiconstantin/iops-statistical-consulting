source("./scripts/helpers.R")

# Plot parameters estimates from jags.
density.plot <- function(model.output) {
    # On exit stop asking questions.
    on.exit({
        # Ask to show next plot.
        par(ask = FALSE)
    })

    # Extract the relevant data.
    data <- model.output$BUGSoutput$sims.matrix
    
    # Loop over the parameters in the matrix.
    for (col in 1:ncol(data)) {
        # If a plot has been shown, start asking before displaying the next one.
        if(col == 2) {
            par(ask = TRUE)
        }
        
        # Get data ready for ggplot2.
        estimates <- data.frame(
            x = data[, col],
            y = as.factor(rep(1, length(x)))
        )
        
        # Relevant statistics for the plot.
        median.estimate <- median(estimates$x)
        mean.estimate <- mean(estimates$x)
        
        # Create the density plot.
        density.plot <- ggplot(estimates, aes(x = x)) +
            geom_density(
                alpha = 0.5, 
                fill = "steelblue",
                size = 1.2
            ) +
            geom_vline(
                xintercept = mean.estimate,
                size = 1,
                color = "darkred"
            ) +
            labs(
                x = paste0(colnames(data)[col]),
                y = "Density"
            ) +
            theme_bw()
        
        # Create the boxplot.
        box.plot <- ggplot(estimates, aes(x = x, y = y)) +
            geom_boxplot(width = 0.5) +
            annotate(
                "text", 
                x = median.estimate, 
                y = .7, 
                label = paste0("MED = ", round(median.estimate, 2))
            ) +
            theme_bw() +
            labs(
                x = paste0(colnames(data)[col])
            ) +
            theme(
                axis.title.y = element_blank(),
                axis.text.y = element_blank(),
                axis.ticks.y = element_blank()
            )
        
        # Arrange and show plots.
        grid.arrange(density.plot, box.plot, ncol = 2)
    }
}
