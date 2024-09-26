library(nlme)
library(reshape2)
library(ggplot2)
library(dplyr)

# Directory where the CSV file is located (within the project "data" directory)
directory <- "data/data_for_linear mixed-effects model.csv"

# Read the data
data <- read.csv(directory)

# Transform the data into long format
data_long <- melt(data, id.vars = c("Word", "Group"), variable.name = "Year", value.name = "Usage")
data_long$Year <- as.numeric(sub("X", "", data_long$Year)) # Convert the 'Year' column to integer

# Build and summarize the mixed-effects model
# Model with random intercepts for 'Word'
model <- lme(Usage ~ Group, random = ~1 | Word, data = data_long)
summary(model)

# Calculate the yearly mean and confidence intervals for each group
data_summary <- data_long %>%
  group_by(Group, Year) %>%
  summarise(
    mean_usage = mean(Usage),
    lower_ci = mean_usage - 1.96 * sd(Usage) / sqrt(n()),
    upper_ci = mean_usage + 1.96 * sd(Usage) / sqrt(n())
  )

# Convert 'Group' to a factor
data_summary$Group <- factor(data_summary$Group, levels = c(1, 2), labels = c("Group 1", "Group 2"))

# Define color palette
color_palette <- c("#C00000", "#333F50")

# Create the line plot
ggplot(data = data_summary, aes(x = Year, y = mean_usage, color = Group, fill = Group)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.2) +
  labs(x = "Year", y = "Mean Usage", color = "Group", fill = "Group") +
  scale_color_manual(values = color_palette) +
  scale_fill_manual(values = color_palette) +
  scale_y_continuous(breaks = seq(floor(min(data_summary$lower_ci)), ceiling(max(data_summary$upper_ci)), by = 1.0)) +
  theme_minimal() +
  theme(legend.position = "bottom")

# Save the plot as a high-resolution PNG file in the "analysis" directory
ggsave("analysis/output_plot.png", dpi = 300, width = 8, height = 6, units = "in")
