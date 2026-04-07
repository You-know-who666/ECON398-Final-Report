# Check linear regression model assumptions with imputation 1 (clean_data_complete)

library(car)

# Run model without controls
model <- lm(cesd_2023 ~ highest_degree_2021, data = clean_data_complete)

# Set up 2x2 plotting window
par(mfrow = c(1, 2))

# Residuals vs Fitted
plot(model, which = 1, main = "Residuals vs Fitted")

# Q-Q plot
plot(model, which = 2, main = "Q-Q Plot")

# Run model with controls
model_control <- lm(cesd_2023 ~ 
              highest_degree_2021 + 
              cognitive_pct_1997 + 
              female_1997 + 
              age_2023 + 
              white_1997+ 
              urban_1997 + 
              parent_edu_1997 + 
              peer_negative_1997 + 
              health_2021 + 
              cesd_2019 + 
              employed_2021 + 
              has_partner_2021 + 
              log_income_2022 + 
              extraversion_2008 + 
              openess_2008 + 
              neuroticism_2008, 
              data = clean_data_complete)

# Set up 2x2 plotting window
par(mfrow = c(1, 2))

# Residuals vs Fitted
plot(model_control, which = 1, main = "Residuals vs Fitted")

# Q-Q plot
plot(model_control, which = 2, main = "Q-Q Plot")

# VIF (check multicollinearity)
# Rule of thumb: VIF > 5 or 10 indicates problematic multicollinearity
vif_values <- vif(model_control)
print(vif_values)

# Based on the plots, the assumptions might not be satisfied

# Explore the relationships between education and depression
# Boxplot: CES-D by education group
ggplot(clean_data_complete, aes(x = highest_degree_2021, 
                                y = cesd_2023, 
                                fill = highest_degree_2021)) +
  geom_boxplot() +
  labs(x = "Education Level", 
       y = "CES-D Score (2023)",
       title = "Depression Scores by Educational Attainment") +
  theme_minimal()

# From the boxplot, not much is known about the relationship
# Formal regressions are needed to examine it