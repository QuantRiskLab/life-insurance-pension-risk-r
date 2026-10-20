
# Life Insurance Pricing
# Term life insurance using a synthetic mortality table

source("R/mortality_model.R")

# Expected present value of term life insurance
term_insurance_epv <- function(x, term, sum_insured, interest_rate,
                               table = life_table) {
  if (length(x) != 1 || length(term) != 1 ||
      !is.finite(x) || !is.finite(term) ||
      x != floor(x) || term != floor(term) ||
      x < 0 || term < 1 ||
      x + term > max(table$age)) {
    stop("Invalid age or insurance term.")
  }

  if (!is.finite(sum_insured) || sum_insured <= 0 ||
      !is.finite(interest_rate) || interest_rate <= -1) {
    stop("Invalid sum insured or interest rate.")
  }

  v <- 1 / (1 + interest_rate)

  sum(v^(seq_len(term)) *
      vapply(seq_len(term), function(k) {
        survival_probability(x, k - 1, table) *
          table$q_x[table$age == x + k - 1]
      }, numeric(1))) * sum_insured
}

# Expected present value of annual premiums paid in advance
premium_annuity_epv <- function(x, term, interest_rate,
                                table = life_table) {
  if (length(x) != 1 || length(term) != 1 ||
      !is.finite(x) || !is.finite(term) ||
      x != floor(x) || term != floor(term) ||
      x < 0 || term < 1 ||
      x + term > max(table$age)) {
    stop("Invalid age or insurance term.")
  }

  if (!is.finite(interest_rate) || interest_rate <= -1) {
    stop("Invalid interest rate.")
  }

  v <- 1 / (1 + interest_rate)

  sum(v^(0:(term - 1)) *
      vapply(0:(term - 1), function(k) {
        survival_probability(x, k, table)
      }, numeric(1)))
}

# Annual net premium based on the equivalence principle
annual_net_premium <- function(x, term, sum_insured, interest_rate,
                               table = life_table) {
  benefit_epv <- term_insurance_epv(
    x, term, sum_insured, interest_rate, table
  )

  premium_epv <- premium_annuity_epv(
    x, term, interest_rate, table
  )

  benefit_epv / premium_epv
}

# Example: 20-year term insurance
age <- 40
term <- 20
sum_insured <- 100000
interest_rate <- 0.02

net_premium <- annual_net_premium(
  age, term, sum_insured, interest_rate
)

cat("Annual net premium:", round(net_premium, 2), "EUR\n")
