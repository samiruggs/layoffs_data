# Exploratory Data Analysis (EDA) Using SQL 

## Project Overview

This project focuses on performing **Exploratory Data Analysis (EDA)** using **SQL** to understand, clean, and extract insights from the dataset.

**Dataset Name:** Layoffs Dataset

**Tools Used:** SQL Server (SSMS), GitHub

**SQL Dialect:** T-SQL

## Dataset Description

The dataset contains global layoff data across multiple companies, industries, and countries, covering the period from 2020 to 2023.

**Source of the data:** This dataset was sourced from [here](https://github.com/AlexTheAnalyst/MySQL-YouTube-Series/blob/main/layoffs.csv)

**Number of rows and columns:** 

 | row_count	| column_count |
 |------------|--------------|
 |   2361	    |     9        |

**sql code:**

```sql
SELECT
	COUNT (*) AS row_count,
	(SELECT COUNT(*) 
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'layoffs') AS column_count
FROM dbo.layoffs;

**Time period covered:**

|minimum_date |	maximum_date|
|-------------|-------------|
|2020-03-11	  |2023-03-06   |

**sql code:**

```sql
SELECT 
    MIN([date]) AS minimum_date,
    MAX([date]) AS maximum_date
FROM dbo.layoffs;

