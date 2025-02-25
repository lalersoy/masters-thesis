# ------------------------------
# Within-Subject Performance Analysis (Experimental Group with 7 time points)
# ------------------------------
# Author: Deniz Lal Ersoy
# Description: 
# This script analyzes behavioral performance data from the 10-week long longitudinal study targeting motor skill acquisiton.
# It fits linear and log-transformed models, compares model performance, and visualizes results.
# ------------------------------

# Load necessary libraries
library(lme4)
library(readxl)
library(ggplot2)
library(dplyr)
library(tidyr)
library(emmeans)

# Load the dataset (update path accordingly)
data <- read_excel("data/performance.xlsx")

# Transform data into long format for analysis
data_long <- data %>%
  pivot_longer(cols = starts_with("ses"), names_to = "session", values_to = "performance") %>%
  mutate(days = case_when(
    session == "ses1" ~ 1,   # Pre-training
    session == "ses2" ~ 8,
    session == "ses3" ~ 15,  # Mid-training
    session == "ses4" ~ 22,
    session == "ses5" ~ 34,
    session == "ses6" ~ 56,
    session == "ses7" ~ 70   # Post-training
  ))

# Fit the first model (linear time effect)
model_first <- lmer(performance ~ days + (1 | ID), data = data_long)
summary(model_first)

# Posthoc pairwise comparisons
posthoc_results <- emmeans(model_first, pairwise ~ session, adjust = "tukey")
summary(posthoc_results$contrasts)

# Fit the log-transformed model
model_log <- lmer(performance ~ log(days) + (1 | ID), data = data_long)

# Model comparison
print(AIC(model_first, model_log))  # Compare using AIC
print(BIC(model_first, model_log))  # Compare using BIC

# Define early vs. late training phases
data_long$phase <- ifelse(data_long$days <= 15, "Early", "Late")  # S3 is the cutoff point
data_long$phase <- factor(data_long$phase)

# Fit interaction model (phase)
model_phase <- lmer(performance ~ log(days) * phase + (1 | ID), data = data_long)
summary(model_phase)

# Predict fitted values
fitted_values <- predict(model_log)
data_long <- na.omit(data_long)
data_long$fitted <- fitted_values

# Compute average fitted and actual performance
average_fitted <- data_long %>% group_by(days) %>% summarise(fitted = mean(fitted, na.rm = TRUE))
average_performance <- data_long %>% group_by(days) %>% summarise(mean_performance = mean(performance, na.rm = TRUE))

# Compute standard deviation and error for performance
average_performance <- data_long %>%
  group_by(days) %>%
  summarise(mean_performance = mean(performance, na.rm = TRUE),
            sd = sd(performance, na.rm = TRUE),
            se = sd / sqrt(n()))

# Plot performance trends
ggplot(data_long, aes(x = days, y = performance)) +
  geom_line(aes(group = ID), color = "gray", alpha = 0.3) +
  geom_point(aes(group = ID), color = "gray", alpha = 0.3) +
  geom_line(data = average_fitted, aes(x = days, y = fitted), color = "black", size = 1) +
  geom_line(data = average_performance, aes(x = days, y = mean_performance), color = "blue", size = 1, linetype = "dotted") +
  scale_x_continuous(breaks = c(1, 8, 15, 22, 34, 56, 70), labels = c(1, 8, 15, 22, 34, 56, 70)) +
  labs(title = "Performance Data with Mixed-Effects Model", x = "Days of Training", y = "Performance") +
  theme_minimal()
