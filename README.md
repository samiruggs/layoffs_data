# Data Cleaning Using SQL 

## Project Overview

This project focuses on performing cleaning processes on the dataset.

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
```

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
```

## Objectives of the Analysis

- Understand the structure of the dataset
  
- Convert columns to appropriate data types
  
- Identify and remove duplicates

- Handle missing and inconsistent data

- Handling null values

- Validate data quality after cleaning

## Data Cleaning Steps

### Understand the Data
```sql
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
```

```sql
SELECT 
	COLUMN_NAME,
	DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'layoffs'
```
**Output:**

|COLUMN_NAME|	DATA_TYPE|
|-----------|------------|
|company    |	nvarchar |
|location	|nvarchar    |
|industry	|nvarchar    |
|total_laid_off	| nvarchar     |
|percentage_laid_off|nvarchar |
|date	    |date        |
|stage	    |nvarchar    |
|country	|nvarchar    |
|funds_raised_millions|nvarchar |

### Change of data type consistent with the elements in each fields

```sql
UPDATE layoffs
SET total_laid_off = NULL
WHERE total_laid_off = 'NULL';

UPDATE layoffs
SET percentage_laid_off = NULL
WHERE percentage_laid_off = 'NULL';

UPDATE layoffs
SET funds_raised_millions = NULL
WHERE funds_raised_millions = 'NULL';


ALTER TABLE layoffs
ALTER COLUMN total_laid_off INT;

ALTER TABLE layoffs
ALTER COLUMN percentage_laid_off FLOAT;

ALTER TABLE layoffs
ALTER COLUMN funds_raised_millions FLOAT;

SELECT 
	COLUMN_NAME,
	DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'layoffs'
```

**Output:**

|COLUMN_NAME|	DATA_TYPE|
|-----------|------------|
|company    |	nvarchar |
|location	|nvarchar    |
|industry	|nvarchar    |
|total_laid_off	| int    |
|percentage_laid_off|float|
|date	    |date        |
|stage	    |nvarchar    |
|country	|nvarchar    |
|funds_raised_millions|float|


### Make a copy of my data incase of any mistakes
```sql
CREATE TABLE layoff_staging
LIKE layoffs;
```

### Make a copy of Distinct Rows

```sql
SELECT DISTINCT *
	INTO layoff_clean
FROM layoff_staging;
```
Alternatively, Duplicates were identified and removed to ensure accurate analysis.

### Identify Duplicate Rows

```sql
WITH cte AS(SELECT *,
ROW_NUMBER() OVER(PARTITION BY 
       company
      ,[location]
      ,industry
      ,[total_laid_off]
      ,[percentage_laid_off]
      ,[date]
      ,[stage]
      ,[country]
      ,[funds_raised_millions]
      ORDER BY country) AS rn
  FROM [Layoffs].[dbo].[layoff_staging])
  SELECT * FROM cte
  WHERE rn > 1
```

**Output:**

| Company           | Location        | Industry        | Total_Laid_Off | Percentage_Laid_Off | Date       | Stage     | Country          | Funds_Raised | Duplicate_Count |
|-------------------|-----------------|-----------------|----------------|---------------------|------------|-----------|------------------|--------------|-----------------|
| Casper            | New York City   | Retail          | NULL           | NULL                | 2021-09-14 | Post-IPO  | United States    | 339          | 2               |
| Cazoo             | London          | Transportation  | 750            | 0.15                | 2022-06-07 | Post-IPO  | United Kingdom   | 2000         | 2               |
| Hibob             | Tel Aviv        | HR              | 70             | 0.30                | 2020-03-30 | Series A  | Israel           | 45           | 2               |
| Wildlife Studios  | Sao Paulo       | Consumer        | 300            | 0.20                | 2022-11-28 | Unknown   | Brazil           | 260          | 2               |
| Yahoo             | SF Bay Area     | Consumer        | 1600           | 0.20                | 2023-02-09 | Acquired  | United States    | 6            | 2               |


### Delete Duplicate Rows

