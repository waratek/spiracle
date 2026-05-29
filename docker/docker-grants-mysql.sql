-- Docker-only: grant remote access for the 'test' user created by setupdb_mysql.sql.
-- setupdb_mysql.sql creates 'test'@'localhost'; that cannot connect from the app container.
-- This file runs AFTER setupdb_mysql.sql (lexicographic order ensures 0-prefix runs first).
CREATE USER IF NOT EXISTS 'test'@'%' IDENTIFIED BY 'test';
GRANT ALL PRIVILEGES ON *.* TO 'test'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
