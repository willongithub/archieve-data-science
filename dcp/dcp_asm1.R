### DCP Assignment 1

## Part 2. Data Preparation and Analysis
# 1

# placeholder for the path. remove in the final version
folder <- c("dcp/data/")

# 1-layer for loop method, we will determine which one later
num_of_file <- 12
for (i in seq(num_of_file)) {
    test_num <- (i - 1) %/% 4 + 1
    act_num <- (i - 1) %% 4 + 1
    data <- read.csv(paste(folder,
                            "test",
                            as.character(test_num),
                            "_activity",
                            as.character(act_num),
                            ".csv",
                            sep = ""),
                            header = FALSE)
    data <- data[1:8]
    assign(paste("df_test",
                as.character(test_num),
                "_act",
                as.character(act_num),
                sep = ""), data)
}
# 2-layer for loop method
num_of_test <- 3
num_of_act <- 4
for (i in seq(num_of_test)) {
    for (j in seq(num_of_act)) {
        data <- read.csv(paste(folder,
                            "test",
                            as.character(i),
                            "_activity",
                            as.character(j),
                            ".csv",
                            sep = ""),
                            header = FALSE)
        data <- data[1:8]
        assign(paste("df_test",
                    as.character(i),
                    "_act",
                    as.character(j),
                    sep = ""), data)
    }
}

# 2
for (i in seq(num_of_file)) {
    test_num <- (i - 1) %/% 4 + 1
    act_num <- (i - 1) %% 4 + 1
    data <- which(get(paste("df_test",
                    as.character(test_num),
                    "_act",
                    as.character(act_num),
                    sep = "")) == "Sample"
    )
    data <- data[2:3]
    assign(paste("marker_test",
                    as.character(test_num),
                    "_act",
                    as.character(act_num),
                    sep = ""), data)
}

# 3
# assign column name to the dataframe
var_name <- as.character(df_test1_act1[marker_test1_act1[1], ])
for (i in seq(num_of_file)) {
    test_num <- (i - 1) %/% 4 + 1
    act_num <- (i - 1) %% 4 + 1
    data <- get(paste("df_test",
                    as.character(test_num),
                    "_act",
                    as.character(act_num),
                    sep = ""))
    names(data) <- var_name
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
    range <- get(paste("marker_test",
                    as.character(test_num),
                    "_act",
                    as.character(act_num),
                    sep = ""))
    data <- data[(range[1] + 1):(range[2] - 1), ]
    assign(paste("obj_test",
                as.character(test_num),
                "_act",
                as.character(act_num),
                sep = ""), data)
}

