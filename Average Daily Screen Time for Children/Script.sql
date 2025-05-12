--1st query: Preliminary review and analysis of the data --
SELECT *
FROM screen_time;




--2nd query: Overall Summary (Average Screen Time and Sample Size) --
/*Calculates the average screen time for the entire dataset */
SELECT
	"Day Type",
	ROUND(AVG("Average Screen Time (hours)"), 2) AS ave_screen_time,
	SUM("Sample Size") AS total_sample_size 
FROM 
	screen_time
GROUP BY "Day Type";



--3th query: Screen Time Analysis by Age and Gender --
/* Calculates the average screen time for each age and gender combination and shows the deviation from the overall average.*/
WITH overall_avg AS (
	SELECT AVG("Average Screen Time (hours)") AS global_avg
	FROM screen_time
)
SELECT
	Age,
	Gender,
	ROUND(AVG("Average Screen Time (hours)"), 2) AS avg_screen_time,
	ROUND(AVG("Average Screen Time (hours)") - (SELECT global_avg FROM overall_avg), 2) AS deviation_from_global
FROM 
	screen_time
GROUP BY 
	Age, 
	Gender
ORDER BY
	Age,
	Gender;
	

--4th query: Weekday vs. Weekend Comparison --
/*Compares weekday and weekend screen time by age groups*/
SELECT 
    Age,
    ROUND(AVG(CASE WHEN "Day Type" = 'Weekday' THEN "Average Screen Time (hours)" END), 2) AS weekday_avg,
    ROUND(AVG(CASE WHEN "Day Type" = 'Weekend' THEN "Average Screen Time (hours)" END), 2) AS weekend_avg
FROM 
	screen_time
GROUP BY 
	Age
ORDER BY 
	Age;
	

--5th query: Percentage Distribution by Screen Type --
/*Calculates the ratio of each screen type to the total screen time*/
SELECT 
    "Screen Time Type",
    ROUND(AVG("Average Screen Time (hours)"), 2) AS avg_screen_time,
    ROUND(AVG("Average Screen Time (hours)") / SUM(AVG("Average Screen Time (hours)")) OVER () * 100, 2) AS percentage
FROM screen_time
GROUP BY "Screen Time Type";


--6th query: Outlier Detection in Sample Size--
/*Detects outliers in sample size based on age or screen type*/

/* Since SQLite does not support the STDDEV function, we need to calculate the standard deviation manually. */

/*Additionally, since SQLite does not allow the use of nested AVG functions within window functions, we will need to perform the calculations using separate window functions instead of combining them into a single one.*/
WITH avg_data AS (
	SELECT
		age,
		"Screen Time Type",
		"Sample Size",
		AVG("Sample Size" * 1.0) OVER (PARTITION BY "Screen Time Type") AS avg_sample_size
	FROM screen_time
),
stats AS (
	SELECT
		age,
		"Screen Time Type",
		"Sample Size",
		avg_sample_size,
		SQRT(
			SUM(("Sample Size" - avg_sample_size) * ("Sample Size" - avg_sample_size)) 
			OVER (PARTITION BY "Screen Time Type")
			/ COUNT(*) OVER (PARTITION BY "Screen Time Type")
			) AS stddev_sample_size
	FROM avg_data
)
SELECT
	Age,
	"Screen Time Type",
	"Sample Size",
	CASE
		WHEN "Sample Size" > avg_sample_size + 2 * stddev_sample_size
			OR "Sample Size" < avg_sample_size - 2 * stddev_sample_size
		THEN "Outlier"
		ELSE "Normal"
	END AS outlier_status
FROM stats
ORDER BY
	Age,
	"Screen Time Type";




--7th query: Age Segmentation and Screen Time --
/* Let’s analyze screen time by segmenting the ages */

SELECT 
    CASE 
        WHEN Age <= 8 THEN "5 - 8"
        WHEN Age <= 12 THEN "9 - 12"
        ELSE "13 - 15"
    END AS age_group,
    Gender,
    "Screen Time Type",
    ROUND(AVG("Average Screen Time (hours)"), 2) AS avg_screen_time
FROM screen_time 
GROUP BY 
    CASE 
        WHEN Age <= 8 THEN "5-8"
        WHEN Age <= 12 THEN "9-12"
        ELSE "13-15"
    END,
    Gender,
    "Screen Time Type"
ORDER BY 
	age_group,
	Gender , 
	"Screen Time Type";





