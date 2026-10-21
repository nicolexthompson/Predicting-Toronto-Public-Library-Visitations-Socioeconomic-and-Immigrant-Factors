# Predicting Toronto Public Library Visitations: Socioeconomic and Immigrant Factors

**Tools:** R · Tidyverse · ggplot2 · estimatr · texreg  
**Methods:** Data Cleaning · Exploratory Data Analysis · Robust Linear Regression · Statistical Inference

## Overview

This project investigates whether neighbourhood-level immigrant population share is associated with Toronto Public Library (TPL) branch visitation, accounting for socioeconomic and demographic characteristics.

Using public library visitation records, branch information, and 2021 neighbourhood census data, I integrated multiple datasets, engineered demographic indicators, and developed robust linear regression models to examine patterns in library usage across Toronto.

The analysis evaluates an initial hypothesis that neighbourhoods with higher immigrant population shares would have higher library visit volumes, while exploring how other neighbourhood characteristics relate to visitation.

## Key Learnings & What Could Have Been Improved

This project strengthened my ability to integrate public datasets, build and interpret regression models, and critically evaluate statistical findings. It also demonstrated that a statistically insignificant result can be informative when interpreted in the context of model specification and data limitations.

### Key Learnings

- **Control variables matter:** The relationship between immigrant population share and library visitation was not statistically significant in the final model. Incorporating additional demographic variables improved model fit, highlighting the importance of accounting for neighbourhood characteristics when examining an individual predictor.
- **Statistical significance is not the same as explanatory power:** Although low-income rate was statistically significant, the model's adjusted \(R^2\) was 0.14. This illustrates why individual coefficient estimates and overall model fit must be evaluated separately.
- **Data integration requires careful measurement:** Combining library branch records with census data required consistent neighbourhood identifiers, aggregation of visits across branches, and the construction of demographic rates.
- **Interpretation must match the data:** Neighbourhood-level visitation counts reflect aggregate branch activity. They cannot establish individual library usage patterns or demonstrate causal relationships.

## Research Question

**Does the proportion of immigrants in a Toronto neighbourhood predict library visitation after accounting for other neighbourhood characteristics?**

The initial hypothesis was that neighbourhoods with higher immigrant population shares would have higher library visit volumes.

## Data Sources

The analysis combines three publicly available datasets:

