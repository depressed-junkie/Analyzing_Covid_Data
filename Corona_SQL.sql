-- Check For Null Values
SELECT 
    *
FROM
    corona_analysis.corona_dataset
WHERE
    Province IS NULL OR Country IS NULL
        OR Latitude IS NULL
        OR Longitude IS NULL
        OR Date IS NULL
        OR Confirmed IS NULL
        OR Deaths IS NULL
        OR Recovered IS NULL;

-- Total number of rows within dataset
SELECT 
    COUNT(*) total_rows
FROM
    corona_analysis.corona_dataset;

-- Finding starting date and endind date of pandemic
SELECT 
    MIN(Date) AS start_date, MAX(Date) AS end_date
FROM
    corona_analysis.corona_dataset;

-- Calculate the duration of pandemic in Months
SELECT 
    TIMESTAMPDIFF(MONTH,
        MIN(Date),
        MAX(Date)) AS num_of_months
FROM
    corona_analysis.corona_dataset;

-- Finding monthly average of confirmed,recovered and death cases
SELECT 
    EXTRACT(MONTH FROM STR_TO_DATE(Date, '%Y-%m-%d')) AS Month,
    EXTRACT(YEAR FROM STR_TO_DATE(Date, '%Y-%m-%d')) AS Year,
    ROUND(AVG(Confirmed)) AS Avg_Confirmed,
    ROUND(AVG(Deaths)) AS Avg_Deaths,
    ROUND(AVG(Recovered)) AS Avg_Recovered
FROM
    corona_analysis.corona_dataset
GROUP BY Month , Year;

-- Calculating most frequent values for confirmed, deaths, recovered each month 
SELECT 
    EXTRACT(MONTH FROM STR_TO_DATE(Date, '%Y-%m-%d')) AS Month,
    EXTRACT(YEAR FROM STR_TO_DATE(Date, '%Y-%m-%d')) AS Year,
    SUBSTRING_INDEX(GROUP_CONCAT(Confirmed
                ORDER BY Confirmed DESC),
            ',',
            1) AS Most_Frequent_Confirmed,
    SUBSTRING_INDEX(GROUP_CONCAT(Deaths
                ORDER BY Deaths DESC),
            ',',
            1) AS Most_Frequent_Deaths,
    SUBSTRING_INDEX(GROUP_CONCAT(Recovered
                ORDER BY Recovered DESC),
            ',',
            1) AS Most_Frequent_Recovered
FROM
    corona_analysis.corona_dataset
GROUP BY Year , Month
ORDER BY Year , Month;

-- Calculating minimum values for confirmed, deaths, recovered per year
SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(Date, '%Y-%m-%d')) AS Year,
    MIN(Confirmed) AS Min_Confirmed,
    MIN(Deaths) AS Min_Deaths,
    MIN(Recovered) AS Min_Recovered
FROM
    corona_analysis.corona_dataset
GROUP BY Year
ORDER BY Year;

-- Calculating maximum values of confirmed, deaths, recovered per year
SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(Date, '%Y-%m-%d')) AS Year,
    MAX(Confirmed) AS Max_Confirmed,
    MAX(Deaths) AS Max_Deaths,
    MAX(Recovered) AS Max_Recovered
FROM
    corona_analysis.corona_dataset
GROUP BY Year
ORDER BY Year;

-- Calculating the total number of case of confirmed, deaths, recovered each month
SELECT 
    EXTRACT(MONTH FROM STR_TO_DATE(Date, '%Y-%m-%d')) AS Month,
    SUM(Confirmed) AS Total_Confirmed,
    SUM(Deaths) AS Total_Deaths,
    SUM(Recovered) AS Total_Recovered
FROM
    corona_analysis.corona_dataset
GROUP BY Month
ORDER BY Month;

-- Checking how corona virus spread out with respect to confirmed case
SELECT 
    SUM(Confirmed) AS Total_Confirmed,
    ROUND(AVG(Confirmed)) AS Avg_Confirmed,
    ROUND(VARIANCE(Confirmed)) AS Var_Confirmed,
    ROUND(STDDEV(Confirmed)) AS Stddev_Confirmed
FROM
    corona_analysis.corona_dataset;

-- Checking how corona virus spread out with respect to death case per month
SELECT 
    SUM(Deaths) AS Total_Deaths,
    ROUND(AVG(Deaths)) AS Avg_Deaths,
    ROUND(VARIANCE(Deaths)) AS Var_Deaths,
    ROUND(STDDEV(Deaths)) AS Stddev_Deaths
FROM
    corona_analysis.corona_dataset;

-- Checking how corona virus spread out with respect to recovered case per month
SELECT 
    SUM(Recovered) AS Total_Recovered,
    ROUND(AVG(Recovered)) AS Avg_Recovered,
    ROUND(VARIANCE(Recovered)) AS Var_Recovered,
    ROUND(STDDEV(Recovered)) AS Stddev_Recovered
FROM
    corona_analysis.corona_dataset;

-- Finding Country having highest number of the Confirmed case
SELECT 
    `Country`, SUM(Confirmed) AS Total_Confirmed_Cases
FROM
    corona_analysis.corona_dataset
GROUP BY `Country`
ORDER BY Total_Confirmed_Cases DESC
LIMIT 1;

-- Finding Country having lowest number of the death case
with rankingCountry as (
SELECT 
`Country`
,sum(Deaths) as Total_Death_Cases
,rank() over(order by sum(Deaths) asc) as rank_no
FROM corona_analysis.corona_dataset
GROUP BY `Country`
)
SELECT
`Country`
,Total_Death_Cases
FROM rankingCountry
WHERE rank_no = 1;

-- Finding top 5 countries having highest recovered case
SELECT 
    `Country`, SUM(Recovered) AS Total_Recovered_Cases
FROM
    corona_analysis.corona_dataset
GROUP BY `Country`
ORDER BY Total_Recovered_Cases DESC
LIMIT 5;