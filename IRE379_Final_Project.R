## DATA CLEANING & WRANGLING ---------------------------------------------------
library(tidyverse)
library(haven)
library(estimatr)
library(dplyr)
library(readxl)
library(ggplot2)
library(texreg)

# Read In Data
tpl <- read.csv('tpl-branch-general-information-2023.csv')
visits <- read.csv('tpl-visits-annual-by-branch.csv')

# Clean visits data - 2023 only
visits <- visits %>% filter(Year == 2023) %>% select(BranchCode, Visits)

# Clean TPL branch data
tpl_clean <- tpl %>% select(NBHDNo, BranchCode, NBHDName)
tpl_clean <- left_join(tpl_clean, visits, by = "BranchCode")

# Aggregate visits to neighbourhood level
visits_by_hood <- tpl_clean %>%
  group_by(NBHDNo) %>%
  summarise(total_visits = sum(Visits, na.rm = TRUE))

## DEMOGRAPHIC DATA ------------------------------------------------------------
#DATA WRANGLING & CLEANING----
demo_data <- read_xlsx("neighbourhood-profiles-2021-158-model.xlsx")

rows_to_extract <- c(
  1,     # Neighbourhood Number
  3,     # Total population
  1487,  # immigrants (to calculate immigrant %)
  178,   # Low income rate (LIM-AT) 
  1971,  # Unemployment rate 
  30,     # % population aged 0 to 14 
  32, #% of population aged 65 years and over
  442# Mother Tongue= non-Official language (first lang isn't english or french)
)

subset_demo <- t(demo_data[rows_to_extract, ])
colnames(subset_demo) <- subset_demo[1, ]
subset_demo <- subset_demo[-1, ]
subset_demo <- as.data.frame(subset_demo)

# Rename columns
names(subset_demo)[1] <- "Neighbourhood_Number"
names(subset_demo)[2] <- "total_pop"
names(subset_demo)[3] <- "immigrants"
names(subset_demo)[4] <- "low_income_rate"
names(subset_demo)[5] <- "unemployment_rate"
names(subset_demo)[6] <- "pct_0to14"
names(subset_demo)[7] <- "pct_65plus"
names(subset_demo)[8] <- "official_lang"
names(subset_demo)[9] <- "non_official_lang"

# Convert to numeric
subset_demo$total_pop<- as.numeric(as.character(subset_demo$total_pop))
subset_demo$immigrants<- as.numeric(as.character(subset_demo$immigrants))
subset_demo$low_income_rate <- as.numeric(as.character(subset_demo$low_income_rate))
subset_demo$unemployment_rate <- as.numeric(as.character(subset_demo$unemployment_rate))
subset_demo$pct_0to14<- as.numeric(as.character(subset_demo$pct_0to14))
subset_demo$pct_65plus<- as.numeric(as.character(subset_demo$pct_65plus))
subset_demo$official_lang<- as.numeric(as.character(subset_demo$official_lang))
subset_demo$non_official_lang<- as.numeric(as.character(subset_demo$non_official_lang))

# Calculate immigrant rate
subset_demo$immigrant_rate <- ((subset_demo$immigrants/ subset_demo$total_pop) * 100)

# Calculate % speaking non-official lang
subset_demo$non_official_lang_rate <- ((subset_demo$non_official_lang / subset_demo$total_pop) * 100)

## MERGE DATASETS --------------------------------------------------------------
merged_data <- merge(visits_by_hood, subset_demo,
                     by.x = "NBHDNo",
                     by.y = "Neighbourhood_Number",
                     all = FALSE)

nrow(merged_data) # check rows

## CHECK DISTRIBUTION ----------------------------------------------------------
ggplot(data = merged_data, aes(x = immigrant_rate)) + geom_histogram() # normally distrubuted
ggplot(data = merged_data, aes(x = total_visits)) + geom_histogram() #right tail
# log transform total_visits
merged_data <- mutate(merged_data, log_visits = log(total_visits))
ggplot(data = merged_data, aes(x = log_visits)) + geom_histogram() #right tail


## SIMPLE REGRESSION -----------------------------------------------------------
model1 <- lm_robust(log_visits ~ immigrant_rate, data = merged_data)
summary(model1)

## CHECK OMITTED VARIABLES -----------------------------------------------------
# Does each candidate correlate with X (immigrant_rate)?
unemp_x  <- lm_robust(immigrant_rate ~ unemployment_rate, data = merged_data)
lowinc_x <- lm_robust(immigrant_rate ~ low_income_rate, data = merged_data)
kids_x  <- lm_robust(immigrant_rate ~ pct_0to14, data = merged_data)
seniors_x <- lm_robust(immigrant_rate ~ pct_65plus, data = merged_data)
pop_x <-lm_robust(immigrant_rate ~ total_pop, data = merged_data)
lang_x <- lm_robust(immigrant_rate ~ non_official_lang_rate, data = merged_data)

