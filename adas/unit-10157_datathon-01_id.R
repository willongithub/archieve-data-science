## Applied Data Analysis in Sport 10157
## Hackathon 1
## student ID


## Question 11 code goes here
ggplot(data = df) +
  geom_bar(mapping = aes(x = outcome, fill = outcome),
           stat = "count", colour = "black")

## Question 12 code goes here
df %>%
  count(outcome) %>%
  mutate(prop = prop.table(n)) %>%
  ggplot() +
    geom_bar(mapping = aes(x = reorder(outcome, prop), y = prop, fill = prop),
             stat = "identity")

## Question 13 code goes here
ggplot(data = df) +
  geom_boxplot(mapping = aes(x = play_type, y = distance_to_goal,
                             colour = play_type), fill = "black")

## Question 14 code goes here
df %>%
  group_by(outcome) %>%
  summarize(mean_distance = mean(distance_to_goal),
         sd_distance = sd(distance_to_goal))

## Question 15 code goes here
df %>%
  filter(attacking_team == "Canberra") %>%
  mutate(goal = if_else(outcome == "Goal", "yes", "no")) %>%
  ggplot() +
    geom_point(mapping = aes(x = x_axis, y = y_axis, colour = goal)) +
    xlim(c(0, 110)) +
    ylim(c(0, 65))

## Question 16 code goes here
df %>%
  filter(attacking_team == "Brisbane" |
           attacking_team ==  "Canberra" |
           attacking_team ==  "Sydney") %>% 
  # filter(outcome == "Goal") %>% # Goals scored selected. If not selected the plot will be the same as appears.
  ggplot(aes(x = game_time, fill = attacking_team, colour = attacking_team)) +
    geom_density(alpha = .2)

## Question 17 code goes here
n_goals_for <- df %>%
  filter(outcome == "Goal") %>%
  group_by(attacking_team) %>%
  summarize(goals_for = n()) %>%
  arrange(desc(goals_for)) %>%
  rename(team = attacking_team)

## Question 18 code goes here
n_goals_against <- df %>%
  filter(outcome == "Goal") %>%
  group_by(defending_team) %>%
  summarize(goals_against = n()) %>%
  arrange(desc(goals_against)) %>%
  rename(team = defending_team)

n_goals <- full_join(n_goals_for, n_goals_against, by = "team")

## Question 19 code goes here
n_goals <- n_goals %>%
  mutate(goal_diff = goals_for - goals_against)

## Question 20 code goes here
ggplot(data = n_goals) +
  geom_bar(mapping = aes(x = reorder(team, goal_diff), y = goal_diff),
           fill = "dodgerblue", stat = "identity") +
  theme(axis.text.x = element_text(angle = 30, vjust = 0.8))