library(ggplot2)
library(scales)

# Load data
data <- read.csv("data/data_for_Figure1.csv", check.names = FALSE)

# Add point size based on Modified Z-score
data$point_size <- ifelse(data$Modified_Z_score > 50, 6,
                          ifelse(data$Modified_Z_score >= 20, 4.5,
                                 ifelse(data$Modified_Z_score >= 10, 3, 1.5)))

# Create plot
plotA <- ggplot(data,
                aes(x = `Number of records using the relevant words/phrases`,
                    y = Modified_Z_score,
                    colour = factor(Group))) +
  geom_point(aes(size = point_size), alpha = 0.8) +
  scale_size_identity() +
  scale_x_log10(
    breaks = 10^(2:6),
    labels = trans_format("log10", math_format(10^.x))
  ) +
  scale_y_log10(
    breaks = c(2.5, 5, 10, 20, 50, 100),
    labels = c("2.5", "5", "10", "20", "50", "100"),
    limits = c(2.5, 120)  # Set lower limit of Y-axis to 2.5
  ) +
  scale_colour_manual(values = c("#333F50", "#C00000")) +
  labs(
    x = expression(Log[10]~Number~of~Records),
    y = "Modified Z-score (log scale)",
    colour = "Group"
  ) +
  theme_minimal()

# Save image (600 dpi)
ggsave("analysis/FIG1_log.png", plotA, width = 10, height = 6, dpi = 600)