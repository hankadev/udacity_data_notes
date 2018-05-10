-- 7.1 Find the total amount of poster_qty paper ordered in the orders table.
SELECT SUM(poster_qty) AS total_poster_qty
FROM orders;

-- 7.2 Find the total amount of standard_qty paper ordered in the orders table.
SELECT SUM(standard_qty) AS total_standard_qty
FROM orders;

-- 7.3 Find the total dollar amount of sales using the total_amt_usd in the orders table.
SELECT SUM(total_amt_usd) AS total_amt_usd
FROM orders;

-- 7.4 Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table.
-- This should give a dollar amount for each order in the table.
SELECT standard_amt_usd + gloss_amt_usd AS total_standard_and_gloss_amt_usd
FROM orders;

-- 7.5 Find the standard_amt_usd per unit of standard_qty paper.
-- Your solution should use both an aggregation and a mathematical operator.
SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders;

-- 11.1 When was the earliest order ever placed? You only need to return the date.
SELECT MIN(occurred_at)
FROM orders;

-- 11.2 Try performing the same query as in question 1 without using an aggregation function.
SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1;

-- 11.3 When did the most recent (latest) web_event occur?
SELECT MAX(occurred_at)
FROM web_events;

-- 11.4 Try to perform the result of the previous query without using an aggregation function.
SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

-- 11.5 Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order.
-- Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.
SELECT AVG(standard_amt_usd) AS avg_standard_amt, AVG(gloss_amt_usd) AS avg_gloss_amt, AVG(poster_amt_usd) AS avg_poster_amt,
        AVG(standard_qty) AS avg_standard_qty, AVG(gloss_qty) AS avg_gloss_qty, AVG(poster_qty) AS avg_poster_qty
FROM orders;

-- 14.1 Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
SELECT a.name, o.occurred_at
FROM orders o
JOIN accounts a ON o.account_id = a.id
ORDER BY o.occurred_at
LIMIT 1;

-- 14.2 Find the total sales in usd for each account.
-- You should include two columns - the total sales for each company's orders in usd and the company name.
SELECT SUM(o.total_amt_usd) AS total_sales, a.name
FROM orders o
JOIN accounts a ON o.account_id = a.id
GROUP BY a.name;

-- 14.3 Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event?
-- Your query should return only three values - the date, channel, and account name.
SELECT w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1;

-- 14.4 Find the total number of times each type of channel from the web_events was used.
-- Your final table should have two columns - the channel and the number of times the channel was used.
SELECT channel, COUNT(*) AS count
FROM web_events
GROUP BY channel;

-- 14.5 Who was the primary contact associated with the earliest web_event?
SELECT a.primary_poc
FROM web_events w
JOIN accounts a ON w.account_id = a.id
ORDER BY w.occurred_at
LIMIT 1;

-- 14.6 What was the smallest order placed by each account in terms of total usd.
-- Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.
SELECT a.name, MIN(o.total_amt_usd) AS smallest_order
FROM orders o
JOIN accounts a ON o.account_id = a.id
GROUP BY a.name
ORDER BY smallest_order;

-- 14.7 Find the number of sales reps in each region.
-- Your final table should have two columns - the region and the number of sales_reps.
-- Order from fewest reps to most reps.
SELECT r.name, COUNT(*) as sls_reps_count
FROM region r
JOIN sales_reps s ON s.region_id = r.id
GROUP BY r.name
ORDER BY sls_reps_count;

-- 17.1 For each account, determine the average amount of each type of paper they purchased across their orders.
-- Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.
SELECT a.name, AVG(o.standard_qty) AS avg_standard, AVG(o.gloss_qty) AS avg_gloss, AVG(o.poster_qty) AS avg_poster
FROM orders o
JOIN accounts a ON o.account_id = a.id
GROUP BY a.name;

-- 17.2 For each account, determine the average amount spent per order on each paper type.
-- Your result should have four columns - one for the account name and one for the average amount spent on each paper type.
SELECT a.name, AVG(o.standard_amt_usd) AS avg_standard, AVG(o.gloss_amt_usd) AS avg_gloss, AVG(o.poster_amt_usd) AS avg_poster
FROM orders o
JOIN accounts a ON o.account_id = a.id
GROUP BY a.name;

