require(tidyverse)
require(lubridate)
require(ggplot2)
require(jsonlite)

# Dataset exploratory summary
data <- read_csv("arvr/arvr_asm2/data/ACT_Road_Crash_Data.csv")
names(data)

canberra_central <- c(
    "Acton", "Ainslie", "Braddon", "Campbell", "City", "Dickson", "Downer",
    "Hackett", "Lyneham", "O'Connor", "Parkes", "Reid", "Russell", "Turner",
    "Watson", "Barton", "Capital Hill", "Deakin", "Forrest", "Fyshwick",
    "Griffith", "Kingston", "Narrabundah", "Parkes", "Red Hill", "Yarralumla"
)
woden_valley <- c(
    "Chifley", "Curtin", "Garran", "Hughes", "Farrer", "Isaacs", "Lyons",
    "Mawson", "O'Malley", "Pearce", "Phillip", "Torrens"
)
belconnen <- c(
    "Aranda", "Belconnen", "Bruce", "Charnwood", "Cook", "Dunlop", "Evatt",
    "Florey", "Flynn", "Fraser", "Giralang", "Hawker", "Higgins", "Holt",
    "Kaleen", "Latham", "Lawson", "Macgregor", "Macnamara", "Macquarie",
    "McKellar", "Melba", "Page", "Scullin", "Spence", "Strathnairn",
    "Weetangera"
)
weston_creek <- c(
    "Chapman", "Duffy", "Fisher", "Holder", "Rivett", "Stirling", "Waramanga",
    "Weston"
)
tuggeranong <- c(
    "Banks", "Bonython", "Calwell", "Chisholm", "Conder", "Fadden", "Gilmore",
    "Gordon", "Gowrie", "Greenway", "Hume", "Isabella Plains", "Kambah",
    "Macarthur", "Monash", "Oxley", "Richardson", "Theodore", "Wanniassa"
)
gungahlin <- c(
    "Amaroo", "Bonner", "Casey", "Crace", "Forde", "Franklin", "Gungahlin",
    "Harrison", "Jacka", "Mitchell", "Moncrieff", "Ngunnawal", "Nicholls",
    "Palmerston", "Taylor", "Throsby"
)
molonglo_valley <- c(
    "Coombs", "Denman Prospect", "Molonglo", "Whitlam", "Wright"
)

color <- c(
    "#ad0000", "#cc7a00", "#b49900", "#4c6d00", "#00b4cc",
    "#0241b6", "#2000ac", "#5301b1", "#a70190"
)

unique(data$CRASH_SEVERITY)
unique(data$LIGHTING_CONDITION)
unique(data$ROAD_CONDITION)
unique(data$WEATHER_CONDITION)

generate_data_by_year_json <- function(data) {
    data_by_year <- data %>%
        mutate(CRASH_DATE = dmy(CRASH_DATE)) %>%
        group_by(year(CRASH_DATE), CRASH_SEVERITY) %>%
        summarise(COUNT = n()) %>%
        rename(YEAR = "year(CRASH_DATE)")

    data_by_year_json <- data_by_year %>%
        rename(c(x = YEAR, y = COUNT, z = CRASH_SEVERITY)) %>%
        mutate(
            label = paste(y, "cases", z, x),
            x = 3 * (x - 2010),
            y = log(y),
            z = -3 * unclass(factor(z)),
            size = 1,
            color = "#b49900"
        ) %>%
        toJSON(dataframe = "rows") %>%
        prettify(indent = 4)

    # items <- 3 * unclass(factor(unique(data$CRASH_SEVERITY)))

    # for (i in seq_len(length(items))) {
    #     for (c in color) {
    #         data_by_year_json <- data_by_year_json %>%
    #         mutate(color = "a" * (z == items[i]))
    #     }
    # }

    dir <- paste0(
        "arvr/arvr_asm2/data/data_",
        tolower("CRASH_SEVERITY"),
        ".json")

    write(data_by_year_json, dir)
}

generate_data_by_year_json(data)

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

