require(tidyverse)
require(lubridate)
require(mapdeck)
require(jsonlite)

# Load dataset
data <- read_csv("data/ACT_Road_Crash_Data.csv")

# Map Page
key <- paste("pk.eyJ1IjoianVhbmd1YXJpbm8iLCJhIjoiY2t1eGk",
             "wbXd5MXlrbjJ3bnlqZmhuY2NjYSJ9.UGZHYXMuS4HM",
             "7KMvK9_MSQ", sep = "")
set_token(key)

get_map_data <- function(year, severity, lighting, road, weather) {
    if (year == "All") {
        year <- year_choices[["YEAR"]]
    }
    if (severity == "All") {
        severity <- unique(data$CRASH_SEVERITY)
    }
    if (lighting == "All") {
        lighting <- unique(data$LIGHTING_CONDITION)
    }
    if (road == "All") {
        road <- unique(data$ROAD_CONDITION)
    }
    if (weather == "All") {
        weather <- unique(data$WEATHER_CONDITION)
    }
    map_data <- data %>%
        mutate(CRASH_DATE = dmy(CRASH_DATE)) %>%
        mutate(YEAR = year(CRASH_DATE)) %>%
        filter(
            YEAR %in% year,
            CRASH_SEVERITY %in% severity,
            LIGHTING_CONDITION %in% lighting,
            ROAD_CONDITION %in% road,
            WEATHER_CONDITION %in% weather
        )

    if (dim(map_data)[1] == 0) {
        return(data)
    } else {
        return(map_data)
    }
}

get_map <- function(dataset) {
    mapdeck(
        style = mapdeck_style("dark"),
        pitch = 30,
        zoom = 9,
        location = c(149.12, -35.28)) %>%
        add_hexagon(
            data = dataset,
            lat = "LATITUDE",
            lon = "LONGITUDE",
            layer_id = "hex_layer",
            elevation_scale = 15,
            radius = 500,
            colour_range = colourvalues::colour_values(
                # 1:6, palette = colourvalues::get_palette("ylorrd")),
                1:6, palette = colourvalues::get_palette("purples")),
            legend = TRUE,
            legend_options = list(title = "Number of Crashes"),
            auto_highlight = TRUE,
            update_view = F,
    )
}

# Constructe dataset different timeslot
data["time"] <- parse_date_time(data$CRASH_DATE, orders = c("dmy"))

data["Yearly"] <- strptime(data$time, format = "%Y-%m-%d") %>% year()

data["Monthly"] <- strptime(data$time, format = "%Y-%m-%d") %>% month()

data["Weekly"] <- strptime(data$time, format = "%Y-%m-%d") %>% weekdays()

data["Hourly"] <- strptime(data$CRASH_TIME, format = "%H:%M") %>% hour()

# Trend Line Page
get_trend_plot <- function(interval, district) {
    if (district) {
        dataset <- to_residential_district(data) %>%
            group_by(SUBURB_LOCATION, across({{interval}})) %>%
            summarise(COUNT = n())

        ggplot(dataset, aes(x = get(interval), y = COUNT)) +
        geom_line(aes(color = SUBURB_LOCATION)) +
        geom_point() +
        theme_minimal() +
        theme(
            plot.title = element_text(
                size = 12, face = "bold", hjust = 0.5),
            axis.title.x = element_text(
                size = 10, hjust = 0.5, face = "bold"),
            axis.text.x = element_text(
                size = 8),
            axis.title.y = element_text(
                size = 10, hjust = 0.5, vjust = 1, face = "bold"),
            axis.text.y = element_text(
                size = 8),
            axis.line.x = element_line(
                color = "black", size = 1),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()
        ) +
        scale_color_viridis_d() +
        labs(
            x = "Timeframe",
            y = "Number of Crashes",
            color = "Residential District",
            title = paste0("Trendline (", interval, ") - ACT Crashes")
        )

    } else {
        dataset <- data %>%
            group_by(across({{interval}})) %>%
            summarise(COUNT = n())

        ggplot(dataset, aes(x = get(interval), y = COUNT)) +
        geom_line(color = "#287D8EFF") +
        geom_point() +
        theme_minimal() +
        theme(
            plot.title = element_text(
                size = 12, face = "bold", hjust = 0.5),
            axis.title.x = element_text(
                size = 10, hjust = 0.5, face = "bold"),
            axis.text.x = element_text(
                size = 8),
            axis.title.y = element_text(
                size = 10, hjust = 0.5, vjust = 1, face = "bold"),
            axis.text.y = element_text(
                size = 8),
            axis.line.x = element_line(
                color = "black", size = 1),
            legend.position = "none",
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()
        ) +
        scale_color_viridis_d() +
        labs(
            x = "Timeframe",
            y = "Number of Crashes",
            title = paste0("Trendline (", interval, ") - ACT Crashes")
        )
    }
}

