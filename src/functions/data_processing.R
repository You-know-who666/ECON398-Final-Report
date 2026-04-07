set.seed(123)

library(janitor) # Used for cleaning variable names

# Auto-clean names first
clean_data <- raw_data %>%
  clean_names()  # Converts to snake_case

# Then check what names I got
names(clean_data)

# Then manually rename the ones that are still unclear
clean_data <- clean_data %>%
  rename(
    id = pubid,
    pct_peer_smoke_1997 = yprs_700, 
    pct_peer_drunk_1997 = yprs_800,
    pct_peer_drug_1997 = yprs_1300,
    sex_1997 = key_sex,
    urban_rural_1997 = cv_urban_rural,
    highest_grade_dad_1997 = cv_hgc_bio_dad,
    highest_grade_mum_1997 = cv_hgc_bio_mom,
    race_1997 = key_race_ethnicity,
    conscientiousness_2002 = ysaq_282k,
    agreeableness_2002 = ysaq_282n,
    extraversion_2008 = ytel_tipia_000001,
    openess_2008 = ytel_tipia_000005,
    neuroticism_2008 = ytel_tipia_000009,
    highest_degree_2021 = cv_highest_degree_ever_edt,
    marital_status_2021 = cv_marstat,
    employ_status_2021 = cv_doi_employed,
    religion_2021 = yhhi_55708_rev,
    health_2021 = yhea_100,
    age_2023 = cv_age_int_date,
    cesd_2023 = cv_cesd_score_r21,
    cesd_2019 = cv_cesd_score_r19,
    cognitive_score_1997 = asvab_math_verbal_score_pct,
    income_2022 = yinc_1700
  )

# Replace all negative values with NA across all columns
clean_data <- clean_data %>% mutate(across(everything(), ~ ifelse(. < 0, NA, .)))

# Transform variables into desired form
clean_data <- clean_data %>%
  mutate(
    # ============================================================
    # DEMOGRAPHICS (Fixed characteristics)
    # ============================================================
    
    # Sex: 1 = Male, 2 = Female
    female_1997 = case_when(
      sex_1997 == 2 ~ 1,
      sex_1997 == 1 ~ 0,
      TRUE ~ NA_real_
    ),
    female_1997 = factor(female_1997, levels = c(0, 1), labels = c("No", "Yes")),
    
    # Race: White vs Non-white (binary categorical)
    white_1997 = case_when(
      race_1997 == 4 ~ 1,      # White
      race_1997 %in% c(1, 2, 3) ~ 0,  # Non-white
      TRUE ~ NA_real_
    ),
    white_1997 = factor(white_1997, levels = c(0, 1), labels = c("No", "Yes")),
    
    # Urban/rural (if needed)
    urban_1997 = case_when(
      urban_rural_1997 == 1 ~ 1,  # Urban
      urban_rural_1997 == 0 ~ 0,  # Rural
      TRUE ~ NA_real_
    ),
    urban_1997 = factor(urban_1997, levels = c(0, 1), labels = c("No", "Yes")),
    
    # ============================================================
    # FAMILY EDUCATION BACKGROUND
    # ============================================================
    
    # Parental education: max of both parents (continuous)
    parent_edu_1997 = pmax(highest_grade_dad_1997, highest_grade_mum_1997, na.rm = TRUE),
    
    # ============================================================
    # PEER ENVIRONMENT (1997) - Binary: "At least 50% of peers smoke/drink/use drug" (negative peer environment) 
    # vs "25% or less smoke/drink/use drug"
    # ============================================================
    # In NLSY97, friends smoke/drink/use drugs all count as negative peer behaviors
    # Code negative values as missing values first
    peer_negative_1997 = case_when(
      pct_peer_smoke_1997 >= 3 | pct_peer_drunk_1997 >= 3 | pct_peer_drug_1997 >= 3 ~ 1,
      pct_peer_smoke_1997 <= 2 & pct_peer_smoke_1997 <= 2 & pct_peer_smoke_1997 <= 2 ~ 0,
      TRUE ~ NA_real_
    ),
    peer_negative_1997 = factor(peer_negative_1997, levels = c(0, 1), labels = c("No", "Yes")),
    
    # ============================================================
    # COGNITIVE ABILITY (1997) - Continuous
    # ============================================================
    # Convert from 0-100000 scale to 0-100 percentile
    cognitive_pct_1997 = as.numeric(cognitive_score_1997) / 1000,
    
    # ============================================================
    # EDUCATIONAL ATTAINMENT (2021)
    # ============================================================
    # Highest degree: Keep as ordinal or create binary
    # Typical coding: 0=No degree, 1=GED, 2=HS, 3=Some college, 4=Bach, 5=Master, 6=PhD, 7=Prof
    # Two categories: Less than college, college or higher
    highest_degree_2021 = case_when(
      highest_degree_2021 >= 3 ~ 1,   # College or higher
      highest_degree_2021 >= 0 & highest_degree_2021 < 3 ~ 0,
      TRUE ~ NA_real_
    ),
    highest_degree_2021 = factor(highest_degree_2021, levels = c(0, 1), labels = c("Low", "High")),
    
    # ============================================================
    # EMPLOYMENT (2021) - Binary
    # ============================================================
    # In NLSY97: 1 = employed, 0 = not employed
    employed_2021 = case_when(
      employ_status_2021 == 1 ~ 1,
      employ_status_2021 == 0 ~ 0,
      TRUE ~ NA_real_
    ),
    employed_2021 = factor(employed_2021, levels = c(0, 1), labels = c("No", "Yes")),
    
    # ============================================================
    # PARTNERSHIP STATUS (2021) - Binary
    # ============================================================
    # Marital status codes (typical NLSY97):
    # Categorize into living with a partner or not living with a partner
    has_partner_2021 = case_when(
      marital_status_2021 %in% c(1, 3, 5, 7, 9) ~ 1,  # Has spouse/partner
      marital_status_2021 %in% c(2, 4, 6, 8, 10) ~ 0,  # No partner
      TRUE ~ NA_real_
    ),
    has_partner_2021 = factor(has_partner_2021, levels = c(0, 1), labels = c("No", "Yes")),
    
    # ============================================================
    # INCOME (2022) - Continuous (log transform if skewed)
    # ============================================================
    log_income_2022 = log(income_2022 + 1)  # +1 to handle zeros
  )

