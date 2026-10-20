
# Mortality Modeling
# Life Insurance & Pension Risk Analytics
# Synthetic mortality data for educational purposes

# 1. Define ages
ages <- 0:110

# 2. Generate synthetic mortality probabilities
# Gompertz-Makeham-inspired mortality assumption
A <- 0.0005
B <- 0.00002
c <- 1.10

mortality_rate <- A + B * c^ages
q_x <- 1 - exp(-mortality_rate)

# Assume no survival beyond the terminal age
q_x[length(q_x)] <- 1

# 3. Calculate one-year survival probabilities
p_x <- 1 - q_x

# 4. Construct a synthetic life table
l_x <- numeric(length(ages))
l_x[1] <- 100000

for (i in 2:length(ages)) {
  l_x[i] <- l_x[i - 1] * p_x[i - 1]
}

d_x <- l_x * q_x

life_table <- data.frame(
  age = ages,
  q_x = q_x,
  p_x = p_x,
  l_x = l_x,
  d_x = d_x
)

# 5. Calculate t-year survival probabilities
survival_probability <- function(x, t, table = life_table) {
  if (length(x) != 1 || length(t) != 1 ||
      !is.finite(x) || !is.finite(t) ||
      x != floor(x) || t != floor(t) ||
      x < 0 || t < 0 || x + t > max(table$age)) {
    stop("Invalid age or duration.")
  }

  if (t == 0) return(1)

  current_lives <- table$l_x[table$age == x]
  future_lives <- table$l_x[table$age == x + t]

  future_lives / current_lives
}

# 6. Calculate curtate expected future lifetime
curtate_life_expectancy <- function(x, table = life_table) {
  max_age <- max(table$age)

  if (length(x) != 1 || !is.finite(x) ||
      x != floor(x) || x < 0 || x > max_age) {
    stop("Invalid age.")
  }

  durations <- seq_len(max_age - x)

  if (length(durations) == 0) return(0)

  sum(vapply(
    durations,
    function(t) survival_probability(x, t, table),
    numeric(1)
  ))
}

# 7. Example calculations
cat("Mortality probability at age 40:",
    life_table$q_x[life_table$age == 40], "\n")

cat("10-year survival probability at age 40:",
    survival_probability(40, 10), "\n")

cat("Curtate expected future lifetime at age 40:",
    curtate_life_expectancy(40), "years\n")

# 8. Export the life table
write.csv(life_table, "mortality_table.csv", row.names = FALSE)

cat("Synthetic mortality table exported successfully.\n")
