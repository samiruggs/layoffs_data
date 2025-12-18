-- The ALTER COLUMN code could not convert "NULL' from string to int hence the need to manually convert them using the UPDATE function.
-- Then the ALTER TABLE can now successfully convert.

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