# 6
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
    data <- as.data.frame(sapply(data, function(x) as.numeric(x)))
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
    rest_marker <- as.integer(dim(data)[1] / 50 * 10)
    data[, 2] <- data[, 2] - mean(data[1:rest_marker, 2])
    data[, 3] <- data[, 3] - mean(data[1:rest_marker, 3])
    data[, 4] <- data[, 4] - mean(data[1:rest_marker, 4])
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
    if (act_num == 1) {
        dataset <- data
    }
    else {
        dataset <- rbind(dataset, data)
    }
    if (act_num == 4) {
        windows()
        plot(seq(dim(dataset)[1]), dataset[, 2], type = "l", col = "red",
            main = paste("Test ", as.character(test_num)),
            xlab = "Sample",
            ylab = "Rotational velocity (deg/sec)")
        lines(seq(dim(dataset)[1]), dataset[, 3], col = "yellow")
        lines(seq(dim(dataset)[1]), dataset[, 4], col = "blue")
        legend("topleft",
                legend = c("gX", "gY", "gZ"),
                col = c("red", "yellow", "blue"),
                lty = 1)
        text(x = c(500, 1400, 2000, 2600),
             y = -22000,
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
    act_marker <- c(as.integer(dim(data)[1] / 50 * 10),
                    as.integer(dim(data)[1] / 50 * 40))
    data <- data[(act_marker[1]):(act_marker[2]), ]
    assign(paste("obj_test",
                as.character(test_num),
                "_act",
                as.character(act_num),
                sep = ""), data)
}

# 12
test_list <- vector(mode = "list", length = 3)
for (i in seq(num_of_file)) {
    test_num <- (i - 1) %/% 4 + 1
    act_num <- (i - 1) %% 4 + 1
    data <- get(paste("obj_test",
                    as.character(test_num),
                    "_act",
                    as.character(act_num),
                    sep = ""))
    window <- as.integer(dim(data)[1] / 30 * 5)
    if (act_num == 1) {
        act_list <- vector(mode = "list", length = 4)
    }
    window_list <- vector(mode = "list", length = 6)
    for (step in seq(from = 1, to = dim(data)[1] - window, by = window)) {
        wd_mtx <- matrix(, nrow = window, ncol = 3)
        wd_mtx[, 1] <- data[step:(step + window - 1), 2]
        wd_mtx[, 2] <- data[step:(step + window - 1), 3]
        wd_mtx[, 3] <- data[step:(step + window - 1), 4]
        window_list[[as.integer((step + window - 1) / window)]] <- wd_mtx
    }
    act_list[[act_num]] <- window_list
    if (act_num == 4) {
        test_list[[test_num]] <- act_list
    }
}

# 13
num_test <- 3
num_act <- 4
num_wd <- 6
sim_sta_mtx <- matrix(, nrow = 2, ncol = 3)
stat_list <- test_list
for (i in seq(num_test)) {
    for (j in seq(num_act)) {
        for (k in seq(num_wd)) {
            sim_sta_mtx[1, 1] <- mean(test_list[[i]][[j]][[k]][, 1],
                                        na.rm = TRUE)
            sim_sta_mtx[1, 2] <- mean(test_list[[i]][[j]][[k]][, 2],
                                        na.rm = TRUE)
            sim_sta_mtx[1, 3] <- mean(test_list[[i]][[j]][[k]][, 3],
                                        na.rm = TRUE)
            sim_sta_mtx[2, 1] <- sd(test_list[[i]][[j]][[k]][, 1],
                                        na.rm = TRUE)
            sim_sta_mtx[2, 2] <- sd(test_list[[i]][[j]][[k]][, 2],
                                        na.rm = TRUE)
            sim_sta_mtx[2, 3] <- sd(test_list[[i]][[j]][[k]][, 3],
                                        na.rm = TRUE)
            stat_list[[i]][[j]][[k]] <- sim_sta_mtx
        }
    }
}

# 14
stat_df <- data.frame(matrix(, nrow = 6 * 3 * 4, ncol = 2))
names(stat_df) <- c("values", "group")
stat_df$group <- c(rep("x1", 6), rep("y1", 6), rep("z1", 6),
                     rep("x2", 6), rep("y2", 6), rep("z2", 6),
                     rep("x3", 6), rep("y3", 6), rep("z3", 6),
                     rep("x4", 6), rep("y4", 6), rep("z4", 6))

plot_box <- function(data, flag) {
    if (flag == "mean") {
        flag <- "Mean"
    }
    if (flag = "sd") {
        flag <- "Standard Deviation"
    }
    else {
        warning("argument 2 not recognized")
    }
    boxplot(values ~ group, data,
        main = paste("Test 1 - Stats of ", as.character(flag)),
        xlab = paste(as.character(flag), " Values"),
        ylab = "Rotational velocity",
        at = c(1, 2, 3, 6, 7, 8, 9, 10, 11, 13, 14, 15))
    legend("topleft",
                    legend = c("X", "Y", "Z"),
                    col = c("red", "yellow", "blue"),
                    lty = 1)
    text(x = c(2, 7, 10, 14),
            y = -20000,
            c("Activity-1",
              "Activity-2",
              "Activity-3",
              "Activity-4"))
}

for (i in seq(num_test)) {
    for (j in seq(num_act)) {
        for (k in seq(num_wd)) {
            stat_df["values", k] <- stat_list[[i]][[j]][[k]][1, 1]
            stat_df["values", k + 6] <- stat_list[[i]][[j]][[k]][1, 2]
            stat_df["values", k + 12] <- stat_list[[i]][[j]][[k]][1, 3]
        }
    }
    plot_box(stat_df, mean)
}

stat_list[[1]][[1]][[1]][1, 1]
