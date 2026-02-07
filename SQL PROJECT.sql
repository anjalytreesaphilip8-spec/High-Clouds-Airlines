create database Project;
use project;
select * from maindata;

-- 1. Date --
SELECT
    STR_TO_DATE(
        CONCAT(`Year`, '-', `Month (#)`, '-', `Day`),
        '%Y-%m-%d'
    ) AS Date
FROM maindata;

-- A. Year--
SELECT YEAR(STR_TO_DATE(CONCAT(`Year`, '-', `Month (#)`, '-', `Day`), '%Y-%m-%d')) AS Year FROM maindata;

-- B. Month Number --
SELECT  MONTH(STR_TO_DATE(CONCAT(`Year`, '-', `Month (#)`, '-', `Day`), '%Y-%m-%d')) AS MonthNo FROM maindata;

-- c. Month Full Name --
SELECT MONTHNAME(STR_TO_DATE(CONCAT(`Year`, '-', `Month (#)`, '-', `Day`), '%Y-%m-%d')) AS MonthFullName FROM maindata;

-- D. Quarter -- 
SELECT CONCAT(
        'Q',
        QUARTER(STR_TO_DATE(CONCAT(`Year`, '-', `Month (#)`, '-', `Day`), '%Y-%m-%d'))
    ) AS Quarter FROM maindata;
    
-- E. Year-Month --
SELECT DATE_FORMAT(
        STR_TO_DATE(CONCAT(`Year`, '-', `Month (#)`, '-', `Day`), '%Y-%m-%d'),
        '%Y-%b'
    ) AS YearMonth FROM maindata;
    
-- F. Weekday Number (Monday = 1) --
SELECT WEEKDAY(
        STR_TO_DATE(CONCAT(`Year`, '-', `Month (#)`, '-', `Day`), '%Y-%m-%d')
    ) + 1 AS WeekdayNo FROM maindata;
    
-- G. Weekday Name --
SELECT DAYNAME(
        STR_TO_DATE(CONCAT(`Year`, '-', `Month (#)`, '-', `Day`), '%Y-%m-%d')
    ) AS WeekdayName FROM maindata;
    
-- H. Financial Month (If Financial Year Starts in April) --
SELECT 
	CASE
        WHEN `Month (#)` >= 4 THEN `Month (#)` - 3
        ELSE `Month (#)` + 9
    END AS FinancialMonth
FROM maindata;

-- I. Financial Quarter (If Financial Year Starts in April) --
SELECT
	CASE
        WHEN `Month (#)` BETWEEN 4 AND 6 THEN 'FQ1'
        WHEN `Month (#)` BETWEEN 7 AND 9 THEN 'FQ2'
        WHEN `Month (#)` BETWEEN 10 AND 12 THEN 'FQ3'
        ELSE 'FQ4'
    END AS FinancialQuarter
FROM maindata;

-- 2. Yearly, Quarterly, Monthlywise Load Factor--
-- A. Yearly Load Factor % --
SELECT
    `Year`,
    `Carrier Name`,
    ROUND(
        SUM(`# Transported Passengers`) /
        SUM(`# Available Seats`) * 100,
        2
    ) AS `Load Factor %`
FROM maindata
GROUP BY
    `Year`,
    `Carrier Name`
ORDER BY
    `Year`,
    `Carrier Name`;

-- B. Quarterlywise Load Factor --

SELECT
    `Year`,
    CONCAT(
        'Q',
        QUARTER(
            STR_TO_DATE(
                CONCAT(`Year`, '-', `Month (#)`, '-', `Day`),
                '%Y-%m-%d'
            )
        )
    ) AS Quarter,
    `Carrier Name`,
    ROUND(
        SUM(`# Transported Passengers`) /
        SUM(`# Available Seats`) * 100,
        2
    ) AS `Load Factor %`
FROM maindata
GROUP BY
    `Year`,
    Quarter,
    `Carrier Name`
ORDER BY
    `Year`,
    Quarter,
    `Carrier Name`;

-- C. Monthlywise Load Factor --
SELECT
    `Year`,
    `Month (#)` AS MonthNo,
    MONTHNAME(
        STR_TO_DATE(
            CONCAT(`Year`, '-', `Month (#)`, '-', `Day`),
            '%Y-%m-%d'
        )
    ) AS MonthName,
    `Carrier Name`,
    ROUND(
        SUM(`# Transported Passengers`) /
        SUM(`# Available Seats`) * 100,
        2
    ) AS `Load Factor %`
FROM maindata
GROUP BY
    `Year`,
    MonthNo,
    MonthName,
    `Carrier Name`
ORDER BY
    `Year`,
    MonthNo,
    `Carrier Name`;

-- 3. Carrier Name by Load Factor % --
SELECT
    `Carrier Name`,
    ROUND(
        SUM(`# Transported Passengers`) /
        SUM(`# Available Seats`) * 100,
        2
    ) AS "Load Factor %"
FROM maindata
GROUP BY `Carrier Name`
ORDER BY "Load Factor %" DESC;

-- 4. Top 10 Carrier Names Based on Passenger Preference --
SELECT
    `Carrier Name`,
    SUM(`# Transported Passengers`) AS "Total Passengers"
FROM maindata
GROUP BY `Carrier Name`
ORDER BY "Total Passengers" DESC
LIMIT 10;

-- 5. Top Routes (From–To City) Based on Number of Flights --
SELECT
    `From - To City`,
    SUM(`# Departures Performed`) AS "Total Flights"
FROM maindata
GROUP BY `From - To City`
ORDER BY "Total Flights" DESC
LIMIT 10;

-- 6. Load Factor: Weekend vs Weekdays --
SELECT
    CASE
        WHEN DAYOFWEEK(
            STR_TO_DATE(CONCAT(`Year`, '-', `Month (#)`, '-', `Day`), '%Y-%m-%d')
        ) IN (1,7)
        THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type,

    ROUND(
        SUM(`# Transported Passengers`) /
        SUM(`# Available Seats`) * 100,
        2
    ) AS "Load Factor %"
FROM maindata
GROUP BY Day_Type;

-- 7. Number of Flights Based on Distance Group --
SELECT
    `%Distance Group ID` AS Distance_Group,
    SUM(`# Departures Performed`) AS "Total Flights"
FROM maindata
GROUP BY `%Distance Group ID`
ORDER BY Distance_Group;
















