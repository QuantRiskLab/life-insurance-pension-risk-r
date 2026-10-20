
# Automated Tests
# Life Insurance & Pension Risk Modeling

source("R/mortality_model.R")
source("R/life_insurance_pricing.R")
source("R/annuity_valuation.R")
source("R/pension_liabilities.R")

# Mortality probabilities
stopifnot(all(life_table$q_x >= 0))
stopifnot(all(life_table$q_x <= 1))
stopifnot(all(life_table$p_x >= 0))
stopifnot(all(life_table$p_x <= 1))
stopifnot(all(abs(life_table$q_x + life_table$p_x - 1) < 1e-10))

# Survival probabilities
stopifnot(survival_probability(40, 0) == 1)
stopifnot(survival_probability(40, 10) > 0)
stopifnot(survival_probability(40, 10) <= 1)

# Life insurance premiums
premium <- annual_net_premium(40, 20, 100000, 0.02)
stopifnot(is.finite(premium))
stopifnot(premium > 0)

# Annuity valuation
annuity <- whole_life_annuity(40, 24000, 0.02)
stopifnot(is.finite(annuity))
stopifnot(annuity > 0)

# Pension liabilities
liability <- pension_liability(40, 67, 24000, 0.02)
stopifnot(is.finite(liability))
stopifnot(liability > 0)

# Interest rate sensitivity
low_rate <- pension_liability(40, 67, 24000, 0.01)
high_rate <- pension_liability(40, 67, 24000, 0.04)
stopifnot(low_rate > high_rate)

# Longevity risk: lower mortality increases annuity value
source("R/longevity_risk.R")

improved_table <- improve_mortality(life_table, 0.10)

improved_liability <- pension_liability(
  40, 67, 24000, 0.02, improved_table
)

stopifnot(improved_liability > liability)

cat("All actuarial model tests passed.\n")
