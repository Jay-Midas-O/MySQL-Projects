---------------------------------------------------------------------------------------------------- Data Cleaning ----------------------------------------------------------------------------------------------------
USE world_layoffs;

SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank values
-- 4. Remove Any Columns

CREATE TABLE layoff_staging
LIKE layoffs;

SELECT *
FROM layoff_staging;

SELECT 
	Company
FROM layoff_staging;
--WHERE location = 'New York';

INSERT INTO layoff_staging
SELECT * 
FROM layoffs;


-- REMOVE DUPLICATE
SELECT *,
	ROW_NUMBER () OVER (
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised) AS row_num 
FROM layoff_staging;


-- CREATE A CTE TO CHECK WHETHER THERE ARE DUPLICATES IN THE DATASET

WITH Duplicate_cte AS
(
SELECT *,
	ROW_NUMBER () OVER (
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised) AS row_num 
FROM layoff_staging
) 

SELECT *
FROM Duplicate_cte
WHERE row_num >2;

-- INCASE OF DUPLICATES, USE THESE

CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoff_staging2;

INSERT INTO layoff_staging2
SELECT *,
	ROW_NUMBER () OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised) AS row_num 
FROM layoff_staging;

SELECT *
FROM layoff_staging2
WHERE row_num >2;

DELETE
FROM layoff_staging2
WHERE row_num >2;

-- 2. Standardizing Data

SELECT DISTINCT (company)
FROM layoff_staging;


SELECT 
	company, 
	TRIM(company) AS Trimed
FROM layoff_staging;

UPDATE layoff_staging
SET company = TRIM(company);

SELECT *
FROM layoff_staging;

SELECT 
	DISTINCT industry
FROM layoff_staging
ORDER BY 1;

-- IF THERE ARE DIFFERENCE IN THE COLUMN DATA, USE THIS

-- UPDATE layoff_staging
-- SET industry = 'Aerospace'
-- WHERE industry LIKE 'Aero%';

SELECT 
	DISTINCT industry
FROM layoff_staging
WHERE industry LIKE 'Aerospace';

SELECT 
	DISTINCT location
FROM layoff_staging
ORDER BY 1;

SELECT 
	DISTINCT country
FROM layoff_staging
WHERE country LIKE 'U%';

-- ORDER BY 1;
SELECT 
	DISTINCT country
FROM layoff_staging
ORDER BY 1;

UPDATE layoff_staging
SET country = 'United Arab Emirate'
WHERE country = 'UAE';

-- CHANGING THE DATA FORMAT TO ACTUAL SQL DATA TYPE

SELECT 
	`date`,
	str_to_date(`date` ,'%Y/%m/%d')
FROM layoff_staging;

UPDATE layoff_staging2
SET `date` = str_to_date(`date` ,'%m/%d/%Y');

ALTER TABLE layoff_staging
MODIFY COLUMN `date` DATE;


-- 3. NULL VALUES OR BLANK COLUMN

SELECT 
	company, 
	industry
FROM layoff_staging
WHERE industry = NULL;

UPDATE layoff_staging
SET total_laid_off = NULL
WHERE total_laid_off = '';

UPDATE layoff_staging
SET funds_raised = NULL
WHERE funds_raised= '';

-- COPYING FROM ONE ROW TO OTHER ROW IN THE SAME TABLE

SELECT 
	t1.industry, 
	t2.industry
FROM layoff_staging t1
JOIN layoff_staging t2
ON t1.company=t2.company
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

UPDATE layoff_staging t1
JOIN layoff_staging t2 ON t1.company=t2.company
SET t1.industry=t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

-- DELETING SOME COLUNMS

SELECT *
FROM layoff_staging
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

DELETE
FROM layoff_staging
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT *
FROM layoff_staging;
