# 必要なライブラリの読み込み
library(readr)
library(stringr)
library(dplyr)
library(purrr)
library(tidyr)

# CSVファイルがあるディレクトリ
directory <- "C:/Users/30071/Dropbox/（進行中）/_①ChatGPT_frequent terms/2000-2024.04 - コピー"

# ディレクトリ内の全CSVファイルをリストアップ
file_list <- list.files(directory, pattern = "*.csv", full.names = TRUE)

# 2000年から2024年までの年のベクトルを降順で作成
years <- 2024:2000
year_df <- data.frame(Year = years)

# 各ファイルからデータを読み込み、2000-2024年のデータのみ抽出して横に結合
merged_data <- lapply(file_list, function(file) {
  data <- read_csv(file, skip = 1, show_col_types = FALSE)[, 1:2]  # 最初の2列だけ取得
  col_names <- str_remove(basename(file), "\\.csv")
  names(data) <- c("Year", "Count")
  
  # 2000-2024年のデータのみ抽出
  data <- data %>% filter(Year >= 2000, Year <= 2024)
  
  # 欠損している年を補完し、CountがNAの場合は0を代入
  data <- year_df %>% left_join(data, by = "Year") %>% mutate(Count = replace_na(Count, 0))
  
  # 列名をファイル名に基づいて変更し、_Countを削除
  names(data) <- c("Year", col_names)
  
  data
}) %>% reduce(full_join, by = "Year")  # 年をキーにしてフルジョイン

# 結果をCSVファイルに保存
write_csv(merged_data, "C:/Users/30071/Dropbox/（進行中）/_①ChatGPT_frequent terms/_merged_data.csv")