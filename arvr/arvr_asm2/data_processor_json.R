require(tidyverse)
require(jsonlite)

# Dataset exploratory summary
data <- read_csv("arvr/arvr_asm2/data/ACT_Road_Crash_Data.csv")
names(data)

# Residential Districts of Canberra
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

# Group data by Residential District
data_canberra_central <- data %>%
    filter(SUBURB_LOCATION %in% toupper(canberra_central)) %>%
    mutate(
        CRASH_DATE = dmy(CRASH_DATE),
        SUBURB_LOCATION = "CANBERRA CENTRAL",
        LONGITUDE = 149.1287,
        LATITUDE = -35.2822
    )

data_woden_valley <- data %>%
    filter(SUBURB_LOCATION %in% toupper(woden_valley)) %>%
    mutate(
        CRASH_DATE = dmy(CRASH_DATE),
        SUBURB_LOCATION = "WODEN VALLEY",
        LONGITUDE = 149.0950,
        LATITUDE = -35.3452
    )

data_belconnen <- data %>%
    filter(SUBURB_LOCATION %in% toupper(belconnen)) %>%
    mutate(
        CRASH_DATE = dmy(CRASH_DATE),
        SUBURB_LOCATION = "BELCONNEN",
        LONGITUDE = 149.0661,
        LATITUDE = -35.2386
    )

data_weston_creek <- data %>%
    filter(SUBURB_LOCATION %in% toupper(weston_creek)) %>%
    mutate(
        CRASH_DATE = dmy(CRASH_DATE),
        SUBURB_LOCATION = "WESTON CREEK",
        LONGITUDE = 149.0340,
        LATITUDE = -35.2974
    )

data_tuggeranong <- data %>%
    filter(SUBURB_LOCATION %in% toupper(tuggeranong)) %>%
    mutate(
        CRASH_DATE = dmy(CRASH_DATE),
        SUBURB_LOCATION = "TUGGERANONG",
        LONGITUDE = 149.0888,
        LATITUDE = -35.4244
    )

data_gungahlin <- data %>%
    filter(SUBURB_LOCATION %in% toupper(gungahlin)) %>%
    mutate(
        CRASH_DATE = dmy(CRASH_DATE),
        SUBURB_LOCATION = "GUNGAHLIN",
        LONGITUDE = 149.1330,
        LATITUDE = -35.1831
    )

data_molonglo_valley <- data %>%
    filter(SUBURB_LOCATION %in% toupper(molonglo_valley)) %>%
    mutate(
        CRASH_DATE = dmy(CRASH_DATE),
        SUBURB_LOCATION = "MOLONGLO VALLEY",
        LONGITUDE = 149.0642,
        LATITUDE = -35.2861
    )

data_rd <- rbind(
    data_canberra_central,
    data_woden_valley,
    data_belconnen,
    data_weston_creek,
    data_tuggeranong,
    data_gungahlin,
    data_molonglo_valley
)

unique(data_rd$SUBURB_LOCATION)

unique(data$CRASH_SEVERITY)
unique(data$LIGHTING_CONDITION)
unique(data$ROAD_CONDITION)
unique(data$WEATHER_CONDITION)

get_json <- function(dataset) {
    get_weather_data(dataset)
    get_lighting_data(dataset)
    get_road_data(dataset)
    get_severity_data(dataset)
    # get_timeslot_data(dataset)
}

get_json(data)

# Convert coordination by the map size
latitude_conversion <- function(latitude) {
    y <- (-latitude - 35.3333) * 3564 + 139
    return(y)
}

longitude_conversion <- function(longitude) {
    x <- (longitude - 149.1667) * 2856 + 152
    return(x)
}

# Dataset of Weather Condition
get_weather_data <- function(dataset) {
    conditions <- unique(dataset$WEATHER_CONDITION)

    for (i in seq_len(length(conditions) - 1)) {
        group_data <- dataset %>%
            filter(WEATHER_CONDITION == conditions[i],
                CRASH_SEVERITY != "Property Damage Only") %>%
            group_by(SUBURB_LOCATION) %>%
            summarise(
                COUNT = n(),
                LONGITUDE = mean(LONGITUDE),
                LATITUDE = mean(LATITUDE)
            )

        dataset_json <- group_data %>%
            mutate(
                LONGITUDE = longitude_conversion(LONGITUDE),
                LATITUDE = latitude_conversion(LATITUDE)
            ) %>%
            rename(c(x = LONGITUDE, z = LATITUDE)) %>%
            mutate(
                y = COUNT,
                size = sqrt(COUNT),
                color = color[i],
                label = paste(SUBURB_LOCATION)
            ) %>%
            toJSON(dataframe = "rows") %>%
            prettify(indent = 4)

        dir <- paste0("arvr/arvr_asm2/data/data_",
            tolower(conditions[i]), ".json")
        write(dataset_json, dir)
    }
}

