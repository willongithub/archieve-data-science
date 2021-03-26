### DCP Assignment 1

## Part 2. Data Preparation and Analysis
# 1

# placeholder for the path. remove in the final version
folder <- c("dcp/data/")

# For the loops. There are 12 csv files for the 3 tests
# which consist of 4 activities each.
num_of_file <- 12

for (i in seq(num_of_file)) {

    # Loop through all the files by name,
    # so calculate the No. of tests and No. of activities
    # based on No. of loops. (e.g., df_test{test_num}_act{act_num}.csv)
    test_num <- (i - 1) %/% 4 + 1
    act_num <- (i - 1) %% 4 + 1

    # Load csv files using catenated filenames in turn.
    data <- read.csv(paste(folder,
                           "test",
                           as.character(test_num),
                           "_activity",
                           as.character(act_num),
                           ".csv",
                           sep = ""),
                           header = FALSE)

    # Truncate columns of outliers.
    data <- data[1:8]

    # Put loaded dataframes into workspace with corresponding names.
    assign(paste("df_test",
                as.character(test_num),
                "_act",
                as.character(act_num),
                sep = ""), data)
}

# 2
for (i in seq(num_of_file)) {
    test_num <- (i - 1) %/% 4 + 1
    act_num <- (i - 1) %% 4 + 1

    # Load the 12 dataframes in turn, and find the rows with markers
    data <- which(get(paste("df_test",
                            as.character(test_num),
                            "_act",
                            as.character(act_num),
                            sep = "")) == "Sample")

    # Take the second and third marker which determine the actual data.
    data <- data[2:3]

    # Put the marker vecters into workspace with corresponding names.
    assign(paste("marker_test",
                 as.character(test_num),
                 "_act",
                 as.character(act_num),
                 sep = ""), data)
}

# 3
for (i in seq(num_of_file)) {
    test_num <- (i - 1) %/% 4 + 1
    act_num <- (i - 1) %% 4 + 1

    # Load the dataframe for this loop.
    data <- get(paste("df_test",
                      as.character(test_num),
                      "_act",
                      as.character(act_num),
                      sep = ""))

    # Load marker vecters for this loop.
    var_name <- as.character(data[get(paste("marker_test",
                          as.character(test_num),
                          "_act",
                          as.character(act_num),
                          sep = ""))[1], ])

    # Name the variables of dataframes with corresponding markers.
    names(data) <- var_name

    # Put the dataframes with names back to workspace.
    assign(paste("df_test",
                 as.character(test_num),
                 "_act",
                 as.character(act_num),
                 sep = ""), data)
}

# 4
for (i in seq(num_of_file)) {
    test_num <- (i - 1) %/% 4 + 1
    act_num <- (i - 1) %% 4 + 1
    data <- get(paste("df_test",
                    as.character(test_num),
                    "_act",
                    as.character(act_num),
                    sep = ""))

    # Take the columns of number of samples and gyroscope's data.
    data <- data[c(1, 6:8)]

    assign(paste("df_test",
                as.character(test_num),
                "_act",
                as.character(act_num),
                sep = ""), data)
}

# 5
for (i in seq(num_of_file)) {
    test_num <- (i - 1) %/% 4 + 1
    act_num <- (i - 1) %% 4 + 1
    data <- get(paste("df_test",
                    as.character(test_num),
                    "_act",
                    as.character(act_num),
                    sep = ""))

    # Load marker vecter for this loop
    range <- get(paste("marker_test",
                    as.character(test_num),
                    "_act",
                    as.character(act_num),
                    sep = ""))

    # Take the rows between two markers.
    data <- data[(range[1] + 1):(range[2] - 1), ]

    # Put new data into separate dataframes
    assign(paste("obj_test",
                as.character(test_num),
                "_act",
                as.character(act_num),
                sep = ""), data)
}

# 6
# List all items in the workspace and remove
# them except for the dataframes from Step 5.
remove(list = (ls()[!startsWith(ls(), "obj")]))

