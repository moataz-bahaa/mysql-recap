
# indexing for high performance

USE sql_store;

SELECT * FROM customers;

# cost of indexing
# 1- increase the database
# 2- slow down the writes(insert / update)

# design indexes based on your queries not your tables

EXPLAIN SELECT customer_id FROM customers WHERE state = 'CA';

SELECT COUNT(*) FROM customers;

CREATE INDEX idx_state ON customers(state);


# write a query to find customers with more than 1000 points

SELECT customer_id FROM customers WHERE points > 1000; -- checks all rows(1010)

EXPLAIN SELECT customer_id FROM customers WHERE points > 1000; -- checks all row

CREATE INDEX idx_points ON customers(points);

SELECT customer_id FROM customers WHERE points > 1000; -- checks 528 record

# show indexes of a table
SHOW INDEXES IN customers;

ANALYZE TABLE customers;

SHOW INDEXES IN orders;

# prefix indexes
CREATE INDEX idx_lastname ON customers(last_name(20)); -- include only 20 first characters

SELECT LEFT(last_name, 1) FROM customers;
SELECT
    COUNT(DISTINCT LEFT(last_name, 1)),
    COUNT(DISTINCT LEFT(last_name, 5)), -- optimal prefix length
    COUNT(DISTINCT LEFT(last_name, 10))
FROM customers;


# full-text index
# for building fast search engines
USE sql_blog;

SELECT * FROM posts;

# finding postes related to react redux
SELECT *
FROM posts
WHERE title LIKE '%react redux%' OR
      body LIKE '%react redux%';

CREATE FULLTEXT INDEX idx_title_body ON posts(title, body);

SELECT
    *,
    MATCH(title, body) AGAINST('react redux') AS relevent_score
FROM posts
WHERE MATCH(title, body) AGAINST('react redux');

SELECT
    *,
    MATCH(title, body) AGAINST('react redux') AS relevent_score
FROM posts
WHERE MATCH(title, body) AGAINST('react -redux' IN BOOLEAN MODE ); -- having react but not redux

SELECT
    *,
    MATCH(title, body) AGAINST('react redux') AS relevent_score
FROM posts
WHERE MATCH(title, body) AGAINST('react -redux +form' IN BOOLEAN MODE ); -- must have word form in either the title or the body


SELECT
    *,
    MATCH(title, body) AGAINST('react redux') AS relevent_score
FROM posts
WHERE MATCH(title, body) AGAINST('"handling a form"' IN BOOLEAN MODE ); -- searching for specific word

# composite indexes

USE sql_store;

SHOW INDEXES IN customers;

EXPLAIN SELECT
    customer_id
FROM customers
# USE INDEX() -- to force mysql to use specific index
WHERE state = 'CA' AND points > 1000;

CREATE INDEX idx_state_points ON customers(state, points);

DROP INDEX idx_state ON customers;

DROP INDEX idx_points ON customers;

SHOW INDEXES IN customers;

# put indexes on
# 1- frequently used columns
# 2- high cardinality columns first (take your qureis into account)


# when indexes are ignored

SELECT
    customer_id
FROM customers
WHERE state='CA' OR points > 1000;

# better statement with indexes
CREATE INDEX idx_points ON customers(points);
EXPLAIN SELECT
    customer_id
FROM customers
WHERE state='CA'
UNION
SELECT
    customer_id
FROM customers
WHERE points > 1000;

# this query scans all rows
EXPLAIN SELECT customer_id FROM customers
WHERE points + 10 > 2010;

# better one
EXPLAIN SELECT customer_id FROM customers
WHERE points > 2000;

# using indexes for sorting data

SHOW INDEXES IN customers;

EXPLAIN SELECT customer_id FROM customers ORDER BY state;
EXPLAIN SELECT customer_id FROM customers ORDER BY first_name;

SHOW STATUS LIKE 'last_query_cost';

# if we have an index in (a, b)
# we can sort by
# a
# a, b
# a DESC, b DESC
# we can't put column in the middle lice a, c, b

# note: we can olny pick columns stored in the index (id added by mysql, columns you add when creating the index)
# other wise it will not use the index


EXPLAIN SELECT customer_id, state FROM customers ORDER BY state; -- uses index
EXPLAIN SELECT * FROM customers ORDER BY state; -- doesn't use index

# avoid to much indexes
# avoid duplicate indexes and redundant indexes

# before creating a new index check the existing ones