```sql
WITH cte AS(SELECT *,
ROW_NUMBER() OVER(PARTITION BY 
       company
      ,[location]
      ,industry
      ,[total_laid_off]
      ,[percentage_laid_off]
      ,[date]
      ,[stage]
      ,[country]
      ,[funds_raised_millions]
      ORDER BY country) AS rn
  FROM [Layoffs].[dbo].[layoff_staging])
  DELETE FROM cte
  WHERE rn > 1
```
**Check:**

```sql
WITH cte AS(SELECT *,
ROW_NUMBER() OVER(PARTITION BY 
       company
      ,[location]
      ,industry
      ,[total_laid_off]
      ,[percentage_laid_off]
      ,[date]
      ,[stage]
      ,[country]
      ,[funds_raised_millions]
      ORDER BY country) AS rn
  FROM [Layoffs].[dbo].[layoff_staging])
  SELECT * FROM cte
  WHERE rn > 1
```

**Output:**

| company | location | industry | total_laid_off | percentage_laid_off | date | stage | country | funds_raised_millions |
|--------|----------|----------|----------------|---------------------|------|-------|---------|-----------------------|


###  standardize elements across company, country, location, industry columns.

```sql
SELECT DISTINCT company
FROM layoff_staging
ORDER BY 1                 --- There were no errors found here
```
```sql
SELECT DISTINCT location
FROM layoff_staging
ORDER BY 1                  --- Two errors were found Dusseldorf  & Malmo due to sign spellings
```

--- Output

| location    |
|-------------|
| Dusseldorf  |
| Düsseldorf  |

| location |
|----------|
| Malmo    |
| Malmö    |



```sql
 --- Correction of the error
UPDATE layoff_staging
SET location = Dusseldorf
WHERE location LIKE '%dorf'

UPDATE layoff_staging
SET location = Malmo
WHERE location LIKE 'Mal%'
```


```sql
--- Do same for country

SELECT DISTINCT country
FROM layoff_staging
ORDER BY 1              --- An error was found
```
**Output:**

| country         |
|-----------------|
| United States   |
| United States.  |


```sql
 --- Correction of the error
UPDATE layoff_staging
SET country = TRIM(REPLACE(country,'.',''))
WHERE country LIKE 'United States%'           
```
**check Industry**

```sql
SELECT DISTINCT industry
FROM layoff_staging
ORDER BY 1                  --- Two errors were found due to different representations of Crypto, Crypto Currency etc        
```
**Output:**

| industry        |
|-----------------|
| Crypto          |
| Crypto Currency |
| CryptoCurrency  |


```sql
 --- Correction of the error
UPDATE layoff_staging
SET location = Crypto
WHERE location LIKE 'Crypto%'
```


### Checked for null and empty values across columns and decided whether to keep, replace, or remove them.

```sql

SELECT *
	FROM layoff_staging
	WHERE country IS NULL OR country = ''      --- No error was found here
```

```sql

SELECT *
FROM layoff_staging
WHERE company IS NULL OR company = ''    --- three errors were found
```

```sql

SELECT *
FROM layoff_staging
WHERE company = 'Airbnb'                --- checked what the missing values were

UPDATE layoff_staging
SET industry = 'Travel'
WHERE company = 'Airbnb'                 --- Replace the missing values

SELECT *
FROM layoff_staging
WHERE company = 'Juul'

UPDATE layoff_staging
SET industry = 'Travel'
WHERE company = 'Airbnb'

SELECT *
FROM layoff_staging
WHERE company = 'Carvana'

UPDATE layoff_staging
SET industry = 'Cars'
WHERE company = 'Carvana'
```

### Handling the NULL values of the number columns

**Identify the NULL values**

```sql
SELECT total_laid_off, percentage_laid_off
FROM layoff_staging
WHERE total_laid_off IS NULL OR percentage_laid_off IS NULL
```

**Delete all rows containing the null values**

```sql
WITH cte AS (SELECT *
    FROM layoff_staging
    WHERE total_laid_off IS NULL OR percentage_laid_off IS NULL) 
DELETE FROM cte
WHERE percentage_laid_off IS NULL OR total_laid_off IS NULL; 
```


