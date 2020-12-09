# Set working directory.
# setwd(...)

# Load the data.
data <- read.csv("data.csv", fileEncoding="UTF-8-BOM")

# Normalize column names.
colnames(data) <- trimws(tolower(colnames(data)))

# Register cut-offs.
kk <- function(value) {
    if(is.na(value)) return(NA)
    
    if(value >= 1) {
        return(1)
    }
    else {
        return(0)
    }
}

poc.cca <- function(value) {
    if(is.na(value)) return(NA)
    
    if(value >= 4) {
        return(1)
    } else if(value == 2 || value == 3) { 
        return(1)
    } else {
        return(0)
    }
}
    
caa <- function(value) {
    if(is.na(value)) return(NA)
    
    if(value >= 0.6) {
        return(1)
    } else {
        return(0)
    }
}

pcr <- function(value) {
    if(is.na(value)) return(NA)
    
    if(value < 50) { 
        return(1)
    } else {
        return(0)
    }
}

# Match tests to cut-off strategy.
test.suite <- list(
    kk = kk,
    poc.cca = poc.cca,
    caa = caa,
    pcr = pcr
)

# Determine cutoffs for a single time point for a single respondent.
determine.cutoff <- function(measurement, tests = test.suite) {
    # Create storage for outcomes.
    outcomes <- rep(NA, 4)
    
    # Add names.
    names(outcomes) <- names(tests)
    
    for (column in colnames(measurement)) {
        if(column %in% names(tests)) {
            outcomes[column] <- tests[[column]](measurement[column])
        }
    }
    
    return(outcomes)
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
