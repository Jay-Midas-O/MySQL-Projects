-- Exploratory Data Analysis

SELECT *
FROM layoff_staging;

SELECT 
  MAX(total_laid_off), 
  MAX(percentage_laid_off)
FROM layoff_staging;

SELECT 
  country, 
  SUM(total_laid_off)
FROM layoff_staging
GROUP BY country
ORDER BY 2 DESC;

SELECT 
  `date`, SUM(total_laid_off)
FROM layoff_staging
GROUP BY `date`
ORDER BY 1 DESC;

SELECT 
  YEAR(`date`), SUM(total_laid_off)
FROM layoff_staging
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT 
  MONTH(`date`),
  SUM(total_laid_off)
FROM layoff_staging
GROUP BY MONTH(`date`)
ORDER BY 1 DESC;

SELECT 
  stage, 
  SUM(total_laid_off)
FROM layoff_staging
GROUP BY stage          
ORDER BY 2 DESC;

SELECT 
  stage, 
  SUM(total_laid_off)
FROM layoff_staging
GROUP BY stage          
ORDER BY 2 DESC;


SELECT 
  SUBSTRING(`date`, 1,10) AS `MONTH` -- SUM(total_laid_off)
FROM layoff_staging;

SELECT 
  SUBSTRING(`date`, 1,7) AS `MONTH`, 
  SUM(total_laid_off)
FROM layoff_staging
WHERE SUBSTRING(`date`, 1,10)
GROUP BY `MONTH`
ORDER BY 1 ASC;

-- FINDING THE ROLLING 

WITH Rolling_Total AS
(
SELECT 
  SUBSTRING(`date`, 1,7) AS `MONTH`, 
  SUM(total_laid_off) AS Total_off
FROM layoff_staging
WHERE SUBSTRING(`date`, 1,10)
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT 
  `MONTH`, 
  Total_off,
  SUM(Total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;


SELECT 
  company, 
  YEAR(`date`), 
  SUM(total_laid_off)
FROM layoff_staging
GROUP BY company, YEAR(`date`)
ORDER BY company DESC;


-- RANKING THEM

WITH Company_Year (COMPANY, YEARS, TLO) AS
(
SELECT 
  company, 
  YEAR(`date`), 
  SUM(total_laid_off)
FROM layoff_staging
GROUP BY company, YEAR(`date`)
),

Company_Year_Rank AS
(
SELECT *, 
DENSE_RANK() OVER(PARTITION BY YEARS ORDER BY TLO DESC) AS Ranks
FROM Company_Year
WHERE TLO IS NOT NULL
)

SELECT *
FROM Company_Year_Rank
WHERE Ranks <=5;

