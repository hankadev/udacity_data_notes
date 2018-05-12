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
SELECT r.name, COUNT(o.total) AS count_orders
FROM orders o
JOIN accounts a ON o.account_id = a.id
JOIN sales_reps s ON a.sales_rep_id = s.id
JOIN region r ON s.region_id = r.id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) =
  (SELECT MAX(total_sales)
  FROM
    (SELECT r.id, r.name, SUM(o.total_amt_usd) as total_sales
    FROM orders o
    JOIN accounts a ON o.account_id = a.id
    JOIN sales_reps s ON a.sales_rep_id = s.id
    JOIN region r ON s.region_id = r.id
    GROUP BY r.id, r.name) tb_sales)

-- 10.3 For the name of the account that purchased the most (in total over their lifetime as a customer) standard_qty paper,
-- how many accounts still had more in total purchases?
SELECT COUNT(*)
FROM
  (SELECT a.name
  FROM orders o
  JOIN accounts a ON o.account_id = a.id
  GROUP BY a.name
  HAVING SUM(o.total) >
    (SELECT total_purchase
    FROM
      (SELECT a.name, SUM(o.standard_qty) AS sum_standard_qty, SUM(o.total) AS total_purchase
      FROM orders o
      JOIN accounts a ON o.account_id = a.id
      GROUP BY a.name
      ORDER BY sum_standard_qty DESC
      LIMIT 1) t1)) name_tab;

-- 10.4 For the customer that spent the most (in total over their lifetime as a customer)
-- total_amt_usd, how many web_events did they have for each channel?
SELECT a.name, w.channel, COUNT(*)
FROM  web_events w
JOIN accounts a ON a.id = w.account_id
GROUP BY a.name, w.channel
HAVING a.name =
  (SELECT a.name
  FROM orders o
  JOIN accounts a ON o.account_id = a.id
  GROUP BY a.name
  HAVING SUM(o.total_amt_usd) =
    (SELECT MAX(total_spend) AS max_total_spend
    FROM
      (SELECT a.name, SUM(o.total_amt_usd) AS total_spend
      FROM orders o
      JOIN accounts a ON o.account_id = a.id
      GROUP BY a.name) tb_spend))
ORDER BY 3 DESC;

-- 10.5 What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
SELECT AVG(total_spend) AS avg_top10_lifetime_spend
FROM
  (SELECT a.name, SUM(o.total_amt_usd) AS total_spend
  FROM orders o
  JOIN accounts a ON o.account_id = a.id
  GROUP BY a.name
  ORDER BY total_spend DESC
  LIMIT 10) table_spend;

-- 10.6 What is the lifetime average amount spent in terms of total_amt_usd for only the companies that spent more than the average of all orders.
SELECT AVG(amount) AS avg_amt_spent
FROM
  (SELECT account_id, AVG(total_amt_usd) AS amount
  FROM orders
  GROUP BY account_id
  HAVING AVG(total_amt_usd) >
    (SELECT AVG(total_amt_usd)
    FROM orders o
    JOIN accounts a ON a.id = o.account_id)) t1;

----- write the queries from part 10 using WITH statement-----
-- 14.1 Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
WITH t1 AS
  (SELECT s.name AS sls_rep, r.name AS region, SUM(o.total_amt_usd) AS sales
  FROM orders o
  JOIN accounts a ON o.account_id = a.id
  JOIN sales_reps s ON a.sales_rep_id = s.id
  JOIN region r ON s.region_id = r.id
  GROUP BY s.name, r.name),

  t2 AS
  (SELECT region, MAX(sales) AS sales
  FROM t1
  GROUP BY region)

SELECT t1.sls_rep, t1.region, t1.sales
FROM t2
JOIN t1
ON t1.sales = t2.sales AND t1.region = t2.region
ORDER BY 3 DESC;

-- 14.2 For the region with the largest sales total_amt_usd, how many total orders were placed?
WITH tb_sales AS
  (SELECT r.id, r.name, SUM(o.total_amt_usd) AS total_sales
  FROM orders o
  JOIN accounts a ON o.account_id = a.id
  JOIN sales_reps s ON a.sales_rep_id = s.id
  JOIN region r ON s.region_id = r.id
  GROUP BY r.id, r.name),

  tb_max_sales AS
  (SELECT MAX(total_sales)
  FROM tb_sales)

SELECT r.name, COUNT(o.total) AS count_orders
FROM orders o
JOIN accounts a ON o.account_id = a.id
JOIN sales_reps s ON a.sales_rep_id = s.id
JOIN region r ON s.region_id = r.id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (SELECT * FROM tb_max_sales);

-- 14.3 For the name of the account that purchased the most (in total over their lifetime as a customer) standard_qty paper,
-- how many accounts still had more in total purchases?
WITH t1 AS
  (SELECT a.name, SUM(o.standard_qty) AS sum_standard_qty, SUM(o.total) AS total_purchase
  FROM orders o
  JOIN accounts a ON o.account_id = a.id
  GROUP BY a.name
  ORDER BY sum_standard_qty DESC
  LIMIT 1),

  t2 AS
  (SELECT total_purchase
  FROM t1),

  t3 AS
  (SELECT a.name
  FROM orders o
  JOIN accounts a ON o.account_id = a.id
  GROUP BY a.name
  HAVING SUM(o.total) > (SELECT total_purchase FROM t2))

SELECT COUNT(*)
FROM t3;

-- 14.4 For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd,
-- how many web_events did they have for each channel?
WITH tb_spend AS
  (SELECT a.name, SUM(o.total_amt_usd) AS total_spend
  FROM orders o
  JOIN accounts a ON o.account_id = a.id
  GROUP BY a.name),

  tb_max_spend AS
  (SELECT MAX(total_spend) AS max_total_spend
  FROM tb_spend),

  tb_acc_names AS
  (SELECT a.name AS name
  FROM orders o
  JOIN accounts a ON o.account_id = a.id
  GROUP BY a.name
  HAVING SUM(o.total_amt_usd) = (SELECT max_total_spend FROM tb_max_spend))

SELECT a.name, w.channel, COUNT(*)
FROM  web_events w
JOIN accounts a ON a.id = w.account_id
GROUP BY a.name, w.channel
HAVING a.name = (SELECT name FROM tb_acc_names )
ORDER BY 3 DESC;

-- 14.5 What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
WITH table_spend AS
  (SELECT a.name, SUM(o.total_amt_usd) AS total_spend
  FROM orders o
  JOIN accounts a ON o.account_id = a.id
  GROUP BY a.name
  ORDER BY total_spend DESC
  LIMIT 10)

SELECT AVG(total_spend) AS avg_top10_lifetime_spend
FROM table_spend;

-- 14.6 What is the lifetime average amount spent in terms of total_amt_usd for only the companies that spent more than the average of all accounts.
WITH t1 AS
  (SELECT AVG(total_amt_usd) AS average
  FROM orders o
  JOIN accounts a ON a.id = o.account_id),

  t2 AS
  (SELECT account_id, AVG(total_amt_usd) AS amount
  FROM orders
  GROUP BY account_id
  HAVING AVG(total_amt_usd) > (SELECT average FROM t1))

SELECT AVG(amount) AS avg_amt_spent
FROM t2;
