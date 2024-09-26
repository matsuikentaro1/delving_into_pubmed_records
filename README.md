Project: Delving into PubMed records

Overview
This repository contains the R code, data, and results used for the analysis in the study titled "Delving into PubMed records: some terms in medical writing have drastically changed after the arrival of ChatGPT." The goal of this project is to analyze trends in PubMed data between 2000 and 2024 using various statistical and predictive methods, including linear mixed-effects models and ARIMA modeling.

Repository Structure
- analysis/: Contains the R scripts and outputs related to the analysis.
  - ARIMA_predictions_results.csv: Results of ARIMA model predictions.
  - FIG1_50_110.png: The upper part of Fig. 1
  - FIG1_-10_50.png: The lower part of Fig. 1
  - merged_data.csv: The merged dataset used for analysis.
  - results_2000-2024_modified_z-score.csv: Modified Z-score calculations based on the 2000-2024 dataset.
  - output_plot.png: A plot for Fig 2.
- data/: Contains raw and processed data used in the analysis.
  - data_for_Figure1.csv: Data used to generate Fig 1.
  - data_for_linear_mixed_effects_model.csv: Data prepared for the linear mixed-effects model analysis.
  - UseRate_2000-2024.csv: Raw data from 2000 to 2024.
- materials/: Includes supporting materials or additional datasets.
  - Various CSV files such as _Total Records.csv, align.csv, etc., contain auxiliary data for different analytical purposes.

Requirements
To run the analysis, you will need the following dependencies:
- R version 4.3.2 or higher
- R packages:
  - ggplot2
  - dplyr
  - lme4 (for linear mixed-effects models)
  - forecast (for ARIMA model)
  
You can install the required packages by running the following command in R:
install.packages(c("ggplot2", "dplyr", "forecast", "lme4"))

Running the Analysis
1. Clone this repository to your local machine:
   git clone https://github.com/yourusername/Project-Delving-Into-PubMed.git
2. Open the R project file located in the repository using RStudio.
3. Make sure all necessary packages are installed.
4. Run the main script for the analysis located in the analysis/ directory:
   source("analysis/main_analysis.R")

Data
The data files are located in the data/ directory. These include:
- data_for_Figure1.csv: Data used for creating Figure 1, representing key trends in PubMed records.
- UseRate_2000-2024.csv: Raw data detailing the use rate of certain terms in PubMed from 2000 to 2024.

Results
The results, including plots and calculated metrics (e.g., modified Z-scores, ARIMA predictions), are saved in the analysis/ directory. You can find figures and processed data outputs like results_2000-2024_modified_z-score.csv.

License
This repository is licensed under the MIT License. See the LICENSE file for more details.

Contact
For questions or clarifications regarding this analysis, please contact:
- Kentaro Matsui
- matsui.kentaro@ncnp.go.jp
- Department of Clinical Laboratory, National Center Hospital, National Center of Neurology and Psychiatry
