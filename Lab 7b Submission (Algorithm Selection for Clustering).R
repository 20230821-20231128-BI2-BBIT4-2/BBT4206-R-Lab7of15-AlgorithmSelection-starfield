# *****************************************************************************
# Lab 7.b.: Algorithm Selection for Clustering ----
#
# Course Code: BBT4206
# Course Name: Business Intelligence II
# Semester Duration: 21st August 2023 to 28th November 2023
#
# Lecturer: Allan Omondi
# Contact: aomondi [at] strathmore.edu
#
# Note: The lecture contains both theory and practice. This file forms part of
#       the practice. It has required lab work submissions that are graded for
#       coursework marks.
#
# License: GNU GPL-3.0-or-later
# See LICENSE file for licensing information.
# *****************************************************************************

# **[OPTIONAL] Initialization: Install and use renv ----
# The R Environment ("renv") package helps you create reproducible environments
# for your R projects. This is helpful when working in teams because it makes
# your R projects more isolated, portable and reproducible.

# Further reading:
#   Summary: https://rstudio.github.io/renv/
#   More detailed article: https://rstudio.github.io/renv/articles/renv.html

# "renv" It can be installed as follows:
# if (!is.element("renv", installed.packages()[, 1])) {
# install.packages("renv", dependencies = TRUE,
# repos = "https://cloud.r-project.org") # nolint
# }
# require("renv") # nolint

# Once installed, you can then use renv::init() to initialize renv in a new
# project.

# The prompt received after executing renv::init() is as shown below:
# This project already has a lockfile. What would you like to do?

# 1: Restore the project from the lockfile.
# 2: Discard the lockfile and re-initialize the project.
# 3: Activate the project without snapshotting or installing any packages.
# 4: Abort project initialization.

# Select option 1 to restore the project from the lockfile
# renv::init() # nolint

# This will set up a project library, containing all the packages you are
# currently using. The packages (and all the metadata needed to reinstall
# them) are recorded into a lockfile, renv.lock, and a .Rprofile ensures that
# the library is used every time you open the project.

# Consider a library as the location where packages are stored.
# Execute the following command to list all the libraries available in your
# computer:
.libPaths()

# One of the libraries should be a folder inside the project if you are using
# renv

# Then execute the following command to see which packages are available in
# each library:
lapply(.libPaths(), list.files)

# This can also be configured using the RStudio GUI when you click the project
# file, e.g., "BBT4206-R.Rproj" in the case of this project. Then
# navigate to the "Environments" tab and select "Use renv with this project".

# As you continue to work on your project, you can install and upgrade
# packages, using either:
# install.packages() and update.packages or
# renv::install() and renv::update()

# You can also clean up a project by removing unused packages using the
# following command: renv::clean()

# After you have confirmed that your code works as expected, use
# renv::snapshot(), AT THE END, to record the packages and their
# sources in the lockfile.

# Later, if you need to share your code with someone else or run your code on
# a new machine, your collaborator (or you) can call renv::restore() to
# reinstall the specific package versions recorded in the lockfile.

# [OPTIONAL]
# Execute the following code to reinstall the specific package versions
# recorded in the lockfile (restart R after executing the command):
# renv::restore() # nolint

# [OPTIONAL]
# If you get several errors setting up renv and you prefer not to use it, then
# you can deactivate it using the following command (restart R after executing
# the command):
# renv::deactivate() # nolint

# If renv::restore() did not install the "languageserver" package (required to
# use R for VS Code), then it can be installed manually as follows (restart R
# after executing the command):

