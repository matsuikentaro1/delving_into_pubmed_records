library(forecast)
library(dplyr)

# Load data from the "data" directory in the project
df <- read.csv("data/UseRate_2000-2024.csv", header = TRUE, check.names = FALSE)

# Select data from 2000 to 2022
train_data <- df %>% filter(Year <= 2022)

# Prepare a data frame to store the results
results <- data.frame(Term = colnames(train_data)[-1],
                      Predicted_2023 = numeric(length(colnames(train_data))-1),
                      Actual_2023 = numeric(length(colnames(train_data))-1),
                      MAE_2023 = numeric(length(colnames(train_data))-1),
                      Ratio_2023 = numeric(length(colnames(train_data))-1),
                      Predicted_2024 = numeric(length(colnames(train_data))-1),
                      Actual_2024 = numeric(length(colnames(train_data))-1),
                      MAE_2024 = numeric(length(colnames(train_data))-1),
                      Ratio_2024 = numeric(length(colnames(train_data))-1))

# ARIMA modeling and prediction
for(term in colnames(train_data)[-1]) {
  # Extract time series data for each term (treat 0 as missing values)
  ts_data <- ts(train_data[[term]], start = 2000, end = 2022)
  ts_data[ts_data == 0] <- NA
  
  # Apply ARIMA model
  model <- auto.arima(ts_data)
  
  # Forecast for 2023 and 2024
  predictions <- forecast(model, h = 2)$mean
  
  # Save predictions for 2023 and 2024
  predicted_2023 <- predictions[1]
  predicted_2024 <- predictions[2]
  
  # Get actual values for 2023 and 2024 from the original data
  actual_2023 <- df %>% filter(Year == 2023) %>% select(term) %>% unlist()
  actual_2024 <- df %>% filter(Year == 2024) %>% select(term) %>% unlist()
  
  # Calculate ratio of actual to predicted values
  ratio_2023 <- ifelse(predicted_2023 != 0, actual_2023 / predicted_2023, NA)
  ratio_2024 <- ifelse(predicted_2024 != 0, actual_2024 / predicted_2024, NA)
  
  # Calculate MAE for 2023 and 2024
  mae_2023 <- mean(abs(actual_2023 - predicted_2023), na.rm = TRUE)
  mae_2024 <- mean(abs(actual_2024 - predicted_2024), na.rm = TRUE)
  
  # Save results
  results <- results %>% mutate(
    Predicted_2023 = replace(Predicted_2023, Term == term, predicted_2023),
    Actual_2023 = replace(Actual_2023, Term == term, actual_2023),
    MAE_2023 = replace(MAE_2023, Term == term, mae_2023),
    Ratio_2023 = replace(Ratio_2023, Term == term, ratio_2023),
    Predicted_2024 = replace(Predicted_2024, Term == term, predicted_2024),
    Actual_2024 = replace(Actual_2024, Term == term, actual_2024),
    MAE_2024 = replace(MAE_2024, Term == term, mae_2024),
    Ratio_2024 = replace(Ratio_2024, Term == term, ratio_2024)
  )
}

# Sort by the ratio for 2024 in descending order
results <- results %>% arrange(desc(Ratio_2024))

# Save the results to a CSV file
write.csv(results, file = "analysis/ARIMA_predictions_results.csv", row.names = FALSE)