-- 17.3 Determine the number of times a particular channel was used in the web_events table for each sales rep.
-- Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences.
-- Order your table with the highest number of occurrences first.
SELECT s.name, w.channel, COUNT(*) AS occurrences
FROM web_events w
JOIN accounts a ON w.account_id = a.id
JOIN sales_reps s ON a.sales_rep_id = s.id
GROUP BY s.name, w.channel
ORDER BY occurrences DESC;

-- 17.4 Determine the number of times a particular channel was used in the web_events table for each region.
-- Your final table should have three columns - the region name, the channel, and the number of occurrences.
-- Order your table with the highest number of occurrences first.
SELECT r.name, w.channel, COUNT(*) AS occurrences
FROM web_events w
JOIN accounts a ON w.account_id = a.id
JOIN sales_reps s ON a.sales_rep_id = s.id
JOIN region r ON s.region_id = r.id
GROUP BY r.name, w.channel
ORDER BY occurrences DESC;

-- 20.1 Use DISTINCT to test if there are any accounts associated with more than one region.
SELECT a.id AS account_id, r.id AS region_id, a.name AS account, r.name AS region
FROM accounts a
JOIN sales_reps s ON s.id = a.sales_rep_id
JOIN region r ON r.id = s.region_id;

SELECT DISTINCT id, name
FROM accounts;
-- => same results, therefore every account is associated with one region

-- 20.2 Have any sales reps worked on more than one account?
SELECT s.id, s.name, COUNT(*) count_accounts
FROM accounts a
JOIN sales_reps s ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY count_accounts;

SELECT DISTINCT id, name
FROM sales_reps;
-- => different result, therefore some sales reps working with more than one account

-- 23.1 How many of the sales reps have more than 5 accounts that they manage?
SELECT s.id, s.name, COUNT(*) AS count_accounts
FROM accounts a
JOIN sales_reps s ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5
ORDER BY count_accounts DESC;

-- 23.2 How many accounts have more than 20 orders?
SELECT a.id, a.name, COUNT(*) AS count_orders
FROM orders o
JOIN accounts a ON o.account_id = a.id
GROUP BY a.id, a.name
HAVING COUNT(*) > 20
ORDER BY count_orders DESC;

-- 23.3 Which account has the most orders?
SELECT a.id, a.name, COUNT(*) AS count_orders
FROM orders o
JOIN accounts a ON o.account_id = a.id
GROUP BY a.id, a.name
ORDER BY count_orders DESC
LIMIT 1;

-- 23.4 How many accounts spent more than 30,000 usd total across all orders?
SELECT a.id, a.name, SUM(total_amt_usd) AS total_usd
FROM orders o
JOIN accounts a ON o.account_id = a.id
GROUP BY a.id, a.name
HAVING SUM(total_amt_usd) > 30000
ORDER BY total_usd DESC;

-- 23.5 How many accounts spent less than 1,000 usd total across all orders?
SELECT a.id, a.name, SUM(total_amt_usd) AS total_usd
FROM orders o
JOIN accounts a ON o.account_id = a.id
GROUP BY a.id, a.name
HAVING SUM(total_amt_usd) < 1000
ORDER BY total_usd;

-- 23.6 Which account has spent the most with us?
SELECT a.id, a.name, SUM(total_amt_usd) AS total_usd
FROM orders o
JOIN accounts a ON o.account_id = a.id
GROUP BY a.id, a.name
ORDER BY total_usd DESC
LIMIT 1;

-- 23.7 Which account has spent the least with us?
SELECT a.id, a.name, SUM(total_amt_usd) AS total_usd
FROM orders o
JOIN accounts a ON o.account_id = a.id
GROUP BY a.id, a.name
ORDER BY total_usd
LIMIT 1;

-- 23.8 Which accounts used facebook as a channel to contact customers more than 6 times?
SELECT a.id, a.name, COUNT(*) AS facebook_contact
FROM accounts a
JOIN web_events w ON a.id = w.account_id AND w.channel = 'facebook'
GROUP BY a.id, a.name
HAVING COUNT(*) > 6
ORDER BY facebook_contact DESC;