# 7
num_of_file <- 12
for (i in seq(num_of_file)) {
    test_num <- (i - 1) %/% 4 + 1
    act_num <- (i - 1) %% 4 + 1
    data <- get(paste("obj_test",
                    as.character(test_num),
                    "_act",
                    as.character(act_num),
                    sep = ""))

    # Remove NAs from each dataframe
    data <- na.omit(data)

    assign(paste("obj_test",
                as.character(test_num),
                "_act",
                as.character(act_num),
                sep = ""), data)
}

# 8
for (i in seq(num_of_file)) {
    test_num <- (i - 1) %/% 4 + 1
    act_num <- (i - 1) %% 4 + 1
    data <- get(paste("obj_test",
                    as.character(test_num),
                    "_act",
                    as.character(act_num),
                    sep = ""))

    # Transfer all data points into numeric type
    data <- as.data.frame(apply(data, c(1, 2), function(x) as.numeric(x)))
    data <- na.omit(data)

    assign(paste("obj_test",
                as.character(test_num),
                "_act",
                as.character(act_num),
                sep = ""), data)
}

# 9
for (i in seq(num_of_file)) {
    test_num <- (i - 1) %/% 4 + 1
    act_num <- (i - 1) %% 4 + 1
    data <- get(paste("obj_test",
                    as.character(test_num),
                    "_act",
                    as.character(act_num),
                    sep = ""))

    # Get marker for the first 10 seconds of data
    rest_marker <- as.integer(dim(data)[1] / 50 * 10)

    # Compute the mean for each column in rest period and
    # subtract the mean value for each column
    data[, 2:4] <- data[, 2:4] - colMeans(data[1:rest_marker, 2:4], na.rm = F)

    assign(paste("obj_test",
                as.character(test_num),
                "_act",
                as.character(act_num),
                sep = ""), data)
}

# 10
for (i in seq(num_of_file)) {
    test_num <- (i - 1) %/% 4 + 1
    act_num <- (i - 1) %% 4 + 1
    data <- get(paste("obj_test",
                    as.character(test_num),
                    "_act",
                    as.character(act_num),
                    sep = ""))

    # Catenate 4 activities into one and keep note of markers
    # for labels and seperation lines
    if (act_num == 1) {
        dataset <- data

        # Line markers are in the middle between two labels
        marker_line <- dim(data)[1] / 2

        # Label markers are in between two activities
        marker_label <- dim(data)[1]
        pointer <- dim(data)[1]
    }
    else {
        dataset <- rbind(dataset, data)
        marker_label <- c(marker_label, pointer + dim(data)[1])
        marker_line <- c(marker_line, pointer + dim(data)[1] / 2)
        pointer <- pointer + dim(data)[1]
    }

    # Plot data for each test(subject).
    if (act_num == 4) {
        plot(seq(dim(dataset)[1]), dataset[, 2], type = "l", col = "red",
            main = paste("Test ", as.character(test_num), "- All activities"),
            xlab = "Sample",
            ylab = "Rotational velocity (deg/sec)",
            xlim = c(0, 3200),
            ylim = c(-40000, 40000))
        lines(seq(dim(dataset)[1]), dataset[, 3], col = "yellow")
        lines(seq(dim(dataset)[1]), dataset[, 4], col = "blue")
        legend("topleft",
                legend = c("gX", "gY", "gZ"),
                col = c("red", "yellow", "blue"),
                lty = 1)
        abline(v = marker_label[1:3], lty = 2)
        text(x = marker_line,
             y = -40000,
             c("Activity-1",
               "Activity-2",
               "Activity-3",
               "Activity-4"))
        dataset <- NULL
    }
}

# 11
for (i in seq(num_of_file)) {
    test_num <- (i - 1) %/% 4 + 1
    act_num <- (i - 1) %% 4 + 1
    data <- get(paste("obj_test",
                    as.character(test_num),
                    "_act",
                    as.character(act_num),
                    sep = ""))

    # Get marker between two 10 second rest periods
    marker_act <- c(as.integer(dim(data)[1] / 50 * 10),
                    as.integer(dim(data)[1] / 50 * 40))

    # Get data of the actual activites
    data <- data[(marker_act[1]):(marker_act[2]), ]

    assign(paste("obj_test",
                as.character(test_num),
                "_act",
                as.character(act_num),
                sep = ""), data)
}

