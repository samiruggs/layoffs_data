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
  FROM [dbo].[layoff_clean]

GO

SELECT COUNT(*)
FROM dbo.layoff_clean;

SELECT COUNT(*) AS distinct_row_count
FROM (
    SELECT DISTINCT *
    FROM dbo.layoff_staging
) t;

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
