library(ggplot2)

# Load data from the "data" directory in the project
data <- read.csv("data/data_for_Figure1.csv", header = TRUE, check.names = FALSE)

# Apply logarithmic transformation to the data
data$log_records <- log10(data$`Number of records using the relevant words/phrases`)

# Create the first scatter plot using ggplot
plot1 <- ggplot(data, aes(x = log_records, y = Modified_Z_score, color = factor(Group))) +
  geom_point(shape = 21, size = 3, fill = c("#333F50", "#C00000")[data$Group + 1]) +
  scale_color_manual(values = c("#333F50", "#C00000")) +
  labs(
    x = expression(Log[10](Number ~ of ~ Records ~ Using ~ the ~ Relevant ~ Words/Phrases)),
    y = "Modified Z-score",
    title = "Scatter Plot of Modified Z-score vs. Log(Number of Records)",
    color = "Group"
  ) +
  theme_minimal() +
  ylim(50, 110) +  # Limit Y-axis range from 50 to 110
  scale_x_continuous(breaks = log10(c(100, 1000, 10000, 100000, 1000000)), 
                     labels = c(expression(10^2), expression(10^3), expression(10^4), expression(10^5), expression(10^6)))

# Display the first plot
print(plot1)

# Save the first plot to the "analysis" directory in the project
ggsave("analysis/FIG1_50_110.png", plot = plot1, width = 10, height = 6, dpi = 300)

# Create the second scatter plot with a different Y-axis range
plot2 <- ggplot(data, aes(x = log_records, y = Modified_Z_score, color = factor(Group))) +
  geom_point(shape = 21, size = 3, fill = c("#333F50", "#C00000")[data$Group + 1]) +
  scale_color_manual(values = c("#333F50", "#C00000")) +
  labs(
    x = expression(Log[10](Number ~ of ~ Records ~ Using ~ the ~ Relevant ~ Words/Phrases)),
    y = "Modified Z-score",
    title = "Scatter Plot of Modified Z-score vs. Log(Number of Records)",
    color = "Group"
  ) +
  theme_minimal() +
  ylim(-10, 50) +  # Limit Y-axis range from -10 to 50
  scale_x_continuous(breaks = log10(c(100, 1000, 10000, 100000, 1000000)), 
                     labels = c(expression(10^2), expression(10^3), expression(10^4), expression(10^5), expression(10^6)))

# Display the second plot
print(plot2)

# Save the second plot to the "analysis" directory in the project
ggsave("analysis/FIG1_-10_50.png", plot = plot2, width = 10, height = 6, dpi = 300)
