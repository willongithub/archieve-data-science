### IDS Lab Week 10

## Exercise 1
require(ggplot2)
# 1
ggplot(data = mpg)

# 2
ggplot(data = mpg, aes(x = cyl, y = hwy)) +
    geom_point()

# 3
ggplot(data = mpg, aes(x = cyl, y = hwy, colour = class)) +
    geom_point()

# 4
ggplot(data = mpg, aes(x = class, y = drv, colour = class)) +
    geom_point()

## Exercise 2
# 1
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point()

# 2
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point() +
    geom_smooth()

# 3
ggplot(data = mpg, aes(x = class)) +
    geom_bar()

# 4
ggplot(data = mpg, aes(x = hwy)) +
    geom_histogram()

# 5
ggplot(data = mpg, aes(x = hwy)) +
    geom_histogram(bins = 20, aes(fill = class)) +
    scale_x_continuous(breaks = seq(10, 50, 2))

# 6
ggplot(data = mpg, aes(x = hwy)) +
    geom_histogram(bins = 20, aes(fill = class)) +
    scale_x_continuous(breaks = seq(10, 50, 2)) +
    geom_vline(xintercept = mean(mpg$hwy))

## Exercise 3
# 1
ggplot(data = mpg, aes(x = class)) +
    geom_bar()

# 2
ggplot(data = mpg, aes(x = class)) +
    geom_bar(aes(fill = drv))

# 3
ggplot(data = mpg, aes(x = class)) +
    geom_bar(aes(fill = drv)) +
    scale_y_continuous(labels = scales::label_percent(accuracy = 0.1,
                                                       scale = 1))
# percentages here is not proportion to total count but simply convert format

# Exercise 4
# 1
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point() +
    facet_grid(. ~ class)

# 2
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point(aes(colour = cyl, shape = as.factor(year))) +
    facet_grid(. ~ class)
