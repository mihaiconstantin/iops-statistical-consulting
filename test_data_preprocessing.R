# Source helper functions.
source("./scripts/helpers/helpers.R")

# Load toy data.
load("./data/data_toy.RData")

# Apply cutoffs.
cutoff.data <- apply.cutoff(data.toy, trace = 0)

# Determine frequencies.
count.patterns(cutoff.data, timepoint = "t1", tests.ordering = c("kk", "cca", "caa", "pcr"))

# TODO: Angelika, can you please check this?
