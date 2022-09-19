-- wrting complex quries
USE sql_store;

-- find products that are more expensive that Lettuce (id = 3)
SELECT
	product_id,
    name,
    unit_price
FROM products
WHERE unit_price > (
	SELECT
		unit_price
	FROM products
	WHERE name LIKE '%Lettuce%'	
);


-- in sql_hr databases:
-- 		find employees whose earn more than average
USE sql_hr;

SELECT *
FROM employees
WHERE salary > (
	SELECT
		AVG(salary)
	FROM employees
);


-- find the products that have never been ordered
USE sql_store;

SELECT *
FROM products
WHERE product_id NOT IN (
	SELECT DISTINCT
		product_id
    FROM order_items
);

-- find clients without invoices
USE sql_invoicing;

SELECT *
FROM clients
WHERE client_id NOT IN (
	SELECT DISTINCT
		client_id
	FROM invoices
);

-- solution using join
SELECT *
FROM clients As c
LEFT JOIN invoices AS i
	USING (client_id)
WHERE invoice_id IS NULL;


-- find customers who have ordered lettuce (id = 3)
-- 		select customer_id, first_name, last_name 
-- solve it with 2 solutions

USE sql_store;

-- soltion using subqures
SELECT
	customer_id,
    first_name,
    last_name
FROM customers
WHERE customer_id IN (
	SELECT DISTINCT
		customer_id
    FROM orders
    WHERE order_id IN (
		SELECT
			order_id
		FROM order_items
		WHERE product_id = 3
    )
);

-- soltion using join and subquries
SELECT
	customer_id,
    first_name,
    last_name
FROM customers
WHERE customer_id IN (
	SELECT DISTINCT
		customer_id
    FROM orders AS o
    JOIN order_items AS oi
		USING(order_id)
	WHERE oi.product_id = 3
);

-- using join (good one)

SELECT DISTINCT
	c.customer_id,
    c.first_name,
    c.last_name
FROM customers AS c
JOIN orders AS o
	USING(customer_id)
JOIN order_items AS oi
	USING(order_id)
WHERE oi.product_id = 3;


-- select invoices larger than all invoices of client 3

USE sql_invoicing;

SELECT *
FROM invoices
WHERE invoice_total > (
	SELECT
		MAX(invoice_total)
	FROM invoices
	WHERE client_id = 3
);

-- another soluiton usin ALL clause
SELECT *
FROM invoices
WHERE invoice_total > ALL (
	SELECT
		invoice_total
	FROM invoices
	WHERE client_id = 3
);

-- select clients with at least w invoices
-- ANY operator
SELECT *
FROM clients
WHERE client_id = ANY ( -- equivalant to IN ()
	SELECT client_id
	FROM invoices
    GROUP BY client_id
    HAVING COUNT(*) >= 2
);


-- correlated subquries
-- select employees whose salary is above the average in their office
USE sql_hr;

SELECT *
FROM employees AS e
WHERE salary > (
	SELECT
		AVG(salary)
	FROM employees
    WHERE e.office_id = office_id
);

-- calculate avg salary for each office
SELECT
	office_id,
	AVG(salary)
FROM employees
GROUP BY office_id;

-- get invoices that are larger than the clients avg invoice amount
USE sql_invoicing;
SELECT *
FROM invoices AS i
WHERE invoice_total > (
	SELECT
		AVG(invoice_total)
	FROM invoices
    WHERE i.client_id = client_id
);


-- select clients that have an invoice
SELECT *
FROM clients
WHERE client_id IN (
	SELECT DISTINCT client_id
	FROM invoices
);

SELECT *
FROM clients As c
WHERE EXISTS (
	SELECT client_id
    FROM invoices
    WHERE client_id = c.client_id
);

-- find the producs that have never been ordered
USE sql_store;
SELECT *
FROM products
WHERE product_id NOT IN (
	SELECT DISTINCT product_id
    FROM order_items
);

-- in operate can retrun big list
-- try use EXSITS
SELECT *
FROM products AS p
WHERE NOT EXISTS (
	SELECT product_id
    FROM order_items
    WHERE product_id = p.product_id
);

-- subquries in select
USE sql_invoicing;
SELECT
	invoice_id,
    invoice_total,
    (
		SELECT AVG(invoice_total)
        FROM invoices
    ) AS invoice_avg,
    invoice_total - (SELECT invoice_avg) AS difference
FROM invoices;

SELECT
	client_id,
    name,
    (
		SELECT
			SUM(invoice_total)
		FROM invoices
        WHERE client_id = c.client_id
    ) AS total_sales,
    (
		SELECT AVG(invoice_total)
		FROM invoices
    ) AS avg_sales,
    -- we cannot use total_sales - avg_salse
    (SELECT total_sales) - (SELECT avg_sales) AS diffrerence
FROM clients AS c;

-- subquries in FROM clause

SELECT *
FROM (
	SELECT
		client_id,
		name,
		(
			SELECT
				SUM(invoice_total)
			FROM invoices
			WHERE client_id = c.client_id
		) AS total_sales,
		(
			SELECT AVG(invoice_total)
			FROM invoices
		) AS avg_sales,
    (SELECT total_sales) - (SELECT avg_sales) AS diffrerence
	FROM clients AS c
) AS sales_summary -- wrting a sub qury in FROM clause must give an alias to returned table
WHERE total_sales IS NOT NULL;




