# Average Daily Screen Time for Children

## Introduction:
This project explores the “Average Daily Screen Time for Children” dataset from the Kaggle platform, which provides detailed information on the daily screen usage patterns of children aged 5 to 15 years. The dataset includes variables such as age, gender, screen time type (educational or recreational), day type (weekday or weekend), average daily screen time in hours, and sample size. The data was queried using SQLite and analyzed separately using both SQLite and Python to identify key patterns and trends.

### Variables:
- Age
- Gender
- Screen Time Type
- Day Type
- Average Screen Time (hour)
- Sample Size

## SQL Analyses
The dataset was queried in various ways, and analyses were conducted under the following headings:


#### *1<sup>st</sup> query: General Querying, Data Viewing, and Data Analysis*

#### *2<sup>st</sup> query: Overall Summary (Average Screen Time and Sample Size)*
To understand the overall structure of the dataset, all data was initially examined. The average screen time was calculated as 2.66 hours on weekdays and 3.32 hours on weekends. The total sample size for both day types was determined to be 39,600, indicating that the dataset provides balanced sampling.


#### *3<sup>nd</sup> query: Age and Gender-Based Screen Time Analysis*
Average screen times were calculated for each age and gender combination, and their deviations from the overall average were analyzed. The overall average screen time was determined to be 3.99 hours.

- Ages 5-8: Screen times are generally low (0.72-2.58 hours) and show negative deviation from the overall average. For example, the educational screen time of 5-year-old girls is 0.72 hours, which is 3.27 hours below the overall average.
- Ages 9-12: Screen times increase (1.25-4.93 hours). Notably, 12-year-old boys have a total screen time of 4.93 hours, which is 0.94 hours above the overall average.
- Ages 13-15: Screen times rise further (1.64-6.87 hours). At 15 years old, boys have the highest total screen time of 6.87 hours, which is 2.88 hours above the overall average.
- Gender Differences: Boys generally spend more time on screens than girls, with the difference becoming more pronounced after age 10.


#### *4<sup>th</sup> query: Weekday vs. Weekend Comparison*
Screen times on weekdays and weekends were compared across age groups.

- Across all age groups, weekend screen times are higher than weekday screen times. For example, in the 5-year-old group, the average screen time is 1.29 hours on weekdays, increasing to 1.65 hours on weekends.
- In the 15-year-old group, weekday screen time is 4.32 hours, rising to 5.40 hours on weekends, marking one of the largest differences (1.08 hours).
- Generally, as age increases, both weekday and weekend screen times rise, but the increase is more pronounced on weekends.


#### *5<sup>th</sup> query: Percentage Distribution by Screen Type*
The distribution of screen time between educational and entertainment purposes was analyzed.
- Educational: 1.23 hours, accounting for 13.66% of the total screen time.
- Recreational: 3.26 hours, making up 36.33% of the total screen time.
- Total: 4.49 hours, representing 50% of the total screen time.


#### *6<sup>th</sup> query: Outlier Detection*
An outlier analysis was conducted on sample sizes, but no outliers were detected. Therefore, no cleaning or adjustments were required for the dataset.


#### *7<sup>th</sup> Age Segmentation and Screen Time*
Screen times were analyzed by age segments.

- Ages 5-8: Screen times range from 1.16 to 2.58 hours, below the overall average (3.99 hours). For example, 5-year-old girls have 1.16 hours, showing a -1.83-hour deviation.
- Ages 9-12: Screen times range from 1.25 to 4.93 hours, closer to the overall average. Twelve-year-old boys have 4.93 hours, exceeding the average by 0.94 hours.
- Ages 13-15: Screen times range from 1.64 to 6.87 hours, generally above the average. Fifteen-year-old boys have 6.87 hours, with a positive deviation of 2.88 hours.

Screen time consistently increases with age. Additionally, boys spend more screen time than girls across all age groups.

## Python Analyses
### 1. Data Cleaning and Preprocessing
- Missing and outlier values were checked.
- Data transformations were applied when necessary

#### 2.	Exploratory Data Analysis (EDA):
- The distribution of screen time was examined across different age groups.
- Categorical analyses were conducted based on device types and purposes of use.

### 3.	Visualizations:
- Bar Charts
- Line Charts
- Box Plots
- Heatmap 

## Conclusion
The analyses reveal that children's screen time increases significantly with age. Boys generally have higher screen time than girls, with this difference becoming more pronounced during adolescence. The majority of screen use consists of recreational activities, while educational use remains limited. Screen times are higher on weekends compared to weekdays, providing important insights into how children spend their free time. These findings can guide parents and educators in managing children's screen usage habits.

