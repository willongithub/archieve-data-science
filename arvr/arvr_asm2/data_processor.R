require(tidyverse)

data <- read_csv("arvr/arvr_asm2/data/ACT_Road_Crash_Data.csv")

data_bruce <- filter(data, SUBURB_LOCATION == "BRUCE")
data_dickson <- filter(data, SUBURB_LOCATION == "DICKSON")
data_gungahlin <- filter(data, SUBURB_LOCATION == "GUNGAHLIN")

names(data_bruce)
unique(data_bruce$CRASH_DATE)
