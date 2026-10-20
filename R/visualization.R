
# Actuarial Risk Visualizations
# Life Insurance & Pension Risk Modeling

source("R/interest_rate_sensitivity.R")
source("R/longevity_risk.R")

# Create output directory
dir.create("figures", showWarnings = FALSE)

# 1. Mortality probability by age
png("figures/mortality_probability.png",
    width = 1000, height = 650)

plot(
  life_table$age,
  life_table$q_x,
  type = "l",
  lwd = 2,
  col = "steelblue",
  xlab = "Age",
  ylab = "One-Year Mortality Probability",
  main = "Synthetic Mortality Probability by Age"
)

grid()
dev.off()

# 2. Survival curve
png("figures/survival_curve.png",
    width = 1000, height = 650)

plot(
  life_table$age,
  life_table$l_x / life_table$l_x[1],
  type = "l",
  lwd = 2,
  col = "darkgreen",
  xlab = "Age",
  ylab = "Survival Probability from Birth",
  main = "Synthetic Survival Curve"
)

grid()
dev.off()

# 3. Interest rate sensitivity
png("figures/interest_rate_sensitivity.png",
    width = 1000, height = 650)

plot(
  sensitivity_results$interest_rate_percent,
  sensitivity_results$total_liability / 1e6,
  type = "b",
  pch = 19,
  lwd = 2,
  col = "steelblue",
  xlab = "Interest Rate (%)",
  ylab = "Pension Liability (EUR Millions)",
  main = "Interest Rate Sensitivity"
)

grid()
dev.off()

# 4. Longevity risk distribution
png("figures/longevity_risk_distribution.png",
    width = 1000, height = 650)

hist(
  longevity_results$liability_increase / 1e6,
  breaks = 30,
  col = "lightblue",
  border = "white",
  main = "Longevity Risk: Increase in Pension Liabilities",
  xlab = "Liability Increase (EUR Millions)"
)

abline(v = var_99 / 1e6, col = "red", lwd = 2, lty = 2)
abline(v = es_99 / 1e6, col = "darkorange", lwd = 2, lty = 2)

legend(
  "topright",
  legend = c("99% VaR", "99% Expected Shortfall"),
  col = c("red", "darkorange"),
  lty = 2,
  lwd = 2,
  bty = "n"
)

dev.off()

cat("All actuarial visualizations generated successfully.\n")
