SELECT * FROM layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * FROM layoffs_staging;

INSERT layoffs_staging
SELECT * FROM layoffs;

SELECT company, industry, total_laid_off,`date`,
		ROW_NUMBER() OVER (
			PARTITION BY company, industry, total_laid_off,`date`) AS row_num
	FROM 
		world_layoffs.layoffs_staging;


SELECT *
FROM (
	SELECT company, industry, total_laid_off,`date`,
		ROW_NUMBER() OVER (
			PARTITION BY company, industry, total_laid_off,`date`
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging
) duplicates
WHERE 
	row_num > 1;


SELECT *
FROM world_layoffs.layoffs_staging
WHERE company = 'Oda'
;

SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging
) duplicates
WHERE 
	row_num > 1;
    
    
WITH DELETE_CTE AS 
(
SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging
) duplicates
WHERE 
	row_num > 1
)
DELETE
FROM DELETE_CTE
;


ALTER TABLE world_layoffs.layoffs_staging ADD row_num INT;


SELECT *
FROM world_layoffs.layoffs_staging
;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` double ,
  `row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `world_layoffs`.`layoffs_staging2`
(`company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised`,
`row_num`)
SELECT `company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised`,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging;

-- now that we have this we can delete rows were row_num is greater than 2

DELETE FROM world_layoffs.layoffs_staging2
WHERE row_num >= 2;
select * from layoffs_staging2;
-- STANDARDIZATION
SELECT DISTINCT TRIM(company) from layoffs_staging2;

UPDATE layoffs_staging2
SET company=TRIM(company);
SELECT company FROM layoffs_staging2;

SELECT industry from layoffs_staging2
ORDER BY 1;
SELECT * FROM layoffs_staging2
WHERE industry='Crypto';

SELECT DISTINCT location from layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country from layoffs_staging2
ORDER BY 1;

select date
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN date DATE;

SELECT industry FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM world_layoffs.layoffs_staging2;
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

UPDATE layoffs_staging2
SET total_laid_off= Null
WHERE total_laid_off LIKE'';
UPDATE layoffs_staging2
SET percentage_laid_off= Null
WHERE percentage_laid_off LIKE'';
SELECT * FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
SELECT *
FROM world_layoffs.layoffs_staging2;



-- exploratory data analysis
SELECT * FROM world_layoffs.layoffs_staging2;
select max(percentage_laid_off), min(percentage_laid_off)
FROM layoffs_staging2
WHERE percentage_laid_off IS  NOT NULL;

SELECT * FROM layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY funds_raised DESC;

SELECT DISTINCT company FROM layoffs_staging2;
select company, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(date), MAX(date)
FROM layoffs_staging2;

select industry, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

select country, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

select year(date), SUM(total_laid_off) FROM layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 DESC;

WITH CTE1 AS (
SELECT SUBSTRING(date,6,2) AS month, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY month
ORDER BY 1)
SELECT month, SUM(total_laid_off) OVER(ORDER BY month asc) AS rolling_total_off
FROM CTE1
ORDER BY 1;

SELECT company, YEAR(date), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(date)
ORDER BY 2;

WITH company_year(company,year,total_laid_off) AS (
SELECT company, YEAR(date), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(date)
ORDER BY 2), 
company_year_ranking AS(
SELECT *,
dense_rank() OVER (PARTITION BY year ORDER BY total_laid_off DESC) AS ranking 
FROM company_year
WHERE year is not null)
SELECT * FROM company_year_ranking
WHERE ranking<=5;