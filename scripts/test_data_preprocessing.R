# Source helper functions.
source("./scripts/helpers/helpers.R")

# Load toy data.
load("./data/data_toy.RData")

# Apply cutoffs.
# trace: Which value should the trace take in the dataset
cutoff.data <- apply.cutoff(data.toy, trace = 1)

# Determine frequencies.
count.patterns(cutoff.data, timepoint = "t1", tests.ordering = c("cca", "kk", "caa", "pcr"))

# TODO: Angelika, can you please check this?
