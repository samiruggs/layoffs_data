--- 1. Tried to find out the number of NULLS in each column  

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
FROM dbo.layoff_staging;                                                                             

 --- 2. copied layoff_staging into another back up data layoff_clean but for only distinct values.
SELECT DISTINCT *
INTO layoff_clean
FROM layoff_staging;        

 --- 3. An alternative way of finding the number of NULL in each column, here is just an example for one column
SELECT 
    COUNT(*) - COUNT(total_laid_off) AS total_laid_off_nulls
FROM dbo.layoff_staging;                                     

--- 4. This is to ascertain the outcome of the new data created.   
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

 --- 5. To ascertain the number of distinct rows

SELECT COUNT(*)
FROM dbo.layoff_clean;     

 --- 6. An alternative way to ascertain the distinct row count.

SELECT COUNT(*) AS distinct_row_count
FROM (
    SELECT DISTINCT *
    FROM dbo.layoff_staging
) t;                           

--- 7. This creates a new column rn to determine duplicated rows/ an alternative way to find duplicates. The duplicates are deleted by changing (SELECT * FROM cte) to DELETE FROM cte

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

 --- 8. Select distinct country in alphabetical order for standardization

SELECT DISTINCT country
FROM layoff_staging
ORDER BY 1                    

 --- 9. Standardized United States. This and above was donefor text rows like industry, location etc

UPDATE layoff_staging
SET country = TRIM(REPLACE(country,'.',''))
WHERE country LIKE 'United States%'        

--- 10. Identify null values in the country colunn, same is done with other text columns.   
SELECT *
FROM layoff_staging
WHERE country IS NULL OR country =''       

--- 11. Airbnb row has an empty value so is seperated out for better understanding.

SELECT *
FROM layoff_staging
WHERE company = 'Airbnb'  

--- 12. The empty cell is replaced with Travel, as is obtainable with the others.   
    
UPDATE layoff_staging
SET industry = 'Travel'
WHERE company = 'Airbnb'           

--- 13. Same as done in 12
    
SELECT *
FROM layoff_staging
WHERE company = 'Juul' 

--- 14. Same as done in 12

UPDATE layoff_staging
SET industry = 'Travel'
WHERE company = 'Airbnb'        

--- 15. Same as done in 12

SELECT *
FROM layoff_staging
WHERE company = 'Carvana'           

--- 16. Same as done in 12

UPDATE layoff_staging
SET industry = 'Travel'
WHERE company = 'Airbnb'     

--- 17. Identifying null values in the number fields

SELECT total_laid_off, percentage_laid_off
FROM layoff_staging
WHERE total_laid_off IS NULL OR percentage_laid_off IS NULL   

--- 17. Identifying null values in the industry fields

SELECT *
FROM layoff_staging
WHERE industry IS NULL OR industry = ''    

--- 18. Delete null values as the information is incomplete

WITH cte AS (SELECT *
    FROM layoff_staging
    WHERE total_laid_off IS NULL OR percentage_laid_off IS NULL) 
DELETE FROM cte
WHERE percentage_laid_off IS NULL OR total_laid_off IS NULL;  

--- 19. load the final and cleaned outcome
SELECT *
FROM layoff_staging






