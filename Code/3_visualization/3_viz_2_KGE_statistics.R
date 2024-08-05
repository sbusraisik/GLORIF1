# Load necessary libraries
library(dplyr)
library(ggplot2)

# Define the paths to the CSV files
pcr_file_path <- '/scratch-shared/bisik/Practical_NEW/reanalysis_NEW_95_filtered/validation/KGE_results_PCR_GSIM_validation.csv'
rf_file_path <- '/scratch-shared/bisik/Practical_NEW/reanalysis_NEW_95_filtered/validation/KGE_results_RF_GSIM_validation.csv'

# Load the CSV files
kge_results_pcr <- read.csv(pcr_file_path)
kge_results_rf <- read.csv(rf_file_path)

# Filter the KGE values to be within the expected range
kge_results_pcr <- kge_results_pcr %>%
  filter(KGE >= -1 & KGE <= 1)
kge_results_rf <- kge_results_rf %>%
  filter(KGE >= -1 & KGE <= 1)

# Perform an inner join to only include matching rows
matched_results <- inner_join(kge_results_pcr, kge_results_rf, by = c("cell_no_land", "gsim.no"), suffix = c("_PCR", "_RF"))

# Display the first few rows of the matched dataframe to understand its structure
head(matched_results)

# Step 1: Overall Performance Comparison
performance_summary <- data.frame(
  Metric = c("KGE", "NSE", "RMSE", "MAE", "nRMSE", "nMAE"),
  PCR_Average = c(
    mean(matched_results$KGE_PCR, na.rm = TRUE),
    mean(matched_results$NSE_PCR, na.rm = TRUE),
    mean(matched_results$RMSE_PCR, na.rm = TRUE),
    mean(matched_results$MAE_PCR, na.rm = TRUE),
    mean(matched_results$nRMSE_PCR, na.rm = TRUE),
    mean(matched_results$nMAE_PCR, na.rm = TRUE)
  ),
  RF_Average = c(
    mean(matched_results$KGE_RF, na.rm = TRUE),
    mean(matched_results$NSE_RF, na.rm = TRUE),
    mean(matched_results$RMSE_RF, na.rm = TRUE),
    mean(matched_results$MAE_RF, na.rm = TRUE),
    mean(matched_results$nRMSE_RF, na.rm = TRUE),
    mean(matched_results$nMAE_RF, na.rm = TRUE)
  )
)

# Save performance summary to CSV
write.csv(performance_summary, '/scratch-shared/bisik/Practical_NEW/reanalysis_NEW_95_filtered/validation/performance_summary.csv', row.names = FALSE)

# Step 2: Distribution Analysis
g1 <- ggplot(matched_results, aes(x = KGE_PCR)) +
  geom_histogram(fill = "blue", bins = 30, alpha = 0.5) +
  labs(title = "KGE Distribution - PCR Dataset", x = "KGE", y = "Frequency") +
  theme_minimal()

g2 <- ggplot(matched_results, aes(x = KGE_RF)) +
  geom_histogram(fill = "green", bins = 30, alpha = 0.5) +
  labs(title = "KGE Distribution - RF Dataset", x = "KGE", y = "Frequency") +
  theme_minimal()

# Save the distribution plots
ggsave('/scratch-shared/bisik/Practical_NEW/reanalysis_NEW_95_filtered/validation/kge_distribution_pcr.png', plot = g1)
ggsave('/scratch-shared/bisik/Practical_NEW/reanalysis_NEW_95_filtered/validation/kge_distribution_rf.png', plot = g2)

# Step 3: Scatter Plot of KGE Values
#g3 <- ggplot(matched_results, aes(x = KGE_PCR, y = KGE_RF)) +
#  geom_point() +
#  labs(title = "Comparison of KGE Values between PCR and RF Datasets", x = "KGE (PCR)", y = "KGE (RF)") +
#  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
#  theme_minimal()

