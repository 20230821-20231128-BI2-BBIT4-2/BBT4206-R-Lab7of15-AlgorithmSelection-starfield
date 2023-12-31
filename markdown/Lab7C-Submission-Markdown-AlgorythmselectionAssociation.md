Business Intelligence Lab Submission Markdown
================
Starfield
11/1/2023

- [Student Details](#student-details)
- [Setup Chunk](#setup-chunk)

# Student Details

<table style="width:97%;">
<colgroup>
<col style="width: 48%" />
<col style="width: 48%" />
</colgroup>
<tbody>
<tr class="odd">
<td><strong>Student ID Numbers and Names of Group Members</strong></td>
<td><p>1. 135232 - Sadiki Hamisi</p>
<p>2. 134782 - Yasmin Choma</p>
<p>3. 134783 - Moses mbugua</p>
<p>4. 122998 - Glenn Oloo</p></td>
</tr>
<tr class="even">
<td><strong>GitHub Classroom Group Name</strong></td>
<td>Starfield</td>
</tr>
<tr class="odd">
<td><strong>Course Code</strong></td>
<td>BBT4206</td>
</tr>
<tr class="even">
<td><strong>Course Name</strong></td>
<td>Business Intelligence II</td>
</tr>
<tr class="odd">
<td><strong>Program</strong></td>
<td>Bachelor of Business Information Technology</td>
</tr>
<tr class="even">
<td><strong>Semester Duration</strong></td>
<td>21<sup>st</sup> August 2023 to 28<sup>th</sup> November 2023</td>
</tr>
</tbody>
</table>

# Setup Chunk

**Note:** the following “*KnitR*” options have been set as the
defaults:  
`knitr::opts_chunk$set(echo = TRUE, warning = FALSE, eval = TRUE, collapse = FALSE, tidy.opts = list(width.cutoff = 80), tidy = TRUE)`.

More KnitR options are documented here
<https://bookdown.org/yihui/rmarkdown-cookbook/chunk-options.html> and
here <https://yihui.org/knitr/options/>.

**Note:** the following “*R Markdown*” options have been set as the
defaults:

Installing and loading of required packages

``` code

if (require("languageserver")) {
  require("languageserver")
} else {
  install.packages("languageserver", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

if (require("arules")) {
  require("arules")
} else {
  install.packages("arules", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## arulesViz ----
if (require("arulesViz")) {
  require("arulesViz")
} else {
  install.packages("arulesViz", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}


if (require("tidyverse")) {
  require("tidyverse")
} else {
  install.packages("tidyverse", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

if (require("readxl")) {
  require("readxl")
} else {
  install.packages("readxl", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}


if (require("knitr")) {
  require("knitr")
} else {
  install.packages("knitr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}


if (require("ggplot2")) {
  require("ggplot2")
} else {
  install.packages("ggplot2", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

if (require("lubridate")) {
  require("lubridate")
} else {
  install.packages("lubridate", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}


if (require("plyr")) {
  require("plyr")
} else {
  install.packages("plyr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

if (require("dplyr")) {
  require("dplyr")
} else {
  install.packages("dplyr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

if (require("naniar")) {
  require("naniar")
} else {
  install.packages("naniar", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

if (require("RColorBrewer")) {
  require("RColorBrewer")
} else {
  install.packages("RColorBrewer", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

the first format

``` code
library(arules)
data("Groceries")
View(Groceries)
transactions_single_format <- as(Groceries, "transactions")
View(transactions_single_format)
print(transactions_single_format)

```

the second format

``` code
library(arules)
data("Groceries")
transactions_basket_format <- as(Groceries, "transactions")
View(transactions_basket_format)
print(transactions_basket_format)
```

loading the dataset

``` code

data("Groceries")
dim(Groceries)


groceries_df <- as(Groceries, "data.frame")

dim(groceries_df)

groceries_df <- as(Groceries, "data.frame")

groceries_removed_vars_obs <- groceries_df %>% filter(complete.cases(.))

dim(groceries_removed_vars_obs)

str(groceries_removed_vars_obs)
dim(groceries_removed_vars_obs)

head(groceries_removed_vars_obs)

groceries_df <- as(Groceries, "data.frame")

any_na(groceries_df)

groceries_removed_vars_obs <- groceries_df %>% filter(complete.cases(.))

dim(groceries_removed_vars_obs)

groceries_df <- as(Groceries, "data.frame")

dim(groceries_df)

str(groceries_df)

custom_data <- data.frame(
  invoice_no = c(1, 1, 2, 3, 3, 3),
  trans_date = c("2023-01-01", "2023-01-01", "2023-01-02", "2023-01-03", "2023-01-03", "2023-01-03"),
  Description = c("Item1", "Item2", "Item1", "Item3", "Item4", "Item5")
)
```

Creating transactions based on Description

``` code
transaction_data <- custom_data %>%
  group_by(invoice_no, trans_date) %>%
  summarise(Items = paste(Description, collapse = ","))

View(transaction_data)

library(arules)

custom_data <- data.frame(
  trans_id = 1:4,
  items = c(
    "bread, milk, eggs",
    "bread, milk",
    "milk, eggs",
    "bread, eggs"
  )
)
```

Creating transactions based on items

``` code

transaction_data <- as(custom_data, "transactions")
View(transaction_data)

write.csv(as(Groceries, "data.frame"), file = "data/transactions_basket_format_groceries.csv", row.names = FALSE)

tr_groceries <- read.transactions("data/transactions_basket_format_groceries.csv", format = "basket", sep = ",")


print(tr_groceries)
summary(tr_groceries)
```

EDA rules

``` code

itemFrequencyPlot(tr_groceries, topN = 10, type = "absolute",
                  col = brewer.pal(8, "Pastel2"),
                  main = "Absolute Item Frequency Plot",
                  horiz = TRUE,
                  mai = c(2, 2, 2, 2))
itemFrequencyPlot(tr_groceries, topN = 10, type = "relative",
                  col = brewer.pal(8, "Pastel2"),
                  main = "Relative Item Frequency Plot",
                  horiz = TRUE,
                  mai = c(2, 2, 2, 2))
```

Creating the association rules

``` code

association_rules <- apriori(tr_groceries,
                             parameter = list(support = 0.01,
                                              confidence = 0.8,
                                              maxlen = 10))
```

Print the association rules

``` code

association_rules <- apriori(tr_groceries,
                             parameter = list(support = 0.001,  # Lower support threshold
                                              confidence = 0.2,   # Lower confidence threshold
                                              maxlen = 10))

summary(association_rules)
inspect(association_rules)
inspect(association_rules)
```

Finding the specific rules

``` code

View(Groceries)

chicken_association_rules <- apriori(Groceries, 
                                     parameter = list(supp = 0.01, conf = 0.8),
                                     appearance = list(default = "lhs", rhs = "chicken"))
inspect(head(chicken_association_rules))


strawberry_charlotte_bag_association_rules <- apriori(Groceries, 
                                                      parameter = list(supp = 0.01, conf = 0.8),
                                                      appearance = list(lhs = c("chicken"), default = "rhs"))
inspect(head(strawberry_charlotte_bag_association_rules))

rules_to_plot <- chicken_association_rules[quality(chicken_association_rules)$confidence > 0.85]

rules_to_plot_by_lift <- head(rules_to_plot, n = 20, by = "lift")
```