# Rank Page
munsell::hue_slice("5P") +
    annotate(
        geom = "segment",
        x = c(7, 7),
        y = c(1, 10),
        xend = c(7, 7),
        yend = c(2, 9),
        arrow = arrow(length = unit(2, "mm"))
    )

get_rank_plot <- function(year, num) {
    if (year == "All") {
        year <- year_choices[["YEAR"]]
    }

    rank_data <- data %>%
        group_by(SUBURB_LOCATION) %>%
        summarise(COUNT = n()) %>%
        arrange(desc(COUNT)) %>%
        head(as.numeric(num))

    data %>%
        filter(SUBURB_LOCATION %in% rank_data$SUBURB_LOCATION) %>%
        mutate(CRASH_DATE = dmy(CRASH_DATE)) %>%
        mutate(YEAR = year(CRASH_DATE)) %>%
        filter(YEAR %in% year) %>%
        count(SUBURB_LOCATION) %>%
        arrange(desc(n)) %>%

        ggplot(aes(x = reorder(SUBURB_LOCATION, n), y = n, label = n)) +
            geom_bar(stat = "identity", fill = "#5b2c60") +
            theme_minimal() +
            geom_text(size = 4, hjust = 1.5,
                color = "white", fontface = "bold") +
            theme(
                plot.title = element_text(
                    size = 12, face = "bold", hjust = 0.5),
                axis.title.x = element_text(
                    size = 10, hjust = 0.5, face = "bold"),
                axis.text.x = element_text(
                    size = 8),
                axis.title.y = element_text(
                    size = 10, hjust = 0.5, vjust = 1, face = "bold"),
                axis.text.y = element_text(
                    size = 8),
                axis.line.x = element_line(
                    color = "black", size = 0.2),
                legend.position = "none",
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank()
            ) +
            coord_flip() +
            scale_fill_gradient(
                low = munsell::mnsl("5P 2/12"),
                high = munsell::mnsl("5P 7/12")
            ) +
            labs(
                x = "Suburbs",
                y = "Number of Crashes",
                title = "Rank by Suburb - ACT Crashes"
            )
}

# Condition Page
get_cond_plot <- function(year, suburb, column) {
    if (year == "All") {
        year <- year_choices[["YEAR"]]
    }
    if (suburb == "All") {
        suburb <- toupper(c(get("canberra_central"),
                            get("woden_valley"),
                            get("belconnen"),
                            get("weston_creek"),
                            get("tuggeranong"),
                            get("gungahlin"),
                            get("molonglo_valley")))
    } else {
        suburb <- toupper(get(suburb))
    }

    data %>%
        mutate(CRASH_DATE = dmy(CRASH_DATE)) %>%
        mutate(YEAR = year(CRASH_DATE)) %>%
        filter(SUBURB_LOCATION %in% suburb, YEAR %in% year) %>%
        group_by(across({{column}}), CRASH_SEVERITY) %>%
        summarise(COUNT = n()) %>%

        ggplot(aes(x = get(column), y = COUNT, fill = get(column))) +
            geom_bar(stat = "identity", position = "dodge") +
            ggtitle("Compare by Condition - ACT Crashes") +
            theme_minimal() +
            labs(
                x = "Categories",
                y = "Number of Crashes",
                fill = column) +
            scale_fill_viridis_d(direction = -1) +
            theme(
                plot.title = element_text(
                    size = 12, face = "bold", hjust = 0.5),
                axis.title.x = element_text(
                    size = 10, hjust = 0.5, face = "bold"),
                axis.text.x = element_text(
                    size = 8, angle = 45, vjust = 0.5),
                axis.title.y = element_text(
                    size = 10, hjust = 0.5, vjust = 1, face = "bold"),
                axis.text.y = element_text(
                    size = 8),
                axis.line.x = element_line(
                    color = "black", size = 0.2),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank()
            )
}

