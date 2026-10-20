
# Longevity Risk Modeling
# Life Insurance & Pension Risk Modeling

source("R/pension_liabilities.R")

set.seed(123)

# Base mortality assumptions
base_table <- life_table

# Mortality improvement scenario
improve_mortality <- function(table, improvement_rate) {
  if (length(improvement_rate) != 1 ||
      !is.finite(improvement_rate) ||
      improvement_rate < 0 || improvement_rate >= 1) {
    stop("Invalid mortality improvement rate.")
  }

  improved_table <- table

  # Reduce mortality probabilities except at terminal age
  improved_table$q_x <- table$q_x * (1 - improvement_rate)
  improved_table$q_x[nrow(improved_table)] <- 1

  improved_table$p_x <- 1 - improved_table$q_x

  # Recalculate survivors
  improved_table$l_x <- numeric(nrow(improved_table))
  improved_table$l_x[1] <- table$l_x[1]

  for (i in 2:nrow(improved_table)) {
    improved_table$l_x[i] <-
      improved_table$l_x[i - 1] * improved_table$p_x[i - 1]
  }

  improved_table$d_x <-
    improved_table$l_x * improved_table$q_x

  improved_table
}

# Calculate total portfolio liability for a mortality scenario
portfolio_liability_scenario <- function(table, portfolio,
                                         interest_rate) {
  sum(vapply(
    seq_len(nrow(portfolio)),
    function(i) {
      pension_liability(
        current_age = portfolio$current_age[i],
        retirement_age = portfolio$retirement_age[i],
        annual_pension = portfolio$annual_pension[i],
        interest_rate = interest_rate,
        table = table
      )
    },
    numeric(1)
  ))
}

# Baseline portfolio liability
base_liability <- portfolio_liability_scenario(
  base_table,
  pension_portfolio,
  interest_rate = 0.02
)

# Simulate mortality improvement scenarios
n_simulations <- 1000

mortality_improvements <- runif(
  n_simulations,
  min = 0,
  max = 0.20
)

# Precalculate the pension portfolio by age and pension amount
portfolio_groups <- aggregate(
  annual_pension ~ current_age + retirement_age,
  data = pension_portfolio,
  FUN = sum
)

# Evaluate scenario liabilities
scenario_liabilities <- vapply(
  mortality_improvements,
  function(improvement) {
    scenario_table <- improve_mortality(
      base_table,
      improvement
    )

    portfolio_liability_scenario(
      scenario_table,
      portfolio_groups,
      interest_rate = 0.02
    )
  },
  numeric(1)
)

# Calculate risk measures
liability_increases <- scenario_liabilities - base_liability

var_99 <- as.numeric(
  quantile(liability_increases, probs = 0.99)
)

es_99 <- mean(
  liability_increases[liability_increases >= var_99]
)

# Store simulation results
longevity_results <- data.frame(
  simulation = seq_len(n_simulations),
  mortality_improvement = mortality_improvements,
  total_liability = scenario_liabilities,
  liability_increase = liability_increases
)

write.csv(
  longevity_results,
  "longevity_risk_results.csv",
  row.names = FALSE
)

cat("Baseline pension liability:",
    round(base_liability, 2), "EUR\n")

cat("99% VaR of liability increase:",
    round(var_99, 2), "EUR\n")

cat("99% Expected Shortfall:",
    round(es_99, 2), "EUR\n")
