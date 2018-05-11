-- 3. get a table that shows the average number of events a day for each channel.
SELECT channel, AVG(event_count) as avg_event_count
FROM
  (SELECT DATE_TRUNC('day', occurred_at) AS day, channel, COUNT(*) as event_count
  FROM web_events
  GROUP BY day, channel) t
GROUP BY channel
ORDER BY avg_event_count DESC;

-- 7. find only the orders that took placein the same month and year as the first order
-- pull the average for each type of paper
SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);

-- 10.1 Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
SELECT t3.sls_rep, t3.region, t3.sales
FROM
  (SELECT region, MAX(sales) AS sales
  FROM
    (SELECT s.name AS sls_rep, r.name AS region, SUM(o.total_amt_usd) AS sales
    FROM orders o
    JOIN accounts a ON o.account_id = a.id
    JOIN sales_reps s ON a.sales_rep_id = s.id
    JOIN region r ON s.region_id = r.id
    GROUP BY s.name, r.name) t1
  GROUP BY region) t2
  JOIN
    (SELECT s.name AS sls_rep, r.name AS region, SUM(o.total_amt_usd) AS sales
    FROM orders o
    JOIN accounts a ON o.account_id = a.id
    JOIN sales_reps s ON a.sales_rep_id = s.id
    JOIN region r ON s.region_id = r.id
    GROUP BY s.name, r.name) t3
  ON t3.sales = t2.sales AND t3.region = t2.region
ORDER BY 3 DESC;

-- 10.2 For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?

-- 10.3 For the name of the account that purchased the most (in total over their lifetime as a customer) standard_qty paper,
-- how many accounts still had more in total purchases?

-- 10.4 For the customer that spent the most (in total over their lifetime as a customer)
-- total_amt_usd, how many web_events did they have for each channel?

-- 10.5 What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

-- 10.6 What is the lifetime average amount spent in terms of total_amt_usd for only the companies that spent more than the average of all orders.
