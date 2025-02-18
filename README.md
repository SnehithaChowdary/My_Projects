# SQL_Project
This project is an Exploratory Data Analysis (EDA) on global layoffs using SQL. The goal is to uncover trends, patterns, and insights into how layoffs have affected different companies, industries, and locations over time.

*What This Project Covers*
Basic Data Exploration: Retrieve all records to understand the dataset.

Layoff Trends: Identify companies with the biggest single-day layoffs and total layoffs.

Industry & Location Impact: Analyze which industries and locations had the highest layoffs.

Time-based Analysis: Track layoffs year by year and visualize rolling totals by month.

Company-Specific Insights: Identify companies that laid off the highest percentage of employees.

*SQL Concepts Used*

Basic Queries: SELECT, WHERE, ORDER BY

Aggregations: SUM(), MAX(), MIN()

Grouping & Ranking: GROUP BY, DENSE_RANK(), PARTITION BY

Common Table Expressions (CTEs): Used for trend analysis over time

*Dataset Information*

The dataset is stored in the table layoffs_staging2.
Key columns include company, date, total_laid_off, percentage_laid_off, industry, location, and funds_raised_millions.
This project provides a structured way to analyze layoffs in the business world and gain meaningful insights using SQL.
