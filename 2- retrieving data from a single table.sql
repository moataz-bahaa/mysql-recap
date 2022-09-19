-- REG expression

USE sql_store;

SELECT *
FROM customers
WHERE first_name REGEXP 'elka|ambur'; -- contain elka or abmur

SELECT *
FROM customers
WHERE last_name REGEXP 'EY$|ON$'; -- end with ey or end with on

SELECT * 
FROM customers
WHERE last_name REGEXP '^MY|SE'; -- start with my or contain se

SELECT *
FROM customers
WHERE last_name REGEXP 'B[RU]'; -- contain b followed by r or u


-- IS NULL
SELECT *
FROM customers
WHERE phone IS NOT NULL;

SELECT *
FROM orders
WHERE shipper_id IS NULL;


-- ORDER BY
SELECT *
FROM customers
ORDER BY first_name DESC;

-- multiple sort
SELECT first_name, last_name
FROM customers
ORDER BY state DESC, first_name ASC;

-- sort by column that not exsit in the table
SELECT first_name, last_name, 10 AS testing
FROM customers
ORDER BY testing, first_name;

SELECT first_name, last_name
FROM customers
ORDER BY first_name, last_name;

-- same as
SELECT first_name, last_name
FROM customers
ORDER BY 1, 2; -- same as above query and this is bad behavior


-- LIMIT clause
SELECT * 
FROM customers
LIMIT 3; -- return only the first 3 records

SELECT *
FROM customers
LIMIT 6, 3; -- skip 6 records and then return 3 records


 -- pick the first 3 loyal customers (have the most points)
 SELECT *
 FROM customers
 ORDER BY points DESC
 LIMIT 3;
 
 -- 3.retreiving data from multiple tables