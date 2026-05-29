#!/bin/bash
# Docker-only init script for MySQL.
# The canonical setupdb_mysql.sql has bare DROP TABLE (no IF EXISTS) which
# errors on a fresh DB. Run it with --force to skip those errors.
set -e

mysql --force -u root -p"${MYSQL_ROOT_PASSWORD}" < /init/setupdb_mysql.sql

# Grant remote access for 'test'@'%' so the app container (different host)
# can connect. The canonical seed only creates 'test'@'localhost'.
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<'SQL'
CREATE USER IF NOT EXISTS 'test'@'%' IDENTIFIED WITH mysql_native_password BY 'test';
GRANT ALL PRIVILEGES ON *.* TO 'test'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
SQL
