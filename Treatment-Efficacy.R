# ==============================================
# Colon Cancer Survival Analysis
# Author: Vismaya S D
# ==============================================

# --- 0. Load Required Libraries ---
library(survival)
library(dplyr)
library(survminer)
library(ggplot2)
library(ggeffects)
library(plotly)

# --- 1. Load and Prepare Data ---
colon <- survival::colon

# Filter for death events (etype = 2)
colondeath <- colon %>%
  as_tibble() %>%
  filter(etype == 2)

head(colon)

# --- 2. Exploratory Data Analysis (EDA) ---
# Summarize baseline characteristics by treatment group
colondeath %>%
  group_by(rx) %>%
  summarise(
    N = n(),
    mean_age = mean(age, na.rm = TRUE),
    male_pct = mean(sex == 1) * 100
  )

# --- 3. Kaplan-Meier Survival Analysis ---
# Fit KM curves by treatment group
fit_km <- survfit(Surv(time, status) ~ rx, data = colondeath)

# Plot KM curves
ggsurvplot(fit_km,
           data = colondeath,
           pval = TRUE, conf.int = TRUE,
           legend.labs = levels(colondeath$rx),
           palette = c("red", "blue", "green"),
           title = "Survival by Treatment (Colon Cancer Trial)"
)

# Log-rank test for survival difference
survdiff(Surv(time, status) ~ rx, data = colondeath)

# --- 4. Cox Proportional Hazards Model ---
# Fit Cox model on full dataset
fit_cox_full <- coxph(Surv(time, status) ~ rx + age + sex + nodes, data = colon)

# Perform the test
ph_test <- cox.zph(fit_cox_full)

# Print the statistical results
# A p-value > 0.05 indicates the assumption holds for that variable.
print(ph_test)

# Create a visual plot of the Schoenfeld residuals
# If the assumption holds, the lines should be roughly flat and horizontal.
ggcoxzph(ph_test)

# Forest plot for hazard ratios
ggforest(fit_cox_full, data = colon)

# --- 5. Interaction Analysis ---
# Test if treatment effect depends on number of nodes
fit_interaction <- coxph(Surv(time, status) ~ rx * nodes + age + sex, data = colondeath)
summary(fit_interaction)

# --- 6. Stratified Survival Analysis by Node Count ---
# Determine median number of nodes
median_nodes <- median(colondeath$nodes, na.rm = TRUE)
cat("Median number of nodes is:", median_nodes, "\n")

# Create node-based risk groups
colondeath <- colondeath %>%
  mutate(node_group = ifelse(nodes <= median_nodes, "Low Nodes", "High Nodes"))

# Split data by node group
low_nodes_data <- filter(colondeath, node_group == "Low Nodes")
high_nodes_data <- filter(colondeath, node_group == "High Nodes")

# Fit KM models for each group
fit_low <- survfit(Surv(time, status) ~ rx, data = low_nodes_data)
fit_high <- survfit(Surv(time, status) ~ rx, data = high_nodes_data)

# Create KM plots for each group
plot_low <- ggsurvplot(fit_low,
                       data = low_nodes_data,
                       title = paste0("Low-Risk Group (<= ", median_nodes, " Nodes)"),
                       pval = TRUE,
                       legend.labs = levels(colondeath$rx),
                       palette = c("red", "blue", "green")
)

plot_high <- ggsurvplot(fit_high,
                        data = high_nodes_data,
                        title = paste0("High-Risk Group (> ", median_nodes, " Nodes)"),
                        pval = TRUE,
                        legend.labs = levels(colondeath$rx),
                        palette = c("red", "blue", "green")
)

# Arrange the two plots side-by-side
arrange_ggsurvplots(list(plot_low, plot_high), print = TRUE, ncol = 2, nrow = 1)

# --- 7. Interactive Kaplan-Meier Plot ---
km_plot_static <- ggsurvplot(fit_km,
                             data = colondeath,
                             pval = TRUE, conf.int = TRUE,
                             legend.labs = levels(colondeath$rx),
                             palette = c("red", "blue", "green"),
                             title = "Interactive Survival by Treatment"
)

# Convert to interactive plot (plotly)
ggplotly(km_plot_static$plot)
