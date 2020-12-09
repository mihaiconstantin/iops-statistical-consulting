# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                     IOPS Statistical Consulting                         #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                         #
# File contributors:                                                      #
#   - A. Stefan                                                           #
#   - M. A. Constantin                                                    #
#                                                                         #
# File description:                                                       #
#   - this file contains silly helper functions and constants             #
#                                                                         #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Clear everything.
rm(list = ls())

# Loader ------------------------------------------------------------------

# User feedback.
cat("Loading...", "\n")

# # # Load the libraries
library(ggplot2)
library(gridExtra)
library(R2jags)

source(paste0(getwd(), "/scripts/helpers/", "plotting.R"))
# source(paste0(getwd(), "/scripts/helpers/", "preprocessing.R"))

# User feedback.
cat("Loaded successfully.", "\n")

# # # End of file.