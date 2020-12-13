# Source helper functions.
source("./scripts/helpers/helpers.R")

# Load toy data.
data.toy <- read.csv("./data/data_toy.csv")

# Apply cutoffs.
# trace means -> Which value should the trace take in the data set?
cutoff.data <- apply.cutoff(data.toy, trace = 1)

# Print.
print(cutoff.data)

# Determine frequencies.
count.patterns(cutoff.data, timepoint = "t1", tests.ordering = c("cca", "kk", "caa", "pcr"))
