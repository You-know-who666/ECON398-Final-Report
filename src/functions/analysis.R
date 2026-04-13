# The analysis is done following similar order as in the McFarland and Wagner 2016 paper

# Run linear regression model on all imputations and combine
# Model 1: OLS without controls
linear_no_control <- with(imputed, lm(cesd_2023 ~ highest_degree_2021))

# Pool results
pooled_results_no_control <- pool(linear_no_control)
summary(pooled_results_no_control)

library(broom)
tidy(pooled_results_no_control)

# Model 2: OLS with controls
linear_control <- with(imputed, lm(cesd_2023 ~ 
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
                                     neuroticism_2008))

# Pool results
pooled_results_control <- pool(linear_control)
summary(pooled_results_control)
tidy(pooled_results_control)

# Check linear regression assumptions


# Model 3: IV
library(AER)

iv <- with(imputed, ivreg(cesd_2023 ~ highest_degree_2021 | cognitive_pct_1997))

# Pool results
pooled_results_iv <- pool(iv)
summary(pooled_results_iv)
tidy(pooled_results_iv)