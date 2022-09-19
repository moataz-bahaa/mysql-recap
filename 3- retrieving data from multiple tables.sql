USE sql_store;

-- JOIN
SELECT order_id, first_name, o.customer_id, last_name
FROM orders AS o
JOIN customers AS c
	ON o.customer_id = c.customer_id;
    

SELECT order_id, name, quantity, p.unit_price
FROM order_items AS oi
JOIN products AS p
	ON oi.product_id = p.product_id;
    

-- JOIN accros databases

SELECT *
FROM order_items AS oi -- order_items in the current used database
JOIN sql_inventory.products AS p
	ON oi.product_id = p.product_id;

USE sql_hr;
SELECT 
    e.first_name,
    e.employee_id,
    m.first_name AS manager_first_name
FROM employees AS e
JOIN employees AS m
    ON e.reports_to = m.employee_id;


-- JOIN more than 2 tables

USE sql_store;
SELECT
	o.order_id,
    o.order_date,
    c.first_name,
    os.name As 'status name'
FROM orders AS o
JOIN customers AS c
	ON o.customer_id = c.customer_id
JOIN order_statuses AS os
	ON o.status = os.order_status_id;


USE sql_invoicing;
SELECT
	p.payment_id,
    p.date,
    p.amount,
	c.name AS client_name,
    pm.name AS payment_method_name
FROM payments AS p
JOIN payment_methods AS pm
	ON p.payment_method = pm.payment_method_id
JOIN clients AS c
	ON p.client_id = c.client_id;

-- 5.compound joind conditions
USE sql_store;
SELECT *
FROM order_items AS oi
JOIN order_item_notes AS oin
	ON oi.order_id = oin.order_id
    AND oi.product_id = oin.product_id;



SELECT *
FROM orders AS o
JOIN customers AS c
	ON o.customer_id = c.customer_id;
    
-- implicit join syntax (bad behavoir)
SELECT *
FROM orders AS o, customers AS c
	WHERE o.customer_id = c.customer_id;
    
-- outer join (LEFT or RIGHT)
-- INNER JOUN is default
SELECT
	c.customer_id,
    c.first_name,
    o.order_id
FROM orders AS o
RIGHT JOIN customers AS c -- OUTER keyword is optional => LEFT OUTER JOIN
	ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

SELECT
	p.product_id,
    p.name,
    oi.quantity
FROM products AS p
LEFT JOIN order_items AS oi
	ON p.product_id = oi.product_id;

-- outer join between multiple tables
SELECT 
	c.customer_id,
    c.first_name,
    o.order_id,
    sh.name AS shipper_name
FROM customers AS c
LEFT JOIN orders AS o
	ON c.customer_id = o.customer_id
LEFT JOIN shippers AS sh
	ON sh.shipper_id = o.shipper_id
ORDER BY c.customer_id;

-- best practice avoid RIGHT JOIN and use LEFT JOIN to avoid confusing

SELECT
	o.order_date,
    o.order_id,
    c.first_name AS customer,
    sh.name AS shipper_name,
    os.name
FROM orders AS o
JOIN customers AS c
	ON o.customer_id = c.customer_id
LEFT JOIN shippers AS sh
	ON o.shipper_id = sh.shipper_id
JOIN order_statuses AS os
	ON o.status = os.order_status_id
ORDER BY o.order_id;


-- self OUTER JOIN
USE sql_hr;
SELECT
	em.first_name AS employee_name,
    m.first_name AS manager_name
FROM employees AS em
LEFT JOIN employees AS m
	ON em.reports_to = m.employee_id;

-- USEING clause to join columns with exact the same name
USE sql_store;
SELECT
	o.order_id,
    c.first_name,
    sh.name AS shipper
FROM orders AS o
JOIN customers AS c
	USING (customer_id) -- ON c.customer_id = o.customer_d
LEFT JOIN shippers AS sh
	USING (shipper_id);
    
SELECT *
FROM order_items oi
JOIN order_item_notes oin
	USING (product_id, order_id);
	-- ON oin.product_id = oi.product_id
    -- AND oin.order_id = oi.order_id;

USE sql_invoicing;
SELECT
	p.date,
    c.name AS client,
    p.amount,
    pm.name AS payment_method
FROM payments AS p
JOIN clients AS c
	USING (client_id)
JOIN payment_methods AS pm
	ON p.payment_method = pm.payment_method_id;


-- natural joins: databse engine guess the joind (not best practice)
USE sql_store;

SELECT
	o.order_id,
    c.first_name
FROM orders AS o
NATURAL JOIN customers AS c;

-- cross joins
SELECT
	c.first_name AS customer,
    p.name AS product
FROM customers AS c -- implicit syntax: FROM customer AS c, products AS p
CROSS JOIN products AS p -- explict syntax
ORDER BY c.first_name;
-- this joins every record in customer table with every record in products table

-- implicit syntax for cross join
SELECT
	sh.name AS shipper,
    p.name AS product
FROM shippers AS sh, products AS p;

-- explicit syntax
SELECT 
	sh.name AS shipper,
    p.name AS product
FROM shippers AS sh
CROSS JOIN products AS p;

-- join for compine columns from multiple tables
-- union for compine rows from multiple tables
-- UNION

SELECT
	order_id,
    order_date,
    'Active' AS status
FROM orders
WHERE order_date >= '2019-01-01'
UNION
SELECT
	order_id,
    order_date,
    'paused' AS status
FROM orders
WHERE order_date < '2019-01-01';


SELECT
	first_name
FROM customers
UNION
SELECT
	name
FROM shippers;


SELECT
	customer_id,
    first_name,
    points,
    'Bronze' AS type
FROM customers
WHERE points < 2000
UNION
SELECT
	customer_id,
    first_name,
    points,
    'Silver'
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT
	customer_id,
    first_name,
    points,
    'Gold'
FROM customers
WHERE points > 300
ORDER BY customer_id;
