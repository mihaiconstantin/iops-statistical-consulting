
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
}


# Create matrix for storing the outcomes.
outcomes <- matrix(NA, dim(data)[1], length(test.suite), dimnames = list(NULL, names(test.suite)))

# Determine outcomes for all respondents.
for (i in 1:dim(data)[1]) {
    outcomes[i, ] <- determine.cutoff(data[i, ])
}

# Add id.
outcomes <- cbind(id = data$repst.id, outcomes)

# Aggregate.
aggregate(id ~ ., outcomes, length)

# List with all combinations