# Dataset of Lighting Condition
get_lighting_data <- function(dataset) {
    conditions <- unique(dataset$LIGHTING_CONDITION)

    for (i in seq_len(length(conditions) - 1)) {
        group_data <- dataset %>%
            filter(LIGHTING_CONDITION == conditions[i],
                CRASH_SEVERITY != "Property Damage Only") %>%
            group_by(SUBURB_LOCATION) %>%
            summarise(
                COUNT = n(),
                LONGITUDE = mean(LONGITUDE),
                LATITUDE = mean(LATITUDE)
            )

        dataset_json <- group_data %>%
            mutate(
                LONGITUDE = longitude_conversion(LONGITUDE),
                LATITUDE = latitude_conversion(LATITUDE)
            ) %>%
            rename(c(x = LONGITUDE, z = LATITUDE)) %>%
            mutate(
                y = COUNT,
                size = sqrt(COUNT),
                color = color[i],
                label = paste(SUBURB_LOCATION)
            ) %>%
            toJSON(dataframe = "rows") %>%
            prettify(indent = 4)

        dir <- paste0("arvr/arvr_asm2/data/data_",
            tolower(conditions[i]), ".json")
        write(dataset_json, dir)
    }
}

# Dataset of Road Condition
get_road_data <- function(dataset) {
    conditions <- unique(dataset$ROAD_CONDITION)

    for (i in seq_len(length(conditions) - 1)) {
        group_data <- dataset %>%
            filter(ROAD_CONDITION == conditions[i],
                CRASH_SEVERITY != "Property Damage Only") %>%
            group_by(SUBURB_LOCATION) %>%
            summarise(
                COUNT = n(),
                LONGITUDE = mean(LONGITUDE),
                LATITUDE = mean(LATITUDE)
            )

        dataset_json <- group_data %>%
            mutate(
                LONGITUDE = longitude_conversion(LONGITUDE),
                LATITUDE = latitude_conversion(LATITUDE)
            ) %>%
            rename(c(x = LONGITUDE, z = LATITUDE)) %>%
            mutate(
                y = COUNT,
                size = sqrt(COUNT),
                color = color[i],
                label = paste(SUBURB_LOCATION)
            ) %>%
            toJSON(dataframe = "rows") %>%
            prettify(indent = 4)

        dir <- paste0("arvr/arvr_asm2/data/data_",
            tolower(conditions[i]), ".json")
        write(dataset_json, dir)
    }
}

# Dataset of Crash Severity
get_severity_data <- function(dataset) {
    conditions <- unique(dataset$CRASH_SEVERITY)

    for (i in seq_len(length(conditions))) {
        group_data <- dataset %>%
            filter(CRASH_SEVERITY == conditions[i],
                CRASH_SEVERITY != "Property Damage Only") %>%
            group_by(SUBURB_LOCATION) %>%
            summarise(
                COUNT = n(),
                LONGITUDE = mean(LONGITUDE),
                LATITUDE = mean(LATITUDE)
            )

        dataset_json <- group_data %>%
            mutate(
                LONGITUDE = longitude_conversion(LONGITUDE),
                LATITUDE = latitude_conversion(LATITUDE)
            ) %>%
            rename(c(x = LONGITUDE, z = LATITUDE)) %>%
            mutate(
                y = COUNT,
                size = sqrt(COUNT),
                color = color[i],
                label = paste(SUBURB_LOCATION)
            ) %>%
            toJSON(dataframe = "rows") %>%
            prettify(indent = 4)

        dir <- paste0("arvr/arvr_asm2/data/data_",
            tolower(conditions[i]), ".json")
        write(dataset_json, dir)
    }
}

# Dataset of Time Slot
# get_road_data <- function(dataset) {
#     conditions <- unique(dataset$CRASH_SEVERITY)

#     for (i in seq_len(length(conditions))) {
#         group_data <- dataset %>%
#             filter(CRASH_SEVERITY == conditions[i],
#                 CRASH_SEVERITY != "Property Damage Only") %>%
#             group_by(SUBURB_LOCATION) %>%
#             summarise(
#                 COUNT = n(),
#                 LONGITUDE = mean(LONGITUDE),
#                 LATITUDE = mean(LATITUDE)
#             )

#         dataset_json <- group_data %>%
#             mutate(
#                 LONGITUDE = longitude_conversion(LONGITUDE),
#                 LATITUDE = latitude_conversion(LATITUDE)
#             ) %>%
#             rename(c(x = LONGITUDE, z = LATITUDE)) %>%
#             mutate(
#                 y = COUNT,
#                 size = sqrt(COUNT),
#                 color = color[i],
#                 label = paste(SUBURB_LOCATION)
#             ) %>%
#             toJSON(dataframe = "rows") %>%
#             prettify(indent = 4)

#         dir <- paste0("arvr/arvr_asm2/data/data_",
#             tolower(conditions[i]), ".json")
#         write(dataset_json, dir)
#     }
# }