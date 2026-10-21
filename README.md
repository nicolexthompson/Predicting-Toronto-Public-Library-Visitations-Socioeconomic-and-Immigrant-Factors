# Predicting Toronto Public Library Visitations: Socioeconomic and Immigrant Factors

## Tools,Packages & Methods

- **R:** Statistical analysis and data processing.
- **Tidyverse / dplyr:** Data cleaning, transformation, aggregation, and dataset joins.
- **readxl:** Importing demographic data from Excel.
- **ggplot2:** Exploratory data visualization and regression coefficient plots.
- **estimatr:** Robust linear regression using `lm_robust()`.
- **texreg:** Regression table generation and reporting.
  
**Methods:** Data Cleaning · Exploratory Data Analysis · Robust Linear Regression · Statistical Inference

## Overview

This project investigates whether neighbourhood-level immigrant population share is associated with Toronto Public Library (TPL) branch visitation, accounting for socioeconomic and demographic characteristics.

Using public library visitation records, branch information, and 2021 neighbourhood census data, I integrated multiple datasets, engineered demographic indicators, and developed robust linear regression models to examine patterns in library usage across Toronto.

The analysis evaluates an initial hypothesis that neighbourhoods with higher immigrant population shares would have higher library visit volumes, while exploring how other neighbourhood characteristics relate to visitation.

**Result:** The relationship between neighbourhood immigrant population share and library visitation was **not statistically significant** in the final multiple regression model ![Equation](https://latex.codecogs.com/svg.latex?\beta%20=%20-0.01,%20\qquad%20p%20%3E%200.05), controlling for low-income rate, total population, and the proportion of children aged 0–14.

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

- **Immigrant population share was not statistically significant.** After controlling for low-income rate, total population, and the proportion of children aged 0–14, the model found no statistically significant association between neighbourhood immigrant share and library visit volume.
- **Low-income rate was positively associated with library visits.** The coefficient was 0.05 and statistically significant at the 5% level, holding the other variables constant.
- **The proportion of children aged 0–14 was not statistically significant.** Although the estimated coefficient was negative, the model did not provide sufficient evidence of an association.
- **Total population was statistically significant.** Its coefficient was positive but rounded to 0.00 in the reported results; the unrounded estimate is needed to assess its magnitude.
- **The model had modest explanatory power.** The model achieved an \(R^2\) of 0.18 and an adjusted \(R^2\) of 0.14, indicating that it explained a limited proportion of the variation in log-transformed library visits.

Overall, the findings did not support the initial hypothesis that neighbourhood immigrant population share independently predicts library visitation after accounting for the included demographic controls.

These results reflect **statistical associations, not causal relationships**. In particular, the positive association between low-income rate and total visit volume does not establish that lower-income residents visit libraries more frequently on a per-person basis.

## Limitations

- **Ecological inference:** Neighbourhood-level demographic data cannot establish the characteristics or behaviour of individual library visitors.
- **Temporal mismatch:** Library visitation data are from 2023, whereas demographic data are from 2021.
- **Omitted variables:** Branch size, operating hours, transit accessibility, service availability, and proximity to other branches may influence visitation.
- **Geographic coverage:** The analysis is limited to neighbourhoods represented in the merged dataset, excluding areas without a matched library branch.
- **Cross-sectional design:** Using one year of visitation data limits the ability to assess long-term trends or establish causal relationships.
- **Model specification:** The selected predictors may not capture all relevant relationships. Additional diagnostic testing and sensitivity analyses could help evaluate model assumptions and the robustness of the findings.

## Future Directions

Potential extensions to this analysis include:

- Incorporating multiple years of visitation data to examine changes in library usage over time.
- Adding branch-level operational and geographic variables, such as opening hours, facility size, and service availability.
- Investigating transit accessibility and proximity to library services.
- Comparing alternative outcome measures, including population-adjusted visitation metrics.
- Conducting formal model diagnostics, multicollinearity checks, and sensitivity analyses.
- Exploring whether demographic relationships vary across neighbourhoods or library branch types.

## Project Context

Developed as part of the University of Toronto's IRE379 Research and Data course, this project demonstrates an end-to-end analytical workflow involving public dataset integration, variable engineering, exploratory data analysis, robust regression modeling, statistical inference, and critical evaluation of findings.
