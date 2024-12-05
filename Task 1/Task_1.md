# Bitstamp Assesment Test
## Task 1: Where are my assets?

Welcome to crypto! The Product team is seeking insights into the performance of our lending product. Your mission is to:

1. Clean (if needed) and enrich the attached data (*task_1_earn.csv*) – end goal is having clean table which can be
easily used (without any manipulation) for any kind of analytics. The presented data includes all completed lending
withdrawals (when a user makes a request to stop lending). Add yearweek and yearmonth columns and any other
that will be useful to end users.
Definitions:
    - **User_Id** is the id of user
    - **Id** is the identifier of the withdrawal request
    - **Requested_at** means when the user made a request to unlend
    - **Finished_at** means when the lending provider completed the lending and user got the funds

2. Prepare an analysis of the lending product with the data you have so the product team will be able to identify if we
have any issues with our lending provider. Include numbers and graphs and don't forget to write key findings.
    -  Identify key trends, patterns, and potential issues with the lending provider.

3. Based on your analysis:
    - **Identify opportunities** to improve the **performance** and **reliability** of our lending provider.
    - Suggest actionable **recommendations** for the Product team to address these issues.

--------------------------------------------------------------------------------------------

### Data Analysis

Let's first look at the data **manually** to see if there are things that stand out. 

We see that there is enormous volatility in conversions between the given cryptocurrency and USD. Withdrawal requests with similar native values that were recorded minutes apart for the same currency have vastly different USD values. We will have to analyse if there are other factors that contribute to this volatility or if it is only the price volatility of cryptocurrencies.

Another feature of the data is that the majority of values for amount_native range from 17.4 to 17.6. We will have to perform analysis to get a specific distribution. This could indicate there is a lower limit for the amount able to be withdrawn set at ~17 units of the currency.

Looking at the processing time, we can see that there is also a lot of volatility there. By the first look one factor determining the length of time to fulfil the request is the currency (e. g. When withdrawing PEPE the time_to_complete is around 150 hours, while it is between 2 and 20 hours for Bitcoin withdrawals)

Taking a quick look at the user_id data shows us we have a few different types of users. There are some repeating users with frequent transactions, sometimes spanning in just one currency, sometimes spanning through multiple. There are also some users with infrequent transactions. 

Lastly, we can notice that a lot of withdrawals where the amount_native is higher than average, the conversion rate is also much better. This indicates that the bigger clients take their assets out of the lending program when the opportunity to realise gains arises. 

Now lets analyse the data to see if we can confirm our preliminary findings or find some other paterns.

--------------------------------------------------------------------------------------------

### Data Summary and Key Findings

We have now analysed the data by four main categories:
- Conversion rate
- Withdrawal size
- Processing time
- User behaviour

##### Conversion rate
We have 13 different currencies that have vastly different volatility. PEPE and BTC have by far the highest volatilities. There are some more stable currnecies, most stable seems to be DOT which has the lowest absolute and relative standard diviation. On average the volatility of the entire market is very high.

Another peculiar attribute is the the minimal conversion rates of almost every currency is 30.722. However, this is likely just a feature that comes out of the way data was generated.

When we present the more volatile currencies as a time series we see there are many anomalies, where the price of the asset jumps by up to 800,000% for one withdrawal and then drops right back down. This could be a serious issue, since te actual currency value is likely not reflecting this jump. Meaning, **there could be an issue in the lending system that allows for withdrawals at the wrong USD price.** This phenomenon apears, although less frequently among some lower volatility currencies as well.

We have also looked at the volatiliy of conversion rates based on the number of transactions for each currency. We notice that currencies with higher trading volume (volume of withdrawals) have higher volatility. 

##### Withdrawal size

The first thing we notice when we look at size of withdrawals is that we have a lower bound at 17.446609 units of currency for all assets. This likely means there is a set boundry that limits the smallest possible withdrawal. Since mean and median are also very close to that value (additionally median is lower than the mean), we can say the **majority of withdrawals is done at or near the lower limit**. This can also be seen in the graph showing the distribution of USDT withdrawals, which is the currency with the highest mean withdrawal and highest standard diviation.

We then looked at the correlation between the withdrawal size and conversion rate. Here we can see that for most less volatile assets the scatterplots look as you would expect. A lot of lower quantity withdrawals spread evenly throughout all different conversion rates, with bigger withdrawals comming with higher conversion rates (clients with bigger positions realising their earnings). 

A bigger surprise comes with the more volatile assets like BTC and PEPE (To some extent we can also see this in AVAX and DOT). There we have a almost linear correlation between amount_native withdrawn and the conversion rate. Meaning, **if ther is an actual issue with some withdrawals processing with vastly higher conversion rates, users can see it and exploit it, by dumping bigger amounts of their currencies at the boosted conversion rates.**

##### Processing Time

Looking at different processing times we can see that over $\frac23$ requests get processed within the first day and over 85% of transactions are done within the first two days.

Processing times differ for different currencies. We can see that currencies with higher trade volume have higher processing times.

Looking at correlation between processing time and the size of the withdrawal we can see there is very little corelation (in native currency or USD). This probably means there is no priority based on size.

