require(tidyverse)
require(lubridate)
require(ggplot2)
require(jsonlite)

# Dataset exploratory summary
data <- read_csv("arvr/arvr_asm2/data/ACT_Road_Crash_Data.csv")
names(data)
unique(data$CRASH_SEVERITY)
unique(data$LIGHTING_CONDITION)
unique(data$ROAD_CONDITION)
unique(data$WEATHER_CONDITION)

data_by_year <- data %>%
    mutate(CRASH_DATE = dmy(CRASH_DATE)) %>%
    group_by(year(CRASH_DATE), CRASH_SEVERITY) %>%
    summarise(COUNT = n()) %>%
    rename(YEAR = "year(CRASH_DATE)")

data_by_year %>%
    ggplot(aes(x = YEAR, y = COUNT, fill = CRASH_SEVERITY)) +
        geom_bar(stat = "identity", position = "dodge", width = 0.3) +
        geom_text(aes(label = COUNT), vjust = -0.5) +
        ggtitle("Crash by Year") +
        # scale_fill_distiller(palette = "Reds", direction = 1) +
        theme_gray()

data_by_suburb <- data %>%
    filter(CRASH_SEVERITY != "Property Damage Only") %>%
    group_by(SUBURB_LOCATION, CRASH_SEVERITY) %>%
    summarise(COUNT = n())

data_by_suburb %>%
    ggplot(aes(x = SUBURB_LOCATION, y = COUNT, fill = COUNT)) +
        geom_bar(stat = "identity", width = 0.3) +
        geom_text(aes(label = COUNT), vjust = -0.5) +
        ggtitle("Crash by Suburb") +
        scale_fill_distiller(palette = "Reds", direction = 1) +
        theme_gray()

# Analysis by suburb
# Bruce
data_bruce <- filter(data, SUBURB_LOCATION == "BRUCE")

data_bruce_by_lighting <- data %>%
    # filter(CRASH_SEVERITY != "Property Damage Only") %>%
    group_by(LIGHTING_CONDITION, CRASH_SEVERITY) %>%
    summarise(COUNT = n())

data_bruce_by_lighting %>%
    ggplot(aes(x = LIGHTING_CONDITION, y = COUNT, fill = CRASH_SEVERITY)) +
        geom_bar(stat = "identity", position = "dodge") +
        geom_text(aes(label = COUNT), vjust = -0.5) +
        ggtitle("Crash by Lighting Condition (Bruce)") +
        # scale_fill_distiller(palette = "Reds", direction = 1) +
        theme_gray()

# Dickson
data_dickson <- filter(data, SUBURB_LOCATION == "DICKSON")

data_dickson_by_road <- data %>%
    # filter(CRASH_SEVERITY != "Property Damage Only") %>%
    group_by(ROAD_CONDITION, CRASH_SEVERITY) %>%
    summarise(COUNT = n())

data_dickson_by_road %>%
    ggplot(aes(x = ROAD_CONDITION, y = COUNT, fill = CRASH_SEVERITY)) +
        geom_bar(stat = "identity", position = "dodge") +
        geom_text(aes(label = COUNT), vjust = -0.5) +
        ggtitle("Crash by Road Condition (Dickson)") +
        # scale_fill_distiller(palette = "Reds", direction = 1) +
        theme_gray()

# Gungahlin
data_gungahlin <- filter(data, SUBURB_LOCATION == "GUNGAHLIN")

data_gungahlin_by_weather <- data %>%
    # filter(CRASH_SEVERITY != "Property Damage Only") %>%
    group_by(WEATHER_CONDITION, CRASH_SEVERITY) %>%
    summarise(COUNT = n())

data_gungahlin_by_weather %>%
    ggplot(aes(x = WEATHER_CONDITION, y = COUNT, fill = CRASH_SEVERITY)) +
        geom_bar(stat = "identity", position = "dodge") +
        geom_text(aes(label = COUNT), vjust = -0.5) +
        ggtitle("Crash by Weather Condition (Gungahlin)") +
        # scale_fill_distiller(palette = "Reds", direction = 1) +
        theme_gray()

# Convert to JSON
data_by_year_json <- data_by_year %>%
    rename(c(x = YEAR, y = COUNT, z = CRASH_SEVERITY)) %>%
    mutate(
        x = 3 * (x - 2010),
        y = 3 * log(y),
        z = 3 * unclass(factor(z)),
        color = "#CC0000",
        size = 1,
        label = y,
    ) %>%
    toJSON(dataframe = "rows") %>%
    prettify(indent = 4)
glimpse(data_by_year)
write(data_by_year_json,
    "arvr/arvr_asm2/data/data_by_year.json")

data_by_suburb_json <- data_by_suburb %>%
    rename(c(x = SUBURB_LOCATION, y = COUNT, z = CRASH_SEVERITY)) %>%
    mutate(
        x = unclass(factor(x)),
        z = unclass(factor(z)),
        color = "#CC0000",
        size = 1,
        label = y,
    ) %>%
    toJSON(dataframe = "rows") %>%
    prettify(indent = 4)
glimpse(data_by_suburb)
write(data_by_suburb_json,
    "arvr/arvr_asm2/data/data_by_suburb.json")

data_bruce_by_lighting_json <- data_bruce_by_lighting %>%
    rename(c(x = LIGHTING_CONDITION, y = COUNT, z = CRASH_SEVERITY)) %>%
    mutate(
        x = unclass(factor(x)),
        y = log(y),
        z = unclass(factor(z)),
        color = "#CC0000",
        size = 1,
        label = y,
    ) %>%
    toJSON(dataframe = "rows") %>%
    prettify(indent = 4)
glimpse(data_bruce_by_lighting)
write(data_bruce_by_lighting_json,
    "arvr/arvr_asm2/data/data_bruce_by_lighting.json")

data_dickson_by_road_json <- data_dickson_by_road %>%
    rename(c(x = ROAD_CONDITION, y = COUNT, z = CRASH_SEVERITY)) %>%
    mutate(
        x = unclass(factor(x)),
        y = log(y),
        z = unclass(factor(z)),
        color = "#CC0000",
        size = 1,
        label = y,
    ) %>%
    toJSON(dataframe = "rows") %>%
    prettify(indent = 4)
glimpse(data_dickson_by_road)
write(data_dickson_by_road_json,
    "arvr/arvr_asm2/data/data_dickson_by_road.json")

data_gungahlin_by_weather_json <- data_gungahlin_by_weather %>%
    rename(c(x = WEATHER_CONDITION, y = COUNT, z = CRASH_SEVERITY)) %>%
    mutate(
        x = unclass(factor(x)),
        y = log(y),
        z = unclass(factor(z)),
        color = "#CC0000",
        size = 1,
        label = y,
    ) %>%
    toJSON(dataframe = "rows") %>%
    prettify(indent = 4)
glimpse(data_gungahlin_by_weather)
write(data_gungahlin_by_weather_json,
    "arvr/arvr_asm2/data/data_gungahlin_by_weather.json")