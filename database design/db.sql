CREATE DATABASE IF NOT EXISTS sql_store2;

DROP DATABASE IF EXISTS sql_store2;

USE sql_store2;

DROP TABLE IF EXISTS customers;

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    points INT NOT NULL DEFAULT 0,
    email VARCHAR(255) NOT NULL UNIQUE
);
# CHARACTER SET latin1 -- to change character set

# editing an existing table
ALTER TABLE customers
    ADD last_name VARCHAR(50) NOT NULL AFTER first_name,
    ADD city VARCHAR(50) NOT NULL,
    MODIFY COLUMN first_name VARCHAR(255) DEFAULT '',
    DROP points;

DROP TABLE IF EXISTS orders;

CREATE TABLE IF NOT EXISTS orders(
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    FOREIGN KEY fk_orders_customers (customer_id)
        REFERENCES customers(customer_id)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);


# adding relationships after creating a table

ALTER TABLE orders
    ADD PRIMARY KEY (order_id),
    DROP PRIMARY KEY,
    DROP FOREIGN KEY orders_ibfk_1,
    ADD FOREIGN KEY fk_orders_customers(customer_id)
        REFERENCES customers(customer_id)
        ON UPDATE CASCADE
        ON DELETE NO ACTION;


# character sets and collations

SHOW CHARACTER SET;

# change character set

CREATE DATABASE db_name
    CHARACTER SET latin1;

ALTER DATABASE sql_store2
    CHARACTER SET latin1;

ALTER TABLE customers
    CHARACTER SET utf8;


# storage engines
# to determine how the data is stored and what features is available for us

SHOW ENGINES;
# most used(MyISAM, InnoDB)
# storage engines is for table level

ALTER TABLE customers
    ENGINE = InnoDB;