# Save the scatter plot
#ggsave('/scratch-shared/bisik/Practical_NEW/reanalysis_NEW_95_filtered/validation/kge_comparison_scatter.png', plot = g3)

# Step 4: Correlation Analysis
#correlation <- cor(matched_results$KGE_PCR, matched_results$KGE_RF, use = "complete.obs")

# Step 5: Summary Statistics
summary_stats_pcr <- summary(matched_results %>% select(contains("_PCR")))
summary_stats_rf <- summary(matched_results %>% select(contains("_RF")))

print(performance_summary)
print(summary_stats_pcr)
print(summary_stats_rf)
#print(correlation)

# Save summary statistics to CSV
write.csv(as.data.frame(summary_stats_pcr), '/scratch-shared/bisik/Practical_NEW/reanalysis_NEW_95_filtered/validation/summary_stats_pcr.csv')
write.csv(as.data.frame(summary_stats_rf), '/scratch-shared/bisik/Practical_NEW/reanalysis_NEW_95_filtered/validation/summary_stats_rf.csv')

# Detailed Comparison of Performance Metrics
summary_comparison <- data.frame(
  Metric = c("KGE", "NSE", "RMSE", "MAE", "nRMSE", "nMAE"),
  PCR_Mean = c(
    mean(matched_results$KGE_PCR, na.rm = TRUE),
    mean(matched_results$NSE_PCR, na.rm = TRUE),
    mean(matched_results$RMSE_PCR, na.rm = TRUE),
    mean(matched_results$MAE_PCR, na.rm = TRUE),
    mean(matched_results$nRMSE_PCR, na.rm = TRUE),
    mean(matched_results$nMAE_PCR, na.rm = TRUE)
  ),
  RF_Mean = c(
    mean(matched_results$KGE_RF, na.rm = TRUE),
    mean(matched_results$NSE_RF, na.rm = TRUE),
    mean(matched_results$RMSE_RF, na.rm = TRUE),
    mean(matched_results$MAE_RF, na.rm = TRUE),
    mean(matched_results$nRMSE_RF, na.rm = TRUE),
    mean(matched_results$nMAE_RF, na.rm = TRUE)
  ),
  PCR_Median = c(
    median(matched_results$KGE_PCR, na.rm = TRUE),
    median(matched_results$NSE_PCR, na.rm = TRUE),
    median(matched_results$RMSE_PCR, na.rm = TRUE),
    median(matched_results$MAE_PCR, na.rm = TRUE),
    median(matched_results$nRMSE_PCR, na.rm = TRUE),
    median(matched_results$nMAE_PCR, na.rm = TRUE)
  ),
  RF_Median = c(
    median(matched_results$KGE_RF, na.rm = TRUE),
    median(matched_results$NSE_RF, na.rm = TRUE),
    median(matched_results$RMSE_RF, na.rm = TRUE),
    median(matched_results$MAE_RF, na.rm = TRUE),
    median(matched_results$nRMSE_RF, na.rm = TRUE),
    median(matched_results$nMAE_RF, na.rm = TRUE)
  ),
  PCR_Std = c(
    sd(matched_results$KGE_PCR, na.rm = TRUE),
    sd(matched_results$NSE_PCR, na.rm = TRUE),
    sd(matched_results$RMSE_PCR, na.rm = TRUE),
    sd(matched_results$MAE_PCR, na.rm = TRUE),
    sd(matched_results$nRMSE_PCR, na.rm = TRUE),
    sd(matched_results$nMAE_PCR, na.rm = TRUE)
  ),
  RF_Std = c(
    sd(matched_results$KGE_RF, na.rm = TRUE),
    sd(matched_results$NSE_RF, na.rm = TRUE),
    sd(matched_results$RMSE_RF, na.rm = TRUE),
    sd(matched_results$MAE_RF, na.rm = TRUE),
    sd(matched_results$nRMSE_RF, na.rm = TRUE),
    sd(matched_results$nMAE_RF, na.rm = TRUE)
  ),
  PCR_Min = c(
    min(matched_results$KGE_PCR, na.rm = TRUE),
    min(matched_results$NSE_PCR, na.rm = TRUE),
    min(matched_results$RMSE_PCR, na.rm = TRUE),
    min(matched_results$MAE_PCR, na.rm = TRUE),
    min(matched_results$nRMSE_PCR, na.rm = TRUE),
    min(matched_results$nMAE_PCR, na.rm = TRUE)
  ),
  RF_Min = c(
    min(matched_results$KGE_RF, na.rm = TRUE),
    min(matched_results$NSE_RF, na.rm = TRUE),
    min(matched_results$RMSE_RF, na.rm = TRUE),
    min(matched_results$MAE_RF, na.rm = TRUE),
    min(matched_results$nRMSE_RF, na.rm = TRUE),
    min(matched_results$nMAE_RF, na.rm = TRUE)
  ),
  PCR_Max = c(
        max(matched_results$KGE_PCR, na.rm = TRUE),
    max(matched_results$NSE_PCR, na.rm = TRUE),
    max(matched_results$RMSE_PCR, na.rm = TRUE),
    max(matched_results$MAE_PCR, na.rm = TRUE),
    max(matched_results$nRMSE_PCR, na.rm = TRUE),
    max(matched_results$nMAE_PCR, na.rm = TRUE)
  ),
  RF_Max = c(
    max(matched_results$KGE_RF, na.rm = TRUE),
    max(matched_results$NSE_RF, na.rm = TRUE),
    max(matched_results$RMSE_RF, na.rm = TRUE),
    max(matched_results$MAE_RF, na.rm = TRUE),
    max(matched_results$nRMSE_RF, na.rm = TRUE),
    max(matched_results$nMAE_RF, na.rm = TRUE)
  )
)

