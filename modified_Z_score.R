library(readr)
library(dplyr)
library(tidyr)

# Load data from the "data" directory in the project
data <- read.csv("data/UseRate_2000-2024.csv", header = TRUE, check.names = FALSE)

# List of words to analyze
words <- colnames(data)[2:ncol(data)]

# Calculate Modified Z-score for each word
results <- data %>%
  select(Year, all_of(words)) %>%
  mutate(across(all_of(words), ~ . * 1e6)) %>%
  mutate(across(all_of(words), ~ 0.6745 * (. - median(.)) / median(abs(. - median(.))))) %>%
  pivot_longer(cols = all_of(words), names_to = "Word", values_to = "Modified_Z_score")

# Convert results to wide format
results_wide <- results %>%
  pivot_wider(names_from = Word, values_from = Modified_Z_score)

# Save the results to a CSV file in the "analysis" directory in the project
write.csv(results_wide, file = "analysis/results_2000-2024_modified_z-score.csv", row.names = FALSE)
