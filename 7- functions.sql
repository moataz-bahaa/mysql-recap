-- essential mysql functions
-- ROUND(number, number of digits after decmical point)
SELECT ROUND(5.7243543);
SELECT ROUND(5.3243543);
SELECT ROUND(5.3243543, 1);
SELECT ROUND(5.3243543, 4);

-- TRUNCATE
SELECT TRUNCATE(5.7345, 1); -- keep 1 digts after decimal point
SELECT TRUNCATE(5.7345, 2); -- keep 2 digts after decimal point
SELECT TRUNCATE(5.7345, 3); -- keep 3 digts after decimal point
SELECT TRUNCATE(5.7345, 4); -- keep 4 digts after decimal point

-- CEILING(number)
-- return smallest integer that greater than or equal to number
SELECT CEILING(4.63);
SELECT CEILING(5.2);

-- FLOOR(number)
-- return largest integer smaller than or equal to number
SELECT FLOOR(4.99);

-- ABS(number) => return abs of number
SELECT ABS(-235);
SELECT ABS(235);


-- RAND()
-- generate random number between 0 and 1
SELECT RAND();


-- strig functions
-- LENGTH(string) => return length of string
SELECT LENGTH('Hello');

SELECT UPPER('sky');
SELECT LOWER('SKY');

SELECT LTRIM('     SKY'); -- remoe spaces from left
SELECT RTRIM('SKY     '); -- remoe spaces from right
SELECT TRIM('   SKY    '); -- remove any spaces from left and right
SELECT LEFT('Hello World', 3); -- return first 3 characters from left Hel
SELECT RIGHT('Hello World', 3); -- return first 3 characters from right rld

-- SUBSTRING(string, start, number)
-- return substring from start(1 based) positon until
SELECT SUBSTRING('Hello World', 2, 4); -- count 4 characters starting from postion 2 
SELECT SUBSTRING('Hello World', 2); -- return substring from postion 2 to the end of string
 
-- LOCATE(search_string, string) => return first occurance of search_string in string
SELECT LOCATE('wor', 'hello world');
-- if character doesn't exsit return 0
SELECT LOCATE('q', 'hello world'); -- 0

-- replace sql with mysql
SELECT REPLACE('hello sql', 'sql', 'mysql');

SELECT CONCAT('first', 'second');

USE sql_store;
SELECT
	CONCAT(first_name, ' ', last_name) AS full_name
FROM customers;

-- date and time functions
SELECT NOW(); -- return current date and time
SELECT CURDATE(); -- return current date
SELECT CURTIME(); -- return current time
SELECT YEAR(NOW());
SELECT MONTH(NOW());
SELECT DAY(NOW());
SELECT HOUR(NOW());
SELECT MINUTE(NOW());
SELECT SECOND(NOW());
SELECT DAYNAME(NOW()); -- return name of current date
SELECT MONTHNAME(NOW());
SELECT EXTRACT(DAY FROM NOW());
SELECT EXTRACT(YEAR FROM NOW());
SELECT EXTRACT(HOUR FROM NOW());

-- select orders of current year
SELECT *
FROM orders
WHERE order_date >= DATE(NOW());

-- formating date and time
-- %y => 2 digit year
-- %Y => r digits year
-- %m => 2 digit month
-- %M => month name in english
SELECT DATE_FORMAT(NOW(), '%m %d %y');
SELECT DATE_FORMAT(NOW(), '%M %D %Y');


SELECT TIME_FORMAT(NOW(), '%h:%I %p');


-- caculating date and time
SELECT DATE_ADD(NOW(), INTERVAL 1 DAY); -- return tomorrow date with same time
SELECT DATE_ADD(NOW(), INTERVAL 1 YEAR); -- next year
SELECT DATE_ADD(NOW(), INTERVAL -1 YEAR); -- last year

SELECT DATE_SUB(NOW(), INTERVAL 1 YEAR);

-- caculate difference between 2 dates in days
SELECT DATEDIFF('2019-01-05', '2019-01-01');

-- caculate difference between 2 times
SELECT TIME_TO_SEC('09:00');
SELECT TIME_TO_SEC('09:00') - TIME_TO_SEC('09:02');



USE sql_store;
SELECT
	order_id,
    IFNULL(shipper_id, 'Not assigned') AS shipper -- if shipper_id is NULL return not assigned
FROM orders;

SELECT
	order_id,
    COALESCE(shipper_id, comments, 'not assigned') AS shipper
FROM orders;
-- if shipper_id IS NULL return comments
-- 		if comments IS NULL return 'not assigned' 
-- to recap COALESCE() => return the first none null value in the list

SELECT
	CONCAT(first_name, ' ', last_name) AS customer,
    IFNULL(phone, 'Unknown') AS phone
FROM customers;

SELECT
	order_id,
    order_date,
    IF (
		YEAR(order_date) = YEAR(NOW()),
        'Active',
        'archived'
    ) AS category
FROM orders;


SELECT
	p.product_id,
    p.name,
	COUNT(*) AS orders,
    IF (
		COUNT(*) > 1,
        'many times',
        'once'
    ) AS frequncy
FROM order_items AS oi
JOIN products AS p
	USING(product_id)
GROUP BY product_id, name;


-- CASE operator

SELECT
	order_id,
    CASE
		WHEN YEAR(order_date) = YEAR(NOW()) THEN 'Active'
        WHEN YEAR(order_date) = YEAR(NOW()) - 1 THEN 'Last Year'
        WHEN YEAR(order_date) < YEAR(NOW()) - 1 THEN 'Archived'
        ELSE 'Future'
	END AS category
FROM orders;


SELECT
	CONCAT(first_name, ' ', last_name) AS customer,
    points,
    'Gold' AS category
FROM customers
WHERE points > 3000
UNION
SELECT
	CONCAT(first_name, ' ', last_name),
    points,
    'Silver' AS category
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT
	CONCAT(first_name, ' ', last_name),
    points,
    'Bronze'
FROM customers
WHERE points < 2000
ORDER BY customer;

-- let's write the above query using CASE operator
SELECT
	CONCAT(first_name, ' ', last_name)
    points,
    CASE
		WHEN points > 3000 THEN 'Gold'
        WHEN points BETWEEN 2000 AND 3000 THEN 'Silver'
        ELSE 'Bronze'
	END AS category
FROM customers;
