
# Pension Liability Valuation
# Life Insurance & Pension Risk Modeling

source("R/annuity_valuation.R")

# Present value of a deferred lifetime pension
pension_liability <- function(current_age, retirement_age,
                              annual_pension, interest_rate,
                              table = life_table) {
  if (length(current_age) != 1 ||
      length(retirement_age) != 1 ||
      !is.finite(current_age) ||
      !is.finite(retirement_age) ||
      current_age != floor(current_age) ||
      retirement_age != floor(retirement_age) ||
      current_age < 0 ||
      retirement_age < current_age ||
      retirement_age > max(table$age)) {
    stop("Invalid current age or retirement age.")
  }

  if (length(annual_pension) != 1 ||
      !is.finite(annual_pension) ||
      annual_pension < 0 ||
      length(interest_rate) != 1 ||
      !is.finite(interest_rate) ||
      interest_rate <= -1) {
    stop("Invalid pension amount or interest rate.")
  }

  deferred_life_annuity(
    x = current_age,
    deferment = retirement_age - current_age,
    annual_payment = annual_pension,
    interest_rate = interest_rate,
    table = table
  )
}

# Calculate liabilities for a pension portfolio
calculate_portfolio_liabilities <- function(portfolio,
                                            interest_rate) {
  required_columns <- c(
    "current_age", "retirement_age", "annual_pension"
  )

  if (!all(required_columns %in% names(portfolio))) {
    stop("Missing required portfolio columns.")
  }

  portfolio$liability <- mapply(
    pension_liability,
    current_age = portfolio$current_age,
    retirement_age = portfolio$retirement_age,
    annual_pension = portfolio$annual_pension,
    MoreArgs = list(interest_rate = interest_rate)
  )

  portfolio
}

# Synthetic pension portfolio
set.seed(42)

n_members <- 1000

pension_portfolio <- data.frame(
  member_id = seq_len(n_members),
  current_age = sample(30:65, n_members, replace = TRUE),
  retirement_age = rep(67, n_members),
  annual_pension = round(
    runif(n_members, min = 12000, max = 36000),
    2
  )
)

interest_rate <- 0.02

pension_results <- calculate_portfolio_liabilities(
  pension_portfolio,
  interest_rate
)

total_liability <- sum(pension_results$liability)

cat("Number of pension members:", n_members, "\n")
cat("Total pension liability:",
    round(total_liability, 2), "EUR\n")
cat("Average pension liability:",
    round(mean(pension_results$liability), 2), "EUR\n")

write.csv(
  pension_results,
  "pension_liabilities_results.csv",
  row.names = FALSE
)