# Does each candidate correlate with Y (log_visits)?
unemp_y <- lm_robust(log_visits ~ unemployment_rate, data = merged_data)
lowinc_y <- lm_robust(log_visits ~ low_income_rate, data = merged_data)
kids_y <- lm_robust(log_visits ~ pct_0to14, data = merged_data)
seniors_y<- lm_robust(log_visits ~ pct_65plus, data = merged_data)
pop_y <-lm_robust(log_visits ~ total_pop, data = merged_data)
lang_y <- lm_robust(log_visits ~ non_official_lang_rate, data = merged_data)


summary(unemp_x) #excludes 0
summary(unemp_y) #include 0

summary(lowinc_x) #exclude 0
summary(lowinc_y) #exclude 0

summary(kids_x) #include 0
summary(kids_y) #exclude 0 #PCT_0TO14 IS A PRECISION VARIABLE THEN

summary(seniors_x) #include 0
summary(seniors_y) #include 0

summary(pop_x) #exclude 0
summary(pop_y) #exclude 0

summary(lang_x) #exclude 0 #can't include as PRECISION variable
summary(lang_y) #include 0

## MULTIPLE REGRESSION (add confirmed omitted variables & precision) -----------
model2 <- lm_robust(log_visits ~ immigrant_rate + low_income_rate + pct_0to14 +total_pop, data = merged_data)
summary(model2)

# Compare simple vs multiple
summary(model1)
summary(model2)

#visualizations-----------------------------------------------------------------
# HTML OF REGRESSION
my_html = htmlreg(list(model2),
                  include.ci = FALSE,
                  custom.model.names = c("Multiple Regression"))
write(my_html, "my_reg_table.html")

#----REGRESSION VISUALIZATION
tidy(model2) # examine the column names

ggplot(tidy(model2) %>% filter(term != "(Intercept)"),
       aes(x=term, y=estimate)) +
  geom_point() +
  geom_errorbar(aes(ymin=conf.low, ymax=conf.high), width=0) +
  geom_hline(yintercept=0) +
  coord_flip() +
  ylab("Library Visitations")

#----2) Potential Regression Table -- visualizing ci
regression_ci_viz <- lm_robust(log_visits ~ immigrant_rate + low_income_rate + 
                                 pct_0to14 +total_pop, data = merged_data)

tidy(regression_ci_viz) # examine the column names

ggplot(tidy(regression_ci_viz) %>% filter(term != "(Intercept)"),
       aes(x=term, y=estimate)) +
  geom_point() +
  geom_errorbar(aes(ymin=conf.low, ymax=conf.high), width=0) +
  geom_hline(yintercept=0) +
  coord_flip() +
  ylab("Library Visitations")

#---------------
# Build models progressively
m1 <- lm_robust(log_visits ~ immigrant_rate,
                data = merged_data)

m2 <- lm_robust(log_visits ~ immigrant_rate + low_income_rate,
                data = merged_data)

m3 <- lm_robust(log_visits ~ immigrant_rate + low_income_rate + total_pop,
                data = merged_data)

m4 <- lm_robust(log_visits ~ immigrant_rate + low_income_rate +  
                  total_pop + pct_0to14, 
                data = merged_data)

# Build the table
my_html <- htmlreg(
  list(m1, m2, m3, m4),
  
  include.ci = FALSE,
  
  custom.model.names = c("Model 1", "Model 2", "Model 3", "Model 4"),
  
  custom.coef.names = c("Intercept",
                        "Immigrant rate",
                        "Low income rate",
                        "Total population",
                        "% aged 0-14"),
  
  caption = "Progressive model building — dependent variable: log(library visits)",
  caption.above = TRUE,
  
  custom.note = "Models build progressively, adding one variable at a time. 
                 Compare R² across models to assess improvement in fit. %stars."
)

write(my_html, "progressive_models.html")

#---omitted variable screening table--------------------------------------------
my_html_ov <- htmlreg(
  list(unemp_x,  unemp_y,
       lowinc_x, lowinc_y,
       kids_x,   kids_y,
       seniors_x, seniors_y,
       pop_x,    pop_y,
       lang_x,   lang_y),
  
  include.ci = FALSE,
  
  custom.model.names = c(
    "Unemp (X)",   "Unemp (Y)",
    "Low inc (X)", "Low inc (Y)",
    "% 0-14 (X)",  "% 0-14 (Y)",
    "65+ (X)",     "65+ (Y)",
    "Pop (X)",     "Pop (Y)",
    "Lang (X)",    "Lang (Y)"
  ),
  
  custom.coef.names = c(
    "Intercept",
    "Unemployment rate",
    "Low income rate",
    "% aged 0-14",
    "% aged 65+",
    "Total population",
    "Non-official lang rate"
  ),
  
  caption = "Omitted variable screening — dependent variable alternates between 
  X (immigrant rate) and Y (log visits)",
  caption.above = TRUE,
  
  custom.note = "For each candidate variable, the (X) model regresses immigrant rate on 
                 the candidate, and the (Y) model regresses log(library visits) on the 
                 candidate. A variable qualifies as an omitted variable if its CI excludes 
                 0 in both models. A variable that only correlates with Y is a precision 
                 variable. %stars."
)

write(my_html_ov, "omitted_variable_screening.html")

