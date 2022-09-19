-- insert row
USE sql_store;
INSERT INTO customers
VALUES (
	DEFAULT,
    'John',
    'Smith',
    '1990-01-01',
    DEFAULT,
    'addresss',
    'city test',
    'CA',
    250
);
-- or we can specify columns
INSERT INTO customers (
	first_name,
    last_name,
    birth_date,
    address,
    city,
    state,
    points
)
VALUES (
    'Moataz',
    'Bahaa',
    '2001-06-20',
    'egypt-abou-qorqas',
    'minia',
    'MI',
    2500
);


-- insert multiple rows
INSERT INTO shippers(name)
VALUES ('shipper_1'), ('shipper_2'), ('shipper_3');

INSERT INTO products(
	name,
    quantity_in_stock,
    unit_price
)
VALUES
	('name_1', 4, 3.43),
	('name_2', 2, 2.5),
	('name_3', 3, 2.35);


-- insert hierarchial data 
INSERT INTO orders(
	customer_id,
    order_date,
    shipper_id
)
VALUES (1, '2001-01-02', 1);

INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 1, 2, 2.95);


-- creating a copy of a table
CREATE TABLE orders_archived AS 
SELECT * FROM orders;

INSERT INTO orders_archived
SELECT *
FROM orders
WHERE order_date < '2019-01-01';

USE sql_invoicing;

CREATE TABLE invocing_archived AS
SELECT
	invoice_id,
    number,
    c.name AS client,
    i.payment_date
FROM invoices AS i
JOIN clients AS c
	USING (client_id)
WHERE payment_date IS NOT NULL;


-- updating a single row
UPDATE invoices
SET payment_total = 105, payment_date = '2020-01-03'
WHERE invoice_id = 1;

UPDATE invoices
SET payment_total = DEFAULT, payment_date = NULL
WHERE invoice_id = 1;

UPDATE invoices
SET
	payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE invoice_id = 3;

-- update multiple rows
USE sql_invoicing;

-- to do this disable safe update on mysql workbench
UPDATE invoices
SET
	payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE client_id = 3; -- update all recored for clien_id 3 (not invoice number 3)


USE sql_store;

-- add 50 extra points for every customer born before 1990
UPDATE customers
SET points = points + 50
WHERE birth_date < '1990-01-01';


-- using subqueries in updates
USE sql_invoicing;

UPDATE invoices
SET
	payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE client_id = (
	SELECT client_id
	FROM clients
	WHERE name = 'Myworks'
);


UPDATE invoices
SET
	payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE client_id IN (
	SELECT client_id
	FROM clients
	WHERE state IN ('CA', 'NY')
);


USE sql_store;

UPDATE orders
SET
	comments = 'Gold Customer'
WHERE customer_id IN (
	SELECT customer_id
	FROM customers
    WHERE points > 3000
);


-- delete rows
DELETE FROM invoices
WHERE invoice_id = 1;


