# Regression-Analysis

# 📊 Regression Analysis of Post-Surgery Hospital Stay Duration

## 📋 Overview

This project analyzes the factors affecting the length of hospital stays after surgery. The analysis is performed using multiple linear regression, ridge regression, and various diagnostic tests to evaluate model performance and assumptions. The aim is to identify key factors and accurately predict hospital stay duration, optimizing resource use in healthcare.

## 🏗️ Project Structure

### 1. 📝 Dataset Introduction

- **Dependent Variable (y):** Duration of hospital stay after surgery (in days).
- **Independent Variables:**
  - **x1:** Age of the patient.
  - **x2:** Number of pre-existing medical conditions.
  - **x3:** Duration of surgery (in hours).
  - **x4:** Type of surgery (categorical: 1, 2, 3).

### 2. 📊 Descriptive Statistics and Data Preprocessing

#### Summary Statistics

- **Hospital Stay (y):**
  - Mean: 60.14 days
  - Median: 59.81 days
  - Standard Deviation: 12.04 days
  - Skewness: 1.00 (positively skewed)
  - Kurtosis: 2.85

- **Patient Age (x1):**
  - Mean: 9.11 years
  - Median: 9.11 years
  - Skewness: 0.07 (approximately symmetric)

- **Number of Medical Conditions (x2):**
  - Mean: 2.03
  - Median: 2.07
  - Skewness: 0.27

- **Surgery Duration (x3):**
  - Mean: 5.92 hours
  - Median: 6.05 hours
  - Skewness: 0.21

- **Type of Surgery (x4):**
  - Categories: 1, 2, 3
  - Mean: 2.14
  - Skewness: -0.27

#### Logarithmic Transformation

- **Log-transformed Hospital Stay (ln_y):**
  - Mean: 4.078
  - Median: 4.091
  - Skewness: 0.02
  - Kurtosis: 1.17

### 3. 📈 Regression Analysis

#### Multiple Linear Regression

- **Model Summary:**
  - **R-squared:** 0.9934
  - **Adjusted R-squared:** 0.993
  - **F-statistic:** 2619, p < 2.2e-16
  - **Residual Standard Error:** 0.01253

- **Regression Equation:**
  \[
  \hat{y} = 2.987973 + 0.141456 \cdot x1 + 0.078017 \cdot x2 - 0.047955 \cdot x3 - 0.102059 \cdot x42 - 0.117459 \cdot x43 \pm 0.01253
  \]

- **Coefficient Interpretation:**
  - **x1 (Age):** Each additional year increases the log-transformed stay duration by 0.141456 units (p < 2e-16).
  - **x2 (Medical Conditions):** Each additional condition increases the log-transformed stay duration by 0.078017 units (p < 2e-16).
  - **x3 (Surgery Duration):** Each additional hour decreases the log-transformed stay duration by 0.047955 units (p < 2e-16).
  - **x42 and x43 (Surgery Types 2 and 3):** Both types decrease the log-transformed stay duration significantly.

#### Model Diagnostics

- **Residual Analysis:**
  - Residuals range from -0.04259 to 0.014133, indicating the model's errors are small and centered around zero.

- **Breusch-Pagan Test:** No heteroscedasticity detected (p = 0.123 > 0.05).
- **Durbin-Watson Test:** No autocorrelation detected (p = 0.1303 > 0.05).

- **Variance Inflation Factor (VIF):**
  - All VIF values < 10, indicating no significant multicollinearity.

#### Ridge Regression Analysis

- **Lambda = 0.40 Coefficients:**
  - **x1:** 0.11054036
  - **x2:** 0.05605792
  - **x3:** -0.03857199
  - **x4:** -0.05201207
  - **x5:** -0.05921916

- **Ridge Trace Plot:**
  - As lambda increases, coefficients shrink towards zero, reducing overfitting and multicollinearity.

### 4. 🚀 Model Performance and Prediction

#### Adjusted R-squared and Confidence Intervals

- **Adjusted R-squared:** 0.9998961
- **R-squared:** 0.9999033
- **95% Confidence Intervals:** Narrow confidence intervals for all coefficients indicate reliable estimates.

#### Prediction and Validation

- **Fit for 10th Observation:**
  - Predicted Value: 69.56521
  - Actual Value: 69.54777
  - 95% Confidence Interval: [69.50993, 69.62049]

- **New Observation Prediction:**
  - Predicted Log-Stay: 41.6579
  - 95% Confidence Interval: [41.20315, 42.11265]

### 5. 🔍 Variable Selection and Best Model

- **Forward Selection, Backward Elimination, and Stepwise Regression** all identify the same best model: y ~ x1 + x2 + x3 + x4.

- **Best Model:** Forward Selection model with 99.99% adjusted R-squared.

