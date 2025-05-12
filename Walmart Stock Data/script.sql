-- 1st query: Preliminary review and analysis of the data --
SELECT *
FROM wmt_data;


-- 2nd query: Highest and lowest closing prices
-- Purpose: Calculate the minimum, maximum and average closing price
SELECT 
    MIN(close) AS min_close_price,
    MAX(close) AS max_close_price,
    AVG(close) AS avg_close_price
FROM 
	wmt_data;

-- 3rd query: Annual Performance Analysis
-- Purpose: Calculate the minimum, maximum and average closing price and total volume per year
-- Technique: Use strftime for grouping by year-month 
SELECT 
    strftime('%Y', date) AS year,
    MIN(close) AS min_price,
    MAX(close) AS max_price,
    AVG(close) AS avg_price,
    SUM(volume) AS total_volume
FROM 
	wmt_data
GROUP BY 
	year
ORDER BY 
	year;


-- 4th query: Monthly Average Price Change
-- Purpose: Calculate the average closing price per month
-- Technique: Use strftime for grouping by year-month 
WITH monthly_data AS (
    SELECT 
        strftime('%Y-%m', date) AS month,
        AVG(close) AS avg_close
    FROM 
    		wmt_data
    GROUP BY 
    		month
)
SELECT 
    month,
    avg_close,
    LAG(avg_close, 1) OVER (ORDER BY month) AS prev_month_avg,
    (avg_close - LAG(avg_close, 1) OVER (ORDER BY month)) / LAG(avg_close, 1) OVER (ORDER BY month) * 100 AS monthly_change_pct
FROM 
	monthly_data;


-- 5th query: Monthly Average Closing Price and Volume
-- Purpose: Calculate the average closing price and total volume per month
-- Technique: Use strftime for grouping by year-month 
WITH monthly_data AS (
    SELECT 
        strftime('%Y-%m', date) AS month,
        AVG(close) AS avg_close,
        SUM(volume) AS total_volume
    FROM 
    		wmt_data
    GROUP BY 
    		month
)
SELECT 
    month,
    ROUND(avg_close, 2) AS avg_close_price,
    total_volume
FROM 
	monthly_data
ORDER BY 
	month;


-- 6th query: Annual Price Volatility
-- Purpose: Measure volatility as the difference between high and low prices per day, aggregated by year
-- Technique: Use a CTE and window function to rank years by volatility
WITH DailyVolatility AS (
    SELECT 
        strftime('%Y', date) AS year,
        date,
        (high - low) AS daily_range
    FROM wmt_data
)
SELECT 
    year,
    ROUND(AVG(daily_range), 2) AS avg_daily_range,
    RANK() OVER (ORDER BY AVG(daily_range) DESC) AS volatility_rank
FROM 
	DailyVolatility
GROUP BY 
	year
ORDER BY 
	avg_daily_range DESC;


-- 7th query: Significant Price Drops (>5% in a Day)
-- Purpose: Identify days with significant price drops for risk analysis.
-- Technique: Use a self-join to compare consecutive days.
WITH PriceChange AS (
    SELECT 
        a.date,
        a.close,
        a.close / b.close - 1 AS daily_change
    FROM wmt_data a
    JOIN wmt_data b
        ON julianday(a.date) = julianday(b.date) + 1
)
SELECT 
    strftime('%Y-%m-%d', date) AS day,
    ROUND(close, 2) AS close_price,
    ROUND(daily_change * 100, 2) AS percentage_change
FROM 
	PriceChange
WHERE 
	daily_change < -0.05
ORDER BY 
	daily_change ASC;


-- 8th query: Significant Price Increase (>5% in a Day)
-- Purpose: Identify days with significant price increases for risk analysis.
-- Technique: Use a self-join to compare consecutive days.
WITH PriceChange AS (
    SELECT 
        a.date,
        a.close,
        a.close / b.close - 1 AS daily_change
    FROM 
    		wmt_data a
    JOIN 
    		wmt_data b
        ON julianday(a.date) = julianday(b.date) + 1
)
SELECT 
    strftime('%Y-%m-%d', date) AS day,
    ROUND(close, 2) AS close_price,
    ROUND(daily_change * 100, 2) AS percentage_change
FROM 
	PriceChange
WHERE 
	daily_change > 0.05
ORDER BY 
	daily_change DESC ;

-- 9th query: The 10 days with the Highest Trading Volume
-- Determining the top 10 days with the highest trading volume
SELECT 
    strftime('%Y-%m-%d', date) AS day,
    volume,
    close,
    (high - low) AS daily_range
FROM 
	wmt_data
ORDER BY 
	volume DESC
LIMIT 10;


-- 10th query: Yearly Volume Spikes
-- Purpose: Detect years with unusually high trading volumes -- Technique: Use several CTEs and statistical thresholds (mean + 2*stddev)


/* Since SQLite does not support the STDDEV function, we need to calculate the standard deviation manually. */

/*Additionally, since SQLite does not allow the use of nested AVG functions within window functions, we will need to perform the calculations using separate window functions instead of combining them into a single one.*/

WITH YearlyAvg AS (
    -- Annual average volume calculation
    SELECT 
        strftime('%Y', date) AS year,
        AVG(volume) AS avg_volume
    FROM 
    		wmt_data
    GROUP BY 
    		strftime('%Y', date)
),
VarianceCalc AS (
    -- Calculate the squared difference from the mean for each record
    SELECT 
        w.date,
        w.volume,
        y.year,
        y.avg_volume,
        (w.volume - y.avg_volume) * (w.volume - y.avg_volume) AS squared_diff
    FROM 
    		wmt_data w
    JOIN YearlyAvg y ON strftime('%Y', w.date) = y.year
),
StdDev AS (
    -- Calculate the annual standard deviation
    SELECT 
        year,
        avg_volume,
        SQRT(AVG(squared_diff)) AS std_volume
    FROM 
    		VarianceCalc
    GROUP BY 
    		year
),
VolumeStats AS (
    -- Merge volume, average, and standard deviation
    SELECT 
        w.date,
        w.volume,
        s.year,
        s.avg_volume,
        s.std_volume
    FROM 
    		wmt_data w
    JOIN StdDev s ON strftime('%Y', w.date) = s.year
)
SELECT 
    year,
	strftime('%Y-%m-%d', date) AS day,
    volume,
    ROUND((volume - avg_volume) / std_volume, 2) AS z_score
FROM 
	VolumeStats
WHERE 
	volume > avg_volume + 2 * std_volume
ORDER BY 
	year,
	z_score DESC;