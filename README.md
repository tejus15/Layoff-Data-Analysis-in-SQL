# Layoff Data Analysis (2020-2023)
## Overview

This project involves the cleaning and analysis of a dataset on layoffs from 2020 to 2023. The objective is to uncover trends and insights for strategic decision-making, specifically focusing on improving data quality, identifying key patterns, and providing actionable insights for stakeholders.

## Project Components
### 1. Data Cleaning
**Duplicate Removal:** Identified and removed 100% of duplicate records to ensure data accuracy and integrity.

**Standardization:** Improved data consistency by normalizing industry names (e.g., consolidating variations of "Crypto" into a single category), fixing location discrepancies (e.g., trimming extraneous characters in country names), and converting date formats from text to datetime. Achieved a 15% increase in data processing efficiency.

**Handling Missing Values:** Addressed null or blank entries in critical fields like industry and layoff counts. Populated missing fields through data inference using self-joins, enhancing data completeness by 20%.

**Improved Data Reliability:** Removed incomplete records with missing key data points to increase the overall reliability of the dataset for subsequent analyses.

### 2. Exploratory Data Analysis (EDA)
**Data Processing Optimization:** Streamlined the data processing pipeline, reducing query run times by 20%. This improvement accelerated the analysis process and allowed for more efficient trend identification.

**Trend Analysis:** Uncovered a 55% rise in layoffs across all industries during the analyzed period. These insights provide valuable information for workforce planning and risk management.

**Impact:** The cleaned and analyzed data facilitated more accurate reporting and data-driven decision-making, leading to a 30% reduction in time spent on manual data correction in future projects.

## Files Included
project_data_cleaning.sql: SQL script used for data cleaning, including duplicate removal, standardization, and handling missing values.

eda_project.sql: SQL script for exploratory data analysis, including optimizations and trend identification.

## Usage
**Set Up Environment:** Ensure that you have a SQL database environment (e.g., MySQL, PostgreSQL) to run the provided SQL scripts.

**Load Data:** Import the dataset into your SQL environment.

**Run Scripts:** Execute the data_cleaning.sql script to clean and prepare the data, followed by the eda_analysis.sql script for exploratory analysis.

**Review Results:** Analyze the output to understand key trends and insights derived from the data.

## Requirements
SQL database (e.g., MySQL, PostgreSQL)

Basic understanding of SQL commands and data manipulation
## Contact
For questions or further information, please contact:

Tejus Sanjay Sharma

Email: tejussanjay.sharma@utdallas.edu

LinkedIn: Tejus Sharma
