USE layoffs
GO

SELECT *
FROM
dbo.layoff_staging;    -- Before this the UI interface was used to duplicate the layoff data and saving it as layoff_staging

SELECT 
SUM(CASE WHEN company IS NULL THEN 1 ELSE 0 END) AS company_nulls,
SUM(CASE WHEN [location] IS NULL THEN 1 ELSE 0 END) AS location_nulls,
SUM(CASE WHEN industry IS NULL THEN 1 ELSE 0 END) AS industry_nulls,
SUM(CASE WHEN total_laid_off IS NULL THEN 1 ELSE 0 END) AS total_laid_off_nulls,
SUM(CASE WHEN percentage_laid_off IS NULL THEN 1 ELSE 0 END) AS percentage_laid_off_nulls,
SUM(CASE WHEN [date] IS NULL THEN 1 ELSE 0 END) AS date_nulls,
SUM(CASE WHEN stage IS NULL THEN 1 ELSE 0 END) AS stage_nulls,
SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_nulls,
SUM(CASE WHEN funds_raised_millions IS NULL THEN 1 ELSE 0 END) AS fund_raised_millions_nulls
FROM dbo.layoff_staging;                                                                             -- Tried to find out the number of NULLS in each columns

SELECT DISTINCT *
INTO layoff_clean
FROM layoff_staging;         -- copied layoff_staging into another back up data layoff_clean but for only distinct values.

SELECT 
    COUNT(*) - COUNT(total_laid_off) AS total_laid_off_nulls
FROM dbo.layoff_staging;                                      -- An alternative way of finding the number of NULL in each column, here is just an example for one column


USE [Layoffs]
GO

SELECT [company]
      ,[location]
      ,[industry]
      ,[total_laid_off]
      ,[percentage_laid_off]
      ,[date]
      ,[stage]
      ,[country]
      ,[funds_raised_millions]
  FROM [dbo].[layoff_clean]             -- This is ascertain the the outcome of the new data created.        



SELECT COUNT(*)
FROM dbo.layoff_clean;      -- To ascertain the number of distinct rows

SELECT COUNT(*) AS distinct_row_count
FROM (
    SELECT DISTINCT *
    FROM dbo.layoff_staging
) t;                            -- An alternative way to acsertain the distinct row count.

WITH cte AS(SELECT *,
ROW_NUMBER() OVER(PARTITION BY 
company,
[location],
industry
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

SELECT DISTINCT country
FROM layoff_staging
ORDER BY 1

UPDATE layoff_staging
SET country = TRIM(REPLACE(country,'.',''))
WHERE country LIKE 'United States%'

SELECT *
FROM layoff_staging
WHERE country IS NULL OR country = ''

SELECT *
FROM layoff_staging
WHERE company = 'Airbnb'

UPDATE layoff_staging
SET industry = 'Travel'
WHERE company = 'Airbnb'

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
SET industry = 'Travel'
WHERE company = 'Airbnb'

SELECT total_laid_off, percentage_laid_off
FROM layoff_staging
WHERE total_laid_off IS NULL OR percentage_laid_off IS NULL

SELECT *
FROM layoff_staging
WHERE industry IS NULL OR industry = ''


UPDATE layoff_staging
SET industry = 'Cars'
WHERE company = 'Carvana'


SELECT total_laid_off, percentage_laid_off
FROM layoff_staging
WHERE total_laid_off IS NULL OR percentage_laid_off IS NULL;


WITH cte AS (SELECT *
    FROM layoff_staging
    WHERE total_laid_off IS NULL OR percentage_laid_off IS NULL) 
DELETE FROM cte
WHERE percentage_laid_off IS NULL OR total_laid_off IS NULL; 

SELECT *
FROM layoff_staging


SELECT *
FROM layoff_staging
WHERE company = 'Carvana'

