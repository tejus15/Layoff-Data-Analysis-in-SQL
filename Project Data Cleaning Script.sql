-- Create a copy of the original data
CREATE TABLE IF NOT EXISTS layoffs_staging LIKE layoffs;

-- INSERT THE ORIGINAL DATA IN THE COPY TABLE
INSERT INTO layoffs_staging
select * from layoffs;

-- Remove duplicates
-- Identify duplicates 

-- Create a copy of the table
CREATE TABLE IF NOT EXISTS layoffs_staging2 LIKE layoffs;

-- Add a row_num column in the table
alter table layoffs_staging2 
add column row_num int;

-- Insert data in the second staging table alomg with row num column
INSERT INTO layoffs_staging2
select *, row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) 
from layoffs_staging;

-- Check for duplicates, row_num>1 (5 records)
SELECT * FROM layoffs_staging2 where ROW_NUM>1;

-- Delete the duplicate records
DELETE FROM layoffs_staging2 where ROW_NUM>1;

-- 2. Standardizing

-- Remove leading and trailing whitespaces
UPDATE layoffs_staging2
SET company=trim(company);

select company
from layoffs_staging2;

-- Observe all industries
select distinct industry
from layoffs_staging2;

-- We observe that Crypto, CryptoCurrency, Crypto Currency  are considered separate industries
SELECT * FROM layoffs_staging2
WHERE industry like 'Crypto%';

-- Majority of such records are stored as 'Crypto'. Thus, we will change 'CryptoCurrency' and 'Crypto Currency' as 'Crypto'
UPDATE layoffs_staging2
SET INDUSTRY='Crypto'
WHERE industry like 'Crypto%';

-- Check out location
SELECT DISTINCT location
FROM  layoffs_staging2
ORDER BY 1;

SELECT DISTINCT COUNTRY
FROM layoffs_staging2
ORDER BY 1;

-- We have 2 records for United States and United States.
SELECT * FROM layoffs_staging2
WHERE COUNTRY LIKE 'United States%';

-- Update the table and remove the '.' at the end of United States
update layoffs_staging2
SET COUNTRY=TRIM(TRAILING '.' FROM country)
WHERE COUNTRY LIKE 'United States%'; 

-- Let us change the format of date column from text to datetime
select `date`, str_to_date(`date`, '%m/%d/%Y') as str_to_date
from layoffs_staging2;

-- '%M/%d/%Y' gives us null values
select `date`, str_to_date(`date`, '%M/%d/%Y') as str_to_date
from layoffs_staging2;

-- '%M/%D/%Y' gives us null values
select `date`, str_to_date(`date`, '%M/%D/%Y') as str_to_date
from layoffs_staging2;

-- '%m/%D/%Y' gives us null values
select `date`, str_to_date(`date`, '%m/%D/%Y') as str_to_date
from layoffs_staging2;

-- '%m/%D/%y' gives us null values
select `date`, str_to_date(`date`, '%m/%D/%y') as str_to_date
from layoffs_staging2;

-- '%M/%D/%y' gives us null values
select `date`, str_to_date(`date`, '%M/%D/%Y') as str_to_date
from layoffs_staging2;


-- '%M/%d/%y' gives us null values
select `date`, str_to_date(`date`, '%M/%d/%y') as str_to_date
from layoffs_staging2;

-- '%m/%d/%y' gives us 2020 in the year part
select `date`, str_to_date(`date`, '%m/%d/%y') as str_to_date
from layoffs_staging2;

-- Update the table
UPDATE layoffs_staging2
SET `date`=str_to_date(`date`, '%m/%d/%Y');

SELECT * FROM layoffs_staging2;

-- The date column in the table is still a text. Have to change it to type date
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` date;

-- Handle null and blank values
SELECT * FROM layoffs_staging2
WHERE total_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry='';

-- To populate industry field, we are looking for other records containing these companies and checking if they belong to a particular industry
-- If they do, then we can populate the blank and null fields easily. 

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

-- Since we are tring to link two rows of the same table, use self join
SELECT T1.INDUSTRY, T2.INDUSTRY
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company=t2.company
WHERE (T1.INDUSTRY IS NULL OR T1.INDUSTRY='')
AND (T2.INDUSTRY IS NOT NULL AND NOT (T2.INDUSTRY = ''));


UPDATE layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company=t2.company
SET T1.INDUSTRY=T2.INDUSTRY
WHERE (T1.INDUSTRY IS NULL OR T1.INDUSTRY='')
AND (T2.INDUSTRY IS NOT NULL AND NOT (T2.INDUSTRY = ''));

-- IDENTIFY ROWS WHERE WE HAVE NO RECORD OF TOTAL_LAID_OFF AND % LAID OFF
SELECT * FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

-- We can delete these records because we dont know how reliable they are
delete FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL; 

-- Drop the row_num column as it has served its purpose now
alter table layoffs_staging2
drop column row_num;

select * from layoffs_staging2;