# 12
# Initialize list for the 3 tests
obj_list <- vector(mode = "list", length = 3)

for (i in seq(num_of_file)) {
    test_num <- (i - 1) %/% 4 + 1
    act_num <- (i - 1) %% 4 + 1
    data <- get(paste("obj_test",
                      as.character(test_num),
                      "_act",
                      as.character(act_num),
                      sep = ""))

    # Get window size of 5 second in terms of number
    # of data points
    window <- as.integer(dim(data)[1] / 30 * 5)

    # Initialize list for the 4 activities
    if (act_num == 1) {
        act_list <- vector(mode = "list", length = 4)
    }

    # Initialize list for the 6 windows
    window_list <- vector(mode = "list", length = 6)

    # Divide data points into the windows as matrix
    for (step in seq(from = 1, to = dim(data)[1] - window, by = window)) {
        wd_mtx <- matrix(, nrow = window, ncol = 3)
        wd_mtx[, 1:3] <- as.matrix(data[step:(step + window - 1), 2:4])
        window_list[[as.integer((step + window - 1) / window)]] <- wd_mtx
    }
    act_list[[act_num]] <- window_list
    if (act_num == 4) {
        obj_list[[test_num]] <- act_list
    }
}

# 13
# For the loops. There are 3 tests, 4 activities in each test,
# 6 windows in each activity.
num_test <- 3
num_act <- 4
num_wd <- 6

# Initialize the data structure for means and standard deviations.
stat_df <- data.frame(matrix(, nrow = 3 * num_wd * num_test * num_act,
                               ncol = 5))

# Set label to identify each means and standard deviations
names(stat_df) <- c("mean", "sd", "axis", "activity", "test")
stat_df$axis <- rep(c("x", "y", "z"), 3 * 4 * 6)
stat_df$activity <- rep(c(1, 2, 3, 4), each = 6 * 3 * 3)
stat_df$test <- rep(c(1, 2, 3), each = 3)

# Initialize function for calculating index where each statistic should be.
index_range <- function(outer, middle, inner) {
    from <- ((outer - 1) * 18 + (middle - 1) * 54 + inner * 3 - 2)
    to <- ((outer - 1) * 18 + (middle - 1) * 54 + inner * 3)
    return(from:to)
}

# Calculate and store the statistics in the dataframe.
for (i in seq(num_test)) {
    for (j in seq(num_act)) {
        for (k in seq(num_wd)) {
            stat_df$mean[index_range(i, j, k)] <-
                colMeans(obj_list[[i]][[j]][[k]][, 1:3])
            stat_df$sd[index_range(i, j, k)] <-
                apply(obj_list[[i]][[j]][[k]][, 1:3], 2, sd)
        }
    }
}

# 14
# Initialize function for the boxplot with costomised requirements
plot_box <- function(data, flag) {
    colnames(data)[colnames(data) == flag] <- "value"
    if (flag == "mean") {
        flag <- "Mean"
    }
    else if (flag == "sd") {
        flag <- "Standard Deviation"
    }
    else {
        warning("argument 2 not recognized")
    }
    boxplot(value ~ axis + activity, data,
        main = paste("Distribution of", flag, "Values"),
        xlab = paste(flag, " Values"),
        ylab = "Rotational velocity",
        names = c("", "Act1", "", "", "Act2", "",
                  "", "Act3", "", "", "Act4", ""),
        col = c("red", "yellow", "blue"),
        at = c(1:3, 5:7, 9:11, 13:15))
    legend("topleft",
            legend = c("X", "Y", "Z"),
            fill = c("red", "yellow", "blue"),
            border = "black")
    abline(v = c(4, 8, 12), lty = 2)
}

# Plot for means and standard deviations
plot_box(stat_df, "mean")
plot_box(stat_df, "sd")
