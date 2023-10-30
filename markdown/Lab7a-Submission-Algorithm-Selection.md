Business Intelligence Lab Submission Markdown
================
<Specify your group name here>
<Specify the date when you submitted the lab>

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
if (require("stats")) {
  require("stats")
} else {
  install.packages("stats", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

if (require("mlbench")) {
  require("mlbench")
} else {
  install.packages("mlbench", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

if (require("caret")) {
  require("caret")
} else {
  install.packages("caret", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

if (require("MASS")) {
  require("MASS")
} else {
  install.packages("MASS", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

if (require("glmnet")) {
  require("glmnet")
} else {
  install.packages("glmnet", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

if (require("e1071")) {
  require("e1071")
} else {
  install.packages("e1071", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

if (require("kernlab")) {
  require("kernlab")
} else {
  install.packages("kernlab", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

if (require("rpart")) {
  require("rpart")
} else {
  install.packages("rpart", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

Linear Regression Analysis on the IRIS Dataset

``` code

library(readr)
IRIS <- read_csv("data/IRIS.csv")
View(IRIS)

train_index <- createDataPartition(IRIS$petal_width,
                                   p = 0.8,
                                   list = FALSE)
IRIS_train <- IRIS[train_index, ]
IRIS_test <-IRIS[-train_index, ]

IRIS_model_lm <- lm(petal_width ~ ., IRIS_train)

print(IRIS_model_lm)

predictions <- predict(IRIS_model_lm, IRIS_test[, 1:5])

rmse <- sqrt(mean((IRIS_test$petal_width - predictions)^2))
print(paste("RMSE =", sprintf(rmse, fmt = "%#.4f")))

ssr <- sum((IRIS_test$petal_width - predictions)^2)
print(paste("SSR =", sprintf(ssr, fmt = "%#.4f")))

sst <- sum((IRIS_test$petal_width - mean(IRIS_test$petal_width))^2)
print(paste("SST =", sprintf(sst, fmt = "%#.4f")))

print(paste("R Squared =", sprintf(r_squared, fmt = "%#.4f")))

absolute_errors <- abs(predictions - IRIS_test$petal_width)
mae <- mean(absolute_errors)
print(paste("MAE =", sprintf(mae, fmt = "%#.4f")))
```

Logistic Regression Analysis

``` code

library(readr)
IRIS <- read_csv("data/IRIS.csv")
View(IRIS)

train_index <- createDataPartition(IRIS$species,
                                   p = 0.7,
                                   list = FALSE)
IRIS_train <- IRIS[train_index, ]
IRIS_test <- IRIS[-train_index, ]

train_control <- trainControl(method = "cv", number = 5)

set.seed(7)
species_caret_model_logistic <-
  train(species ~ ., data = IRIS_train,
        method = "regLogistic", metric = "Accuracy",
        preProcess = c("center", "scale"), trControl = train_control)

print(species_caret_model_logistic)

predictions <- predict(species_caret_model_logistic,
                       IRIS_test[, 1:4])

all_species_levels <- unique(IRIS$species)

predictions <- factor(predictions, levels = all_species_levels)
IRIS_test$species <- factor(IRIS_test$species, levels = all_species_levels)

confusion_matrix <- caret::confusionMatrix(predictions, IRIS_test$species)
print(confusion_matrix)

library(ggplot2)

conf_matrix <- as.table(confusion_matrix)
heatmap(conf_matrix, col = c("grey", "lightblue"), main = "Confusion Matrix", xlab = "Predicted", ylab = "Actual")
```

Linear Discriminant Analysis

``` code

library(readr)
IRIS <- read_csv("data/IRIS.csv")
View(IRIS)

train_index <- createDataPartition(IRIS$species,
                                   p = 0.7,
                                   list = FALSE)
IRIS_train <- IRIS[train_index, ]
IRIS_test <- IRIS[-train_index, ]

species_model_lda <- lda(species ~ ., data = IRIS_train)

print(species_model_lda)

predictions <- predict(species_model_lda,
                       IRIS_test[, 1:4])$class

table(predictions, IRIS_test$species)
```

Regularized Linear Regression Classification Problem without CARET

``` code

library(readr)
IRIS <- read_csv("data/IRIS.csv")
View(IRIS)
x <- as.matrix(IRIS[, 1:4])
y <- as.matrix(IRIS[, 5])

species_model_glm <- glmnet(x, y, family = "multinomial",
                             alpha = 0.5, lambda = 0.001)
--
print(species_model_glm)

predictions <- predict(species_model_glm, x, type = "class")

table(predictions, IRIS$species)
```

Regularized Linear Regression Classification Problem with CARET

``` code
library(readr)
IRIS <- read_csv("data/IRIS.csv")

train_index <- createDataPartition(IRIS$species,
                                   p = 0.7,
                                   list = FALSE)
IRIS_train <- IRIS[train_index, ]
IRIS_test <- IRIS[-train_index, ]

set.seed(7)
train_control <- trainControl(method = "cv", number = 5)
species_caret_model_glmnet <-
  train(species ~ ., data = IRIS_train,
        method = "glmnet", metric = "Accuracy",
        preProcess = c("center", "scale"), trControl = train_control)

print(species_caret_model_glmnet)

predictions <- predict(species_caret_model_glmnet,
                       IRIS_test[, 1:4])

# Determine the unique species levels present in your dataset
all_species_levels <- unique(IRIS$species)

predictions <- factor(predictions, levels = all_species_levels)
IRIS_test$species <- factor(IRIS_test$species, levels = all_species_levels)

confusion_matrix <- caret::confusionMatrix(predictions, IRIS_test$species)
print(confusion_matrix)

library(ggplot2)

conf_matrix <- as.table(confusion_matrix)
heatmap(conf_matrix, col = c("grey", "lightblue"), main = "Confusion Matrix", xlab = "Predicted", ylab = "Actual")
```

Non-Linear Algorithms

``` code
library(readr)
IRIS <- read_csv("data/IRIS.csv")

train_index <- createDataPartition(IRIS$species,
                                   p = 0.7,
                                   list = FALSE)
IRIS_train <- IRIS[train_index, ]
IRIS_test <- IRIS[-train_index, ]

species_model_rpart <- rpart(species ~ ., data = IRIS_train)
]
print(species_model_rpart)

predictions <- predict(species_model_rpart,
                       IRIS_test[, 1:4],
                       type = "class")

all_species_levels <- unique(IRIS$species)

predictions <- factor(predictions, levels = all_species_levels)
IRIS_test$species <- factor(IRIS_test$species, levels = all_species_levels)

confusion_matrix <- caret::confusionMatrix(predictions, IRIS_test$species)
print(confusion_matrix)

library(ggplot2)
x
conf_matrix <- as.table(confusion_matrix)
heatmap(conf_matrix, col = c("grey", "lightblue"), main = "Confusion Matrix", xlab = "Predicted", ylab = "Actual")
```

Decision tree for a classification problem with caret

``` code

train_index <- createDataPartition(IRIS$species,
                                   p = 0.7,
                                   list = FALSE)
IRIS_train <- IRIS[train_index, ]
IRIS_test <- IRIS[-train_index, ]

set.seed(7)
train_control <- trainControl(method = "cv", number = 5)
species_caret_model_rpart <- train(species ~ ., data = IRIS,
                                    method = "rpart", metric = "Accuracy",
                                    trControl = train_control)

print(species_caret_model_rpart)

predictions <- predict(species_model_rpart,
                       IRIS_test[, 1:4],
                       type = "class")

# Determine the unique species levels present in your dataset
all_species_levels <- unique(IRIS$species)

predictions <- factor(predictions, levels = all_species_levels)
IRIS_test$species <- factor(IRIS_test$species, levels = all_species_levels)

confusion_matrix <- caret::confusionMatrix(predictions, IRIS_test$species)
print(confusion_matrix)

library(ggplot2)

conf_matrix <- as.table(confusion_matrix)
heatmap(conf_matrix, col = c("grey", "lightblue"), main = "Confusion Matrix", xlab = "Predicted", ylab = "Actual")
```

Naïve Bayes

``` code
library(readr)
IRIS <- read_csv("data/IRIS.csv")

train_index <- createDataPartition(IRIS$species,
                                   p = 0.7,
                                   list = FALSE)
IRIS_train <- IRIS[train_index, ]
IRIS_test <- IRIS[-train_index, ]

species_model_nb <- naiveBayes(species ~ .,
                                data = IRIS_train)

print(species_model_nb)

predictions <- predict(species_model_nb,
                       IRIS_test[, 1:4])

all_species_levels <- unique(IRIS$species)

predictions <- factor(predictions, levels = all_species_levels)

confusion_matrix <- caret::confusionMatrix(predictions, IRIS_test$species)
print(confusion_matrix)

library(ggplot2)

conf_matrix <- as.table(confusion_matrix)
heatmap(conf_matrix, col = c("grey", "lightblue"), main = "Confusion Matrix", xlab = "Predicted", ylab = "Actual")
```

k-Nearest Neighbour

``` code
library(readr)
IRIS <- read_csv("data/IRIS.csv")

train_index <- createDataPartition(IRIS$species,
                                   p = 0.7,
                                   list = FALSE)
IRIS_train <- IRIS[train_index, ]
IRIS_test <- IRIS[-train_index, ]

species_caret_model_knn <- knn3(species ~ ., data = IRIS_train, k=3)

print(species_caret_model_knn)

predictions <- predict(species_caret_model_knn,
                       IRIS_test[, 1:4],
                       type = "class")

table(predictions, IRIS_test$species)
```

KNN for a classification problem with CARET’s train function

``` code
library(readr)
IRIS <- read_csv("data/IRIS.csv")

train_index <- createDataPartition(IRIS$species,
                                   p = 0.7,
                                   list = FALSE)
IRIS_train <- IRIS[train_index, ]
IRIS_test <- IRIS[-train_index, ]

set.seed(7)
train_control <- trainControl(method = "cv", number = 10)
species_caret_model_knn <- train(species ~ ., data = IRIS,
                                  method = "knn", metric = "Accuracy",
                                  preProcess = c("center", "scale"),
                                  trControl = train_control)

print(species_caret_model_knn)

all_species_levels <- unique(IRIS$species)

predictions <- factor(predictions, levels = all_species_levels)
IRIS_test$species <- factor(IRIS_test$species, levels = all_species_levels)

confusion_matrix <- caret::confusionMatrix(predictions, IRIS_test$species)
print(confusion_matrix)

library(ggplot2)

conf_matrix <- as.table(confusion_matrix)
heatmap(conf_matrix, col = c("grey", "lightblue"), main = "Confusion Matrix", xlab = "Predicted", ylab = "Actual")
```

Support Vector Machine

``` code
library(readr)
IRIS <- read_csv("data/IRIS.csv")

train_index <- createDataPartition(IRIS$species,
                                   p = 0.7,
                                   list = FALSE)
IRIS_train <- IRIS[train_index, ]
IRIS_test <- IRIS[-train_index, ]

set.seed(7)
train_control <- trainControl(method = "cv", number = 5)
species_caret_model_svm_radial <- # nolint: object_length_linter.
  train(species ~ ., data = IRIS_train, method = "svmRadial",
        metric = "Accuracy", trControl = train_control)

print(species_caret_model_svm_radial)

predictions <- predict(species_caret_model_svm_radial,
                       IRIS_test[, 1:4])

table(predictions, IRIS_test$species)
all_species_levels <- unique(IRIS$species)

predictions <- factor(predictions, levels = all_species_levels)
IRIS_test$species <- factor(IRIS_test$species, levels = all_species_levels)

confusion_matrix <- caret::confusionMatrix(predictions, IRIS_test$species)
print(confusion_matrix)

library(ggplot2)

conf_matrix <- as.table(confusion_matrix)
heatmap(conf_matrix, col = c("grey", "lightblue"), main = "Confusion Matrix", xlab = "Predicted", ylab = "Actual")
```

SVM classifier for a regression problem with CARET

``` code

data(BostonHousing)

train_index <- createDataPartition(BostonHousing$medv,
                                   p = 0.8,
                                   list = FALSE)
boston_housing_train <- BostonHousing[train_index, ]
boston_housing_test <- BostonHousing[-train_index, ]

set.seed(7)
train_control <- trainControl(method = "cv", number = 5)
housing_caret_model_svm_radial <-
  train(medv ~ ., data = boston_housing_train,
        method = "svmRadial", metric = "RMSE",
        trControl = train_control)

print(housing_caret_model_svm_radial)

predictions <- predict(housing_caret_model_svm_radial,
                       boston_housing_test[, 1:13])

rmse <- sqrt(mean((boston_housing_test$medv - predictions)^2))
print(paste("RMSE =", sprintf(rmse, fmt = "%#.4f")))

ssr <- sum((boston_housing_test$medv - predictions)^2)
print(paste("SSR =", sprintf(ssr, fmt = "%#.4f")))

sst <- sum((boston_housing_test$medv - mean(boston_housing_test$medv))^2)
print(paste("SST =", sprintf(sst, fmt = "%#.4f")))

r_squared <- 1 - (ssr / sst)
print(paste("R Squared =", sprintf(r_squared, fmt = "%#.4f")))

absolute_errors <- abs(predictions - boston_housing_test$medv)
mae <- mean(absolute_errors)
print(paste("MAE =", sprintf(mae, fmt = "%#.4f")))
```