| Dataset | Purpose |
|---|---|
| [TPL Branch General Information](https://open.toronto.ca/dataset/library-branch-general-information/) | Links library branches to neighbourhood identifiers. |
| [TPL Library Visits](https://open.toronto.ca/dataset/library-visits/) | Provides annual branch visitation counts; 2023 records were selected. |
| [Toronto Neighbourhood Profiles](https://open.toronto.ca/dataset/neighbourhood-profiles/) | Provides demographic and socioeconomic indicators from the 2021 census profiles. |

The datasets were cleaned and integrated to construct a neighbourhood-level analytical dataset. Branch visits were aggregated by neighbourhood and merged with demographic indicators.

### What I Would Improve Next Time

1. **Include additional explanatory variables.** Incorporating branch size, opening hours, transit accessibility, distance to other branches, and available services could help explain variation in visitation beyond demographic characteristics.

2. **Improve the measurement of library usage.** Total visits measure overall branch activity rather than individual engagement. Analysing visits relative to the population served, where appropriate, could help distinguish population size from visitation intensity.

3. **Strengthen model diagnostics.** I would explicitly assess multicollinearity using variance inflation factors (VIF), inspect residual patterns, identify influential observations, and evaluate whether the model's functional form is appropriate.

4. **Test alternative specifications.** Transforming highly skewed predictors, expressing population in more interpretable units, and testing plausible nonlinear relationships could improve interpretability and potentially model fit. Any alternative specification would need to be justified and evaluated rather than selected solely to increase \(R^2\).

5. **Address the mismatch in data years.** The analysis combines 2023 visitation data with 2021 census demographics. Using more closely aligned time periods, or analysing multiple years of visitation data, could provide a stronger basis for comparison.

6. **Refine variable selection.** Rather than relying primarily on statistical associations to screen potential controls, I would use subject-matter reasoning and sensitivity analyses to evaluate which variables should be included and how their inclusion affects the main estimate.

These improvements would support a more robust analysis and help translate the findings into more actionable insights for public library planning.

## Methodology

### 1. Data Cleaning and Integration

- Selected relevant variables from the branch, visitation, and neighbourhood profile datasets.
- Filtered library visitation records to 2023.
- Joined branch information with visitation records using branch codes.
- Aggregated total visits across branches within each neighbourhood.
- Extracted demographic indicators and converted relevant variables to numeric formats.
- Calculated immigrant population share and non-official-language mother-tongue share.
- Merged visitation and demographic data using neighbourhood identifiers.

### 2. Exploratory Data Analysis

Used histograms and exploratory visualizations to examine variable distributions and assess skewness in visitation counts. The outcome was log-transformed to reduce the influence of right-skewness and support regression analysis.

### 3. Regression Modeling

Estimated robust linear regression models using `lm_robust()` from the `estimatr` package.

**Initial bivariate model:** Examined the relationship between immigrant population share and log-transformed library visits.

**Model development:** Evaluated candidate demographic controls and compared model specifications to assess how estimates and model fit changed when additional variables were included.

**Final multiple regression model:** Included immigrant population share, low-income rate, total population, and the proportion of children aged 0–14.

The final model was specified as:

![Equation](https://latex.codecogs.com/svg.latex?\ln(\text{log\_visits}_i)%20=%20\beta_0%20+%20\beta_1\text{immigrant\_rate}_i%20+%20\beta_2\text{low\_income\_rate}_i%20+%20\beta_3\text{total\_pop}_i%20+%20\beta_4\text{pct\_0to14}_i)

Where:

- \(\text{log\_visits}_i\) is the natural logarithm of total library visits in neighbourhood \(i\).
- \(\text{immigrant\_rate}_i\) is the immigrant population share.
- \(\text{low\_income\_rate}_i\) is the low-income rate.
- \(\text{total\_pop}_i\) is the neighbourhood's total population.
- \(\text{pct\_0to14}_i\) is the proportion of the population aged 0–14.
- \(\beta_0\) is the intercept, \(\beta_1\) through \(\beta_4\) are regression coefficients, and \(\epsilon_i\) is the error term.

### 4. Visualization and Reporting

Used `ggplot2` to visualize data distributions and regression estimates, and `texreg` to generate regression tables. Coefficient estimates and confidence intervals supported interpretation of the direction, magnitude, and uncertainty of the relationships.

## Final Regression Results

The final model included 86 observations.

| Independent variable | Coefficient | Standard error | Significance |
|---|---:|---:|---|
| Intercept | 11.08 | 0.51 | *** |
| Immigrant rate | -0.01 | 0.01 | Not significant |
| Low-income rate | 0.05 | 0.02 | * |
| Proportion aged 0–14 | -0.04 | 0.02 | Not significant |
| Total population | 0.00 | 0.00 | ** |

| Model fit statistic | Result |
|---|---:|
| \(R^2\) | 0.18 |
| Adjusted \(R^2\) | 0.14 |
| Observations | 86 |
| RMSE | 0.82 |

Significance notation: *** \(p < 0.001\); ** \(p < 0.01\); * \(p < 0.05\).

*Note: Coefficients and standard errors are rounded as reported. The total population coefficient is displayed as 0.00 because of rounding; its underlying value is needed to interpret its magnitude.*

## Key Findings

- **Immigrant population share was not statistically significant.** The final model did not find sufficient evidence of an independent association between immigrant share and neighbourhood-level library visit volume after accounting for the included controls.
- **Low-income rate was positively associated with visit volume.** Its coefficient was 0.05 and statistically significant at the 5% level, holding the other included variables constant.
- **The proportion
