-- transaction: a group of SQL statements that represent a single unit of work

START TRANSACTION;

INSERT INTO orders(customer_id, order_date, status)
VALUES (1, '2020-01-01', 1);

INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 1, 1, 1);

COMMIT;
-- ROLLBACK;

-- concurrency
USE sql_store;

SHOW VARIABLES LIKE 'transaction_isolation';

-- isolation level
-- default(REPETABLE READ) -> solved lost updates, dirty read and non-repating reads
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- concurrency levels:-
-- READ UNCOMMITED
-- READ COMMITTED
-- REPEATABLE READ(default)
-- SERIALIZABLE (transactions are excuted sequenctial - it solves all concurrency problems but it's very slow)

-- this only applies to next transaction
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; -- the bad one

-- deadlocks: 2 transaction locks each other
 
