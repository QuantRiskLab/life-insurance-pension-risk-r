
# Life Insurance & Pension Risk Modeling in R

![R](https://img.shields.io/badge/Language-R-276DC3)
![Actuarial Science](https://img.shields.io/badge/Domain-Actuarial%20Science-blue)
![GitHub Actions](https://github.com/QuantRiskLab/life-insurance-pension-risk-r/actions/workflows/r-tests.yml/badge.svg)

## Project Overview

An actuarial modeling project developed in R to explore life insurance pricing, pension liability valuation, interest rate sensitivity, and longevity risk.

The project demonstrates the application of actuarial mathematics, probability theory, discounted cash flow valuation, and quantitative risk analysis to synthetic insurance and pension portfolios.

All mortality assumptions and portfolio data are synthetic and intended for educational and portfolio demonstration purposes.

## Key Features

- Synthetic mortality modeling and life table construction
- Survival probabilities and curtate life expectancy
- Term life insurance valuation and annual net premiums
- Temporary, whole-life, and deferred annuity valuation
- Pension liability modeling for a synthetic portfolio of 1,000 members
- Interest rate sensitivity analysis
- Monte Carlo simulation of mortality improvement scenarios
- Value at Risk (VaR) and Expected Shortfall (ES)
- Actuarial data visualization
- Automated model testing with GitHub Actions

## Repository Structure

```text
life-insurance-pension-risk-r/
├── R/
│   ├── mortality_model.R
│   ├── life_insurance_pricing.R
│   ├── annuity_valuation.R
│   ├── pension_liabilities.R
│   ├── interest_rate_sensitivity.R
│   ├── longevity_risk.R
│   └── visualization.R
├── tests/
│   └── test_models.R
├── .github/
│   └── workflows/
│       └── r-tests.yml
└── README.md
```

## 1. Mortality Modeling

The project uses a synthetic mortality model inspired by the Gompertz-Makeham law.

The one-year mortality probability is modeled as:

$$
q_x = 1 - \exp\left[-(A + Bc^x)\right]
$$

The corresponding one-year survival probability is:

$$
p_x = 1-q_x
$$

The life table includes:

- Age
- Mortality probability
- Survival probability
- Number of survivors
- Number of deaths

## 2. Term Life Insurance Pricing

The expected present value of a term life insurance benefit is calculated using mortality probabilities and discount factors.

For a benefit payable at the end of the year of death:

$$
EPV = S \sum_{k=0}^{n-1}
v^{k+1}\,{}_kp_x\,q_{x+k}
$$

where:

- S is the sum insured
- v is the annual discount factor
- n is the insurance term
- x is the policyholder's entry age

The annual net premium is obtained by dividing the expected present value of benefits by the expected present value of premium payments.

## 3. Life Annuity Valuation

The project implements:

- Temporary life annuities
- Whole-life annuities
- Deferred life annuities

For an annuity-due with annual payment C:

$$
PV = C\sum_{k=0}^{n-1}v^k\,{}_kp_x
$$

These models provide the foundation for valuing future retirement benefits.

## 4. Pension Liability Valuation

A synthetic pension portfolio of 1,000 members is generated with varying:

- Current ages
- Retirement ages
- Annual pension benefits

The present value of future pension payments is calculated for each member.

Total portfolio liability is:

$$
L = \sum_{i=1}^{N} L_i
$$

where L_i represents the present value of the pension obligation for member i.

## 5. Interest Rate Sensitivity

Pension liabilities are evaluated under annual interest rate scenarios from 0.5% to 5%.

The analysis demonstrates the sensitivity of discounted pension obligations to changes in valuation interest rates.

Higher discount rates generally reduce the present value of future pension payments.

## 6. Longevity Risk Simulation

The project models longevity risk by reducing mortality probabilities under simulated improvement scenarios.

A Monte Carlo simulation with 1,000 scenarios evaluates changes in total pension liabilities.

The resulting liability increases are used to estimate:

- 99% Value at Risk
- 99% Expected Shortfall

The mortality improvement assumptions are illustrative rather than calibrated forecasts.

## 7. Risk Visualization

The visualization module generates:

- Mortality probability curve
- Survival curve
- Interest rate sensitivity chart
- Longevity risk distribution

Plots are generated using base R and saved as PNG files in the `figures/` directory.

## 8. Automated Testing

GitHub Actions runs automated checks for:

- Valid mortality probabilities
- Survival probability calculations
- Positive life insurance premiums
- Positive annuity values
- Pension liability calculations
- Interest rate sensitivity
- Longevity improvement effects

The workflow also generates actuarial visualizations and uploads them as downloadable workflow artifacts.

## How to Run

Requirements:

- R
- No additional R packages required

Run the automated tests:

```bash
Rscript tests/test_models.R
```

Generate visualizations:

```bash
Rscript R/visualization.R
```

Run individual modules:

```bash
Rscript R/mortality_model.R
Rscript R/life_insurance_pricing.R
Rscript R/annuity_valuation.R
Rscript R/pension_liabilities.R
Rscript R/interest_rate_sensitivity.R
Rscript R/longevity_risk.R
```

Run commands from the repository root directory.

## Limitations and Future Development

This project is a simplified actuarial modeling framework.

Potential extensions include:

- Calibration to published mortality tables
- Cohort-based mortality improvements
- Stochastic interest rate models
- Solvency II capital modeling
- Pension asset-liability management
- Model validation against actuarial benchmarks

The simulated longevity risk measures depend on the chosen scenario distribution and should not be interpreted as regulatory capital estimates.

## Skills Demonstrated

**Actuarial Mathematics:** mortality modeling, survival analysis, life insurance pricing, annuity valuation.

**Quantitative Risk Management:** interest rate sensitivity, longevity risk, Monte Carlo simulation, VaR, Expected Shortfall.

**Programming:** R, modular functions, data processing, visualization, automated testing, GitHub Actions.

## Disclaimer

This project is intended for educational and portfolio demonstration purposes only. It does not constitute actuarial advice, insurance pricing recommendations, or a production-ready valuation system.
