-- data types

-- string data types:-
-- CHAR(x) -> fixed length
-- VARCHAR(x) -> max x = 65535 character(~64KB)
-- MEDIUMTEXT -> max 16MB
-- LONGTEXT -> 4GB
-- TINYTEXT -> max 255 byte
-- TEXT -> max 64KB

-- english letter = 1 byte
-- european letter = 2 byte
-- asian letter = 3 byte


-- integer types:-
-- TINYINT -> 1B [-128, 127]
-- UNSIGNED TINYINT [0, 255]
-- SMALLINT 2b [-32k, 32k]
-- MEDIUMINT 3b [-8M, 8M]
-- INT 4b [-2b, 2b]
-- BIGINT 8b [-9Z, 9Z]


-- rations numbers
-- DECIMAL(p, s) 
DECIMAL(9, 2) -- 1234567.89

-- DEC = NUMBERIC = FIXED = DECIMAL

-- for caculations
-- they don't store the actual value but they use an approxmeation
-- FLOAT -> 4b
-- DOUBLE -> 8b


-- boolean type
-- BOOLEAN, BOOL
-- TRUE = 1, FALSE = 0


-- enum
-- ENUM('small', 'medium', 'large')


-- date and time
-- DATE
-- TIME
-- DATETIME
-- TIMESTAMP
-- YEAR

-- blobs
-- bad practive to store file in database
-- TINYBLOB 255b
-- BLOB  65KB
-- MEDIUMBLOB 16MB
-- LONGBLOB 4GB


-- JSON TYPE
UPDATE products
SET properties = '
{
	"dimentions": [1, 2, 3],
    "weight": 10,
    "manufacturer": {
		"name": "sony"
    }
}
'
WHERE product_id = 1;

-- another way
UPDATE products
SET properties = JSON_OBJECT(
	'weight', 10,
    'dimentions', JSON_ARRAY(1, 2, 3),
    'manufacturer', JSON_OBJECT('name', 'sony')
)
WHERE product_id = 1;

SELECT 
	product_id,
    JSON_EXTRACT(properties, '$.dimentions') AS dimentions
FROM products;


SELECT 
	product_id,
    properties -> '$.dimentions' AS dimentions
FROM products;

SELECT 
	product_id,
    properties -> '$.dimentions[1]' AS dimentions
FROM products;


SELECT 
	product_id,
    properties -> '$.manufacturer.name' AS manufacturer
FROM products;

SELECT 
	product_id,
    properties ->> '$.manufacturer.name' AS manufacturer
    -- ->> to get rid of double qutoes "sony" => sony
FROM products;


-- update json
UPDATE products
SET properties = JSON_SET(
	properties,
    '$.weight', 20,
    '$.age', 21
)
WHERE product_id = 1;

UPDATE products
SET properties = JSON_REMOVE(
	properties,
    '$.age'
)
WHERE product_id = 1;

SELECT
	product_id,
    properties
FROM products
WHERE product_id = 1;
