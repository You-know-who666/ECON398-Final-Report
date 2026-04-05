library(tidyverse)
library(here)
library(readxl)

# Import the raw survey data from the Excel workbook
raw_data <- read_excel(here("data", "raw_data.xlsx"), sheet = "ALL")
head(raw_data)