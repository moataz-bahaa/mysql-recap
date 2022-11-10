
# creating a new user
CREATE USER moataz@127.0.0.0; -- (ip/host/domain) is optional

CREATE USER moataz1@localhost;
CREATE USER moataz2@codewithmosh.com;
CREATE USER moataz3@'%.codewithmosh.com'; -- % for including subdomains


CREATE USER john IDENTIFIED BY '1234';

# viewing users
SELECT * FROM mysql.user;

# droping a user
CREATE USER bob@codewithmosh.com IDENTIFIED BY '1234';

DROP USER bob@codewithmosh.com;

# changing password

SET PASSWORD FOR john = '1234';

SET PASSWORD = '1234'; -- current user

# privileges
# 1- web/desktop application
CREATE USER moon_app IDENTIFIED BY '1234';

GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE
ON sql_store.*
TO moon_app;

# 2- admin
# GRANT ALL ON sql_store.*
GRANT ALL
ON *.* -- all tables on all databases
TO john;

# viewing privileges
SHOW GRANTS FOR john;
SHOW GRANTS FOR moon_app;

SHOW GRANTS; -- current user (root)

# revoking privileges
GRANT CREATE VIEW
ON sql_store.*
TO moon_app;

SHOW GRANTS FOR moon_app;

REVOKE CREATE VIEW
ON sql_store.*
FROM moon_app;