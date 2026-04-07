library(tidyverse)
library(here)
library(readxl)

# Import the raw census data from the Excel workbook downloaded
raw_data <- read_excel(here("data", "data_april_6_2026.xlsx"), sheet = "data_april_6_2026")
head(raw_data)