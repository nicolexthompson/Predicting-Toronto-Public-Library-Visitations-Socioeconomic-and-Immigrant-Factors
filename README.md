# Predicting Toronto Public Library Visitations: Socioeconomic and Immigrant Factors

**Tools:** R, Tidyverse, ggplot2, estimatr, texreg  
**Project Type:** Statistical Analysis · Exploratory Data Analysis · Regression Modeling

## Overview

This project investigates the relationship between neighbourhood demographics and Toronto Public Library (TPL) branch visitations. Using publicly available library visitation, branch information, and census demographic data, the analysis examines whether the proportion of immigrants in a neighbourhood predicts library visit volume after accounting for socioeconomic and demographic characteristics.

The project applies data cleaning, exploratory data analysis, robust linear regression, and progressive model building to investigate factors associated with library usage.

## Research Question

**Does the proportion of immigrants in a Toronto neighbourhood predict library visitations, after accounting for other neighbourhood characteristics?**

The initial hypothesis was that neighbourhoods with higher immigrant population shares would have higher library visit volumes.

## Data Sources

The analysis combines three publicly available datasets:

- **Toronto Public Library Branch Information:** Branch identifiers and neighbourhood associations.
- **Toronto Public Library Annual Visits:** Annual visitation counts by branch, filtered to 2023.
- **City of Toronto Neighbourhood Profiles:** Census demographic and socioeconomic characteristics from 2021.

The datasets were cleaned and integrated to create a neighbourhood-level analytical dataset. Library branch visits were aggregated by neighbourhood and merged with demographic indicators.

## Methodology

### 1. Data Cleaning and Wrangling

- Selected relevant variables from the three source datasets.
- Filtered library visitation records to 2023.
- Joined branch information with annual visitation data using branch codes.
- Aggregated branch visits to the neighbourhood level.
- Extracted and converted demographic variables into numeric formats.
- Calculated neighbourhood immigrant population shares and non-official mother-tongue population shares.
- Merged visitation and demographic data using neighbourhood identifiers.

### 2. Exploratory Data Analysis

Used histograms to examine variable distributions and identify skewness in neighbourhood-level visit counts. Applied a logarithmic transformation to the visitation outcome before regression modeling.

### 3. Regression Modeling

Estimated a series of robust linear regression models using `lm_robust()` from the `estimatr` package.

- **Bivariate regression:** Examined the initial relationship between immigrant population share and log-transformed library visits.
- **Potential confounder screening:** Examined associations between immigrant share, library visits, and candidate demographic controls.
- **Multiple regression:** Incorporated low-income rate, total population, and the proportion of children aged 0–14 alongside immigrant share.
- **Progressive model building:** Added control variables incrementally to examine changes in model fit and coefficient estimates.

### 4. Visualization and Reporting

Created regression tables and coefficient plots with confidence intervals to communicate estimates, uncertainty, and differences across model specifications.

## Key Findings

- **Immigrant population share was not a statistically significant predictor** of neighbourhood-level library visits in the final multiple regression model.
- **Low-income rate was positively associated with library visit volume**, controlling for immigrant share, population size, and the proportion of children.
- **Total neighbourhood population was positively associated with library visit volume**, consistent with larger populations generating greater overall demand for library services.
- **Model fit improved with additional controls:** the reported \(R^2\) increased from approximately 0.01 in the bivariate model to 0.185 in the multiple regression model.

The findings did not support the initial hypothesis that neighbourhood immigrant share independently predicts library visitation after accounting for the included demographic characteristics.

These results describe associations at the neighbourhood level. They do not establish that individual immigrants use libraries more or less frequently than other residents, nor do they establish causal relationships.

## Limitations

- **Ecological inference:** Neighbourhood demographics cannot establish the immigration status of individual library visitors.
- **Temporal mismatch:** Library visitation data cover 2023, while demographic data are from the 2021 census.
- **Geographic scope:** The analysis focuses on Toronto neighbourhoods with library branches and may not generalize to other cities or neighbourhoods without branches.
- **Unobserved factors:** Branch size, operating hours, transit accessibility, service offerings, and other factors may influence visitation.
- **Cross-sectional design:** The analysis examines a single year of visitation data and cannot establish causality or long-term trends.

## Tools and Packages

- **R:** Data manipulation, statistical modeling, and analysis.
- **Tidyverse / dplyr:** Data cleaning, transformation, aggregation, and joins.
- **readxl:** Importing demographic data from Excel.
- **ggplot2:** Exploratory visualizations and regression coefficient plots.
- **estimatr:** Robust linear regression estimation.
- **texreg:** Regression table generation.

## Future Improvements

Potential extensions include incorporating multiple years of library visitation data, adding branch-level characteristics, examining geographic accessibility, and evaluating the relationship between library service availability and visitation patterns over time.

## Project Context

Developed as part of the University of Toronto's IRE379 Research and Data course. The project demonstrates an end-to-end analytical workflow, from integrating public datasets to evaluating statistical relationships and communicating findings.

## References and Data

- [City of Toronto Neighbourhood Profiles](https://open.toronto.ca/dataset/neighbourhood-profiles/)
- [Toronto Public Library Branch General Information](https://open.toronto.ca/dataset/library-branch-general-information/)
- [Toronto Public Library Visits](https://open.toronto.ca/dataset/library-visits/)
