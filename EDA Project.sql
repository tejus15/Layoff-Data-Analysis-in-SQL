-- Exploratory Data Analysis

-- See the entire data
SELECT * FROM layoffs_staging2;

-- Identify the company with the highest total laid off in a day
SELECT company, total_laid_off, `date`
FROM layoffs_staging2
WHERE total_laid_off=(SELECT max(total_laid_off) FROM layoffs_staging2);

-- Identify the companies where all staff members were laid off
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY funds_raised_millions DESC;

-- Identify the top 10 companies who laid off the most employees in total
SELECT company, SUM(total_laid_off) AS number_of_emp_laid_off
from layoffs_staging2
GROUP BY company
ORDER BY 2 DESC  -- 2 here means column 2 i.e. SUM(total_laid_off)
LIMIT 10;

-- Identify the industry with the most layoffs
SELECT industry, SUM(total_laid_off) AS industry_lay_offs
FROM layoffs_staging2
GROUP BY industry
order by 2 DESC
LIMIT 10;


-- Identify the country with the most layoffs
SELECT country, SUM(total_laid_off) AS industry_lay_offs
FROM layoffs_staging2
GROUP BY country
order by 2 DESC
LIMIT 10;

SELECT YEAR(`date`) as yr, SUM(total_laid_off) AS industry_lay_offs
FROM layoffs_staging2
GROUP BY YEAR(`date`)
order by 1 DESC
LIMIT 10;

with rolling_total as (
SELECT substring(`date`, 1, 7) AS yr_month, SUM(total_laid_off) AS monthly_laid_off FROM layoffs_staging2
WHERE substring(`date`, 1, 7) IS NOT NULL
GROUP BY substring(`date`, 1, 7)
ORDER BY 1 ASC
)

select yr_month, monthly_laid_off, SUM(monthly_laid_off) OVER(ORDER BY YR_MONTH) AS rolling_total
FROM rolling_total;

-- Get the data
SELECT * FROM layoffs_staging2;

-- The company with the highest layoffs each year
with company_yr(company, Yr, total_laid_off) as(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
ORDER BY 1 ASC),
laid_off_ranking as (
select *, dense_rank() OVER(PARTITION BY yr ORDER BY total_laid_off desc) AS Ranking 
from company_yr
WHERE YR IS NOT NULL)

SELECT * FROM laid_off_ranking
WHERE Ranking<=5;

-- The top 5 industries with the highest layoffs in each year
with industry_year as (
select industry, year(`date`) as yr, sum(total_laid_off) as annual_industry_layoff
from layoffs_staging2
GROUP BY INDUSTRY, YEAR(`date`)
),
industry_ranking_year as(
SELECT *, DENSE_RANK() OVER(PARTITION BY yr ORDER BY annual_industry_layoff desc) as Industry_Ranking 
FROM industry_year
WHERE yr is not null)

SELECT * FROM industry_ranking_year
WHERE Industry_Ranking<=5;

with industry_year as (
select industry, year(`date`) as yr, sum(total_laid_off) as annual_industry_layoff
from layoffs_staging2
GROUP BY INDUSTRY, YEAR(`date`)
),
industry_ranking_year as(
SELECT *, DENSE_RANK() OVER(PARTITION BY yr ORDER BY annual_industry_layoff desc) as Industry_Ranking 
FROM industry_year
WHERE yr is not null)


SELECT * FROM industry_ranking_year
WHERE yr='2023'
ORDER BY Industry_Ranking DESC
LIMIT 3;

SELECT * FROM layoffs_staging2 where industry='Crypto Currency';

-- Finding the total layoffs in each year. 
SELECT year(`date`) AS yr, SUM(total_laid_off) as annual_layoffs
from layoffs_staging2
where year(`date`) IS NOT NULL
GROUP BY year(`date`)
ORDER BY 1;

-- Finding the % increase in layoff during the time period: 2020-2023
SELECT 
  (SUM(CASE WHEN YEAR(`date`) = 2023 THEN total_laid_off ELSE 0 END) - 
   SUM(CASE WHEN YEAR(`date`) = 2020 THEN total_laid_off ELSE 0 END)) / 
   SUM(CASE WHEN YEAR(`date`) = 2020 THEN total_laid_off ELSE 0 END) * 100 AS Percent_Increase
FROM layoffs_staging2;
