
# Cutoff KK.
cutoff.kk <- function(value) {
    if(is.na(value)) return(NA)

    if(value >= 1) {
        return(1)
    }
    else {
        return(0)
    }
}

# Cutoff CCA.
cutoff.cca <- function(value, trace) {
    if(is.na(value)) return(NA)

    if(value >= 4) {
        return(1)
    } else if(value == 2 || value == 3) {
        return(trace)
    } else {
        return(0)
    }
}

# Cutoff CAA.
cutoff.caa <- function(value) {
    if(is.na(value)) return(NA)

    if(value >= 0.6) {
        return(1)
    } else {
        return(0)
    }
}

# Cutoff PCR.
cutoff.pcr <- function(value) {
    if(is.na(value)) return(NA)

    if(value < 50) {
        return(1)
    } else {
        return(0)
    }
}

# Apply the cutoffs to the raw data.
apply.cutoff <- function(raw.data, trace = 1) {
    # Which columns are not test measurements?
    meta.columns <- which(!grepl(paste(..TESTS.., collapse = "|"), colnames(raw.data)))

    # Create new data frame to store cutoff scores.
    data <- as.data.frame(matrix(NA, nrow = nrow(raw.data), ncol = ncol(raw.data)))

    # Copy the non-test columns.
    data[, meta.columns] <- raw.data[, meta.columns]

    # Apply the cutoff for each test type in turn.
    for (test in ..TESTS..) {
        # Identify all columns that belong to a certain test.
        cols <- which(grepl(test, colnames(raw.data)))

        # Apply the cutoff and inject the result.
        for (c in cols) {
            if("trace" %in% formalArgs(..CUTOFFS..[[test]])) {
                data[, c] <- sapply(raw.data[, c], ..CUTOFFS..[[test]], trace = trace)
            } else {
                data[, c] <- sapply(raw.data[, c], ..CUTOFFS..[[test]])
            }
        }
    }

    # Update the column names.
    colnames(data) <- colnames(raw.data)

    return(data)
}

# Generate all possible patterns with a default test ordering.
get.possible.patterns <- function() {
    # Generate patterns.
    patterns <- expand.grid(..CUTOFF.VALUES..)

    # Sort patterns.
    patterns <- patterns[with(patterns, order(kk, cca, caa, pcr, decreasing = TRUE)), ]

    # Remove names.
    rownames(patterns) <- NULL

    return(patterns)
}

# Count ocurring patterns.
count.patterns <- function(cutoff.data, timepoint = "t1", tests.ordering = c("kk", "cca", "caa", "pcr")) {
    # Generate patterns.
    patterns <- get.possible.patterns()

    # Create factors.
    cutoff.data$group <- as.factor(cutoff.data$group)

    # Add a frequency column for current group and time point.
    for (g in levels(cutoff.data$group)) {
        # Indicate where to store the frequencies.
        col <- paste0("g", g, "_", timepoint)

        # Prepare pattern matrix for storing the frequencies.
        patterns[, col] <- 0

        # Get the data for the current group for the current time point.
        data <- cutoff.data[with(cutoff.data, group == g), ][, grepl(paste0("id|", timepoint), colnames(cutoff.data))]

        # Remove time point from columns.
        colnames(data) <- sub(paste0("_", timepoint), "", colnames(data))

        # Order tests the same way as the default ordering of the matrix of patterns.
        data <- data[, c("id", "kk", "cca", "caa", "pcr")]

        # Count patterns.
        frequencies <- aggregate(id ~ ., data, length)

        # Update the pattern matrix accordingly.
        for (f in 1:nrow(frequencies)) {
            for (p in 1:nrow(patterns)) {
                if(all(patterns[p, 1:length(..TESTS..)] == frequencies[f, 1:length(..TESTS..)])) {
                    patterns[p, col] <- frequencies[f, "id"]
                }
            }
        }
    }

    # Add total frequencies per time point.
    patterns[, timepoint] <- apply(patterns[, (ncol(patterns) - length(levels(cutoff.data$group)) + 1):ncol(patterns)], 1, sum)

    # Apply specified ordering.
    patterns <- patterns[, c(tests.ordering, colnames(patterns)[!colnames(patterns) %in% ..TESTS..])]

    # Order based on the provided ordering.
    patterns <- patterns[order(patterns[, tests.ordering[1]], patterns[, tests.ordering[2]], patterns[, tests.ordering[3]], patterns[, tests.ordering[4]], decreasing = TRUE), ]

    return(patterns)
}
