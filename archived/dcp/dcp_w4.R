# DCP Lab Week 4

require(purrr)

# e1
quantity <- c(10, 30, 40)
test1 <- function(x) {
    if (x < 20) {
    print("Not enough for today.")
    }
    else if (x < 30) {
        print("Average day~")
    }
    else {
    print("What a day!")
    }
}
output <- quantity %>% map(test)

# e2
category <- list("A", "B", "C", "B", "E")
price <- list(1080, 720, 540, 2160, 9527)
test2 <- function(c, p) {
    if (c == "A") {
        cat("item in category A\n", "VAT rate of 8% applied\n")
    }
    else if (c == "B") {
        cat("item in category B\n", "VAT rate of 10% applied\n")
    }
    else if (c == "C") {
        cat("item in category C\n", "VAT rate of 20% applied\n")
    }
    else {
        cat("category", c, "undifined!\n")
    }
}
args <- list(category, price)
output <- args %>% pmap(test2)
    
# e3
data_tab <- read.table("dcp/tab.txt", header = TRUE, row.names = 1, sep = "\t")
is.data.frame(data_tab)
dim(data_tab)
names(data_tab)
row.names(data_tab)

# e4
path <- paste(getwd(), "/dcp", sep = "")
write.table(x = print("This is the first line\nThis is the second line\nThis is the third line"),
    file = paste(path, "/my_text.txt", sep = ""),
    row.names = FALSE, col.names = FALSE, quote = FALSE)
my_text <- readLines("dcp/my_text.txt")

# e5
employees <- read.csv("dcp/employee_sales.csv", TRUE, sep = ",")
View(employees)
str(employees)

# e6
max_salary <- max(employees$YearlyIncome)
min_sales <- min(employees$Sales)
median_sales <- median(employees$Sales)
mean_sales <- mean(employees$Sales)
bach_edu <- subset(employees, Education == "Bachelors")
bach_edu_income <- subset(employees, Education == "Bachelors" & YearlyIncome > 70000)
names_max_sales <- employees[which.max(employees$Sales), c("FirstName", "LastName")]
names_min_sales <- employees[which.min(employees$Sales), c("FirstName", "LastName")]