-- 23.9 Which account used facebook most as a channel?
SELECT a.id, a.name, COUNT(*) AS facebook_contact
FROM accounts a
JOIN web_events w ON a.id = w.account_id AND w.channel = 'facebook'
GROUP BY a.id, a.name
ORDER BY facebook_contact DESC
LIMIT 1;

-- 23.10 Which channel was most frequently used by most accounts?
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 10;

-- 27.1 Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least.
-- Do you notice any trends in the yearly sales totals?
SELECT DATE_PART('year', occurred_at) AS year,  SUM(total_amt_usd) AS total_amount
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-- 27.2 Which month did Parch & Posey have the greatest sales in terms of total dollars?
-- Are all months evenly represented by the dataset?
SELECT DATE_PART('month', occurred_at) AS month,  SUM(total_amt_usd) AS total_amount
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-- 27.3 Which year did Parch & Posey have the greatest sales in terms of total number of orders?
-- Are all years evenly represented by the dataset?
SELECT DATE_PART('year', occurred_at) AS year,  COUNT(*) total_order
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-- 27.4 Which month did Parch & Posey have the greatest sales in terms of total number of orders?
-- Are all months evenly represented by the dataset?
SELECT DATE_PART('month', occurred_at) AS month,  COUNT(*) total_order
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-- 27.4 In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
SELECT DATE_PART('month', o.occurred_at) AS month,  SUM(o.gloss_amt_usd) AS Walmart_total_order
FROM orders o
JOIN accounts a ON o.account_id = a.id AND a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 31.1 We would like to understand 3 different levels of customers based on the amount associated with their purchases.
-- The top branch includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd.
-- The second branch is between 200,000 and 100,000 usd. The lowest branch is anyone under 100,000 usd.
-- Provide a table that includes the level associated with each account.
-- You should provide the account name, the total sales of all orders for the customer, and the level.
-- Order with the top spending customers listed first.
SELECT a.name, SUM(o.total_amt_usd) AS total_amount_spend,
      CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'top value'
           WHEN SUM(o.total_amt_usd) > 100000 THEN 'middle value'
           ELSE 'low value'
      END AS value
FROM orders o JOIN accounts a ON o.account_id = a.id
GROUP BY a.name
ORDER BY value DESC;

-- 31.2 We would now like to perform a similar calculation to the first, but we want to obtain
-- the total amount spent by customers only in 2016 and 2017. Keep the same levels as in the previous question.
-- Order with the top spending customers listed first.
SELECT a.name, SUM(o.total_amt_usd) AS total_amount_spend,
      CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'top value'
           WHEN SUM(o.total_amt_usd) > 100000 THEN 'middle value'
           ELSE 'low value'
      END AS value
FROM orders o JOIN accounts a ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '2016-01-01' AND '2018-01-01'
GROUP BY a.name
ORDER BY value DESC;

-- 31.3 We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders.
-- Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders.
-- Place the top sales people first in your final table.
SELECT s.name, COUNT(*) AS num_of_orders,
      CASE WHEN COUNT(*) > 200 THEN 'yes'
      ELSE 'no'
      END AS over_200_orders
FROM orders o
JOIN accounts a ON o.account_id = a.id
JOIN sales_reps s ON a.sales_rep_id = s.id
GROUP BY s.name
ORDER BY num_of_orders DESC;

-- 31.3 The previous didn't account for the middle, nor the dollar amount associated with the sales.
-- Management decides they want to see these characteristics represented as well.
-- We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales.
-- The middle group has any rep with more than 150 orders or 500000 in sales.
-- Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low
-- depending on this criteria. Place the top sales people based on dollar amount of sales first in your final table.
-- You might see a few upset sales people by this criteria!
SELECT s.name, COUNT(*) AS num_of_orders, SUM(o.total_amt_usd) AS total_sales,
      CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
           WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'
      ELSE 'low'
      END AS performance
FROM orders o
JOIN accounts a ON o.account_id = a.id
JOIN sales_reps s ON a.sales_rep_id = s.id
GROUP BY s.name
ORDER BY total_sales DESC, num_of_orders DESC;
