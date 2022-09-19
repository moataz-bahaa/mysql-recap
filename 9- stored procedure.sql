-- stored procedures

USE sql_invoicing;

DELIMITER $$
CREATE PROCEDURE get_clients()
BEGIN
  SELECT * FROM clients;
END$$
DELIMITER ;

CALL get_clients();

DELIMITER $$
CREATE PROCEDURE get_invoices_with_balance()
BEGIN
  SELECT *
  FROM invoices_with_balance -- this is a view
  WHERE balance > 0;
END$$
DELIMITER ;


-- droping a procedure
DROP PROCEDURE IF EXISTS get_clients;

DELIMITER $$
CREATE PROCEDURE get_clients_by_state(
  state CHAR(2)
)
BEGIN
  SELECT *
  FROM clients AS c
  WHERE c.state = state;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS get_invoices_by_client;

DELIMITER $$
CREATE PROCEDURE get_invoices_by_client(
  client_id INT
)
BEGIN
  SELECT *
  FROM invoices AS i
  WHERE i.client_id = client_id;
END$$
DELIMITER ;

-- for calling
CALL get_invoices_by_client(5);

-- using default parameters
DROP PROCEDURE IF EXISTS get_clients_by_state;
DELIMITER $$
CREATE PROCEDURE get_clients_by_state(
  state CHAR(2)
)
BEGIN
  IF state IS NULL THEN
    SET state = 'CA';
  END IF;
  SELECT *
  FROM clients AS c
  WHERE c.state = state;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS get_clients_by_state;
DELIMITER $$
CREATE PROCEDURE get_clients_by_state(
  state CHAR(2)
)
BEGIN
  IF state IS NULL THEN
    SELECT * FROM clients;
  ELSE
    SELECT *
    FROM clients AS c
    WHERE c.state = state;
  END IF;
END$$
DELIMITER ;


-- a better way
DROP PROCEDURE IF EXISTS get_clients_by_state;
DELIMITER $$
CREATE PROCEDURE get_clients_by_state(
  state CHAR(2)
)
BEGIN
  SELECT *
  FROM clients AS c
  WHERE c.state = IFNULL(state, c.state);
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS get_payments;
DELIMITER $$
CREATE PROCEDURE get_payments(
  client_id INT,
  payment_method_id TINYINT
)
BEGIN
  SELECT *
  FROM payments AS p
  WHERE
    p.client_id = IFNULL(client_id, p.client_id) AND
    p.payment_method = IFNULL(payment_method_id, p.payment_method);

END$$
DELIMITER ;

-- using procedure for updating
-- validating parameters
DROP PROCEDURE IF EXISTS make_payment;

DELIMITER $$
CREATE PROCEDURE make_payment(
  invoice_id INT,
  payment_amount DECIMAL(9, 2), -- DECIMAL(total number of digits, number of digits after decimal points)
  payment_date DATE
)
BEGIN 
  IF payment_amount <= 0 THEN
    SIGNAL SQLSTATE '22003' -- Error code, like throw an error in programming
      SET MESSAGE_TEXT = 'Invalid payment amount';
  END IF;
  UPDATE invoices AS i
  SET
    i.payment_total = payment_amount,
    i.payment_date = payment_date
  WHERE
    i.invoice_id = invoice_id;
END $$
DELIMITER ;


-- output parameters
DROP PROCEDURE IF EXISTS get_unpaid_invoices_for_client;

DELIMITER $$
CREATE PROCEDURE get_unpaid_invoices_for_client(
  client_id INT,
  OUT invoices_count INT, -- output parameters to get values out of this procedrue
  OUT invoice_total DECIMAL(9, 2) -- output parameters to get values out of this procedrue
)
BEGIN
  SELECT
    COUNT(*),
    SUM(invoice_total)
  INTO invoices_count, invoice_total
  FROM invoices AS i
  WHERE
    i.client_id = client_id AND payment_total = 0;
END $$
DELIMITER ;

-- to call the above procedure
set @invoices_count = 0; -- declaring a variable
set @invoice_total = 0;
call sql_invoicing.get_unpaid_invoices_for_client(3, @invoices_count, @invoice_total);
select @invoices_count, @invoice_total;


-- User or session variables
set @invoices_count = 0;

-- Local variables
-- risk_factor = invoice_total / invoices_count * 5
DROP PROCEDURE IF EXISTS get_risk_factor;
DELIMITER $$
CREATE PROCEDURE get_risk_factor()
BEGIN
  DECLARE risk_factor DECIMAL(9, 2) DEFAULT 0;
  DECLARE invoices_total DECIMAL(9, 2);
  DECLARE invoices_count INT;

  SELECT
    SUM(invoice_total),
    COUNT(*)
  FROM invoices
  INTO invoices_total, invoices_count;

  SET risk_factor = invoices_total / invoices_count * 5;
  SELECT risk_factor;
END$$
DELIMITER ;


-- functions => using to calculate a single value

DROP FUNCTION IF EXISTS get_risk_factor_for_client;

DELIMITER $$
CREATE FUNCTION get_risk_factor_for_client(
  client_id INT
)
RETURNS INTEGER
-- attributes
READS SQL DATA
BEGIN
  DECLARE risk_factor DECIMAL(9, 2) DEFAULT 0;
  DECLARE invoices_total DECIMAL(9, 2);
  DECLARE invoices_count INT;

  SELECT
    SUM(invoice_total),
    COUNT(*)
  FROM invoices AS i
  WHERE i.client_id = client_id
  INTO invoices_total, invoices_count;

  SET risk_factor = invoices_total / invoices_count * 5;
  RETURN IFNULL(risk_factor, 0)
END$$
DELIMITER ;

-- calling function
SELECT
  client_id,
  name,
  get_risk_factor_for_client(client_id) AS risk_factor
FROM clients;