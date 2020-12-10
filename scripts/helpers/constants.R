# Constants ---------------------------------------------------------------

# How many tests there are?
..TESTS.. = c("kk", "cca", "caa", "pcr")

# How many time points?
..TIMEPOINTS.. = c("t1", "t2")

# What are the cutoffs?
..CUTOFFS.. = list(
    kk = cutoff.kk,
    cca = cutoff.cca,
    caa = cutoff.caa,
    pcr = cutoff.pcr
)

# What are the cutoff values?
..CUTOFF.VALUES.. = list(
    kk = 1:0,
    cca = 1:0,
    caa = 1:0,
    pcr = 1:0
)

# Expected naming convetion.
..VARS.. <- c(
    "id", "group",
    "kk_t1", "cca_t1", "caa_t1", "pcr_t1",
    "kk_t2", "cca_t2", "caa_t2", "pcr_t2",
    "kk_t3", "cca_t3", "caa_t3", "pcr_t3",
    "kk_t4", "cca_t4", "caa_t4", "pcr_t4"
)
