
# Life Annuity Valuation
# Life Insurance & Pension Risk Modeling

source("R/mortality_model.R")

# Temporary life annuity paid annually in advance
temporary_life_annuity <- function(x, term, annual_payment,
                                   interest_rate, table = life_table) {
  if (length(x) != 1 || length(term) != 1 ||
      !is.finite(x) || !is.finite(term) ||
      x != floor(x) || term != floor(term) ||
      x < 0 || term < 1 ||
      x + term - 1 > max(table$age)) {
    stop("Invalid age or annuity term.")
  }

  if (length(annual_payment) != 1 ||
      !is.finite(annual_payment) || annual_payment < 0 ||
      length(interest_rate) != 1 ||
      !is.finite(interest_rate) || interest_rate <= -1) {
    stop("Invalid payment or interest rate.")
  }

  v <- 1 / (1 + interest_rate)

  payment_times <- 0:(term - 1)

  survival_probs <- vapply(
    payment_times,
    function(t) survival_probability(x, t, table),
    numeric(1)
  )

  annual_payment * sum(v^payment_times * survival_probs)
}

# Whole life annuity paid annually in advance
whole_life_annuity <- function(x, annual_payment,
                               interest_rate, table = life_table) {
  max_age <- max(table$age)

  if (length(x) != 1 || !is.finite(x) ||
      x != floor(x) || x < 0 || x > max_age) {
    stop("Invalid age.")
  }

  temporary_life_annuity(
    x = x,
    term = max_age - x + 1,
    annual_payment = annual_payment,
    interest_rate = interest_rate,
    table = table
  )
}

# Deferred whole life annuity
deferred_life_annuity <- function(x, deferment, annual_payment,
                                  interest_rate, table = life_table) {
  max_age <- max(table$age)

  if (length(x) != 1 || length(deferment) != 1 ||
      !is.finite(x) || !is.finite(deferment) ||
      x != floor(x) || deferment != floor(deferment) ||
      x < 0 || deferment < 0 ||
      x + deferment > max_age) {
    stop("Invalid age or deferment period.")
  }

  v <- 1 / (1 + interest_rate)

  v^deferment *
    survival_probability(x, deferment, table) *
    whole_life_annuity(
      x + deferment, annual_payment, interest_rate, table
    )
}

# Example calculations
age <- 40
retirement_age <- 67
annual_pension <- 24000
interest_rate <- 0.02

immediate_annuity <- whole_life_annuity(
  age, annual_pension, interest_rate
)

deferred_annuity <- deferred_life_annuity(
  age,
  retirement_age - age,
  annual_pension,
  interest_rate
)

cat("Whole life annuity present value:",
    round(immediate_annuity, 2), "EUR\n")

cat("Deferred pension annuity present value:",
    round(deferred_annuity, 2), "EUR\n")
