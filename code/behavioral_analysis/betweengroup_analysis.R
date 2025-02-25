# ------------------------------
# Between-Subject Performance Analysis (Experimental vs. Control)
# ------------------------------
# Author: Deniz Lal Ersoy
# Date: 2024-04-30
# Description:
# - This script compares pre-training vs. post-training performance between experimental and control groups.
# - Uses mixed-effects modeling for statistical analysis.
# - Generates an interaction plot with means and standard errors.
#
# Dependencies:
# - lme4: Mixed-effects modeling
# - emmeans: Post-hoc tests
# - ggplot2, dplyr, tidyr: Data wrangling & visualization
# ------------------------------

# Install necessary packages
install.packages(c("readxl", "dplyr", "ggplot2", "tidyr", "lme4", "emmeans"), dependencies = TRUE)

# Load required libraries
library(lme4)       # Mixed-effects models
library(emmeans)    # Post-hoc comparisons
library(readxl)     # Read Excel files
library(dplyr)      # Data manipulation
library(ggplot2)    # Visualization
library(tidyr)      # Data reshaping

# Load the Excel file (UPDATE PATH IF NEEDED)
data <- read_excel("data/exp_control_perf.xlsx")  

# Convert group variable to categorical factor
data$group <- as.factor(data$group)

# Reshape the data into long format for easier plotting & analysis
data_perf <- melt(data, id.vars = c("subject_id", "group"), # IDs remain constant
                  measure.vars = c("Pre_training", "Post_training"), 
                  variable.name = "time", value.name = "performance")
data_perf$time <- factor(data_perf$time, levels = c("Pre_training", "Post_training"))

# Mixed-Effects Model
# - Includes **group × time interaction**
# - Random intercept for each subject
model <- lmer(performance ~ group * time + (1|subject_id), data = data_perf) 
summary(model)

# Post-Hoc Comparisons
emmeans_results <- emmeans(model, ~ group * time)
pairs(emmeans_results)

# Compute Mean & Standard Error for Plot
interaction_plot <- data_perf %>%
  group_by(group, time) %>%
  summarise(mean_performance = mean(performance),
            se_performance = sd(performance) / sqrt(n()))

# Interaction Plot: Performance by Group & Time
plot <- ggplot(interaction_plot, aes(x = time, y = mean_performance, group = group, linetype = group, shape = group)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = mean_performance - se_performance, ymax = mean_performance + se_performance), width = 0.1) +
  scale_linetype_manual(values = c("dashed", "solid")) +
  scale_shape_manual(values = c(16, 15)) +  # Different shapes for points
  labs(title = "Interaction Plot of Performance by Group and Time",
       x = "Time",
       y = "Mean Performance (seconds)") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    legend.title = element_blank(),  
    legend.text = element_text(size = 12),
    legend.position = "top"
  )

print(plot)

# Save Results for LaTeX
# Save interaction plot data for LaTeX reproduction
write.csv(interaction_plot, "results/behavioral/interaction_plot_data.csv", row.names = FALSE)

# Convert time to numerical encoding for LaTeX
interaction_plot$time_numeric <- as.numeric(interaction_plot$time)
write.csv(interaction_plot, "results/behavioral/sorted_interaction_plot_data.csv", row.names = FALSE)

