library(nlme)
library(reshape2)
library(ggplot2)
library(dplyr)

# ==== 入力 ====
directory <- "data/data_for_linear mixed-effects model_SA.csv"
# 読み込み
data <- read.csv(directory)
# 列名を扱いやすく
data <- data %>%
  rename(total_records = Number.of.records.using.the.relevant.words.phrases)

# ==== 感度分析（AI語のみ <2000 を除外、Controlは全件残す） ====
cutoff <- 2000
# 除外対象（AI語・総レコード<2000）
to_drop <- data %>%
  filter(Group == 1, total_records < cutoff) %>%
  pull(Word)

message("Excluded AI terms (< ", cutoff, " records): ", length(to_drop))
if (length(to_drop) > 0) {
  message(paste(head(to_drop, 10), collapse = ", "),
          ifelse(length(to_drop) > 10, " ...", ""))
}

# フィルタ適用
data_sa <- data %>%
  filter(Group == 0 | (Group == 1 & total_records >= cutoff))

# ==== ロング化（年列だけを安全に抽出） ====
year_cols <- grep("^X\\d{4}$", names(data_sa), value = TRUE)
data_long <- melt(
  data_sa[, c("Word", "Group", "total_records", year_cols)],
  id.vars = c("Word", "Group", "total_records"),
  variable.name = "Year",
  value.name = "Usage"
)

# "X2000" -> 2000
data_long$Year <- as.numeric(sub("^X", "", data_long$Year))

# ==== 線形混合効果モデル（語ごとのランダム切片） ====
model <- lme(Usage ~ Group, random = ~1 | Word, data = data_long)
print(summary(model))

# ==== 要約と可視化 ====
data_summary <- data_long %>%
  group_by(Group, Year) %>%
  summarise(
    mean_usage = mean(Usage, na.rm = TRUE),
    sd_usage   = sd(Usage,   na.rm = TRUE),
    n          = dplyr::n(),
    lower_ci   = mean_usage - 1.96 * sd_usage / sqrt(n),
    upper_ci   = mean_usage + 1.96 * sd_usage / sqrt(n),
    .groups = "drop"
  )

# ラベル
data_summary$Group <- factor(
  data_summary$Group,
  levels = c(1, 0),
  labels = c("AI terms (Group 1)", "Control (Group 0)")
)

# Define color palette
color_palette <- c("#C00000", "#333F50")

# y範囲（NAを避けて計算）
yrange <- range(c(data_summary$lower_ci, data_summary$upper_ci), na.rm = TRUE)

p <- ggplot(data_summary, aes(Year, mean_usage, color = Group, fill = Group)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.2) +
  labs(x = "Year", y = "Mean Usage", color = "Group", fill = "Group") +
  scale_color_manual(values = color_palette) +
  scale_fill_manual(values = color_palette) +
  scale_y_continuous(breaks = seq(floor(min(data_summary$lower_ci)), ceiling(max(data_summary$upper_ci)), by = 1.0)) +
  theme_minimal() +
  theme(legend.position = "bottom")

# 保存
ggsave("analysis/output_plot_SA_min2000.png", p, dpi = 300, width = 8, height = 6, units = "in")
# ==== 参考：データ点数の確認 ====
message("Rows before filter: ", nrow(data))
message("Rows after  filter: ", nrow(data_sa))