if (require("languageserver")) {
  require("languageserver")
} else {
  install.packages("languageserver", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

# Introduction ----
# Clustering is a type of unsupervised machine learning technique that aims to
# group similar data points together into clusters or segments based on certain
# characteristics or similarities, without the need for predefined labels or
# target outcomes. In clustering, the goal is to discover hidden patterns or
# structures in data and to create natural groupings of data points.

## Some Applications of Clustering ----

### 1. Customer segmentation ----
# Grouping customers into segments with similar purchase behavior or
# demographics.

### 2. Anomaly detection ----
# Identifying unusual or outlier data points.

### 3. Document categorization ----
# Clustering documents based on their content to
# discover topics or themes.

### 4. Image segmentation ----
# Segmenting an image into different regions based on
# color or texture.

### 5. Genetic analysis ----
# Clustering genes or proteins with similar functions.

# In R, there are several clustering algorithms you can use. The choice of
# clustering algorithm depends on the nature of your data, the number of
# clusters you want to find, and the specific requirements of your analysis.

## Popular clustering algorithms ----

### 1. K-Means Clustering ----
# K-means is a partitioning-based clustering algorithm that divides the data
# into K non-overlapping clusters. It aims to minimize the sum of squared
# distances from data points to the cluster center.
# Example usage: kmeans_result <- kmeans(data, centers = K)

### 2. Hierarchical Clustering ----
# Hierarchical clustering creates a hierarchy of clusters by repeatedly merging
# or splitting existing clusters. It does not require specifying the number of
# clusters in advance.
# Example usage: hclust_result <- hclust(dist(data))

### 3. DBSCAN (Density-Based Spatial Clustering of Applications with Noise) ----
# DBSCAN groups data points based on their density. It can discover clusters of
# arbitrary shapes and identify outliers as noise.
# Example usage: dbscan_result <- dbscan(data, eps = 0.5, minPts = 5)

### 4. Agglomerative Clustering ----
# Agglomerative clustering is a hierarchical clustering algorithm that starts
# with individual data points as clusters and merges them gradually.
# Example usage: agnes_result <- agnes(data)

### 5. OPTICS (Ordering Points To Identify the Clustering Structure) ----
# OPTICS is a density-based clustering algorithm that provides a visualization
# of the cluster structure of the data.

### 6. Gaussian Mixture Models (GMM) ----
# GMM is a probabilistic model that assumes that the data is generated from a
# mixture of several Gaussian distributions.
# Example usage: gmm_result <- Mclust(data)

# The choice of clustering algorithm depends on factors such as data
# distribution, the number of clusters, noise tolerance, and the problem you
# are trying to solve. It is often a good practice to try multiple algorithms
# and assess their results to determine the best approach for your specific
# data and objectives.

## Performance Metrics for Clustering ----
# Given that clustering is unsupervised learning and it does not use labeled
# data, we cannot calculate performance metrics like accuracy, Cohen's Kappa,
# AUC, LogLoss, RMSE, R squared, etc., to compare different algorithms and
# their models. As a result, assessing the performance of clustering models
# is challenging and subjective.

# The subjective assessment involves determining whether the clustering model
# is interpretable, whether the output of the clustering model is useful, and
# whether the clustering model has led to the discovery of new patterns in the
# data.

## The K-Means Clustering Algorithm ----
# The K-Means clustering algorithm is a popular algorithm for clustering tasks
# because of its intuition and ease of implementation.

# K-Means is a centroid-based algorithm where the ML Engineer must define the
# required number of clusters to be created. The number of clusters can be
# informed by the business use-case or through trial and error.

### Steps in K-Means Clustering ----
#     1. Choose the number of clusters, k.
#     2. Select k points (clusters of size 1) at random. These are referred to
#        as the centroids.
#     3. Calculate the distance between each point and the centroid and assign
#        each data point to the closest centroid.
#     4. Calculate the centroid (mean position) for each cluster based on the
#        assigned data points. This will change the position of the centroid.
#     5. Repeat steps 3–4 until the clusters do not change or until the
#        maximum number of iterations is reached.

# Watch the following video: https://youtu.be/4b5d3muPQmA?si=7F9d2A6_MlqSsag2

# STEP 1. Install and Load the Required Packages ----
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

# STEP 2. Load the Dataset ----

library(readr)
Wine <- read_csv("data/Wine.csv")
View(Wine)


str(Wine)
dim(Wine)
head(Wine)
summary(Wine)

# STEP 3. Check for Missing Data and Address it ----
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


# STEP 4. Perform EDA and Feature Selection ----
## Compute the correlations between variables ----
# We identify the correlated variables because it is these correlated variables
# that can then be used to identify the clusters.

# Create a correlation matrix
# Option 1: Basic Table
cor(Wine[, c(6, 7, 10, 11)]) %>%
  View()

# Option 2: Basic Plot
cor(Wine[, c(6, 7, 10, 11)]) %>%
  corrplot(method = "square")

# Option 3: Fancy Plot using ggplot2
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



## Transform the data ----
# The K Means Clustering algorithm performs better when data transformation has
# been applied. This helps to standardize the data making it easier to compare
# multiple variables.

summary(Wine)
model_of_the_transform_wine <- preProcess(Wine,
                                          method = c("scale", "center"))
print(model_of_the_transform_wine)
Wine_std <- predict(model_of_the_transform_wine, Wine)
summary(Wine_std)
sapply(Wine_std[, c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13)], sd)

# OPTION 2: Use only the most significant variables to create the clusters
# This can be informed by feature selection, or by the business case.

Wine_vars <-
  Wine_std[, c("Total_Phenols","Flavanoids")]

# STEP 5. Create the clusters using the K-Means Clustering Algorithm ----
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
}

## Plot a scree plot ----
# The scree plot should help you to note when additional clusters do not make
# any significant difference (the plateau).
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

# The plateau is reached at 6 clusters.
# We therefore create the final cluster with 6 clusters
# (not the initial 3 used at the beginning of this STEP.)
k <- 3
set.seed(7)
# Build model with k clusters: kmeans_cluster
kmeans_cluster <- kmeans(Wine_vars, centers = k, nstart = 20)

# STEP 6. Add the cluster number as a label for each observation ----
Wine_vars$cluster_id <- factor(kmeans_cluster$cluster)

## View the results by plotting scatter plots with the labelled cluster ----
ggplot(Wine_vars, aes(Total_Phenols, Flavanoids,
                                         color = cluster_id)) +
  geom_point(alpha = 0.5) +
  xlab("Total_Phenols") +
  ylab("Flavanoids")


# Note on Clustering for both Descriptive and Predictive Data Analytics ----
# Clustering can be used for both descriptive and predictive analytics.
# It is more commonly used around Exploratory Data Analysis which is
# descriptive analytics.

# The results of clustering, i.e., a label of the cluster can be fed as input
# to a supervised learning algorithm. The trained model can then be used to
# predict the cluster that a new observation will belong to.

# References ----
## Ali, M. (2022, August). Clustering in Machine Learning: 5 Essential Clustering Algorithms. https://www.datacamp.com/blog/clustering-in-machine-learning-5-essential-clustering-algorithms # nolint ----

## Cox, M., Morris, J., & Higgins, T. (2023). Airbnb Dataset for Cape Town in South Africa [Dataset; CSV]. Inside Airbnb. http://insideairbnb.com/cape-town/ # nolint ----