# Drop unnecessary variables from the initial clean_data dataset
clean_data <- clean_data %>% 
  select(-pct_peer_smoke_1997, 
         -pct_peer_drunk_1997, 
         -pct_peer_drug_1997,
         -income_2022,
         -cognitive_score_1997,
         -sex_1997,
         -urban_rural_1997,
         -highest_grade_dad_1997,
         -highest_grade_mum_1997,
         -race_1997,
         -employ_status_2021,
         -marital_status_2021) %>% 
  # Replace the value 999 in religion_2021 with NA
  mutate(religion_2021 = ifelse(religion_2021 == 999, NA, religion_2021))

# Check the percentage of missing values for all variables
missing_percent <- clean_data %>%
  summarise(across(everything(), ~ mean(is.na(.)) * 100))

glimpse(missing_percent)

# conscientiousness_2002 and agreeableness_2002 have nearly 50% of missing values, 
# and nearly all religion_2021 values are missing.
# Therefore, these three variables should be dropped. 
clean_data <- clean_data %>%
  select(-religion_2021, -conscientiousness_2002, -agreeableness_2002)

# For other variables with missing values, MICE is used to impute values
library(mice)

# Define MICE methods (pmm for continuous, logreg for binary, plor for ordinal)
method_vec <- c(
  id = "",
  extraversion_2008 = "pmm",
  openess_2008 = "pmm",
  neuroticism_2008 = "pmm",
  cesd_2019 = "pmm",
  highest_degree_2021 = "polr",
  health_2021 = "pmm", 
  age_2023 = "pmm",      
  cesd_2023 = "pmm", 
  female_1997 = "",             
  white_1997 = "", 
  urban_1997 = "logreg",  
  parent_edu_1997 = "pmm",   
  peer_negative_1997 = "",    
  cognitive_pct_1997 = "pmm",  
  employed_2021 = "logreg",     
  has_partner_2021 = "logreg", 
  log_income_2022 = "pmm"
)

# Run MICE 
imputed <- mice(clean_data,
                m = 5,           # 5 imputations (standard practice) 
                maxit = 10,      # 10 iterations (standard practice)
                method = method_vec,
                seed = 123,
                printFlag = FALSE)  # Suppress progress output 

# Get complete dataset (use 1st imputation for initial checks)
clean_data_complete <- complete(imputed, 1)

# Check convergence
plot(imputed)  # Should show lines stabilizing (no trend)