Now we will look at the processing time based on the withdrawal request day or month. Interestingly even though **number of transactions are fairly similar for all days of the week with small increases on Wednesday and Thursday, there is an around 80% increase in processing times**. There is another (smaller) increase on Sundays. We can assume that stems from a lower amount of working staff. Withdrawal times also increase in the months leading up to new year, the slowest processing times spanning from September to January. There is also an increase in number of transactions in those months, which explains the slower processing times.

When analysing processing times based on time of request we see that withdrawal requests issued between 11PM and 2AM have drastically higher processing times. There is a more than 20 hour increase in processing comparing requests submitted at 22PM and 23PM. **This could indicate that late night requests get lost in the system**.

##### User Behaviour 

From the data we see that currencies with the highest number of users are PEPE, BTC, UNI and AVAX. UNI and PEPE also have the highest amount of currency withdrawn. **Most of the users only lend one currency and the number of users for each additional currency decreases exponentially**.

We can divide users into three categories:
- High frequency (over 20 transactions)
- Medium frequency (between 6 and 20 transactions)
- Low frequency (5 or less transactions)

Most of the users are low frequency. Most of these users trade rarely and at low volumes. Unexpectedly there are very few low frequency high volume users. The highest volume withdrawals fall among the high frequency users. We can assume some of these users are using algorithms that withdraw the funds whenever there is a mispricing that we discovered in the first two parts.

Processing times are the fastest for high frequency users and they are the slowest for low frequency users. This probably means the process of withdrawal is streamlined for users who frequently withdraw funds.

Interestingly, in contradiction to previous findings the best conversion rates, mostly for the high volatility assets are given to low and medium frequency users. This means the low frequency users only withdraw funds when there are big capital gains to be realised.

--------------------------------------------------------------------------------------------

### Improvement opportunities and recommendations

1. Address Date logging errors:

**Issue**: We observe many date logging errors for requested_at and finished_at. These errors span from invalid dates logged to negative differences between requested_at and finished_at datetimes.

**Improvement**: **Implement Date Validation**. When dates are logged, ensure they are valid and fall within acceptable ranges (e.g., not invalid dates). **Automate Date Cleaning**. During data ingestion or processing, automatically convert any invalid date entries to NaT (Not a Time), and flag these rows for review.  If an invalid date cannot be automatically corrected, a **predefined fallback date** could be used, or the transaction should be **marked for manual review**.

2. Address Conversion Rate Anomalies:

**Issue**: We've observed significant spikes in conversion rates for certain currencies, particularly PEPE and BTC. These spikes can reach up to 800,000% for individual withdrawals and then drop right back down. This could be a serious issue in the lending system, as the price at the time of withdrawal might not reflect the actual currency value.

**Improvement**: To improve the system's reliability and prevent exploitation of mispricing, a **review of the conversion rate logic** is needed. Ensure that the conversion rates are recalculated correctly and consistently for every withdrawal. Adding **real-time validation checks** against the current market value could help mitigate these sudden fluctuations. If conversion rates deviate from expected market prices, the system could **flag the transaction** for manual review or automatically halt withdrawals until the issue is resolved.

3. Withdrawal Lower Limit Issue:

**Issue**: The data indicates that most withdrawals are **near the lower boundary** of the withdrawal size limit (**17.446609 units**). This indicates a **lack of flexibility** or options for smaller withdrawals.

**Improvement**: **Expand the withdrawal size limit**s or allow for **tiered withdrawal sizes** to accommodate a wider range of users. This could improve the user experience for those who wish to withdraw smaller amounts. Additionally, allowing for custom withdrawal size limits could increase user participation in the lending program bringing in higher profits for the company.

4. Reduce Volatility in High-Volume Currencies:

**Issue**: Currencies with higher trading volume (like BTC and PEPE) exhibit significantly higher volatility in their conversion rates.

**Improvement**: Implement more sophisticated **slippage controls or dynamic pricing** that smooths out conversion rate volatility during high-volume periods. This would improve reliability and ensure that users get consistent conversion rates without unexpected spikes. Also, **introducing buffers for large withdrawals** could prevent massive fluctuations caused by large transactions.

5. Improve Processing Time During Peak Hours:

**Issue**: **Processing times are significantly higher during certain periods** of the day (especially late-night hours between 11 PM and 2 AM), as well as during high-traffic months leading up to the New Year.

**Improvement**: **Optimize resource allocation** for late-night hours or low-staff periods. Consider implementing **automated systems** to handle withdrawals during these times, or **shift resources to high-traffic hours** to minimize delays. Additionally, improving load balancing and scaling infrastructure during high-traffic months could significantly reduce processing delays.

6. Fix System Delays Caused by Late-Night Requests

**Issue**:  **Late-night withdrawal requests show drastic increases in processing times**, potentially due to system bottlenecks or a lack of staff at night.

**Improvement**: **Automate late-night withdrawal processing** using algorithms that can handle routine requests, or increase staff during late-night shifts to handle these requests more efficiently. Alternatively, **introducing queue management systems** could help prioritize requests based on urgency.




