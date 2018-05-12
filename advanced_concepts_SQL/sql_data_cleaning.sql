-- 3.1 In the accounts table, there is a column holding the website for each company.
-- The last three digits specify what type of web address they are using.
-- Pull these extensions and provide how many of each website type exist in the accounts table.
SELECT RIGHT(website,3) AS web_extension, COUNT(*) AS count
FROM accounts
GROUP BY web_extension
ORDER BY count DESC;

-- 3.2 Use the accounts table to pull the first letter of each company name
-- to see the distribution of company names that begin with each letter (or number).
SELECT LEFT(name,1) AS first_char, COUNT(*) AS count
FROM accounts
GROUP BY first_char
ORDER BY count DESC;

-- 3.3 Use the accounts table and a CASE statement to create two groups:
-- one group of company names that start with a number and a
-- second group of those company names that start with a letter.
-- What proportion of company names start with a letter?
WITH t1 AS
  (SELECT name,
         CASE WHEN LEFT(name,1)  IN ('0','1','2','3','4','5','6','7','8','9') THEN 1 ELSE 0 END AS num,
         CASE WHEN LEFT(name,1)  NOT IN ('0','1','2','3','4','5','6','7','8','9') THEN 1 ELSE 0 END AS letter
  FROM accounts)

SELECT SUM(num) AS first_number, SUM(letter) AS first_char, ROUND(SUM(letter) * 100.0/COUNT(*),2) AS letter_percentage
FROM t1;

-- 3.4 Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?
WITH t1 AS
  (SELECT name,
         CASE WHEN LEFT(LOWER(name),1)  IN ('a','e','i','o','u') THEN 1 ELSE 0 END AS vowel,
         CASE WHEN LEFT(LOWER(name),1)  NOT IN ('a','e','i','o','u') THEN 1 ELSE 0 END AS not_vowel
  FROM accounts)

SELECT ROUND(SUM(vowel) * 100.0/COUNT(*),2) AS vowel_percentage,
       ROUND(SUM(not_vowel) * 100.0/COUNT(*),2) AS not_vowel_percentage
FROM t1;

-- 6.1 Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.
SELECT LEFT(primary_poc, STRPOS(primary_poc,' ') - 1) AS first_name,
       RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc,' ')) AS last_name
FROM accounts;

-- 6.2 Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.
SELECT LEFT(name, STRPOS(name,' ') - 1) AS first_name,
       RIGHT(name, LENGTH(name) - STRPOS(name,' ')) AS last_name
FROM sales_reps;

-- 9.1 Each company in the accounts table wants to create an email address for each primary_poc.
-- The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.
WITH names AS
  (SELECT LEFT(primary_poc, STRPOS(primary_poc,' ') - 1) AS first_name,
         RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc,' ')) AS last_name,
         name
  FROM accounts)

SELECT name, first_name, last_name, first_name || '.' || last_name || '@' || name || '.com' AS email
FROM names;

-- 9.2 You may have noticed that in the previous solution some of the company names include spaces, which will certainly not work in an email address.
-- See if you can create an email address that will work by removing all of the spaces in the account name,
-- but otherwise your solution should be just as in question 1.
WITH names AS
  (SELECT LEFT(primary_poc, STRPOS(primary_poc,' ') - 1) AS first_name,
         RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc,' ')) AS last_name,
         name
  FROM accounts)

SELECT name, first_name, last_name, first_name || '.' || last_name || '@' || REPLACE(name, ' ', '') || '.com' AS email
FROM names;

-- 9.3 We would also like to create an initial password, which they will change after their first log in.
-- The first password will be the first letter of the primary_poc's first name (lowercase),
-- then the last letter of their first name (lowercase), the first letter of their last name (lowercase),
-- the last letter of their last name (lowercase), the number of letters in their first name,
-- the number of letters in their last name, and then the name of the company they are working with, all capitalized with no spaces.
WITH names AS
  (SELECT LEFT(primary_poc, STRPOS(primary_poc,' ') - 1) AS first_name,
         RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc,' ')) AS last_name,
         name
  FROM accounts)

SELECT name, first_name, last_name, first_name || '.' || last_name || '@' || REPLACE(name, ' ', '') || '.com' AS email,
       LOWER(LEFT(first_name, 1)) || LOWER(RIGHT(first_name, 1)) || LOWER(LEFT(last_name, 1)) || LOWER(RIGHT(last_name, 1)) ||
        LENGTH(first_name) || LENGTH(last_name) || UPPER(REPLACE(name, ' ', ''))
FROM names;

-- 12.1 create the correct date format
SELECT (SUBSTRING(date, 7, 4) || '-' || SUBSTRING(date, 1, 2) ||  '-' || SUBSTRING(date, 4, 2)) :: date AS corrected_date
FROM sf_crime_data