# Miscellaneous
year_choices <- data %>%
    mutate(CRASH_DATE = dmy(CRASH_DATE)) %>%
    mutate(YEAR = year(CRASH_DATE)) %>%
    select(YEAR) %>%
    unique()

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

# Convert coordination by the map size
latitude_conversion <- function(latitude) {
    y <- (-latitude - 35.3333) * 3564 + 139
    return(y)
}

longitude_conversion <- function(longitude) {
    x <- (longitude - 149.1667) * 2856 + 152
    return(x)
}

# Group suburb into residential districts
to_residential_district <- function(dataset) {
    # Group data by Residential District
    data_canberra_central <- dataset %>%
        filter(SUBURB_LOCATION %in% toupper(canberra_central)) %>%
        mutate(
            CRASH_DATE = dmy(CRASH_DATE),
            SUBURB_LOCATION = "CANBERRA CENTRAL",
            LONGITUDE = 149.1287,
            LATITUDE = -35.2822
        )

    data_woden_valley <- dataset %>%
        filter(SUBURB_LOCATION %in% toupper(woden_valley)) %>%
        mutate(
            CRASH_DATE = dmy(CRASH_DATE),
            SUBURB_LOCATION = "WODEN VALLEY",
            LONGITUDE = 149.0950,
            LATITUDE = -35.3452
        )

    data_belconnen <- dataset %>%
        filter(SUBURB_LOCATION %in% toupper(belconnen)) %>%
        mutate(
            CRASH_DATE = dmy(CRASH_DATE),
            SUBURB_LOCATION = "BELCONNEN",
            LONGITUDE = 149.0661,
            LATITUDE = -35.2386
        )

    data_weston_creek <- dataset %>%
        filter(SUBURB_LOCATION %in% toupper(weston_creek)) %>%
        mutate(
            CRASH_DATE = dmy(CRASH_DATE),
            SUBURB_LOCATION = "WESTON CREEK",
            LONGITUDE = 149.0340,
            LATITUDE = -35.2974
        )

    data_tuggeranong <- dataset %>%
        filter(SUBURB_LOCATION %in% toupper(tuggeranong)) %>%
        mutate(
            CRASH_DATE = dmy(CRASH_DATE),
            SUBURB_LOCATION = "TUGGERANONG",
            LONGITUDE = 149.0888,
            LATITUDE = -35.4244
        )

    data_gungahlin <- dataset %>%
        filter(SUBURB_LOCATION %in% toupper(gungahlin)) %>%
        mutate(
            CRASH_DATE = dmy(CRASH_DATE),
            SUBURB_LOCATION = "GUNGAHLIN",
            LONGITUDE = 149.1330,
            LATITUDE = -35.1831
        )

    data_molonglo_valley <- dataset %>%
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
    return(data_rd)
}

