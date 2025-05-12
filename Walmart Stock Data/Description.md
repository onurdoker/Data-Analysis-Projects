# Walmart Stock Data 2025

## Introduction
This report presents a comprehensive analysis of Walmart's stock data from January 2000 to March 2025, sourced from Kaggle. The dataset includes daily stock metrics such as opening, closing, high, and low prices, adjusted closing prices, and trading volume. The analysis is conducted using SQL for database querying and Python in a Jupyter Notebook for data processing and visualization. The objective is to uncover trends, volatility, significant price movements, and trading patterns to provide insights into Walmart's stock performance over the 25 years.

Kaggle link: [https://www.kaggle.com/datasets/abdmoiz/walmart-stock-data-2025](https://www.kaggle.com/datasets/abdmoiz/walmart-stock-data-2025)

# SQL Analysis:
### Commentary
The SQL section leverages structured queries to extract meaningful insights from the Walmart stock dataset. The queries use SQLite-compatible syntax to aggregate data, calculate key metrics, and identify significant events. Techniques such as grouping, window functions, common table expressions (CTEs), and self-joins are employed to analyze temporal trends, volatility, and trading activity. Each query is designed to address a specific analytical goal, ranging from basic data exploration to advanced statistical analysis.


SQL script file: https://github.com/onurdoker/Data-Analysis-Projects/blob/main/Walmart%20Stock%20Data/script.sql

### Query Details:
#### 1. Preliminary Review and Analysis
Purpose: To gain an initial understanding of the dataset's structure and content.
Explanation: This query retrieves a sample of records to inspect columns (Date, Open, High, Low, Close, Adj_close, Volume) and their values. It helps verify data integrity, identify any anomalies (e.g., null values or outliers), and confirm the dataset's suitability for further analysis. For example, checking the range of dates ensures the dataset spans from January 2000 to March 2025, and examining numeric fields confirms they are in expected formats (e.g., positive prices and volumes).

#### 2. Highest and Lowest Closing Prices
Purpose: To calculate the minimum, maximum, and average closing prices.
Explanation: This query uses aggregate functions (<code>MIN, MAX, AVG</code>) on the <code>Close</code> column to summarize the stock’s price range and central tendency. The minimum closing price indicates the lowest value Walmart’s stock reached, the maximum shows its peak, and the average provides a baseline for typical performance. This is critical for understanding the stock’s historical boundaries and overall stability.

#### 3. Annual Performance Analysis
Purpose: To calculate the minimum, maximum, and average closing prices and total volume per year.
Technique: Uses <code>strftime('%Y', Date)</code> for grouping by year.
Explanation: By grouping data by year, this query aggregates <code>MIN(Close), MAX(Close), AVG(Close)</code>, and <code>SUM(Volume)</code> to evaluate annual trends. It reveals how Walmart’s stock performed over time, highlighting years with significant growth, decline, or high trading activity. For instance, a year with a high maximum price and volume might indicate a bullish market or a corporate milestone.

#### 4. Monthly Average Price Change
Purpose: To calculate the average closing price per month.
Technique: Uses <code>strftime('%Y-%m', Date)</code> for grouping by year-month.
Explanation: This query computes <code>AVG(Close)</code> for each month, enabling the identification of seasonal or cyclical patterns in stock prices. By grouping by year-month, it provides a finer granularity than annual analysis, which is useful for detecting intra-year trends, such as price increases during holiday seasons when Walmart’s sales typically peak.

#### 5. Monthly Average Closing Price and Volume
Purpose: To calculate the average closing price and total volume per month.
Technique: Uses <code>strftime('%Y-%m', Date)</code> for grouping by year-month.
Explanation: Similar to the previous query, this one extends the analysis by including <code>SUM(Volume)</code> alongside <code>AVG(Close)</code>. This dual focus reveals correlations between price movements and trading activity. High volume with stable prices might suggest strong investor confidence, while high volume with price drops could indicate market uncertainty.

#### 6. Annual Price Volatility
Purpose: To measure volatility as the difference between high and low prices per day, aggregated by year.
Technique: Uses a CTE and window function to rank years by volatility.
Explanation: Volatility is calculated as <code> High-Low </code> for each day, then averaged by year using a CTE. A window function (e.g., <code>RANK() OVER (ORDER BY AVG(High - Low) DESC)</code>) ranks years by volatility. This identifies periods of market instability, which could be linked to economic events, corporate announcements, or market-wide trends affecting Walmart.

#### 7. Significant Price Drops (<5% in a Day)
Purpose: To identify days with significant price drops for risk analysis.
Technique: Uses a self-join to compare consecutive days.
Explanation: This query joins the table to itself to compare <code>Close</code> values between consecutive days <code>(using Date + 1)</code>. It calculates the percentage change (<code>((Close_prev - Close_curr) / Close_prev) * 100</code>) and filters for drops greater than 5%. These events are critical for risk assessment, as they may signal adverse market conditions or company-specific issues.

#### 8. Significant Price Increases (>5% in a Day)
Purpose: To identify days with significant price increases for risk analysis.
Technique: Uses a self-join to compare consecutive days.
Explanation: Similar to the price drop query, this identifies days where the closing price increased by more than 5% using the same self-join technique. These spikes could reflect positive news (e.g., strong earnings reports) or market exuberance, providing insights into investor sentiment and potential overvaluation risks.

#### 9. The 10 Days with the Highest Trading Volume
Purpose: To determine the top 10 days with the highest trading volume.
Explanation: This query uses <code>ORDER BY Volume DESC LIMIT 10</code> to select days with the highest <code>Volume</code>. High-volume days often coincide with major events (e.g., earnings releases, mergers, or market corrections), making this analysis valuable for understanding market dynamics and investor behavior during pivotal moments.

#### 10. Volume Spikes by Year
Purpose: To detect years with unusually high trading volumes.
Technique: Uses several CTEs and statistical thresholds <code>(mean + 2*stddev)</code>.
Explanation: This query calculates the annual average and standard deviation of <code>Volume</code> using CTEs. It then flags years where the total volume exceeds the threshold of <code>mean + 2 * stddev</code>. This statistical approach identifies outliers, which may correspond to years with significant corporate or market events driving abnormal trading activity.

# Python Analysis

### Commentary

The Python section, executed in a Jupyter Notebook, focuses on data manipulation, statistical analysis, and visualization using libraries like pandas, NumPy, and matplotlib. The queries (or code blocks) systematically process the dataset, check for quality, compute derived metrics (e.g., moving averages, returns), and generate visualizations to complement the SQL findings. This section excels in providing dynamic and visual insights into Walmart’s stock trends and performance.

Jupyter Notebook File: https://github.com/onurdoker/Data-Analysis-Projects/blob/main/Walmart%20Stock%20Data/walmart.ipynb

### Query Details

#### 1. Importing Libraries
Purpose: To load essential Python libraries for data analysis and visualization.
Explanation: Libraries such as <code>pandas</code> (for data manipulation), <code>numpy</code> (for numerical operations), <code>matplotlib</code> and <code>seaborn</code> (for plotting), and potentially <code>scipy</code> (for statistics) are imported. This step ensures all necessary tools are available for subsequent analysis, enabling efficient handling of the dataset.

#### 2. Load the Data
Purpose: To import the Walmart stock dataset into a pandas DataFrame.
Explanation: The dataset (likely a CSV file from Kaggle) is loaded using <code>pd.read_csv()</code>. This step creates a DataFrame containing columns like </code>Date, Open, High, Low, Close, Adj_close</code>, and <code>Volume</code>. Proper loading is critical to ensure data is accessible for further processing and analysis.

#### 3. Missing Data Check
Purpose: To identify and quantify any missing values in the dataset.
Explanation: Using <code>df.isnull().sum()</code>, this code checks each column for null values. Missing data could distort analysis (e.g., skewing averages or disrupting time-series continuity). If missing values are found, they may need to be imputed (e.g., forward-fill for prices) or excluded, depending on their extent.

#### 4. Checking Data
Purpose: To perform a preliminary inspection of the dataset’s content.
Explanation: Commands like <code>df.head(), df.tail()</code>, or <code>df.info()</code> display the first/last few rows and summary metadata (e.g., column names, data types). This confirms the dataset’s structure matches expectations (e.g., 6 numeric columns and 1 date column) and helps spot any immediate inconsistencies.

#### 5. Check Data Types
Purpose: To verify the data types of each column.
Explanation: Using <code>df.dtypes</code>, this step ensures columns have appropriate types (e.g., <code>float64</code> for prices, <code>int64</code> for volume, and <code>object</code> or <code>datetime64</code> for Date). Incorrect types (e.g., Date as a string) could cause errors in calculations or time-series analysis, necessitating conversion.

#### 6. Convert the Date Column to Datetime
Purpose: To convert the Date column to a datetime64 type for time-series analysis.
Explanation: The code <code>df['Date'] = pd.to_datetime(df['Date'])</code> parses the Date column into a datetime format. This enables time-based operations like grouping by year/month, calculating differences, or plotting trends over time, which are essential for stock data analysis.

#### 7. Describe the Data
Purpose: To generate summary statistics for numeric columns.
Explanation: Using <code>df.describe()</code>, this query provides metrics like <code>count, mean, standard deviation, min, max</code>, and <code>quartiles</code> for <code>Open, High, Low, Close, Adj_close</code>, and <code>Volume</code>. These statistics offer a quick overview of the data’s distribution, highlighting central tendencies and variability.

#### 8. Calculate 50-day and 200-day Moving Averages
Purpose: To compute short-term (50-day) and long-term (200-day) moving averages of the closing price.
Explanation: Using <code>df['Close'].rolling(window=50).mean()</code> and <code>df['Close'].rolling(window=200).mean()</code>, this code smooths price data to identify trends. The 50-day average reflects short-term momentum, while the 200-day average indicates long-term trends. Crossovers (e.g., 50-day crossing above 200-day) can signal buy/sell opportunities.

#### 9. Calculate Daily Returns
Purpose: To compute the percentage change in closing prices between consecutive days.
Explanation: Using <code>df['Daily_Return'] = df['Close'].pct_change() * 100</code>, this calculates daily returns. This metric quantifies volatility and performance, enabling analysis of risk (e.g., high variance in returns) and comparison with market benchmarks.

#### 10. Plot Close Price
Purpose: To visualize the closing price over time.
Explanation: A line plot (e.g., <code>plt.plot(df['Date'], df['Close']</code>)) displays the Close column against Date. This visualization reveals long-term trends, such as upward growth or periods of stagnation, and helps contextualize numerical findings from SQL queries.

#### 11. Volume Over Time
Purpose: To visualize trading volume trends.
Explanation: A plot of <code>Volume</code> against <code>Date</code> (e.g., <code>sns.lineplot(data=df, x='date', y='volume')</code>) highlights periods of high/low trading activity. Spikes in volume often align with significant price movements or events, complementing the SQL query on volume spikes.

#### 12. Daily Returns Distribution
Purpose: To visualize the distribution of daily returns.
Explanation: A histogram or kernel density plot (e.g., <code>sns.histplot(df['daily_return']</code>) shows the frequency of different return values. A normal-like distribution with fat tails might indicate occasional extreme movements, informing risk analysis and aligning with SQL queries on price drops/increases.

#### 13. Adjusted Close with Moving Averages
Purpose: To visualize the adjusted closing price alongside its moving averages.
Explanation: A plot combining <code>Adj_close</code>, 50-day, and 200-day moving averages (e.g., <code>sns.lineplot()</code>, etc.) illustrates how dividends and splits affect prices and how moving averages track trends. This enhances understanding of long-term performance.

#### 14. Calculate p-value and t-stats (A/B Analysis)
Purpose: Compare stock performance (daily returns) before and after a significant event, e.g., pandemic (2020-02-29).
Explanation: Using <code>scipy.stats.ttest_ind()</code>, this code calculates the t-statistic and p-value to test for significant differences between two sets of returns (e.g., pre- and post-pandemic). p-value (>0.05) indicates a there is not a significant difference, providing evidence of structural changes in stock behavior.

# Conclusion
The analysis of Walmart’s stock data from 2000 to 2025 reveals key insights into its market performance. SQL queries uncovered annual and monthly trends, volatility patterns, significant price movements, and volume spikes, highlighting periods of stability and turbulence. Python analysis complemented these findings with robust data processing, moving average calculations, and visualizations that illustrated long-term growth, daily volatility, and trading activity. Together, these approaches provide a holistic view of Walmart’s stock, demonstrating its resilience and responsiveness to market dynamics. This dual methodology serves as a powerful framework for financial data analysis, offering actionable insights for investors and analysts.