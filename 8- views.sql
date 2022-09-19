-- views

CREATE VIEW sales_by_client AS
SELECT
	c.client_id,
    c.name,
    SUM(invoice_total) AS total_sales
FROM clients AS c
JOIN invoices AS i
	USING(client_id)
GROUP BY client_id, name;

SELECT *
FROM sales_by_client
ORDER BY total_sales DESC;

CREATE VIEW clients_balance AS
SELECT
	c.client_id,
    name,
    SUM(invoice_total - payment_total) AS balance
FROM clients AS c
JOIN invoices AS i
	USING(client_id)
GROUP BY client_id, name;

-- to update views drop it then create it again
DROP VIEW sales_by_client;

-- or
CREATE OR REPLACE VIEW sales_by_client AS
SELECT
	c.client_id,
    c.name,
    SUM(invoice_total) AS total_sales
FROM clients AS c
JOIN invoices AS i
	USING(client_id)
GROUP BY client_id, name;

-- best practice to save views in sql files and put them in source code


-- we can update / insert / delete in views only if views doesn't have
-- DISTINCT
-- Aggregate functions MAX, MIN ..
-- GROUP BY / HAVING
-- UNION

-- this is an updateble view
CREATE OR REPLACE VIEW invoices_with_balance AS
SELECT
	invoice_id,
    number,
    client_id,
    invoice_total,
    payment_total,
    invoice_total - payment_total AS balance,
    invoice_date,
    due_date,
    payment_date
FROM invoices
WHERE (invoice_total - payment_total > 0)
WITH CHECK OPTION;
-- WITH CHECK OPTION: will give an error when trying to update a row and
-- this update will lead to delete that row

DELETE FROM invoices_with_balance
WHERE invoice_id = 4;

UPDATE invoices_with_balance
SET due_date = DATE_ADD(due_date, INTERVAL 2 DAY)
WHERE invoice_id = 2;

-- note this query will lead to deleting the record (deafult behavior)
-- because wehen we created the view we set this conditions
-- WHERE (invoice_total - payment_total > 0);
UPDATE invoices_with_balance
SET payment_total = invoice_total
WHERE invoice_id = 7;
-- this will thorw an error because WITH CHECK OPTION prevent update that lead to exclude row

-- by default when update through a view the modified rows may no longer be included in the view
-- to prevent this use WITH CHECK OPTION 
-- so if you tried to modife a row in such a way this row will no longer be included in the view
-- you will get an error
