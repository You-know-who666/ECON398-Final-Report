# The analysis is done following similar order as in the McFarland and Wagner 2016 paper

library(modelsummary)
library(tidyverse)

# Define the three models
linear_no_control <- with(imputed, lm(cesd_2023 ~ highest_degree_2021))
linear_pre_control <- with(imputed, lm(cesd_2023 ~ 
                                         highest_degree_2021 + 
                                         cognitive_pct_1997 + 
                                         female_1997 + 
                                         age_2023 + 
                                         white_1997 + 
                                         urban_1997 + 
                                         parent_edu_1997 + 
                                         peer_negative_1997 +
                                         extraversion_2008 + 
                                         openess_2008 + 
                                         neuroticism_2008))

linear_post_control <- with(imputed, lm(cesd_2023 ~ 
                                          highest_degree_2021 + 
                                          cognitive_pct_1997 + 
                                          female_1997 + 
                                          age_2023 + 
                                          white_1997 + 
                                          urban_1997 + 
                                          parent_edu_1997 + 
                                          peer_negative_1997 + 
                                          extraversion_2008 + 
                                          openess_2008 + 
                                          neuroticism_2008 + 
                                          health_2021 + 
                                          cesd_2019 + 
                                          employed_2021 + 
                                          has_partner_2021 + 
                                          log_income_2022))

# Pool the results
pooled_no_control <- pool(linear_no_control)
pooled_pre_control <- pool(linear_pre_control)
pooled_post_control <- pool(linear_post_control)

# Extract coefficients, standard errors, and p-values
extract_results <- function(pooled_obj, model_name) {
  summary_obj <- summary(pooled_obj)
  data.frame(
    term = summary_obj$term,
    estimate = summary_obj$estimate,
    std.error = summary_obj$std.error,
    p.value = summary_obj$p.value,
    model = model_name
  )
}

# Combine all results
results_all <- bind_rows(
  extract_results(pooled_no_control, "No Controls"),
  extract_results(pooled_pre_control, "Pre-treatment Controls"),
  extract_results(pooled_post_control, "Post-treatment Controls")
)

# Reshape to wide format for modelsummary
results_wide <- results_all %>%
  select(-std.error, -p.value) %>%
  pivot_wider(names_from = model, values_from = estimate)

# Create a publication-ready table using modelsummary
# First, create list of model objects for modelsummary
model_list <- list(
  "No Controls" = pooled_no_control,
  "Pre-treatment Controls" = pooled_pre_control,
  "Post-treatment Controls" = pooled_post_control
)

# Generate the table
modelsummary(model_list,
             statistic = "({std.error})",
             stars = c('*' = 0.05, '**' = 0.01, '***' = 0.001),
             coef_map = c(
               "highest_degree_2021High" = "College Degree or Higher",
               "cognitive_pct_1997" = "Cognitive Ability (ASVAB)",
               "female_1997Yes" = "Female",
               "age_2023" = "Age",
               "white_1997Yes" = "White",
               "urban_1997Yes" = "Urban",
               "parent_edu_1997" = "Parental Education",
               "peer_negative_1997Yes" = "Negative Peer Influence",
               "extraversion_2008" = "Extraversion",
               "openess_2008" = "Openness",
               "neuroticism_2008" = "Neuroticism",
               "health_2021" = "Self-rated Health",
               "cesd_2019" = "Prior Depression (2019)",
               "employed_2021Yes" = "Employed",
               "has_partner_2021Yes" = "Has Partner",
               "log_income_2022" = "Log Income"
             ),
             gof_map = c("nobs", "r.squared", "adj.r.squared"),
             title = "OLS Regression Results for Depressive Symptoms (CES-D 2023)",
             notes = "Heteroskedasticity-robust standard errors in parentheses. *** p < 0.001, ** p < 0.01, * p < 0.05. Results pooled across 5 imputed datasets using Rubin's rules."
)
