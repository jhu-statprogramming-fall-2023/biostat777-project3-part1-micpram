## Example Analysis

### Refugee Population Data from TidyTuesday

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

```{r, include=FALSE}
library(Project2)
library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyr)
library(purrr)
```


```{r, include=FALSE}
## List of exported functions that are in the package
exists("fn_cos")
exists("fn_sin")
exists("sample_mean")
exists("sample_sd")
exists("CI1")
exists("make_ci_class")
exists("print")
exists("CI2")
```

#### R Package, Project2, includes basic functions to calculate cosine, sine, sample mean, sample standard deviation, 95% confidence interval of the mean, and S3 class 95% confidence interval. In order to utilize these functions from the Project2 package, one must create a vector and label it "x". 

#### Question: What is the 95% confidence interval and mean number of refugees across the US & Canada from 2019 to 2022?

```{r}
## Data is from TidyTuesday and focuses on refugee population and country of asylum data.
library(tidyverse)
library(refugees)
populations <- refugees::population
populations <- filter(populations, year >= 2019)
head(populations)

```

### Data Dictionary

# `population.csv`

|variable          |class     |description       |
|:-----------------|:---------|:-----------------|
|year              |double    |The year.              |
|coo_name          |character |Country of origin name.        |
|coo               |character |Country of origin UNHCR code.   |
|coo_iso           |character |Country of origin ISO code.  |
|coa_name          |character |Country of asylum name.    |
|coa               |character |Country of asylum UNHCR code.  |
|coa_iso           |character |Country of asylum ISO code.    |
|refugees          |double    |The number of refugees.   |
|asylum_seekers    |double    |The number of asylum-seekers.  |
|returned_refugees |double    |The number of returned refugees. |
|idps              |double    |The number of internally displaced persons.     |
|returned_idps     |double    |The number of returned internally displaced persons.  |
|stateless         |double    |The number of stateless persons.  |
|ooc               |double    |The number of others of concern to UNHCR.   |
|oip               |double    |The number of other people in need of international protection.     |
|hst               |double    |The number of host community members.     |


```{r, message=FALSE}
summary <- populations %>%
  group_by(coo_name) %>%
  summarise(Sample_Mean = mean(refugees, na.rm = TRUE))

top_countries_mean <- summary %>%
  arrange(desc(Sample_Mean)) %>%
  head(10) 

top_countries_mean
```
```{r}
plot <- ggplot(top_countries_mean, aes(x = coo_name, y = Sample_Mean)) +
  geom_bar(stat = "identity", position = "dodge", alpha = 0.8) +
  labs(
    title = "Top-10 Mean Number of Refugees by Country of Origin",
    subtitle = "Data from 2019-2022",
    x = "Country",
    y = "Mean Number of Refugees",
    fill = "Year"
  ) +
  theme_light() +
  coord_flip() +
  facet_grid()

plot
```

#### Time series plot of total refugees by year

```{r}
subset <- populations %>%
  filter(coa_name == c("United States of America", "Canada")) 

ggplot(subset, aes(x = coa_name, y = refugees, fill=factor(year))) +
  geom_bar(stat = "identity", position = "dodge", alpha = 0.8) +
  labs(
    title = "Total Number of Refugees by Year Per Country",
    x = "Country of Asylyum",
    y = "Total Refugees") +  
    theme_light() +
    coord_flip() +
    facet_grid()

```


```{r}
# Aggregate the total number of refugees by year
total_refugees_by_year <- populations %>%
  group_by(year) %>%
  summarise(Total_Refugees = sum(refugees, na.rm = TRUE)) %>%
  ungroup()

# Create a time series plot of total refugees by year
ggplot(total_refugees_by_year, aes(x = year, y = Total_Refugees)) +
  geom_line() +
  labs(
    title = "Total Number of Refugees Over Time",
    x = "Year",
    y = "Total Refugees") +
    theme_light() +
    facet_grid()
```

```{r}
#$ Calculate mean refugees for each year
mean_refugees_by_year <- populations %>%
  group_by(year) %>%
  summarise(mean_refugees = mean(refugees, na.rm = TRUE))

## Extract a vector of mean refugees for each year
mean_refugees_vector <- map_dbl(unique(populations$year), ~ mean_refugees_by_year$mean_refugees[mean_refugees_by_year$year == .x])

## Mean refugees for each year
mean_refugees_vector

## Calculate the overall mean of refugees
overall_mean_refugees <- mean(populations$refugees, na.rm = TRUE)

## Subtract the overall mean from each yearly mean using map2()
results <- map2(mean_refugees_by_year$mean_refugees, overall_mean_refugees, `-`)

## Difference between refugee mean per year and overall mean
results

```


```{r}
## Calculating sample mean and standard deviation in order to calculate the 95% confidence interval
## x = Vector of your choosing made of any combination of numerical values. In this case, it's the winner's marathon times.
x <- (population$refugees)
## Calculate the sample mean or average of values in the vector x
sample_mean(x)
## Calculate the sample standard deviation
sample_sd(x)
## Calculate the confidence interval of the mean with consideration to marginal errors. Function produces the lower and upper bound of the mean.
CI1(x)
```


```{r}
## S3 class to produce a 95% confidence interval with lower and upper bounds.
## Used in order to track the function as rnorm produces values at random using the mean and standard deviation from the winning marathon times in hours
## Produces n values at random with a normal distribution to account for all data points in the winners dataset
set.seed(111)
x <- rnorm(n = nrow(population), mean = mean(population$refugees), sd = sd(population$refugees))
## Constructor function of the confidence interval S3 class
## Prints each of the returns of the make_ci_class along with the respective value 
obj <- make_ci_class(x)
print(obj)
# Modified confidence interval calculation with consideration to the S3 confidence interval class
CI2(obj)
```

##### Summary: Overall, there has been a dramatic increase in the total number of refugees across the globe, and especially between 2019 and 2022. Additionally, when comparing the amount of refugees seeking asylyum between the US and Canada, the US clearly accepts more refugees than Canada.

#### Packages & Functions Used

| Package | Function   |
|:--------|:-----------|
| DPLYR   | %\>%       |
| DPLYR   | summarise     |
| DPLYR   | group_by   |
| DPLYR   | mean  |
| DPLYR   | filter   |
| PURR   |  map_dbl    |
| PURR   |  map2    |
| TIDYR   | tibble     |
| TIDYR   | count     |
| GGPLOT2 | geom_bar  |
| GGPLOT2 | geom_line  |
| GGPLOT2 | geom_point     |
| GGPLOT2 | facet_grid     |




