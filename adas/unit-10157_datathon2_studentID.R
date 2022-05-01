## Applied Data Analysis in Sport 10157
## Datathon 2
## <put your student ID here>


## Question 21 code goes here
df_filtered <- 
  df %>% 
    filter(Season > 1998) %>% 
    select(
      Season,
      Round,
      Home.team,
      Away.team,
      Home.score,
      Kicks,
      Marks,
      Handballs,
      Goals,
      Inside.50s,
      Marks.Inside.50)


str(df_filtered)

## Question 22 code goes here
# A)
fit <- 
  lm(Goals ~ Kicks + Marks + Handballs + Inside.50s + Marks.Inside.50,
     data = df_filtered)

broom::tidy(fit, conf.int = T)

# B)
# For the intercept, there is no practical meaning in this case. For the slope
# coefficients, the team that get 1 more than average in Kicks, Marks,
# Handballs, Inside.50s or Marks.Inside.50, will get -0.0408, 0.000401, 0.00372,
# 0.242 or 0.379 more Goals than average teams respectively.

## Question 23 code goes here
pairs(formula = ~ Kicks + Marks + Handballs + Inside.50s + Marks.Inside.50,
      data = df_filtered)
# All the shapes show no significant diagonal orientation on this scale. There
# is no obvious linear relationship found between the explanatory variables from
# the pairs plot test.

sqrt(car::vif(fit))
# The variance inflation factors of the explanatory variables are well below 5,
# they are all lower than 1.5, which means the standard errors are all less than
# 1.5 times larger if there is 0 correlation with others respectively.

## Question 24 code goes here
car::avPlots(fit)
# It seems the explanatory variables all shows weak linearity with Goals.

## Question 25 code goes here
# A)
res <- residuals(fit)
fitted <- predict(fit)

ggplot(data = NULL, aes(x = fitted, y = res)) +
  geom_point(colour = "black") +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "red", )

# B)
# The plot shows no obvious pattern of heteroscedasticity, so we can say this
# test does not reject the assumption of homoscedasticity.

## Question 26 code goes here
# A)
df_filtered <- 
  df_filtered %>% 
    mutate(exp_Goals = predict(fit))

df_filtered %>% 
ggplot(aes(x = Goals, y = exp_Goals)) +
  geom_point(colour = "black") +
  geom_abline(linetype = "dashed", colour = "red", )

# B)
# We can see quite a lot of the predicted values of this model shows weak
# alignment with the observed values across the range, which means the validity
# of the model is not good enough. For instance, there are a number of cases
# with observed goals around 25 but were predicted to be as low as 20 and as
# high as 30.