# Dataset of conditions
get_condition_json <- function(dataset, condition) {
    conditions <- unique(dataset[condition])[[condition]]

    for (i in seq_len(length(conditions) - 1)) {
        dataset_grouped <- dataset %>%
            filter(get(condition) == conditions[i],
                CRASH_SEVERITY != "Property Damage Only") %>%
            group_by(SUBURB_LOCATION) %>%
            summarise(
                COUNT = n(),
                LONGITUDE = mean(LONGITUDE),
                LATITUDE = mean(LATITUDE)
            )

        dataset_json <- dataset_grouped %>%
            mutate(
                LONGITUDE = longitude_conversion(LONGITUDE),
                LATITUDE = latitude_conversion(LATITUDE)
            ) %>%
            rename(c(x = LONGITUDE, z = LATITUDE)) %>%
            mutate(
                y = COUNT,
                size = sqrt(COUNT),
                color = color[sample(seq_len(length(color)), 1)],
                label = paste(SUBURB_LOCATION)
            ) %>%
            toJSON(dataframe = "rows") %>%
            prettify(indent = 4)

        identifier <- tolower(gsub("-", "_", abbreviate(conditions[i])))
        dir <- paste0("www/assets/data_", identifier, ".json")
        write(dataset_json, dir)
    }
}

# Dataset in terms of suburbs/residential district
get_severity_json <- function(dataset) {
    conditions <- unique(dataset$CRASH_SEVERITY)

    for (i in seq_len(length(conditions))) {
        dataset_grouped <- dataset %>%
            filter(CRASH_SEVERITY == conditions[i]) %>%
            group_by(SUBURB_LOCATION) %>%
            summarise(
                COUNT = n(),
                LONGITUDE = mean(LONGITUDE),
                LATITUDE = mean(LATITUDE)
            )

        dataset_json <- dataset_grouped %>%
            mutate(
                LONGITUDE = longitude_conversion(LONGITUDE),
                LATITUDE = latitude_conversion(LATITUDE)
            ) %>%
            rename(c(x = LONGITUDE, z = LATITUDE)) %>%
            mutate(
                y = COUNT,
                size = sqrt(COUNT),
                color = color[sample(seq_len(length(color)), 1)],
                label = paste(SUBURB_LOCATION)
            ) %>%
            toJSON(dataframe = "rows") %>%
            prettify(indent = 4)

        identifier <- tolower(gsub("-", "_", abbreviate(conditions[i])))
        dir <- paste0("www/assets/data_", identifier, ".json")
        write(dataset_json, dir)
    }
}

# Dataset by year
get_year_json <- function(dataset) {
    for (i in 12:21) {
        year <- 2000 + i
        dataset_grouped <- dataset %>%
            filter(year(CRASH_DATE) == year,
                CRASH_SEVERITY != "Property Damage Only") %>%
            select(LONGITUDE, LATITUDE, SUBURB_LOCATION) %>%
            mutate(
                LONGITUDE = longitude_conversion(LONGITUDE),
                LATITUDE = latitude_conversion(LATITUDE)
            ) %>%
            group_by(SUBURB_LOCATION) %>%
            summarise(
                COUNT = n(),
                LONGITUDE = mean(LONGITUDE),
                LATITUDE = mean(LATITUDE)
            )

        dataset_json <- dataset_grouped %>%
            rename(c(x = LONGITUDE, z = LATITUDE)) %>%
            mutate(
                y = COUNT,
                size = sqrt(COUNT),
                color = color[sample(seq_len(length(color)), 1)],
                label = paste(SUBURB_LOCATION)
            ) %>%
            toJSON(dataframe = "rows") %>%
            prettify(indent = 4)

        dir <- paste0("www/assets/data_", year, ".json")
        write(dataset_json, dir)
    }
}

# Generate JSON dataset
get_vr_json <- function(verbose) {
    verbose <- as.logical(verbose)
    if (!verbose) {
        dataset <- to_residential_district(data)
    }
    else {
        dataset <- data
    }

    get_year_json(dataset)
    get_severity_json(dataset)
    get_condition_json(dataset, "WEATHER_CONDITION")
    get_condition_json(dataset, "LIGHTING_CONDITION")
    get_condition_json(dataset, "ROAD_CONDITION")
}
