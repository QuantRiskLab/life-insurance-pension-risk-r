
# Interest Rate Sensitivity Analysis
# Life Insurance & Pension Risk Modeling

source("R/pension_liabilities.R")

# Define interest rate scenarios
interest_rates <- seq(0.005, 0.05, by = 0.005)

# Calculate portfolio liabilities under each scenario
total_liabilities <- vapply(
  interest_rates,
  function(rate) {
    results <- calculate_portfolio_liabilities(
      pension_portfolio,
      interest_rate = rate
    )
    sum(results$liability)
  },
  numeric(1)
)

# Store sensitivity results
sensitivity_results <- data.frame(
  interest_rate = interest_rates,
  interest_rate_percent = interest_rates * 100,
  total_liability = total_liabilities
)

# Calculate percentage change relative to the 2% base scenario
base_liability <- sum(
  calculate_portfolio_liabilities(
    pension_portfolio,
    interest_rate = 0.02
  )$liability
)

sensitivity_results$change_percent <- (
  sensitivity_results$total_liability / base_liability - 1
) * 100

# Export results
write.csv(
  sensitivity_results,
  "interest_rate_sensitivity_results.csv",
  row.names = FALSE
)

# Display results
print(sensitivity_results)

# Plot interest rate sensitivity
png(
  filename = "interest_rate_sensitivity.png",
  width = 1000,
  height = 650
)

plot(
  sensitivity_results$interest_rate_percent,
  sensitivity_results$total_liability / 1e6,
  type = "b",
  pch = 19,
  col = "steelblue",
  xlab = "Interest Rate (%)",
  ylab = "Total Pension Liability (EUR Millions)",
  main = "Interest Rate Sensitivity of Pension Liabilities"
)

grid()

dev.off()

cat("Interest rate sensitivity analysis completed.\n")
