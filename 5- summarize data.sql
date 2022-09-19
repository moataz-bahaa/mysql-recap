-- 5. summarizing data
USE sql_invoicing;

-- aggregate functions
-- they only operate on none NULL values
SELECT
	MAX(invoice_total) AS highest,
    MIN(invoice_total) AS lowest,
    AVG(invoice_total) AS average,
    SUM(invoice_total) AS total,
    COUNT(invoice_total) AS number_of_invoices,
    COUNT(client_id) AS client_id,
    COUNT(DISTINCT client_id) AS distinct_client_id,
    COUNT(invoice_total * 0.1) AS number_of_invoices_mu_by_1,
    COUNT(payment_date) AS count_of_dates,
    COUNT(*) AS total_records
FROM invoices;
-- WHERE invoice_date > '2019-07-01'; -- we can add conditions

-- group date within signle column
-- total sales for each client
SELECT
	client_id,
    SUM(invoice_total) AS total_sales
FROM invoices
GROUP BY client_id
ORDER BY total_sales DESC;

-- GROUP BY multiple columns
SELECT
	state,
    city,
    SUM(invoice_total) AS total_sales
FROM invoices AS i
JOIN clients AS c
	USING (client_id)
GROUP BY state, city;


SELECT
	p.date,
    pm.name AS payment_method,
    SUM(p.amount) AS total_payment
FROM payments AS p
JOIN payment_methods AS pm
	ON 	P.payment_method = pm.payment_method_id
GROUP BY p.date, pm.name
ORDER BY p.date, pm.name;

-- WHERE caluse: to filter data before GROUP BY
-- HAVING clause: to filter data after GROUP BY
SELECT
	client_id,
    SUM(invoice_total) AS total_sales
FROM invoices
GROUP BY client_id
HAVING total_sales > 500;


SELECT
	client_id,
    SUM(invoice_total) AS total_sales,
    COUNT(*) AS number_of_invoices
FROM invoices
GROUP BY client_id
HAVING
	total_sales > 500
    AND number_of_invoices > 5;
	-- we cann't reference payment_date as it's not selected
-- note: the columns used with HAVING caluse have to be part of SELECT clause
-- unlike WHERE clause


-- get the customers
-- 		located in virginia
-- 		who have spent more than $100

USE sql_store;

SELECT
	c.customer_id,
	c.first_name,
    c.last_name,
	SUM(oi.quantity * oi.unit_price) AS total_payment
FROM customers AS c
JOIN orders AS o
	USING(customer_id)
JOIN order_items AS oi
	USING(order_id)
WHERE state = 'VA'
GROUP BY
	c.customer_id,
	c.first_name,
    c.last_name
HAVING total_payment > 100;

-- section 5: rollup operator
-- WITH ROLLUP: gives an extra row with sum of values in each column
-- which have aggregate values


USE sql_invoicing;
SELECT 
	client_id,
    SUM(invoice_total) AS total_sales
FROM invoices
GROUP BY client_id WITH ROLLUP;

-- when we group by multiple columns so we see summary for each group
-- as wel as the entire result

-- note: rollup operater is not part of statandrd sql langaue

USE sql_invoicing;
SELECT
    state, 
    city,
    SUM(invoice_total) AS total_sales
FROM invoices AS i
JOIN clients AS c
	USING (client_id)
GROUP BY state, city WITH ROLLUP;


SELECT
	pm.name,
	SUM(amount) AS total
FROM payments AS p
JOIN payment_methods AS pm
	ON p.payment_method = pm.payment_method_id
GROUP BY pm.name WITH ROLLUP;