# Save the detailed performance comparison to CSV
write.csv(summary_comparison, '/scratch-shared/bisik/Practical_NEW/reanalysis_NEW_95_filtered/validation/summary_comparison.csv', row.names = FALSE)


# Boxplot comparison
g4 <- ggplot(matched_results, aes(x = factor("PCR"), y = KGE_PCR)) +
  geom_boxplot(fill = "blue") +
  geom_boxplot(data = matched_results, aes(x = factor("GLORIF1"), y = KGE_RF), fill = "green") +
  labs(x = "", y = "KGE") +
  theme_minimal(base_size = 14) + # Increase base font size
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 16)
  )

# Histogram comparison
g5 <- ggplot() +
  geom_histogram(data = matched_results, aes(x = KGE_PCR), fill = "blue", bins = 30, alpha = 0.5) +
  geom_histogram(data = matched_results, aes(x = KGE_RF), fill = "green", bins = 30, alpha = 0.5) +
  labs(x = "KGE", y = "Frequency") +
  theme_minimal(base_size = 14) + # Increase base font size
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 16)
  )

# Save the visual comparison plots
ggsave('/scratch-shared/bisik/Practical_NEW/reanalysis_NEW_95_filtered/validation/kge_boxplot.pdf', plot = g4)
ggsave('/scratch-shared/bisik/Practical_NEW/reanalysis_NEW_95_filtered/validation/kge_histogram.pdf', plot = g5)

# Paired t-test
#t_test_result <- t.test(matched_results$KGE_PCR, matched_results$KGE_RF, paired = TRUE)

# Save the t-test result
#t_test_summary <- data.frame(
#  Statistic = t_test_result$statistic,
#  P_Value = t_test_result$p.value,
#  Confidence_Interval_Lower = t_test_result$conf.int[1],
#  Confidence_Interval_Upper = t_test_result$conf.int[2]
#)
#write.csv(t_test_summary, '/scratch-shared/bisik/Practical_NEW/reanalysis_NEW_95_filtered/validation/t_test_summary.csv', row.names = FALSE)

# Print outputs to console
print(performance_summary)
print(summary_stats_pcr)
print(summary_stats_rf)
#print(correlation)
#print(t_test_summary)

