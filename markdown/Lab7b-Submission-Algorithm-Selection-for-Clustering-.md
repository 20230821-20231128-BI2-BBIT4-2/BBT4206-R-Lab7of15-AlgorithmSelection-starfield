# Business Intelligence Lab Submission Markdown

<Specify your group name here> <Specify the date when you submitted the lab>

-   [Student Details](#student-details)
-   [Setup Chunk](#setup-chunk)

# Student Details {#student-details}

+---------------------------------------------------+---------------------------------------------+
| **Student ID Numbers and Names of Group Members** | 1\. 135232 - Sadiki Hamisi                  |
|                                                   |                                             |
|                                                   | 2\. 134782 - Yasmin Choma                   |
|                                                   |                                             |
|                                                   | 3\. 134783 - Moses mbugua                   |
|                                                   |                                             |
|                                                   | 4\. 122998 - Glenn Oloo                     |
+---------------------------------------------------+---------------------------------------------+
| **GitHub Classroom Group Name**                   | Starfield                                   |
+---------------------------------------------------+---------------------------------------------+
| **Course Code**                                   | BBT4206                                     |
+---------------------------------------------------+---------------------------------------------+
| **Course Name**                                   | Business Intelligence II                    |
+---------------------------------------------------+---------------------------------------------+
| **Program**                                       | Bachelor of Business Information Technology |
+---------------------------------------------------+---------------------------------------------+
| **Semester Duration**                             | 21^st^ August 2023 to 28^th^ November 2023  |
+---------------------------------------------------+---------------------------------------------+

# Setup Chunk {#setup-chunk}

**Note:** the following "*KnitR*" options have been set as the defaults:\
`knitr::opts_chunk$set(echo = TRUE, warning = FALSE, eval = TRUE, collapse = FALSE, tidy.opts = list(width.cutoff = 80), tidy = TRUE)`.

More KnitR options are documented here <https://bookdown.org/yihui/rmarkdown-cookbook/chunk-options.html> and here <https://yihui.org/knitr/options/>.

**Note:** the following "*R Markdown*" options have been set as the defaults:

Installing and loading of required packages

``` code
# Language server
if (require("languageserver")) {
  require("languageserver")
} else {
  install.packages("languageserver", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## readr ----
if (require("readr")) {
  require("readr")
} else {
  install.packages("readr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## naniar ----
if (require("naniar")) {
  require("naniar")
} else {
  install.packages("naniar", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## ggplot2 ----
if (require("ggplot2")) {
  require("ggplot2")
} else {
  install.packages("ggplot2", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## corrplot ----
if (require("corrplot")) {
  require("corrplot")
} else {
  install.packages("corrplot", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## ggcorrplot ----
if (require("ggcorrplot")) {
  require("ggcorrplot")
} else {
  install.packages("ggcorrplot", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## caret ----
if (require("caret")) {
  require("caret")
} else {
  install.packages("caret", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## tidyverse ----
if (require("tidyverse")) {
  require("tidyverse")
} else {
  install.packages("tidyverse", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

Loading and viewing of the dataset

``` code

library(readr)
Wine <- read_csv("data/Wine.csv")
View(Wine)


str(Wine)
dim(Wine)
head(Wine)
summary(Wine)
```

Check for Missing Data and Address it

``` code

# Are there missing values in the dataset?
any_na(Wine)

# How many?
n_miss(Wine)

# What is the proportion of missing data in the entire dataset?
prop_miss(Wine)

# What is the number and percentage of missing values grouped by
# each variable?
miss_var_summary(Wine)

# Which variables contain the most missing values?
gg_miss_var(Wine)

# Which combinations of variables are missing together?
gg_miss_upset(Wine)

# Where are missing values located (the shaded regions in the plot)?
vis_miss(Wine) +
  theme(axis.text.x = element_text(angle = 80))
```

Perform EDA and Feature Selection

``` code

# Create a correlation matrix
# Basic Table
cor(Wine[, c(6, 7, 10, 11)]) %>%
  View()

# Basic Plot
cor(Wine[, c(6, 7, 10, 11)]) %>%
  corrplot(method = "square")

# Fancy Plot using ggplot2
corr_matrix <- cor(Wine[, c(6, 7, 10, 11)])

p <- ggplot2::ggplot(data = reshape2::melt(corr_matrix),
                     ggplot2::aes(Var1, Var2, fill = value)) +
  ggplot2::geom_tile() +
  ggplot2::geom_text(ggplot2::aes(label = label_wrap(label, width = 10)),
                     size = 4) +
  ggplot2::theme_minimal() +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))