# Fatal JSON datasets
generate_fatal_data_json <- function(data) {
    for (i in 12:21) {
        year <- 2000 + i

        data_fatal <- data %>%
            mutate(CRASH_DATE = dmy(CRASH_DATE)) %>%
            filter(year(CRASH_DATE) == year,
                CRASH_SEVERITY == "Fatal") %>%
            select(LONGITUDE, LATITUDE, SUBURB_LOCATION, CRASH_TIME) %>%
            mutate(
                LONGITUDE = longitude_conversion(LONGITUDE),
                LATITUDE = latitude_conversion(LATITUDE)
            )

        data_fatal_json <- data_fatal %>%
            rename(c(x = LONGITUDE, z = LATITUDE)) %>%
            mutate(
                y = 30,
                size = 1,
                color = "#2000ac",
                label = paste(SUBURB_LOCATION, CRASH_TIME)
            ) %>%
            toJSON(dataframe = "rows") %>%
            prettify(indent = 4)

        dir <- paste0("arvr/arvr_asm2/data/data_fatal_", year, ".json")
        write(data_fatal_json, dir)
    }
}

generate_fatal_data_json(data)

data_fatal <- data %>%
    mutate(CRASH_DATE = dmy(CRASH_DATE)) %>%
    filter(CRASH_SEVERITY != "Property Damage Only") %>%
    select(LONGITUDE, LATITUDE, SUBURB_LOCATION, CRASH_DATE, CRASH_TIME) %>%
    mutate(
        LONGITUDE = longitude_conversion(LONGITUDE),
        LATITUDE = latitude_conversion(LATITUDE),
        YEAR = year(CRASH_DATE)
    )

data_fatal_json <- data_fatal %>%
    rename(c(x = LONGITUDE, z = LATITUDE)) %>%
    mutate(
        y = 30,
        size = 1,
        color = "#ad0000",
        label = paste(SUBURB_LOCATION, CRASH_TIME, YEAR)
    ) %>%
    toJSON(dataframe = "rows") %>%
    prettify(indent = 4)

dir <- paste0("arvr/arvr_asm2/data/data_fatal_all.json")
write(data_fatal_json, dir)

# Weather JSON datasets
generate_weather_data_json <- function(data) {
    conditions <- unique(data$WEATHER_CONDITION)

    for (i in seq_len(length(conditions))) {
        data_weather <- data %>%
            filter(WEATHER_CONDITION == conditions[i],
                CRASH_SEVERITY != "Property Damage Only") %>%
            select(LONGITUDE, LATITUDE, SUBURB_LOCATION, CRASH_TIME) %>%
            mutate(
                LONGITUDE = longitude_conversion(LONGITUDE),
                LATITUDE = latitude_conversion(LATITUDE)
            )

        data_weather_json <- data %>%
            rename(c(x = LONGITUDE, z = LATITUDE)) %>%
            mutate(
                y = 30,
                size = 1,
                color = "#4c6d00",
                label = paste(SUBURB_LOCATION, CRASH_TIME)
            ) %>%
            toJSON(dataframe = "rows") %>%
            prettify(indent = 4)

        dir <- paste0("arvr/arvr_asm2/data/data_weather_",
            tolower(conditions[i]), ".json")
        write(data_weather_json, dir)
    }
}

generate_weather_data_json(data)

# Datasets by Suburb
data_belconnen <- filter(data, SUBURB_LOCATION %in% toupper(belconnen)) %>%
    mutate(
        CRASH_DATE = dmy(CRASH_DATE),
        SUBURB_LOCATION = BELCONNEN
    )




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

# Helper function
coordinate_conversion <- function(latitude, longitude) {
    x <- (longitude - 149.1667) * 2856 + 152
    y <- (-latitude - 35.3333) * 3564 + 139
    result <- c(x, y)
    return(result)
}

latitude_conversion <- function(latitude) {
    y <- (-latitude - 35.3333) * 3564 + 139
    return(y)
}

longitude_conversion <- function(longitude) {
    x <- (longitude - 149.1667) * 2856 + 152
    return(x)
}

# coordinate_conversion(-35.2506, 149.1377)
# as.numeric(str_extract(a, "-.+(?=,)"))
# as.numeric(str_extract(a, "(?<= ).+(?=[)])"))