ggcorrplot(corr_matrix, hc.order = TRUE, type = "lower", lab = TRUE)

## Plot the scatter plots ----
  # A scatter plot to show Phenols against Flavanoids
ggplot(Wine, aes(x=Total_Phenols, y=Flavanoids)) +
  geom_point() +
  geom_smooth(method="lm", se=FALSE) +
  labs(title="Wines Attributes",
       subtitle="Relationship between Phenols and Flavanoids") +
  theme_bw()


# A scatter plot to show Alcohol against Malic Acid
ggplot(Wine, aes(x=Alcohol, y=Malic_Acid)) +
  geom_point() +
  geom_smooth(method="lm", se=FALSE) +
  labs(title="Wines Attributes",
       subtitle="Relationship between Alcohol and Malic Acid") +
  theme_bw()

# A scatter plot to show Magnesium against the Hue
ggplot(Wine, aes(x=Magnesium, y=Hue)) +
  geom_point() +
  geom_smooth(method="lm", se=FALSE) +
  labs(title="Wines Attributes",
       subtitle="Relationship between Magnesium and Hue") +
  theme_bw()
```

Transforming the of data

``` code

# Use only the most significant variables to create the clusters
Wine_vars <-
  Wine_std[, c("Total_Phenols","Flavanoids")]
```

Creating the clusters using the K-Means Clustering Algorithm

``` code

# We start with a random guess of the number of clusters we need
set.seed(7)
kmeans_cluster <- kmeans(Wine_vars, centers = 2, nstart = 20)

# We then decide the maximum number of clusters to investigate
n_clusters <- 3

# Initialize total within sum of squares error: wss
wss <- numeric(n_clusters)

set.seed(7)

# Investigate 1 to n possible clusters (where n is the maximum number of 
# clusters that we want to investigate)
for (i in 1:n_clusters) {
  # Use the K Means cluster algorithm to create each cluster
  kmeans_cluster <- kmeans(Wine_vars, centers = i, nstart = 20)
  # Save the within cluster sum of squares
  wss[i] <- kmeans_cluster$tot.withinss
```

Plotting the results to get visualization of the clustering

``` code

# The scree plot should help you to note when additional clusters do not make any significant difference (the plateau).
wss_df <- tibble(clusters = 1:n_clusters, wss = wss)

scree_plot <- ggplot(wss_df, aes(x = clusters, y = wss, group = 1)) +
  geom_point(size = 4) +
  geom_line() +
  scale_x_continuous(breaks = c(2, 4, 6, 8)) +
  xlab("Number of Clusters")

scree_plot

# We can add guides to make it easier to identify the plateau (or "elbow").
scree_plot +
  geom_hline(
    yintercept = wss,
    linetype = "dashed",
    col = "#000000"  # Set a single color, e.g., black
  )


k <- 3
set.seed(7)
# Build model with k clusters: kmeans_cluster
kmeans_cluster <- kmeans(Wine_vars, centers = k, nstart = 20)

# Add the cluster number as a label for each observation ----
Wine_vars$cluster_id <- factor(kmeans_cluster$cluster)

# View the results by plotting scatter plots with the labelled cluster ----
ggplot(Wine_vars, aes(Total_Phenols, Flavanoids,
                                         color = cluster_id)) +
  geom_point(alpha = 0.5) +
  xlab("Total_Phenols") +
  ylab("Flavanoids")
```
